import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/data/models/progress_model.dart';

/// Repository for learning progress data operations
class ProgressRepository {
  final GetStorage _storage = GetStorage();
  static const String _progressKey = 'learning_progress';
  static const String _quizResultsKey = 'quiz_results';
  static const String _dailyGoalsKey = 'daily_goals';
  static const String _streakKey = 'daily_streak';
  static const String _lastActiveKey = 'last_active_date';

  // ============== PROGRESS OPERATIONS ==============

  /// Get progress for a category
  ProgressModel? getProgress(String category) {
    final data = _storage.read('${_progressKey}_$category');
    if (data != null) {
      return ProgressModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// Get all progress
  Map<String, ProgressModel> getAllProgress() {
    final Map<String, ProgressModel> allProgress = {};
    final categories = [
      'numbers', 'capital_letters', 'small_letters', 'hindi_letters',
      'tables', 'animals', 'birds', 'fruits', 'vegetables', 'colors',
      'shapes', 'body_parts', 'flowers', 'months', 'weekdays',
    ];

    for (final category in categories) {
      final progress = getProgress(category);
      if (progress != null) {
        allProgress[category] = progress;
      }
    }
    return allProgress;
  }

  /// Save progress for a category
  Future<void> saveProgress(String category, ProgressModel progress) async {
    await _storage.write('${_progressKey}_$category', progress.toJson());
  }

  /// Update progress
  Future<void> updateProgress(String category, {int? completed, double? accuracy}) async {
    final current = getProgress(category);
    if (current != null) {
      await saveProgress(category, current.copyWith(
        completed: completed ?? current.completed,
        accuracy: accuracy ?? current.accuracy,
        lastPracticed: DateTime.now(),
      ));
    }
  }

  /// Increment completed count
  Future<void> incrementCompleted(String category) async {
    final current = getProgress(category);
    if (current != null) {
      await saveProgress(category, current.copyWith(
        completed: current.completed + 1,
        lastPracticed: DateTime.now(),
      ));
    }
  }

  // ============== QUIZ RESULTS ==============

  /// Get quiz results
  List<QuizResultModel> getQuizResults() {
    final data = _storage.read(_quizResultsKey);
    if (data != null) {
      return (data as List).map((e) =>
        QuizResultModel.fromJson(Map<String, dynamic>.from(e))
      ).toList();
    }
    return [];
  }

  /// Add quiz result
  Future<void> addQuizResult(QuizResultModel result) async {
    final results = getQuizResults();
    results.add(result);
    // Keep only last 100 results
    if (results.length > 100) {
      results.removeRange(0, results.length - 100);
    }
    await _storage.write(_quizResultsKey, results.map((e) => e.toJson()).toList());
  }

  /// Get quiz results by category
  List<QuizResultModel> getQuizResultsByCategory(String category) {
    return getQuizResults().where((r) => r.category == category).toList();
  }

  /// Get best score for category
  int getBestScore(String category) {
    final results = getQuizResultsByCategory(category);
    if (results.isEmpty) return 0;
    return results.map((r) => r.score).reduce((a, b) => a > b ? a : b);
  }

  // ============== DAILY GOALS ==============

  /// Get daily goals
  List<DailyGoalModel> getDailyGoals() {
    final data = _storage.read(_dailyGoalsKey);
    if (data != null) {
      return (data as List).map((e) =>
        DailyGoalModel.fromJson(Map<String, dynamic>.from(e))
      ).toList();
    }
    return _getDefaultGoals();
  }

  /// Save daily goals
  Future<void> saveDailyGoals(List<DailyGoalModel> goals) async {
    await _storage.write(_dailyGoalsKey, goals.map((e) => e.toJson()).toList());
  }

  /// Reset daily goals (called at midnight)
  Future<void> resetDailyGoals() async {
    await _storage.write(_dailyGoalsKey, _getDefaultGoals().map((e) => e.toJson()).toList());
  }

  List<DailyGoalModel> _getDefaultGoals() {
    return [
      const DailyGoalModel(id: 'letters', title: 'Learn 5 Letters', icon: '🔤', target: 5),
      const DailyGoalModel(id: 'numbers', title: 'Learn 10 Numbers', icon: '🔢', target: 10),
      const DailyGoalModel(id: 'quiz', title: 'Complete a Quiz', icon: '📝', target: 1),
      const DailyGoalModel(id: 'game', title: 'Play a Game', icon: '🎮', target: 1),
      const DailyGoalModel(id: 'words', title: 'Learn 5 New Words', icon: '📚', target: 5),
    ];
  }

  // ============== STREAK ==============

  /// Get current streak
  int getStreak() {
    return _storage.read(_streakKey) ?? 0;
  }

  /// Update streak
  Future<void> updateStreak() async {
    final lastActive = _storage.read(_lastActiveKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastActive == null) {
      await _storage.write(_streakKey, 1);
    } else {
      final lastDate = DateTime.parse(lastActive);
      final todayDate = DateTime.parse(today);
      final difference = todayDate.difference(lastDate).inDays;

      if (difference == 1) {
        // Consecutive day
        final currentStreak = getStreak();
        await _storage.write(_streakKey, currentStreak + 1);
      } else if (difference > 1) {
        // Streak broken
        await _storage.write(_streakKey, 1);
      }
    }

    await _storage.write(_lastActiveKey, today);
  }

  /// Reset streak
  Future<void> resetStreak() async {
    await _storage.write(_streakKey, 0);
  }
}
