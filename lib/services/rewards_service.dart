import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

/// Rewards Service - Manages stars, badges, trophies, and achievements
class RewardsService extends GetxService {
  static RewardsService get to => Get.find<RewardsService>();

  final GetStorage _storage = GetStorage();

  // Storage keys
  static const String kStars = 'total_stars';
  static const String kBadges = 'earned_badges';
  static const String kTrophies = 'earned_trophies';
  static const String kStreak = 'daily_streak';
  static const String kLastActiveDate = 'last_active_date';
  static const String kCertificates = 'earned_certificates';
  static const String kStickers = 'earned_stickers';
  static const String kLevel = 'current_level';
  static const String kXP = 'total_xp';

  // Observable values
  final RxInt totalStars = 0.obs;
  final RxList<String> earnedBadges = <String>[].obs;
  final RxList<String> earnedTrophies = <String>[].obs;
  final RxInt dailyStreak = 0.obs;
  final RxList<String> earnedCertificates = <String>[].obs;
  final RxList<String> earnedStickers = <String>[].obs;
  final RxInt currentLevel = 1.obs;
  final RxInt totalXP = 0.obs;

  // Badge definitions
  static const Map<String, Map<String, dynamic>> badges = {
    'first_lesson': {
      'name': 'First Step',
      'description': 'Complete your first lesson',
      'icon': '🎯',
      'xpReward': 10,
    },
    'alphabet_master': {
      'name': 'Alphabet Master',
      'description': 'Learn all 26 letters',
      'icon': '🔤',
      'xpReward': 50,
    },
    'number_ninja': {
      'name': 'Number Ninja',
      'description': 'Learn numbers',
      'icon': '🔢',
      'xpReward': 100,
    },
    'animal_expert': {
      'name': 'Animal Expert',
      'description': 'Learn all animals',
      'icon': '🦁',
      'xpReward': 50,
    },
    'math_wizard': {
      'name': 'Math Wizard',
      'description': 'Complete 100 math problems',
      'icon': '🧮',
      'xpReward': 100,
    },
    'streak_3': {
      'name': '3 Day Streak',
      'description': 'Learn for 3 days in a row',
      'icon': '🔥',
      'xpReward': 30,
    },
    'streak_7': {
      'name': 'Week Warrior',
      'description': 'Learn for 7 days in a row',
      'icon': '⚡',
      'xpReward': 70,
    },
    'streak_30': {
      'name': 'Monthly Master',
      'description': 'Learn for 30 days in a row',
      'icon': '🏆',
      'xpReward': 300,
    },
    'quick_learner': {
      'name': 'Quick Learner',
      'description': 'Complete 5 lessons in one day',
      'icon': '⚡',
      'xpReward': 50,
    },
    'perfectionist': {
      'name': 'Perfectionist',
      'description': 'Get 100% in any quiz',
      'icon': '💯',
      'xpReward': 25,
    },
    'explorer': {
      'name': 'Explorer',
      'description': 'Try all learning categories',
      'icon': '🧭',
      'xpReward': 75,
    },
    'artist': {
      'name': 'Little Artist',
      'description': 'Complete 10 drawings',
      'icon': '🎨',
      'xpReward': 40,
    },
    'reader': {
      'name': 'Story Lover',
      'description': 'Read 5 stories',
      'icon': '📚',
      'xpReward': 35,
    },
    'singer': {
      'name': 'Rhyme Singer',
      'description': 'Learn 5 rhymes',
      'icon': '🎵',
      'xpReward': 35,
    },
    'hindi_hero': {
      'name': 'Hindi Hero',
      'description': 'Learn all Hindi letters',
      'icon': '🇮🇳',
      'xpReward': 75,
    },
    'table_champion': {
      'name': 'Table Champion',
      'description': 'Learn tables from 2 to 20',
      'icon': '✖️',
      'xpReward': 100,
    },
    'game_master': {
      'name': 'Game Master',
      'description': 'Win 10 games',
      'icon': '🎮',
      'xpReward': 60,
    },
    'memory_champion': {
      'name': 'Memory Champion',
      'description': 'Complete memory game in under 20 moves',
      'icon': '🧠',
      'xpReward': 50,
    },
  };

