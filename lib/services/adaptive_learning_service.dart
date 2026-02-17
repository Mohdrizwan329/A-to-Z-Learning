import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Difficulty levels for adaptive learning
enum DifficultyLevel { easy, medium, hard, expert }

/// Model for tracking performance in a category
class CategoryPerformance {
  final String category;
  final int totalAttempts;
  final int correctAnswers;
  final double accuracy;
  final DifficultyLevel currentLevel;
  final DateTime lastAttempt;

  CategoryPerformance({
    required this.category,
    required this.totalAttempts,
    required this.correctAnswers,
    required this.accuracy,
    required this.currentLevel,
    required this.lastAttempt,
  });

  factory CategoryPerformance.fromJson(Map<String, dynamic> json) {
    return CategoryPerformance(
      category: json['category'] ?? '',
      totalAttempts: json['totalAttempts'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      currentLevel: DifficultyLevel.values[json['currentLevel'] ?? 0],
      lastAttempt: DateTime.parse(json['lastAttempt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'totalAttempts': totalAttempts,
      'correctAnswers': correctAnswers,
      'accuracy': accuracy,
      'currentLevel': currentLevel.index,
      'lastAttempt': lastAttempt.toIso8601String(),
    };
  }

  CategoryPerformance copyWith({
    int? totalAttempts,
    int? correctAnswers,
    double? accuracy,
    DifficultyLevel? currentLevel,
    DateTime? lastAttempt,
  }) {
    return CategoryPerformance(
      category: category,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      accuracy: accuracy ?? this.accuracy,
      currentLevel: currentLevel ?? this.currentLevel,
      lastAttempt: lastAttempt ?? this.lastAttempt,
    );
  }
}

/// Adaptive question model
class AdaptiveQuestion {
  final String id;
  final String question;
  final String category;
  final DifficultyLevel difficulty;
  final List<String> options;
  final int correctIndex;
  final String? hint;
  final String? explanation;
  final String? imageEmoji;

  AdaptiveQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty,
    required this.options,
    required this.correctIndex,
    this.hint,
    this.explanation,
    this.imageEmoji,
  });

  String get correctAnswer => options[correctIndex];
}

/// Service for adaptive learning and difficulty adjustment
class AdaptiveLearningService extends GetxService {
  static AdaptiveLearningService get to => Get.find();

  final GetStorage _storage = GetStorage();
  static const String _performanceKey = 'adaptive_performance';

  // Thresholds for difficulty adjustment
  static const double _promoteThreshold = 0.80; // 80% accuracy to go up
  static const double _demoteThreshold = 0.50; // Below 50% to go down
  static const int _minAttemptsForAdjustment = 5;

  final RxMap<String, CategoryPerformance> performances = <String, CategoryPerformance>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPerformances();
  }

