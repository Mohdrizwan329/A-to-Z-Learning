import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view/quiz/quiz_page.dart';
import 'package:jiyan_learning/view/rewards/rewards_page.dart';
import 'package:jiyan_learning/view/rewards/daily_goals_page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class QuizHubPage extends StatefulWidget {
  const QuizHubPage({super.key});

  @override
  State<QuizHubPage> createState() => _QuizHubPageState();
}

class _QuizHubPageState extends State<QuizHubPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late AnimationController _scaleController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;
  bool _isInitialized = false;

  final List<Map<String, dynamic>> quizItems = [
    {
      'title': 'Quiz Time',
      'subtitle': 'Test your knowledge!',
      'emoji': '❓',
      'gradient': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      'page': () => QuizPage(),
    },
    {
      'title': 'My Rewards',
      'subtitle': 'Stars, badges & trophies',
      'emoji': '🏆',
      'gradient': [const Color(0xFFFFD700), const Color(0xFFFFA500)],
      'page': () => RewardsPage(),
    },
    {
      'title': 'Daily Goals',
      'subtitle': 'Track your progress',
      'emoji': '🎯',
      'gradient': [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      'page': () => DailyGoalsPage(),
    },
  ];

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

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _isInitialized = true;
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  // Floating bubbles for playful effect
  List<Widget> _buildFloatingBubbles() {
    if (!_isInitialized) return [];

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        title: Text(
          "Quiz & Rewards",
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFf5576c),
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
              child: Column(
                children: [
                  // Grid content
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.r,
                        crossAxisSpacing: 16.r,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: quizItems.length,
                      itemBuilder: (context, index) {
                        final item = quizItems[index];
                        final gradientColors = item['gradient'] as List<Color>;

                        if (!_isInitialized) {
                          return const SizedBox();
                        }

                        return AnimatedBuilder(
                          animation: Listenable.merge([
                            _floatController,
                            _scaleController,
                          ]),
                          builder: (_, child) {
                            final floatOffset = (index % 2 == 0)
                                ? _floatAnimation.value
                                : -_floatAnimation.value;
                            final scale = index == 0
                                ? _scaleAnimation.value
                                : 1.0;

                            return Transform.translate(
                              offset: Offset(0, floatOffset),
                              child: Transform.scale(
                                scale: scale,
                                child: child,
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              TtsService.to.speak(item['title']);
                              Get.to(item['page']);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradientColors[0].withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 12.r,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Decorative circle top-right - colored
                                  Positioned(
                                    top: -20.h,
                                    right: -20.w,
                                    child: Container(
                                      width: 70.w,
                                      height: 70.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            gradientColors[1].withValues(
                                              alpha: 0.4,
                                            ),
                                            gradientColors[0].withValues(
                                              alpha: 0.2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Decorative circle bottom-left - colored
                                  Positioned(
                                    bottom: -25.h,
                                    left: -25.w,
                                    child: Container(
                                      width: 80.w,
                                      height: 80.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            gradientColors[0].withValues(
                                              alpha: 0.3,
                                            ),
                                            gradientColors[1].withValues(
                                              alpha: 0.15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Small decorative circle - colored
                                  Positioned(
                                    top: 40.h,
                                    left: -10.w,
                                    child: Container(
                                      width: 30.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: gradientColors[1].withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Extra decorative circle bottom-right
                                  Positioned(
                                    bottom: 20.h,
                                    right: -15.w,
                                    child: Container(
                                      width: 40.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: gradientColors[0].withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.r),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Emoji container with gradient glow
                                          Container(
                                            width: 80.w,
                                            height: 80.h,
                                            decoration: BoxDecoration(
                                              gradient: RadialGradient(
                                                colors: [
                                                  Colors.white.withValues(
                                                    alpha: 0.35,
                                                  ),
                                                  gradientColors[1].withValues(
                                                    alpha: 0.2,
                                                  ),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: gradientColors[0]
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 15.r,
                                                  spreadRadius: 2.r,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                item['emoji']!,
                                                style: const TextStyle(
                                                  fontSize: 45,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 14.h),
                                          // Title. Flexible with a line cap so a
                                          // long label shortens instead of
                                          // pushing the tile past its fixed
                                          // aspect-ratio height.
                                          Flexible(
                                            child: Text(
                                              item['title']!,
                                              style: GoogleFonts.baloo2(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          // Subtitle
                                          Flexible(
                                            child: Text(
                                              item['subtitle']!,
                                              style: GoogleFonts.nunito(
                                                fontSize: 12,
                                                color: Colors.white.withValues(
                                                  alpha: 0.95,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
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
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
