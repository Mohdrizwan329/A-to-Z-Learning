import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view%20model/table%20controller/table_detail_controller.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class TableDetailScreen extends StatefulWidget {
  final int number;

  const TableDetailScreen({super.key, required this.number});

  @override
  State<TableDetailScreen> createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends State<TableDetailScreen>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late TableDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TableDetailController(widget.number));
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    Get.delete<TableDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Table of ${widget.number}',
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
          onPressed: () => controller.resetStep(),
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final completed = controller.completedCount;
            final total = 10;
            final progress = completed / total;
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
                          '$completed/$total completed',
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
                crossAxisCount: 2,
                mainAxisSpacing: 12.r,
                crossAxisSpacing: 12.r,
                childAspectRatio: 1.5,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                final multiplier = index + 1;
                final product = widget.number * multiplier;
                final gradient = AppColors.getGradientForIndex(index);

                return Obx(() {
                  final isSelected = controller.selectedIndex.value == index;
                  final isCompleted = controller.isEntryCompleted(index);

                  return buildAnimatedGridItem(
                    index: index,
                    isSelected: isSelected,
                    child: GradientCard(
                      gradient: gradient,
                      isSelected: isSelected,
                      borderRadius: 20,
                      onTap: () {
                        TtsService.to.speak(
                          '${widget.number} times $multiplier equals $product',
                        );
                        controller.onBoxTap(index);
                      },
                      pulseAnimation: pulseAnimation,
                      child: Stack(
                        children: [
                          Center(
                            child: GradientCardText(
                              text: '${widget.number} × $multiplier = $product',
                              fontSize: 18,
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
