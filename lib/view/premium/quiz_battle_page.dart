import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'dart:async';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class QuizBattlePage extends StatefulWidget {
  const QuizBattlePage({Key? key}) : super(key: key);

  @override
  State<QuizBattlePage> createState() => _QuizBattlePageState();
}

class _QuizBattlePageState extends State<QuizBattlePage>
    with TickerProviderStateMixin {
  // Game State
  bool _gameStarted = false;
  bool _gameEnded = false;
  int _currentQuestion = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _timeLeft = 10;
  Timer? _timer;
  String _selectedCategory = 'math';
  String _difficulty = 'easy';

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _questions = [];
  int? _selectedAnswer;

  final Map<String, Color> categoryColors = {
    'math': Color(0xFFFF6B6B),
    'science': Color(0xFF4ECDC4),
    'gk': Color(0xFFFFAA5A),
    'english': Color(0xFFA78BFA),
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startGame() {
    _generateQuestions();
    setState(() {
      _gameStarted = true;
      _gameEnded = false;
      _currentQuestion = 0;
      _score = 0;
      _streak = 0;
      _maxStreak = 0;
      _selectedAnswer = null;
    });
    _startTimer();
  }

  void _generateQuestions() {
    _questions.clear();
    final random = Random();

    for (int i = 0; i < 10; i++) {
      switch (_selectedCategory) {
        case 'math':
          _questions.add(_generateMathQuestion(random));
          break;
        case 'science':
          _questions.add(_generateScienceQuestion(random));
          break;
        case 'gk':
          _questions.add(_generateGKQuestion(random));
          break;
        case 'english':
          _questions.add(_generateEnglishQuestion(random));
          break;
      }
    }
  }

  Map<String, dynamic> _generateMathQuestion(Random random) {
    int num1, num2, answer;
    String question;
    List<int> options;

    final maxNum = _difficulty == 'easy' ? 10 : (_difficulty == 'medium' ? 20 : 50);
    final operations = _difficulty == 'easy' ? ['+'] : ['+', '-', '×'];
    final op = operations[random.nextInt(operations.length)];

    num1 = random.nextInt(maxNum) + 1;
    num2 = random.nextInt(maxNum) + 1;

    switch (op) {
      case '+':
        answer = num1 + num2;
        question = '$num1 + $num2 = ?';
        break;
      case '-':
        if (num1 < num2) {
          final temp = num1;
          num1 = num2;
          num2 = temp;
        }
        answer = num1 - num2;
        question = '$num1 - $num2 = ?';
        break;
      case '×':
        num1 = random.nextInt(12) + 1;
        num2 = random.nextInt(12) + 1;
        answer = num1 * num2;
        question = '$num1 × $num2 = ?';
        break;
      default:
        answer = num1 + num2;
        question = '$num1 + $num2 = ?';
    }

    options = _generateOptions(answer, random);

    return {
      'question': question,
      'options': options,
      'answer': answer,
      'emoji': '🧮',
    };
  }

  List<int> _generateOptions(int answer, Random random) {
    final options = <int>{answer};
    while (options.length < 4) {
      final offset = random.nextInt(10) - 5;
      if (offset != 0) {
        options.add(answer + offset);
      }
    }
    return options.toList()..shuffle();
  }

  Map<String, dynamic> _generateScienceQuestion(Random random) {
    final questions = [
      {'q': 'What planet is known as the Red Planet?', 'a': 'Mars', 'opts': ['Mars', 'Venus', 'Jupiter', 'Saturn']},
      {'q': 'What is the largest organ in the human body?', 'a': 'Skin', 'opts': ['Skin', 'Heart', 'Liver', 'Brain']},
      {'q': 'What gas do plants breathe in?', 'a': 'Carbon Dioxide', 'opts': ['Carbon Dioxide', 'Oxygen', 'Nitrogen', 'Hydrogen']},
      {'q': 'How many legs does a spider have?', 'a': '8', 'opts': ['8', '6', '4', '10']},
      {'q': 'What is frozen water called?', 'a': 'Ice', 'opts': ['Ice', 'Steam', 'Vapor', 'Frost']},
      {'q': 'Which planet is closest to the Sun?', 'a': 'Mercury', 'opts': ['Mercury', 'Venus', 'Earth', 'Mars']},
      {'q': 'What do caterpillars turn into?', 'a': 'Butterfly', 'opts': ['Butterfly', 'Bee', 'Bird', 'Beetle']},
      {'q': 'What is the hardest natural substance?', 'a': 'Diamond', 'opts': ['Diamond', 'Gold', 'Iron', 'Silver']},
      {'q': 'How many bones are in the human body?', 'a': '206', 'opts': ['206', '106', '306', '156']},
      {'q': 'What animal is known as man\'s best friend?', 'a': 'Dog', 'opts': ['Dog', 'Cat', 'Horse', 'Rabbit']},
    ];

    final q = questions[random.nextInt(questions.length)];
    return {
      'question': q['q'],
      'options': (q['opts'] as List).cast<String>()..shuffle(),
      'answer': q['a'],
      'emoji': '🔬',
    };
  }

  Map<String, dynamic> _generateGKQuestion(Random random) {
    final questions = [
      {'q': 'What is the capital of India?', 'a': 'New Delhi', 'opts': ['New Delhi', 'Mumbai', 'Kolkata', 'Chennai']},
      {'q': 'How many colors are in a rainbow?', 'a': '7', 'opts': ['7', '5', '6', '8']},
      {'q': 'Which is the largest ocean?', 'a': 'Pacific', 'opts': ['Pacific', 'Atlantic', 'Indian', 'Arctic']},
      {'q': 'What is the national bird of India?', 'a': 'Peacock', 'opts': ['Peacock', 'Parrot', 'Eagle', 'Sparrow']},
      {'q': 'How many days are in a week?', 'a': '7', 'opts': ['7', '5', '6', '8']},
      {'q': 'What is the national animal of India?', 'a': 'Tiger', 'opts': ['Tiger', 'Lion', 'Elephant', 'Cow']},
      {'q': 'How many months have 31 days?', 'a': '7', 'opts': ['7', '6', '5', '4']},
      {'q': 'Which festival is known as the Festival of Lights?', 'a': 'Diwali', 'opts': ['Diwali', 'Holi', 'Eid', 'Christmas']},
      {'q': 'What is the currency of India?', 'a': 'Rupee', 'opts': ['Rupee', 'Dollar', 'Pound', 'Euro']},
      {'q': 'Which is the smallest continent?', 'a': 'Australia', 'opts': ['Australia', 'Europe', 'Antarctica', 'Africa']},
    ];

    final q = questions[random.nextInt(questions.length)];
    return {
      'question': q['q'],
      'options': (q['opts'] as List).cast<String>()..shuffle(),
      'answer': q['a'],
      'emoji': '🌍',
    };
  }

  Map<String, dynamic> _generateEnglishQuestion(Random random) {
    final questions = [
      {'q': 'What is the opposite of "Hot"?', 'a': 'Cold', 'opts': ['Cold', 'Warm', 'Cool', 'Wet']},
      {'q': 'What is the plural of "Child"?', 'a': 'Children', 'opts': ['Children', 'Childs', 'Childrens', 'Child']},
      {'q': 'What is the past tense of "Go"?', 'a': 'Went', 'opts': ['Went', 'Goed', 'Gone', 'Going']},
      {'q': 'Which word means "Happy"?', 'a': 'Joyful', 'opts': ['Joyful', 'Sad', 'Angry', 'Tired']},
      {'q': 'What is the opposite of "Big"?', 'a': 'Small', 'opts': ['Small', 'Large', 'Huge', 'Tall']},
      {'q': 'What is a baby dog called?', 'a': 'Puppy', 'opts': ['Puppy', 'Kitten', 'Calf', 'Cub']},
      {'q': 'What rhymes with "Cat"?', 'a': 'Bat', 'opts': ['Bat', 'Dog', 'Cup', 'Sun']},
      {'q': 'What is the opposite of "Day"?', 'a': 'Night', 'opts': ['Night', 'Morning', 'Evening', 'Afternoon']},
      {'q': 'Which is a verb?', 'a': 'Run', 'opts': ['Run', 'Beautiful', 'Red', 'Table']},
      {'q': 'What is a group of fish called?', 'a': 'School', 'opts': ['School', 'Herd', 'Flock', 'Pack']},
    ];

    final q = questions[random.nextInt(questions.length)];
    return {
      'question': q['q'],
      'options': (q['opts'] as List).cast<String>()..shuffle(),
      'answer': q['a'],
      'emoji': '📚',
    };
  }

  void _startTimer() {
    _timeLeft = _difficulty == 'easy' ? 15 : (_difficulty == 'medium' ? 10 : 7);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    setState(() {
      _streak = 0;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _nextQuestion();
    });
  }

  void _selectAnswer(dynamic answer) {
    if (_selectedAnswer != null) return;

    _timer?.cancel();
    final question = _questions[_currentQuestion];
    final correct = answer.toString() == question['answer'].toString();

    setState(() {
      _selectedAnswer = _questions[_currentQuestion]['options'].indexOf(answer);
      if (correct) {
        _score += 10 + (_streak * 2) + _timeLeft;
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
      } else {
        _streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
      });
      _startTimer();
    } else {
      _endGame();
    }
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _gameEnded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            _timer?.cancel();
            Get.back();
          },
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
          "Quiz Battle",
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
        child: _gameEnded
            ? _buildResultScreen()
            : (_gameStarted ? _buildQuizScreen() : _buildStartScreen()),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildStartScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Title Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: const Text("⚔️", style: TextStyle(fontSize: 80)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quiz Battle',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Test your knowledge and beat the clock!',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Category Selection
          _buildSectionTitle('Select Category'),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
          const SizedBox(height: 24),
          // Difficulty Selection
          _buildSectionTitle('Select Difficulty'),
          const SizedBox(height: 12),
          _buildDifficultySelector(),
          const SizedBox(height: 32),
          // Start Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: categoryColors[_selectedCategory],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'START BATTLE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'id': 'math', 'name': 'Math', 'icon': '🧮'},
      {'id': 'science', 'name': 'Science', 'icon': '🔬'},
      {'id': 'gk', 'name': 'GK', 'icon': '🌍'},
      {'id': 'english', 'name': 'English', 'icon': '📚'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _selectedCategory == cat['id'];
        final color = categoryColors[cat['id']]!;

        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat['id']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isSelected ? null : Border.all(color: Colors.white30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cat['icon']!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  cat['name']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDifficultySelector() {
    final difficulties = [
      {'id': 'easy', 'name': 'Easy', 'icon': '😊'},
      {'id': 'medium', 'name': 'Medium', 'icon': '😐'},
      {'id': 'hard', 'name': 'Hard', 'icon': '😤'},
    ];

    return Row(
      children: difficulties.map((diff) {
        final isSelected = _difficulty == diff['id'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _difficulty = diff['id']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: diff['id'] != 'hard' ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(diff['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    diff['name']!,
                    style: TextStyle(
                      color: isSelected ? Colors.black87 : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuizScreen() {
    final question = _questions[_currentQuestion];
    final color = categoryColors[_selectedCategory]!;

    return Column(
      children: [
        // Stats Bar
        _buildStatsBar(),
        // Timer
        _buildTimer(color),
        // Question
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        question['emoji'],
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question['question'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Options
                ...List.generate(question['options'].length, (index) {
                  final option = question['options'][index];
                  final isSelected = _selectedAnswer == index;
                  final isCorrectOption =
                      option.toString() == question['answer'].toString();

                  Color bgColor = Colors.white;
                  if (_selectedAnswer != null) {
                    if (isCorrectOption) {
                      bgColor = Colors.green;
                    } else if (isSelected) {
                      bgColor = Colors.red;
                    }
                  }

                  return GestureDetector(
                    onTap: () => _selectAnswer(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected && _selectedAnswer != null
                            ? null
                            : Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _selectedAnswer != null && isCorrectOption
                                  ? Colors.white
                                  : color.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  color: _selectedAnswer != null && isCorrectOption
                                      ? Colors.green
                                      : color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              option.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: _selectedAnswer != null &&
                                        (isCorrectOption || isSelected)
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (_selectedAnswer != null && isCorrectOption)
                            const Icon(Icons.check_circle, color: Colors.white),
                          if (_selectedAnswer != null &&
                              isSelected &&
                              !isCorrectOption)
                            const Icon(Icons.cancel, color: Colors.white),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Question', '${_currentQuestion + 1}/10'),
          _buildStatItem('Score', '$_score'),
          _buildStatItem('Streak', '🔥 $_streak'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimer(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: _timeLeft <= 3 ? Colors.red : Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            '$_timeLeft',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _timeLeft <= 3 ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / 200 * 100).clamp(0, 100).round();
    String grade;
    String emoji;
    Color gradeColor;

    if (percentage >= 90) {
      grade = 'EXCELLENT';
      emoji = '🏆';
      gradeColor = Colors.amber;
    } else if (percentage >= 70) {
      grade = 'GREAT';
      emoji = '⭐';
      gradeColor = Colors.green;
    } else if (percentage >= 50) {
      grade = 'GOOD';
      emoji = '👍';
      gradeColor = Colors.blue;
    } else {
      grade = 'KEEP TRYING';
      emoji = '💪';
      gradeColor = Colors.orange;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(
                grade,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'POINTS',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildResultStat('Max Streak', '🔥 $_maxStreak'),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  _buildResultStat('Accuracy', '$percentage%'),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _gameStarted = false;
                          _gameEnded = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Menu'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColors[_selectedCategory],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
