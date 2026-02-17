import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/data/models/reward_model.dart';

/// Repository for rewards and gamification data operations
class RewardRepository {
  final GetStorage _storage = GetStorage();
  static const String _badgesKey = 'earned_badges';
  static const String _trophiesKey = 'earned_trophies';
  static const String _stickersKey = 'earned_stickers';
  static const String _pointsKey = 'total_points';
  static const String _coinsKey = 'total_coins';
  static const String _levelKey = 'current_level';
  static const String _xpKey = 'experience_points';
  static const String _spinHistoryKey = 'spin_history';
  static const String _mysteryBoxHistoryKey = 'mystery_box_history';
  static const String _scratchCardHistoryKey = 'scratch_card_history';

  // ============== BADGES ==============

  /// Get all earned badges
  List<BadgeModel> getEarnedBadges() {
    final data = _storage.read(_badgesKey);
    if (data != null) {
      return (data as List)
          .map((e) => BadgeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  /// Check if badge is earned
  bool hasBadge(String badgeId) {
    return getEarnedBadges().any((b) => b.id == badgeId);
  }

  /// Award badge
  Future<void> awardBadge(BadgeModel badge) async {
    if (!hasBadge(badge.id)) {
      final badges = getEarnedBadges();
      badges.add(badge);
      await _storage.write(_badgesKey, badges.map((e) => e.toJson()).toList());
    }
  }

  // ============== TROPHIES ==============

  /// Get all earned trophies
  List<TrophyModel> getEarnedTrophies() {
    final data = _storage.read(_trophiesKey);
    if (data != null) {
      return (data as List)
          .map((e) => TrophyModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  /// Award trophy
  Future<void> awardTrophy(TrophyModel trophy) async {
    final trophies = getEarnedTrophies();
    if (!trophies.any((t) => t.id == trophy.id)) {
      trophies.add(trophy);
      await _storage.write(_trophiesKey, trophies.map((e) => e.toJson()).toList());
    }
  }

  // ============== STICKERS ==============

  /// Get all earned stickers
  List<StickerModel> getEarnedStickers() {
    final data = _storage.read(_stickersKey);
    if (data != null) {
      return (data as List)
          .map((e) => StickerModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  /// Award sticker
  Future<void> awardSticker(StickerModel sticker) async {
    final stickers = getEarnedStickers();
    stickers.add(sticker);
    await _storage.write(_stickersKey, stickers.map((e) => e.toJson()).toList());
  }

  // ============== POINTS & COINS ==============

  /// Get total points
  int getTotalPoints() {
    return _storage.read(_pointsKey) ?? 0;
  }

  /// Add points
  Future<void> addPoints(int points) async {
    final current = getTotalPoints();
    await _storage.write(_pointsKey, current + points);
    // Also add XP for leveling
    await addXP(points);
  }

  /// Get total coins
  int getTotalCoins() {
    return _storage.read(_coinsKey) ?? 0;
  }

  /// Add coins
  Future<void> addCoins(int coins) async {
    final current = getTotalCoins();
    await _storage.write(_coinsKey, current + coins);
  }

  /// Spend coins (returns true if successful)
  Future<bool> spendCoins(int coins) async {
    final current = getTotalCoins();
    if (current >= coins) {
      await _storage.write(_coinsKey, current - coins);
      return true;
    }
    return false;
  }

  // ============== LEVEL & XP ==============

  /// Get current level
  int getCurrentLevel() {
    return _storage.read(_levelKey) ?? 1;
  }

  /// Get experience points
  int getXP() {
    return _storage.read(_xpKey) ?? 0;
  }

  /// Get XP required for next level
  int getXPForNextLevel() {
    final level = getCurrentLevel();
    return level * 100 + (level - 1) * 50; // Progressive XP requirement
  }

  /// Add XP and handle level up
  Future<bool> addXP(int xp) async {
    final currentXP = getXP();
    final newXP = currentXP + xp;
    final requiredXP = getXPForNextLevel();

    if (newXP >= requiredXP) {
      // Level up!
      final currentLevel = getCurrentLevel();
      await _storage.write(_levelKey, currentLevel + 1);
      await _storage.write(_xpKey, newXP - requiredXP);
      return true; // Indicates level up
    } else {
      await _storage.write(_xpKey, newXP);
      return false;
    }
  }

  // ============== SPIN WHEEL ==============

  /// Get today's spin count
  int getTodaySpinCount() {
    final history = _getSpinHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return history[today] ?? 0;
  }

  /// Can spin today
  bool canSpinToday() {
    return getTodaySpinCount() < 3;
  }

  /// Record spin
  Future<void> recordSpin() async {
    final history = _getSpinHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    history[today] = (history[today] ?? 0) + 1;
    await _storage.write(_spinHistoryKey, history);
  }

  Map<String, int> _getSpinHistory() {
    final data = _storage.read(_spinHistoryKey);
    if (data != null) {
      return Map<String, int>.from(data);
    }
    return {};
  }

  // ============== MYSTERY BOX ==============

  /// Get today's mystery box count
  int getTodayMysteryBoxCount() {
    final history = _getMysteryBoxHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return history[today] ?? 0;
  }

  /// Can open mystery box today
  bool canOpenMysteryBoxToday() {
    return getTodayMysteryBoxCount() < 2;
  }

  /// Record mystery box open
  Future<void> recordMysteryBoxOpen() async {
    final history = _getMysteryBoxHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    history[today] = (history[today] ?? 0) + 1;
    await _storage.write(_mysteryBoxHistoryKey, history);
  }

  Map<String, int> _getMysteryBoxHistory() {
    final data = _storage.read(_mysteryBoxHistoryKey);
    if (data != null) {
      return Map<String, int>.from(data);
    }
    return {};
  }

  // ============== SCRATCH CARD ==============

  /// Get today's scratch card count
  int getTodayScratchCardCount() {
    final history = _getScratchCardHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return history[today] ?? 0;
  }

  /// Can scratch today
  bool canScratchToday() {
    return getTodayScratchCardCount() < 1;
  }

  /// Record scratch card
  Future<void> recordScratchCard() async {
    final history = _getScratchCardHistory();
    final today = DateTime.now().toIso8601String().split('T')[0];
    history[today] = (history[today] ?? 0) + 1;
    await _storage.write(_scratchCardHistoryKey, history);
  }

  Map<String, int> _getScratchCardHistory() {
    final data = _storage.read(_scratchCardHistoryKey);
    if (data != null) {
      return Map<String, int>.from(data);
    }
    return {};
  }

  // ============== SUMMARY ==============

  /// Get rewards summary
  RewardsSummary getRewardsSummary() {
    return RewardsSummary(
      stars: getTotalPoints(),
      coins: getTotalCoins(),
      xp: getXP(),
      level: getCurrentLevel(),
      dailyStreak: 0, // Retrieved from progress repository
      badges: getEarnedBadges(),
      trophies: getEarnedTrophies(),
    );
  }

  // ============== RESET ==============

  /// Reset all rewards (for testing or new profile)
  Future<void> resetAll() async {
    await _storage.remove(_badgesKey);
    await _storage.remove(_trophiesKey);
    await _storage.remove(_stickersKey);
    await _storage.remove(_pointsKey);
    await _storage.remove(_coinsKey);
    await _storage.remove(_levelKey);
    await _storage.remove(_xpKey);
    await _storage.remove(_spinHistoryKey);
    await _storage.remove(_mysteryBoxHistoryKey);
    await _storage.remove(_scratchCardHistoryKey);
  }
}
