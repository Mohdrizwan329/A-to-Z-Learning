import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
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

  static const List<Map<String, dynamic>> _policySections = [
    {
      "title": "Information We Collect",
      "body": "We collect basic information like child's name, age, and learning preferences to personalize the educational experience.",
      "icon": Icons.description_rounded,
      "gradient": [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    },
    {
      "title": "Child Safety First",
      "body": "Learning For Kids is designed with child safety as our top priority. We comply with COPPA guidelines and do not collect unnecessary personal data.",
      "icon": Icons.child_care_rounded,
      "gradient": [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    },
    {
      "title": "How We Use Information",
      "body": "Your data is used to track learning progress, provide personalized content, and improve our educational materials.",
      "icon": Icons.settings_rounded,
      "gradient": [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    },
    {
      "title": "Parental Controls",
      "body": "Parents can access, modify, or delete their child's data at any time. We encourage parental supervision during app usage.",
      "icon": Icons.family_restroom_rounded,
      "gradient": [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
    {
      "title": "Data Security",
      "body": "We implement strong security measures to protect children's information from unauthorized access.",
      "icon": Icons.lock_rounded,
      "gradient": [Color(0xFF56D97F), Color(0xFF7BE495)],
    },
    {
      "title": "No Harmful Content",
      "body": "All content in Learning For Kids is age-appropriate, educational, and free from harmful or inappropriate materials.",
      "icon": Icons.verified_user_rounded,
      "gradient": [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    },
    {
      "title": "Advertisements",
      "body": "Any advertisements shown are child-friendly and comply with children's advertising guidelines.",
      "icon": Icons.tv_rounded,
      "gradient": [Color(0xFF45B7D1), Color(0xFF7DD3E8)],
    },
    {
      "title": "Third-Party Services",
      "body": "We only partner with trusted third-party services that maintain similar privacy and safety standards.",
      "icon": Icons.handshake_rounded,
      "gradient": [Color(0xFFEC407A), Color(0xFFF48FB1)],
    },
    {
      "title": "Data Retention",
      "body": "We retain data only as long as necessary for educational purposes. Parents can request data deletion anytime.",
      "icon": Icons.delete_sweep_rounded,
      "gradient": [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    },
    {
      "title": "Contact Us",
      "body": "For any privacy concerns or questions, parents can contact us through the Help section in the app.",
      "icon": Icons.email_rounded,
      "gradient": [Color(0xFF4ECDC4), Color(0xFF44A08D)],
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
                itemCount: _policySections.length,
                itemBuilder: (context, index) {
                  final item = _policySections[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: _buildPolicyTile(item, index),
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
        'Privacy Policy',
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

  Widget _buildPolicyTile(Map<String, dynamic> item, int index) {
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
