import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'dart:async';

class EmotionalRegulationPage extends StatefulWidget {
  const EmotionalRegulationPage({super.key});

  @override
  State<EmotionalRegulationPage> createState() => _EmotionalRegulationPageState();
}

class _EmotionalRegulationPageState extends State<EmotionalRegulationPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  bool isBreathingActive = false;
  String breathPhase = 'Ready';
  int breathCycles = 0;

  final List<Map<String, dynamic>> calmingStrategies = [
    {
      'name': 'Deep Breathing',
      'emoji': '🌬️',
      'color': Color(0xFF4ECDC4),
      'description': 'Take slow, deep breaths to feel calm.',
      'steps': ['Breathe in slowly through your nose', 'Hold for a moment', 'Breathe out slowly through your mouth', 'Repeat 3 times'],
    },
    {
      'name': 'Count to 10',
      'emoji': '🔢',
      'color': Color(0xFF667EEA),
      'description': 'When upset, slowly count from 1 to 10.',
      'steps': ['Close your eyes', 'Count slowly: 1, 2, 3...', 'Take a breath between numbers', 'Feel yourself getting calmer'],
    },
    {
      'name': 'Find 5 Things',
      'emoji': '👀',
      'color': Color(0xFFFF6B6B),
      'description': 'Look around and name 5 things you see.',
      'steps': ['Look around the room', 'Name 5 things you can see', 'Name 4 things you can touch', 'This helps you feel grounded'],
    },
    {
      'name': 'Squeeze and Release',
      'emoji': '✊',
      'color': Color(0xFFA78BFA),
      'description': 'Squeeze your fists tight, then let go.',
      'steps': ['Make tight fists', 'Hold for 5 seconds', 'Release and relax', 'Feel the tension go away'],
    },
    {
      'name': 'Happy Place',
      'emoji': '🏖️',
      'color': Color(0xFFFFAA5A),
      'description': 'Imagine a place that makes you happy.',
      'steps': ['Close your eyes', 'Think of your favorite place', 'Imagine the sounds and smells', 'Stay there for a moment'],
    },
    {
      'name': 'Talk It Out',
      'emoji': '💬',
      'color': Color(0xFF56D97F),
      'description': 'Tell someone how you feel.',
      'steps': ['Find a trusted person', 'Say "I feel..."', 'Explain what happened', 'Ask for help if you need it'],
    },
  ];

  final List<Map<String, dynamic>> emotionTools = [
    {'emotion': 'Angry', 'emoji': '😠', 'color': Color(0xFFFF6B6B), 'tools': ['Take deep breaths', 'Count to 10', 'Walk away for a moment', 'Squeeze a stress ball']},
    {'emotion': 'Sad', 'emoji': '😢', 'color': Color(0xFF667EEA), 'tools': ['Talk to someone you trust', 'Hug a stuffed animal', 'Draw your feelings', 'Listen to happy music']},
    {'emotion': 'Scared', 'emoji': '😨', 'color': Color(0xFFA78BFA), 'tools': ['Find a safe person', 'Take deep breaths', 'Hold your favorite toy', 'Think of something happy']},
    {'emotion': 'Worried', 'emoji': '😟', 'color': Color(0xFF4ECDC4), 'tools': ['Talk about your worries', 'Take slow breaths', 'Think of good things', 'Ask for a hug']},
  ];

  int selectedStrategy = -1;

  @override
  void initState() {
    super.initState();
    _initTts();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breathAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _startBreathingExercise() async {
    setState(() {
      isBreathingActive = true;
      breathCycles = 0;
    });

    _runBreathingCycle();
  }

  void _runBreathingCycle() async {
    if (!isBreathingActive) return;

    for (int i = 0; i < 3; i++) {
      if (!isBreathingActive || !mounted) return;

      // Breathe in
      setState(() => breathPhase = 'Breathe In');
      _speakText('Breathe in');
      _breathController.forward();
      await Future.delayed(const Duration(seconds: 4));

      if (!isBreathingActive || !mounted) return;

      // Hold
      setState(() => breathPhase = 'Hold');
      _speakText('Hold');
      await Future.delayed(const Duration(seconds: 2));

      if (!isBreathingActive || !mounted) return;

      // Breathe out
      setState(() => breathPhase = 'Breathe Out');
      _speakText('Breathe out');
      _breathController.reverse();
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return;
      setState(() => breathCycles = i + 1);
    }

    if (isBreathingActive && mounted) {
      setState(() => breathPhase = 'Great job!');
      _speakText('Great job! You did 3 breaths!');
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => isBreathingActive = false);
    }
  }

  void _stopBreathing() {
    _breathController.stop();
    setState(() {
      isBreathingActive = false;
      breathPhase = 'Ready';
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              if (isBreathingActive) {
                _stopBreathing();
              }
              Get.back();
            },
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
          title: const Text("Calm Down", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Breathe", icon: Icon(Icons.air, size: 20)),
              Tab(text: "Strategies", icon: Icon(Icons.lightbulb, size: 20)),
              Tab(text: "Tools", icon: Icon(Icons.construction, size: 20)),
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
            children: [
              _buildBreathingTab(),
              _buildStrategiesTab(),
              _buildToolsTab(),
            ],
          ),
        ),
        bottomNavigationBar: const AdsScreen(),
      ),
    );
  }

  Widget _buildBreathingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            isBreathingActive ? breathPhase : "Let's Calm Down",
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (isBreathingActive)
            Text("Breath ${breathCycles + 1} of 3", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _breathController,
            builder: (context, child) {
              return Container(
                width: 200 * (isBreathingActive ? _breathAnimation.value : 1.0),
                height: 200 * (isBreathingActive ? _breathAnimation.value : 1.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4ECDC4).withValues(alpha: 0.8), Color(0xFF44A08D).withValues(alpha: 0.8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4ECDC4).withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isBreathingActive ? "🌬️" : "🧘",
                    style: TextStyle(fontSize: isBreathingActive ? 60 : 70),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          if (!isBreathingActive) ...[
            ElevatedButton.icon(
              onPressed: _startBreathingExercise,
              icon: const Icon(Icons.play_arrow, size: 28),
              label: const Text("Start Breathing", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF56D97F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Text("🌟 How it works:", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("1. Breathe in for 4 seconds", style: TextStyle(color: Colors.white70)),
                  Text("2. Hold for 2 seconds", style: TextStyle(color: Colors.white70)),
                  Text("3. Breathe out for 4 seconds", style: TextStyle(color: Colors.white70)),
                  Text("4. Repeat 3 times", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: _stopBreathing,
              icon: const Icon(Icons.stop),
              label: const Text("Stop"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStrategiesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: calmingStrategies.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🌈", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Calming Strategies", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Ways to feel better!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final strategy = calmingStrategies[index - 1];
        final isExpanded = selectedStrategy == index - 1;

        return GestureDetector(
          onTap: () {
            setState(() => selectedStrategy = isExpanded ? -1 : index - 1);
            if (!isExpanded) {
              _speakText(strategy['description']);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: strategy['color'].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(child: Text(strategy['emoji'], style: const TextStyle(fontSize: 30))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(strategy['name'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: strategy['color'])),
                            Text(strategy['description'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: strategy['color']),
                    ],
                  ),
                ),
                if (isExpanded)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: strategy['color'].withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Steps:", style: TextStyle(fontWeight: FontWeight.bold, color: strategy['color'])),
                        const SizedBox(height: 8),
                        ...(strategy['steps'] as List<String>).asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(color: strategy['color'], shape: BoxShape.circle),
                                child: Center(
                                  child: Text("${entry.key + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(entry.value, style: TextStyle(color: Colors.grey.shade700))),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: emotionTools.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🧰", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Emotion Tools", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("What to do when you feel...", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final tool = emotionTools[index - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [tool['color'], tool['color'].withValues(alpha: 0.7)]),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Text(tool['emoji'], style: const TextStyle(fontSize: 35)),
                    const SizedBox(width: 14),
                    Text("When I feel ${tool['emotion']}...", style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: (tool['tools'] as List<String>).map((t) {
                    return GestureDetector(
                      onTap: () => _speakText(t),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: tool['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: tool['color'], size: 20),
                            const SizedBox(width: 12),
                            Expanded(child: Text(t, style: TextStyle(color: Colors.grey.shade700))),
                            Icon(Icons.volume_up, color: tool['color'].withValues(alpha: 0.6), size: 20),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
