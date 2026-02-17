import 'package:get_storage/get_storage.dart';

/// Local database wrapper using GetStorage
/// Provides a unified interface for all local data operations
class LocalDatabase {
  static LocalDatabase? _instance;
  static GetStorage? _storage;

  LocalDatabase._();

  /// Get singleton instance
  static LocalDatabase get instance {
    _instance ??= LocalDatabase._();
    return _instance!;
  }

  /// Initialize database
  static Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  /// Get storage instance
  GetStorage get storage {
    if (_storage == null) {
      throw Exception('LocalDatabase not initialized. Call LocalDatabase.init() first.');
    }
    return _storage!;
  }

  // ============== GENERIC OPERATIONS ==============

  /// Read data
  T? read<T>(String key) {
    return storage.read<T>(key);
  }

  /// Write data
  Future<void> write(String key, dynamic value) async {
    await storage.write(key, value);
  }

  /// Remove data
  Future<void> remove(String key) async {
    await storage.remove(key);
  }

  /// Check if key exists
  bool hasData(String key) {
    return storage.hasData(key);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await storage.erase();
  }

  /// Get all keys
  Iterable<String> get keys => storage.getKeys();

  // ============== LIST OPERATIONS ==============

  /// Read list
  List<T> readList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final data = storage.read(key);
    if (data != null && data is List) {
      return data
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  /// Write list
  Future<void> writeList<T>(
    String key,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    await storage.write(key, items.map((e) => toJson(e)).toList());
  }

  /// Add to list
  Future<void> addToList<T>(
    String key,
    T item,
    Map<String, dynamic> Function(T) toJson,
    T Function(Map<String, dynamic>) fromJson, {
    int? maxItems,
  }) async {
    final items = readList<T>(key, fromJson);
    items.add(item);

    // Limit list size if specified
    if (maxItems != null && items.length > maxItems) {
      items.removeRange(0, items.length - maxItems);
    }

    await writeList(key, items, toJson);
  }

  /// Remove from list by condition
  Future<void> removeFromList<T>(
    String key,
    bool Function(T) condition,
    Map<String, dynamic> Function(T) toJson,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final items = readList<T>(key, fromJson);
    items.removeWhere(condition);
    await writeList(key, items, toJson);
  }

  // ============== MAP OPERATIONS ==============

  /// Read map
  Map<String, T> readMap<T>(String key, T Function(dynamic) fromValue) {
    final data = storage.read(key);
    if (data != null && data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), fromValue(v)));
    }
    return {};
  }

  /// Write map
  Future<void> writeMap<T>(
    String key,
    Map<String, T> map,
    dynamic Function(T) toValue,
  ) async {
    await storage.write(key, map.map((k, v) => MapEntry(k, toValue(v))));
  }

  // ============== DATE-BASED OPERATIONS ==============

  /// Get today's key
  String get todayKey => DateTime.now().toIso8601String().split('T')[0];

  /// Read today's value
  T? readToday<T>(String baseKey) {
    return read<T>('${baseKey}_$todayKey');
  }

  /// Write today's value
  Future<void> writeToday(String baseKey, dynamic value) async {
    await write('${baseKey}_$todayKey', value);
  }

  /// Increment today's counter
  Future<int> incrementToday(String baseKey) async {
    final current = readToday<int>(baseKey) ?? 0;
    final newValue = current + 1;
    await writeToday(baseKey, newValue);
    return newValue;
  }

  // ============== CLEANUP OPERATIONS ==============

  /// Remove old dated entries (older than specified days)
  Future<void> cleanupOldEntries(String baseKey, int daysToKeep) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    final allKeys = keys.where((k) => k.startsWith(baseKey)).toList();

    for (final key in allKeys) {
      final datePart = key.replaceFirst('${baseKey}_', '');
      try {
        final date = DateTime.parse(datePart);
        if (date.isBefore(cutoffDate)) {
          await remove(key);
        }
      } catch (_) {
        // Not a dated key, skip
      }
    }
  }

  // ============== BACKUP & RESTORE ==============

  /// Export all data as JSON map
  Map<String, dynamic> exportData() {
    final Map<String, dynamic> data = {};
    for (final key in keys) {
      data[key] = storage.read(key);
    }
    return data;
  }

  /// Import data from JSON map
  Future<void> importData(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      await storage.write(entry.key, entry.value);
    }
  }

  // ============== LISTENERS ==============

  /// Listen to key changes
  void listen(String key, void Function(dynamic) callback) {
    storage.listenKey(key, callback);
  }

  /// Remove listener
  void removeListener(String key) {
    // GetStorage doesn't have a direct removeListener,
    // but you can handle this in your app logic
  }
}

/// Database keys constants
class DBKeys {
  // User
  static const String user = 'user_data';
  static const String childProfiles = 'child_profiles';
  static const String activeChild = 'active_child_id';

  // Progress
  static const String progress = 'learning_progress';
  static const String quizResults = 'quiz_results';
  static const String dailyGoals = 'daily_goals';
  static const String streak = 'daily_streak';
  static const String lastActive = 'last_active_date';

  // Rewards
  static const String badges = 'earned_badges';
  static const String trophies = 'earned_trophies';
  static const String stickers = 'earned_stickers';
  static const String points = 'total_points';
  static const String coins = 'total_coins';
  static const String level = 'current_level';
  static const String xp = 'experience_points';

  // Settings
  static const String settings = 'app_settings';
  static const String theme = 'theme_mode';
  static const String locale = 'app_locale';
  static const String parentalPin = 'parental_pin';
  static const String screenTimeLimit = 'screen_time_limit';

  // Misc
  static const String onboarding = 'onboarding_complete';
  static const String lastSync = 'last_sync_date';
  static const String offlineContent = 'offline_content';
}
