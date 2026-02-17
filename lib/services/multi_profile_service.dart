import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MultiProfileService extends GetxService {
  final GetStorage _box = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current profile
  final Rx<ChildProfile?> currentProfile = Rx<ChildProfile?>(null);
  final RxList<ChildProfile> profiles = <ChildProfile>[].obs;
  final RxBool isLoading = false.obs;

  // Max profiles allowed
  static const int maxProfiles = 5;

  Future<MultiProfileService> init() async {
    await _loadProfiles();
    return this;
  }

  Future<void> _loadProfiles() async {
    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Load from Firestore
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('profiles')
            .get();

        profiles.value = snapshot.docs
            .map((doc) => ChildProfile.fromJson({...doc.data(), 'id': doc.id}))
            .toList();
      } else {
        // Load from local storage
        final localProfiles = _box.read<List>('child_profiles');
        if (localProfiles != null) {
          profiles.value = localProfiles
              .map((p) => ChildProfile.fromJson(Map<String, dynamic>.from(p)))
              .toList();
        }
      }

      // Set current profile
      final currentId = _box.read<String>('current_profile_id');
      if (currentId != null && profiles.isNotEmpty) {
        currentProfile.value = profiles.firstWhereOrNull((p) => p.id == currentId);
      }
      currentProfile.value ??= profiles.isNotEmpty ? profiles.first : null;
    } catch (e) {
      // Handle error
    }
    isLoading.value = false;
  }

  Future<void> _saveProfiles() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Save to Firestore
        final batch = _firestore.batch();
        for (final profile in profiles) {
          final docRef = _firestore
              .collection('users')
              .doc(user.uid)
              .collection('profiles')
              .doc(profile.id);
          batch.set(docRef, profile.toJson());
        }
        await batch.commit();
      }

      // Always save locally too
      await _box.write(
        'child_profiles',
        profiles.map((p) => p.toJson()).toList(),
      );
    } catch (e) {
      // Handle error
    }
  }

  // Create new profile
  Future<CreateProfileResult> createProfile({
    required String name,
    required int age,
    String? avatarEmoji,
    String? grade,
  }) async {
    if (profiles.length >= maxProfiles) {
      return CreateProfileResult(
        success: false,
        message: 'Maximum $maxProfiles profiles allowed',
      );
    }

    if (name.trim().isEmpty) {
      return CreateProfileResult(
        success: false,
        message: 'Please enter a name',
      );
    }

    if (age < 3 || age > 12) {
      return CreateProfileResult(
        success: false,
        message: 'Age must be between 3 and 12',
      );
    }

    final profile = ChildProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      age: age,
      avatarEmoji: avatarEmoji ?? _getDefaultAvatar(age),
      grade: grade,
      createdAt: DateTime.now(),
    );

    profiles.add(profile);
    await _saveProfiles();

    // If first profile, set as current
    if (profiles.length == 1) {
      await switchProfile(profile.id);
    }

    return CreateProfileResult(
      success: true,
      message: 'Profile created successfully',
      profile: profile,
    );
  }

  String _getDefaultAvatar(int age) {
    if (age <= 5) return '👶';
    if (age <= 8) return '🧒';
    return '👦';
  }

  // Update profile
  Future<bool> updateProfile(ChildProfile updatedProfile) async {
    final index = profiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index == -1) return false;

    profiles[index] = updatedProfile;
    await _saveProfiles();

    if (currentProfile.value?.id == updatedProfile.id) {
      currentProfile.value = updatedProfile;
    }

    return true;
  }

  // Delete profile
  Future<bool> deleteProfile(String profileId) async {
    if (profiles.length <= 1) {
      return false; // Must have at least one profile
    }

    final profile = profiles.firstWhereOrNull((p) => p.id == profileId);
    if (profile == null) return false;

    profiles.removeWhere((p) => p.id == profileId);

    // Delete from Firestore
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('profiles')
          .doc(profileId)
          .delete();
    }

    await _saveProfiles();

    // Switch to another profile if current was deleted
    if (currentProfile.value?.id == profileId) {
      await switchProfile(profiles.first.id);
    }

    return true;
  }

  // Switch profile
  Future<void> switchProfile(String profileId) async {
    final profile = profiles.firstWhereOrNull((p) => p.id == profileId);
    if (profile == null) return;

    currentProfile.value = profile;
    await _box.write('current_profile_id', profileId);

    // Update last active
    profile.lastActiveAt = DateTime.now();
    await updateProfile(profile);
  }

  // Get profile progress data key prefix
  String getProgressKey(String key) {
    final profileId = currentProfile.value?.id ?? 'default';
    return '${profileId}_$key';
  }

  // Get profile-specific storage
  T? readProfileData<T>(String key) {
    return _box.read<T>(getProgressKey(key));
  }

  Future<void> writeProfileData<T>(String key, T value) async {
    await _box.write(getProgressKey(key), value);
  }

  // Sync profiles to cloud
  Future<void> syncToCloud() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _saveProfiles();
  }

  // Check if profile name exists
  bool isNameTaken(String name) {
    return profiles.any((p) => p.name.toLowerCase() == name.toLowerCase());
  }
}

class ChildProfile {
  final String id;
  String name;
  int age;
  String avatarEmoji;
  String? grade;
  DateTime createdAt;
  DateTime? lastActiveAt;
  int totalStars;
  int level;
  int totalLessonsCompleted;
  int currentStreak;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    this.avatarEmoji = '🧒',
    this.grade,
    required this.createdAt,
    this.lastActiveAt,
    this.totalStars = 0,
    this.level = 1,
    this.totalLessonsCompleted = 0,
    this.currentStreak = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'avatarEmoji': avatarEmoji,
        'grade': grade,
        'createdAt': createdAt.toIso8601String(),
        'lastActiveAt': lastActiveAt?.toIso8601String(),
        'totalStars': totalStars,
        'level': level,
        'totalLessonsCompleted': totalLessonsCompleted,
        'currentStreak': currentStreak,
      };

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 5,
      avatarEmoji: json['avatarEmoji'] ?? '🧒',
      grade: json['grade'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'])
          : null,
      totalStars: json['totalStars'] ?? 0,
      level: json['level'] ?? 1,
      totalLessonsCompleted: json['totalLessonsCompleted'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
    );
  }

  ChildProfile copyWith({
    String? name,
    int? age,
    String? avatarEmoji,
    String? grade,
    int? totalStars,
    int? level,
    int? totalLessonsCompleted,
    int? currentStreak,
  }) {
    return ChildProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      grade: grade ?? this.grade,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt,
      totalStars: totalStars ?? this.totalStars,
      level: level ?? this.level,
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

class CreateProfileResult {
  final bool success;
  final String message;
  final ChildProfile? profile;

  CreateProfileResult({
    required this.success,
    required this.message,
    this.profile,
  });
}
