import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Mixin for controllers that need cache functionality
/// Provides standardized cache load/save operations
mixin CacheMixin on GetxController {
  final GetStorage _cacheBox = GetStorage();

  /// Override this to provide cache key for your controller
  String get cacheKey;

  /// Selected indices stored in cache
  final RxSet<int> selectedIndex = <int>{}.obs;

  /// Load selected indices from cache
  void loadFromCache() {
    try {
      final saved = _cacheBox.read<dynamic>(cacheKey);
      if (saved != null && saved.isNotEmpty) {
        selectedIndex.addAll(saved.cast<int>().toSet());
        debugPrint("$cacheKey: Loaded ${selectedIndex.length} items from cache");
      }
    } catch (e) {
      debugPrint("Error loading cache for $cacheKey: $e");
      clearCache();
    }
  }

  /// Save selected indices to cache
  Future<void> saveToCache() async {
    try {
      await _cacheBox.write(cacheKey, selectedIndex.toList());
      debugPrint("$cacheKey: Saved ${selectedIndex.length} items to cache");
    } catch (e) {
      debugPrint("Error saving cache for $cacheKey: $e");
    }
  }

  /// Clear cache for this controller
  Future<void> clearCache() async {
    try {
      await _cacheBox.remove(cacheKey);
      selectedIndex.clear();
      debugPrint("$cacheKey: Cache cleared");
    } catch (e) {
      debugPrint("Error clearing cache for $cacheKey: $e");
    }
  }

  /// Toggle item selection and save to cache
  void toggleSelection(int index) {
    if (selectedIndex.contains(index)) {
      selectedIndex.remove(index);
    } else {
      selectedIndex.add(index);
    }
    saveToCache();
  }

  /// Select item if not already selected
  void selectItem(int index) {
    if (!selectedIndex.contains(index)) {
      selectedIndex.add(index);
      saveToCache();
    }
  }

  /// Check if item is selected
  bool isSelected(int index) => selectedIndex.contains(index);

  /// Get count of selected items
  int get selectedCount => selectedIndex.length;

  /// Reset all selections
  Future<void> resetSelection() async {
    selectedIndex.clear();
    await clearCache();
  }
}

/// Generic cache helper for non-controller usage
class CacheHelper {
  static final GetStorage _box = GetStorage();

  /// Save a value to cache
  static Future<void> save<T>(String key, T value) async {
    await _box.write(key, value);
  }

  /// Read a value from cache
  static T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Remove a value from cache
  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Check if key exists in cache
  static bool hasKey(String key) {
    return _box.hasData(key);
  }

  /// Clear all cache
  static Future<void> clearAll() async {
    await _box.erase();
  }

  /// Save set of integers (commonly used for selections)
  static Future<void> saveIntSet(String key, Set<int> values) async {
    await _box.write(key, values.toList());
  }

  /// Read set of integers from cache
  static Set<int> readIntSet(String key) {
    try {
      final data = _box.read<dynamic>(key);
      if (data != null && data is List) {
        return data.cast<int>().toSet();
      }
    } catch (e) {
      debugPrint("Error reading int set from cache: $e");
    }
    return {};
  }
}