  void _loadPerformances() {
    final data = _storage.read(_performanceKey);
    if (data != null) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data);
      performances.value = map.map((key, value) =>
          MapEntry(key, CategoryPerformance.fromJson(Map<String, dynamic>.from(value))));
    }
  }

  Future<void> _savePerformances() async {
    await _storage.write(
      _performanceKey,
      performances.map((key, value) => MapEntry(key, value.toJson())),
    );
  }

  /// Get current difficulty level for a category
  DifficultyLevel getDifficultyLevel(String category) {
    return performances[category]?.currentLevel ?? DifficultyLevel.easy;
  }

  /// Record an answer attempt
  Future<DifficultyLevel> recordAttempt({
    required String category,
    required bool isCorrect,
  }) async {
    final current = performances[category];

    final newTotalAttempts = (current?.totalAttempts ?? 0) + 1;
    final newCorrectAnswers = (current?.correctAnswers ?? 0) + (isCorrect ? 1 : 0);
    final newAccuracy = newCorrectAnswers / newTotalAttempts;

    DifficultyLevel newLevel = current?.currentLevel ?? DifficultyLevel.easy;

    // Only adjust difficulty after minimum attempts
    if (newTotalAttempts >= _minAttemptsForAdjustment) {
      newLevel = _calculateNewLevel(newAccuracy, newLevel);
    }

    final updated = CategoryPerformance(
      category: category,
      totalAttempts: newTotalAttempts,
      correctAnswers: newCorrectAnswers,
      accuracy: newAccuracy,
      currentLevel: newLevel,
      lastAttempt: DateTime.now(),
    );

    performances[category] = updated;
    await _savePerformances();

    return newLevel;
  }

  DifficultyLevel _calculateNewLevel(double accuracy, DifficultyLevel current) {
    if (accuracy >= _promoteThreshold) {
      // Promote to next level
      switch (current) {
        case DifficultyLevel.easy:
          return DifficultyLevel.medium;
        case DifficultyLevel.medium:
          return DifficultyLevel.hard;
        case DifficultyLevel.hard:
          return DifficultyLevel.expert;
        case DifficultyLevel.expert:
          return DifficultyLevel.expert; // Stay at max
      }
    } else if (accuracy < _demoteThreshold) {
      // Demote to previous level
      switch (current) {
        case DifficultyLevel.expert:
          return DifficultyLevel.hard;
        case DifficultyLevel.hard:
          return DifficultyLevel.medium;
        case DifficultyLevel.medium:
          return DifficultyLevel.easy;
        case DifficultyLevel.easy:
          return DifficultyLevel.easy; // Stay at min
      }
    }
    return current;
  }

  /// Get accuracy for a category
  double getAccuracy(String category) {
    return performances[category]?.accuracy ?? 0.0;
  }

  /// Get performance summary
  CategoryPerformance? getPerformance(String category) {
    return performances[category];
  }

  /// Generate adaptive questions for a category
  List<AdaptiveQuestion> getAdaptiveQuestions({
    required String category,
    required int count,
  }) {
    final level = getDifficultyLevel(category);
    return _generateQuestions(category, level, count);
  }

  List<AdaptiveQuestion> _generateQuestions(
    String category,
    DifficultyLevel level,
    int count,
  ) {
    switch (category.toLowerCase()) {
      case 'math':
      case 'addition':
        return _generateMathQuestions(level, count);
      case 'alphabet':
      case 'letters':
        return _generateAlphabetQuestions(level, count);
      case 'numbers':
        return _generateNumberQuestions(level, count);
      case 'animals':
        return _generateAnimalQuestions(level, count);
      case 'colors':
        return _generateColorQuestions(level, count);
      default:
        return _generateGeneralQuestions(level, count);
    }
  }

  List<AdaptiveQuestion> _generateMathQuestions(DifficultyLevel level, int count) {
    final questions = <AdaptiveQuestion>[];
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count; i++) {
      int a, b, answer;
      String question;

      switch (level) {
        case DifficultyLevel.easy:
          a = (random + i) % 5 + 1; // 1-5
          b = (random + i * 2) % 5 + 1;
          answer = a + b;
          question = 'What is $a + $b?';
          break;
        case DifficultyLevel.medium:
          a = (random + i) % 10 + 1; // 1-10
          b = (random + i * 2) % 10 + 1;
          answer = a + b;
          question = 'What is $a + $b?';
          break;
        case DifficultyLevel.hard:
          a = (random + i) % 20 + 10; // 10-30
          b = (random + i * 2) % 20 + 10;
          answer = a + b;
          question = 'What is $a + $b?';
          break;
        case DifficultyLevel.expert:
          a = (random + i) % 50 + 20; // 20-70
          b = (random + i * 2) % 50 + 20;
          answer = a + b;
          question = 'What is $a + $b?';
          break;
      }

      final options = _generateOptions(answer, level);

      questions.add(AdaptiveQuestion(
        id: 'math_${level.name}_$i',
        question: question,
        category: 'math',
        difficulty: level,
        options: options.map((e) => e.toString()).toList(),
        correctIndex: options.indexOf(answer),
        imageEmoji: '➕',
        hint: 'Count on your fingers!',
        explanation: '$a + $b = $answer',
      ));
    }

    return questions;
  }

  List<int> _generateOptions(int correct, DifficultyLevel level) {
    final options = <int>[correct];
    final range = level == DifficultyLevel.easy ? 3 : (level == DifficultyLevel.medium ? 5 : 10);

    while (options.length < 4) {
      final offset = (DateTime.now().millisecondsSinceEpoch % range) - (range ~/ 2);
      final option = correct + offset + options.length;
      if (!options.contains(option) && option > 0) {
        options.add(option);
      } else {
        options.add(correct + options.length);
      }
    }

    options.shuffle();
    return options;
  }

  List<AdaptiveQuestion> _generateAlphabetQuestions(DifficultyLevel level, int count) {
    final questions = <AdaptiveQuestion>[];
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

    for (int i = 0; i < count; i++) {
      final letterIndex = (i * 3) % 26;
      final letter = letters[letterIndex];
      String question;
      List<String> options;
      int correctIndex;

      switch (level) {
        case DifficultyLevel.easy:
          question = 'Which letter is this? $letter';
          options = [letter, letters[(letterIndex + 1) % 26], letters[(letterIndex + 2) % 26], letters[(letterIndex + 3) % 26]];
          correctIndex = 0;
          break;
        case DifficultyLevel.medium:
          question = 'What comes after $letter?';
          final nextLetter = letters[(letterIndex + 1) % 26];
          options = [nextLetter, letters[(letterIndex + 2) % 26], letters[(letterIndex + 3) % 26], letter];
          correctIndex = 0;
          break;
        case DifficultyLevel.hard:
          question = 'What is the ${_ordinal(letterIndex + 1)} letter?';
          options = [letter, letters[(letterIndex + 5) % 26], letters[(letterIndex + 10) % 26], letters[(letterIndex + 15) % 26]];
          correctIndex = 0;
          break;
        case DifficultyLevel.expert:
          question = 'What letter is ${letterIndex + 1} positions from A?';
          options = [letter, letters[(letterIndex + 3) % 26], letters[(letterIndex + 5) % 26], letters[(letterIndex + 7) % 26]];
          correctIndex = 0;
          break;
      }

      options.shuffle();
      correctIndex = options.indexOf(level == DifficultyLevel.easy ? letter : (level == DifficultyLevel.medium ? letters[(letterIndex + 1) % 26] : letter));

      questions.add(AdaptiveQuestion(
        id: 'alphabet_${level.name}_$i',
        question: question,
        category: 'alphabet',
        difficulty: level,
        options: options,
        correctIndex: correctIndex,
        imageEmoji: '🔤',
      ));
    }

    return questions;
  }

  String _ordinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    switch (n % 10) {
      case 1: return '${n}st';
      case 2: return '${n}nd';
      case 3: return '${n}rd';
      default: return '${n}th';
    }
  }

  List<AdaptiveQuestion> _generateNumberQuestions(DifficultyLevel level, int count) {
    final questions = <AdaptiveQuestion>[];

    for (int i = 0; i < count; i++) {
      int number;
      String question;

      switch (level) {
        case DifficultyLevel.easy:
          number = i + 1; // 1-10
          question = 'What number is this? $number';
          break;
        case DifficultyLevel.medium:
          number = (i + 1) * 5; // 5, 10, 15...
          question = 'What comes after ${number - 1}?';
          break;
        case DifficultyLevel.hard:
          number = (i + 1) * 10; // 10, 20, 30...
          question = 'Count by 10s: What comes after ${number - 10}?';
          break;
        case DifficultyLevel.expert:
          number = (i + 1) * 7; // 7, 14, 21...
          question = 'Count by 7s: What comes after ${number - 7}?';
          break;
      }

      final options = [number, number + 1, number - 1, number + 2];
      options.shuffle();

      questions.add(AdaptiveQuestion(
        id: 'numbers_${level.name}_$i',
        question: question,
        category: 'numbers',
        difficulty: level,
        options: options.map((e) => e.toString()).toList(),
        correctIndex: options.indexOf(number),
        imageEmoji: '🔢',
      ));
    }

    return questions;
  }

  List<AdaptiveQuestion> _generateAnimalQuestions(DifficultyLevel level, int count) {
    final animals = [
      {'emoji': '🐶', 'name': 'Dog', 'sound': 'Bark', 'legs': '4'},
      {'emoji': '🐱', 'name': 'Cat', 'sound': 'Meow', 'legs': '4'},
      {'emoji': '🐦', 'name': 'Bird', 'sound': 'Chirp', 'legs': '2'},
      {'emoji': '🐟', 'name': 'Fish', 'sound': 'Blub', 'legs': '0'},
      {'emoji': '🐘', 'name': 'Elephant', 'sound': 'Trumpet', 'legs': '4'},
      {'emoji': '🦁', 'name': 'Lion', 'sound': 'Roar', 'legs': '4'},
      {'emoji': '🐸', 'name': 'Frog', 'sound': 'Ribbit', 'legs': '4'},
      {'emoji': '🦋', 'name': 'Butterfly', 'sound': 'Flutter', 'legs': '6'},
    ];

    final questions = <AdaptiveQuestion>[];

    for (int i = 0; i < count; i++) {
      final animal = animals[i % animals.length];
      String question;
      List<String> options;
      int correctIndex;

      switch (level) {
        case DifficultyLevel.easy:
          question = 'What animal is this? ${animal['emoji']}';
          options = [animal['name']!, animals[(i + 1) % animals.length]['name']!, animals[(i + 2) % animals.length]['name']!, animals[(i + 3) % animals.length]['name']!];
          correctIndex = 0;
          break;
        case DifficultyLevel.medium:
          question = 'Which animal says "${animal['sound']}"?';
          options = [animal['name']!, animals[(i + 1) % animals.length]['name']!, animals[(i + 2) % animals.length]['name']!, animals[(i + 3) % animals.length]['name']!];
          correctIndex = 0;
          break;
        case DifficultyLevel.hard:
          question = 'How many legs does a ${animal['name']} have?';
          options = ['0', '2', '4', '6'];
          correctIndex = options.indexOf(animal['legs']!);
          break;
        case DifficultyLevel.expert:
          question = '${animal['emoji']} This animal has ${animal['legs']} legs and says "${animal['sound']}". What is it?';
          options = [animal['name']!, animals[(i + 1) % animals.length]['name']!, animals[(i + 2) % animals.length]['name']!, animals[(i + 3) % animals.length]['name']!];
          correctIndex = 0;
          break;
      }

      if (level != DifficultyLevel.hard) {
        options.shuffle();
        correctIndex = options.indexOf(animal['name']!);
      }

      questions.add(AdaptiveQuestion(
        id: 'animals_${level.name}_$i',
        question: question,
        category: 'animals',
        difficulty: level,
        options: options,
        correctIndex: correctIndex,
        imageEmoji: animal['emoji'],
      ));
    }

    return questions;
  }

  List<AdaptiveQuestion> _generateColorQuestions(DifficultyLevel level, int count) {
    final colors = [
      {'emoji': '🔴', 'name': 'Red'},
      {'emoji': '🔵', 'name': 'Blue'},
      {'emoji': '🟢', 'name': 'Green'},
      {'emoji': '🟡', 'name': 'Yellow'},
      {'emoji': '🟠', 'name': 'Orange'},
      {'emoji': '🟣', 'name': 'Purple'},
      {'emoji': '🟤', 'name': 'Brown'},
      {'emoji': '⚫', 'name': 'Black'},
    ];

    final questions = <AdaptiveQuestion>[];

    for (int i = 0; i < count; i++) {
      final color = colors[i % colors.length];
      final question = 'What color is this? ${color['emoji']}';
      var options = [color['name']!, colors[(i + 1) % colors.length]['name']!, colors[(i + 2) % colors.length]['name']!, colors[(i + 3) % colors.length]['name']!];
      options.shuffle();

      questions.add(AdaptiveQuestion(
        id: 'colors_${level.name}_$i',
        question: question,
        category: 'colors',
        difficulty: level,
        options: options,
        correctIndex: options.indexOf(color['name']!),
        imageEmoji: color['emoji'],
      ));
    }

    return questions;
  }

  List<AdaptiveQuestion> _generateGeneralQuestions(DifficultyLevel level, int count) {
    // Mix of different categories
    final allQuestions = <AdaptiveQuestion>[];
    allQuestions.addAll(_generateMathQuestions(level, count ~/ 3 + 1));
    allQuestions.addAll(_generateAlphabetQuestions(level, count ~/ 3 + 1));
    allQuestions.addAll(_generateNumberQuestions(level, count ~/ 3 + 1));
    allQuestions.shuffle();
    return allQuestions.take(count).toList();
  }

  /// Reset performance for a category
  Future<void> resetCategory(String category) async {
    performances.remove(category);
    await _savePerformances();
  }

  /// Reset all performances
  Future<void> resetAll() async {
    performances.clear();
    await _storage.remove(_performanceKey);
  }

  /// Get difficulty label
  String getDifficultyLabel(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy:
        return 'Easy 🌟';
      case DifficultyLevel.medium:
        return 'Medium 🌟🌟';
      case DifficultyLevel.hard:
        return 'Hard 🌟🌟🌟';
      case DifficultyLevel.expert:
        return 'Expert 🌟🌟🌟🌟';
    }
  }

  /// Get difficulty color
  int getDifficultyColor(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy:
        return 0xFF4CAF50; // Green
      case DifficultyLevel.medium:
        return 0xFFFFA726; // Orange
      case DifficultyLevel.hard:
        return 0xFFEF5350; // Red
      case DifficultyLevel.expert:
        return 0xFF9C27B0; // Purple
    }
  }
}
