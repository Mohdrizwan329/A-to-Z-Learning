import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'dart:async';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class RhythmLearningPage extends StatefulWidget {
  const RhythmLearningPage({super.key});

  @override
  State<RhythmLearningPage> createState() => _RhythmLearningPageState();
}

class _RhythmLearningPageState extends State<RhythmLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int currentPattern = 0;
  List<int> userTaps = [];
  bool isPlaying = false;
  bool showResult = false;
  bool isCorrect = false;
  int score = 0;
  int currentBeat = -1;

  final List<Map<String, dynamic>> rhythmPatterns = [
    {
      'name': 'Simple Beat',
      'emoji': '🥁',
      'pattern': [1, 0, 1, 0],
      'description': 'Tap on the colored beats',
      'difficulty': 'Easy',
    },
    {
      'name': 'Double Tap',
      'emoji': '👏',
      'pattern': [1, 1, 0, 1, 1, 0],
      'description': 'Two quick taps then pause',
      'difficulty': 'Easy',
    },
    {
      'name': 'Triple Beat',
      'emoji': '🎵',
      'pattern': [1, 1, 1, 0, 1, 0],
      'description': 'Three taps, pause, one tap',
      'difficulty': 'Medium',
    },
    {
      'name': 'Syncopation',
      'emoji': '🎶',
      'pattern': [1, 0, 1, 1, 0, 1, 0, 0],
      'description': 'Off-beat rhythm',
      'difficulty': 'Medium',
    },
    {
      'name': 'Complex Pattern',
      'emoji': '🎼',
      'pattern': [1, 0, 1, 0, 1, 1, 0, 1],
      'description': 'Mixed rhythm pattern',
      'difficulty': 'Hard',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _playPattern() async {
    if (isPlaying) return;
    TtsService.to.speak(rhythmPatterns[currentPattern]['name']);

    setState(() {
      isPlaying = true;
      userTaps.clear();
      showResult = false;
      currentBeat = -1;
    });

    final pattern = rhythmPatterns[currentPattern]['pattern'] as List<int>;

    for (int i = 0; i < pattern.length; i++) {
      setState(() => currentBeat = i);

      if (pattern[i] == 1) {
        _pulseController.forward().then((_) => _pulseController.reverse());
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      isPlaying = false;
      currentBeat = -1;
    });
  }

  void _onBeatTap(int index) {
    if (isPlaying || showResult) return;

    setState(() {
      if (userTaps.length <= index) {
        userTaps.add(1);
      }
    });

    _pulseController.forward().then((_) => _pulseController.reverse());

    final pattern = rhythmPatterns[currentPattern]['pattern'] as List<int>;
    if (userTaps.length == pattern.length) {
      _checkPattern();
    }
  }

  void _checkPattern() {
    final pattern = rhythmPatterns[currentPattern]['pattern'] as List<int>;
    bool correct = true;

    for (int i = 0; i < pattern.length; i++) {
      if (i >= userTaps.length || userTaps[i] != pattern[i]) {
        correct = false;
        break;
      }
    }

    setState(() {
      isCorrect = correct;
      showResult = true;
      if (correct) {
        score += 10;
        flutterTts.speak("Perfect rhythm!");
        // Mark pattern as completed
        ProgressService.to.markItemCompleted(
          ProgressService.kRhythm,
          currentPattern,
        );
      } else {
        flutterTts.speak("Try again!");
      }
    });
  }

  void _nextPattern() {
    setState(() {
      if (currentPattern < rhythmPatterns.length - 1) {
        currentPattern++;
      } else {
        currentPattern = 0;
      }
      userTaps.clear();
      showResult = false;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pattern = rhythmPatterns[currentPattern];
    final beats = pattern['pattern'] as List<int>;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Rhythm Learning",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
              ProgressService.to.resetProgress(ProgressService.kRhythm);
              setState(() {
                currentPattern = 0;
                score = 0;
                userTaps.clear();
                showResult = false;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress bar
              Obx(() {
                // Access observable to trigger rebuild
                final _ =
                    ProgressService.to.completedItems[ProgressService.kRhythm];
                final progress =
                    ProgressService.to.getProgressPercentage(
                      ProgressService.kRhythm,
                    ) /
                    100;
                final progressString = ProgressService.to.getProgressString(
                  ProgressService.kRhythm,
                );
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Pattern number indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "Pattern ${currentPattern + 1} of ${rhythmPatterns.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Pattern display card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.25),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Follow this pattern",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(beats.length, (index) {
                                final isBeat = beats[index] == 1;
                                final isCurrentBeat = currentBeat == index;

                                return AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    double scale = isCurrentBeat && isBeat
                                        ? _pulseAnimation.value
                                        : 1.0;
                                    return Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        width: 40.w,
                                        height: 40.h,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isBeat
                                              ? LinearGradient(
                                                  colors: isCurrentBeat
                                                      ? [
                                                          const Color(
                                                            0xFFFFD700,
                                                          ),
                                                          const Color(
                                                            0xFFFFA500,
                                                          ),
                                                        ]
                                                      : [
                                                          const Color(
                                                            0xFFFF6B6B,
                                                          ),
                                                          const Color(
                                                            0xFFFF8E53,
                                                          ),
                                                        ],
                                                )
                                              : null,
                                          color: isBeat
                                              ? null
                                              : Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                          shape: BoxShape.circle,
                                          border: isCurrentBeat
                                              ? Border.all(
                                                  color: Colors.white,
                                                  width: 3,
                                                )
                                              : Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1,
                                                ),
                                          boxShadow: isBeat
                                              ? [
                                                  BoxShadow(
                                                    color:
                                                        (isCurrentBeat
                                                                ? const Color(
                                                                    0xFFFFD700,
                                                                  )
                                                                : const Color(
                                                                    0xFFFF6B6B,
                                                                  ))
                                                            .withValues(
                                                              alpha: 0.4,
                                                            ),
                                                    blurRadius: 8.r,
                                                    spreadRadius: 2.r,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isBeat
                                                ? Icons.music_note
                                                : Icons.remove,
                                            color: isBeat
                                                ? Colors.white
                                                : Colors.white38,
                                            size: isBeat ? 20 : 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                            SizedBox(height: 20.h),
                            // Play button
                            GestureDetector(
                              onTap: isPlaying ? null : _playPattern,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isPlaying
                                        ? [Colors.grey, Colors.grey.shade600]
                                        : [
                                            const Color(0xFF56D97F),
                                            const Color(0xFF11998E),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(30.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (isPlaying
                                                  ? Colors.grey
                                                  : const Color(0xFF56D97F))
                                              .withValues(alpha: 0.4),
                                      blurRadius: 10.r,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPlaying
                                          ? Icons.hourglass_top
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Flexible(
                                      child: Text(
                                        isPlaying
                                            ? "Playing..."
                                            : "Play Pattern",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Your turn section
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: showResult
                                ? (isCorrect
                                      ? [
                                          Colors.green.withValues(alpha: 0.3),
                                          Colors.green.withValues(alpha: 0.1),
                                        ]
                                      : [
                                          Colors.orange.withValues(alpha: 0.3),
                                          Colors.orange.withValues(alpha: 0.1),
                                        ])
                                : [
                                    Colors.white.withValues(alpha: 0.15),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: showResult
                                ? (isCorrect ? Colors.green : Colors.orange)
                                      .withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              showResult
                                  ? (isCorrect ? "Perfect!" : "Try Again!")
                                  : "Your turn",
                              style: TextStyle(
                                color: showResult
                                    ? (isCorrect
                                          ? Colors.greenAccent
                                          : Colors.orangeAccent)
                                    : Colors.white70,
                                fontSize: 14,
                                fontWeight: showResult
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(beats.length, (index) {
                                final hasTapped = index < userTaps.length;
                                final tapped =
                                    hasTapped && userTaps[index] == 1;

                                return Container(
                                  width: 40.w,
                                  height: 40.h,
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    gradient: hasTapped && tapped
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF56D97F),
                                              Color(0xFF11998E),
                                            ],
                                          )
                                        : null,
                                    color: hasTapped
                                        ? (tapped
                                              ? null
                                              : Colors.white.withValues(
                                                  alpha: 0.2,
                                                ))
                                        : Colors.white.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: hasTapped
                                          ? (tapped
                                                ? Colors.greenAccent
                                                : Colors.white30)
                                          : Colors.white.withValues(alpha: 0.2),
                                      width: hasTapped && tapped ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: hasTapped
                                        ? Icon(
                                            tapped
                                                ? Icons.music_note
                                                : Icons.remove,
                                            color: tapped
                                                ? Colors.white
                                                : Colors.white38,
                                            size: tapped ? 20 : 16,
                                          )
                                        : const SizedBox(),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // Drum tap area
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: GestureDetector(
                          onTap: () => _onBeatTap(userTaps.length),
                          child: Container(
                            width: 150.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                  Color(0xFFFFAA5A),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.5),
                                  blurRadius: 25.r,
                                  spreadRadius: 5.r,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "TAP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text("🥁", style: TextStyle(fontSize: 50)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Action buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Skip button
                          Flexible(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (!isPlaying && !showResult) {
                                  setState(() {
                                    userTaps.add(0);
                                  });
                                  final pattern =
                                      rhythmPatterns[currentPattern]['pattern']
                                          as List<int>;
                                  if (userTaps.length == pattern.length) {
                                    _checkPattern();
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.skip_next,
                                      color: Colors.white,
                                      size: 20.r,
                                    ),
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Text(
                                        "Skip Beat",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
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
                          // Reset button
                          Flexible(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  userTaps.clear();
                                  showResult = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.replay,
                                      color: Colors.white,
                                      size: 20.r,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Retry",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Next button (only when result is shown and correct)
                      if (showResult && isCorrect)
                        GestureDetector(
                          onTap: _nextPattern,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF56D97F), Color(0xFF11998E)],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    0xFF56D97F,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Next Pattern",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
