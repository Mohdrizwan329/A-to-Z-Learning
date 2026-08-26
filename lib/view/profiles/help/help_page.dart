import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/view%20model/setting%20controller/help_controller.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  final HelpController controller = Get.put(HelpController());
  final _formKey = GlobalKey<FormState>();

  late AnimationController _bubbleController;
  late AnimationController _floatController;
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
                  children: [
                    // Header Card
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: _buildHeaderCard(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppTheme.spacingM),

                    // Form Card
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: _buildFormCard(),
                          ),
                        );
                      },
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
        'Help & Support',
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

  Widget _buildHeaderCard() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        final offset = _floatAnimation.value * 0.5;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingL),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 32.r,
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We\'re Here to Help!',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Parents, share your feedback to help us make learning better for your child.',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        final offset = -_floatAnimation.value * 0.5;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA78BFA).withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.message_rounded,
                        color: Colors.white,
                        size: 22.r,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingS),
                    Flexible(
                      child: Text(
                        'Send us a Message',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),

                // Name Field
                _buildFieldLabel('Your Name', Icons.person_outline_rounded),
                SizedBox(height: AppTheme.spacingS),
                _buildTextField(
                  hint: 'Enter your name',
                  initialValue: controller.name.value,
                  onSaved: (v) => controller.name.value = v ?? '',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingM),

                // Phone Field
                _buildFieldLabel('Phone Number', Icons.phone_outlined),
                SizedBox(height: AppTheme.spacingS),
                _buildTextField(
                  hint: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  initialValue: controller.phone.value,
                  onSaved: (v) => controller.phone.value = v ?? '',
                ),
                SizedBox(height: AppTheme.spacingM),

                // Email Field
                _buildFieldLabel('Email Address', Icons.email_outlined),
                SizedBox(height: AppTheme.spacingS),
                _buildTextField(
                  hint: 'Enter email address',
                  keyboardType: TextInputType.emailAddress,
                  initialValue: controller.email.value,
                  onSaved: (v) => controller.email.value = v ?? '',
                  validator: (v) {
                    if (v != null && v.isNotEmpty) {
                      final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
                      if (!emailRegex.hasMatch(v)) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingM),

                // Message Field
                _buildFieldLabel('Your Message', Icons.edit_note_rounded),
                SizedBox(height: AppTheme.spacingS),
                _buildTextField(
                  hint: 'Type your message here...',
                  maxLines: 4,
                  initialValue: controller.message.value,
                  onSaved: (v) => controller.message.value = v ?? '',
                ),
                SizedBox(height: AppTheme.spacingL),

                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
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
        Flexible(
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    TextInputType? keyboardType,
    String? initialValue,
    int maxLines = 1,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
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
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onSaved: onSaved,
        validator: validator,
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
          errorStyle: GoogleFonts.nunito(
            fontSize: 12,
            color: const Color(0xFFFFCB80),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Get.snackbar(
            'Success',
            'Your message has been sent!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF4ECDC4),
            colorText: Colors.white,
            borderRadius: 16.r,
            margin: EdgeInsets.all(16.r),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: AppTheme.buttonHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF56D97F), Color(0xFF7BE495)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF56D97F).withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, color: Colors.white, size: 22.r),
              SizedBox(width: AppTheme.spacingS),
              Flexible(
                child: Text(
                  'Send Message',
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
}
