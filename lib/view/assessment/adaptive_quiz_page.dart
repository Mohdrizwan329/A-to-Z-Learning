import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/adaptive_learning_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  'Question ${_currentIndex + 1} / ${_questions.length} ($percentage%)',
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
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF56D97F),
              ),
              minHeight: 10.h,
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
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 22.r,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
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
              blurRadius: 15.r,
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
              blurRadius: 4.r,
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
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
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
        SizedBox(height: 16.h),

        // Categories
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFFFE66D), width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 8.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circle (Home screen style)
                        Positioned(
                          top: -10.h,
                          right: -10.w,
                          child: Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            children: [
                              // Circular emoji container (Home screen style)
                              Container(
                                width: 60.w,
                                height: 60.h,
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
                              SizedBox(width: 16.w),
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
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8.r,
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
                                        SizedBox(width: 8.w),
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
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Color(0xFF56D97F),
                                    size: 20.r,
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
          padding: EdgeInsets.all(20.r),
          child: SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667EEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 28.r),
                  SizedBox(width: 8.w),
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
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.amber.shade400,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8.w),
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
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20.r,
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
              SizedBox(height: 16.h),
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
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16.r,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 4.w),
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    TtsService.to.speak(
                      _questions[_currentIndex].options[index],
                    );
                    _selectAnswer(index);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
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
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (showCorrect
                                      ? Colors.green
                                      : showWrong
                                      ? Colors.red
                                      : gradient[0])
                                  .withValues(alpha: 0.4),
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
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: showCorrect
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24.r,
                                        )
                                      : showWrong
                                      ? Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 24.r,
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
                              SizedBox(width: 16.w),
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

        SizedBox(height: 16.h),

        // Navigation Buttons (Previous & Next)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              // Previous Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentIndex > 0 ? _previousQuestion : null,
                  icon: Icon(Icons.arrow_back_ios, size: 18.r),
                  label: Text(
                    'Previous',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentIndex > 0
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    foregroundColor: const Color(0xFF667EEA),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
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
                    size: 18.r,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAnswered
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    foregroundColor: const Color(0xFF667EEA),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),
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
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20.r,
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
              SizedBox(height: 16.h),
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
              SizedBox(height: 24.h),

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

              SizedBox(height: 24.h),

              // Current Level
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Color(
                    _adaptiveService.getDifficultyColor(_currentLevel),
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(
                          _adaptiveService.getDifficultyColor(_currentLevel),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
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
                SizedBox(height: 12.h),
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
          padding: EdgeInsets.all(20.r),
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
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: const Text('Change Category'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF667EEA),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            SizedBox(height: 4.h),
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
