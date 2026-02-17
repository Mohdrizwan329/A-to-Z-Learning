import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SmartLearningService extends GetxService {
  final GetStorage _box = GetStorage();

  // Learning analytics
  final RxMap<String, CategoryAnalytics> categoryAnalytics = <String, CategoryAnalytics>{}.obs;
  final RxList<String> weakTopics = <String>[].obs;
  final RxList<String> strongTopics = <String>[].obs;
  final RxList<LearningRecommendation> recommendations = <LearningRecommendation>[].obs;
  final RxInt currentDifficulty = 1.obs; // 1=Easy, 2=Medium, 3=Hard
  final RxDouble overallAccuracy = 0.0.obs;

  // Category keys
  static const List<String> allCategories = [
    'alphabets_capital',
    'alphabets_small',
    'numbers',
    'hindi_letters',
    'animals',
    'birds',
    'fruits',
    'vegetables',
    'colors',
    'shapes',
    'bodyparts',
    'flowers',
    'months',
    'weekdays',
    'vehicles',
    'seasons',
    'gk',
    'addition',
    'subtraction',
    'multiplication',
    'division',
    'tables',
    'stories',
    'rhymes',
    'poems',
  ];

  static const Map<String, String> categoryNames = {
    'alphabets_capital': 'Capital Letters',
    'alphabets_small': 'Small Letters',
    'numbers': 'Numbers',
    'hindi_letters': 'Hindi Letters',
    'animals': 'Animals',
    'birds': 'Birds',
    'fruits': 'Fruits',
    'vegetables': 'Vegetables',
    'colors': 'Colors',
    'shapes': 'Shapes',
    'bodyparts': 'Body Parts',
    'flowers': 'Flowers',
    'months': 'Months',
    'weekdays': 'Week Days',
    'vehicles': 'Vehicles',
    'seasons': 'Seasons',
    'gk': 'General Knowledge',
    'addition': 'Addition',
    'subtraction': 'Subtraction',
    'multiplication': 'Multiplication',
    'division': 'Division',
    'tables': 'Tables',
    'stories': 'Stories',
    'rhymes': 'Rhymes',
    'poems': 'Poems',
  };

  Future<SmartLearningService> init() async {
    await _loadAnalytics();
    _analyzePerformance();
    _generateRecommendations();
    return this;
  }

  Future<void> _loadAnalytics() async {
    for (final category in allCategories) {
      final data = _box.read<Map<String, dynamic>>('analytics_$category');
      if (data != null) {
        categoryAnalytics[category] = CategoryAnalytics.fromJson(data);
      } else {
        categoryAnalytics[category] = CategoryAnalytics(category: category);
      }
    }
  }

  Future<void> _saveAnalytics(String category) async {
    final analytics = categoryAnalytics[category];
    if (analytics != null) {
      await _box.write('analytics_$category', analytics.toJson());
    }
  }

  // Record attempt for a category
  void recordAttempt({
    required String category,
    required bool isCorrect,
    required int timeTakenSeconds,
    int difficulty = 1,
  }) {
    final analytics = categoryAnalytics[category] ?? CategoryAnalytics(category: category);

    analytics.totalAttempts++;
    if (isCorrect) {
      analytics.correctAttempts++;
      analytics.currentStreak++;
      if (analytics.currentStreak > analytics.bestStreak) {
        analytics.bestStreak = analytics.currentStreak;
      }
    } else {
      analytics.currentStreak = 0;
    }

    analytics.totalTimeSpent += timeTakenSeconds;
    analytics.lastAttemptDate = DateTime.now();
    analytics.difficultyLevel = difficulty;

    // Calculate average time
    analytics.averageTimePerQuestion =
        analytics.totalTimeSpent / analytics.totalAttempts;

    categoryAnalytics[category] = analytics;
    _saveAnalytics(category);

    // Re-analyze after recording
    _analyzePerformance();
    _adjustDifficulty(category);
    _generateRecommendations();
  }

  void _analyzePerformance() {
    weakTopics.clear();
    strongTopics.clear();

    double totalAccuracy = 0;
    int categoriesWithData = 0;

    for (final entry in categoryAnalytics.entries) {
      final analytics = entry.value;
      if (analytics.totalAttempts >= 5) {
        categoriesWithData++;
        final accuracy = analytics.accuracy;
        totalAccuracy += accuracy;

        if (accuracy < 0.6) {
          weakTopics.add(entry.key);
        } else if (accuracy >= 0.85) {
          strongTopics.add(entry.key);
        }
      }
    }

    if (categoriesWithData > 0) {
      overallAccuracy.value = totalAccuracy / categoriesWithData;
    }

    // Sort weak topics by accuracy (lowest first)
    weakTopics.sort((a, b) {
      final aAccuracy = categoryAnalytics[a]?.accuracy ?? 0;
      final bAccuracy = categoryAnalytics[b]?.accuracy ?? 0;
      return aAccuracy.compareTo(bAccuracy);
    });
  }

  void _adjustDifficulty(String category) {
    final analytics = categoryAnalytics[category];
    if (analytics == null || analytics.totalAttempts < 10) return;

    final accuracy = analytics.accuracy;
    final currentLevel = analytics.difficultyLevel;

    // Increase difficulty if doing well
    if (accuracy >= 0.9 && analytics.currentStreak >= 5 && currentLevel < 3) {
      analytics.difficultyLevel = currentLevel + 1;
      categoryAnalytics[category] = analytics;
      _saveAnalytics(category);
    }
    // Decrease difficulty if struggling
    else if (accuracy < 0.5 && currentLevel > 1) {
      analytics.difficultyLevel = currentLevel - 1;
      categoryAnalytics[category] = analytics;
      _saveAnalytics(category);
    }

    // Update global difficulty based on overall performance
    if (overallAccuracy.value >= 0.85) {
      currentDifficulty.value = 3;
    } else if (overallAccuracy.value >= 0.7) {
      currentDifficulty.value = 2;
    } else {
      currentDifficulty.value = 1;
    }
  }

  void _generateRecommendations() {
    recommendations.clear();

    // Priority 1: Weak topics
    for (final topic in weakTopics.take(3)) {
      final analytics = categoryAnalytics[topic];
      recommendations.add(LearningRecommendation(
        category: topic,
        title: 'Practice ${categoryNames[topic] ?? topic}',
        description: 'Your accuracy is ${((analytics?.accuracy ?? 0) * 100).toStringAsFixed(0)}%. Let\'s improve!',
        priority: RecommendationPriority.high,
        type: RecommendationType.weakTopic,
      ));
    }

    // Priority 2: Not practiced recently
    final now = DateTime.now();
    for (final entry in categoryAnalytics.entries) {
      final analytics = entry.value;
      if (analytics.lastAttemptDate != null) {
        final daysSinceLastPractice = now.difference(analytics.lastAttemptDate!).inDays;
        if (daysSinceLastPractice >= 3 && !weakTopics.contains(entry.key)) {
          recommendations.add(LearningRecommendation(
            category: entry.key,
            title: 'Review ${categoryNames[entry.key] ?? entry.key}',
            description: 'You haven\'t practiced this in $daysSinceLastPractice days',
            priority: RecommendationPriority.medium,
            type: RecommendationType.review,
          ));
        }
      }
    }

    // Priority 3: New topics to explore
    for (final category in allCategories) {
      final analytics = categoryAnalytics[category];
      if (analytics == null || analytics.totalAttempts == 0) {
        recommendations.add(LearningRecommendation(
          category: category,
          title: 'Try ${categoryNames[category] ?? category}',
          description: 'Start learning something new!',
          priority: RecommendationPriority.low,
          type: RecommendationType.newTopic,
        ));
      }
    }

    // Sort by priority
    recommendations.sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }

  // Get recommended difficulty for a category
  int getRecommendedDifficulty(String category) {
    final analytics = categoryAnalytics[category];
    if (analytics == null) return 1;
    return analytics.difficultyLevel;
  }

  // Get personalized learning path
  List<String> getLearningPath() {
    final path = <String>[];

    // Start with weak topics
    path.addAll(weakTopics.take(2));

    // Add topics that need review
    final now = DateTime.now();
    for (final entry in categoryAnalytics.entries) {
      if (path.length >= 5) break;
      if (path.contains(entry.key)) continue;

      final analytics = entry.value;
      if (analytics.lastAttemptDate != null) {
        final daysSince = now.difference(analytics.lastAttemptDate!).inDays;
        if (daysSince >= 2) {
          path.add(entry.key);
        }
      }
    }

    // Fill remaining with strong topics for confidence
    for (final topic in strongTopics) {
      if (path.length >= 5) break;
      if (!path.contains(topic)) {
        path.add(topic);
      }
    }

    return path;
  }

  // Get daily practice suggestions
  List<DailyPractice> getDailyPractice() {
    final practices = <DailyPractice>[];

    // 2 weak topics
    for (final topic in weakTopics.take(2)) {
      practices.add(DailyPractice(
        category: topic,
        name: categoryNames[topic] ?? topic,
        questionCount: 10,
        estimatedMinutes: 5,
        type: 'Improvement',
      ));
    }

    // 1 strong topic for confidence
    if (strongTopics.isNotEmpty) {
      practices.add(DailyPractice(
        category: strongTopics.first,
        name: categoryNames[strongTopics.first] ?? strongTopics.first,
        questionCount: 5,
        estimatedMinutes: 3,
        type: 'Confidence',
      ));
    }

    // 1 new topic to explore
    for (final category in allCategories) {
      final analytics = categoryAnalytics[category];
      if (analytics == null || analytics.totalAttempts == 0) {
        practices.add(DailyPractice(
          category: category,
          name: categoryNames[category] ?? category,
          questionCount: 5,
          estimatedMinutes: 3,
          type: 'Explore',
        ));
        break;
      }
    }

    return practices;
  }

  // Reset analytics for a category
  void resetCategoryAnalytics(String category) {
    categoryAnalytics[category] = CategoryAnalytics(category: category);
    _saveAnalytics(category);
    _analyzePerformance();
    _generateRecommendations();
  }

  // Reset all analytics
  void resetAllAnalytics() {
    for (final category in allCategories) {
      categoryAnalytics[category] = CategoryAnalytics(category: category);
      _box.remove('analytics_$category');
    }
    weakTopics.clear();
    strongTopics.clear();
    recommendations.clear();
    currentDifficulty.value = 1;
    overallAccuracy.value = 0.0;
  }
}

