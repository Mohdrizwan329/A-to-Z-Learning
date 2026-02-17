import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogicGamePage extends StatefulWidget {
  const LogicGamePage({super.key});

  @override
  State<LogicGamePage> createState() => _LogicGamePageState();
}

class _LogicGamePageState extends State<LogicGamePage> {
  final List<Map<String, dynamic>> _logicPuzzles = [
    {
      'question': 'What comes next?',
      'sequence': ['1', '2', '3', '4', '?'],
      'options': ['5', '6', '7', '8'],
      'answer': '5',
      'emoji': '🔢',
    },
    {
      'question': 'Find the pattern!',
      'sequence': ['🔴', '🔵', '🔴', '🔵', '?'],
      'options': ['🔴', '🟢', '🟡', '🔵'],
      'answer': '🔴',
      'emoji': '🎨',
    },
    {
      'question': 'What comes next?',
      'sequence': ['2', '4', '6', '8', '?'],
      'options': ['9', '10', '11', '12'],
      'answer': '10',
      'emoji': '➕',
    },
    {
      'question': 'Complete the pattern!',
      'sequence': ['🌙', '⭐', '🌙', '⭐', '?'],
      'options': ['☀️', '🌙', '🌟', '⭐'],
      'answer': '🌙',
      'emoji': '🌌',
    },
    {
      'question': 'What number is missing?',
      'sequence': ['5', '10', '15', '20', '?'],
      'options': ['22', '25', '30', '24'],
      'answer': '25',
      'emoji': '🧮',
    },
    {
      'question': 'Find the odd one out!',
      'sequence': ['🍎', '🍊', '🥕', '🍇', '🍌'],
      'options': ['🍎', '🥕', '🍊', '🍇'],
      'answer': '🥕',
      'emoji': '🔍',
    },
    {
      'question': 'What comes next?',
      'sequence': ['A', 'C', 'E', 'G', '?'],
      'options': ['H', 'I', 'J', 'K'],
      'answer': 'I',
      'emoji': '🔤',
    },
    {
      'question': 'Complete the pattern!',
      'sequence': ['🔺', '🔺🔺', '🔺🔺🔺', '?'],
      'options': ['🔺🔺🔺🔺', '🔺🔺', '🔺', '🔺🔺🔺🔺🔺'],
      'answer': '🔺🔺🔺🔺',
      'emoji': '📐',
    },
  ];

  int _currentPuzzleIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _shufflePuzzles();
  }

  void _shufflePuzzles() {
    _logicPuzzles.shuffle(Random());
  }

  void _selectAnswer(String answer) {
    if (_showResult) return;

    final puzzle = _logicPuzzles[_currentPuzzleIndex];
    final correct = answer == puzzle['answer'];

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _isCorrect = correct;
      if (correct) {
        _score += 10;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentPuzzleIndex < _logicPuzzles.length - 1) {
        setState(() {
          _currentPuzzleIndex++;
          _selectedAnswer = null;
          _showResult = false;
        });
      } else {
        _showWinDialog();
      }
    });
  }

  void _showWinDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🧠", style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Logic Master!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 12),
            Text('Score: $_score points', style: const TextStyle(fontSize: 18)),
            Text(
              'You solved ${_score ~/ 10} puzzles correctly!',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back();
                setState(() {
                  _currentPuzzleIndex = 0;
                  _score = 0;
                  _selectedAnswer = null;
                  _showResult = false;
                });
                _shufflePuzzles();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
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
    final puzzle = _logicPuzzles[_currentPuzzleIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
              "Logic Games",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress and Score
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Puzzle ${_currentPuzzleIndex + 1}/${_logicPuzzles.length}',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '⭐ $_score',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Question Card
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      puzzle['emoji'],
                      style: const TextStyle(fontSize: 50),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      puzzle['question'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5CF6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Sequence display
                    Wrap(
                      spacing: 8,
                      children: (puzzle['sequence'] as List<String>).map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: item == '?'
                                ? const Color(0xFFFFE66D)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: item == '?'
                                ? Border.all(color: const Color(0xFFFFA94D), width: 2)
                                : null,
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: item.length > 2 ? 16 : 22,
                              fontWeight: FontWeight.bold,
                              color: item == '?'
                                  ? const Color(0xFFFFA94D)
                                  : Colors.grey.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (_showResult) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle : Icons.cancel,
                            color: _isCorrect ? Colors.green : Colors.red,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isCorrect ? 'Correct!' : 'Try again!',
                            style: TextStyle(
                              color: _isCorrect ? Colors.green : Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Answer Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: (puzzle['options'] as List<String>).map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrectAnswer = option == puzzle['answer'];
                    Color bgColor;

                    if (_showResult && isSelected) {
                      bgColor = _isCorrect ? Colors.green : Colors.red;
                    } else if (_showResult && isCorrectAnswer) {
                      bgColor = Colors.green.shade400;
                    } else {
                      bgColor = Colors.white;
                    }

                    return GestureDetector(
                      onTap: () => _selectAnswer(option),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: option.length > 4 ? 14 : 22,
                              fontWeight: FontWeight.bold,
                              color: (_showResult && (isSelected || isCorrectAnswer))
                                  ? Colors.white
                                  : const Color(0xFF8B5CF6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),

              // Skip button
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () {
                    if (_currentPuzzleIndex < _logicPuzzles.length - 1) {
                      setState(() {
                        _currentPuzzleIndex++;
                        _selectedAnswer = null;
                        _showResult = false;
                      });
                    }
                  },
                  child: Text(
                    'Skip →',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
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
