import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/screen_time_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ParentalControlPage extends StatefulWidget {
  const ParentalControlPage({super.key});

  @override
  State<ParentalControlPage> createState() => _ParentalControlPageState();
}

class _ParentalControlPageState extends State<ParentalControlPage> {
  ScreenTimeService get _screenTimeService {
    if (!Get.isRegistered<ScreenTimeService>()) {
      Get.put(ScreenTimeService(), permanent: true);
    }
    return Get.find<ScreenTimeService>();
  }

  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isSettingPin = false;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Parental Controls',
      emoji: '🔐',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PIN Setup Section
            _buildSectionTitle('🔑 PIN Protection'),
            SizedBox(height: 12.h),
            _buildPinSection(),
            SizedBox(height: 24.h),

            // Screen Time Section
            _buildSectionTitle('⏰ Screen Time'),
            SizedBox(height: 12.h),
            _buildScreenTimeSection(),
            SizedBox(height: 24.h),

            // Content Lock Section
            _buildSectionTitle('🔒 Content Lock'),
            SizedBox(height: 12.h),
            _buildContentLockSection(),
            SizedBox(height: 24.h),

            // Break Reminders Section
            _buildSectionTitle('👀 Eye Care'),
            SizedBox(height: 12.h),
            _buildBreakReminderSection(),
            SizedBox(height: 24.h),

