import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/view%20model/qustion%20controller/generic_math_questions_controller.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
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
            final answered =
                controller.questions.where((q) => q.isAnswered).length;
            final progress = total > 0 ? answered / total : 0.0;
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
                        '$answered/$total completed',
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
          Obx(() => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScoreBadge(
                        '✅ ${controller.correct}', Colors.green),
                    const SizedBox(width: 12),
                    _buildScoreBadge(
                        '❌ ${controller.incorrect}', Colors.red),
                    const SizedBox(width: 12),
                    _buildScoreBadge(
                      'Batch ${controller.currentBatch.value + 1}/${(controller.questions.length / 10).ceil()}',
                      Colors.blue,
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          // Grid
          Expanded(
            child: Obx(() => GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
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
                          question, gradient, isSelected, index),
                    );
                  },
                )),
          ),
        ],
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildScoreBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, color: Colors.grey.shade600, size: 40),
            SizedBox(height: 8),
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

  Widget _buildQuestionCard(MathQuestionModel question, List<Color> gradient,
      bool isSelected, int index) {
    final isAnswered = question.isAnswered;

    return GestureDetector(
      onTap: () {
        TtsService.to.speak('${question.num1} ${controller.symbol} ${question.num2}');
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow(
            isSelected ? AppColors.selectedGradient[0] : gradient[0],
            isSelected: isSelected,
          ),
          border:
              isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: -15,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Question
                  Text(
                    "${question.num1} ${controller.symbol} ${question.num2}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 2),
                            blurRadius: 3),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  // Answer Input or Result
                  if (!isAnswered)
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: question.controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Answer",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),

                  if (isAnswered)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
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

                  SizedBox(height: 12),

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
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),

                  if (isAnswered)
                    Text("✅", style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                  top: 6,
                  left: 6,
                  child: Text("⭐", style: TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }

  void _showScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text("🎉", style: TextStyle(fontSize: 28)),
            SizedBox(width: 8),
            Text("Batch Completed!",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      Text("${controller.correct}",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      Text("Correct",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("❌", style: TextStyle(fontSize: 32)),
                      Text("${controller.incorrect}",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Text("Incorrect",
                          style: TextStyle(color: Colors.grey)),
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
                  borderRadius: BorderRadius.circular(20)),
              padding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("Next 10 Questions ➡️",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