  // Trophy definitions (harder to earn)
  static const Map<String, Map<String, dynamic>> trophies = {
    'all_alphabets': {
      'name': 'Alphabet Trophy',
      'description': 'Master all alphabets (Capital & Small)',
      'icon': '🏆',
      'xpReward': 200,
    },
    'all_numbers': {
      'name': 'Numbers Trophy',
      'description': 'Learn all numbers',
      'icon': '🥇',
      'xpReward': 200,
    },
    'all_math': {
      'name': 'Math Champion',
      'description': 'Complete all math operations',
      'icon': '🏅',
      'xpReward': 300,
    },
    'all_learning_sets': {
      'name': 'Knowledge King',
      'description': 'Complete all learning sets',
      'icon': '👑',
      'xpReward': 500,
    },
    'streak_100': {
      'name': 'Century Streak',
      'description': '100 days learning streak',
      'icon': '💎',
      'xpReward': 1000,
    },
    'all_badges': {
      'name': 'Badge Collector',
      'description': 'Earn all badges',
      'icon': '🎖️',
      'xpReward': 500,
    },
  };

  // Sticker categories
  static const Map<String, List<String>> stickerCategories = {
    'animals': ['🐶', '🐱', '🐰', '🦊', '🐻', '🐼', '🦁', '🐯', '🐮', '🐷'],
    'nature': ['🌸', '🌺', '🌻', '🌹', '🌷', '🌴', '🌵', '🍀', '🌈', '⭐'],
    'food': ['🍎', '🍊', '🍋', '🍇', '🍓', '🍌', '🥕', '🍕', '🍦', '🧁'],
    'vehicles': ['🚗', '🚕', '🚌', '✈️', '🚀', '🚂', '🚁', '🛸', '🚲', '⛵'],
    'celebration': ['🎉', '🎊', '🎈', '🎁', '🏆', '🥇', '🎯', '💯', '🌟', '💫'],
  };

  // XP requirements for each level
  static const List<int> levelXPRequirements = [
    0, 50, 100, 200, 350, 500, 700, 1000, 1400, 1800, // Level 1-10
    2300, 2900, 3600, 4400, 5300, 6300, 7400, 8600, 9900, 11300, // Level 11-20
  ];

  @override
  void onInit() {
    super.onInit();
    _loadRewards();
    _checkDailyStreak();
  }

  void _loadRewards() {
    totalStars.value = _storage.read<int>(kStars) ?? 0;
    earnedBadges.value = List<String>.from(
      _storage.read<List<dynamic>>(kBadges) ?? [],
    );
    earnedTrophies.value = List<String>.from(
      _storage.read<List<dynamic>>(kTrophies) ?? [],
    );
    dailyStreak.value = _storage.read<int>(kStreak) ?? 0;
    earnedCertificates.value = List<String>.from(
      _storage.read<List<dynamic>>(kCertificates) ?? [],
    );
    earnedStickers.value = List<String>.from(
      _storage.read<List<dynamic>>(kStickers) ?? [],
    );
    currentLevel.value = _storage.read<int>(kLevel) ?? 1;
    totalXP.value = _storage.read<int>(kXP) ?? 0;
  }

  void _checkDailyStreak() {
    final lastActive = _storage.read<String>(kLastActiveDate);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastActive == null) {
      dailyStreak.value = 1;
    } else {
      final lastDate = DateTime.parse(lastActive);
      final todayDate = DateTime.parse(today);
      final difference = todayDate.difference(lastDate).inDays;

      if (difference == 1) {
        dailyStreak.value++;
        _checkStreakBadges();
      } else if (difference > 1) {
        dailyStreak.value = 1;
      }
    }

