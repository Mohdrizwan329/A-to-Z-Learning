import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/reading_fluency_controller/reading_fluency_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ReadingFluencyDetailPage extends StatefulWidget {
  final int levelIndex;

  const ReadingFluencyDetailPage({super.key, required this.levelIndex});

  @override
  State<ReadingFluencyDetailPage> createState() =>
      _ReadingFluencyDetailPageState();
}

class _ReadingFluencyDetailPageState extends State<ReadingFluencyDetailPage> {
  late final ReadingFluencyController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ReadingFluencyController>();
    controller.selectLevel(widget.levelIndex);
  }

  @override
  Widget build(BuildContext context) {
    final levelName = controller.levels[widget.levelIndex]['name'] as String;
    final progressKey =
        ReadingFluencyController.progressKeys[widget.levelIndex];

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
            controller.resetLevelProgress(widget.levelIndex);
            controller.selectLevel(widget.levelIndex);
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
                          '$progressString stories read',
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
          // Story content
          Expanded(
            child: Obx(() {
              final storyIndex = controller.currentStoryIndex.value;
              final stories = controller.currentStories;
              final currentStory = stories[storyIndex];
              final sentences = currentStory['sentences'] as List<String>;
              final isReading = controller.isReading.value;
              final currentSentenceIdx = controller.currentSentenceIndex.value;
              // Access for reactivity
              controller.completedSentences.length;
              ProgressService.to.completedItems[progressKey];

              return LayoutBuilder(
                // In landscape this slot is a couple of pixels shorter than the
                // story card needs, so it scrolls rather than overflowing.
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // A LayoutBuilder can sit inside another scrollable, where
                      // maxHeight is infinite; a minHeight of infinity
                      // is not a constraint anything can satisfy.
                      minHeight: constraints.maxHeight.isFinite
                          ? constraints.maxHeight
                          : 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Story info card
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  currentStory['emoji'],
                                  style: const TextStyle(fontSize: 40),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  currentStory['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF764BA2),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Read all button
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: GestureDetector(
                              onTap: isReading
                                  ? () => controller.stopReading()
                                  : () => controller.readFullStory(),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isReading
                                        ? [
                                            const Color(0xFFFF6B6B),
                                            const Color(0xFFFF5252),
                                          ]
                                        : [
                                            const Color(0xFF56D97F),
                                            const Color(0xFF43A047),
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (isReading
                                                  ? const Color(0xFFFF6B6B)
                                                  : const Color(0xFF56D97F))
                                              .withValues(alpha: 0.4),
                                      blurRadius: 8.r,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isReading ? Icons.stop : Icons.play_arrow,
                                      size: 28.r,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8.w),
                                    Flexible(
                                      child: Text(
                                        isReading
                                            ? "Stop Reading"
                                            : "Read Full Story",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Sentences list + navigation buttons
                        SizedBox(
                          // A share of the viewport rather than `Expanded`:
                          // `Expanded` inside a scroll view needs an `IntrinsicHeight`
                          // above it, and a scrollable cannot report an intrinsic
                          // height - it throws.
                          height: math.max(200.h, constraints.maxHeight * 0.55),
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: sentences.length + 1,
                            itemBuilder: (context, index) {
                              // Last item = navigation buttons
                              if (index == sentences.length) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: 4.h,
                                    bottom: 16.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              controller.previousStory(),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFAA5A),
                                                  Color(0xFFFF8E53),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFFFFAA5A,
                                                  ).withValues(alpha: 0.4),
                                                  blurRadius: 8.r,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.white,
                                                  size: 18.r,
                                                ),
                                                SizedBox(width: 4.w),
                                                Flexible(
                                                  child: Text(
                                                    "Previous",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => controller.nextStory(),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF56D97F),
                                                  Color(0xFF43A047),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF56D97F,
                                                  ).withValues(alpha: 0.4),
                                                  blurRadius: 8.r,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Next",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 4.w),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 18.r,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final isCurrentSentence =
                                  currentSentenceIdx == index && isReading;
                              final isCompleted = controller.completedSentences
                                  .contains(index);

                              return GestureDetector(
                                onTap: isReading
                                    ? null
                                    : () {
                                        TtsService.to.speak(sentences[index]);
                                        controller.readSentence(index);
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    color: isCurrentSentence
                                        ? const Color(0xFFFFD700)
                                        : isCompleted
                                        ? Colors.green.shade100
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: isCurrentSentence
                                        ? Border.all(
                                            color: const Color(0xFFFFAA00),
                                            width: 3,
                                          )
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 8.r,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36.w,
                                        height: 36.h,
                                        decoration: BoxDecoration(
                                          color: isCompleted
                                              ? Colors.green
                                              : const Color(0xFF764BA2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: isCompleted
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 20.r,
                                                )
                                              : Text(
                                                  "${index + 1}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          sentences[index],
                                          style: GoogleFonts.nunito(
                                            fontSize: 18,
                                            fontWeight: isCurrentSentence
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.volume_up,
                                        color: isCurrentSentence
                                            ? const Color(0xFFFFAA00)
                                            : Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const SizedBox.shrink(),
    );
  }
}
