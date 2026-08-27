import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/view/profiles/account/account_settings_page.dart';
import 'package:jiyan_learning/view/profiles/help/help_page.dart';
import 'package:jiyan_learning/view/profiles/policy/privacy_policy_page.dart';
import 'package:jiyan_learning/view/profiles/terms%20&%20condition/terms_conditions_page.dart';
import 'package:jiyan_learning/view/profiles/support/support_page.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';
import 'package:jiyan_learning/services/user_profile_service.dart';
import 'package:jiyan_learning/utils/responsive.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.appVersion,
    this.location,
    this.onSavedAddresses,
    this.onPrivacyPolicy,
    this.onTerms,
    this.onSupport,
  });

  final String name;
  final String email;
  final String appVersion;
  final String? location;

  final VoidCallback? onSavedAddresses;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTerms;
  final VoidCallback? onSupport;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
          // Kid-friendly rainbow gradient background - same as Home
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
                    // Profile Card
                    _buildProfileCard(),
                    SizedBox(height: AppTheme.spacingS),
                    // Section Title
                    Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingS),
                    // Profile Options
                    _ProfileTile(
                      title: 'Account',
                      icon: Icons.person_outline_rounded,
                      gradient: const [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                      onTap: () => Get.to(() => AccountSettingsScreen()),
                      index: 0,
                      floatAnimation: _floatAnimation,
                    ),
                    SizedBox(height: AppTheme.spacingXS),
                    // Legal Section Title
                    Text(
                      'Legal & Support',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingS),
                    _ProfileTile(
                      title: 'Privacy Policy',
                      icon: Icons.privacy_tip_outlined,
                      gradient: const [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
                      onTap: () => Get.to(() => PrivacyPolicyScreen()),
                      index: 1,
                      floatAnimation: _floatAnimation,
                    ),
                    _ProfileTile(
                      title: 'Terms & Conditions',
                      icon: Icons.description_outlined,
                      gradient: const [Color(0xFF56D97F), Color(0xFF81E89E)],
                      onTap: () => Get.to(() => TermsConditionsScreen()),
                      index: 2,
                      floatAnimation: _floatAnimation,
                    ),
                    _ProfileTile(
                      title: 'Support',
                      icon: Icons.support_agent_rounded,
                      gradient: const [Color(0xFF45B7D1), Color(0xFF74C9DB)],
                      onTap: () => Get.to(() => const SupportScreen()),
                      index: 3,
                      floatAnimation: _floatAnimation,
                    ),
                    _ProfileTile(
                      title: 'Help',
                      icon: Icons.help_outline_rounded,
                      gradient: const [Color(0xFFEC407A), Color(0xFFF06292)],
                      onTap: () => Get.to(() => HelpScreen()),
                      index: 4,
                      floatAnimation: _floatAnimation,
                    ),
                    SizedBox(height: AppTheme.spacingM),
                    // Logout Button
                    _buildLogoutButton(),
                    SizedBox(height: AppTheme.spacingM),
                    // App Version
                    Center(
                      child: Text(
                        'Version ${widget.appVersion}',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
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
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          // Vibrant kid-friendly gradient - same as Home
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
        'Profile',
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

  UserProfileService? get _profileService =>
      Get.isRegistered<UserProfileService>()
          ? Get.find<UserProfileService>()
          : null;

  Widget _buildProfileCard() {
    final profile = _profileService;
    if (profile == null) {
      return _buildProfileCardBody(
        widget.name,
        widget.email,
        widget.location ?? 'Location not set',
        _photoOf(null),
      );
    }

    return Obx(
      () => _buildProfileCardBody(
        UserProfileService.resolveField(widget.name, profile.name.value, 'Guest User'),
        UserProfileService.resolveField(widget.email, profile.email.value, 'Guest'),
        UserProfileService.resolveField(
          widget.location ?? '',
          profile.location.value,
          'Location not set',
        ),
        _photoOf(profile),
      ),
    );
  }

  /// The picture to show: the file saved on this device, otherwise whatever
  /// the account carries -- inline bytes from a signup, or a Google account's
  /// hosted picture. A fresh install has only the account copy until the next
  /// save puts a file back on the device.
  ImageProvider? _photoOf(UserProfileService? profile) {
    final file = profile?.photoFile;
    if (file != null) return FileImage(file);

    final controller = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : null;
    // Read through the observable so this rebuilds when the account record
    // lands, which on a cold start is after the first frame.
    final user = controller?.userModelRx.value;

    final inline = user?.photoBase64?.trim() ?? '';
    if (inline.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(inline));
      } catch (_) {
        // Not readable as an image; fall through to the initial.
      }
    }

    final hosted = user?.photoUrl?.trim() ?? '';
    if (hosted.isNotEmpty) return NetworkImage(hosted);

    return null;
  }

  Widget _buildAvatarInitial(String name) {
    final trimmed = name.trim();
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        trimmed.isNotEmpty ? trimmed[0].toUpperCase() : 'U',
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppTheme.accentColor,
        ),
      ),
    );
  }

  Widget _buildProfileCardBody(
    String name,
    String email,
    String location,
    ImageProvider? photo,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS + AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withValues(alpha: 0.4),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10.r,
                ),
              ],
            ),
            child: ClipOval(
              child: SizedBox(
                width: 64.w,
                height: 64.h,
                child: photo != null
                    ? Image(
                        image: photo,
                        fit: BoxFit.cover,
                        // A file can vanish between the existsSync() check and
                        // the decode, and a hosted picture can fail to load,
                        // so fall back rather than show a broken-image box.
                        errorBuilder: (context, error, stackTrace) =>
                            _buildAvatarInitial(name),
                      )
                    : _buildAvatarInitial(name),
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacingM),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppTheme.spacingXS),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 14.r,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    SizedBox(width: AppTheme.spacingXS),
                    Expanded(
                      child: Text(
                        email,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingXS),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.r,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    SizedBox(width: AppTheme.spacingXS),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () async {
        AuthController authController;
        if (Get.isRegistered<AuthController>()) {
          authController = Get.find<AuthController>();
        } else {
          authController = Get.put(AuthController(), permanent: true);
        }
        if (authController.isLoggedIn) {
          await authController.signOut();
          // The device copy belongs to the account that just left -- the photo
          // especially, since no account ever held it -- so it goes with them.
          await _profileService?.clear();
          Get.offAllNamed('/login');
        } else {
          Get.offAllNamed('/login');
        }
      },
      child: Container(
        width: double.infinity,
        height: AppTheme.buttonHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppTheme.errorColor.withValues(alpha: 0.4),
              blurRadius: 16.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.white, size: 22.r),
              SizedBox(width: AppTheme.spacingS),
              Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final int index;
  final Animation<double> floatAnimation;

  const _ProfileTile({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.index,
    required this.floatAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        final offset = (index % 2 == 0)
            ? floatAnimation.value * 0.5
            : -floatAnimation.value * 0.5;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppTheme.spacingS),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS + AppTheme.spacingXS,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22.r),
                  ),
                  SizedBox(width: AppTheme.spacingS + AppTheme.spacingXS),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.r,
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
}
