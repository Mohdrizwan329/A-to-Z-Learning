import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/sentence_formation_controller/sentence_formation_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SentenceFormationDetailPage extends StatefulWidget {
  final int levelIndex;

  const SentenceFormationDetailPage({super.key, required this.levelIndex});

  @override
  State<SentenceFormationDetailPage> createState() =>
      _SentenceFormationDetailPageState();
}

class _SentenceFormationDetailPageState
    extends State<SentenceFormationDetailPage>
    with TickerProviderStateMixin {
  late final SentenceFormationController controller;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SentenceFormationController>();
    controller.selectLevel(widget.levelIndex);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levelName = controller.levels[widget.levelIndex]['name'] as String;
    final progressKey =
        SentenceFormationController.progressKeys[widget.levelIndex];

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
          onPressed: () async {
            await controller.resetLevelProgress(widget.levelIndex);
            controller.selectLevel(widget.levelIndex);
            setState(() {});
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
          SizedBox(height: 8.h),
          // Main content
          Expanded(
            child: Obx(() {
              final sentenceIndex = controller.currentSentenceIndex.value;
              final sentences = controller.currentSentences;
              final currentSentence = sentences[sentenceIndex];
              final showResult = controller.showResult.value;
              final isCorrect = controller.isCorrect.value;
              final selectedWords = controller.selectedWords;
              final availableWords = currentSentence['words'] as List<String>;
              // Access for reactivity
              ProgressService.to.completedItems[progressKey];

              return SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    // Emoji display card
                    AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFF6B6B,
                              ).withValues(alpha: 0.4),
                              blurRadius: 12.r,
                              offset: const Offset(0, 6),
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
                            Positioned(
                              bottom: -10.h,
                              left: -10.w,
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                currentSentence['emoji'],
                                style: const TextStyle(fontSize: 80),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Hint button (speaks the sentence)
                    GestureDetector(
                      onTap: () => controller.speakHint(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 28.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.volume_up,
                              size: 28.r,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.w),
                            Flexible(
                              child: Text(
                                "Listen to Hint",
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
                    SizedBox(height: 20.h),

                    // Selected words area (sentence being built)
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 70.h),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: showResult
                            ? Border.all(
                                color: isCorrect ? Colors.green : Colors.red,
                                width: 3,
                              )
                            : Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 2,
                              ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: selectedWords.isEmpty
                          ? Center(
                              child: Text(
                                "Tap words below to form a sentence",
                                style: GoogleFonts.nunito(
                                  color: Colors.grey.shade400,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Wrap(
                              spacing: 8.r,
                              runSpacing: 8.r,
                              children: List.generate(
                                selectedWords.length,
                                (index) => GestureDetector(
                                  onTap: showResult
                                      ? null
                                      : () => controller.removeWord(index),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF667EEA),
                                          Color(0xFF764BA2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF667EEA,
                                          ).withValues(alpha: 0.3),
                                          blurRadius: 4.r,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          selectedWords[index],
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (!showResult) ...[
                                          SizedBox(width: 6.w),
                                          Icon(
                                            Icons.close,
                                            color: Colors.white70,
                                            size: 16.r,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20.h),

                    // Available words to tap
                    if (!showResult || !isCorrect)
                      Wrap(
                        spacing: 10.r,
                        runSpacing: 10.r,
                        alignment: WrapAlignment.center,
                        children: availableWords.map((word) {
                          final isUsed = selectedWords.contains(word);
                          return GestureDetector(
                            onTap: (showResult || isUsed)
                                ? null
                                : () {
                                    TtsService.to.speak(word);
                                    controller.selectWord(word);
                                  },
                            child: AnimatedOpacity(
                              opacity: isUsed ? 0.4 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isUsed
                                      ? Colors.grey.shade300
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: isUsed
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 6.r,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                ),
                                child: Text(
                                  word,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isUsed
                                        ? Colors.grey.shade500
                                        : const Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    SizedBox(height: 20.h),

                    // Result message
                    if (showResult)
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value * 0.3),
                            child: child,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCorrect
                                  ? [
                                      const Color(0xFF56D97F),
                                      const Color(0xFF43A047),
                                    ]
                                  : [
                                      const Color(0xFFFF6B6B),
                                      const Color(0xFFFF5252),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isCorrect
                                            ? const Color(0xFF56D97F)
                                            : const Color(0xFFFF6B6B))
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
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: Colors.white,
                                size: 30.r,
                              ),
                              SizedBox(width: 10.w),
                              Flexible(
                                child: Text(
                                  isCorrect
                                      ? "Correct! Well done!"
                                      : "Answer: ${currentSentence['sentence']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),

                    // Action buttons
                    if (!showResult)
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: selectedWords.isNotEmpty
                              ? () => controller.checkSentence()
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: selectedWords.isNotEmpty
                                    ? [
                                        const Color(0xFF56D97F),
                                        const Color(0xFF43A047),
                                      ]
                                    : [
                                        Colors.grey.shade400,
                                        Colors.grey.shade500,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: selectedWords.isNotEmpty
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF56D97F,
                                        ).withValues(alpha: 0.4),
                                        blurRadius: 8.r,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "Check Sentence",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (showResult)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.resetCurrent(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFAA5A),
                                      Color(0xFFFF8E53),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
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
                                child: Center(
                                  child: Text(
                                    "Try Again",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.nextSentence(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF56D97F),
                                      Color(0xFF43A047),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
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
                                child: Center(
                                  child: Text(
                                    "Next",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 24.h),

                    // Previous / Next navigation buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.previousSentence(),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFAA5A),
                                    Color(0xFFFF8E53),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r),
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                        SizedBox(width: 16.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.nextSentence(),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF56D97F),
                                    Color(0xFF43A047),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r),
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
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
