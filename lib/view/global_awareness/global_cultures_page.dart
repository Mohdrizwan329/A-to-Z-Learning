import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/global_cultures_controller/global_cultures_controller.dart';
import 'package:jiyan_learning/view/global_awareness/global_cultures_detail_page.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class GlobalCulturesPage extends StatefulWidget {
  const GlobalCulturesPage({super.key});

  @override
  State<GlobalCulturesPage> createState() => _GlobalCulturesPageState();
}

class _GlobalCulturesPageState extends State<GlobalCulturesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final GlobalCulturesController controller = Get.put(
    GlobalCulturesController(),
  );

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Global Cultures',
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
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kGlobalCultures,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kGlobalCultures,
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
                  final isCompleted = controller.isSectionCompleted(index);

                  return buildFloatingItem(
                    index: index,
                    child: GestureDetector(
                      onTap: () {
                        TtsService.to.speak(section['title']);
                        controller.toggleExpanded(index);
                        Get.to(
                          () => GlobalCulturesDetailPage(sectionIndex: index),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: gradient[0].withValues(alpha: 0.4),
                              blurRadius: 8.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -15.h,
                              right: -15.w,
                              child: Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
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
                                    Text(
                                      section['title'],
                                      style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.1,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
