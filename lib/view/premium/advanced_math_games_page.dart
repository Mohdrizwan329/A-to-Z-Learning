import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

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
      int maxNum = _difficulty == 'Easy'
          ? 20
          : (_difficulty == 'Medium' ? 50 : 100);

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
        if (option != _correctAnswer &&
            option >= 0 &&
            !_options.contains(option)) {
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
        _score += _difficulty == 'Easy'
            ? 10
            : (_difficulty == 'Medium' ? 20 : 30);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _score >= 200 ? "🏆" : (_score >= 100 ? "🌟" : "💪"),
              style: const TextStyle(fontSize: 60),
            ),
            SizedBox(height: 16.h),
            Text(
              _score >= 200
                  ? 'Excellent!'
                  : (_score >= 100 ? 'Great Job!' : 'Good Try!'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B6B),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.h),
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
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('Exit'),
                  ),
                ),
                SizedBox(width: 12.w),
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
                        borderRadius: BorderRadius.circular(12.r),
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
                blurRadius: 10.r,
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
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                const Text("⭐", style: TextStyle(fontSize: 16)),
                SizedBox(width: 4.w),
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
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: LayoutBuilder(
              // Portrait-shaped content: in landscape the body is barely 300pt tall,
              // which is shorter than this column needs. Scroll when that happens and
              // stay exactly as before whenever there is room.
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Difficulty selector
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: ['Easy', 'Medium', 'Hard'].map((d) {
                            final isSelected = _difficulty == d;
                            // Equal shares: the three chips are wider than the
                            // card once the reader turns their font size up.
                            return Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _difficulty = d;
                                    _score = 0;
                                    _currentQuestion = 0;
                                  });
                                  _generateQuestion();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Color(0xFF764BA2)
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Progress
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(10, (index) {
                            return Container(
                              width: 28.w,
                              height: 8.h,
                              margin: EdgeInsets.symmetric(horizontal: 2.w),
                              decoration: BoxDecoration(
                                color: index < _currentQuestion
                                    ? Colors.white
                                    : Colors.white30,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // Question card
                      Container(
                        padding: EdgeInsets.all(30.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20.r,
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
                            SizedBox(height: 20.h),
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
                      SizedBox(height: 30.h),
                      // Options
                      SizedBox(
                        // A share of the viewport rather than `Expanded`:
                        // `Expanded` inside a scroll view needs an `IntrinsicHeight`
                        // above it, and a scrollable cannot report an intrinsic
                        // height - it throws.
                        height: max(200.h, constraints.maxHeight * 0.55),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.r,
                                crossAxisSpacing: 16.r,
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
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8.r,
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
                                      color:
                                          _answered && (isCorrect || isSelected)
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
          ),
        ),
      ),
    );
  }
}
