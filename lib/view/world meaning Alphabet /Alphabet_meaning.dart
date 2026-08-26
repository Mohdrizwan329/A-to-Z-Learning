import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/alphabet%20controller/world_meaning_alphabet_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class AlphabetMeaning extends StatefulWidget {
  final List<Color>? gradient;

  const AlphabetMeaning({super.key, this.gradient});

  @override
  State<AlphabetMeaning> createState() => _AlphabetMeaningState();
}

class _AlphabetMeaningState extends State<AlphabetMeaning>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final WorldMeaningAlphabetController controller = Get.put(
    WorldMeaningAlphabetController(),
  );

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, pulseMax: 1.05);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'A to Z Words',
      emoji: '📖',
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
          onPressed: () => controller.clearCache(),
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kAlphabetWords,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kAlphabetWords,
            );
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
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.r,
                crossAxisSpacing: 16.r,
                childAspectRatio: 1,
              ),
              itemCount: controller.alphabetData.length,
              itemBuilder: (context, index) {
                final item = controller.alphabetData[index];
                final gradient = AppColors.getGradientForIndex(index);

                return Obx(() {
                  final isSelected = controller.selectedIndexes.contains(index);
                  final isCompleted = controller.isLetterCompleted(index);

                  return buildAnimatedGridItem(
                    index: index,
                    isSelected: isSelected,
                    child: GradientCard(
                      gradient: gradient,
                      isSelected: isSelected,
                      borderRadius: 20,
                      onTap: () => controller.toggleSelection(
                        index: index,
                        showSnack: _showSnack,
                      ),
                      pulseAnimation: pulseAnimation,
                      child: Stack(
                        children: [
                          Center(child: _buildCardContent(item)),
                          // Show checkmark if completed
                          if (isCompleted)
                            Positioned(
                              bottom: 6.h,
                              right: 6.w,
                              child: Container(
                                padding: EdgeInsets.all(3.r),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14.r,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(Map<String, String> item) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Letter
          GradientCardText(text: item['letter']!, fontSize: 30),
          // Emoji in circle
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(item['emoji']!, style: const TextStyle(fontSize: 36)),
            ),
          ),
          SizedBox(height: 8.h),
          // Meaning text
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: Text(
              item['meaning']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
