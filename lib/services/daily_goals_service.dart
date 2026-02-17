import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/rewards_service.dart';

/// Daily Goals Service - Manages daily learning goals and tracking
class DailyGoalsService extends GetxService {
  static DailyGoalsService get to => Get.find<DailyGoalsService>();

  final GetStorage _storage = GetStorage();

  // Storage keys
  static const String kDailyGoals = 'daily_goals';
  static const String kCompletedGoals = 'completed_goals_today';
  static const String kLastGoalDate = 'last_goal_date';
  static const String kGoalStreak = 'goal_completion_streak';
  static const String kTotalGoalsCompleted = 'total_goals_completed';
  static const String kCustomGoals = 'custom_goals';

  // Observable values
  final RxList<Map<String, dynamic>> dailyGoals = <Map<String, dynamic>>[].obs;
  final RxList<String> completedGoalIds = <String>[].obs;
  final RxInt goalStreak = 0.obs;
  final RxInt totalGoalsCompleted = 0.obs;
  final RxBool allGoalsCompleted = false.obs;

  // Default daily goals
  static const List<Map<String, dynamic>> defaultGoals = [
    {
      'id': 'learn_5_letters',
      'title': 'Learn 5 Letters',
      'description': 'Practice 5 alphabet letters',
      'icon': '🔤',
      'target': 5,
      'category': 'alphabets',
      'xpReward': 10,
      'starReward': 2,
    },
    {
      'id': 'learn_10_numbers',
      'title': 'Learn 10 Numbers',
      'description': 'Practice 10 numbers',
      'icon': '🔢',
      'target': 10,
      'category': 'numbers',
      'xpReward': 10,
      'starReward': 2,
    },
    {
      'id': 'complete_1_quiz',
      'title': 'Complete a Quiz',
      'description': 'Finish any quiz',
      'icon': '❓',
      'target': 1,
      'category': 'quiz',
      'xpReward': 15,
      'starReward': 3,
    },
    {
      'id': 'play_1_game',
      'title': 'Play a Game',
      'description': 'Play any learning game',
      'icon': '🎮',
      'target': 1,
      'category': 'games',
      'xpReward': 10,
      'starReward': 2,
    },
    {
      'id': 'learn_5_words',
      'title': 'Learn 5 New Words',
      'description': 'Learn words from any category',
      'icon': '📚',
      'target': 5,
      'category': 'vocabulary',
      'xpReward': 10,
      'starReward': 2,
    },
  ];

