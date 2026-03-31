import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class GoodHabitsPage extends StatefulWidget {
  const GoodHabitsPage({super.key});

  @override
  State<GoodHabitsPage> createState() => _GoodHabitsPageState();
}

class _GoodHabitsPageState extends State<GoodHabitsPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  Map<String, bool> habitChecks = {};

  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> morningHabits = [
    {'habit': 'Wake up early', 'emoji': '⏰', 'tip': 'Go to bed on time!'},
    {'habit': 'Make your bed', 'emoji': '🛏️', 'tip': 'A tidy room feels great!'},
    {'habit': 'Brush your teeth', 'emoji': '🪥', 'tip': 'Brush for 2 minutes!'},
    {'habit': 'Wash your face', 'emoji': '🧼', 'tip': 'Clean face, fresh start!'},
    {'habit': 'Eat a healthy breakfast', 'emoji': '🥣', 'tip': 'Breakfast gives you energy!'},
    {'habit': 'Get dressed neatly', 'emoji': '👕', 'tip': 'Look your best!'},
  ];

  final List<Map<String, dynamic>> dailyHabits = [
    {'habit': 'Say please and thank you', 'emoji': '🙏', 'tip': 'Polite words make friends!'},
    {'habit': 'Listen when others speak', 'emoji': '👂', 'tip': 'Listening shows you care.'},
    {'habit': 'Share with others', 'emoji': '🤝', 'tip': 'Sharing brings happiness!'},
    {'habit': 'Be kind to everyone', 'emoji': '💖', 'tip': 'Kindness comes back to you!'},
    {'habit': 'Finish homework on time', 'emoji': '📚', 'tip': 'Then you can play!'},
    {'habit': 'Help around the house', 'emoji': '🏠', 'tip': 'Everyone helps at home!'},
    {'habit': 'Drink enough water', 'emoji': '💧', 'tip': 'Water keeps you healthy!'},
    {'habit': 'Play outside', 'emoji': '🌳', 'tip': 'Fresh air is good for you!'},
  ];

  final List<Map<String, dynamic>> nightHabits = [
    {'habit': 'Tidy up your toys', 'emoji': '🧸', 'tip': 'Clean up before bed!'},
    {'habit': 'Take a bath/shower', 'emoji': '🛁', 'tip': 'Stay clean and fresh!'},
    {'habit': 'Brush teeth again', 'emoji': '🦷', 'tip': 'No cavities allowed!'},
    {'habit': 'Read a book', 'emoji': '📖', 'tip': 'Reading makes you smart!'},
    {'habit': 'Say goodnight to family', 'emoji': '😴', 'tip': 'Love your family!'},
    {'habit': 'Go to bed on time', 'emoji': '🌙', 'tip': 'Sleep helps you grow!'},
  ];

  final List<Map<String, dynamic>> healthyHabits = [
    {'habit': 'Eat fruits & vegetables', 'emoji': '🥗', 'why': 'They give you vitamins and make you strong!'},
    {'habit': 'Exercise every day', 'emoji': '🏃', 'why': 'Your body needs to move to stay healthy!'},
    {'habit': 'Wash hands before eating', 'emoji': '🧴', 'why': 'Keep germs away from your tummy!'},
    {'habit': 'Cover mouth when sneezing', 'emoji': '🤧', 'why': 'Don\'t spread germs to others!'},
    {'habit': 'Sit up straight', 'emoji': '🧘', 'why': 'Good posture keeps your back healthy!'},
    {'habit': 'Limit screen time', 'emoji': '📱', 'why': 'Your eyes and brain need rest!'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);

    // Initialize home screen style animations
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _toggleHabit(String habitName) {
    setState(() {
      habitChecks[habitName] = !(habitChecks[habitName] ?? false);
    });
    if (habitChecks[habitName] == true) {
      _speakText("Great job! You did it!");
    }
  }

  void _resetProgress() {
    setState(() {
      habitChecks.clear();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top = startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  // Get progress for a specific tab
  double _getTabProgress(int tabIndex) {
    List<Map<String, dynamic>> habits;
    switch (tabIndex) {
      case 0:
        habits = morningHabits;
        break;
      case 1:
        habits = dailyHabits;
        break;
      case 2:
        habits = nightHabits;
        break;
      case 3:
        habits = healthyHabits;
        break;
      default:
        habits = [];
    }
    if (habits.isEmpty) return 0;
    int completed = habits.where((h) => habitChecks[h['habit']] == true).length;
    return completed / habits.length;
  }

  String _getProgressString(int tabIndex) {
    List<Map<String, dynamic>> habits;
    switch (tabIndex) {
      case 0:
        habits = morningHabits;
        break;
      case 1:
        habits = dailyHabits;
        break;
      case 2:
        habits = nightHabits;
        break;
      case 3:
        habits = healthyHabits;
        break;
      default:
        habits = [];
    }
    int completed = habits.where((h) => habitChecks[h['habit']] == true).length;
    return '$completed/${habits.length}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Good Habits",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
            onPressed: _resetProgress,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Morning"),
            Tab(text: "Daily"),
            Tab(text: "Night"),
            Tab(text: "Health"),
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
        child: Stack(
          children: [
            // Floating bubbles background
            ..._buildFloatingBubbles(),
            // Main content
            TabBarView(
              key: ValueKey(habitChecks.values.where((v) => v).length),
              controller: _tabController,
              children: [
                _buildHabitList(morningHabits, "Morning Routine", 0),
                _buildHabitList(dailyHabits, "Daily Habits", 1),
                _buildHabitList(nightHabits, "Bedtime Routine", 2),
                _buildHealthTab(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildProgressBar(int tabIndex) {
    final progress = _getTabProgress(tabIndex);
    final progressString = _getProgressString(tabIndex);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$progressString completed',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(List<Map<String, dynamic>> habits, String title, int tabIndex) {
    int completed = habits.where((h) => habitChecks[h['habit']] == true).length;

    return Column(
      children: [
        // Progress bar
        _buildProgressBar(tabIndex),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length + (completed == habits.length ? 1 : 0),
            itemBuilder: (context, index) {
              // Show celebration card at the end if all completed
              if (index == habits.length && completed == habits.length) {
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Text("🏆", style: TextStyle(fontSize: 40)),
                      SizedBox(height: 8),
                      Text("Amazing! All Done!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("You're a superstar!", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                );
              }

              final habit = habits[index];
              final isChecked = habitChecks[habit['habit']] ?? false;
              final gradient = AppColors.getGradientForIndex(index);

              return AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, index.isEven ? _floatAnimation.value : -_floatAnimation.value),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    TtsService.to.speak(habit['habit']);
                    _toggleHabit(habit['habit']);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isChecked
                            ? [const Color(0xFF56D97F), const Color(0xFF81E89E)]
                            : gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isChecked ? const Color(0xFF56D97F) : gradient[0]).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(habit['emoji'], style: const TextStyle(fontSize: 25)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit['habit'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                habit['tip'],
                                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _speakText("${habit['habit']}. ${habit['tip']}"),
                          icon: Icon(Icons.volume_up, color: Colors.white.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHealthTab() {
    int completed = healthyHabits.where((h) => habitChecks[h['habit']] == true).length;

    return Column(
      children: [
        // Progress bar
        _buildProgressBar(3),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: healthyHabits.length + (completed == healthyHabits.length ? 1 : 0),
            itemBuilder: (context, index) {
              // Show celebration card at the end if all completed
              if (index == healthyHabits.length && completed == healthyHabits.length) {
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Text("🏆", style: TextStyle(fontSize: 40)),
                      SizedBox(height: 8),
                      Text("Health Star!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Keep it up!", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                );
              }

              final habit = healthyHabits[index];
              final isChecked = habitChecks[habit['habit']] ?? false;
              final gradient = AppColors.getGradientForIndex(index);

              return AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, index.isEven ? _floatAnimation.value : -_floatAnimation.value),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    _toggleHabit(habit['habit']);
                    _speakText("${habit['habit']}. ${habit['why']}");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isChecked
                            ? [const Color(0xFF56D97F), const Color(0xFF81E89E)]
                            : gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isChecked ? const Color(0xFF56D97F) : gradient[0]).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(habit['emoji'], style: const TextStyle(fontSize: 25)),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  habit['habit'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(Icons.volume_up, color: Colors.white.withValues(alpha: 0.7)),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text("💡", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  habit['why'],
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
