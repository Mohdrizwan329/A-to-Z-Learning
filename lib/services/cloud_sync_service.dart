import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CloudSyncService extends GetxService {
  final GetStorage _box = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isSyncing = false.obs;
  final RxBool isOnline = true.obs;
  final Rx<DateTime?> lastSyncTime = Rx<DateTime?>(null);
  final RxString syncStatus = 'Not synced'.obs;
  final RxBool autoSyncEnabled = true.obs;

  // Keys to sync
  static const List<String> syncKeys = [
    'progress_',
    'rewards_',
    'daily_goals_',
    'analytics_',
    'total_coins',
    'lifetime_earned',
    'selected_avatar',
    'selected_outfit',
    'owned_avatars',
    'owned_outfits',
    'settings_',
  ];

  Future<CloudSyncService> init() async {
    await _loadSettings();
    _setupConnectivityListener();
    return this;
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((results) {
      isOnline.value = results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);

      if (isOnline.value && autoSyncEnabled.value) {
        syncToCloud();
      }
    });
  }

  Future<void> _loadSettings() async {
    autoSyncEnabled.value = _box.read<bool>('auto_sync_enabled') ?? true;
    final lastSync = _box.read<String>('last_sync_time');
    if (lastSync != null) {
      lastSyncTime.value = DateTime.tryParse(lastSync);
    }
  }

  Future<void> setAutoSync(bool enabled) async {
    autoSyncEnabled.value = enabled;
    await _box.write('auto_sync_enabled', enabled);
  }

  // Sync all data to cloud
  Future<SyncResult> syncToCloud() async {
    final user = _auth.currentUser;
    if (user == null) {
      return SyncResult(success: false, message: 'Not logged in');
    }

    if (!isOnline.value) {
      return SyncResult(success: false, message: 'No internet connection');
    }

    if (isSyncing.value) {
      return SyncResult(success: false, message: 'Sync already in progress');
    }

    isSyncing.value = true;
    syncStatus.value = 'Syncing...';

    try {
      final userData = <String, dynamic>{};
      final allKeys = _box.getKeys();

      // Collect data to sync
      for (final key in allKeys) {
        for (final syncKey in syncKeys) {
          if (key.toString().startsWith(syncKey) || key == syncKey.replaceAll('_', '')) {
            userData[key.toString()] = _box.read(key);
          }
        }
      }

      // Add metadata
      userData['lastModified'] = DateTime.now().toIso8601String();
      userData['deviceInfo'] = await _getDeviceInfo();

      // Upload to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sync_data')
          .doc('app_data')
          .set(userData, SetOptions(merge: true));

      lastSyncTime.value = DateTime.now();
      await _box.write('last_sync_time', lastSyncTime.value!.toIso8601String());

      syncStatus.value = 'Synced successfully';
      isSyncing.value = false;

      return SyncResult(success: true, message: 'Data synced successfully');
    } catch (e) {
      syncStatus.value = 'Sync failed';
      isSyncing.value = false;
      return SyncResult(success: false, message: 'Sync failed: $e');
    }
  }

  // Restore data from cloud
  Future<SyncResult> restoreFromCloud() async {
    final user = _auth.currentUser;
    if (user == null) {
      return SyncResult(success: false, message: 'Not logged in');
    }

    if (!isOnline.value) {
      return SyncResult(success: false, message: 'No internet connection');
    }

    if (isSyncing.value) {
      return SyncResult(success: false, message: 'Sync already in progress');
    }

    isSyncing.value = true;
    syncStatus.value = 'Restoring...';

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sync_data')
          .doc('app_data')
          .get();

      if (!doc.exists || doc.data() == null) {
        isSyncing.value = false;
        syncStatus.value = 'No backup found';
        return SyncResult(success: false, message: 'No backup found');
      }

      final data = doc.data()!;

      // Restore each key
      for (final entry in data.entries) {
        if (entry.key != 'lastModified' && entry.key != 'deviceInfo') {
          await _box.write(entry.key, entry.value);
        }
      }

      lastSyncTime.value = DateTime.now();
      await _box.write('last_sync_time', lastSyncTime.value!.toIso8601String());

      syncStatus.value = 'Restored successfully';
      isSyncing.value = false;

      return SyncResult(success: true, message: 'Data restored successfully');
    } catch (e) {
      syncStatus.value = 'Restore failed';
      isSyncing.value = false;
      return SyncResult(success: false, message: 'Restore failed: $e');
    }
  }

  // Check if cloud has newer data
  Future<bool> hasCloudData() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sync_data')
          .doc('app_data')
          .get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Get cloud data timestamp
  Future<DateTime?> getCloudDataTimestamp() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sync_data')
          .doc('app_data')
          .get();

      if (doc.exists && doc.data() != null) {
        final lastModified = doc.data()!['lastModified'];
        if (lastModified != null) {
          return DateTime.tryParse(lastModified);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Delete cloud data
  Future<bool> deleteCloudData() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sync_data')
          .doc('app_data')
          .delete();

      syncStatus.value = 'Cloud data deleted';
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': GetPlatform.isAndroid ? 'Android' : 'iOS',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Format last sync time
  String get lastSyncFormatted {
    if (lastSyncTime.value == null) return 'Never synced';

    final now = DateTime.now();
    final diff = now.difference(lastSyncTime.value!);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    return '${lastSyncTime.value!.day}/${lastSyncTime.value!.month}/${lastSyncTime.value!.year}';
  }
}

class SyncResult {
  final bool success;
  final String message;

  SyncResult({required this.success, required this.message});
}
