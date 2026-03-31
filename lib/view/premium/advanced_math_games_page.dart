import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class AdvancedMathGamesPage extends StatefulWidget {
  const AdvancedMathGamesPage({super.key});

  @override
  State<AdvancedMathGamesPage> createState() => _AdvancedMathGamesPageState();
}

class _AdvancedMathGamesPageState extends State<AdvancedMathGamesPage> {
  final Random _random = Random();
  int _score = 0;
  int _currentQuestion = 0;
  int _num1 = 0;
  int _num2 = 0;
  String _operator = '+';
  int _correctAnswer = 0;
  List<int> _options = [];
  bool _answered = false;
  int? _selectedAnswer;
  String _difficulty = 'Easy';


  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      _answered = false;
      _selectedAnswer = null;
      _currentQuestion++;

      // Adjust difficulty
      int maxNum = _difficulty == 'Easy' ? 20 : (_difficulty == 'Medium' ? 50 : 100);

      _num1 = _random.nextInt(maxNum) + 1;
      _num2 = _random.nextInt(maxNum) + 1;

      // Random operator
      List<String> operators = ['+', '-', '×'];
      if (_difficulty != 'Easy') operators.add('÷');
      _operator = operators[_random.nextInt(operators.length)];

      // Ensure valid division
      if (_operator == '÷') {
        _num1 = _num2 * (_random.nextInt(10) + 1);
      }

      // Ensure positive subtraction
      if (_operator == '-' && _num2 > _num1) {
        int temp = _num1;
        _num1 = _num2;
        _num2 = temp;
      }

      // Calculate answer
      switch (_operator) {
        case '+':
          _correctAnswer = _num1 + _num2;
          break;
        case '-':
          _correctAnswer = _num1 - _num2;
          break;
        case '×':
          _correctAnswer = _num1 * _num2;
          break;
        case '÷':
          _correctAnswer = _num1 ~/ _num2;
          break;
      }

      // Generate options
      _options = [_correctAnswer];
      while (_options.length < 4) {
        int option = _correctAnswer + _random.nextInt(21) - 10;
        if (option != _correctAnswer && option >= 0 && !_options.contains(option)) {
          _options.add(option);
        }
      }
      _options.shuffle();
    });
  }

  void _checkAnswer(int answer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (answer == _correctAnswer) {
        _score += _difficulty == 'Easy' ? 10 : (_difficulty == 'Medium' ? 20 : 30);
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentQuestion < 10) {
        _generateQuestion();
      } else {
        _showGameOverDialog();
      }
    });
  }

  void _showGameOverDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _score >= 200 ? "🏆" : (_score >= 100 ? "🌟" : "💪"),
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 16),
            Text(
              _score >= 200 ? 'Excellent!' : (_score >= 100 ? 'Great Job!' : 'Good Try!'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B6B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Score: $_score',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Exit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      setState(() {
                        _score = 0;
                        _currentQuestion = 0;
                      });
                      _generateQuestion();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Play Again'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          "Advanced Math",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text("⭐", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Difficulty selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Easy', 'Medium', 'Hard'].map((d) {
                      final isSelected = _difficulty == d;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _difficulty = d;
                            _score = 0;
                            _currentQuestion = 0;
                          });
                          _generateQuestion();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            d,
                            style: TextStyle(
                              color: isSelected ? Color(0xFF764BA2) : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                // Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(10, (index) {
                    return Container(
                      width: 28,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index < _currentQuestion
                            ? Colors.white
                            : Colors.white30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                // Question card
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Question $_currentQuestion/10',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '$_num1 $_operator $_num2 = ?',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Options
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      final isCorrect = option == _correctAnswer;
                      final isSelected = _selectedAnswer == option;

                      Color bgColor = Colors.white;
                      if (_answered) {
                        if (isCorrect) {
                          bgColor = Colors.green.shade400;
                        } else if (isSelected) {
                          bgColor = Colors.red.shade400;
                        }
                      }

                      return GestureDetector(
                        onTap: () {
                          TtsService.to.speak('$option');
                          _checkAnswer(option);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$option',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _answered && (isCorrect || isSelected)
                                    ? Colors.white
                                    : Color(0xFF333333),
                              ),
                            ),
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
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }
}
