import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:jiyan_learning/services/tts_service.dart';

class AdhdSupportPage extends StatefulWidget {
  const AdhdSupportPage({super.key});

  @override
  State<AdhdSupportPage> createState() => _AdhdSupportPageState();
}

class _AdhdSupportPageState extends State<AdhdSupportPage> with TickerProviderStateMixin {
  final GetStorage _storage = GetStorage();
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  // ADHD Settings
  bool focusModeEnabled = false;
  bool breakReminders = true;
  bool taskBreakdown = true;
  bool rewardAfterTask = true;
  bool minimalDistractions = true;
  bool timerVisible = true;
  int focusDuration = 10; // minutes
  int breakDuration = 3; // minutes

  // Timer state
  bool isTimerRunning = false;
  bool isBreakTime = false;
  int remainingSeconds = 0;
  Timer? _timer;

  // Focus tasks
  final List<Map<String, dynamic>> focusTasks = [
    {'task': 'Learn 5 Numbers', 'emoji': '🔢', 'duration': 3, 'completed': false, 'points': 10},
    {'task': 'Practice 5 Letters', 'emoji': '🔤', 'duration': 3, 'completed': false, 'points': 10},
    {'task': 'Watch 1 Story', 'emoji': '📖', 'duration': 2, 'completed': false, 'points': 5},
    {'task': 'Play 1 Game', 'emoji': '🎮', 'duration': 3, 'completed': false, 'points': 10},
    {'task': 'Draw Something', 'emoji': '🎨', 'duration': 5, 'completed': false, 'points': 15},
  ];

  // Rewards
  int earnedPoints = 0;
  final List<Map<String, dynamic>> rewards = [
    {'name': 'Gold Star', 'emoji': '⭐', 'points': 20},
    {'name': 'Trophy', 'emoji': '🏆', 'points': 50},
    {'name': 'Medal', 'emoji': '🥇', 'points': 30},
    {'name': 'Crown', 'emoji': '👑', 'points': 100},
  ];

  // Focus tips
  final List<Map<String, dynamic>> focusTips = [
    {'tip': 'Find a quiet spot to learn', 'emoji': '🤫', 'color': Color(0xFF4ECDC4)},
    {'tip': 'Put away toys before starting', 'emoji': '🧸', 'color': Color(0xFFFFAA5A)},
    {'tip': 'Take deep breaths when distracted', 'emoji': '🌬️', 'color': Color(0xFF667EEA)},
    {'tip': 'Look at one thing at a time', 'emoji': '👀', 'color': Color(0xFF56D97F)},
    {'tip': 'Wiggle your body, then sit still', 'emoji': '💪', 'color': Color(0xFFA78BFA)},
    {'tip': 'Drink water to stay fresh', 'emoji': '💧', 'color': Color(0xFF4ECDC4)},
    {'tip': 'Say "I can do this!" out loud', 'emoji': '🗣️', 'color': Color(0xFFFF6B6B)},
    {'tip': 'Finish one task before starting another', 'emoji': '✅', 'color': Color(0xFFFFD93D)},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);
    _loadSettings();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _loadSettings() {
    setState(() {
      focusModeEnabled = _storage.read('adhd_focus_mode') ?? false;
      breakReminders = _storage.read('adhd_break_reminders') ?? true;
      taskBreakdown = _storage.read('adhd_task_breakdown') ?? true;
      rewardAfterTask = _storage.read('adhd_reward_after_task') ?? true;
      minimalDistractions = _storage.read('adhd_minimal_distractions') ?? true;
      timerVisible = _storage.read('adhd_timer_visible') ?? true;
      focusDuration = _storage.read('adhd_focus_duration') ?? 10;
      breakDuration = _storage.read('adhd_break_duration') ?? 3;
      earnedPoints = _storage.read('adhd_earned_points') ?? 0;
    });
  }

