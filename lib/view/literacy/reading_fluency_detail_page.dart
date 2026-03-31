import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/reading_fluency_controller/reading_fluency_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

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
    final levelName =
        controller.levels[widget.levelIndex]['name'] as String;
    final progressKey =
        ReadingFluencyController.progressKeys[widget.levelIndex];

    return GradientScaffold(
      title: levelName,
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
            final progressString =
                ProgressService.to.getProgressString(progressKey);
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
                        '$progressString stories read',
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          // Story content
          Expanded(
            child: Obx(() {
              final storyIndex = controller.currentStoryIndex.value;
              final stories = controller.currentStories;
              final currentStory = stories[storyIndex];
              final sentences =
                  currentStory['sentences'] as List<String>;
              final isReading = controller.isReading.value;
              final currentSentenceIdx =
                  controller.currentSentenceIndex.value;
              // Access for reactivity
              controller.completedSentences.length;
              ProgressService.to.completedItems[progressKey];

              return Column(
                children: [
                  // Story info card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(currentStory['emoji'],
                            style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(
                          currentStory['title'],
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF764BA2)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Read all button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: isReading
                          ? () => controller.stopReading()
                          : () => controller.readFullStory(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isReading
                                ? [
                                    const Color(0xFFFF6B6B),
                                    const Color(0xFFFF5252)
                                  ]
                                : [
                                    const Color(0xFF56D97F),
                                    const Color(0xFF43A047)
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: (isReading
                                      ? const Color(0xFFFF6B6B)
                                      : const Color(0xFF56D97F))
                                  .withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                isReading
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                size: 28,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              isReading
                                  ? "Stop Reading"
                                  : "Read Full Story",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Sentences list + navigation buttons
                  Expanded(
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: sentences.length + 1,
                      itemBuilder: (context, index) {
                        // Last item = navigation buttons
                        if (index == sentences.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.previousStory(),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFFAA5A).withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                                          const SizedBox(width: 4),
                                          Text("Previous",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.nextStory(),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF56D97F), Color(0xFF43A047)],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF56D97F).withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Next",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
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
                        final isCompleted = controller
                            .completedSentences
                            .contains(index);

                        return GestureDetector(
                          onTap: isReading
                              ? null
                              : () {
                                  TtsService.to.speak(sentences[index]);
                                  controller.readSentence(index);
                                },
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isCurrentSentence
                                  ? const Color(0xFFFFD700)
                                  : isCompleted
                                      ? Colors.green.shade100
                                      : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(16),
                              border: isCurrentSentence
                                  ? Border.all(
                                      color:
                                          const Color(0xFFFFAA00),
                                      width: 3)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? Colors.green
                                        : const Color(0xFF764BA2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? const Icon(Icons.check,
                                            color: Colors.white,
                                            size: 20)
                                        : Text(
                                            "${index + 1}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.bold),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
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
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const SizedBox.shrink(),
    );
  }
}
