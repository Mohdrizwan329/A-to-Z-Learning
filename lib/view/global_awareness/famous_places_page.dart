import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/famous_places_controller/famous_places_controller.dart';
import 'package:jiyan_learning/view/global_awareness/famous_places_detail_page.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class FamousPlacesPage extends StatefulWidget {
  const FamousPlacesPage({super.key});

  @override
  State<FamousPlacesPage> createState() => _FamousPlacesPageState();
}

class _FamousPlacesPageState extends State<FamousPlacesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FamousPlacesController controller = Get.put(FamousPlacesController());

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0, pulseMax: 1.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Famous Places',
      emoji: '🏛️',
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
                  ProgressService.kFamousPlaces,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kFamousPlaces,
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
                crossAxisCount: 2,
                mainAxisSpacing: 16.r,
                crossAxisSpacing: 16.r,
                childAspectRatio: 1.1,
              ),
              itemCount: controller.sections.length,
              itemBuilder: (context, index) {
                final section = controller.sections[index];
                final gradient = AppColors.getGradientForIndex(index);

                return Obx(() {
                  final isSelected = controller.expandedIndexes.contains(index);
                  final isCompleted = controller.isSectionCompleted(index);

                  return buildFloatingItem(
                    index: index,
                    child: GradientCard(
                      gradient: gradient,
                      isSelected: isSelected,
                      onTap: () {
                        TtsService.to.speak(section['title']);
                        controller.toggleExpanded(index);
                        Get.to(
                          () => FamousPlacesDetailPage(sectionIndex: index),
                        );
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 75.w,
                                    height: 75.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        section['emoji'],
                                        style: const TextStyle(fontSize: 35),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Flexible(
                                    child: Text(
                                      section['title'],
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
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
