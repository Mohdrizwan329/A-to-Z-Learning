import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/view%20model/qustion%20controller/generic_math_questions_controller.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// Generic Math Questions Page that can display any operation type
/// Usage: GenericMathQuestionsPage(operationType: MathOperationType.addition)
class GenericMathQuestionsPage extends StatefulWidget {
  final MathOperationType operationType;

  const GenericMathQuestionsPage({super.key, required this.operationType});

  @override
  State<GenericMathQuestionsPage> createState() =>
      _GenericMathQuestionsPageState();
}

class _GenericMathQuestionsPageState extends State<GenericMathQuestionsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late GenericMathQuestionsController controller;

  final List<int> selectedIndexes = [];

  @override
  void initState() {
    super.initState();

    final tag = 'math_${widget.operationType.name}';
    controller = Get.put(
      GenericMathQuestionsController(operationType: widget.operationType),
      tag: tag,
    );

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
      title: controller.title,
      emoji: controller.emoji,
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
          onPressed: () {
            setState(() {
              controller.resetAll();
              selectedIndexes.clear();
            });
          },
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final total = controller.questions.length;
            final answered = controller.questions
                .where((q) => q.isAnswered)
                .length;
            final progress = total > 0 ? answered / total : 0.0;
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
                          '$answered/$total completed',
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0
                            ? Colors.green
                            : const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          // Score row
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreBadge('✅ ${controller.correct}', Colors.green),
                  SizedBox(width: 12.w),
                  _buildScoreBadge('❌ ${controller.incorrect}', Colors.red),
                  SizedBox(width: 12.w),
                  _buildScoreBadge(
                    'Batch ${controller.currentBatch.value + 1}/${(controller.questions.length / 10).ceil()}',
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          // Grid
          Expanded(
            child: Obx(
              () => GridView.builder(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.r,
                  crossAxisSpacing: 12.r,
                  childAspectRatio: 0.9,
                ),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) {
                  final question = controller.questions[index];
                  final gradient = AppColors.getGradientForIndex(index);
                  final isSelected = selectedIndexes.contains(index);

                  // Locked card
                  if (!controller.isInCurrentBatch(index) &&
                      !question.isAnswered) {
                    return buildFloatingItem(
                      index: index,
                      child: _buildLockedCard(),
                    );
                  }

                  // Active Card
                  return buildAnimatedGridItem(
                    index: index,
                    isSelected: isSelected,
                    child: _buildQuestionCard(
                      question,
                      gradient,
                      isSelected,
                      index,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLockedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.r,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, color: Colors.grey.shade600, size: 40.r),
            SizedBox(height: 8.h),
            Text(
              "Locked",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    MathQuestionModel question,
    List<Color> gradient,
    bool isSelected,
    int index,
  ) {
    final isAnswered = question.isAnswered;

    return GestureDetector(
      onTap: () {
        TtsService.to.speak(
          '${question.num1} ${controller.symbol} ${question.num2}',
        );
        setState(() {
          if (isSelected) {
            selectedIndexes.remove(index);
          } else {
            selectedIndexes.add(index);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAnswered
                ? [Color(0xFF56D97F), Color(0xFF81E89E)]
                : isSelected
                ? AppColors.selectedGradient
                : gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppColors.cardShadow(
            isSelected ? AppColors.selectedGradient[0] : gradient[0],
            isSelected: isSelected,
          ),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10.h,
              right: -10.w,
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -15.h,
              left: -15.w,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Question. A three-digit pair wraps to two lines on a narrow
                  // phone, which pushed the Submit button out of the tile.
                  Flexible(
                    child: Text(
                      "${question.num1} ${controller.symbol} ${question.num2}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
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
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Answer Input or Result
                  if (!isAnswered)
                    SizedBox(
                      height: 40.h,
                      child: TextField(
                        controller: question.controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Answer",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                          ),
                        ),
                      ),
                    ),

                  if (isAnswered)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        question.result,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  SizedBox(height: 12.h),

                  // Submit Button
                  if (!isAnswered)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.checkAnswer(index);
                          if (controller.allAnsweredInBatch) {
                            _showScoreDialog(context);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: gradient[0],
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  if (isAnswered) Text("✅", style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 6.h,
                left: 6.w,
                child: Text("⭐", style: TextStyle(fontSize: 14)),
              ),
          ],
        ),
      ),
    );
  }

  void _showScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text("🎉", style: TextStyle(fontSize: 28)),
            SizedBox(width: 8.w),
            Text(
              "Batch Completed!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("✅", style: TextStyle(fontSize: 32)),
                      Text(
                        "${controller.correct}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text("Correct", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("❌", style: TextStyle(fontSize: 32)),
                      Text(
                        "${controller.incorrect}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text("Incorrect", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.moveToNextBatch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF56D97F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              "Next 10 Questions ➡️",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
