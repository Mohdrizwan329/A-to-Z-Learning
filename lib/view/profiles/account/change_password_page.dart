import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with TickerProviderStateMixin {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AuthController _authController;
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

    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController(), permanent: true);
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Security Icon Section with Animation
                    AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value * 0.5),
                          child: child,
                        );
                      },
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667EEA),
                                    Color(0xFF764BA2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 15.r,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.lock_outline_rounded,
                                  size: 48.r,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: AppTheme.spacingM),
                            Text(
                              'Create a strong password',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingL),

                    // Form Fields
                    // Current Password
                    _buildFieldLabel('Current Password', Icons.lock_outline),
                    SizedBox(height: AppTheme.spacingS),
                    _buildPasswordField(
                      controller: _currentPasswordController,
                      hint: 'Enter current password',
                      obscureText: _obscureCurrentPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    SizedBox(height: AppTheme.spacingM),

                    // New Password
                    _buildFieldLabel('New Password', Icons.lock_reset_rounded),
                    SizedBox(height: AppTheme.spacingS),
                    _buildPasswordField(
                      controller: _newPasswordController,
                      hint: 'Enter new password',
                      obscureText: _obscureNewPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    SizedBox(height: AppTheme.spacingM),

                    // Confirm New Password
                    _buildFieldLabel(
                      'Confirm New Password',
                      Icons.check_circle_outline_rounded,
                    ),
                    SizedBox(height: AppTheme.spacingS),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      hint: 'Confirm new password',
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    SizedBox(height: AppTheme.spacingXL),

                    // Update Button
                    _buildUpdateButton(),
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
      title: Text(
        'Change Password',
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

  Widget _buildFieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: Colors.white, size: 18.r),
        ),
        SizedBox(width: AppTheme.spacingS),
        // Takes the width left beside the icon so a long field name wraps
        // instead of running off the form.
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 2.r,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.white,
        cursorWidth: 2.5,
        cursorHeight: 20,
        style: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          suffixIcon: GestureDetector(
            onTap: onToggleVisibility,
            child: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.white.withValues(alpha: 0.7),
              size: 20.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleUpdatePassword,
      child: Container(
        width: double.infinity,
        height: AppTheme.buttonHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
              blurRadius: 16.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5.r,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: Colors.white,
                      size: 22.r,
                    ),
                    SizedBox(width: AppTheme.spacingS),
                    Flexible(
                      child: Text(
                        'Update Password',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _handleUpdatePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
        borderRadius: 16.r,
        margin: EdgeInsets.all(16.r),
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
        borderRadius: 16.r,
        margin: EdgeInsets.all(16.r),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
        borderRadius: 16.r,
        margin: EdgeInsets.all(16.r),
      );
      return;
    }

    // Check if user is logged in
    if (!_authController.isLoggedIn) {
      Get.snackbar(
        'Error',
        'Please login to change password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
        borderRadius: 16.r,
        margin: EdgeInsets.all(16.r),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authController.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Password updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4ECDC4),
          colorText: Colors.white,
          borderRadius: 16.r,
          margin: EdgeInsets.all(16.r),
        );
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          _authController.errorMessage.value.isNotEmpty
              ? _authController.errorMessage.value
              : 'Failed to change password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF6B6B),
          colorText: Colors.white,
          borderRadius: 16.r,
          margin: EdgeInsets.all(16.r),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
        borderRadius: 16.r,
        margin: EdgeInsets.all(16.r),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
