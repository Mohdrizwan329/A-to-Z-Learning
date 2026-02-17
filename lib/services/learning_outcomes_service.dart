import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Learning outcome model for each module
class LearningOutcome {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final List<String> objectives;
  final int targetScore;
  final int currentScore;
  final bool isCompleted;
  final DateTime? completedAt;

  LearningOutcome({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.objectives,
    required this.targetScore,
    this.currentScore = 0,
    this.isCompleted = false,
    this.completedAt,
  });

  double get progressPercentage =>
      targetScore > 0 ? (currentScore / targetScore * 100).clamp(0, 100) : 0;

  factory LearningOutcome.fromJson(Map<String, dynamic> json) {
    return LearningOutcome(
      id: json['id'] ?? '',
      moduleId: json['moduleId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      objectives: List<String>.from(json['objectives'] ?? []),
      targetScore: json['targetScore'] ?? 100,
      currentScore: json['currentScore'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'title': title,
      'description': description,
      'objectives': objectives,
      'targetScore': targetScore,
      'currentScore': currentScore,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  LearningOutcome copyWith({
    int? currentScore,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return LearningOutcome(
      id: id,
      moduleId: moduleId,
      title: title,
      description: description,
      objectives: objectives,
      targetScore: targetScore,
      currentScore: currentScore ?? this.currentScore,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Milestone model for achievements
class LearningMilestone {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int requiredOutcomes;
  final int currentOutcomes;
  final String category;
  final String certificateType;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  LearningMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.requiredOutcomes,
    this.currentOutcomes = 0,
    required this.category,
    required this.certificateType,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  double get progressPercentage =>
      requiredOutcomes > 0 ? (currentOutcomes / requiredOutcomes * 100).clamp(0, 100) : 0;

  factory LearningMilestone.fromJson(Map<String, dynamic> json) {
    return LearningMilestone(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      emoji: json['emoji'] ?? '🏆',
      requiredOutcomes: json['requiredOutcomes'] ?? 5,
      currentOutcomes: json['currentOutcomes'] ?? 0,
      category: json['category'] ?? 'general',
      certificateType: json['certificateType'] ?? 'basic',
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'emoji': emoji,
      'requiredOutcomes': requiredOutcomes,
      'currentOutcomes': currentOutcomes,
      'category': category,
      'certificateType': certificateType,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  LearningMilestone copyWith({
    int? currentOutcomes,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return LearningMilestone(
      id: id,
      title: title,
      description: description,
      emoji: emoji,
      requiredOutcomes: requiredOutcomes,
      currentOutcomes: currentOutcomes ?? this.currentOutcomes,
      category: category,
      certificateType: certificateType,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

/// Service for tracking learning outcomes and milestones
class LearningOutcomesService extends GetxService {
  static LearningOutcomesService get to => Get.find();

  final GetStorage _storage = GetStorage();
  static const String _outcomesKey = 'learning_outcomes';
  static const String _milestonesKey = 'learning_milestones';
  static const String _pathKey = 'learning_path';

  final RxMap<String, LearningOutcome> outcomes = <String, LearningOutcome>{}.obs;
  final RxMap<String, LearningMilestone> milestones = <String, LearningMilestone>{}.obs;
  final RxList<String> recommendedPath = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultOutcomes();
    _initializeDefaultMilestones();
    _loadProgress();
    _generateRecommendations();
  }

  void _initializeDefaultOutcomes() {
    final defaultOutcomes = [
      // Numbers Module
      LearningOutcome(
        id: 'numbers_1_10',
        moduleId: 'numbers',
        title: 'Count 1-10',
        description: 'Learn to count from 1 to 10',
        objectives: ['Recognize numbers 1-10', 'Count objects up to 10', 'Write numbers 1-10'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'numbers_11_20',
        moduleId: 'numbers',
        title: 'Count 11-20',
        description: 'Learn to count from 11 to 20',
        objectives: ['Recognize numbers 11-20', 'Understand teen numbers', 'Count backward'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'numbers_21_100',
        moduleId: 'numbers',
        title: 'Count to 100',
        description: 'Master counting from 21 to 100',
        objectives: ['Count by 10s', 'Recognize two-digit numbers', 'Number sequencing'],
        targetScore: 100,
      ),

      // Alphabet Module
      LearningOutcome(
        id: 'alphabet_capital',
        moduleId: 'alphabet',
        title: 'Capital Letters A-Z',
        description: 'Learn all 26 capital letters',
        objectives: ['Recognize all capitals', 'Know letter sounds', 'Write capital letters'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'alphabet_small',
        moduleId: 'alphabet',
        title: 'Small Letters a-z',
        description: 'Learn all 26 small letters',
        objectives: ['Recognize small letters', 'Match with capitals', 'Write small letters'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'alphabet_phonics',
        moduleId: 'alphabet',
        title: 'Letter Sounds',
        description: 'Learn phonetic sounds of letters',
        objectives: ['Sound out letters', 'Beginning sounds', 'Blend simple words'],
        targetScore: 100,
      ),

      // Math Module
      LearningOutcome(
        id: 'math_addition',
        moduleId: 'math',
        title: 'Basic Addition',
        description: 'Learn to add numbers',
        objectives: ['Add single digits', 'Use number line', 'Mental math'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'math_subtraction',
        moduleId: 'math',
        title: 'Basic Subtraction',
        description: 'Learn to subtract numbers',
        objectives: ['Subtract single digits', 'Take away concept', 'Word problems'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'math_tables',
        moduleId: 'math',
        title: 'Times Tables',
        description: 'Learn multiplication tables 2-10',
        objectives: ['2-5 tables', '6-10 tables', 'Quick recall'],
        targetScore: 100,
      ),

      // Colors & Shapes
      LearningOutcome(
        id: 'colors_basic',
        moduleId: 'colors',
        title: 'Primary Colors',
        description: 'Learn basic colors',
        objectives: ['Red, Blue, Yellow', 'Green, Orange, Purple', 'Color mixing'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'shapes_basic',
        moduleId: 'shapes',
        title: '2D Shapes',
        description: 'Learn basic 2D shapes',
        objectives: ['Circle, Square, Triangle', 'Rectangle, Oval', 'Shape properties'],
        targetScore: 100,
      ),

      // Hindi Module
      LearningOutcome(
        id: 'hindi_vowels',
        moduleId: 'hindi',
        title: 'Hindi Swar (Vowels)',
        description: 'Learn Hindi vowels',
        objectives: ['अ to अः', 'Vowel sounds', 'Writing practice'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'hindi_consonants',
        moduleId: 'hindi',
        title: 'Hindi Vyanjan',
        description: 'Learn Hindi consonants',
        objectives: ['क to ञ', 'ट to न', 'प to ह'],
        targetScore: 100,
      ),

      // GK Module
      LearningOutcome(
        id: 'gk_animals',
        moduleId: 'gk',
        title: 'Animal Kingdom',
        description: 'Learn about animals',
        objectives: ['Domestic animals', 'Wild animals', 'Animal sounds'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'gk_body_parts',
        moduleId: 'gk',
        title: 'My Body',
        description: 'Learn body parts',
        objectives: ['Face parts', 'Body parts', 'Senses'],
        targetScore: 100,
      ),
      LearningOutcome(
        id: 'gk_nature',
        moduleId: 'gk',
        title: 'Nature & Environment',
        description: 'Learn about nature',
        objectives: ['Plants & Trees', 'Weather', 'Seasons'],
        targetScore: 100,
      ),
    ];

    for (final outcome in defaultOutcomes) {
      if (!outcomes.containsKey(outcome.id)) {
        outcomes[outcome.id] = outcome;
      }
    }
  }

  void _initializeDefaultMilestones() {
    final defaultMilestones = [
      // Numbers Milestones
      LearningMilestone(
        id: 'numbers_beginner',
        title: 'Number Explorer',
        description: 'Complete basic number learning',
        emoji: '🔢',
        requiredOutcomes: 1,
        category: 'numbers',
        certificateType: 'numbers_beginner',
      ),
      LearningMilestone(
        id: 'numbers_master',
        title: 'Number Master',
        description: 'Master all number outcomes',
        emoji: '🏆',
        requiredOutcomes: 3,
        category: 'numbers',
        certificateType: 'numbers_master',
      ),

      // Alphabet Milestones
      LearningMilestone(
        id: 'alphabet_beginner',
        title: 'Letter Learner',
        description: 'Start your alphabet journey',
        emoji: '🔤',
        requiredOutcomes: 1,
        category: 'alphabet',
        certificateType: 'alphabet_beginner',
      ),
      LearningMilestone(
        id: 'alphabet_master',
        title: 'Alphabet Champion',
        description: 'Master all letters',
        emoji: '👑',
        requiredOutcomes: 3,
        category: 'alphabet',
        certificateType: 'alphabet_master',
      ),

      // Math Milestones
      LearningMilestone(
        id: 'math_beginner',
        title: 'Math Explorer',
        description: 'Begin math adventures',
        emoji: '➕',
        requiredOutcomes: 1,
        category: 'math',
        certificateType: 'math_beginner',
      ),
      LearningMilestone(
        id: 'math_master',
        title: 'Math Genius',
        description: 'Master all math concepts',
        emoji: '🧮',
        requiredOutcomes: 3,
        category: 'math',
        certificateType: 'math_master',
      ),

      // Hindi Milestones
      LearningMilestone(
        id: 'hindi_beginner',
        title: 'Hindi Starter',
        description: 'Start learning Hindi',
        emoji: '📚',
        requiredOutcomes: 1,
        category: 'hindi',
        certificateType: 'hindi_beginner',
      ),
      LearningMilestone(
        id: 'hindi_master',
        title: 'Hindi Expert',
        description: 'Master Hindi letters',
        emoji: '🎓',
        requiredOutcomes: 2,
        category: 'hindi',
        certificateType: 'hindi_master',
      ),

      // GK Milestones
      LearningMilestone(
        id: 'gk_explorer',
        title: 'Knowledge Seeker',
        description: 'Explore the world',
        emoji: '🌍',
        requiredOutcomes: 1,
        category: 'gk',
        certificateType: 'gk_beginner',
      ),
      LearningMilestone(
        id: 'gk_master',
        title: 'Knowledge Champion',
        description: 'Master general knowledge',
        emoji: '🧠',
        requiredOutcomes: 3,
        category: 'gk',
        certificateType: 'gk_master',
      ),

      // Overall Milestones
      LearningMilestone(
        id: 'all_rounder',
        title: 'All-Rounder',
        description: 'Complete outcomes in all categories',
        emoji: '⭐',
        requiredOutcomes: 5,
        category: 'overall',
        certificateType: 'all_rounder',
      ),
      LearningMilestone(
        id: 'super_learner',
        title: 'Super Learner',
        description: 'Complete 10 learning outcomes',
        emoji: '🌟',
        requiredOutcomes: 10,
        category: 'overall',
        certificateType: 'super_learner',
      ),
      LearningMilestone(
        id: 'learning_champion',
        title: 'Learning Champion',
        description: 'Complete all learning outcomes',
        emoji: '🏅',
        requiredOutcomes: 16,
        category: 'overall',
        certificateType: 'learning_champion',
      ),
    ];

    for (final milestone in defaultMilestones) {
      if (!milestones.containsKey(milestone.id)) {
        milestones[milestone.id] = milestone;
      }
    }
  }

  void _loadProgress() {
    // Load outcomes progress
    final outcomesData = _storage.read(_outcomesKey);
    if (outcomesData != null) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(outcomesData);
      for (final entry in map.entries) {
        if (outcomes.containsKey(entry.key)) {
          outcomes[entry.key] = LearningOutcome.fromJson(
            Map<String, dynamic>.from(entry.value),
          );
        }
      }
    }

    // Load milestones progress
    final milestonesData = _storage.read(_milestonesKey);
    if (milestonesData != null) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(milestonesData);
      for (final entry in map.entries) {
        if (milestones.containsKey(entry.key)) {
          milestones[entry.key] = LearningMilestone.fromJson(
            Map<String, dynamic>.from(entry.value),
          );
        }
      }
    }
  }

  Future<void> _saveProgress() async {
    await _storage.write(
      _outcomesKey,
      outcomes.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _storage.write(
      _milestonesKey,
      milestones.map((key, value) => MapEntry(key, value.toJson())),
    );
  }

  /// Update progress for a learning outcome
  Future<void> updateOutcomeProgress(String outcomeId, int score) async {
    if (!outcomes.containsKey(outcomeId)) return;

    final outcome = outcomes[outcomeId]!;
    final newScore = (outcome.currentScore + score).clamp(0, outcome.targetScore);
    final isCompleted = newScore >= outcome.targetScore;

    outcomes[outcomeId] = outcome.copyWith(
      currentScore: newScore,
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
    );

    await _saveProgress();
    await _updateMilestones();
    _generateRecommendations();
  }

  /// Mark outcome as completed
  Future<void> completeOutcome(String outcomeId) async {
    if (!outcomes.containsKey(outcomeId)) return;

    final outcome = outcomes[outcomeId]!;
    outcomes[outcomeId] = outcome.copyWith(
      currentScore: outcome.targetScore,
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    await _saveProgress();
    await _updateMilestones();
    _generateRecommendations();
  }

  Future<void> _updateMilestones() async {
    final completedOutcomes = outcomes.values.where((o) => o.isCompleted).toList();
    final completedByCategory = <String, int>{};

    for (final outcome in completedOutcomes) {
      completedByCategory[outcome.moduleId] =
          (completedByCategory[outcome.moduleId] ?? 0) + 1;
    }

    for (final entry in milestones.entries) {
      final milestone = entry.value;
      int currentOutcomes;

      if (milestone.category == 'overall') {
        currentOutcomes = completedOutcomes.length;
      } else {
        currentOutcomes = completedByCategory[milestone.category] ?? 0;
      }

      final isUnlocked = currentOutcomes >= milestone.requiredOutcomes;

      if (milestone.currentOutcomes != currentOutcomes || milestone.isUnlocked != isUnlocked) {
        milestones[entry.key] = milestone.copyWith(
          currentOutcomes: currentOutcomes,
          isUnlocked: isUnlocked,
          unlockedAt: isUnlocked && !milestone.isUnlocked ? DateTime.now() : milestone.unlockedAt,
        );
      }
    }

    await _saveProgress();
  }

  void _generateRecommendations() {
    final incomplete = outcomes.values
        .where((o) => !o.isCompleted)
        .toList();

    // Sort by progress (prioritize nearly complete)
    incomplete.sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));

    // Group by category for variety
    final byCategory = <String, List<LearningOutcome>>{};
    for (final outcome in incomplete) {
      byCategory.putIfAbsent(outcome.moduleId, () => []).add(outcome);
    }

    // Create recommended path
    recommendedPath.clear();
    final categories = byCategory.keys.toList();
    int index = 0;

    while (recommendedPath.length < 5 && categories.isNotEmpty) {
      final category = categories[index % categories.length];
      if (byCategory[category]!.isNotEmpty) {
        recommendedPath.add(byCategory[category]!.removeAt(0).id);
      }
      if (byCategory[category]!.isEmpty) {
        categories.remove(category);
      }
      index++;
    }

    _storage.write(_pathKey, recommendedPath.toList());
  }

  /// Get outcomes for a specific module
  List<LearningOutcome> getOutcomesForModule(String moduleId) {
    return outcomes.values.where((o) => o.moduleId == moduleId).toList();
  }

  /// Get milestones for a specific category
  List<LearningMilestone> getMilestonesForCategory(String category) {
    return milestones.values.where((m) => m.category == category || m.category == 'overall').toList();
  }

  /// Get overall progress
  double get overallProgress {
    if (outcomes.isEmpty) return 0;
    final total = outcomes.values.fold(0.0, (sum, o) => sum + o.progressPercentage);
    return total / outcomes.length;
  }

  /// Get completed outcomes count
  int get completedOutcomesCount {
    return outcomes.values.where((o) => o.isCompleted).length;
  }

  /// Get unlocked milestones count
  int get unlockedMilestonesCount {
    return milestones.values.where((m) => m.isUnlocked).length;
  }

  /// Get next recommended outcome
  LearningOutcome? get nextRecommendedOutcome {
    if (recommendedPath.isEmpty) return null;
    return outcomes[recommendedPath.first];
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    _initializeDefaultOutcomes();
    _initializeDefaultMilestones();
    await _storage.remove(_outcomesKey);
    await _storage.remove(_milestonesKey);
    await _storage.remove(_pathKey);
    _generateRecommendations();
  }
}
