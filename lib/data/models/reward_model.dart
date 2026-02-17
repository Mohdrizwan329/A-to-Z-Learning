/// Badge model for achievements
class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String category;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      emoji: json['emoji'] ?? '🏅',
      category: json['category'] ?? 'general',
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'category': category,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}

/// Trophy model for major achievements
class TrophyModel {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String rarity; // common, rare, epic, legendary
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const TrophyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.rarity = 'common',
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory TrophyModel.fromJson(Map<String, dynamic> json) {
    return TrophyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      emoji: json['emoji'] ?? '🏆',
      rarity: json['rarity'] ?? 'common',
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'rarity': rarity,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}

/// Sticker model for collectibles
class StickerModel {
  final String id;
  final String emoji;
  final String category;
  final int count;
  final bool isNew;

  const StickerModel({
    required this.id,
    required this.emoji,
    required this.category,
    this.count = 0,
    this.isNew = false,
  });

  factory StickerModel.fromJson(Map<String, dynamic> json) {
    return StickerModel(
      id: json['id'] ?? '',
      emoji: json['emoji'] ?? '⭐',
      category: json['category'] ?? 'general',
      count: json['count'] ?? 0,
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emoji': emoji,
      'category': category,
      'count': count,
      'isNew': isNew,
    };
  }
}

/// User rewards summary
class RewardsSummary {
  final int stars;
  final int coins;
  final int xp;
  final int level;
  final int dailyStreak;
  final List<BadgeModel> badges;
  final List<TrophyModel> trophies;

  const RewardsSummary({
    this.stars = 0,
    this.coins = 0,
    this.xp = 0,
    this.level = 1,
    this.dailyStreak = 0,
    this.badges = const [],
    this.trophies = const [],
  });

  int get unlockedBadges => badges.where((b) => b.isUnlocked).length;
  int get unlockedTrophies => trophies.where((t) => t.isUnlocked).length;

  factory RewardsSummary.fromJson(Map<String, dynamic> json) {
    return RewardsSummary(
      stars: json['stars'] ?? 0,
      coins: json['coins'] ?? 0,
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 1,
      dailyStreak: json['dailyStreak'] ?? 0,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((b) => BadgeModel.fromJson(b))
              .toList() ??
          [],
      trophies: (json['trophies'] as List<dynamic>?)
              ?.map((t) => TrophyModel.fromJson(t))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'coins': coins,
      'xp': xp,
      'level': level,
      'dailyStreak': dailyStreak,
      'badges': badges.map((b) => b.toJson()).toList(),
      'trophies': trophies.map((t) => t.toJson()).toList(),
    };
  }
}
