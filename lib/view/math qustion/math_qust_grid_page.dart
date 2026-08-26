import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
// Generic Math Questions Page - replaces 4 individual pages
import 'package:jiyan_learning/view/math%20qustion/generic_math_questions_page.dart';
import 'package:jiyan_learning/view%20model/qustion%20controller/generic_math_questions_controller.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class MathQustionGridScreen extends StatefulWidget {
  @override
  State<MathQustionGridScreen> createState() => _MathQustionGridScreenState();
}

class _MathQustionGridScreenState extends State<MathQustionGridScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> mathItems = [
    {
      'label': 'Addition',
      'emoji': '➕',
      'gradient': [Color(0xFF56D97F), Color(0xFF81E89E)],
      'pageBuilder': () =>
          GenericMathQuestionsPage(operationType: MathOperationType.addition),
      'progressKey': ProgressService.kMathAddition,
    },
    {
      'label': 'Subtraction',
      'emoji': '➖',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      'pageBuilder': () => GenericMathQuestionsPage(
        operationType: MathOperationType.subtraction,
      ),
      'progressKey': ProgressService.kMathSubtraction,
    },
    {
      'label': 'Multiplication',
      'emoji': '✖️',
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
      'pageBuilder': () => GenericMathQuestionsPage(
        operationType: MathOperationType.multiplication,
      ),
      'progressKey': ProgressService.kMathMultiplication,
    },
    {
      'label': 'Division',
      'emoji': '➗',
      'gradient': [Color(0xFF45B7D1), Color(0xFF74C9DB)],
      'pageBuilder': () =>
          GenericMathQuestionsPage(operationType: MathOperationType.division),
      'progressKey': ProgressService.kMathDivision,
    },
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return GradientScaffold(
      title: 'Math Practice',
      emoji: '🧮',
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
          // Progress bar with percentage
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
                          '$totalDone/$totalAll completed',
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
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.r,
                crossAxisSpacing: 20.r,
                childAspectRatio: 0.8,
              ),
              itemCount: mathItems.length,
              itemBuilder: (context, index) {
                final item = mathItems[index];

                return AnimatedBuilder(
                  animation: _floatController,
                  builder: (_, child) {
                    final offset = (index % 2 == 0)
                        ? _floatAnimation.value
                        : -_floatAnimation.value;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                  child: _buildMathCard(item, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMathCard(Map<String, dynamic> item, int index) {
    final List<Color> gradient = item['gradient'];
    return GestureDetector(
      onTap: () {
        TtsService.to.speak(item['label']);
        Get.to(item['pageBuilder']);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.5),
              blurRadius: 15.r,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -25.h,
              right: -25.w,
              child: Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -35.h,
              left: -35.w,
              child: Container(
                width: 110.w,
                height: 110.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 15.r,
                            spreadRadius: 2.r,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          item['emoji'],
                          style: TextStyle(fontSize: 56),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Capped to two lines: 'Multiplication' wraps to three on a
                    // narrow phone and pushes the tile past its fixed height.
                    Flexible(
                      child: Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 3.r,
                            ),
                          ],
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
    );
  }
}
