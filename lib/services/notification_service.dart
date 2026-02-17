import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final GetStorage _box = GetStorage();

  // Notification settings - Original
  final RxBool dailyReminderEnabled = true.obs;
  final RxBool streakAlertEnabled = true.obs;
  final RxBool achievementAlertEnabled = true.obs;
  final RxBool weeklyReportEnabled = true.obs;
  final Rx<TimeOfDay> dailyReminderTime = const TimeOfDay(hour: 10, minute: 0).obs;
  final RxBool exactAlarmPermissionGranted = false.obs;

  // Additional notification settings for notification settings page
  final RxBool newContentEnabled = true.obs;
  final RxBool practiceReminderEnabled = false.obs;
  final RxBool appUpdatesEnabled = true.obs;
  final RxBool specialOffersEnabled = false.obs;
  final RxBool parentTipsEnabled = true.obs;

  Future<NotificationService> init() async {
    try {
      tz_data.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      await _loadSettings();

      // Request exact alarm permission on Android 12+
      if (Platform.isAndroid) {
        await _requestExactAlarmPermission();
      }

      // Only schedule if we have permission or on iOS
      if (exactAlarmPermissionGranted.value || Platform.isIOS) {
        await _scheduleDailyReminder();
      }
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }

    return this;
  }

  // Request exact alarm permission for Android 12+
  Future<void> _requestExactAlarmPermission() async {
    try {
      final android = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        // Check if notification permission was already granted (saved in storage)
        final notificationPermissionGranted = _box.read<bool>('notification_permission_granted') ?? false;

        if (!notificationPermissionGranted) {
          // Request notification permission only if not already granted
          final granted = await android.requestNotificationsPermission();
          if (granted == true) {
            await _box.write('notification_permission_granted', true);
          }
        }

        // Check exact alarm permission status
        final exactAlarmGranted = await android.requestExactAlarmsPermission();
        exactAlarmPermissionGranted.value = exactAlarmGranted ?? false;
      }
    } catch (e) {
      debugPrint('Failed to request exact alarm permission: $e');
      exactAlarmPermissionGranted.value = false;
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate based on payload
      switch (payload) {
        case 'daily_practice':
          Get.toNamed('/HomePage');
          break;
        case 'streak_alert':
          Get.toNamed('/DailyGoalsPage');
          break;
        case 'achievement':
          Get.toNamed('/RewardsPage');
          break;
      }
    }
  }

  Future<void> _loadSettings() async {
    dailyReminderEnabled.value = _box.read<bool>('notif_daily_reminder') ?? true;
    streakAlertEnabled.value = _box.read<bool>('notif_streak_alert') ?? true;
    achievementAlertEnabled.value = _box.read<bool>('notif_achievement') ?? true;
    weeklyReportEnabled.value = _box.read<bool>('notif_weekly_report') ?? true;

    // Load additional settings
    newContentEnabled.value = _box.read<bool>('notif_new_content') ?? true;
    practiceReminderEnabled.value = _box.read<bool>('notif_practice_reminder') ?? false;
    appUpdatesEnabled.value = _box.read<bool>('notif_app_updates') ?? true;
    specialOffersEnabled.value = _box.read<bool>('notif_special_offers') ?? false;
    parentTipsEnabled.value = _box.read<bool>('notif_parent_tips') ?? true;

    final savedHour = _box.read<int>('notif_reminder_hour');
    final savedMinute = _box.read<int>('notif_reminder_minute');
    if (savedHour != null && savedMinute != null) {
      dailyReminderTime.value = TimeOfDay(hour: savedHour, minute: savedMinute);
    }
  }

  Future<void> _saveSettings() async {
    await _box.write('notif_daily_reminder', dailyReminderEnabled.value);
    await _box.write('notif_streak_alert', streakAlertEnabled.value);
    await _box.write('notif_achievement', achievementAlertEnabled.value);
    await _box.write('notif_weekly_report', weeklyReportEnabled.value);
    await _box.write('notif_reminder_hour', dailyReminderTime.value.hour);
    await _box.write('notif_reminder_minute', dailyReminderTime.value.minute);

    // Save additional settings
    await _box.write('notif_new_content', newContentEnabled.value);
    await _box.write('notif_practice_reminder', practiceReminderEnabled.value);
    await _box.write('notif_app_updates', appUpdatesEnabled.value);
    await _box.write('notif_special_offers', specialOffersEnabled.value);
    await _box.write('notif_parent_tips', parentTipsEnabled.value);
  }

  // Request permission
  Future<bool> requestPermission() async {
    // Check if already granted
    final alreadyGranted = _box.read<bool>('notification_permission_granted') ?? false;
    if (alreadyGranted) {
      return true;
    }

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      if (granted == true) {
        await _box.write('notification_permission_granted', true);
      }
      return granted ?? false;
    }
    return true;
  }

  // Schedule daily reminder
  Future<void> _scheduleDailyReminder() async {
    try {
      if (!dailyReminderEnabled.value) {
        await _notifications.cancel(1);
        return;
      }

      // Check if we have exact alarm permission on Android
      if (Platform.isAndroid && !exactAlarmPermissionGranted.value) {
        debugPrint('Skipping scheduled notification - no exact alarm permission');
        return;
      }

      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        dailyReminderTime.value.hour,
        dailyReminderTime.value.minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        1,
        '🎓 Time to Learn!',
        'Your daily learning adventure awaits! Let\'s practice today.',
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder',
            'Daily Reminder',
            channelDescription: 'Daily learning reminders',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFF6366F1),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_practice',
      );
    } catch (e) {
      debugPrint('Failed to schedule daily reminder: $e');
    }
  }

  // Show streak reminder
  Future<void> showStreakReminder(int currentStreak) async {
    if (!streakAlertEnabled.value) return;

    await _notifications.show(
      2,
      '🔥 Keep Your Streak Alive!',
      'You have a $currentStreak day streak! Don\'t break it - practice today.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_alert',
          'Streak Alerts',
          channelDescription: 'Streak reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFEF4444),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'streak_alert',
    );
  }

  // Show achievement notification
  Future<void> showAchievementNotification(String title, String description) async {
    if (!achievementAlertEnabled.value) return;

    await _notifications.show(
      3,
      '🏆 $title',
      description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'achievements',
          'Achievements',
          channelDescription: 'Achievement notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFF59E0B),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'achievement',
    );
  }

  // Show coins earned notification
  Future<void> showCoinsEarnedNotification(int coins, String reason) async {
    await _notifications.show(
      4,
      '💰 You earned $coins coins!',
      reason,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'coins',
          'Coins',
          channelDescription: 'Coin notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF10B981),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
    );
  }

  // Show custom notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'general',
          'General',
          channelDescription: 'General notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // Schedule streak break warning (evening reminder)
  Future<void> scheduleStreakBreakWarning(int currentStreak) async {
    try {
      if (!streakAlertEnabled.value || currentStreak < 2) return;

      // Check if we have exact alarm permission on Android
      if (Platform.isAndroid && !exactAlarmPermissionGranted.value) {
        debugPrint('Skipping streak warning - no exact alarm permission');
        return;
      }

      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, 20, 0); // 8 PM

      if (scheduledDate.isBefore(now)) {
        return; // Don't schedule if already past 8 PM
      }

      await _notifications.zonedSchedule(
        5,
        '⚠️ Don\'t Lose Your $currentStreak Day Streak!',
        'You haven\'t practiced today. Just a few minutes to keep your streak!',
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'streak_warning',
            'Streak Warnings',
            channelDescription: 'Streak break warnings',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFFEF4444),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'streak_alert',
      );
    } catch (e) {
      debugPrint('Failed to schedule streak warning: $e');
    }
  }

  // Cancel streak warning (called when user practices)
  Future<void> cancelStreakWarning() async {
    await _notifications.cancel(5);
  }

  // Update settings
  Future<void> setDailyReminderEnabled(bool enabled) async {
    dailyReminderEnabled.value = enabled;
    await _saveSettings();
    await _scheduleDailyReminder();
  }

  Future<void> setStreakAlertEnabled(bool enabled) async {
    streakAlertEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setAchievementAlertEnabled(bool enabled) async {
    achievementAlertEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setWeeklyReportEnabled(bool enabled) async {
    weeklyReportEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setDailyReminderTime(TimeOfDay time) async {
    dailyReminderTime.value = time;
    await _saveSettings();
    await _scheduleDailyReminder();
  }

  // Additional settings setters
  Future<void> setNewContentEnabled(bool enabled) async {
    newContentEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setPracticeReminderEnabled(bool enabled) async {
    practiceReminderEnabled.value = enabled;
    await _saveSettings();
    if (enabled) {
      await _schedulePracticeReminder();
    } else {
      await _notifications.cancel(6);
    }
  }

  Future<void> setAppUpdatesEnabled(bool enabled) async {
    appUpdatesEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setSpecialOffersEnabled(bool enabled) async {
    specialOffersEnabled.value = enabled;
    await _saveSettings();
  }

  Future<void> setParentTipsEnabled(bool enabled) async {
    parentTipsEnabled.value = enabled;
    await _saveSettings();
  }

  // Schedule practice reminder (afternoon)
  Future<void> _schedulePracticeReminder() async {
    try {
      if (!practiceReminderEnabled.value) {
        await _notifications.cancel(6);
        return;
      }

      if (Platform.isAndroid && !exactAlarmPermissionGranted.value) {
        debugPrint('Skipping practice reminder - no exact alarm permission');
        return;
      }

      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, 16, 0); // 4 PM

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        6,
        '📚 Practice Time!',
        'Time for some quick practice. Keep learning!',
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'practice_reminder',
            'Practice Reminder',
            channelDescription: 'Practice reminders',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFFA78BFA),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'practice_reminder',
      );
    } catch (e) {
      debugPrint('Failed to schedule practice reminder: $e');
    }
  }

  // Show new content notification
  Future<void> showNewContentNotification(String contentName) async {
    if (!newContentEnabled.value) return;

    await _notifications.show(
      7,
      '🆕 New Content Available!',
      '$contentName has been added. Check it out!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'new_content',
          'New Content',
          channelDescription: 'New content notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF4ECDC4),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'new_content',
    );
  }

  // Show app update notification
  Future<void> showAppUpdateNotification(String version) async {
    if (!appUpdatesEnabled.value) return;

    await _notifications.show(
      8,
      '🔄 App Update Available',
      'Version $version is now available. Update for new features!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'app_updates',
          'App Updates',
          channelDescription: 'App update notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF45B7D1),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'app_update',
    );
  }

  // Show special offer notification
  Future<void> showSpecialOfferNotification(String offer) async {
    if (!specialOffersEnabled.value) return;

    await _notifications.show(
      9,
      '🎁 Special Offer!',
      offer,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'special_offers',
          'Special Offers',
          channelDescription: 'Special offer notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFFF6B6B),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'special_offer',
    );
  }

  // Show parent tips notification
  Future<void> showParentTipsNotification(String tip) async {
    if (!parentTipsEnabled.value) return;

    await _notifications.show(
      10,
      '💡 Parent Tip',
      tip,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'parent_tips',
          'Parent Tips',
          channelDescription: 'Tips for parents',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFEC407A),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'parent_tip',
    );
  }

  // Show weekly progress notification
  Future<void> showWeeklyProgressNotification(int lessonsCompleted, int totalMinutes) async {
    if (!weeklyReportEnabled.value) return;

    await _notifications.show(
      11,
      '📊 Weekly Progress Report',
      'You completed $lessonsCompleted lessons and spent $totalMinutes minutes learning this week!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_progress',
          'Weekly Progress',
          channelDescription: 'Weekly progress reports',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF56D97F),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'weekly_progress',
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
