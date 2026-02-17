import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen>
    with TickerProviderStateMixin {
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
    return List.generate(15, (index) {
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

  static const List<Map<String, dynamic>> _termsSections = [
    {
      "title": "Age Requirements",
      "body": "This app is designed for children ages 3-12 years. Children must use the app under parental supervision.",
      "icon": Icons.child_care_rounded,
      "gradient": [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    },
    {
      "title": "Educational Content",
      "body": "All content is designed for educational purposes only. We provide accurate and age-appropriate learning materials.",
      "icon": Icons.school_rounded,
      "gradient": [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    },
    {
      "title": "User Account",
      "body": "Parents can create accounts for their children. Keep login credentials secure. One account per child is recommended.",
      "icon": Icons.account_circle_rounded,
      "gradient": [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    },
    {
      "title": "Subscription & Payments",
      "body": "Basic features are free. Premium features require subscription. Parents must authorize all purchases.",
      "icon": Icons.payment_rounded,
      "gradient": [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
    {
      "title": "Child Safety",
      "body": "No direct communication between users. No personal information sharing. All content is reviewed for child safety.",
      "icon": Icons.security_rounded,
      "gradient": [Color(0xFF56D97F), Color(0xFF7BE495)],
    },
    {
      "title": "Acceptable Use",
      "body": "Use the app only for learning purposes. Do not attempt to modify or hack the app. Report any issues through Help section.",
      "icon": Icons.thumb_up_rounded,
      "gradient": [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    },
    {
      "title": "Intellectual Property",
      "body": "All content and designs are owned by Learning For Kids. Users may not copy or distribute app content.",
      "icon": Icons.copyright_rounded,
      "gradient": [Color(0xFF45B7D1), Color(0xFF7DD3E8)],
    },
    {
      "title": "Updates & Changes",
      "body": "We regularly update content to improve learning. App features may change with updates. We notify users of significant changes.",
      "icon": Icons.system_update_rounded,
      "gradient": [Color(0xFFEC407A), Color(0xFFF48FB1)],
    },
    {
      "title": "Limitation of Liability",
      "body": "The app is provided 'as is' for educational purposes. Technical issues will be resolved as quickly as possible.",
      "icon": Icons.gavel_rounded,
      "gradient": [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    },
    {
      "title": "Contact Us",
      "body": "For questions about these terms, contact us through the app or email: support@learningforkids.com",
      "icon": Icons.contact_support_rounded,
      "gradient": [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      bottomNavigationBar: const AdsScreen(),
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
                itemCount: _termsSections.length,
                itemBuilder: (context, index) {
                  final item = _termsSections[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: _buildTermsTile(item, index),
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
        'Terms & Conditions',
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

  Widget _buildTermsTile(Map<String, dynamic> item, int index) {
    final gradient = item['gradient'] as List;
    final gradientList = gradient.cast<Color>();

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
          colors: gradientList,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientList[0].withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingL,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  size: 28,
                ),
              ),
              SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${item['title']}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['body'],
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