class CategoryAnalytics {
  final String category;
  int totalAttempts;
  int correctAttempts;
  int currentStreak;
  int bestStreak;
  int totalTimeSpent; // in seconds
  double averageTimePerQuestion;
  int difficultyLevel;
  DateTime? lastAttemptDate;

  CategoryAnalytics({
    required this.category,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalTimeSpent = 0,
    this.averageTimePerQuestion = 0,
    this.difficultyLevel = 1,
    this.lastAttemptDate,
  });

  double get accuracy => totalAttempts > 0 ? correctAttempts / totalAttempts : 0;

  Map<String, dynamic> toJson() => {
        'category': category,
        'totalAttempts': totalAttempts,
        'correctAttempts': correctAttempts,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'totalTimeSpent': totalTimeSpent,
        'averageTimePerQuestion': averageTimePerQuestion,
        'difficultyLevel': difficultyLevel,
        'lastAttemptDate': lastAttemptDate?.toIso8601String(),
      };

  factory CategoryAnalytics.fromJson(Map<String, dynamic> json) {
    return CategoryAnalytics(
      category: json['category'] ?? '',
      totalAttempts: json['totalAttempts'] ?? 0,
      correctAttempts: json['correctAttempts'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      totalTimeSpent: json['totalTimeSpent'] ?? 0,
      averageTimePerQuestion: (json['averageTimePerQuestion'] ?? 0).toDouble(),
      difficultyLevel: json['difficultyLevel'] ?? 1,
      lastAttemptDate: json['lastAttemptDate'] != null
          ? DateTime.tryParse(json['lastAttemptDate'])
          : null,
    );
  }
}

enum RecommendationPriority { high, medium, low }
enum RecommendationType { weakTopic, review, newTopic }

class LearningRecommendation {
  final String category;
  final String title;
  final String description;
  final RecommendationPriority priority;
  final RecommendationType type;

  LearningRecommendation({
    required this.category,
    required this.title,
    required this.description,
    required this.priority,
    required this.type,
  });
}

class DailyPractice {
  final String category;
  final String name;
  final int questionCount;
  final int estimatedMinutes;
  final String type;

  DailyPractice({
    required this.category,
    required this.name,
    required this.questionCount,
    required this.estimatedMinutes,
    required this.type,
  });
}
