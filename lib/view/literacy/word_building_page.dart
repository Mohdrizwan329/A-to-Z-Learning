import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class WordBuildingPage extends StatefulWidget {
  const WordBuildingPage({super.key});

  @override
  State<WordBuildingPage> createState() => _WordBuildingPageState();
}

class _WordBuildingPageState extends State<WordBuildingPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentWordIndex = 0;
  List<String> selectedLetters = [];
  int score = 0;
  bool showResult = false;
  bool isCorrect = false;

  final List<Map<String, dynamic>> words = [
    {
      'word': 'CAT',
      'emoji': '🐱',
      'letters': ['C', 'A', 'T', 'D', 'O'],
    },
    {
      'word': 'DOG',
      'emoji': '🐕',
      'letters': ['D', 'O', 'G', 'P', 'I'],
    },
    {
      'word': 'SUN',
      'emoji': '☀️',
      'letters': ['S', 'U', 'N', 'A', 'M'],
    },
    {
      'word': 'HAT',
      'emoji': '🎩',
      'letters': ['H', 'A', 'T', 'E', 'R'],
    },
    {
      'word': 'BUS',
      'emoji': '🚌',
      'letters': ['B', 'U', 'S', 'C', 'K'],
    },
    {
      'word': 'PEN',
      'emoji': '🖊️',
      'letters': ['P', 'E', 'N', 'A', 'T'],
    },
    {
      'word': 'CUP',
      'emoji': '🥤',
      'letters': ['C', 'U', 'P', 'O', 'B'],
    },
    {
      'word': 'BAT',
      'emoji': '🦇',
      'letters': ['B', 'A', 'T', 'E', 'N'],
    },
    {
      'word': 'BED',
      'emoji': '🛏️',
      'letters': ['B', 'E', 'D', 'A', 'G'],
    },
    {
      'word': 'FAN',
      'emoji': '🪭',
      'letters': ['F', 'A', 'N', 'U', 'S'],
    },
    {
      'word': 'JAM',
      'emoji': '🍯',
      'letters': ['J', 'A', 'M', 'E', 'P'],
    },
    {
      'word': 'MAP',
      'emoji': '🗺️',
      'letters': ['M', 'A', 'P', 'E', 'T'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _shuffleLetters();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _shuffleLetters() {
    words[currentWordIndex]['letters'].shuffle();
  }

  void _selectLetter(String letter) {
    if (showResult) return;
    TtsService.to.speak(letter);
    setState(() {
      selectedLetters.add(letter);
      if (selectedLetters.length == words[currentWordIndex]['word'].length) {
        _checkAnswer();
      }
    });
  }

  void _removeLetter(int index) {
    if (showResult) return;
    setState(() => selectedLetters.removeAt(index));
  }

  void _checkAnswer() {
    final correctWord = words[currentWordIndex]['word'];
    isCorrect = selectedLetters.join() == correctWord;
    if (isCorrect) {
      score += 10;
      flutterTts.speak("Correct! ${words[currentWordIndex]['word']}");
    } else {
      flutterTts.speak("Try again!");
    }
    setState(() => showResult = true);
  }

  void _nextWord() {
    setState(() {
      if (currentWordIndex < words.length - 1) {
        currentWordIndex++;
      } else {
        currentWordIndex = 0;
      }
      selectedLetters.clear();
      showResult = false;
      _shuffleLetters();
    });
  }

  void _resetCurrent() {
    setState(() {
      selectedLetters.clear();
      showResult = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = words[currentWordIndex];
    final letters = List<String>.from(currentWord['letters']);

    return GradientScaffold(
      title: 'Word Building',
      emoji: '🔨',
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            "⭐ $score",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      body: SafeArea(
        child: LayoutBuilder(
          // Portrait-shaped content: in landscape the body is barely 300pt tall,
          // which is shorter than this column needs. Scroll when that happens and
          // stay exactly as before whenever there is room.
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                // The ConstrainedBox above forces this column to at least the
                // viewport height, so spreading the children fills the screen
                // the way the old Spacers did - without a flex child, which a
                // scroll view cannot lay out.
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Emoji and hint
                  Text(
                    currentWord['emoji'],
                    style: const TextStyle(fontSize: 80),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Build the word!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  // Selected letters area
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(currentWord['word'].length, (
                        index,
                      ) {
                        final hasLetter = index < selectedLetters.length;
                        return GestureDetector(
                          onTap: hasLetter ? () => _removeLetter(index) : null,
                          child: Container(
                            width: 50.w,
                            height: 60.h,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: showResult
                                  ? (isCorrect
                                        ? Colors.green.shade100
                                        : Colors.red.shade100)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: showResult
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                hasLetter ? selectedLetters[index] : "",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: showResult
                                      ? (isCorrect ? Colors.green : Colors.red)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Available letters
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12.r,
                    runSpacing: 12.r,
                    children: letters.map((letter) {
                      final isUsed =
                          selectedLetters.contains(letter) &&
                          selectedLetters.where((l) => l == letter).length >=
                              letters.where((l) => l == letter).length;
                      return GestureDetector(
                        onTap: isUsed ? null : () => _selectLetter(letter),
                        child: Container(
                          width: 55.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isUsed
                                  ? [Colors.grey.shade400, Colors.grey.shade500]
                                  : [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 6.r,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: isUsed
                                    ? Colors.grey.shade600
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                  // Action buttons
                  if (showResult)
                    Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _resetCurrent,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: const Text(
                                "Try Again",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _nextWord,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF56D97F),
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: const Text(
                                "Next Word",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
