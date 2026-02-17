import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardService extends GetxService {
  final GetStorage _box = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<LeaderboardEntry> globalLeaderboard = <LeaderboardEntry>[].obs;
  final RxList<LeaderboardEntry> weeklyLeaderboard = <LeaderboardEntry>[].obs;
  final RxList<LeaderboardEntry> friendsLeaderboard = <LeaderboardEntry>[].obs;
  final RxList<String> friends = <String>[].obs;
  final Rx<LeaderboardEntry?> currentUserEntry = Rx<LeaderboardEntry?>(null);
  final RxBool isLoading = false.obs;
  final RxInt userRank = 0.obs;

  // Flag to track if Firestore is available (permission granted)
  final RxBool firestoreAvailable = true.obs;

  // Points configuration
  static const Map<String, int> pointsConfig = {
    'lesson_complete': 10,
    'quiz_perfect': 50,
    'quiz_pass': 20,
    'daily_streak': 15,
    'achievement_unlock': 25,
    'first_login_today': 5,
    'share_score': 10,
    'invite_friend': 100,
  };

  Future<LeaderboardService> init() async {
    await _loadFriends();
    await _loadLocalPoints();
    await refreshLeaderboards();
    return this;
  }

  // Load points from local storage
  Future<void> _loadLocalPoints() async {
    final localPoints = _box.read<int>('local_total_points') ?? 0;
    final localWeeklyPoints = _box.read<int>('local_weekly_points') ?? 0;

    // Try to get display name from various sources
    String displayName = _box.read<String>('local_display_name') ?? '';
    if (displayName.isEmpty) {
      // Try to get from Firebase Auth
      displayName = _auth.currentUser?.displayName ?? '';
    }
    if (displayName.isEmpty) {
      // Try to get child name from local storage
      displayName = _box.read<String>('child_name') ?? 'Player';
    }

    // Set current user entry from local storage
    final userId = _auth.currentUser?.uid ?? 'local_user';
    currentUserEntry.value = LeaderboardEntry(
      userId: userId,
      displayName: displayName,
      totalPoints: localPoints,
      weeklyPoints: localWeeklyPoints,
      rank: 1,
    );
  }

  // Save points to local storage
  Future<void> _saveLocalPoints(int total, int weekly) async {
    await _box.write('local_total_points', total);
    await _box.write('local_weekly_points', weekly);
  }

  Future<void> _loadFriends() async {
    final savedFriends = _box.read<List>('friends_list');
    if (savedFriends != null) {
      friends.value = savedFriends.cast<String>();
    }
  }

  Future<void> _saveFriends() async {
    await _box.write('friends_list', friends.toList());
  }

  // Add points for user (works both online and offline)
  Future<void> addPoints(String action, {int? customPoints}) async {
    final points = customPoints ?? pointsConfig[action] ?? 0;
    if (points == 0) return;

    final now = DateTime.now();
    final weekStart = _getWeekStart(now);

    // Always update local storage first
    final currentTotal = _box.read<int>('local_total_points') ?? 0;
    final lastUpdateStr = _box.read<String>('local_last_update');
    final lastUpdate = lastUpdateStr != null ? DateTime.tryParse(lastUpdateStr) : null;

    int currentWeekly = _box.read<int>('local_weekly_points') ?? 0;
    if (lastUpdate == null || lastUpdate.isBefore(weekStart)) {
      currentWeekly = 0; // Reset weekly points if new week
    }

    final newTotal = currentTotal + points;
    final newWeekly = currentWeekly + points;

    await _saveLocalPoints(newTotal, newWeekly);
    await _box.write('local_last_update', now.toIso8601String());

    // Update current user entry immediately with local data
    final displayName = _box.read<String>('local_display_name') ??
        _auth.currentUser?.displayName ?? 'Player';
    currentUserEntry.value = LeaderboardEntry(
      userId: _auth.currentUser?.uid ?? 'local_user',
      displayName: displayName,
      totalPoints: newTotal,
      weeklyPoints: newWeekly,
      rank: userRank.value > 0 ? userRank.value : 1,
    );

    // Try to sync with Firestore if available
    final user = _auth.currentUser;
    if (user != null && firestoreAvailable.value) {
      try {
        final userRef = _firestore.collection('leaderboard').doc(user.uid);
        final doc = await userRef.get();

        if (doc.exists) {
          final data = doc.data()!;
          final serverLastUpdate = DateTime.tryParse(data['lastUpdate'] ?? '');
          final serverWeeklyPoints = serverLastUpdate != null && serverLastUpdate.isAfter(weekStart)
              ? (data['weeklyPoints'] ?? 0) + points
              : points;

          await userRef.update({
            'totalPoints': FieldValue.increment(points),
            'weeklyPoints': serverWeeklyPoints,
            'lastUpdate': now.toIso8601String(),
          });
        } else {
          await userRef.set({
            'userId': user.uid,
            'displayName': user.displayName ?? 'Player',
            'photoUrl': user.photoURL,
            'totalPoints': points,
            'weeklyPoints': points,
            'createdAt': now.toIso8601String(),
            'lastUpdate': now.toIso8601String(),
          });
        }

        // Update from server
        await _updateCurrentUserEntry();
      } catch (e) {
        // Firestore not available, continue with local-only mode
        if (e.toString().contains('permission-denied')) {
          firestoreAvailable.value = false;
          debugPrint('Leaderboard: Firestore not available, using local storage only');
        } else {
          debugPrint('Error syncing points to Firestore: $e');
        }
      }
    }
  }

  // Get week start (Monday)
  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  // Refresh all leaderboards
  Future<void> refreshLeaderboards() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchGlobalLeaderboard(),
        _fetchWeeklyLeaderboard(),
        _fetchFriendsLeaderboard(),
        _updateCurrentUserEntry(),
      ]);
    } catch (e) {
      debugPrint('Error refreshing leaderboards: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchGlobalLeaderboard() async {
    List<LeaderboardEntry> entries = [];

    // Add current user to the list
    final currentUser = currentUserEntry.value;
    if (currentUser != null) {
      entries.add(currentUser);
    }

    // Fetch real users from Firebase
    if (firestoreAvailable.value) {
      try {
        final snapshot = await _firestore
            .collection('leaderboard')
            .orderBy('totalPoints', descending: true)
            .limit(100)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final firebaseEntries = snapshot.docs
              .map((doc) => LeaderboardEntry.fromFirestore(doc.data(), 0))
              .toList();

          // Add Firebase users (avoid duplicates)
          for (var fbEntry in firebaseEntries) {
            if (!entries.any((e) => e.userId == fbEntry.userId)) {
              entries.add(fbEntry);
            }
          }
        }
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          firestoreAvailable.value = false;
          debugPrint('Leaderboard: Firestore permission denied, using local mode');
        } else {
          debugPrint('Error fetching global leaderboard: $e');
        }
      }
    }

    // Sort and update ranks
    entries.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    for (int i = 0; i < entries.length; i++) {
      entries[i] = LeaderboardEntry(
        userId: entries[i].userId,
        displayName: entries[i].displayName,
        totalPoints: entries[i].totalPoints,
        weeklyPoints: entries[i].weeklyPoints,
        rank: i + 1,
        photoUrl: entries[i].photoUrl,
        lastUpdate: entries[i].lastUpdate,
      );
    }

    globalLeaderboard.value = entries;
  }

  Future<void> _fetchWeeklyLeaderboard() async {
    List<LeaderboardEntry> entries = [];

    // Add current user to the list
    final currentUser = currentUserEntry.value;
    if (currentUser != null) {
      entries.add(currentUser);
    }

    // Fetch real users from Firebase
    if (firestoreAvailable.value) {
      try {
        final snapshot = await _firestore
            .collection('leaderboard')
            .orderBy('weeklyPoints', descending: true)
            .limit(100)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final firebaseEntries = snapshot.docs
              .map((doc) => LeaderboardEntry.fromFirestore(doc.data(), 0, isWeekly: true))
              .toList();

          // Add Firebase users (avoid duplicates)
          for (var fbEntry in firebaseEntries) {
            if (!entries.any((e) => e.userId == fbEntry.userId)) {
              entries.add(fbEntry);
            }
          }
        }
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          firestoreAvailable.value = false;
        } else {
          debugPrint('Error fetching weekly leaderboard: $e');
        }
      }
    }

    // Sort by weekly points and update ranks
    entries.sort((a, b) => b.weeklyPoints.compareTo(a.weeklyPoints));
    for (int i = 0; i < entries.length; i++) {
      entries[i] = LeaderboardEntry(
        userId: entries[i].userId,
        displayName: entries[i].displayName,
        totalPoints: entries[i].totalPoints,
        weeklyPoints: entries[i].weeklyPoints,
        rank: i + 1,
        photoUrl: entries[i].photoUrl,
        lastUpdate: entries[i].lastUpdate,
      );
    }

    weeklyLeaderboard.value = entries;
  }

  Future<void> _fetchFriendsLeaderboard() async {
    List<LeaderboardEntry> entries = [];

    // Add current user to friends leaderboard
    final currentUser = currentUserEntry.value;
    if (currentUser != null) {
      final userEntry = LeaderboardEntry(
        userId: currentUser.userId,
        displayName: '${currentUser.displayName} (You)',
        totalPoints: currentUser.totalPoints,
        weeklyPoints: currentUser.weeklyPoints,
        rank: 1,
        photoUrl: currentUser.photoUrl,
        lastUpdate: currentUser.lastUpdate,
      );
      entries.add(userEntry);
    }

    // Fetch real friends from Firebase
    if (firestoreAvailable.value && friends.isNotEmpty) {
      try {
        final snapshot = await _firestore
            .collection('leaderboard')
            .where('userId', whereIn: friends)
            .orderBy('totalPoints', descending: true)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final firebaseEntries = snapshot.docs
              .map((doc) => LeaderboardEntry.fromFirestore(doc.data(), 0))
              .toList();
          entries.addAll(firebaseEntries);
        }
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          firestoreAvailable.value = false;
        } else {
          debugPrint('Error fetching friends leaderboard: $e');
        }
      }
    }

    // If no friends added, show empty state (UI will handle this)
    if (entries.length <= 1 && friends.isEmpty) {
      // Only current user - show empty friends message in UI
      friendsLeaderboard.value = entries;
      return;
    }

    // Sort and update ranks
    entries.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    for (int i = 0; i < entries.length; i++) {
      entries[i] = LeaderboardEntry(
        userId: entries[i].userId,
        displayName: entries[i].displayName,
        totalPoints: entries[i].totalPoints,
        weeklyPoints: entries[i].weeklyPoints,
        rank: i + 1,
        photoUrl: entries[i].photoUrl,
        lastUpdate: entries[i].lastUpdate,
      );
    }

    friendsLeaderboard.value = entries;
  }

  Future<void> _updateCurrentUserEntry() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Keep local entry if exists
      if (currentUserEntry.value == null) {
        await _loadLocalPoints();
      }
      return;
    }

    if (!firestoreAvailable.value) {
      // Use local data only
      await _loadLocalPoints();
      return;
    }

    try {
      final doc =
          await _firestore.collection('leaderboard').doc(user.uid).get();

      if (doc.exists) {
        // Get user's rank
        final snapshot = await _firestore
            .collection('leaderboard')
            .orderBy('totalPoints', descending: true)
            .get();

        int rank = 1;
        for (final d in snapshot.docs) {
          if (d.id == user.uid) break;
          rank++;
        }

        userRank.value = rank;
        currentUserEntry.value = LeaderboardEntry.fromFirestore(
          doc.data()!,
          rank,
        );

        // Sync to local storage
        await _saveLocalPoints(
          currentUserEntry.value!.totalPoints,
          currentUserEntry.value!.weeklyPoints,
        );
      }
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        firestoreAvailable.value = false;
        debugPrint('Leaderboard: Firestore permission denied, using local mode');
        await _loadLocalPoints();
      } else {
        debugPrint('Error updating current user entry: $e');
      }
    }
  }

  // Add friend by user ID or friend code
  Future<AddFriendResult> addFriend(String friendIdOrCode) async {
    final user = _auth.currentUser;
    if (user == null) {
      return AddFriendResult(success: false, message: 'Please login first');
    }

    if (friendIdOrCode == user.uid) {
      return AddFriendResult(
          success: false, message: 'Cannot add yourself as friend');
    }

    if (friends.contains(friendIdOrCode)) {
      return AddFriendResult(success: false, message: 'Already friends');
    }

    try {
      // Check if user exists
      final friendDoc =
          await _firestore.collection('leaderboard').doc(friendIdOrCode).get();

      if (!friendDoc.exists) {
        // Try by friend code
        final codeSnapshot = await _firestore
            .collection('users')
            .where('friendCode', isEqualTo: friendIdOrCode.toUpperCase())
            .limit(1)
            .get();

        if (codeSnapshot.docs.isEmpty) {
          return AddFriendResult(success: false, message: 'User not found');
        }

        friendIdOrCode = codeSnapshot.docs.first.id;
      }

      friends.add(friendIdOrCode);
      await _saveFriends();
      await _fetchFriendsLeaderboard();

      return AddFriendResult(success: true, message: 'Friend added!');
    } catch (e) {
      return AddFriendResult(success: false, message: 'Error: $e');
    }
  }

  // Remove friend
  Future<void> removeFriend(String friendId) async {
    friends.remove(friendId);
    await _saveFriends();
    await _fetchFriendsLeaderboard();
  }

  // Generate friend code for current user
  Future<String?> generateFriendCode() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data()?['friendCode'] != null) {
        return userDoc.data()!['friendCode'];
      }

      // Generate new code
      final code = _generateCode();
      await _firestore.collection('users').doc(user.uid).set({
        'friendCode': code,
      }, SetOptions(merge: true));

      return code;
    } catch (e) {
      debugPrint('Error generating friend code: $e');
      return null;
    }
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    int seed = random;
    for (int i = 0; i < 6; i++) {
      code += chars[seed % chars.length];
      seed = (seed ~/ chars.length) + i * 7;
    }
    return code;
  }

  // Get user's tier based on points
  UserTier getUserTier(int points) {
    if (points >= 10000) return UserTier.legend;
    if (points >= 5000) return UserTier.master;
    if (points >= 2500) return UserTier.expert;
    if (points >= 1000) return UserTier.advanced;
    if (points >= 500) return UserTier.intermediate;
    if (points >= 100) return UserTier.beginner;
    return UserTier.starter;
  }

  // Get tier info
  static Map<UserTier, TierInfo> tierInfo = {
    UserTier.starter: TierInfo(
      name: 'Starter',
      emoji: '🌱',
      color: 0xFF9E9E9E,
      minPoints: 0,
    ),
    UserTier.beginner: TierInfo(
      name: 'Beginner',
      emoji: '🌿',
      color: 0xFF8BC34A,
      minPoints: 100,
    ),
    UserTier.intermediate: TierInfo(
      name: 'Intermediate',
      emoji: '⭐',
      color: 0xFF2196F3,
      minPoints: 500,
    ),
    UserTier.advanced: TierInfo(
      name: 'Advanced',
      emoji: '🌟',
      color: 0xFF9C27B0,
      minPoints: 1000,
    ),
    UserTier.expert: TierInfo(
      name: 'Expert',
      emoji: '💫',
      color: 0xFFFF9800,
      minPoints: 2500,
    ),
    UserTier.master: TierInfo(
      name: 'Master',
      emoji: '👑',
      color: 0xFFE91E63,
      minPoints: 5000,
    ),
    UserTier.legend: TierInfo(
      name: 'Legend',
      emoji: '🏆',
      color: 0xFFFFD700,
      minPoints: 10000,
    ),
  };
}

