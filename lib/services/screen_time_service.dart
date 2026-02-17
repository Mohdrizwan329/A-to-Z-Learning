import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Screen Time Service - Manages daily usage limits and parental controls
class ScreenTimeService extends GetxService {
  static ScreenTimeService get to => Get.find<ScreenTimeService>();

  final GetStorage _storage = GetStorage();
  Timer? _sessionTimer;
  Timer? _reminderTimer;

  // Storage keys
  static const String kScreenTimeLimit = 'screen_time_limit_minutes';
  static const String kTodayUsage = 'today_usage_minutes';
  static const String kLastUsageDate = 'last_usage_date';
  static const String kScreenTimeEnabled = 'screen_time_enabled';
  static const String kParentalPin = 'parental_pin';
  static const String kParentalLockEnabled = 'parental_lock_enabled';
  static const String kLockedFeatures = 'locked_features';
  static const String kBreakReminder = 'break_reminder_enabled';
  static const String kBreakInterval = 'break_interval_minutes';
  static const String kUsageHistory = 'usage_history';
  static const String kSessionStartTime = 'session_start_time';

  // Observable values
  final RxInt screenTimeLimitMinutes = 60.obs;
  final RxInt todayUsageMinutes = 0.obs;
  final RxBool isScreenTimeEnabled = false.obs;
  final RxBool isParentalLockEnabled = false.obs;
  final RxList<String> lockedFeatures = <String>[].obs;
  final RxBool isBreakReminderEnabled = true.obs;
  final RxInt breakIntervalMinutes = 20.obs;
  final RxBool isLimitReached = false.obs;
  final RxInt currentSessionMinutes = 0.obs;

