import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/sight_words_controller/sight_words_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SightWordsDetailPage extends StatefulWidget {
  final int levelIndex;

  const SightWordsDetailPage({super.key, required this.levelIndex});

  @override
  State<SightWordsDetailPage> createState() => _SightWordsDetailPageState();
}

class _SightWordsDetailPageState extends State<SightWordsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late final SightWordsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SightWordsController>();
    controller.selectLevel(widget.levelIndex);
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levelName = controller.levels[widget.levelIndex]['name'] as String;
    final progressKey = SightWordsController.progressKeys[widget.levelIndex];
    final words = controller.levels[widget.levelIndex]['words'] as List<String>;

    return GradientScaffold(
      title: levelName,
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
            ProgressService.to.resetProgress(progressKey);
          },
        ),
      ],
      body: Column(
        children: [
          // Progress bar
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(progressKey) / 100;
            final progressString = ProgressService.to.getProgressString(
              progressKey,
            );
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
                          '$progressString learned',
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
          SizedBox(height: 8.h),
          // Words grid
          Expanded(
            child: Obx(() {
              ProgressService.to.completedItems[progressKey];
              return GridView.builder(
                padding: EdgeInsets.all(12.r),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10.r,
                  crossAxisSpacing: 10.r,
                  childAspectRatio: 1.0,
                ),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  final isLearned = controller.isWordLearned(index);
                  final gradient = isLearned
                      ? AppColors.cardGradients[7] // Green
                      : AppColors.getGradientForIndex(index);

                  return buildFloatingItem(
                    index: index,
                    child: GestureDetector(
                      onTap: () {
                        TtsService.to.speak(word);
                        controller.markWordLearned(index, word);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
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
                            // Decorative circles
                            Positioned(
                              top: -8.h,
                              right: -8.w,
                              child: Container(
                                width: 25.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -10.h,
                              left: -10.w,
                              child: Container(
                                width: 30.w,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            // Word text
                            Center(
                              child: Text(
                                word,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Checkmark for completed
                            if (isLearned)
                              Positioned(
                                top: 4.h,
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
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const SizedBox.shrink(),
    );
  }
}
