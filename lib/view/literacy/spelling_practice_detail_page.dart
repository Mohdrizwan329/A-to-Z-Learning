import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/spelling_practice_controller/spelling_practice_controller.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class SpellingPracticeDetailPage extends StatefulWidget {
  final int levelIndex;

  const SpellingPracticeDetailPage({super.key, required this.levelIndex});

  @override
  State<SpellingPracticeDetailPage> createState() =>
      _SpellingPracticeDetailPageState();
}

class _SpellingPracticeDetailPageState extends State<SpellingPracticeDetailPage>
    with TickerProviderStateMixin {
  late final SpellingPracticeController controller;
  final TextEditingController _textController = TextEditingController();
  String userInput = "";

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SpellingPracticeController>();
    controller.selectLevel(widget.levelIndex);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  void _checkSpelling() {
    controller.checkSpelling(userInput);
  }

  void _nextWord() {
    controller.nextWord();
    _textController.clear();
    setState(() => userInput = "");
  }

  void _resetCurrent() {
    controller.resetCurrent();
    _textController.clear();
    setState(() => userInput = "");
  }

  @override
  void dispose() {
    _textController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levelName =
        controller.levels[widget.levelIndex]['name'] as String;
    final progressKey =
        SpellingPracticeController.progressKeys[widget.levelIndex];

    return GradientScaffold(
      title: levelName,
      actions: [
        // Reset button
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
            _textController.clear();
            setState(() => userInput = "");
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
                        '$progressString spelled',
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
          // Main spelling content
          Expanded(
            child: Obx(() {
              final wordIndex = controller.currentWordIndex.value;
              final words = controller.currentWords;
              final currentWord = words[wordIndex];
              final showResult = controller.showResult.value;
              final isCorrect = controller.isCorrect.value;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Word counter
                    Text(
                      "Word ${wordIndex + 1} of ${words.length}",
                      style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),

                    // Emoji display card with float animation
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
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B6B)
                                  .withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -15,
                              right: -15,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: -10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(currentWord['emoji'],
                                  style: const TextStyle(fontSize: 100)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hint card
                    AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset:
                              Offset(0, -_floatAnimation.value * 0.5),
                          child: child,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lightbulb,
                                color: Colors.amber, size: 24),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                "Hint: ${currentWord['hint']}",
                                style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Listen button
                    AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset:
                              Offset(0, _floatAnimation.value * 0.3),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          TtsService.to.speak(currentWord['word']);
                          controller.speakWord(currentWord['word']);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFAA5A),
                                Color(0xFFFF8E53)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFAA5A)
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.volume_up,
                                  size: 28, color: Colors.white),
                              const SizedBox(width: 10),
                              Text("Listen to Word",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Text input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: showResult
                            ? Border.all(
                                color:
                                    isCorrect ? Colors.green : Colors.red,
                                width: 3)
                            : Border.all(
                                color:
                                    Colors.white.withValues(alpha: 0.5),
                                width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        enabled: !showResult,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                        textCapitalization:
                            TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: "Type the word",
                          hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 20,
                              letterSpacing: 1),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        onChanged: (value) =>
                            setState(() => userInput = value),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Result message
                    if (showResult)
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                0, _floatAnimation.value * 0.3),
                            child: child,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCorrect
                                  ? [
                                      const Color(0xFF56D97F),
                                      const Color(0xFF43A047)
                                    ]
                                  : [
                                      const Color(0xFFFF6B6B),
                                      const Color(0xFFFF5252)
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (isCorrect
                                        ? const Color(0xFF56D97F)
                                        : const Color(0xFFFF6B6B))
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                isCorrect
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  isCorrect
                                      ? "Correct! 🎉"
                                      : "Answer: ${currentWord['word']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Action buttons
                    if (!showResult)
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: userInput.isNotEmpty
                              ? _checkSpelling
                              : null,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: userInput.isNotEmpty
                                    ? [
                                        const Color(0xFF56D97F),
                                        const Color(0xFF43A047)
                                      ]
                                    : [
                                        Colors.grey.shade400,
                                        Colors.grey.shade500
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: userInput.isNotEmpty
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF56D97F)
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text("Check Spelling",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    if (showResult)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _resetCurrent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFAA5A),
                                      Color(0xFFFF8E53)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFAA5A)
                                          .withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text("Try Again",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: _nextWord,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF56D97F),
                                      Color(0xFF43A047)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF56D97F)
                                          .withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text("Next Word",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold)),
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
