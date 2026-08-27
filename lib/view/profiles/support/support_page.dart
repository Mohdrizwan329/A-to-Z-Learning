import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/support_contact.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with TickerProviderStateMixin {
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

  static const List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I reset my child\'s learning progress?',
      'answer':
          'Go to Account Settings > Reset Progress. This will clear all learning data and start fresh.',
      'icon': Icons.refresh_rounded,
      'gradient': [Color(0xFF45B7D1), Color(0xFF7DD3E8)],
    },
    {
      'question': 'Is the app safe for my child?',
      'answer':
          'Yes! All content is age-appropriate and reviewed. There are no chat features or external links accessible to children.',
      'icon': Icons.security_rounded,
      'gradient': [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    },
    {
      'question': 'How do I upgrade to Premium?',
      'answer':
          'Go to Profile > Transaction to view our premium plans. Choose a plan that suits your needs and complete the payment.',
      'icon': Icons.star_rounded,
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    },
    {
      'question': 'Can I use the app offline?',
      'answer':
          'Most learning content is available offline once downloaded. Some features like Math Scanner require internet.',
      'icon': Icons.wifi_off_rounded,
      'gradient': [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    },
    {
      'question': 'How do I report a bug or issue?',
      'answer':
          'Use the Help section in Profile to submit your feedback. Our team will respond within 48 hours.',
      'icon': Icons.bug_report_rounded,
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    },
    {
      'question': 'What age group is this app for?',
      'answer':
          'Learning For Kids is designed for children aged 3-12 years, covering Numbers, Alphabets, Hindi, Math, and Drawing.',
      'icon': Icons.child_care_rounded,
      'gradient': [Color(0xFF56D97F), Color(0xFF7BE495)],
    },
  ];

  /// Opens the mail app, or shows the address to copy when the device has no
  /// mail app set up.
  Future<void> _contactSupport() async {
    final opened = await SupportContact.composeEmail(
      subject: 'Jiyan Learning - Support request',
      body: "Tell us your child's age group, the screen you were on, and "
          "what happened:\n\n",
    );
    if (opened) return;

    Get.snackbar(
      'No mail app found',
      'Write to ${SupportContact.email}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF764BA2),
      colorText: Colors.white,
      margin: EdgeInsets.all(AppTheme.spacingM),
      borderRadius: 12.r,
      duration: const Duration(seconds: 5),
    );
  }

  Widget _buildContactCard() {
    return GestureDetector(
      onTap: _contactSupport,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.mail_rounded, color: Colors.white, size: 22.r),
            ),
            SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Still stuck? Email us',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    SupportContact.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.7),
              size: 16.r,
            ),
          ],
        ),
      ),
    );
  }

  @override
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
                    // FAQ Header
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: _buildFaqHeader(),
                          ),
                        );
                      },
                    ),
                    // FAQ Items
                    ...List.generate(_faqItems.length, (index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 450 + (index * 50)),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: _buildFaqSection(_faqItems[index], index),
                            ),
                          );
                        },
                      );
                    }),

                    SizedBox(height: AppTheme.spacingM),
                    // The FAQs answer the common things; this is the way out
                    // for everything else. The page used to carry no way to
                    // reach anyone at all.
                    _buildContactCard(),
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
        'Support',
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

  Widget _buildFaqHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacingL),
      child: Text(
        'Frequently Asked Questions',
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
    );
  }

  /// One question and answer, set straight onto the page background.
  ///
  /// No card and no expand/collapse: six short answers are quicker to skim
  /// laid out as a document than tapped open one at a time.
  Widget _buildFaqSection(Map<String, dynamic> faq, int index) {
    final isLast = index == _faqItems.length - 1;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(faq['icon'], color: Colors.white, size: 22.r),
              SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  faq['question'],
                  style: GoogleFonts.poppins(
                    fontSize: 17,
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
          SizedBox(height: 8.h),
          Text(
            faq['answer'],
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
          if (!isLast) ...[
            SizedBox(height: AppTheme.spacingL),
            // A hairline keeps two answers from reading as one paragraph now
            // that no card separates them.
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.28),
            ),
          ],
        ],
      ),
    );
  }
}
