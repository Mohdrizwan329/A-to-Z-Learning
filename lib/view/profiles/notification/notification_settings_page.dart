import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with TickerProviderStateMixin {
  late NotificationService _notificationService;
  late AnimationController _bubbleController;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Floating bubbles for playful effect - same as home page
  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Get NotificationService instance
    if (Get.isRegistered<NotificationService>()) {
      _notificationService = Get.find<NotificationService>();
    } else {
      _notificationService = Get.put(NotificationService());
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  // Notification settings with keys mapped to service
  List<Map<String, dynamic>> get _notificationSettings => [
    {
      'key': 'daily_reminder',
      'title': 'Daily Learning Reminder',
      'subtitle': 'Get daily reminders to learn',
      'icon': Icons.alarm_rounded,
      'gradient': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
    },
    {
      'key': 'new_content',
      'title': 'New Content Added',
      'subtitle': 'Know when new lessons arrive',
      'icon': Icons.new_releases_rounded,
      'gradient': [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
    },
    {
      'key': 'achievement',
      'title': 'Achievement Unlocked',
      'subtitle': 'Celebrate your victories',
      'icon': Icons.emoji_events_rounded,
      'gradient': [const Color(0xFFFFAA5A), const Color(0xFFFFCB80)],
    },
    {
      'key': 'weekly_progress',
      'title': 'Weekly Progress Report',
      'subtitle': 'Track your weekly progress',
      'icon': Icons.bar_chart_rounded,
      'gradient': [const Color(0xFF56D97F), const Color(0xFF7BE495)],
    },
    {
      'key': 'practice_reminder',
      'title': 'Practice Reminder',
      'subtitle': 'Never miss practice time',
      'icon': Icons.schedule_rounded,
      'gradient': [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)],
    },
    {
      'key': 'app_updates',
      'title': 'App Updates',
      'subtitle': 'Stay updated with new features',
      'icon': Icons.system_update_rounded,
      'gradient': [const Color(0xFF45B7D1), const Color(0xFF7DD3E8)],
    },
    {
      'key': 'parent_tips',
      'title': 'Parent Tips',
      'subtitle': 'Helpful tips for parents',
      'icon': Icons.tips_and_updates_rounded,
      'gradient': [const Color(0xFFEC407A), const Color(0xFFF48FB1)],
    },
  ];

  // Get current value for a notification setting
  bool _getNotificationValue(String key) {
    switch (key) {
      case 'daily_reminder':
        return _notificationService.dailyReminderEnabled.value;
      case 'new_content':
        return _notificationService.newContentEnabled.value;
      case 'achievement':
        return _notificationService.achievementAlertEnabled.value;
      case 'weekly_progress':
        return _notificationService.weeklyReportEnabled.value;
      case 'practice_reminder':
        return _notificationService.practiceReminderEnabled.value;
      case 'app_updates':
        return _notificationService.appUpdatesEnabled.value;
      case 'special_offers':
        return _notificationService.specialOffersEnabled.value;
      case 'parent_tips':
        return _notificationService.parentTipsEnabled.value;
      default:
        return false;
    }
  }

  // Toggle notification setting
  Future<void> _toggleNotification(String key, bool value) async {
    switch (key) {
      case 'daily_reminder':
        await _notificationService.setDailyReminderEnabled(value);
        break;
      case 'new_content':
        await _notificationService.setNewContentEnabled(value);
        break;
      case 'achievement':
        await _notificationService.setAchievementAlertEnabled(value);
        break;
      case 'weekly_progress':
        await _notificationService.setWeeklyReportEnabled(value);
        break;
      case 'practice_reminder':
        await _notificationService.setPracticeReminderEnabled(value);
        break;
      case 'app_updates':
        await _notificationService.setAppUpdatesEnabled(value);
        break;
      case 'special_offers':
        await _notificationService.setSpecialOffersEnabled(value);
        break;
      case 'parent_tips':
        await _notificationService.setParentTipsEnabled(value);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating bubbles background
            ..._buildFloatingBubbles(),

            // Main content
            SafeArea(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                itemCount: _notificationSettings.length,
                itemBuilder: (context, index) {
                  final item = _notificationSettings[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: _buildNotificationTileWithObx(item, index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 8,
      shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B6B),
              Color(0xFFFF8E53),
              Color(0xFFFFAA5A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x40FF6B6B),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Text(
        'Notifications',
        style: GoogleFonts.baloo2(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildNotificationTileWithObx(Map<String, dynamic> item, int index) {
    final key = item['key'] as String;
    final gradient = item['gradient'] as List;
    final gradientList = gradient.cast<Color>();

    return Obx(() {
      final isEnabled = _getNotificationValue(key);
      return _buildNotificationTileContent(item, gradientList, isEnabled, key, index);
    });
  }

  Widget _buildNotificationTileContent(
    Map<String, dynamic> item,
    List<Color> gradientList,
    bool isEnabled,
    String key,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        final offset = (index % 2 == 0)
            ? _floatAnimation.value * 0.5
            : -_floatAnimation.value * 0.5;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacingS),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? gradientList
              : [Colors.grey.shade400, Colors.grey.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isEnabled ? gradientList[0] : Colors.grey).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _toggleNotification(key, !isEnabled),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingL,
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item['icon'],
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['subtitle'],
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: (newValue) => _toggleNotification(key, newValue),
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.white.withValues(alpha: 0.4),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
