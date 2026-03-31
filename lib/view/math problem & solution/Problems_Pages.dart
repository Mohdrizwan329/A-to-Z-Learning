import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/view%20model/math%20controller/math_practice_controller.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

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
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
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
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
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
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
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
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
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
                    onTap: () { TtsService.to.speak(item['label']); Get.to(item['page']); },
                    pulseAnimation: pulseAnimation,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 75,
                                height: 75,
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
                              const SizedBox(height: 10),
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
      bottomNavigationBar: const AdsScreen(),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
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
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$progressString completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
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
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
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
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
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
      bottomNavigationBar: const AdsScreen(),
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
