import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class SkillEvaluationPage extends StatefulWidget {
  const SkillEvaluationPage({super.key});

  @override
  State<SkillEvaluationPage> createState() => _SkillEvaluationPageState();
}

class _SkillEvaluationPageState extends State<SkillEvaluationPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _storage = GetStorage();

  bool _isEvaluating = true;
  bool _showResults = false;
  int _currentSkillIndex = 0;
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
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
        SkillQuestion(question: 'What comes before 4?', options: ['2', '3', '5', '6'], correctIndex: 1),
        SkillQuestion(question: 'Count: 🌟🌟🌟🌟🌟', options: ['3', '4', '5', '6'], correctIndex: 2),
        SkillQuestion(question: 'Which is an even number?', options: ['3', '5', '6', '7'], correctIndex: 2),
        SkillQuestion(question: 'What is 10 + 0?', options: ['0', '1', '10', '100'], correctIndex: 2),
        SkillQuestion(question: 'How many fingers on one hand?', options: ['3', '4', '5', '6'], correctIndex: 2),
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
        SkillQuestion(question: 'Which is lowercase?', options: ['A', 'B', 'c', 'D'], correctIndex: 2),
        SkillQuestion(question: 'What letter starts "Dog"?', options: ['B', 'C', 'D', 'E'], correctIndex: 2),
        SkillQuestion(question: 'How many vowels: A E I O U?', options: ['3', '4', '5', '6'], correctIndex: 2),
        SkillQuestion(question: 'What comes before Z?', options: ['W', 'X', 'Y', 'V'], correctIndex: 2),
        SkillQuestion(question: 'Which letter starts "Mango"?', options: ['N', 'M', 'L', 'O'], correctIndex: 1),
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
        SkillQuestion(question: '6 + 3 = ?', options: ['7', '8', '9', '10'], correctIndex: 2),
        SkillQuestion(question: '8 - 4 = ?', options: ['2', '3', '4', '5'], correctIndex: 2),
        SkillQuestion(question: '2 x 3 = ?', options: ['4', '5', '6', '7'], correctIndex: 2),
        SkillQuestion(question: '9 - 7 = ?', options: ['1', '2', '3', '4'], correctIndex: 1),
        SkillQuestion(question: '5 + 5 = ?', options: ['8', '9', '10', '11'], correctIndex: 2),
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
        SkillQuestion(question: 'What color is 🟡?', options: ['Red', 'Yellow', 'Blue', 'Green'], correctIndex: 1),
        SkillQuestion(question: 'What color are leaves?', options: ['Red', 'Blue', 'Green', 'White'], correctIndex: 2),
        SkillQuestion(question: 'Mix red + yellow = ?', options: ['Purple', 'Orange', 'Green', 'Pink'], correctIndex: 1),
        SkillQuestion(question: 'What color is snow?', options: ['Blue', 'Grey', 'Yellow', 'White'], correctIndex: 3),
        SkillQuestion(question: 'What color is 🟣?', options: ['Pink', 'Blue', 'Purple', 'Red'], correctIndex: 2),
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
        SkillQuestion(question: 'How many sides has a rectangle?', options: ['3', '4', '5', '6'], correctIndex: 1),
        SkillQuestion(question: 'Which shape has 5 sides?', options: ['Square', 'Triangle', 'Pentagon', 'Hexagon'], correctIndex: 2),
        SkillQuestion(question: 'What shape is a ball?', options: ['Cube', 'Sphere', 'Cone', 'Cylinder'], correctIndex: 1),
        SkillQuestion(question: 'Which shape has 6 sides?', options: ['Pentagon', 'Hexagon', 'Octagon', 'Triangle'], correctIndex: 1),
        SkillQuestion(question: 'What shape is a dice?', options: ['Sphere', 'Cone', 'Cube', 'Cylinder'], correctIndex: 2),
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
        SkillQuestion(question: 'Which is the fastest animal?', options: ['Elephant', 'Cheetah', 'Dog', 'Horse'], correctIndex: 1),
        SkillQuestion(question: 'What does a hen give?', options: ['Milk', 'Wool', 'Eggs', 'Honey'], correctIndex: 2),
        SkillQuestion(question: 'Which animal has stripes?', options: ['Lion', 'Zebra', 'Bear', 'Dog'], correctIndex: 1),
        SkillQuestion(question: 'What sound does a cat make?', options: ['Bark', 'Moo', 'Meow', 'Oink'], correctIndex: 2),
        SkillQuestion(question: 'Which is the tallest animal?', options: ['Elephant', 'Horse', 'Giraffe', 'Bear'], correctIndex: 2),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
    _initTts();
    // Auto-start evaluation and speak the first question after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speak('Let\'s test your skills!');
      _speakCurrentQuestion();
    });
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
  }

  Future<void> _saveResults() async {
    await _storage.write(
      'skill_evaluation_results',
      _results.map((key, value) => MapEntry(key, value.toJson())),
    );
  }

  void _startEvaluation() {
    ProgressService.to.resetProgress(ProgressService.kSkillEvaluation);
    setState(() {
      _isEvaluating = true;
      _showResults = false;
      _currentSkillIndex = 0;
      _currentQuestionIndex = 0;
      _selectedOptionIndex = null;
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

  void _selectOption(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _goToNext() {
    if (_selectedOptionIndex == null) return;

    final skill = _skills[_currentSkillIndex];
    final question = skill.questions[_currentQuestionIndex];
    final isCorrect = _selectedOptionIndex == question.correctIndex;

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

    // Mark question as completed in ProgressService
    final flatIndex = _skills.sublist(0, _currentSkillIndex).fold(0, (sum, s) => sum + s.questions.length) + _currentQuestionIndex;
    ProgressService.to.markItemCompleted(ProgressService.kSkillEvaluation, flatIndex);

    if (isCorrect) {
      _results[skill.id] = _results[skill.id]!.copyWith(
        correctAnswers: _results[skill.id]!.correctAnswers + 1,
      );
      _speak('Correct!');
    } else {
      _speak('Oops! The answer is ${question.options[question.correctIndex]}');
    }

    // Move to next question or skill
    setState(() {
      _selectedOptionIndex = null;
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
  }

  void _goToPrevious() {
    setState(() {
      _selectedOptionIndex = null;
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      } else if (_currentSkillIndex > 0) {
        _currentSkillIndex--;
        _currentQuestionIndex = _skills[_currentSkillIndex].questions.length - 1;
      }
      _speakCurrentQuestion();
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
    disposeGridAnimations();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: _showResults ? 'Skills Report' : 'Skill Evaluation',
      bottomNavigationBar: const AdsScreen(),
      actions: _isEvaluating
          ? [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.refresh, color: Colors.white, size: 20),
                ),
                onPressed: _startEvaluation,
              ),
            ]
          : null,
      body: _isEvaluating
          ? _buildEvaluationScreen()
          : _buildResultsScreen(),
    );
  }

  Widget _buildEvaluationScreen() {
    final skill = _skills[_currentSkillIndex];
    final question = skill.questions[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // Progress bar (like Number screen - using ProgressService)
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kSkillEvaluation,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kSkillEvaluation,
            );
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
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
                        '$progressString completed',
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
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

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

          const SizedBox(height: 16),

          // Options with gradient colors and floating animation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(question.options.length, (index) {
                final gradient = AppColors.getGradientForIndex(index);
                final isSelected = _selectedOptionIndex == index;
                return buildFloatingItem(
                  index: index,
                  child: GestureDetector(
                    onTap: () { TtsService.to.speak(question.options[index]); _selectOption(index); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.5)
                                : gradient[0].withValues(alpha: 0.4),
                            blurRadius: isSelected ? 12 : 8,
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
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : Text(
                                      String.fromCharCode(65 + index),
                                      style: const TextStyle(
                                        color: Colors.white,
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
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
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

          const SizedBox(height: 16),

          // Previous and Next buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Previous button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_currentSkillIndex == 0 && _currentQuestionIndex == 0)
                        ? null
                        : _goToPrevious,
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    label: const Text(
                      'Previous',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                      disabledForegroundColor: Colors.white38,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Next button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectedOptionIndex != null ? _goToNext : null,
                    icon: const Text(
                      'Next',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    label: const Icon(Icons.arrow_forward_rounded, size: 20),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF667EEA),
                      disabledBackgroundColor: Colors.white.withValues(alpha: 0.15),
                      disabledForegroundColor: Colors.white38,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    final overallCorrect = _results.values.fold(0, (sum, r) => sum + r.correctAnswers);
    final overallTotal = _results.values.fold(0, (sum, r) => sum + r.totalQuestions);
    final overallPercentage = overallTotal > 0 ? (overallCorrect / overallTotal * 100) : 0.0;

    return Column(
      children: [
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