            // Usage Stats
            _buildSectionTitle('📊 Usage Statistics'),
            SizedBox(height: 12.h),
            _buildUsageStatsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPinSection() {
    return Obx(() {
      final hasPin = _screenTimeService.hasParentalPin();

      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      color: Color(0xFFA78BFA),
                      size: 28.r,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasPin ? 'PIN is Set' : 'No PIN Set',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        hasPin
                            ? 'Parental lock is active'
                            : 'Set a PIN to enable parental controls',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _screenTimeService.isParentalLockEnabled.value,
                  onChanged: hasPin
                      ? (v) => _screenTimeService.toggleParentalLock(v)
                      : null,
                  activeTrackColor: const Color(
                    0xFFA78BFA,
                  ).withValues(alpha: 0.5),
                  activeThumbColor: const Color(0xFFA78BFA),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (_isSettingPin) ...[
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter 4-digit PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  counterText: '',
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  counterText: '',
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSettingPin = false;
                        _pinController.clear();
                        _confirmPinController.clear();
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: _savePin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA78BFA),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save PIN'),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isSettingPin = true);
                      },
                      icon: Icon(hasPin ? Icons.edit : Icons.add),
                      label: Text(hasPin ? 'Change PIN' : 'Set PIN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA78BFA),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  if (hasPin) ...[
                    SizedBox(width: 12.w),
                    ElevatedButton.icon(
                      onPressed: _showRemovePinDialog,
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  void _savePin() {
    if (_pinController.text.length != 4) {
      Get.snackbar(
        'Error',
        'PIN must be 4 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      Get.snackbar(
        'Error',
        'PINs do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _screenTimeService.setParentalPin(_pinController.text);
    setState(() {
      _isSettingPin = false;
      _pinController.clear();
      _confirmPinController.clear();
    });

    Get.snackbar(
      'Success',
      'PIN has been set',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showRemovePinDialog() {
    final verifyController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: const Text('Remove PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter current PIN to remove:'),
            SizedBox(height: 12.h),
            TextField(
              controller: verifyController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Current PIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_screenTimeService.verifyParentalPin(verifyController.text)) {
                _screenTimeService.removeParentalPin();
                Get.back();
                Get.snackbar(
                  'Success',
                  'PIN removed',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Invalid PIN',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenTimeSection() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Enable/Disable Switch
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.timer,
                      color: Color(0xFF4ECDC4),
                      size: 28.r,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Screen Time Limit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _screenTimeService.isScreenTimeEnabled.value
                            ? '${_screenTimeService.screenTimeLimitMinutes.value} min/day'
                            : 'No limit set',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _screenTimeService.isScreenTimeEnabled.value,
                  onChanged: (v) => _screenTimeService.toggleScreenTimeLimit(v),
                  activeTrackColor: const Color(
                    0xFF4ECDC4,
                  ).withValues(alpha: 0.5),
                  activeThumbColor: const Color(0xFF4ECDC4),
                ),
              ],
            ),
            if (_screenTimeService.isScreenTimeEnabled.value) ...[
              SizedBox(height: 16.h),
              // Time Limit Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daily Limit'),
                      Text(
                        '${_screenTimeService.screenTimeLimitMinutes.value} minutes',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _screenTimeService.screenTimeLimitMinutes.value
                        .toDouble(),
                    min: 15,
                    max: 180,
                    divisions: 11,
                    activeColor: const Color(0xFF4ECDC4),
                    onChanged: (v) {
                      _screenTimeService.setScreenTimeLimit(v.toInt());
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('15 min', style: TextStyle(fontSize: 12)),
                      Text('3 hours', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Today's Usage
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Today\'s Usage'),
                    Text(
                      '${_screenTimeService.todayUsageMinutes.value} / ${_screenTimeService.screenTimeLimitMinutes.value} min',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _screenTimeService.usagePercentage > 80
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: _screenTimeService.usagePercentage / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _screenTimeService.usagePercentage > 80
                        ? Colors.red
                        : const Color(0xFF4ECDC4),
                  ),
                  minHeight: 8.h,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildContentLockSection() {
    final features = [
      {'id': 'games', 'name': 'Games', 'icon': '🎮'},
      {'id': 'premium', 'name': 'Premium Content', 'icon': '⭐'},
      {'id': 'settings', 'name': 'Settings', 'icon': '⚙️'},
      {'id': 'payment', 'name': 'Payments', 'icon': '💳'},
    ];

    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Lock specific features (requires PIN)',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 12.h),
            ...features.map((feature) {
              final isLocked = _screenTimeService.lockedFeatures.contains(
                feature['id'],
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Text(
                      feature['icon']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        feature['name']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Switch(
                      value: isLocked,
                      onChanged: _screenTimeService.hasParentalPin()
                          ? (v) {
                              if (v) {
                                _screenTimeService.lockFeature(feature['id']!);
                              } else {
                                _screenTimeService.unlockFeature(
                                  feature['id']!,
                                );
                              }
                            }
                          : null,
                      activeTrackColor: const Color(
                        0xFFFF6B6B,
                      ).withValues(alpha: 0.5),
                      activeThumbColor: const Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildBreakReminderSection() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF56D97F).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(
                    child: Text("👀", style: TextStyle(fontSize: 28)),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Break Reminders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Remind to take breaks for eye rest',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _screenTimeService.isBreakReminderEnabled.value,
                  onChanged: (v) => _screenTimeService.toggleBreakReminder(v),
                  activeTrackColor: const Color(
                    0xFF56D97F,
                  ).withValues(alpha: 0.5),
                  activeThumbColor: const Color(0xFF56D97F),
                ),
              ],
            ),
            if (_screenTimeService.isBreakReminderEnabled.value) ...[
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: const Text(
                      'Remind every',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _screenTimeService.breakIntervalMinutes.value,
                    items: [10, 15, 20, 30, 45, 60]
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text('$e min')),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) _screenTimeService.setBreakInterval(v);
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildUsageStatsSection() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Equal shares, so the widest label wraps inside its own
                // column instead of pushing the row past the card.
                Expanded(
                  child: _buildStatItem(
                    'Today',
                    '${_screenTimeService.todayUsageMinutes.value} min',
                    '📅',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Weekly Avg',
                    '${_screenTimeService.weeklyAverageMinutes} min',
                    '📊',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'This Week',
                    '${_screenTimeService.totalWeeklyMinutes} min',
                    '📈',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Weekly usage chart placeholder
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final date = DateTime.now().subtract(
                    Duration(days: 6 - index),
                  );
                  final dateStr = date.toIso8601String().split('T')[0];
                  final usage = _screenTimeService.usageHistory[dateStr] ?? 0;
                  final maxUsage = 60; // Normalize to 60 min
                  final height = (usage / maxUsage * 60).clamp(5.0, 60.0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 30.w,
                        height: height,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        ['S', 'M', 'T', 'W', 'T', 'F', 'S'][date.weekday % 7],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
