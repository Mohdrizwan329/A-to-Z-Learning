import 'dart:math' as math;
import 'package:jiyan_learning/app/support_contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
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

            // A dark wash over the gradient. Without the cards there is
            // nothing behind the text, and the gradient runs light pink
            // further down. 0.5 puts white body text at ~6.9:1 even against
            // the lightest point of that gradient.
            Positioned.fill(
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.5)),
            ),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.spacingM,
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                  AppTheme.spacingXL,
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
                            child: _buildHelpSteps(),
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
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 26.r,
              ),
              SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  "We're Here to Help!",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Try these in order - most problems are solved by the first few.',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The steps a parent can take to get help, in the order worth trying.
  ///
  /// This replaced a contact form that only showed a success message: nothing
  /// it collected was ever sent anywhere, so it promised help it could not
  /// deliver. Pointing at the channels that do work is honest and faster.
  static const List<Map<String, dynamic>> _helpSteps = [
    {
      'icon': Icons.quiz_rounded,
      'title': 'Check the FAQs first',
      'body':
          'Profile > Support answers the most common questions: resetting progress, child safety, Premium, offline use and age groups.',
    },
    {
      'icon': Icons.child_care_rounded,
      'title': 'Set the right age group',
      'body':
          'Most "wrong content" reports are an age mismatch. Open Profile > Age Group and pick the band that matches your child\'s class.',
    },
    {
      'icon': Icons.person_outline_rounded,
      'title': 'Fix your details in Edit Profile',
      'body':
          'Wrong name, email, location or photo on the profile card? Profile > Account > Edit Profile updates all of them.',
    },
    {
      'icon': Icons.refresh_rounded,
      'title': 'Restart before reporting a bug',
      'body':
          'If a screen freezes or a scan fails, close the app fully and reopen it. A restart clears most one-off glitches.',
    },
    {
      'icon': Icons.wifi_rounded,
      'title': 'Check your connection',
      'body':
          'Scanning, sign-in and syncing need the internet. Lessons already downloaded keep working offline.',
    },
    {
      'icon': Icons.email_outlined,
      'title': 'Still stuck? Email us',
      'body':
          'Write to ${SupportContact.email}. Tell us your child\'s age group, the screen you were on and what happened - it gets you a faster answer.',
    },
  ];

  Widget _buildHelpSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _helpSteps.length; i++)
          _buildHelpStep(_helpSteps[i], i),
      ],
    );
  }

  Widget _buildHelpStep(Map<String, dynamic> step, int index) {
    final isLast = index == _helpSteps.length - 1;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppTheme.spacingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numbered marker, so the steps read as an order to try them in.
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(step['icon'], color: Colors.white, size: 20.r),
                    SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: Text(
                        step['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  step['body'],
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
