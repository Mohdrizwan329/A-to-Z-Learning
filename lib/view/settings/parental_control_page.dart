import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/screen_time_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PIN Setup Section
              _buildSectionTitle('🔑 PIN Protection'),
              const SizedBox(height: 12),
              _buildPinSection(),
              const SizedBox(height: 24),

              // Screen Time Section
              _buildSectionTitle('⏰ Screen Time'),
              const SizedBox(height: 12),
              _buildScreenTimeSection(),
              const SizedBox(height: 24),

              // Content Lock Section
              _buildSectionTitle('🔒 Content Lock'),
              const SizedBox(height: 12),
              _buildContentLockSection(),
              const SizedBox(height: 24),

              // Break Reminders Section
              _buildSectionTitle('👀 Eye Care'),
              const SizedBox(height: 12),
              _buildBreakReminderSection(),
              const SizedBox(height: 24),

              // Usage Stats
              _buildSectionTitle('📊 Usage Statistics'),
              const SizedBox(height: 12),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock, color: Color(0xFFA78BFA), size: 28),
                  ),
                ),
                const SizedBox(width: 16),
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
                  activeTrackColor: const Color(0xFFA78BFA).withValues(alpha: 0.5),
                  activeThumbColor: const Color(0xFFA78BFA),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isSettingPin) ...[
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter 4-digit PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
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
                  const SizedBox(width: 8),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (hasPin) ...[
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _showRemovePinDialog,
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
      Get.snackbar('Error', 'PIN must be 4 digits',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      Get.snackbar('Error', 'PINs do not match',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    _screenTimeService.setParentalPin(_pinController.text);
    setState(() {
      _isSettingPin = false;
      _pinController.clear();
      _confirmPinController.clear();
    });

    Get.snackbar('Success', 'PIN has been set',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  void _showRemovePinDialog() {
    final verifyController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter current PIN to remove:'),
            const SizedBox(height: 12),
            TextField(
              controller: verifyController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Current PIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_screenTimeService.verifyParentalPin(verifyController.text)) {
                _screenTimeService.removeParentalPin();
                Get.back();
                Get.snackbar('Success', 'PIN removed',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white);
              } else {
                Get.snackbar('Error', 'Invalid PIN',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.timer, color: Color(0xFF4ECDC4), size: 28),
                  ),
                ),
                const SizedBox(width: 16),
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
                  activeTrackColor: const Color(0xFF4ECDC4).withValues(alpha: 0.5),
                  activeThumbColor: const Color(0xFF4ECDC4),
                ),
              ],
            ),
            if (_screenTimeService.isScreenTimeEnabled.value) ...[
              const SizedBox(height: 16),
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
                    value: _screenTimeService.screenTimeLimitMinutes.value.toDouble(),
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
              const SizedBox(height: 16),
              // Today's Usage
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _screenTimeService.usagePercentage / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _screenTimeService.usagePercentage > 80
                        ? Colors.red
                        : const Color(0xFF4ECDC4),
                  ),
                  minHeight: 8,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
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
            const SizedBox(height: 12),
            ...features.map((feature) {
              final isLocked =
                  _screenTimeService.lockedFeatures.contains(feature['id']);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(feature['icon']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
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
                                _screenTimeService.unlockFeature(feature['id']!);
                              }
                            }
                          : null,
                      activeTrackColor: const Color(0xFFFF6B6B).withValues(alpha: 0.5),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF56D97F).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text("👀", style: TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 16),
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
                  activeTrackColor: const Color(0xFF56D97F).withValues(alpha: 0.5),
                  activeThumbColor: const Color(0xFF56D97F),
                ),
              ],
            ),
            if (_screenTimeService.isBreakReminderEnabled.value) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remind every'),
                  DropdownButton<int>(
                    value: _screenTimeService.breakIntervalMinutes.value,
                    items: [10, 15, 20, 30, 45, 60]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text('$e min'),
                            ))
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Today',
                  '${_screenTimeService.todayUsageMinutes.value} min',
                  '📅',
                ),
                _buildStatItem(
                  'Weekly Avg',
                  '${_screenTimeService.weeklyAverageMinutes} min',
                  '📊',
                ),
                _buildStatItem(
                  'This Week',
                  '${_screenTimeService.totalWeeklyMinutes} min',
                  '📈',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Weekly usage chart placeholder
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final date = DateTime.now().subtract(Duration(days: 6 - index));
                  final dateStr = date.toIso8601String().split('T')[0];
                  final usage = _screenTimeService.usageHistory[dateStr] ?? 0;
                  final maxUsage = 60; // Normalize to 60 min
                  final height = (usage / maxUsage * 60).clamp(5.0, 60.0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 30,
                        height: height,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
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
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