  void _saveSetting(String key, dynamic value) {
    _storage.write(key, value);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  void _startFocusTimer() {
    setState(() {
      isTimerRunning = true;
      isBreakTime = false;
      remainingSeconds = focusDuration * 60;
    });
    _runTimer();
  }

  void _startBreakTimer() {
    setState(() {
      isTimerRunning = true;
      isBreakTime = true;
      remainingSeconds = breakDuration * 60;
    });
    _speakText("Break time! Rest your eyes and move around.");
    _runTimer();
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
        setState(() => isTimerRunning = false);
        if (isBreakTime) {
          _speakText("Break is over! Ready to focus again?");
        } else {
          _speakText("Great focus! Time for a short break!");
          if (breakReminders) {
            _showBreakDialog();
          }
        }
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => isTimerRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = false;
      remainingSeconds = 0;
      isBreakTime = false;
    });
  }

  void _showBreakDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: const [
            Text("🎉", style: TextStyle(fontSize: 30)),
            SizedBox(width: 12),
            Text("Great Focus!"),
          ],
        ),
        content: const Text("You focused really well! Take a short break to rest your brain."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _startBreakTimer();
            },
            child: const Text("Start Break"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _startFocusTimer();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF667EEA)),
            child: const Text("Keep Going!", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              ),
          ),
        ),
        title: const Text("Focus Helper", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Timer", icon: Icon(Icons.timer, size: 18)),
            Tab(text: "Tasks", icon: Icon(Icons.checklist, size: 18)),
            Tab(text: "Tips", icon: Icon(Icons.lightbulb, size: 18)),
            Tab(text: "Settings", icon: Icon(Icons.settings, size: 18)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTimerTab(),
            _buildTasksTab(),
            _buildTipsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Timer Display
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: isBreakTime ? Color(0xFF56D97F).withValues(alpha: 0.3) : Color(0xFFFF6B6B).withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  isBreakTime ? "🧘 Break Time" : "🎯 Focus Time",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isBreakTime ? Color(0xFF56D97F) : Color(0xFFFF6B6B)),
                ),
                const SizedBox(height: 16),
                Text(
                  remainingSeconds > 0 ? _formatTime(remainingSeconds) : _formatTime(focusDuration * 60),
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: isBreakTime ? Color(0xFF56D97F) : Color(0xFF667EEA)),
                ),
                const SizedBox(height: 8),
                Text(
                  isTimerRunning ? (isBreakTime ? "Relax and recharge!" : "Stay focused!") : "Ready to start?",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Timer Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isTimerRunning) ...[
                ElevatedButton.icon(
                  onPressed: _startFocusTimer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start Focus"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF56D97F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _pauseTimer,
                  icon: const Icon(Icons.pause),
                  label: const Text("Pause"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFAA5A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B6B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 30),

          // Quick Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text("⏱️ Quick Timer", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickTimeButton("5 min", 5),
                    _buildQuickTimeButton("10 min", 10),
                    _buildQuickTimeButton("15 min", 15),
                    _buildQuickTimeButton("20 min", 20),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Points Display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFD93D), Color(0xFFFF8E53)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("⭐", style: TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Text("$earnedPoints Points Earned!", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTimeButton(String label, int minutes) {
    final isSelected = focusDuration == minutes;
    return GestureDetector(
      onTap: () {
        setState(() => focusDuration = minutes);
        _saveSetting('adhd_focus_duration', minutes);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Color(0xFF667EEA) : Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTasksTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("📋", style: TextStyle(fontSize: 50), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text("Bite-Size Tasks", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text("Small tasks are easier to finish!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14), textAlign: TextAlign.center),
        const SizedBox(height: 24),

        ...focusTasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: task['completed'] ? Border.all(color: Color(0xFF56D97F), width: 2) : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: task['completed'] ? Color(0xFF56D97F).withValues(alpha: 0.2) : Color(0xFF667EEA).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: task['completed']
                      ? const Icon(Icons.check, color: Color(0xFF56D97F), size: 30)
                      : Text(task['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              title: Text(
                task['task'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: task['completed'] ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("${task['duration']} min", style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(width: 12),
                  const Text("⭐", style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text("+${task['points']} pts", style: TextStyle(color: Color(0xFFFFAA5A))),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: task['completed']
                    ? null
                    : () {
                        TtsService.to.speak(task['task']);
                        setState(() {
                          focusTasks[index]['completed'] = true;
                          earnedPoints += task['points'] as int;
                        });
                        _saveSetting('adhd_earned_points', earnedPoints);
                        _speakText("Awesome! You earned ${task['points']} points!");
                        if (rewardAfterTask) {
                          _showRewardAnimation(task['points']);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: task['completed'] ? Colors.grey : Color(0xFF56D97F),
                  foregroundColor: Colors.white,
                ),
                child: Text(task['completed'] ? "Done!" : "Complete"),
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // Reset Tasks Button
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              for (var task in focusTasks) {
                task['completed'] = false;
              }
            });
          },
          icon: const Icon(Icons.refresh),
          label: const Text("Reset All Tasks"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: focusTips.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("💡", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Focus Tips", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Helpful ideas to stay focused!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 24),
            ],
          );
        }

        final tip = focusTips[index - 1];
        return GestureDetector(
          onTap: () => _speakText(tip['tip']),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [tip['color'], tip['color'].withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: tip['color'].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Text(tip['emoji'], style: const TextStyle(fontSize: 35)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(tip['tip'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                const Icon(Icons.volume_up, color: Colors.white70),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("⚙️", style: TextStyle(fontSize: 50), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text("Focus Settings", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 24),

        // Timer Settings
        _buildSectionHeader("⏱️", "Timer Settings"),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: _buildIcon("🎯"),
                title: const Text("Focus Duration", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text("$focusDuration minutes"),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: focusDuration.toDouble(),
                    min: 5,
                    max: 30,
                    divisions: 5,
                    activeColor: Color(0xFF667EEA),
                    onChanged: (v) {
                      setState(() => focusDuration = v.toInt());
                      _saveSetting('adhd_focus_duration', focusDuration);
                    },
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: _buildIcon("🧘"),
                title: const Text("Break Duration", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text("$breakDuration minutes"),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: breakDuration.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: Color(0xFF56D97F),
                    onChanged: (v) {
                      setState(() => breakDuration = v.toInt());
                      _saveSetting('adhd_break_duration', breakDuration);
                    },
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildSwitchTile("⏰", "Show Timer", "Display countdown on screen", timerVisible, (v) {
                setState(() => timerVisible = v);
                _saveSetting('adhd_timer_visible', v);
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Learning Settings
        _buildSectionHeader("📚", "Learning Help"),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildSwitchTile("🔔", "Break Reminders", "Remind to take breaks", breakReminders, (v) {
                setState(() => breakReminders = v);
                _saveSetting('adhd_break_reminders', v);
              }),
              const Divider(height: 1),
              _buildSwitchTile("📋", "Task Breakdown", "Show small, easy tasks", taskBreakdown, (v) {
                setState(() => taskBreakdown = v);
                _saveSetting('adhd_task_breakdown', v);
              }),
              const Divider(height: 1),
              _buildSwitchTile("🎁", "Reward After Task", "Celebrate completions", rewardAfterTask, (v) {
                setState(() => rewardAfterTask = v);
                _saveSetting('adhd_reward_after_task', v);
              }),
              const Divider(height: 1),
              _buildSwitchTile("🎯", "Minimal Distractions", "Simpler interface", minimalDistractions, (v) {
                setState(() => minimalDistractions = v);
                _saveSetting('adhd_minimal_distractions', v);
              }),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildIcon(String emoji) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Color(0xFF667EEA).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
    );
  }

  Widget _buildSwitchTile(String icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: _buildIcon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: Color(0xFF667EEA).withValues(alpha: 0.5),
      ),
    );
  }

  void _showRewardAnimation(int points) {
    Get.snackbar(
      "🎉 Amazing!",
      "You earned $points points! Keep going!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF56D97F),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Padding(
        padding: EdgeInsets.all(12),
        child: Text("⭐", style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
