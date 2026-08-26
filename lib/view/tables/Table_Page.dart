import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/table%20controller/table_controller.dart';
import 'package:jiyan_learning/view/tables/Table_Count_Page.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class TableScreen extends StatefulWidget {
  final List<Color>? gradient;

  const TableScreen({super.key, this.gradient});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final TableController controller = Get.put(TableController());
  final int totalBoxes = 39;

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
      title: 'Tables 2-40',
      emoji: '✖️',
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
          onPressed: () => controller.resetExpanded(),
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kTables,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kTables,
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
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12.r,
                crossAxisSpacing: 12.r,
                childAspectRatio: 1,
              ),
              itemCount: totalBoxes,
              itemBuilder: (context, index) {
                final number = index + 2;
                final gradient = AppColors.getGradientForIndex(index);

                return Obx(() {
                  final isSelected = controller.expandedIndexes.contains(index);
                  final isCompleted = controller.isTableCompleted(index);

                  return buildAnimatedGridItem(
                    index: index,
                    isSelected: isSelected,
                    child: GradientCard(
                      gradient: gradient,
                      isSelected: isSelected,
                      onTap: () {
                        TtsService.to.speak('Table of $number');
                        controller.toggleExpanded(index, number);
                        Get.to(() => TableDetailScreen(number: number));
                      },
                      pulseAnimation: pulseAnimation,
                      child: Stack(
                        children: [
                          Center(
                            // The number and its 'x' are a fixed pair that is
                            // slightly taller than the tile on a small phone;
                            // scaling the pair down keeps both fully visible.
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GradientCardText(
                                    text: '$number',
                                    fontSize: 34,
                                  ),
                                  Text(
                                    'x',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
