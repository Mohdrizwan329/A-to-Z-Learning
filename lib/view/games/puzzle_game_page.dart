import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class PuzzleGamePage extends StatefulWidget {
  const PuzzleGamePage({super.key});

  @override
  State<PuzzleGamePage> createState() => _PuzzleGamePageState();
}

class _PuzzleGamePageState extends State<PuzzleGamePage> {
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

  @override
  void initState() {
    super.initState();
    _setupPuzzle();
  }

  void _setupPuzzle() {
    final puzzle = _puzzles[_currentPuzzleIndex];
    final letters = List<String>.from(puzzle['letters']);
    letters.shuffle(Random());

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
    letters.shuffle(Random());

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🏆", style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Puzzle Master!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA78BFA),
              ),
            ),
            const SizedBox(height: 8),
            Text('Score: $_score points', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
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

  @override
  Widget build(BuildContext context) {
    final puzzle = _puzzles[_currentPuzzleIndex];

    return GradientScaffold(
      title: 'Spell the Word',
      appBarGradient: const [
        Color(0xFFFF6B6B),
        Color(0xFFFF8E53),
        Color(0xFFFFAA5A),
      ],
      bodyGradient: const [
        Color(0xFF667EEA),
        Color(0xFF764BA2),
        Color(0xFFf093fb),
        Color(0xFFf5576c),
      ],
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
          onPressed: _resetAllProgress,
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Puzzle ${_currentPuzzleIndex + 1}/${_puzzles.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Score: $_score',
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
                    value: (_currentPuzzleIndex + 1) / _puzzles.length,
                    minHeight: 10,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Emoji and hint card - styled like home screen (increased height +30)
          Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA78BFA).withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative circle
                Positioned(
                  top: -15,
                  right: -15,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          puzzle['emoji'],
                          style: const TextStyle(fontSize: 70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Spell this word!',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_isCorrect) ...[
                      const SizedBox(height: 12),
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

          const SizedBox(height: 24),

          // Selected letters (answer slots) - increased size
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(_selectedLetters.length, (index) {
                return GestureDetector(
                  onTap: () => _onSelectedTap(index),
                  child: Container(
                    width: 48,
                    height: 58,
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
                                    colors: [Colors.white, Colors.white],
                                  ))
                          : null,
                      color: _selectedLetters[index] == null
                          ? Colors.white.withValues(alpha: 0.3)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
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

          const SizedBox(height: 24),

          // Shuffled letters to choose from - styled like home screen cards (increased size)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(_shuffledLetters.length, (index) {
                if (_shuffledLetters[index].isEmpty) {
                  return const SizedBox(width: 55, height: 65);
                }
                return GestureDetector(
                  onTap: () => _onLetterTap(index),
                  child: Container(
                    width: 55,
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA78BFA).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circle
                        Positioned(
                          top: -8,
                          right: -8,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
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
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          // Clear button (shown when wrong answer)
          if (_isWrong)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: _resetCurrentPuzzle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.refresh, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                GestureDetector(
                  onTap: _currentPuzzleIndex > 0 ? _goToPrevious : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: _currentPuzzleIndex > 0
                          ? const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: _currentPuzzleIndex > 0
                          ? null
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _currentPuzzleIndex > 0
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF6B6B,
                                ).withValues(alpha: 0.4),
                                blurRadius: 8,
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
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Previous',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _currentPuzzleIndex > 0
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Next button (only enabled when correct)
                GestureDetector(
                  onTap:
                      (_isCorrect && _currentPuzzleIndex < _puzzles.length - 1)
                      ? _goToNext
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          (_isCorrect &&
                              _currentPuzzleIndex < _puzzles.length - 1)
                          ? const LinearGradient(
                              colors: [Color(0xFF56D97F), Color(0xFF4ECDC4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color:
                          (_isCorrect &&
                              _currentPuzzleIndex < _puzzles.length - 1)
                          ? null
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          (_isCorrect &&
                              _currentPuzzleIndex < _puzzles.length - 1)
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF56D97F,
                                ).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Next',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                (_isCorrect &&
                                    _currentPuzzleIndex < _puzzles.length - 1)
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color:
                              (_isCorrect &&
                                  _currentPuzzleIndex < _puzzles.length - 1)
                              ? Colors.white
                              : Colors.white54,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
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
