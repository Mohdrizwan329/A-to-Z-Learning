import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class EmotionalRegulationPage extends StatefulWidget {
  const EmotionalRegulationPage({super.key});

  @override
  State<EmotionalRegulationPage> createState() =>
      _EmotionalRegulationPageState();
}

class _EmotionalRegulationPageState extends State<EmotionalRegulationPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  bool isBreathingActive = false;
  String breathPhase = 'Ready';
  int breathCycles = 0;

  final List<Map<String, dynamic>> calmingStrategies = [
    {
      'name': 'Deep Breathing',
      'emoji': '🌬️',
      'color': Color(0xFF4ECDC4),
      'description': 'Take slow, deep breaths to feel calm.',
      'steps': [
        'Breathe in slowly through your nose',
        'Hold for a moment',
        'Breathe out slowly through your mouth',
        'Repeat 3 times',
      ],
    },
    {
      'name': 'Count to 10',
      'emoji': '🔢',
      'color': Color(0xFF667EEA),
      'description': 'When upset, slowly count from 1 to 10.',
      'steps': [
        'Close your eyes',
        'Count slowly: 1, 2, 3...',
        'Take a breath between numbers',
        'Feel yourself getting calmer',
      ],
    },
    {
      'name': 'Find 5 Things',
      'emoji': '👀',
      'color': Color(0xFFFF6B6B),
      'description': 'Look around and name 5 things you see.',
      'steps': [
        'Look around the room',
        'Name 5 things you can see',
        'Name 4 things you can touch',
        'This helps you feel grounded',
      ],
    },
    {
      'name': 'Squeeze and Release',
      'emoji': '✊',
      'color': Color(0xFFA78BFA),
      'description': 'Squeeze your fists tight, then let go.',
      'steps': [
        'Make tight fists',
        'Hold for 5 seconds',
        'Release and relax',
        'Feel the tension go away',
      ],
    },
    {
      'name': 'Happy Place',
      'emoji': '🏖️',
      'color': Color(0xFFFFAA5A),
      'description': 'Imagine a place that makes you happy.',
      'steps': [
        'Close your eyes',
        'Think of your favorite place',
        'Imagine the sounds and smells',
        'Stay there for a moment',
      ],
    },
    {
      'name': 'Talk It Out',
      'emoji': '💬',
      'color': Color(0xFF56D97F),
      'description': 'Tell someone how you feel.',
      'steps': [
        'Find a trusted person',
        'Say "I feel..."',
        'Explain what happened',
        'Ask for help if you need it',
      ],
    },
  ];

  final List<Map<String, dynamic>> emotionTools = [
    {
      'emotion': 'Angry',
      'emoji': '😠',
      'color': Color(0xFFFF6B6B),
      'tools': [
        'Take deep breaths',
        'Count to 10',
        'Walk away for a moment',
        'Squeeze a stress ball',
      ],
    },
    {
      'emotion': 'Sad',
      'emoji': '😢',
      'color': Color(0xFF667EEA),
      'tools': [
        'Talk to someone you trust',
        'Hug a stuffed animal',
        'Draw your feelings',
        'Listen to happy music',
      ],
    },
    {
      'emotion': 'Scared',
      'emoji': '😨',
      'color': Color(0xFFA78BFA),
      'tools': [
        'Find a safe person',
        'Take deep breaths',
        'Hold your favorite toy',
        'Think of something happy',
      ],
    },
    {
      'emotion': 'Worried',
      'emoji': '😟',
      'color': Color(0xFF4ECDC4),
      'tools': [
        'Talk about your worries',
        'Take slow breaths',
        'Think of good things',
        'Ask for a hug',
      ],
    },
  ];

  int selectedStrategy = -1;
  late AnimationController _cardAnimController;
  late List<Animation<double>> _cardAnimations;

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
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _cardAnimations = List.generate(
      calmingStrategies.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardAnimController,
          curve: Interval(
            index * 0.12,
            (index * 0.12 + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );
    _cardAnimController.forward();
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
    _cardAnimController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: GestureDetector(
              onTap: () {
                if (isBreathingActive) {
                  _stopBreathing();
                }
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFAA5A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          elevation: 8,
          title: const Text(
            "Calm Down",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3.r,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            labelPadding: EdgeInsets.symmetric(horizontal: 44.w),
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: "Breathe"),
              Tab(text: "Strategies"),
              Tab(text: "Tools"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
                Color(0xFFF093FB),
                Color(0xFFF5576C),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Floating bubbles background (home screen style)
              ..._buildFloatingBubbles(),
              TabBarView(
                children: [
                  _buildBreathingTab(),
                  _buildStrategiesTab(),
                  _buildToolsTab(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Text(
            isBreathingActive ? breathPhase : "Let's Calm Down",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isBreathingActive)
            Text(
              "Breath ${breathCycles + 1} of 3",
              style: const TextStyle(color: Colors.white70),
            ),
          SizedBox(height: 40.h),
          AnimatedBuilder(
            animation: _breathController,
            builder: (context, child) {
              return Container(
                width:
                    200.w * (isBreathingActive ? _breathAnimation.value : 1.0),
                height:
                    200.h * (isBreathingActive ? _breathAnimation.value : 1.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4ECDC4).withValues(alpha: 0.8),
                      Color(0xFF44A08D).withValues(alpha: 0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4ECDC4).withValues(alpha: 0.5),
                      blurRadius: 30.r,
                      spreadRadius: 10.r,
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
          SizedBox(height: 40.h),
          if (!isBreathingActive) ...[
            ElevatedButton.icon(
              onPressed: _startBreathingExercise,
              icon: Icon(Icons.play_arrow, size: 28.r),
              label: Text("Start Breathing", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF56D97F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Text(
                    "🌟 How it works:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "1. Breathe in for 4 seconds",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "2. Hold for 2 seconds",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "3. Breathe out for 4 seconds",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "4. Repeat 3 times",
                    style: TextStyle(color: Colors.white70),
                  ),
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
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Gradient pairs for strategy cards (like home screen)
  final List<List<Color>> _strategyGradients = const [
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFFA78BFA), Color(0xFF7C3AED)],
    [Color(0xFFFFAA5A), Color(0xFFFF6B6B)],
    [Color(0xFF56D97F), Color(0xFF2ECC71)],
  ];

  Widget _buildStrategiesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: calmingStrategies.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🌈", style: TextStyle(fontSize: 50)),
              SizedBox(height: 8.h),
              const Text(
                "Calming Strategies",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Ways to feel better!",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          );
        }

        final strategy = calmingStrategies[index - 1];
        final isExpanded = selectedStrategy == index - 1;
        final animIndex = (index - 1).clamp(0, _cardAnimations.length - 1);
        final gradient =
            _strategyGradients[(index - 1) % _strategyGradients.length];

        return AnimatedBuilder(
          animation: _cardAnimations[animIndex],
          builder: (context, child) {
            final value = _cardAnimations[animIndex].value;
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final offset = ((index - 1) % 2 == 0)
                  ? _floatAnimation.value * 0.5
                  : -_floatAnimation.value * 0.5;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () {
                TtsService.to.speak(strategy['name']);
                setState(() => selectedStrategy = isExpanded ? -1 : index - 1);
                if (!isExpanded) {
                  _speakText(strategy['description']);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 8.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative circle (home screen style)
                    Positioned(
                      top: -15.h,
                      right: -15.w,
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10.h,
                      left: -10.w,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    // Card content
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            children: [
                              // Circular emoji container (home screen style)
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    strategy['emoji'],
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      strategy['name'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Color(0x40000000),
                                            offset: Offset(1, 1),
                                            blurRadius: 3.r,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      strategy['description'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.expand_more,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.r),
                                bottomRight: Radius.circular(20.r),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Steps:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                ...(strategy['steps'] as List<String>)
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => Padding(
                                        padding: EdgeInsets.only(bottom: 6.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 22.w,
                                              height: 22.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${entry.key + 1}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Text(
                                                entry.value,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: emotionTools.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🧰", style: TextStyle(fontSize: 50)),
              SizedBox(height: 8.h),
              const Text(
                "Emotion Tools",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "What to do when you feel...",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          );
        }

        final tool = emotionTools[index - 1];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500 + (index * 150)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: (tool['color'] as Color).withValues(alpha: 0.3),
                  blurRadius: 12.r,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        tool['color'],
                        (tool['color'] as Color).withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(tool['emoji'], style: const TextStyle(fontSize: 35)),
                      SizedBox(width: 14.w),
                      Text(
                        "When I feel ${tool['emotion']}...",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: (tool['tools'] as List<String>)
                        .asMap()
                        .entries
                        .map((entry) {
                          return GestureDetector(
                            onTap: () => _speakText(entry.value),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (tool['color'] as Color).withValues(
                                      alpha: 0.08,
                                    ),
                                    (tool['color'] as Color).withValues(
                                      alpha: 0.18,
                                    ),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: (tool['color'] as Color).withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: tool['color'],
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.volume_up,
                                    color: (tool['color'] as Color).withValues(
                                      alpha: 0.6,
                                    ),
                                    size: 20.r,
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
