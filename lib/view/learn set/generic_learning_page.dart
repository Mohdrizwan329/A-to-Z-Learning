import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/learn%20set%20controller/generic_learning_controller.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

/// Generic Learning Page that can display any learning set
/// Usage: GenericLearningPage(type: 'animals') or GenericLearningPage(type: 'fruits')
class GenericLearningPage extends StatefulWidget {
  final String type;

  const GenericLearningPage({super.key, required this.type});

  @override
  State<GenericLearningPage> createState() => _GenericLearningPageState();
}

class _GenericLearningPageState extends State<GenericLearningPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late GenericLearningController controller;

  @override
  void initState() {
    super.initState();

    // Create unique tag for this controller instance
    final tag = 'learning_${widget.type}';
    controller = Get.put(
      GenericLearningController(type: widget.type),
      tag: tag,
    );

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
      title: controller.title,
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
          onPressed: () {
            setState(() {
              controller.resetSelection();
            });
          },
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final progress = controller.progressPercentage / 100;
            final progressString = controller.progressString;
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
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
            child: Obx(() {
              // This Obx will rebuild when completedCount changes
              final completedCount = controller.completedCount;
              return GridView.builder(
                key: ValueKey(completedCount),
                padding: EdgeInsets.all(12.r),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.r,
                  crossAxisSpacing: 16.r,
                  childAspectRatio: 1.2,
                ),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  final isSelected = controller.selectedIndex.value == index;
                  final isCompleted = controller.isItemCompleted(index);
                  final gradient = AppColors.getGradientForIndex(index);

                  return buildAnimatedGridItem(
                    index: index,
                    isSelected: isSelected,
                    child: GradientCard(
                      gradient: gradient,
                      isSelected: isSelected,
                      borderRadius: 24,
                      onTap: () {
                        TtsService.to.speak(item['name'] ?? '');
                        setState(() {
                          controller.selectItem(index);
                        });
                      },
                      pulseAnimation: pulseAnimation,
                      child: Stack(
                        children: [
                          _buildCardContent(item),
                          // Show checkmark if completed
                          if (isCompleted)
                            Positioned(
                              bottom: 4.h,
                              right: 4.w,
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
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(Map<String, String> item) {
    return Center(
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
              child: Text(
                item['emoji'] ?? '',
                style: const TextStyle(fontSize: 42),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Capped to two lines: a long word wraps and pushes the pair past
          // the tile's fixed aspect-ratio height.
          Flexible(
            child: Text(
              item['name'] ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
