import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/view/profiles/account/edit_profile_page.dart';
import 'package:jiyan_learning/view/profiles/account/change_password_page.dart';
import 'package:jiyan_learning/view/profiles/notification/notification_settings_page.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen>
    with TickerProviderStateMixin {
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

  final List<Map<String, dynamic>> _settingsItems = [
    {
      'title': 'Edit Profile',
      'subtitle': 'Change your avatar & name',
      'icon': Icons.person_outline_rounded,
      'gradient': [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    },
    {
      'title': 'Change Password',
      'subtitle': 'Keep your account safe',
      'icon': Icons.lock_outline_rounded,
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    },
    {
      'title': 'Notification',
      'subtitle': 'Manage your notifications',
      'icon': Icons.notifications_outlined,
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    },
  ];

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
          // Same gradient as Home screen
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA), // Soft Purple
              Color(0xFF764BA2), // Deep Purple
              Color(0xFFF093FB), // Pink
              Color(0xFFF5576C), // Coral
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Settings Items
                    ..._settingsItems.asMap().entries.map((entry) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(
                          milliseconds: 400 + (entry.key * 100),
                        ),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: _buildSettingTile(entry.value, entry.key),
                            ),
                          );
                        },
                      );
                    }),

                    SizedBox(height: AppTheme.spacingM),
                  ],
                ),
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
          // Same gradient as Home AppBar
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B6B), // Coral Red
              Color(0xFFFF8E53), // Orange
              Color(0xFFFFAA5A), // Light Orange
            ],
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
      title: Text(
        'My Account',
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
      centerTitle: true,
    );
  }

  Widget _buildSettingTile(Map<String, dynamic> item, int index) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        final offset = (index % 2 == 0)
            ? _floatAnimation.value * 0.5
            : -_floatAnimation.value * 0.5;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppTheme.spacingS),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: item['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: (item['gradient'] as List<Color>)[0].withValues(
                alpha: 0.4,
              ),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => _handleTileTap(item['title']),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingL,
              ),
              child: Row(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(item['icon'], color: Colors.white, size: 28.r),
                  ),
                  SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item['subtitle'],
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.r,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTileTap(String title) {
    switch (title) {
      case 'Edit Profile':
        Get.to(() => const EditProfileScreen());
        break;
      case 'Change Password':
        Get.to(() => const ChangePasswordScreen());
        break;
      case 'Notification':
        Get.to(() => NotificationSettingsScreen());
        break;
    }
  }
}
