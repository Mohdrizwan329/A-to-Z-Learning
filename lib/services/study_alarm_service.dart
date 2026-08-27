import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// One study alarm the child (or their parent) set.
class StudyAlarm {
  StudyAlarm({
    required this.id,
    required this.hour,
    required this.minute,
    required this.label,
    required this.days,
    this.enabled = true,
  });

  /// Stable id. Notification ids are derived from it, so it must not be
  /// reused while an alarm is still scheduled.
  final int id;
  final int hour;
  final int minute;
  final String label;

  /// Weekdays this alarm rings on, `DateTime.monday`..`DateTime.sunday`.
  /// Empty means every day.
  final Set<int> days;

  final bool enabled;

  bool get isDaily => days.isEmpty || days.length == 7;

  StudyAlarm copyWith({
    int? hour,
    int? minute,
    String? label,
    Set<int>? days,
    bool? enabled,
  }) =>
      StudyAlarm(
        id: id,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        label: label ?? this.label,
        days: days ?? this.days,
        enabled: enabled ?? this.enabled,
      );

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  Map<String, dynamic> toJson() => {
        'id': id,
        'hour': hour,
        'minute': minute,
        'label': label,
        'days': days.toList()..sort(),
        'enabled': enabled,
      };

  static StudyAlarm fromJson(Map<String, dynamic> data) => StudyAlarm(
        id: (data['id'] as num).toInt(),
        hour: (data['hour'] as num?)?.toInt() ?? 8,
        minute: (data['minute'] as num?)?.toInt() ?? 0,
        label: (data['label'] ?? 'Study time').toString(),
        days: ((data['days'] as List?) ?? const [])
            .map((d) => (d as num).toInt())
            .where((d) => d >= DateTime.monday && d <= DateTime.sunday)
            .toSet(),
        enabled: data['enabled'] as bool? ?? true,
      );
}

/// Study alarms that ring on their own, with the app closed.
///
/// Each alarm is handed to the OS as a scheduled notification, so the ringing
/// does not depend on this app running -- Android keeps it in AlarmManager and
/// iOS in its own notification queue. The list itself is stored, and rebooting
/// the phone re-arms it (see the boot receiver in AndroidManifest.xml).
///
/// The one thing no app can do is ring while the phone is switched off; those
/// alarms are re-armed on the next boot instead.
class StudyAlarmService extends GetxService {
  StudyAlarmService({FlutterLocalNotificationsPlugin? plugin, GetStorage? box})
      : _notifications = plugin ?? FlutterLocalNotificationsPlugin(),
        _box = box ?? GetStorage();

  final FlutterLocalNotificationsPlugin _notifications;
  final GetStorage _box;

  static const String _storageKey = 'study_alarms';

  /// Notification ids live in a band of their own so they cannot collide with
  /// the handful of fixed ids NotificationService uses.
  static const int _idBase = 900000;

  /// Every alarm, soonest first.
  final RxList<StudyAlarm> alarms = <StudyAlarm>[].obs;

  /// Whether the OS will actually let an alarm through. False here is why an
  /// alarm would stay silent, so the screen says so.
  final RxBool permissionGranted = true.obs;

  /// The timezone database has to be loaded before `tz.local` can be read.
  /// Done on demand as well as in [init], because the alarm screen can put
  /// this service itself, without going through init.
  static bool _timeZonesReady = false;

  static void _ensureTimeZones() {
    if (_timeZonesReady) return;
    tz_data.initializeTimeZones();
    _timeZonesReady = true;
  }

  Future<StudyAlarmService> init() async {
    try {
      _ensureTimeZones();
      _load();
      // Re-arm on every launch: cheap, and it heals anything the OS dropped.
      await rescheduleAll();
    } catch (e) {
      debugPrint('StudyAlarmService init error: $e');
    }
    return this;
  }

  // ---------------------------------------------------------------- storage

  void _load() {
    final raw = _box.read<String>(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = (jsonDecode(raw) as List)
          .whereType<Map<String, dynamic>>()
          .map(StudyAlarm.fromJson)
          .toList();
      alarms.assignAll(_sorted(list));
    } catch (e) {
      debugPrint('Could not read stored alarms: $e');
    }
  }

  Future<void> _save() async {
    await _box.write(
      _storageKey,
      jsonEncode(alarms.map((a) => a.toJson()).toList()),
    );
  }

  List<StudyAlarm> _sorted(List<StudyAlarm> list) {
    final copy = [...list];
    copy.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    return copy;
  }

  // ------------------------------------------------------------------- crud

  /// Next free id. Ids are never reused from the live list, so a cancelled
  /// notification cannot be matched to a new alarm.
  int get _nextId {
    var id = 1;
    final taken = alarms.map((a) => a.id).toSet();
    while (taken.contains(id)) {
      id++;
    }
    return id;
  }

  Future<StudyAlarm> add({
    required TimeOfDay time,
    required String label,
    Set<int> days = const {},
  }) async {
    final alarm = StudyAlarm(
      id: _nextId,
      hour: time.hour,
      minute: time.minute,
      label: label.trim().isEmpty ? 'Study time' : label.trim(),
      days: {...days},
    );
    alarms.assignAll(_sorted([...alarms, alarm]));
    await _save();
    await _schedule(alarm);
    return alarm;
  }

