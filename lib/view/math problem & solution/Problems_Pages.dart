import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/view%20model/math%20controller/math_practice_controller.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

//////////////////////////////////////////////////////////
//                MAIN MATH GRID SCREEN
//////////////////////////////////////////////////////////
class MathGridScreen extends StatefulWidget {
  @override
  State<MathGridScreen> createState() => _MathGridScreenState();
}

class _MathGridScreenState extends State<MathGridScreen>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final List<Map<String, dynamic>> mathOperations = [
    {
      'label': 'Addition',
      'emoji': '➕',
      'page': () => AdditionPage(),
      'progressKey': ProgressService.kMathAddition,
    },
    {
      'label': 'Subtraction',
      'emoji': '➖',
      'page': () => SubtractionPage(),
      'progressKey': ProgressService.kMathSubtraction,
    },
    {
      'label': 'Multiplication',
      'emoji': '✖️',
      'page': () => MultiplicationPage(),
      'progressKey': ProgressService.kMathMultiplication,
    },
    {
      'label': 'Division',
      'emoji': '➗',
      'page': () => DivisionPage(),
      'progressKey': ProgressService.kMathDivision,
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Math Problem Solve Practice',
      emoji: '🔢',
      actions: [
        Container(
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(
                ProgressService.kMathAddition,
              );
              await ProgressService.to.resetProgress(
                ProgressService.kMathSubtraction,
              );
              await ProgressService.to.resetProgress(
                ProgressService.kMathMultiplication,
              );
              await ProgressService.to.resetProgress(
                ProgressService.kMathDivision,
              );
              setState(() {});
            },
            icon: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
        ),
      ],
      body: Column(
        children: [
          // Progress bar
          Obx(() {
            final addDone =
                (ProgressService.to.completedItems[ProgressService
                            .kMathAddition] ??
                        0) >
                    0
                ? 1
                : 0;
            final subDone =
                (ProgressService.to.completedItems[ProgressService
                            .kMathSubtraction] ??
                        0) >
                    0
                ? 1
                : 0;
            final mulDone =
                (ProgressService.to.completedItems[ProgressService
                            .kMathMultiplication] ??
                        0) >
                    0
                ? 1
                : 0;
            final divDone =
                (ProgressService.to.completedItems[ProgressService
                            .kMathDivision] ??
                        0) >
                    0
                ? 1
                : 0;
            final totalDone = addDone + subDone + mulDone + divDone;
            const totalAll = 4;
            final progress = totalDone / totalAll;
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // The reader's font size can be 30% larger than this row was drawn for.
                      Flexible(
                        child: const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '$totalDone/$totalAll completed',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
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
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.r,
                crossAxisSpacing: 16.r,
                childAspectRatio: 1.0,
              ),
              itemCount: mathOperations.length,
              itemBuilder: (context, index) {
                final item = mathOperations[index];
                final gradient = AppColors.getGradientForIndex(index);
                return buildAnimatedGridItem(
                  index: index,
                  isSelected: false,
                  child: GradientCard(
                    gradient: gradient,
                    isSelected: false,
                    onTap: () {
                      TtsService.to.speak(item['label']);
                      Get.to(item['page']);
                    },
                    pulseAnimation: pulseAnimation,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 75.w,
                                height: 75.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    item['emoji'],
                                    style: const TextStyle(fontSize: 42),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GradientCardText(
                                text: item['label'],
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//                MATH TEMPLATE SCREEN
//////////////////////////////////////////////////////////
class MathGridTemplate extends StatefulWidget {
  final String title;
  final String operator;
  final String emoji;
  final List<Color> themeGradient;
  final String? progressKey;

  const MathGridTemplate({
    super.key,
    required this.title,
    required this.operator,
    required this.emoji,
    required this.themeGradient,
    this.progressKey,
  });

  @override
  State<MathGridTemplate> createState() => _MathGridTemplateState();
}

class _MathGridTemplateState extends State<MathGridTemplate>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late final MathPracticeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      MathPracticeController(
        operatorSymbol: widget.operator,
        progressKey: widget.progressKey,
      ),
      tag: widget.title,
    );
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    Get.delete<MathPracticeController>(tag: widget.title);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.title,
      emoji: widget.emoji,
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
          onPressed: () => controller.resetAll(),
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage (same as Numbers screen)
          if (widget.progressKey != null)
            Obx(() {
              final progress =
                  ProgressService.to.getProgressPercentage(
                    widget.progressKey!,
                  ) /
                  100;
              final progressString = ProgressService.to.getProgressString(
                widget.progressKey!,
              );
              return Padding(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
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
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          // Grid (same pattern as Numbers screen)
          Expanded(
            child: Obx(() {
              final problemsList = controller.problems;
              return GridView.builder(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.r,
                  crossAxisSpacing: 12.r,
                  childAspectRatio: 1.0,
                ),
                itemCount: problemsList.length,
                itemBuilder: (context, index) {
                  final gradient = AppColors.getGradientForIndex(index);

                  return buildFloatingItem(
                    index: index,
                    child: Obx(() {
                      final isSelected =
                          controller.selectedIndex.value == index;
                      final isCompleted = controller.isItemDone(index);

                      return GradientCard(
                        gradient: gradient,
                        isSelected: isSelected,
                        onTap: () => controller.handleTap(index),
                        pulseAnimation: pulseAnimation,
                        child: Stack(
                          children: [
                            Center(
                              child: GradientCardText(
                                text: problemsList[index],
                                fontSize: 20,
                              ),
                            ),
                            // Show checkmark if completed
                            if (isCompleted)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12.r,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//                INDIVIDUAL OPERATION PAGES
//////////////////////////////////////////////////////////
class AdditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
    title: "Addition",
    operator: '+',
    emoji: '➕',
    themeGradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    progressKey: ProgressService.kMathAddition,
  );
}

class SubtractionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
    title: "Subtraction",
    operator: '-',
    emoji: '➖',
    themeGradient: [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    progressKey: ProgressService.kMathSubtraction,
  );
}

class MultiplicationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
    title: "Multiplication",
    operator: '×',
    emoji: '✖️',
    themeGradient: [Color(0xFF56D97F), Color(0xFF81E89E)],
    progressKey: ProgressService.kMathMultiplication,
  );
}

class DivisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MathGridTemplate(
    title: "Division",
    operator: '÷',
    emoji: '➗',
    themeGradient: [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    progressKey: ProgressService.kMathDivision,
  );
}