    _storage.write(kLastActiveDate, today);
    _storage.write(kStreak, dailyStreak.value);
  }

  void _checkStreakBadges() {
    if (dailyStreak.value >= 3) awardBadge('streak_3');
    if (dailyStreak.value >= 7) awardBadge('streak_7');
    if (dailyStreak.value >= 30) awardBadge('streak_30');
    if (dailyStreak.value >= 100) awardTrophy('streak_100');
  }

  // Add stars
  Future<void> addStars(int count) async {
    totalStars.value += count;
    await _storage.write(kStars, totalStars.value);
  }

  // Add XP and check level up
  Future<bool> addXP(int xp) async {
    totalXP.value += xp;
    await _storage.write(kXP, totalXP.value);

    // Check for level up
    if (currentLevel.value < levelXPRequirements.length) {
      if (totalXP.value >= levelXPRequirements[currentLevel.value]) {
        currentLevel.value++;
        await _storage.write(kLevel, currentLevel.value);
        return true; // Level up occurred
      }
    }
    return false;
  }

  // Award a badge
  Future<bool> awardBadge(String badgeId) async {
    if (earnedBadges.contains(badgeId)) return false;

    earnedBadges.add(badgeId);
    await _storage.write(kBadges, earnedBadges.toList());

    // Add XP reward for badge
    final badge = badges[badgeId];
    if (badge != null) {
      await addXP(badge['xpReward'] as int);
      await addStars(5);
    }

    // Check if all badges earned
    if (earnedBadges.length == badges.length) {
      awardTrophy('all_badges');
    }

    return true;
  }

  // Award a trophy
  Future<bool> awardTrophy(String trophyId) async {
    if (earnedTrophies.contains(trophyId)) return false;

    earnedTrophies.add(trophyId);
    await _storage.write(kTrophies, earnedTrophies.toList());

    // Add XP reward for trophy
    final trophy = trophies[trophyId];
    if (trophy != null) {
      await addXP(trophy['xpReward'] as int);
      await addStars(20);
    }

    return true;
  }

  // Award a sticker
  Future<void> awardSticker(String sticker) async {
    if (!earnedStickers.contains(sticker)) {
      earnedStickers.add(sticker);
      await _storage.write(kStickers, earnedStickers.toList());
    }
  }

  // Award a certificate
  Future<void> awardCertificate(String certificateId) async {
    if (!earnedCertificates.contains(certificateId)) {
      earnedCertificates.add(certificateId);
      await _storage.write(kCertificates, earnedCertificates.toList());
      await addXP(100);
      await addStars(50);
    }
  }

  // Check if badge is earned
  bool hasBadge(String badgeId) => earnedBadges.contains(badgeId);

  // Check if trophy is earned
  bool hasTrophy(String trophyId) => earnedTrophies.contains(trophyId);

  // Get progress to next level
  double get levelProgress {
    if (currentLevel.value >= levelXPRequirements.length) return 1.0;

    final currentLevelXP = currentLevel.value > 0
        ? levelXPRequirements[currentLevel.value - 1]
        : 0;
    final nextLevelXP = levelXPRequirements[currentLevel.value];
    final xpInCurrentLevel = totalXP.value - currentLevelXP;
    final xpNeeded = nextLevelXP - currentLevelXP;

    return (xpInCurrentLevel / xpNeeded).clamp(0.0, 1.0);
  }

  // Get XP needed for next level
  int get xpToNextLevel {
    if (currentLevel.value >= levelXPRequirements.length) return 0;
    return levelXPRequirements[currentLevel.value] - totalXP.value;
  }

  // Reset all rewards (for testing)
  Future<void> resetAllRewards() async {
    totalStars.value = 0;
    earnedBadges.clear();
    earnedTrophies.clear();
    dailyStreak.value = 0;
    earnedCertificates.clear();
    earnedStickers.clear();
    currentLevel.value = 1;
    totalXP.value = 0;

    await _storage.remove(kStars);
    await _storage.remove(kBadges);
    await _storage.remove(kTrophies);
    await _storage.remove(kStreak);
    await _storage.remove(kCertificates);
    await _storage.remove(kStickers);
    await _storage.remove(kLevel);
    await _storage.remove(kXP);
    await _storage.remove(kLastActiveDate);
  }

  /// Check and unlock badges/trophies based on progress
  /// Call this after any learning activity completes
  Future<List<String>> checkAndUnlockRewards() async {
    final unlockedRewards = <String>[];

    if (!Get.isRegistered<ProgressService>()) return unlockedRewards;
    final progressService = Get.find<ProgressService>();

    // First lesson badge - any item completed
    int totalCompleted = 0;
    for (var key in progressService.completedItems.keys) {
      totalCompleted += progressService.completedItems[key] ?? 0;
    }
    if (totalCompleted >= 1 && !hasBadge('first_lesson')) {
      await awardBadge('first_lesson');
      unlockedRewards.add('first_lesson');
    }

    // Quick learner - 5 items in one day (tracked separately)
    final todayKey = 'items_completed_${DateTime.now().toIso8601String().split('T')[0]}';
    final todayCount = _storage.read<int>(todayKey) ?? 0;
    if (todayCount >= 5 && !hasBadge('quick_learner')) {
      await awardBadge('quick_learner');
      unlockedRewards.add('quick_learner');
    }

    // Capital Letters - Alphabet Master
    final capitalProgress = progressService.getProgressPercentage(ProgressService.kCapitalLetters);
    if (capitalProgress >= 100 && !hasBadge('alphabet_master')) {
      await awardBadge('alphabet_master');
      unlockedRewards.add('alphabet_master');
    }

    // Small Letters check for trophy
    final smallProgress = progressService.getProgressPercentage(ProgressService.kSmallLetters);
    if (capitalProgress >= 100 && smallProgress >= 100 && !hasTrophy('all_alphabets')) {
      await awardTrophy('all_alphabets');
      unlockedRewards.add('all_alphabets');
    }

    // Numbers - Number Ninja badge
    final numbersProgress = progressService.getProgressPercentage(ProgressService.kNumbers);
    if (numbersProgress >= 50 && !hasBadge('number_ninja')) {
      await awardBadge('number_ninja');
      unlockedRewards.add('number_ninja');
    }
    // Numbers Trophy
    if (numbersProgress >= 100 && !hasTrophy('all_numbers')) {
      await awardTrophy('all_numbers');
      unlockedRewards.add('all_numbers');
    }

    // Hindi Hero - Hindi Letters
    final hindiProgress = progressService.getProgressPercentage(ProgressService.kHindiLetters);
    if (hindiProgress >= 100 && !hasBadge('hindi_hero')) {
      await awardBadge('hindi_hero');
      unlockedRewards.add('hindi_hero');
    }

    // Table Champion - Tables
    final tablesProgress = progressService.getProgressPercentage(ProgressService.kTables);
    if (tablesProgress >= 50 && !hasBadge('table_champion')) {
      await awardBadge('table_champion');
      unlockedRewards.add('table_champion');
    }

    // Animal Expert
    final animalsProgress = progressService.getProgressPercentage(ProgressService.kAnimals);
    if (animalsProgress >= 100 && !hasBadge('animal_expert')) {
      await awardBadge('animal_expert');
      unlockedRewards.add('animal_expert');
    }

    // Math Wizard - Complete 100 math problems total
    final mathAddition = progressService.getCompletedCount(ProgressService.kMathAddition);
    final mathSubtraction = progressService.getCompletedCount(ProgressService.kMathSubtraction);
    final mathMultiplication = progressService.getCompletedCount(ProgressService.kMathMultiplication);
    final mathDivision = progressService.getCompletedCount(ProgressService.kMathDivision);
    final totalMath = mathAddition + mathSubtraction + mathMultiplication + mathDivision;
    if (totalMath >= 100 && !hasBadge('math_wizard')) {
      await awardBadge('math_wizard');
      unlockedRewards.add('math_wizard');
    }

    // Math Champion Trophy - All math operations complete
    final addProgress = progressService.getProgressPercentage(ProgressService.kMathAddition);
    final subProgress = progressService.getProgressPercentage(ProgressService.kMathSubtraction);
    final mulProgress = progressService.getProgressPercentage(ProgressService.kMathMultiplication);
    final divProgress = progressService.getProgressPercentage(ProgressService.kMathDivision);
    if (addProgress >= 100 && subProgress >= 100 && mulProgress >= 100 && divProgress >= 100 && !hasTrophy('all_math')) {
      await awardTrophy('all_math');
      unlockedRewards.add('all_math');
    }

    // Story Lover - 5 stories
    final storiesCount = progressService.getCompletedCount(ProgressService.kStories);
    if (storiesCount >= 5 && !hasBadge('reader')) {
      await awardBadge('reader');
      unlockedRewards.add('reader');
    }

    // Rhyme Singer - 5 rhymes
    final rhymesCount = progressService.getCompletedCount(ProgressService.kRhymes);
    if (rhymesCount >= 5 && !hasBadge('singer')) {
      await awardBadge('singer');
      unlockedRewards.add('singer');
    }

    // Little Artist - 10 drawings
    final coloringCount = progressService.getCompletedCount(ProgressService.kColoring);
    if (coloringCount >= 10 && !hasBadge('artist')) {
      await awardBadge('artist');
      unlockedRewards.add('artist');
    }

    // Explorer - Try all major categories (at least 1 item in each)
    final explorerCategories = [
      ProgressService.kNumbers,
      ProgressService.kCapitalLetters,
      ProgressService.kHindiLetters,
      ProgressService.kTables,
      ProgressService.kAnimals,
      ProgressService.kFruits,
      ProgressService.kColors,
    ];
    bool allCategoriesTried = true;
    for (var cat in explorerCategories) {
      if ((progressService.completedItems[cat] ?? 0) == 0) {
        allCategoriesTried = false;
        break;
      }
    }
    if (allCategoriesTried && !hasBadge('explorer')) {
      await awardBadge('explorer');
      unlockedRewards.add('explorer');
    }

    // Knowledge King Trophy - All learning sets complete
    final learningSetKeys = [
      ProgressService.kAnimals,
      ProgressService.kBirds,
      ProgressService.kFruits,
      ProgressService.kVegetables,
      ProgressService.kFlowers,
      ProgressService.kColors,
      ProgressService.kBodyParts,
      ProgressService.kMonths,
      ProgressService.kWeekDays,
      ProgressService.kShapes,
      ProgressService.kVehicles,
      ProgressService.kSeasons,
    ];
    bool allSetsComplete = true;
    for (var key in learningSetKeys) {
      if (progressService.getProgressPercentage(key) < 100) {
        allSetsComplete = false;
        break;
      }
    }
    if (allSetsComplete && !hasTrophy('all_learning_sets')) {
      await awardTrophy('all_learning_sets');
      unlockedRewards.add('all_learning_sets');
    }

    return unlockedRewards;
  }

  /// Track item completion for daily count
  Future<void> trackItemCompleted() async {
    final todayKey = 'items_completed_${DateTime.now().toIso8601String().split('T')[0]}';
    final currentCount = _storage.read<int>(todayKey) ?? 0;
    await _storage.write(todayKey, currentCount + 1);

    // Add XP for completing an item
    await addXP(5);
    await addStars(1);

    // Check for new rewards
    await checkAndUnlockRewards();
  }

  /// Award perfectionist badge for 100% quiz score
  Future<void> onPerfectQuizScore() async {
    if (!hasBadge('perfectionist')) {
      await awardBadge('perfectionist');
    }
  }

  /// Track game wins
  Future<void> onGameWon() async {
    final gamesWonKey = 'total_games_won';
    final currentWins = _storage.read<int>(gamesWonKey) ?? 0;
    await _storage.write(gamesWonKey, currentWins + 1);

    if (currentWins + 1 >= 10 && !hasBadge('game_master')) {
      await awardBadge('game_master');
    }

    await addXP(10);
    await addStars(2);
  }

  /// Track memory game completion
  Future<void> onMemoryGameComplete(int moves) async {
    if (moves <= 20 && !hasBadge('memory_champion')) {
      await awardBadge('memory_champion');
    }
    await addXP(15);
  }
}
