import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime time;
  final bool isRead;
  final IconData icon;
  final List<Color> gradient;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
    required this.icon,
    required this.gradient,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'time': time.toIso8601String(),
    'isRead': isRead,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'general';
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: type,
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
      icon: _getIconForType(type),
      gradient: _getGradientForType(type),
    );
  }

  static IconData _getIconForType(String type) {
    switch (type) {
      case 'achievement':
        return Icons.emoji_events_rounded;
      case 'reminder':
        return Icons.alarm_rounded;
      case 'progress':
        return Icons.trending_up_rounded;
      case 'new_content':
        return Icons.new_releases_rounded;
      case 'streak':
        return Icons.local_fire_department_rounded;
      case 'reward':
        return Icons.card_giftcard_rounded;
      case 'tip':
        return Icons.lightbulb_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  static List<Color> _getGradientForType(String type) {
    switch (type) {
      case 'achievement':
        return [const Color(0xFFFFAA5A), const Color(0xFFFFCB80)];
      case 'reminder':
        return [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)];
      case 'progress':
        return [const Color(0xFF56D97F), const Color(0xFF7BE495)];
      case 'new_content':
        return [const Color(0xFF4ECDC4), const Color(0xFF44A08D)];
      case 'streak':
        return [const Color(0xFFFF6B6B), const Color(0xFFFFAA5A)];
      case 'reward':
        return [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)];
      case 'tip':
        return [const Color(0xFF45B7D1), const Color(0xFF7DD3E8)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }
}

class NotificationListController extends GetxController {
  final GetStorage _box = GetStorage();
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;

    // Load saved notifications from storage
    final savedNotifications = _box.read<List>('notifications') ?? [];

    if (savedNotifications.isEmpty) {
      // Add some default/demo notifications for new users
      _addDefaultNotifications();
    } else {
      notifications.value = savedNotifications
          .map((e) => NotificationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // Sort by time (newest first)
    notifications.sort((a, b) => b.time.compareTo(a.time));
    isLoading.value = false;
  }

  void _addDefaultNotifications() {
    final now = DateTime.now();
    notifications.value = [
      NotificationItem(
        id: '1',
        title: 'Welcome to Jiyan Learning! 🎉',
        message:
            'Start your learning journey today. Explore Numbers, Alphabets, and more!',
        type: 'general',
        time: now,
        icon: Icons.celebration_rounded,
        gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      ),
      NotificationItem(
        id: '2',
        title: 'Daily Practice Reminder ⏰',
        message:
            'Don\'t forget to practice today! Just 10 minutes can make a big difference.',
        type: 'reminder',
        time: now.subtract(const Duration(hours: 2)),
        icon: Icons.alarm_rounded,
        gradient: [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      ),
      NotificationItem(
        id: '3',
        title: 'New Content Available! ✨',
        message: 'Check out new Shapes and Vehicles learning sets!',
        type: 'new_content',
        time: now.subtract(const Duration(hours: 5)),
        icon: Icons.new_releases_rounded,
        gradient: [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      ),
      NotificationItem(
        id: '4',
        title: 'Keep Your Streak! 🔥',
        message: 'You\'re on a 3-day learning streak. Keep it going!',
        type: 'streak',
        time: now.subtract(const Duration(days: 1)),
        icon: Icons.local_fire_department_rounded,
        gradient: [const Color(0xFFFF6B6B), const Color(0xFFFFAA5A)],
      ),
      NotificationItem(
        id: '5',
        title: 'Tip for Parents 💡',
        message:
            'Encourage your child to learn for 15-20 minutes daily for best results.',
        type: 'tip',
        time: now.subtract(const Duration(days: 2)),
        icon: Icons.lightbulb_rounded,
        gradient: [const Color(0xFF45B7D1), const Color(0xFF7DD3E8)],
      ),
    ];
    _saveNotifications();
  }

  void _saveNotifications() {
    final data = notifications.map((e) => e.toJson()).toList();
    _box.write('notifications', data);
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final item = notifications[index];
      notifications[index] = NotificationItem(
        id: item.id,
        title: item.title,
        message: item.message,
        type: item.type,
        time: item.time,
        isRead: true,
        icon: item.icon,
        gradient: item.gradient,
      );
      _saveNotifications();
    }
  }

  void markAllAsRead() {
    notifications.value = notifications.map((item) {
      return NotificationItem(
        id: item.id,
        title: item.title,
        message: item.message,
        type: item.type,
        time: item.time,
        isRead: true,
        icon: item.icon,
        gradient: item.gradient,
      );
    }).toList();
    _saveNotifications();
    Get.snackbar(
      'Done',
      'All notifications marked as read',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16.r),
    );
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    _saveNotifications();
  }

  void clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Clear All?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to clear all notifications?',
          style: GoogleFonts.nunito(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              notifications.clear();
              _saveNotifications();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Clear All',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  String getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({Key? key}) : super(key: key);

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage>
    with TickerProviderStateMixin {
  final NotificationListController controller = Get.put(
    NotificationListController(),
  );

  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

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
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top =
              startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // Floating bubbles background
            ..._buildFloatingBubbles(),
            // Main content
            SafeArea(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (controller.notifications.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildNotificationList();
              }),
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
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20.r,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x40FF6B6B),
              blurRadius: 15.r,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      title: FittedBox(
        // The title is a Row of separately styled words, so it cannot
        // ellipsize; scaling it down keeps the whole title readable on a
        // narrow phone instead of clipping the last word.
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifi',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
            Text(
              'cations',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFE66D),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        Obx(
          () => controller.notifications.isNotEmpty
              ? PopupMenuButton<String>(
                  icon: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  onSelected: (value) {
                    if (value == 'read_all') {
                      controller.markAllAsRead();
                    } else if (value == 'clear_all') {
                      controller.clearAllNotifications();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'read_all',
                      child: Row(
                        children: [
                          Icon(
                            Icons.done_all_rounded,
                            color: Colors.green,
                            size: 20.r,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Mark all as read',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_sweep_rounded,
                            color: Colors.red,
                            size: 20.r,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Clear all',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: child,
              );
            },
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                size: 60.r,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Notifications',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'You\'re all caught up! Check back later for updates.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                index.isEven ? _floatAnimation.value : -_floatAnimation.value,
              ),
              child: child,
            );
          },
          child: _buildNotificationTile(notification),
        );
      },
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: AppTheme.spacingS),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(Icons.delete_rounded, color: Colors.white, size: 28.r),
      ),
      onDismissed: (_) => controller.deleteNotification(notification.id),
      child: GestureDetector(
        onTap: () => controller.markAsRead(notification.id),
        child: Container(
          margin: EdgeInsets.only(bottom: AppTheme.spacingS),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: notification.isRead
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : notification.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color:
                    (notification.isRead
                            ? Colors.grey
                            : notification.gradient[0])
                        .withValues(alpha: 0.4),
                blurRadius: 12.r,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(AppTheme.spacingM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        notification.icon,
                        color: Colors.white,
                        size: 26.r,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingM),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            notification.message,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14.r,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                controller.getTimeAgo(notification.time),
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white24,
                          blurRadius: 4.r,
                          spreadRadius: 2.r,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
