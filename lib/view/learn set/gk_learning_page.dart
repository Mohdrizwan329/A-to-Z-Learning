import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/learn%20set%20controller/gk_learning_controller.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'dart:math' as math;
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class GKLearningPage extends StatefulWidget {
  const GKLearningPage({super.key});

  @override
  State<GKLearningPage> createState() => _GKLearningPageState();
}

class _GKLearningPageState extends State<GKLearningPage>
    with TickerProviderStateMixin {
  final controller = Get.put(GKLearningController());

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late AnimationController _bubbleController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: controller.categories.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.changeCategory(controller.categories[_tabController.index]);
        _flipController.reset();
      }
    });

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

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
    _tabController.dispose();
    _flipController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'General Knowledge',
      emoji: '',
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
          onPressed: () => controller.resetProgress(),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3.r,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          tabAlignment: TabAlignment.center,
          dividerColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: 44.w),
          tabs: controller.categories.map((category) {
            return Tab(
              child: Text(
                category,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ),
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          SafeArea(
            child: Obx(() {
              final questions = controller.filteredQuestions;
              if (questions.isEmpty) {
                return const Center(
                  child: Text(
                    'No questions in this category',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }
              final question = questions[controller.currentIndex.value];
              final progress = controller.progressPercentage / 100;
              final progressString = controller.progressString;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Progress Bar with percentage
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: const Text(
                                  'Progress',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '$progressString completed',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10.h,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Question Card with float animation
                    AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value * 0.5),
                          child: child,
                        );
                      },
                      child: SizedBox(
                        height: 370.h,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                TtsService.to.speak(question['question']!);
                                if (!controller.showAnswer.value) {
                                  controller.revealAnswer();
                                  _flipController.forward();
                                } else {
                                  controller.showAnswer.value = false;
                                  _flipController.reverse();
                                }
                              },
                              child: AnimatedBuilder(
                                animation: _flipAnimation,
                                builder: (context, child) {
                                  return Transform(
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.001)
                                      ..rotateY(_flipAnimation.value * 3.14159),
                                    alignment: Alignment.center,
                                    child:
                                        controller.showAnswer.value &&
                                            _flipAnimation.value >= 0.5
                                        ? _buildAnswerCard(question)
                                        : _buildQuestionCard(question),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Question counter between card and buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Question counter badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                  Color(0xFFFFAA5A),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 6.r,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${controller.currentIndex.value + 1} / ${questions.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // Navigation Buttons - Always visible with gradient background
                    Container(
                      margin: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 8.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF667EEA).withValues(alpha: 0.4),
                            blurRadius: 10.r,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNavButton(
                              icon: Icons.arrow_back_ios,
                              label: 'Previous',
                              gradientColors: [
                                Color(0xFFEC4899),
                                Color(0xFFF472B6),
                              ],
                              onTap: controller.currentIndex.value > 0
                                  ? () {
                                      controller.previousQuestion();
                                      _flipController.reset();
                                    }
                                  : null,
                            ),
                            _buildNavButton(
                              icon: Icons.volume_up,
                              label: 'Listen',
                              gradientColors: [
                                Color(0xFF4ECDC4),
                                Color(0xFF44A08D),
                              ],
                              onTap: () => controller.speakQuestion(),
                            ),
                            _buildNavButton(
                              icon: Icons.arrow_forward_ios,
                              label: 'Next',
                              gradientColors: [
                                Color(0xFF3B82F6),
                                Color(0xFF60A5FA),
                              ],
                              onTap:
                                  controller.currentIndex.value <
                                      questions.length - 1
                                  ? () {
                                      controller.nextQuestion();
                                      _flipController.reset();
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

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

  Widget _buildQuestionCard(Map<String, String> question) {
    return Container(
      width: double.infinity,
      height: 350.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
            blurRadius: 15.r,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 75.w,
            height: 75.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(question['emoji']!, style: TextStyle(fontSize: 42)),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Question',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            question['question']!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Icon(
            Icons.touch_app,
            color: Colors.white.withValues(alpha: 0.5),
            size: 28.r,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(Map<String, String> question) {
    return Transform(
      transform: Matrix4.identity()..rotateY(3.14159),
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        height: 350.h,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF56D97F), Color(0xFF11998E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF56D97F).withValues(alpha: 0.4),
              blurRadius: 15.r,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 75.w,
              height: 75.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text("✅", style: TextStyle(fontSize: 42))),
            ),
            SizedBox(height: 10.h),
            Text(
              'Answer',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              question['answer']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            ElevatedButton.icon(
              onPressed: () => controller.speakAnswer(),
              icon: Icon(Icons.volume_up, size: 16.r),
              label: Text('Listen', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF11998E),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: gradientColors[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18.r),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