  Future<void> update(StudyAlarm alarm) async {
    final index = alarms.indexWhere((a) => a.id == alarm.id);
    if (index < 0) return;
    await _cancel(alarms[index]);
    final next = [...alarms]..[index] = alarm;
    alarms.assignAll(_sorted(next));
    await _save();
    await _schedule(alarm);
  }

  Future<void> toggle(StudyAlarm alarm, bool enabled) =>
      update(alarm.copyWith(enabled: enabled));

  Future<void> remove(StudyAlarm alarm) async {
    await _cancel(alarm);
    alarms.removeWhere((a) => a.id == alarm.id);
    await _save();
  }

  // -------------------------------------------------------------- scheduling

  /// Ids used by one alarm: one per weekday it rings on, or a single id when
  /// it rings every day.
  List<int> _notificationIds(StudyAlarm alarm) {
    if (alarm.isDaily) return [_idBase + alarm.id * 10];
    return alarm.days.map((d) => _idBase + alarm.id * 10 + d).toList();
  }

  Future<void> rescheduleAll() async {
    for (final alarm in alarms) {
      await _cancel(alarm);
      await _schedule(alarm);
    }
  }

  Future<void> _cancel(StudyAlarm alarm) async {
    for (final id in [
      // Cancel the whole band this alarm could have used, not just the ids it
      // uses now -- its weekdays may have just changed.
      _idBase + alarm.id * 10,
      for (var d = DateTime.monday; d <= DateTime.sunday; d++)
        _idBase + alarm.id * 10 + d,
    ]) {
      try {
        await _notifications.cancel(id);
      } catch (e) {
        debugPrint('Could not cancel alarm notification $id: $e');
      }
    }
  }

  Future<void> _schedule(StudyAlarm alarm) async {
    if (!alarm.enabled) return;

    try {
      _ensureTimeZones();
    } catch (e) {
      // Without a timezone database nothing can be scheduled, but the alarm
      // is already saved -- it re-arms on the next launch.
      debugPrint('Timezone data unavailable, alarm ${alarm.id} not armed: $e');
      permissionGranted.value = false;
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'study_alarm',
        'Study Alarms',
        channelDescription: 'Rings at the study times you set',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        // Rings and lights the screen the way a clock app does, rather than
        // arriving as a quiet line in the shade.
        fullScreenIntent: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFF45B7D1),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );

    try {
      if (alarm.isDaily) {
        await _zonedSchedule(
          id: _notificationIds(alarm).first,
          alarm: alarm,
          when: _nextOccurrence(alarm.hour, alarm.minute),
          details: details,
          repeat: DateTimeComponents.time,
        );
        return;
      }

      for (final day in alarm.days) {
        await _zonedSchedule(
          id: _idBase + alarm.id * 10 + day,
          alarm: alarm,
          when: _nextOccurrence(alarm.hour, alarm.minute, weekday: day),
          details: details,
          repeat: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    } catch (e) {
      // Saving the alarm must not fail just because the OS refused to arm it.
      debugPrint('Could not arm alarm ${alarm.id}: $e');
      permissionGranted.value = false;
    }
  }

  Future<void> _zonedSchedule({
    required int id,
    required StudyAlarm alarm,
    required tz.TZDateTime when,
    required NotificationDetails details,
    required DateTimeComponents repeat,
  }) async {
    try {
      await _notifications.zonedSchedule(
        id,
        '⏰ ${alarm.label}',
        'Time to study! Tap to open Jiyan Learning.',
        when,
        details,
        // The strongest mode there is: it survives Doze and battery saver,
        // which an inexact alarm does not.
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: repeat,
        payload: 'study_alarm',
      );
      permissionGranted.value = true;
    } catch (e) {
      // Android throws here when exact alarms are not permitted.
      debugPrint('Could not schedule alarm $id: $e');
      permissionGranted.value = false;
    }
  }

  /// The next time this clock time comes round, in the device's own zone.
  static tz.TZDateTime _nextOccurrence(int hour, int minute, {int? weekday}) {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!when.isAfter(now)) {
      when = when.add(const Duration(days: 1));
    }
    if (weekday != null) {
      while (when.weekday != weekday) {
        when = when.add(const Duration(days: 1));
      }
    }
    return when;
  }

  // ------------------------------------------------------------- permissions

  /// Asks for what an alarm needs: the right to post a notification, and on
  /// Android 12+ the right to fire at an exact time.
  Future<bool> requestPermissions() async {
    var granted = true;
    try {
      if (Platform.isAndroid) {
        final android = _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (android != null) {
          granted = await android.requestNotificationsPermission() ?? granted;
          granted = await android.requestExactAlarmsPermission() ?? granted;
        }
      } else if (Platform.isIOS) {
        final ios = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        granted = await ios?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            granted;
      }
    } catch (e) {
      debugPrint('Alarm permission request failed: $e');
      granted = false;
    }
    permissionGranted.value = granted;
    return granted;
  }

  /// "Mon, Wed, Fri", or "Every day".
  static String daysLabel(StudyAlarm alarm) {
    if (alarm.isDaily) return 'Every day';
    const names = {
      DateTime.monday: 'Mon',
      DateTime.tuesday: 'Tue',
      DateTime.wednesday: 'Wed',
      DateTime.thursday: 'Thu',
      DateTime.friday: 'Fri',
      DateTime.saturday: 'Sat',
      DateTime.sunday: 'Sun',
    };
    final sorted = alarm.days.toList()..sort();
    return sorted.map((d) => names[d]).join(', ');
  }
}
