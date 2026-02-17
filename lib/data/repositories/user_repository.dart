import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/data/models/user_model.dart';

/// Repository for user-related data operations
class UserRepository {
  final GetStorage _storage = GetStorage();
  static const String _userKey = 'current_user';
  static const String _childProfilesKey = 'child_profiles';
  static const String _activeChildKey = 'active_child';

  // ============== USER OPERATIONS ==============

  /// Get current user
  UserModel? getCurrentUser() {
    final data = _storage.read(_userKey);
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// Save current user
  Future<void> saveUser(UserModel user) async {
    await _storage.write(_userKey, user.toJson());
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    await _storage.write(_userKey, user.toJson());
  }

  /// Delete user (logout)
  Future<void> deleteUser() async {
    await _storage.remove(_userKey);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _storage.hasData(_userKey);
  }

  // ============== CHILD PROFILES OPERATIONS ==============

  /// Get all child profiles
  List<ChildProfileModel> getChildProfiles() {
    final data = _storage.read(_childProfilesKey);
    if (data != null) {
      return (data as List).map((e) =>
        ChildProfileModel.fromJson(Map<String, dynamic>.from(e))
      ).toList();
    }
    return [];
  }

  /// Add new child profile
  Future<void> addChildProfile(ChildProfileModel child) async {
    final profiles = getChildProfiles();
    profiles.add(child);
    await _storage.write(_childProfilesKey, profiles.map((e) => e.toJson()).toList());
  }

  /// Update child profile
  Future<void> updateChildProfile(ChildProfileModel child) async {
    final profiles = getChildProfiles();
    final index = profiles.indexWhere((p) => p.id == child.id);
    if (index != -1) {
      profiles[index] = child;
      await _storage.write(_childProfilesKey, profiles.map((e) => e.toJson()).toList());
    }
  }

  /// Delete child profile
  Future<void> deleteChildProfile(String childId) async {
    final profiles = getChildProfiles();
    profiles.removeWhere((p) => p.id == childId);
    await _storage.write(_childProfilesKey, profiles.map((e) => e.toJson()).toList());
  }

  /// Get active child profile
  ChildProfileModel? getActiveChild() {
    final activeId = _storage.read(_activeChildKey);
    if (activeId != null) {
      final profiles = getChildProfiles();
      try {
        return profiles.firstWhere((p) => p.id == activeId);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Set active child profile
  Future<void> setActiveChild(String childId) async {
    await _storage.write(_activeChildKey, childId);
  }

  // ============== PREMIUM STATUS ==============

  /// Check if user is premium
  bool isPremium() {
    final user = getCurrentUser();
    return user?.isPremium ?? false;
  }

  /// Update premium status
  Future<void> updatePremiumStatus(bool isPremium) async {
    final user = getCurrentUser();
    if (user != null) {
      await saveUser(user.copyWith(isPremium: isPremium));
    }
  }
}
