import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'dart:math' as math;
import 'package:jiyan_learning/services/tts_service.dart';

class SelfAwarenessPage extends StatefulWidget {
  const SelfAwarenessPage({super.key});

  @override
  State<SelfAwarenessPage> createState() => _SelfAwarenessPageState();
}

class _SelfAwarenessPageState extends State<SelfAwarenessPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  // About Me selections
  String? favoriteColor;
  String? favoriteAnimal;
  String? favoriteFood;
  String? favoriteActivity;

  final List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'color': Colors.red, 'emoji': '🔴'},
    {'name': 'Blue', 'color': Colors.blue, 'emoji': '🔵'},
    {'name': 'Green', 'color': Colors.green, 'emoji': '🟢'},
    {'name': 'Yellow', 'color': Colors.yellow, 'emoji': '🟡'},
    {'name': 'Purple', 'color': Colors.purple, 'emoji': '🟣'},
    {'name': 'Orange', 'color': Colors.orange, 'emoji': '🟠'},
    {'name': 'Pink', 'color': Colors.pink, 'emoji': '💗'},
  ];

  final List<Map<String, dynamic>> animals = [
    {'name': 'Dog', 'emoji': '🐕'},
    {'name': 'Cat', 'emoji': '🐱'},
    {'name': 'Rabbit', 'emoji': '🐰'},
    {'name': 'Bird', 'emoji': '🐦'},
    {'name': 'Fish', 'emoji': '🐠'},
    {'name': 'Elephant', 'emoji': '🐘'},
    {'name': 'Lion', 'emoji': '🦁'},
    {'name': 'Butterfly', 'emoji': '🦋'},
  ];

  final List<Map<String, dynamic>> foods = [
    {'name': 'Pizza', 'emoji': '🍕'},
    {'name': 'Ice Cream', 'emoji': '🍦'},
    {'name': 'Fruits', 'emoji': '🍎'},
    {'name': 'Cake', 'emoji': '🎂'},
    {'name': 'Pasta', 'emoji': '🍝'},
    {'name': 'Sandwich', 'emoji': '🥪'},
    {'name': 'Rice', 'emoji': '🍚'},
    {'name': 'Cookies', 'emoji': '🍪'},
  ];

  final List<Map<String, dynamic>> activities = [
    {'name': 'Drawing', 'emoji': '🎨'},
    {'name': 'Reading', 'emoji': '📚'},
    {'name': 'Playing Sports', 'emoji': '⚽'},
    {'name': 'Dancing', 'emoji': '💃'},
    {'name': 'Singing', 'emoji': '🎤'},
    {'name': 'Building', 'emoji': '🧱'},
    {'name': 'Cooking', 'emoji': '👨‍🍳'},
    {'name': 'Games', 'emoji': '🎮'},
  ];

  final List<Map<String, dynamic>> bodyAwareness = [
    {'part': 'Head', 'emoji': '🧠', 'function': 'Helps you think and learn!', 'color': Color(0xFFA78BFA)},
    {'part': 'Eyes', 'emoji': '👀', 'function': 'Help you see beautiful things!', 'color': Color(0xFF4ECDC4)},
    {'part': 'Ears', 'emoji': '👂', 'function': 'Help you hear sounds and music!', 'color': Color(0xFFFFAA5A)},
    {'part': 'Nose', 'emoji': '👃', 'function': 'Helps you smell and breathe!', 'color': Color(0xFF56D97F)},
    {'part': 'Mouth', 'emoji': '👄', 'function': 'Helps you talk, eat, and smile!', 'color': Color(0xFFFF6B6B)},
    {'part': 'Hands', 'emoji': '🤲', 'function': 'Help you hold, draw, and hug!', 'color': Color(0xFF667EEA)},
    {'part': 'Legs', 'emoji': '🦵', 'function': 'Help you walk, run, and jump!', 'color': Color(0xFFFFD93D)},
    {'part': 'Heart', 'emoji': '❤️', 'function': 'Pumps blood and helps you feel love!', 'color': Color(0xFFFF8E53)},
  ];

  final List<Map<String, dynamic>> iAmQuestions = [
    {'question': 'What makes you happy?', 'emoji': '😊'},
    {'question': 'What are you good at?', 'emoji': '⭐'},
    {'question': 'Who do you love?', 'emoji': '💕'},
    {'question': 'What do you want to learn?', 'emoji': '📚'},
    {'question': 'What is your favorite place?', 'emoji': '🏠'},
    {'question': 'What makes you special?', 'emoji': '✨'},
  ];

  late AnimationController _cardAnimController;
  late List<Animation<double>> _bodyCardAnimations;
  late List<Animation<double>> _questionCardAnimations;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
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
    _bodyCardAnimations = List.generate(
      bodyAwareness.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardAnimController,
          curve: Interval(index * 0.1, (index * 0.1 + 0.4).clamp(0.0, 1.0), curve: Curves.easeOutBack),
        ),
      ),
    );
    _questionCardAnimations = List.generate(
      iAmQuestions.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardAnimController,
          curve: Interval(index * 0.12, (index * 0.12 + 0.4).clamp(0.0, 1.0), curve: Curves.easeOutBack),
        ),
      ),
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _cardAnimController.reset();
        _cardAnimController.forward();
      }
    });
    _cardAnimController.forward();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cardAnimController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ),
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
        title: const Text("Know Yourself", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelPadding: const EdgeInsets.symmetric(horizontal: 44),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: "About Me"),
            Tab(text: "My Body"),
            Tab(text: "Questions"),
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
            ..._buildFloatingBubbles(),
            TabBarView(
              controller: _tabController,
              children: [
                _buildAboutMeTab(),
                _buildBodyTab(),
                _buildQuestionsTab(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
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

  Widget _buildAboutMeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("👤", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          const Text("All About Me!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Discover your favorites!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 24),

          // Favorite Color
          _buildPreferenceSection(
            title: "My Favorite Color",
            emoji: "🎨",
            items: colors,
            selectedValue: favoriteColor,
            displayKey: 'emoji',
            nameKey: 'name',
            onSelect: (value) => setState(() => favoriteColor = value),
            gradient: const [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            sectionIndex: 0,
          ),

          // Favorite Animal
          _buildPreferenceSection(
            title: "My Favorite Animal",
            emoji: "🐾",
            items: animals,
            selectedValue: favoriteAnimal,
            displayKey: 'emoji',
            nameKey: 'name',
            onSelect: (value) => setState(() => favoriteAnimal = value),
            gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
            sectionIndex: 1,
          ),

          // Favorite Food
          _buildPreferenceSection(
            title: "My Favorite Food",
            emoji: "🍽️",
            items: foods,
            selectedValue: favoriteFood,
            displayKey: 'emoji',
            nameKey: 'name',
            onSelect: (value) => setState(() => favoriteFood = value),
            gradient: const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            sectionIndex: 2,
          ),

          // Favorite Activity
          _buildPreferenceSection(
            title: "What I Love To Do",
            emoji: "✨",
            items: activities,
            selectedValue: favoriteActivity,
            displayKey: 'emoji',
            nameKey: 'name',
            onSelect: (value) => setState(() => favoriteActivity = value),
            gradient: const [Color(0xFFA78BFA), Color(0xFF7C3AED)],
            sectionIndex: 3,
          ),

          const SizedBox(height: 16),

          // Summary Card
          if (favoriteColor != null || favoriteAnimal != null || favoriteFood != null || favoriteActivity != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text("📋 My Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (favoriteColor != null) Text("Color: $favoriteColor", style: const TextStyle(color: Colors.white)),
                  if (favoriteAnimal != null) Text("Animal: $favoriteAnimal", style: const TextStyle(color: Colors.white)),
                  if (favoriteFood != null) Text("Food: $favoriteFood", style: const TextStyle(color: Colors.white)),
                  if (favoriteActivity != null) Text("Activity: $favoriteActivity", style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreferenceSection({
    required String title,
    required String emoji,
    required List<Map<String, dynamic>> items,
    required String? selectedValue,
    required String displayKey,
    required String nameKey,
    required Function(String) onSelect,
    required List<Color> gradient,
    required int sectionIndex,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (sectionIndex * 150)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final offset = (sectionIndex % 2 == 0)
              ? _floatAnimation.value * 0.5
              : -_floatAnimation.value * 0.5;
          return Transform.translate(offset: Offset(0, offset), child: child);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: -10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Color(0x40000000), offset: Offset(1, 1), blurRadius: 3)],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: items.map((item) {
                        final isSelected = selectedValue == item[nameKey];
                        return GestureDetector(
                          onTap: () {
                            TtsService.to.speak(item[nameKey]);
                            onSelect(item[nameKey]);
                            _speakText("My favorite is ${item[nameKey]}");
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                              boxShadow: isSelected
                                  ? [BoxShadow(color: Colors.white.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item[displayKey], style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 6),
                                Text(
                                  item[nameKey],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? gradient[0] : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bodyAwareness.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🧍", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("My Amazing Body", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Learn what each part does!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final part = bodyAwareness[index - 1];
        final animIndex = (index - 1).clamp(0, _bodyCardAnimations.length - 1);
        final bodyGradients = const [
          [Color(0xFFA78BFA), Color(0xFF7C3AED)],
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFFAA5A), Color(0xFFFF6B6B)],
          [Color(0xFF56D97F), Color(0xFF2ECC71)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFD93D), Color(0xFFFF8E53)],
          [Color(0xFFFF8E53), Color(0xFFFF6B6B)],
        ];
        final gradient = bodyGradients[(index - 1) % bodyGradients.length];

        return AnimatedBuilder(
          animation: _bodyCardAnimations[animIndex],
          builder: (context, child) {
            final value = _bodyCardAnimations[animIndex].value;
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final offset = ((index - 1) % 2 == 0)
                  ? _floatAnimation.value * 0.5
                  : -_floatAnimation.value * 0.5;
              return Transform.translate(offset: Offset(0, offset), child: child);
            },
            child: GestureDetector(
              onTap: () => _speakText("${part['part']}. ${part['function']}"),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(part['emoji'], style: const TextStyle(fontSize: 30))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  part['part'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [Shadow(color: Color(0x40000000), offset: Offset(1, 1), blurRadius: 3)],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(part['function'], style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85))),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
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

  Widget _buildQuestionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: iAmQuestions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🤔", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Think About...", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Questions to explore yourself!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final question = iAmQuestions[index - 1];
        final gradientColors = [
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
          [Color(0xFF56D97F), Color(0xFF11998E)],
          [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        ];
        final gradient = gradientColors[(index - 1) % gradientColors.length];
        final animIndex = (index - 1).clamp(0, _questionCardAnimations.length - 1);

        return AnimatedBuilder(
          animation: _questionCardAnimations[animIndex],
          builder: (context, child) {
            final value = _questionCardAnimations[animIndex].value;
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final offset = ((index - 1) % 2 == 0)
                  ? _floatAnimation.value * 0.5
                  : -_floatAnimation.value * 0.5;
              return Transform.translate(offset: Offset(0, offset), child: child);
            },
            child: GestureDetector(
              onTap: () => _speakText(question['question']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: gradient[0].withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(question['emoji'], style: const TextStyle(fontSize: 32))),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              question['question'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Color(0x40000000), offset: Offset(1, 1), blurRadius: 3)],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
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
}
