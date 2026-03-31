import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/adaptive_learning_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class AdaptiveQuizPage extends StatefulWidget {
  const AdaptiveQuizPage({super.key});

  @override
  State<AdaptiveQuizPage> createState() => _AdaptiveQuizPageState();
}

class _AdaptiveQuizPageState extends State<AdaptiveQuizPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  late AdaptiveLearningService _adaptiveService;
  late AnimationController _feedbackController;
  late AnimationController _progressController;

  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  String _selectedCategory = 'math';
  List<AdaptiveQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _correctCount = 0;
  bool _isAnswered = false;
  int? _selectedAnswer;
  bool _showResult = false;
  DifficultyLevel _currentLevel = DifficultyLevel.easy;
  DifficultyLevel? _newLevel;

  final List<Map<String, String>> _categories = [
    {'id': 'math', 'name': 'Math', 'emoji': '➕'},
    {'id': 'alphabet', 'name': 'Alphabet', 'emoji': '🔤'},
    {'id': 'numbers', 'name': 'Numbers', 'emoji': '🔢'},
    {'id': 'animals', 'name': 'Animals', 'emoji': '🦁'},
    {'id': 'colors', 'name': 'Colors', 'emoji': '🌈'},
  ];

  @override
  void initState() {
    super.initState();
    _adaptiveService = Get.put(AdaptiveLearningService());
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Home screen style animations
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
  }

  void _startQuiz() {
    _currentLevel = _adaptiveService.getDifficultyLevel(_selectedCategory);
    _questions = _adaptiveService.getAdaptiveQuestions(
      category: _selectedCategory,
      count: 50,
    );
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _correctCount = 0;
      _isAnswered = false;
      _selectedAnswer = null;
      _showResult = false;
      _newLevel = null;
    });

    if (_questions.isNotEmpty) {
      _speak(_questions[0].question);
    }
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _selectAnswer(int index) async {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
    });

    final question = _questions[_currentIndex];
    final isCorrect = index == question.correctIndex;

    if (isCorrect) {
      _correctCount++;
      _score += _getPointsForLevel(_currentLevel);
      _speak('Correct! Great job!');
    } else {
      _speak('Oops! The answer is ${question.correctAnswer}');
    }

    // Record attempt and check for level change
    final newLevel = await _adaptiveService.recordAttempt(
      category: _selectedCategory,
      isCorrect: isCorrect,
    );

    if (newLevel != _currentLevel) {
      _newLevel = newLevel;
      _currentLevel = newLevel;
    }

    _feedbackController.forward(from: 0);
  }

  int _getPointsForLevel(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy:
        return 10;
      case DifficultyLevel.medium:
        return 20;
      case DifficultyLevel.hard:
        return 30;
      case DifficultyLevel.expert:
        return 50;
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedAnswer = null;
        _newLevel = null;
      });
      _progressController.forward(from: 0);
      _speak(_questions[_currentIndex].question);
    } else {
      _showResults();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isAnswered = false;
        _selectedAnswer = null;
        _newLevel = null;
      });
      _progressController.forward(from: 0);
      _speak(_questions[_currentIndex].question);
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _correctCount = 0;
      _isAnswered = false;
      _selectedAnswer = null;
      _newLevel = null;
    });
    if (_questions.isNotEmpty) {
      _speak(_questions[0].question);
    }
  }

  // Progress bar widget like other screens
  Widget _buildProgressBar(int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                'Question ${_currentIndex + 1} / ${_questions.length} ($percentage%)',
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
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF56D97F),
              ),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _showResults() {
    setState(() {
      _showResult = true;
    });

    final accuracy = (_correctCount / _questions.length * 100).round();
    if (accuracy >= 80) {
      _speak('Excellent! You scored $accuracy percent!');
    } else if (accuracy >= 60) {
      _speak('Good job! You scored $accuracy percent!');
    } else {
      _speak('Keep practicing! You scored $accuracy percent!');
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _progressController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    _tts.stop();
    super.dispose();
  }

  // Home screen style floating bubbles
  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top =
              startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  // Home screen style AppBar
  PreferredSizeWidget _buildAppBar() {
    String title = 'Adaptive Quiz';
    if (_questions.isNotEmpty && !_showResult) {
      title = 'Quiz';
    } else if (_showResult) {
      title = 'Results';
    }

    return AppBar(
      elevation: 8,
      shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 22,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          // Vibrant kid-friendly gradient - Coral to Pink to Orange
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B6B), // Coral Red
              Color(0xFFFF8E53), // Orange
              Color(0xFFFFAA5A), // Light Orange
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x40FF6B6B),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.baloo2(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
      ),
      actions: [
        // Refresh button for quiz (direct reset like other screens)
        if (_questions.isNotEmpty && !_showResult)
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
            onPressed: _resetQuiz,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFf093fb),
              Color(0xFFf5576c),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating bubbles background
            ..._buildFloatingBubbles(),
            SafeArea(
              child: _questions.isEmpty
                  ? _buildCategorySelection()
                  : _showResult
                  ? _buildResultScreen()
                  : _buildQuizScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildCategorySelection() {
    // Home screen style gradients
    final cardGradients = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
      [const Color(0xFF56D97F), const Color(0xFF11998E)],
      [const Color(0xFFFF6EB4), const Color(0xFFFF9A9E)],
    ];

    return Column(
      children: [
        const SizedBox(height: 16),

        // Categories
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['id'];
              final performance = _adaptiveService.getPerformance(
                category['id']!,
              );
              final level = _adaptiveService.getDifficultyLevel(
                category['id']!,
              );
              final gradient = cardGradients[index % cardGradients.length];

              return AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final offset = index.isEven
                      ? _floatAnimation.value * 0.5
                      : -_floatAnimation.value * 0.5;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategory = category['id']!);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFFFE66D), width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circle (Home screen style)
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Circular emoji container (Home screen style)
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    category['emoji']!,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category['name']!,
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            level.name.toUpperCase(),
                                            style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (performance != null)
                                          Text(
                                            '${(performance.accuracy * 100).round()}% accuracy',
                                            style: GoogleFonts.nunito(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color(0xFF56D97F),
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Start Button
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667EEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Start Quiz',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizScreen() {
    final question = _questions[_currentIndex];
    final progressPercentage = ((_currentIndex + 1) / _questions.length * 100)
        .toInt();

    return Column(
      children: [
        // Progress Bar (like other screens)
        _buildProgressBar(progressPercentage),

        // Level Change Notification
        if (_newLevel != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Level changed to ${_newLevel!.name.toUpperCase()}!',
                    style: const TextStyle(
                      color: Colors.black87,
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
              if (question.imageEmoji != null)
                Text(
                  question.imageEmoji!,
                  style: const TextStyle(fontSize: 48),
                ),
              const SizedBox(height: 16),
              Text(
                question.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              if (question.hint != null && !_isAnswered) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      question.hint!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const Spacer(),

        // Options with Home screen style gradients
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(question.options.length, (index) {
              final isSelected = _selectedAnswer == index;
              final isCorrect = index == question.correctIndex;
              final showCorrect = _isAnswered && isCorrect;
              final showWrong = _isAnswered && isSelected && !isCorrect;

              // Home screen style gradients for options
              final optionGradients = [
                [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
                [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
                [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
                [const Color(0xFF56D97F), const Color(0xFF11998E)],
              ];
              final gradient = optionGradients[index % optionGradients.length];

              return AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final offset = index.isEven
                      ? _floatAnimation.value * 0.3
                      : -_floatAnimation.value * 0.3;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    TtsService.to.speak(_questions[_currentIndex].options[index]);
                    _selectAnswer(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: showCorrect
                          ? const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : showWrong
                          ? const LinearGradient(
                              colors: [Color(0xFFEF5350), Color(0xFFE57373)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (showCorrect
                                      ? Colors.green
                                      : showWrong
                                      ? Colors.red
                                      : gradient[0])
                                  .withValues(alpha: 0.4),
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
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: showCorrect
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      : showWrong
                                      ? const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      : Text(
                                          String.fromCharCode(65 + index),
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
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

        const SizedBox(height: 16),

        // Navigation Buttons (Previous & Next)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Previous Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentIndex > 0 ? _previousQuestion : null,
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  label: Text(
                    'Previous',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentIndex > 0
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    foregroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Next Button (disabled until answered)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAnswered ? _nextQuestion : null,
                  icon: Text(
                    _currentIndex < _questions.length - 1 ? 'Next' : 'Finish',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                  ),
                  label: Icon(
                    _currentIndex < _questions.length - 1
                        ? Icons.arrow_forward_ios
                        : Icons.check,
                    size: 18,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAnswered
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    foregroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultScreen() {
    final accuracy = (_correctCount / _questions.length * 100).round();
    final performance = _adaptiveService.getPerformance(_selectedCategory);

    return Column(
      children: [
        const Spacer(),

        // Result Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
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
              Text(
                accuracy >= 80 ? '🎉' : (accuracy >= 60 ? '👏' : '💪'),
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              Text(
                accuracy >= 80
                    ? 'Excellent!'
                    : (accuracy >= 60 ? 'Good Job!' : 'Keep Practicing!'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 24),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatBox('⭐', 'Score', '$_score'),
                  _buildStatBox(
                    '✅',
                    'Correct',
                    '$_correctCount/${_questions.length}',
                  ),
                  _buildStatBox('📊', 'Accuracy', '$accuracy%'),
                ],
              ),

              const SizedBox(height: 24),

              // Current Level
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(
                    _adaptiveService.getDifficultyColor(_currentLevel),
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Level: ',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(
                          _adaptiveService.getDifficultyColor(_currentLevel),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _currentLevel.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (performance != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Overall accuracy: ${(performance.accuracy * 100).round()}% (${performance.totalAttempts} attempts)',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ],
          ),
        ),

        const Spacer(),

        // Buttons
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _questions = [];
                      _showResult = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Change Category'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String emoji, String label, String value) {
    // Home screen style gradients for stat boxes
    final gradients = {
      '⭐': [const Color(0xFFFFAA5A), const Color(0xFFFF8E53)],
      '✅': [const Color(0xFF56D97F), const Color(0xFF11998E)],
      '📊': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    };
    final gradient =
        gradients[emoji] ?? [const Color(0xFF4ECDC4), const Color(0xFF44A08D)];

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 0.3),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