class LeaderboardEntry {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final int totalPoints;
  final int weeklyPoints;
  final int rank;
  final DateTime? lastUpdate;

  LeaderboardEntry({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.totalPoints,
    required this.weeklyPoints,
    required this.rank,
    this.lastUpdate,
  });

  factory LeaderboardEntry.fromFirestore(Map<String, dynamic> data, int rank,
      {bool isWeekly = false}) {
    return LeaderboardEntry(
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? 'Player',
      photoUrl: data['photoUrl'],
      totalPoints: data['totalPoints'] ?? 0,
      weeklyPoints: data['weeklyPoints'] ?? 0,
      rank: rank,
      lastUpdate: data['lastUpdate'] != null
          ? DateTime.tryParse(data['lastUpdate'])
          : null,
    );
  }

  int getDisplayPoints(bool isWeekly) => isWeekly ? weeklyPoints : totalPoints;
}

class AddFriendResult {
  final bool success;
  final String message;

  AddFriendResult({required this.success, required this.message});
}

enum UserTier {
  starter,
  beginner,
  intermediate,
  advanced,
  expert,
  master,
  legend,
}

class TierInfo {
  final String name;
  final String emoji;
  final int color;
  final int minPoints;

  TierInfo({
    required this.name,
    required this.emoji,
    required this.color,
    required this.minPoints,
  });
}