  // Usage history (last 7 days)
  final RxMap<String, int> usageHistory = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _startSessionTracking();
  }

  void _loadSettings() {
    screenTimeLimitMinutes.value = _storage.read<int>(kScreenTimeLimit) ?? 60;
    isScreenTimeEnabled.value = _storage.read<bool>(kScreenTimeEnabled) ?? false;
    isParentalLockEnabled.value = _storage.read<bool>(kParentalLockEnabled) ?? false;
    lockedFeatures.value = List<String>.from(_storage.read<List<dynamic>>(kLockedFeatures) ?? []);
    isBreakReminderEnabled.value = _storage.read<bool>(kBreakReminder) ?? true;
    breakIntervalMinutes.value = _storage.read<int>(kBreakInterval) ?? 20;

    // Load today's usage
    final today = _getTodayString();
    final lastDate = _storage.read<String>(kLastUsageDate);

    if (lastDate == today) {
      todayUsageMinutes.value = _storage.read<int>(kTodayUsage) ?? 0;
    } else {
      // New day, reset usage
      todayUsageMinutes.value = 0;
      _storage.write(kTodayUsage, 0);
      _storage.write(kLastUsageDate, today);
    }

    // Load usage history
    final history = _storage.read<Map<String, dynamic>>(kUsageHistory);
    if (history != null) {
      usageHistory.value = Map<String, int>.from(history.map((k, v) => MapEntry(k, v as int)));
    }

    _checkLimitReached();
  }

  void _startSessionTracking() {
    // Track session time every minute
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (isScreenTimeEnabled.value) {
        todayUsageMinutes.value++;
        currentSessionMinutes.value++;
        _storage.write(kTodayUsage, todayUsageMinutes.value);
        _updateUsageHistory();
        _checkLimitReached();
      }
    });

    // Break reminders
    _reminderTimer = Timer.periodic(Duration(minutes: breakIntervalMinutes.value), (_) {
      if (isBreakReminderEnabled.value && currentSessionMinutes.value >= breakIntervalMinutes.value) {
        _showBreakReminder();
      }
    });
  }

  String _getTodayString() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  void _updateUsageHistory() {
    final today = _getTodayString();
    usageHistory[today] = todayUsageMinutes.value;

    // Keep only last 7 days
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    usageHistory.removeWhere((key, _) {
      final date = DateTime.parse(key);
      return date.isBefore(sevenDaysAgo);
    });

    _storage.write(kUsageHistory, usageHistory);
  }

  void _checkLimitReached() {
    if (isScreenTimeEnabled.value && todayUsageMinutes.value >= screenTimeLimitMinutes.value) {
      isLimitReached.value = true;
    } else {
      isLimitReached.value = false;
    }
  }

  void _showBreakReminder() {
    // Ensure navigation system is ready before showing dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen != true) {
        Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("👀", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 16),
              const Text(
                'Time for a Break!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4ECDC4),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You\'ve been learning for ${currentSessionMinutes.value} minutes.\nRest your eyes for a bit!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  currentSessionMinutes.value = 0;
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('I\'ll Take a Break'),
              ),
            ],
          ),
        ),
        barrierDismissible: true,
        );
      }
    });
  }

  // Parental Controls
  Future<void> setParentalPin(String pin) async {
    await _storage.write(kParentalPin, pin);
    isParentalLockEnabled.value = true;
    await _storage.write(kParentalLockEnabled, true);
  }

  bool verifyParentalPin(String pin) {
    final storedPin = _storage.read<String>(kParentalPin);
    return storedPin == pin;
  }

  bool hasParentalPin() {
    return _storage.read<String>(kParentalPin) != null;
  }

  Future<void> removeParentalPin() async {
    await _storage.remove(kParentalPin);
    isParentalLockEnabled.value = false;
    await _storage.write(kParentalLockEnabled, false);
  }

  Future<void> toggleParentalLock(bool enabled) async {
    isParentalLockEnabled.value = enabled;
    await _storage.write(kParentalLockEnabled, enabled);
  }

  // Screen Time Settings
  Future<void> setScreenTimeLimit(int minutes) async {
    screenTimeLimitMinutes.value = minutes;
    await _storage.write(kScreenTimeLimit, minutes);
    _checkLimitReached();
  }

  Future<void> toggleScreenTimeLimit(bool enabled) async {
    isScreenTimeEnabled.value = enabled;
    await _storage.write(kScreenTimeEnabled, enabled);
    if (!enabled) {
      isLimitReached.value = false;
    }
  }

  Future<void> extendScreenTime(int additionalMinutes) async {
    screenTimeLimitMinutes.value += additionalMinutes;
    await _storage.write(kScreenTimeLimit, screenTimeLimitMinutes.value);
    isLimitReached.value = false;
  }

  Future<void> resetTodayUsage() async {
    todayUsageMinutes.value = 0;
    currentSessionMinutes.value = 0;
    await _storage.write(kTodayUsage, 0);
    isLimitReached.value = false;
  }

  // Feature Locking
  Future<void> lockFeature(String featureId) async {
    if (!lockedFeatures.contains(featureId)) {
      lockedFeatures.add(featureId);
      await _storage.write(kLockedFeatures, lockedFeatures.toList());
    }
  }

  Future<void> unlockFeature(String featureId) async {
    lockedFeatures.remove(featureId);
    await _storage.write(kLockedFeatures, lockedFeatures.toList());
  }

  bool isFeatureLocked(String featureId) {
    return isParentalLockEnabled.value && lockedFeatures.contains(featureId);
  }

  // Break Reminder Settings
  Future<void> toggleBreakReminder(bool enabled) async {
    isBreakReminderEnabled.value = enabled;
    await _storage.write(kBreakReminder, enabled);
  }

  Future<void> setBreakInterval(int minutes) async {
    breakIntervalMinutes.value = minutes;
    await _storage.write(kBreakInterval, minutes);

    // Restart reminder timer with new interval
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(Duration(minutes: minutes), (_) {
      if (isBreakReminderEnabled.value && currentSessionMinutes.value >= minutes) {
        _showBreakReminder();
      }
    });
  }

  // Analytics
  int get remainingMinutes {
    if (!isScreenTimeEnabled.value) return 999;
    return (screenTimeLimitMinutes.value - todayUsageMinutes.value).clamp(0, 999);
  }

  double get usagePercentage {
    if (!isScreenTimeEnabled.value || screenTimeLimitMinutes.value == 0) return 0;
    return (todayUsageMinutes.value / screenTimeLimitMinutes.value * 100).clamp(0, 100);
  }

  int get weeklyAverageMinutes {
    if (usageHistory.isEmpty) return todayUsageMinutes.value;
    int total = usageHistory.values.fold(0, (sum, val) => sum + val);
    return total ~/ usageHistory.length;
  }

  int get totalWeeklyMinutes {
    return usageHistory.values.fold(0, (sum, val) => sum + val);
  }

  @override
  void onClose() {
    _sessionTimer?.cancel();
    _reminderTimer?.cancel();
    super.onClose();
  }
}
