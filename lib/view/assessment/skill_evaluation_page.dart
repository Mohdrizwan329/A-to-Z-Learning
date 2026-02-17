import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SkillEvaluationPage extends StatefulWidget {
  const SkillEvaluationPage({super.key});

  @override
  State<SkillEvaluationPage> createState() => _SkillEvaluationPageState();
}

class _SkillEvaluationPageState extends State<SkillEvaluationPage>
    with SingleTickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _storage = GetStorage();
  late AnimationController _animationController;

  bool _isEvaluating = false;
  bool _showResults = false;
  int _currentSkillIndex = 0;
  int _currentQuestionIndex = 0;
  Map<String, SkillResult> _results = {};

  final List<SkillCategory> _skills = [
    SkillCategory(
      id: 'numbers',
      name: 'Number Recognition',
      emoji: '🔢',
      color: 0xFF4CAF50,
      questions: [
        SkillQuestion(question: 'What number is this? 5', options: ['3', '5', '7', '9'], correctIndex: 1),
        SkillQuestion(question: 'Which is bigger: 8 or 3?', options: ['3', '8'], correctIndex: 1),
        SkillQuestion(question: 'Count: 🍎🍎🍎', options: ['2', '3', '4', '5'], correctIndex: 1),
        SkillQuestion(question: 'What comes after 6?', options: ['5', '6', '7', '8'], correctIndex: 2),
        SkillQuestion(question: 'Which is the smallest?', options: ['9', '2', '7', '5'], correctIndex: 1),
      ],
    ),
    SkillCategory(
      id: 'letters',
      name: 'Letter Recognition',
      emoji: '🔤',
      color: 0xFF2196F3,
      questions: [
        SkillQuestion(question: 'What letter is this? A', options: ['A', 'B', 'C', 'D'], correctIndex: 0),
        SkillQuestion(question: 'What comes after B?', options: ['A', 'B', 'C', 'D'], correctIndex: 2),
        SkillQuestion(question: 'Find the vowel:', options: ['B', 'C', 'E', 'D'], correctIndex: 2),
        SkillQuestion(question: 'Which is uppercase?', options: ['a', 'b', 'C', 'd'], correctIndex: 2),
        SkillQuestion(question: 'What letter starts "Apple"?', options: ['B', 'A', 'P', 'L'], correctIndex: 1),
      ],
    ),
    SkillCategory(
      id: 'math',
      name: 'Basic Math',
      emoji: '➕',
      color: 0xFFFF9800,
      questions: [
        SkillQuestion(question: '2 + 2 = ?', options: ['3', '4', '5', '6'], correctIndex: 1),
        SkillQuestion(question: '5 - 3 = ?', options: ['1', '2', '3', '4'], correctIndex: 1),
        SkillQuestion(question: '3 + 4 = ?', options: ['5', '6', '7', '8'], correctIndex: 2),
        SkillQuestion(question: '10 - 5 = ?', options: ['3', '4', '5', '6'], correctIndex: 2),
        SkillQuestion(question: '1 + 1 + 1 = ?', options: ['2', '3', '4', '5'], correctIndex: 1),
      ],
    ),
    SkillCategory(
      id: 'colors',
      name: 'Color Recognition',
      emoji: '🌈',
      color: 0xFFE91E63,
      questions: [
        SkillQuestion(question: 'What color is 🔴?', options: ['Blue', 'Red', 'Green', 'Yellow'], correctIndex: 1),
        SkillQuestion(question: 'What color is the sky?', options: ['Red', 'Green', 'Blue', 'Yellow'], correctIndex: 2),
        SkillQuestion(question: 'What color is 🟢?', options: ['Green', 'Blue', 'Red', 'Purple'], correctIndex: 0),
        SkillQuestion(question: 'What color is a banana?', options: ['Red', 'Blue', 'Green', 'Yellow'], correctIndex: 3),
        SkillQuestion(question: 'Mix red + blue = ?', options: ['Green', 'Orange', 'Purple', 'Brown'], correctIndex: 2),
      ],
    ),
    SkillCategory(
      id: 'shapes',
      name: 'Shape Recognition',
      emoji: '🔷',
      color: 0xFF9C27B0,
      questions: [
        SkillQuestion(question: 'How many sides has a triangle?', options: ['2', '3', '4', '5'], correctIndex: 1),
        SkillQuestion(question: 'What shape is ⭕?', options: ['Square', 'Circle', 'Triangle', 'Star'], correctIndex: 1),
        SkillQuestion(question: 'How many sides has a square?', options: ['3', '4', '5', '6'], correctIndex: 1),
        SkillQuestion(question: 'What shape is 🟥?', options: ['Circle', 'Triangle', 'Square', 'Star'], correctIndex: 2),
        SkillQuestion(question: 'Which has no corners?', options: ['Square', 'Triangle', 'Circle', 'Rectangle'], correctIndex: 2),
      ],
    ),
    SkillCategory(
      id: 'animals',
      name: 'Animal Knowledge',
      emoji: '🦁',
      color: 0xFF795548,
      questions: [
        SkillQuestion(question: 'What sound does a dog make?', options: ['Meow', 'Bark', 'Moo', 'Oink'], correctIndex: 1),
        SkillQuestion(question: 'Which animal has a trunk?', options: ['Lion', 'Dog', 'Elephant', 'Cat'], correctIndex: 2),
        SkillQuestion(question: 'Which can fly?', options: ['Fish', 'Dog', 'Bird', 'Cat'], correctIndex: 2),
        SkillQuestion(question: 'Which lives in water?', options: ['Dog', 'Cat', 'Bird', 'Fish'], correctIndex: 3),
        SkillQuestion(question: 'What does a cow give?', options: ['Eggs', 'Milk', 'Wool', 'Honey'], correctIndex: 1),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initTts();
    _loadPreviousResults();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
  }

  void _loadPreviousResults() {
    final data = _storage.read('skill_evaluation_results');
    if (data != null) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data);
      _results = map.map((key, value) =>
          MapEntry(key, SkillResult.fromJson(Map<String, dynamic>.from(value))));
    }
  }

  Future<void> _saveResults() async {
    await _storage.write(
      'skill_evaluation_results',
      _results.map((key, value) => MapEntry(key, value.toJson())),
    );
  }

  void _startEvaluation() {
    setState(() {
      _isEvaluating = true;
      _showResults = false;
      _currentSkillIndex = 0;
      _currentQuestionIndex = 0;
      _results = {};
    });
    _speak('Let\'s test your skills!');
    _speakCurrentQuestion();
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _speakCurrentQuestion() {
    if (_currentSkillIndex < _skills.length) {
      final skill = _skills[_currentSkillIndex];
      if (_currentQuestionIndex < skill.questions.length) {
        _speak(skill.questions[_currentQuestionIndex].question);
      }
    }
  }

  void _answerQuestion(int selectedIndex) {
    final skill = _skills[_currentSkillIndex];
    final question = skill.questions[_currentQuestionIndex];
    final isCorrect = selectedIndex == question.correctIndex;

    // Update results
    if (!_results.containsKey(skill.id)) {
      _results[skill.id] = SkillResult(
        skillId: skill.id,
        skillName: skill.name,
        totalQuestions: skill.questions.length,
        correctAnswers: 0,
        evaluatedAt: DateTime.now(),
      );
    }

    if (isCorrect) {
      _results[skill.id] = _results[skill.id]!.copyWith(
        correctAnswers: _results[skill.id]!.correctAnswers + 1,
      );
      _speak('Correct!');
    } else {
      _speak('Oops! The answer is ${question.options[question.correctIndex]}');
    }

    // Move to next question or skill
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      setState(() {
        if (_currentQuestionIndex < skill.questions.length - 1) {
          _currentQuestionIndex++;
        } else if (_currentSkillIndex < _skills.length - 1) {
          _currentSkillIndex++;
          _currentQuestionIndex = 0;
        } else {
          // Evaluation complete
          _isEvaluating = false;
          _showResults = true;
          _saveResults();
          _speak('Evaluation complete! Great job!');
          return;
        }
        _speakCurrentQuestion();
      });
    });
  }

  SkillLevel _getSkillLevel(double percentage) {
    if (percentage >= 80) return SkillLevel.expert;
    if (percentage >= 60) return SkillLevel.proficient;
    if (percentage >= 40) return SkillLevel.developing;
    return SkillLevel.beginner;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Skill Evaluation',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
        elevation: 0,
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
          child: _isEvaluating
              ? _buildEvaluationScreen()
              : _showResults
                  ? _buildResultsScreen()
                  : _buildStartScreen(),
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    final hasHistory = _results.isNotEmpty;

    return Column(
      children: [
        _buildHeader('Skill Evaluation'),

        const Spacer(),

        // Main Card
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
              const Text('📊', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text(
                'Skill Evaluation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Test your knowledge across ${_skills.length} categories',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Skills preview
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(skill.color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(skill.emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          skill.name,
                          style: TextStyle(
                            color: Color(skill.color),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade400, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_skills.fold(0, (sum, s) => sum + s.questions.length)} questions • ~5 minutes',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Buttons
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startEvaluation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF667EEA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Start Evaluation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasHistory) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    setState(() => _showResults = true);
                  },
                  child: const Text(
                    'View Previous Results',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluationScreen() {
    final skill = _skills[_currentSkillIndex];
    final question = skill.questions[_currentQuestionIndex];
    final totalQuestions = _skills.fold(0, (sum, s) => sum + s.questions.length);
    final answeredQuestions = _skills.sublist(0, _currentSkillIndex).fold(0, (sum, s) => sum + s.questions.length) + _currentQuestionIndex;

    return Column(
      children: [
        // Header with skill info
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Quit Evaluation?'),
                      content: const Text('Your progress will be lost.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              _isEvaluating = false;
                              _showResults = false;
                            });
                          },
                          child: const Text('Quit'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(skill.color),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(skill.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      skill.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Q${_currentQuestionIndex + 1}/${skill.questions.length}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall: ${answeredQuestions + 1}/$totalQuestions',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (answeredQuestions + 1) / totalQuestions,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
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
              Text(skill.emoji, style: const TextStyle(fontSize: 48)),
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
            ],
          ),
        ),

        const Spacer(),

        // Options
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(question.options.length, (index) {
              return GestureDetector(
                onTap: () => _answerQuestion(index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(skill.color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              color: Color(skill.color),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
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
      ],
    );
  }

  Widget _buildResultsScreen() {
    final overallCorrect = _results.values.fold(0, (sum, r) => sum + r.correctAnswers);
    final overallTotal = _results.values.fold(0, (sum, r) => sum + r.totalQuestions);
    final overallPercentage = overallTotal > 0 ? (overallCorrect / overallTotal * 100) : 0.0;

    return Column(
      children: [
        _buildHeader('Your Skills Report'),

        const SizedBox(height: 16),

        // Overall Score
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                overallPercentage >= 80 ? '🌟' : (overallPercentage >= 60 ? '👍' : '💪'),
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                '${overallPercentage.round()}%',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667EEA),
                ),
              ),
              Text(
                'Overall Score',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getLevelColor(_getSkillLevel(overallPercentage)).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getLevelLabel(_getSkillLevel(overallPercentage)),
                  style: TextStyle(
                    color: _getLevelColor(_getSkillLevel(overallPercentage)),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Skill Breakdown
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Skills Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _skills.length,
                    itemBuilder: (context, index) {
                      final skill = _skills[index];
                      final result = _results[skill.id];
                      final percentage = result != null
                          ? (result.correctAnswers / result.totalQuestions * 100)
                          : 0.0;
                      final level = _getSkillLevel(percentage);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Color(skill.color).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(skill.emoji, style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    skill.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: percentage / 100,
                                            backgroundColor: Colors.grey.shade200,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Color(skill.color),
                                            ),
                                            minHeight: 6,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${percentage.round()}%',
                                        style: TextStyle(
                                          color: Color(skill.color),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getLevelColor(level).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getLevelEmoji(level),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Buttons
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _startEvaluation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Retake Test',
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

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(SkillLevel level) {
    switch (level) {
      case SkillLevel.expert:
        return Colors.green;
      case SkillLevel.proficient:
        return Colors.blue;
      case SkillLevel.developing:
        return Colors.orange;
      case SkillLevel.beginner:
        return Colors.red;
    }
  }

  String _getLevelLabel(SkillLevel level) {
    switch (level) {
      case SkillLevel.expert:
        return 'Expert Learner';
      case SkillLevel.proficient:
        return 'Proficient';
      case SkillLevel.developing:
        return 'Developing';
      case SkillLevel.beginner:
        return 'Beginner';
    }
  }

  String _getLevelEmoji(SkillLevel level) {
    switch (level) {
      case SkillLevel.expert:
        return '🌟';
      case SkillLevel.proficient:
        return '👍';
      case SkillLevel.developing:
        return '📈';
      case SkillLevel.beginner:
        return '🌱';
    }
  }
}

enum SkillLevel { beginner, developing, proficient, expert }

class SkillCategory {
  final String id;
  final String name;
  final String emoji;
  final int color;
  final List<SkillQuestion> questions;

  SkillCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.questions,
  });
}

class SkillQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  SkillQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class SkillResult {
  final String skillId;
  final String skillName;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime evaluatedAt;

  SkillResult({
    required this.skillId,
    required this.skillName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.evaluatedAt,
  });

  factory SkillResult.fromJson(Map<String, dynamic> json) {
    return SkillResult(
      skillId: json['skillId'] ?? '',
      skillName: json['skillName'] ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      evaluatedAt: DateTime.parse(json['evaluatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'skillName': skillName,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'evaluatedAt': evaluatedAt.toIso8601String(),
    };
  }

  SkillResult copyWith({int? correctAnswers}) {
    return SkillResult(
      skillId: skillId,
      skillName: skillName,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      evaluatedAt: evaluatedAt,
    );
  }
}
