import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class PuzzleGamePage extends StatefulWidget {
  const PuzzleGamePage({super.key});

  @override
  State<PuzzleGamePage> createState() => _PuzzleGamePageState();
}

class _PuzzleGamePageState extends State<PuzzleGamePage>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _puzzles = [
    // Animals
    {
      'emoji': '🐶',
      'name': 'Dog',
      'letters': ['D', 'O', 'G'],
    },
    {
      'emoji': '🐱',
      'name': 'Cat',
      'letters': ['C', 'A', 'T'],
    },
    {
      'emoji': '🐰',
      'name': 'Rabbit',
      'letters': ['R', 'A', 'B', 'B', 'I', 'T'],
    },
    {
      'emoji': '🦁',
      'name': 'Lion',
      'letters': ['L', 'I', 'O', 'N'],
    },
    {
      'emoji': '🐘',
      'name': 'Elephant',
      'letters': ['E', 'L', 'E', 'P', 'H', 'A', 'N', 'T'],
    },
    {
      'emoji': '🐻',
      'name': 'Bear',
      'letters': ['B', 'E', 'A', 'R'],
    },
    {
      'emoji': '🦊',
      'name': 'Fox',
      'letters': ['F', 'O', 'X'],
    },
    {
      'emoji': '🐼',
      'name': 'Panda',
      'letters': ['P', 'A', 'N', 'D', 'A'],
    },
    {
      'emoji': '🐯',
      'name': 'Tiger',
      'letters': ['T', 'I', 'G', 'E', 'R'],
    },
    {
      'emoji': '🦒',
      'name': 'Giraffe',
      'letters': ['G', 'I', 'R', 'A', 'F', 'F', 'E'],
    },
    {
      'emoji': '🦓',
      'name': 'Zebra',
      'letters': ['Z', 'E', 'B', 'R', 'A'],
    },
    {
      'emoji': '🐵',
      'name': 'Monkey',
      'letters': ['M', 'O', 'N', 'K', 'E', 'Y'],
    },
    {
      'emoji': '🐸',
      'name': 'Frog',
      'letters': ['F', 'R', 'O', 'G'],
    },
    {
      'emoji': '🐢',
      'name': 'Turtle',
      'letters': ['T', 'U', 'R', 'T', 'L', 'E'],
    },
    {
      'emoji': '🦋',
      'name': 'Butterfly',
      'letters': ['B', 'U', 'T', 'T', 'E', 'R', 'F', 'L', 'Y'],
    },
    {
      'emoji': '🐝',
      'name': 'Bee',
      'letters': ['B', 'E', 'E'],
    },
    {
      'emoji': '🐦',
      'name': 'Bird',
      'letters': ['B', 'I', 'R', 'D'],
    },
    {
      'emoji': '🦅',
      'name': 'Eagle',
      'letters': ['E', 'A', 'G', 'L', 'E'],
    },
    {
      'emoji': '🦆',
      'name': 'Duck',
      'letters': ['D', 'U', 'C', 'K'],
    },
    {
      'emoji': '🐔',
      'name': 'Chicken',
      'letters': ['C', 'H', 'I', 'C', 'K', 'E', 'N'],
    },
    {
      'emoji': '🐷',
      'name': 'Pig',
      'letters': ['P', 'I', 'G'],
    },
    {
      'emoji': '🐮',
      'name': 'Cow',
      'letters': ['C', 'O', 'W'],
    },
    {
      'emoji': '🐴',
      'name': 'Horse',
      'letters': ['H', 'O', 'R', 'S', 'E'],
    },
    {
      'emoji': '🐑',
      'name': 'Sheep',
      'letters': ['S', 'H', 'E', 'E', 'P'],
    },
    {
      'emoji': '🐐',
      'name': 'Goat',
      'letters': ['G', 'O', 'A', 'T'],
    },
    {
      'emoji': '🐟',
      'name': 'Fish',
      'letters': ['F', 'I', 'S', 'H'],
    },
    {
      'emoji': '🦈',
      'name': 'Shark',
      'letters': ['S', 'H', 'A', 'R', 'K'],
    },
    {
      'emoji': '🐳',
      'name': 'Whale',
      'letters': ['W', 'H', 'A', 'L', 'E'],
    },
    {
      'emoji': '🐙',
      'name': 'Octopus',
      'letters': ['O', 'C', 'T', 'O', 'P', 'U', 'S'],
    },
    {
      'emoji': '🦀',
      'name': 'Crab',
      'letters': ['C', 'R', 'A', 'B'],
    },
    // Fruits
    {
      'emoji': '🍎',
      'name': 'Apple',
      'letters': ['A', 'P', 'P', 'L', 'E'],
    },
    {
      'emoji': '🍌',
      'name': 'Banana',
      'letters': ['B', 'A', 'N', 'A', 'N', 'A'],
    },
    {
      'emoji': '🍊',
      'name': 'Orange',
      'letters': ['O', 'R', 'A', 'N', 'G', 'E'],
    },
    {
      'emoji': '🍇',
      'name': 'Grapes',
      'letters': ['G', 'R', 'A', 'P', 'E', 'S'],
    },
    {
      'emoji': '🍓',
      'name': 'Strawberry',
      'letters': ['S', 'T', 'R', 'A', 'W', 'B', 'E', 'R', 'R', 'Y'],
    },
    {
      'emoji': '🍉',
      'name': 'Watermelon',
      'letters': ['W', 'A', 'T', 'E', 'R', 'M', 'E', 'L', 'O', 'N'],
    },
    {
      'emoji': '🍋',
      'name': 'Lemon',
      'letters': ['L', 'E', 'M', 'O', 'N'],
    },
    {
      'emoji': '🍑',
      'name': 'Peach',
      'letters': ['P', 'E', 'A', 'C', 'H'],
    },
    {
      'emoji': '🍒',
      'name': 'Cherry',
      'letters': ['C', 'H', 'E', 'R', 'R', 'Y'],
    },
    {
      'emoji': '🥭',
      'name': 'Mango',
      'letters': ['M', 'A', 'N', 'G', 'O'],
    },
    {
      'emoji': '🍍',
      'name': 'Pineapple',
      'letters': ['P', 'I', 'N', 'E', 'A', 'P', 'P', 'L', 'E'],
    },
    {
      'emoji': '🥝',
      'name': 'Kiwi',
      'letters': ['K', 'I', 'W', 'I'],
    },
    // Vegetables
    {
      'emoji': '🥕',
      'name': 'Carrot',
      'letters': ['C', 'A', 'R', 'R', 'O', 'T'],
    },
    {
      'emoji': '🥒',
      'name': 'Cucumber',
      'letters': ['C', 'U', 'C', 'U', 'M', 'B', 'E', 'R'],
    },
    {
      'emoji': '🍅',
      'name': 'Tomato',
      'letters': ['T', 'O', 'M', 'A', 'T', 'O'],
    },
    {
      'emoji': '🥔',
      'name': 'Potato',
      'letters': ['P', 'O', 'T', 'A', 'T', 'O'],
    },
    {
      'emoji': '🧅',
      'name': 'Onion',
      'letters': ['O', 'N', 'I', 'O', 'N'],
    },
    {
      'emoji': '🌽',
      'name': 'Corn',
      'letters': ['C', 'O', 'R', 'N'],
    },
    // Nature
    {
      'emoji': '🌸',
      'name': 'Flower',
      'letters': ['F', 'L', 'O', 'W', 'E', 'R'],
    },
    {
      'emoji': '🌲',
      'name': 'Tree',
      'letters': ['T', 'R', 'E', 'E'],
    },
    {
      'emoji': '🌻',
      'name': 'Sunflower',
      'letters': ['S', 'U', 'N', 'F', 'L', 'O', 'W', 'E', 'R'],
    },
    {
      'emoji': '🌹',
      'name': 'Rose',
      'letters': ['R', 'O', 'S', 'E'],
    },
    {
      'emoji': '🍃',
      'name': 'Leaf',
      'letters': ['L', 'E', 'A', 'F'],
    },
    {
      'emoji': '☀️',
      'name': 'Sun',
      'letters': ['S', 'U', 'N'],
    },
    {
      'emoji': '🌙',
      'name': 'Moon',
      'letters': ['M', 'O', 'O', 'N'],
    },
    {
      'emoji': '⭐',
      'name': 'Star',
      'letters': ['S', 'T', 'A', 'R'],
    },
    {
      'emoji': '🌈',
      'name': 'Rainbow',
      'letters': ['R', 'A', 'I', 'N', 'B', 'O', 'W'],
    },
    {
      'emoji': '☁️',
      'name': 'Cloud',
      'letters': ['C', 'L', 'O', 'U', 'D'],
    },
  ];

  int _currentPuzzleIndex = 0;
  List<String> _shuffledLetters = [];
  List<String?> _selectedLetters = [];
  int _score = 0;
  bool _isCorrect = false;
  bool _isWrong = false;

  // Animation controllers (home screen style)
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Float animation for cards (3s, reverse)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Bubble animation (8s, repeat)
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _setupPuzzle();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _setupPuzzle() {
    final puzzle = _puzzles[_currentPuzzleIndex];
    final letters = List<String>.from(puzzle['letters']);
    letters.shuffle(math.Random());

    setState(() {
      _shuffledLetters = List<String>.from(letters);
      _selectedLetters = List<String?>.filled(puzzle['letters'].length, null);
      _isCorrect = false;
      _isWrong = false;
    });
  }

  void _resetCurrentPuzzle() {
    final puzzle = _puzzles[_currentPuzzleIndex];
    final letters = List<String>.from(puzzle['letters']);
    letters.shuffle(math.Random());

    setState(() {
      _shuffledLetters = List<String>.from(letters);
      _selectedLetters = List<String?>.filled(puzzle['letters'].length, null);
      _isCorrect = false;
      _isWrong = false;
    });
  }

  void _resetAllProgress() {
    setState(() {
      _currentPuzzleIndex = 0;
      _score = 0;
    });
    _setupPuzzle();
  }

  void _onLetterTap(int index) {
    if (_shuffledLetters[index].isEmpty) return;
    TtsService.to.speak(_shuffledLetters[index]);

    int emptySlot = _selectedLetters.indexOf(null);
    if (emptySlot == -1) return;

    setState(() {
      _selectedLetters[emptySlot] = _shuffledLetters[index];
      _shuffledLetters[index] = '';
    });

    if (!_selectedLetters.contains(null)) {
      _checkAnswer();
    }
  }

  void _onSelectedTap(int index) {
    if (_selectedLetters[index] == null) return;

    int emptySlot = _shuffledLetters.indexOf('');
    if (emptySlot != -1) {
      setState(() {
        _shuffledLetters[emptySlot] = _selectedLetters[index]!;
        _selectedLetters[index] = null;
      });
    }
  }

  void _checkAnswer() {
    final puzzle = _puzzles[_currentPuzzleIndex];
    final correctLetters = puzzle['letters'] as List<String>;

    bool isCorrect = true;
    for (int i = 0; i < correctLetters.length; i++) {
      if (_selectedLetters[i] != correctLetters[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      setState(() {
        _isCorrect = true;
        _isWrong = false;
        _score += 10;
      });
    } else {
      setState(() {
        _isWrong = true;
      });
    }
  }

  void _showWinDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🏆", style: TextStyle(fontSize: 60)),
            SizedBox(height: 16.h),
            const Text(
              'Puzzle Master!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA78BFA),
              ),
            ),
            SizedBox(height: 8.h),
            Text('Score: $_score points', style: const TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Get.back();
                setState(() {
                  _currentPuzzleIndex = 0;
                  _score = 0;
                });
                _setupPuzzle();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA78BFA),
                foregroundColor: Colors.white,
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = _puzzles[_currentPuzzleIndex];

    return GradientScaffold(
      title: 'Spell the Word',
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
          onPressed: _resetAllProgress,
        ),
      ],
      body: Stack(
        children: [
          // Floating bubbles background
          ..._buildFloatingBubbles(),

          // Main content
          LayoutBuilder(
            // Portrait-shaped content: in landscape, and with the keyboard up,
            // the body is shorter than this column needs. Scroll when that
            // happens and stay exactly as before whenever there is room.
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : 0,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Progress bar with percentage
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Puzzle ${_currentPuzzleIndex + 1}/${_puzzles.length}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Score: $_score',
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
                                value:
                                    (_currentPuzzleIndex + 1) / _puzzles.length,
                                minHeight: 10.h,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Emoji and hint card - with float animation
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: child,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(30.r),
                          margin: EdgeInsets.symmetric(horizontal: 24.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFA78BFA,
                                ).withValues(alpha: 0.4),
                                blurRadius: 8.r,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Decorative circle
                              Positioned(
                                top: -15.h,
                                right: -15.w,
                                child: Container(
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 130.w,
                                    height: 130.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        puzzle['emoji'],
                                        style: const TextStyle(fontSize: 70),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    'Spell this word!',
                                    style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_isCorrect) ...[
                                    SizedBox(height: 12.h),
                                    const Text(
                                      '✓ Correct!',
                                      style: TextStyle(
                                        color: Color(0xFFFFE66D),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Selected letters (answer slots) - increased size
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Wrap(
                          spacing: 10.r,
                          runSpacing: 10.r,
                          alignment: WrapAlignment.center,
                          children: List.generate(_selectedLetters.length, (
                            index,
                          ) {
                            return GestureDetector(
                              onTap: () => _onSelectedTap(index),
                              child: Container(
                                width: 48.w,
                                height: 58.h,
                                decoration: BoxDecoration(
                                  gradient: _selectedLetters[index] != null
                                      ? (_isCorrect
                                            ? const LinearGradient(
                                                colors: [
                                                  Color(0xFF56D97F),
                                                  Color(0xFF4ECDC4),
                                                ],
                                              )
                                            : const LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Colors.white,
                                                ],
                                              ))
                                      : null,
                                  color: _selectedLetters[index] == null
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : null,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _selectedLetters[index] ?? '',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: _isCorrect
                                          ? Colors.white
                                          : const Color(0xFFA78BFA),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const Spacer(),

                      // Shuffled letters to choose from - styled like home screen cards (increased size)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Wrap(
                          spacing: 12.r,
                          runSpacing: 12.r,
                          alignment: WrapAlignment.center,
                          children: List.generate(_shuffledLetters.length, (
                            index,
                          ) {
                            if (_shuffledLetters[index].isEmpty) {
                              return SizedBox(width: 55.w, height: 65.h);
                            }
                            return AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                final offset = index % 2 == 0
                                    ? _floatAnimation.value
                                    : -_floatAnimation.value;
                                return Transform.translate(
                                  offset: Offset(0, offset),
                                  child: child,
                                );
                              },
                              child: GestureDetector(
                                onTap: () => _onLetterTap(index),
                                child: Container(
                                  width: 55.w,
                                  height: 65.h,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFA78BFA),
                                        Color(0xFF8B5CF6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFA78BFA,
                                        ).withValues(alpha: 0.4),
                                        blurRadius: 8.r,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Decorative circle
                                      Positioned(
                                        top: -8.h,
                                        right: -8.w,
                                        child: Container(
                                          width: 20.w,
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(
                                              alpha: 0.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: 42.w,
                                          height: 42.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              _shuffledLetters[index],
                                              style: GoogleFonts.nunito(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Clear button (shown when wrong answer)
                      if (_isWrong)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: GestureDetector(
                            onTap: _resetCurrentPuzzle,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 14.h,
                              ),
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
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF6B6B,
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
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Clear & Try Again',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Next and Previous buttons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Previous button
                            Flexible(
                              child: GestureDetector(
                                onTap: _currentPuzzleIndex > 0
                                    ? _goToPrevious
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: _currentPuzzleIndex > 0
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFFFF6B6B),
                                              Color(0xFFFF8E53),
                                              Color(0xFFFFAA5A),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: _currentPuzzleIndex > 0
                                        ? null
                                        : Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: _currentPuzzleIndex > 0
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFFF6B6B,
                                              ).withValues(alpha: 0.4),
                                              blurRadius: 8.r,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios,
                                        color: _currentPuzzleIndex > 0
                                            ? Colors.white
                                            : Colors.white54,
                                        size: 18.r,
                                      ),
                                      SizedBox(width: 4.w),
                                      Flexible(
                                        child: Text(
                                          'Previous',
                                          style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _currentPuzzleIndex > 0
                                                ? Colors.white
                                                : Colors.white54,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Next button (only enabled when correct)
                            Flexible(
                              child: GestureDetector(
                                onTap:
                                    (_isCorrect &&
                                        _currentPuzzleIndex <
                                            _puzzles.length - 1)
                                    ? _goToNext
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient:
                                        (_isCorrect &&
                                            _currentPuzzleIndex <
                                                _puzzles.length - 1)
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF56D97F),
                                              Color(0xFF4ECDC4),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color:
                                        (_isCorrect &&
                                            _currentPuzzleIndex <
                                                _puzzles.length - 1)
                                        ? null
                                        : Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow:
                                        (_isCorrect &&
                                            _currentPuzzleIndex <
                                                _puzzles.length - 1)
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
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Next',
                                          style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                (_isCorrect &&
                                                    _currentPuzzleIndex <
                                                        _puzzles.length - 1)
                                                ? Colors.white
                                                : Colors.white54,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color:
                                            (_isCorrect &&
                                                _currentPuzzleIndex <
                                                    _puzzles.length - 1)
                                            ? Colors.white
                                            : Colors.white54,
                                        size: 18.r,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToPrevious() {
    if (_currentPuzzleIndex > 0) {
      setState(() {
        _currentPuzzleIndex--;
      });
      _setupPuzzle();
    }
  }

  void _goToNext() {
    if (_isCorrect && _currentPuzzleIndex < _puzzles.length - 1) {
      setState(() {
        _currentPuzzleIndex++;
      });
      _setupPuzzle();
    } else if (_isCorrect && _currentPuzzleIndex == _puzzles.length - 1) {
      _showWinDialog();
    }
  }
}