  // Goal progress tracking
  final RxMap<String, int> goalProgress = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadGoals();
    _checkNewDay();
  }

  void _loadGoals() {
    // Load saved goals or use defaults
    final savedGoals = _storage.read<List<dynamic>>(kDailyGoals);
    if (savedGoals != null) {
      dailyGoals.value = List<Map<String, dynamic>>.from(
        savedGoals.map((e) => Map<String, dynamic>.from(e)),
      );
    } else {
      dailyGoals.value = List<Map<String, dynamic>>.from(defaultGoals);
    }

    // Load completed goals
    final completed = _storage.read<List<dynamic>>(kCompletedGoals);
    if (completed != null) {
      completedGoalIds.value = List<String>.from(completed);
    }

    // Load streak and total
    goalStreak.value = _storage.read<int>(kGoalStreak) ?? 0;
    totalGoalsCompleted.value = _storage.read<int>(kTotalGoalsCompleted) ?? 0;

    // Initialize goal progress
    for (var goal in dailyGoals) {
      goalProgress[goal['id']] = 0;
    }

    _checkAllGoalsCompleted();
  }

  void _checkNewDay() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastDate = _storage.read<String>(kLastGoalDate);

    if (lastDate != today) {
      // Check if streak should be maintained or reset
      if (lastDate != null) {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final yesterdayStr = yesterday.toIso8601String().split('T')[0];

        if (lastDate == yesterdayStr && allGoalsCompleted.value) {
          // Completed all goals yesterday, continue streak
          goalStreak.value++;
        } else if (lastDate != yesterdayStr) {
          // Missed a day, reset streak
          goalStreak.value = 0;
        }
      }

      // Reset for new day
      completedGoalIds.clear();
      goalProgress.forEach((key, _) => goalProgress[key] = 0);
      allGoalsCompleted.value = false;

      _storage.write(kCompletedGoals, []);
      _storage.write(kLastGoalDate, today);
      _storage.write(kGoalStreak, goalStreak.value);
    }
  }

  // Update progress for a goal
  Future<void> updateGoalProgress(String goalId, int progress) async {
    goalProgress[goalId] = progress;

    // Check if goal is completed
    final goal = dailyGoals.firstWhereOrNull((g) => g['id'] == goalId);
    if (goal != null && progress >= (goal['target'] as int)) {
      await completeGoal(goalId);
    }
  }

  // Increment goal progress
  Future<void> incrementGoalProgress(String goalId, {int amount = 1}) async {
    final current = goalProgress[goalId] ?? 0;
    await updateGoalProgress(goalId, current + amount);
  }

  // Complete a goal
  Future<void> completeGoal(String goalId) async {
    if (completedGoalIds.contains(goalId)) return;

    completedGoalIds.add(goalId);
    await _storage.write(kCompletedGoals, completedGoalIds.toList());

    // Award rewards
    final goal = dailyGoals.firstWhereOrNull((g) => g['id'] == goalId);
    if (goal != null) {
      final rewardsService = Get.find<RewardsService>();
      await rewardsService.addXP(goal['xpReward'] as int);
      await rewardsService.addStars(goal['starReward'] as int);
    }

    totalGoalsCompleted.value++;
    await _storage.write(kTotalGoalsCompleted, totalGoalsCompleted.value);

    _checkAllGoalsCompleted();
  }

  void _checkAllGoalsCompleted() {
    if (completedGoalIds.length == dailyGoals.length && dailyGoals.isNotEmpty) {
      allGoalsCompleted.value = true;

      // Bonus for completing all daily goals
      final rewardsService = Get.find<RewardsService>();
      rewardsService.addXP(50);
      rewardsService.addStars(10);
      rewardsService.awardBadge('quick_learner');
    }
  }

  // Check if goal is completed
  bool isGoalCompleted(String goalId) => completedGoalIds.contains(goalId);

  // Get goal progress percentage
  double getGoalProgressPercentage(String goalId) {
    final goal = dailyGoals.firstWhereOrNull((g) => g['id'] == goalId);
    if (goal == null) return 0;

    final target = goal['target'] as int;
    final current = goalProgress[goalId] ?? 0;
    return (current / target * 100).clamp(0, 100);
  }

  // Get overall daily progress
  double get overallDailyProgress {
    if (dailyGoals.isEmpty) return 0;
    return (completedGoalIds.length / dailyGoals.length * 100);
  }

  // Get remaining goals count
  int get remainingGoalsCount => dailyGoals.length - completedGoalIds.length;

  // Add custom goal
  Future<void> addCustomGoal(Map<String, dynamic> goal) async {
    dailyGoals.add(goal);
    goalProgress[goal['id']] = 0;
    await _storage.write(kDailyGoals, dailyGoals.toList());
  }

  // Remove custom goal
  Future<void> removeGoal(String goalId) async {
    dailyGoals.removeWhere((g) => g['id'] == goalId);
    goalProgress.remove(goalId);
    completedGoalIds.remove(goalId);
    await _storage.write(kDailyGoals, dailyGoals.toList());
    await _storage.write(kCompletedGoals, completedGoalIds.toList());
  }

  // Reset to default goals
  Future<void> resetToDefaultGoals() async {
    dailyGoals.value = List<Map<String, dynamic>>.from(defaultGoals);
    await _storage.write(kDailyGoals, dailyGoals.toList());

    goalProgress.clear();
    for (var goal in dailyGoals) {
      goalProgress[goal['id']] = 0;
    }
  }

  // Get stats
  Map<String, dynamic> getStats() {
    return {
      'totalCompleted': totalGoalsCompleted.value,
      'currentStreak': goalStreak.value,
      'todayCompleted': completedGoalIds.length,
      'todayTotal': dailyGoals.length,
      'allCompleted': allGoalsCompleted.value,
    };
  }
}
