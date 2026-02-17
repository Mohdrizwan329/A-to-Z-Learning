import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

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

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
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
    flutterTts.stop();
    super.dispose();
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
          tabs: const [
            Tab(text: "About Me", icon: Icon(Icons.person, size: 20)),
            Tab(text: "My Body", icon: Icon(Icons.accessibility, size: 20)),
            Tab(text: "Questions", icon: Icon(Icons.help, size: 20)),
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
            _buildAboutMeTab(),
            _buildBodyTab(),
            _buildQuestionsTab(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((item) {
              final isSelected = selectedValue == item[nameKey];
              return GestureDetector(
                onTap: () {
                  onSelect(item[nameKey]);
                  _speakText("My favorite is ${item[nameKey]}");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFFFD700) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item[displayKey], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Text(item[nameKey], style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
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
        return GestureDetector(
          onTap: () => _speakText("${part['part']}. ${part['function']}"),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: part['color'].withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(part['emoji'], style: const TextStyle(fontSize: 30))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(part['part'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: part['color'])),
                      const SizedBox(height: 4),
                      Text(part['function'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Icon(Icons.volume_up, color: part['color']),
              ],
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
        final colors = [
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
          [Color(0xFF56D97F), Color(0xFF11998E)],
          [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        ];
        final gradient = colors[(index - 1) % colors.length];

        return GestureDetector(
          onTap: () => _speakText(question['question']),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: gradient[0].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Text(question['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    question['question'],
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.volume_up, color: Colors.white70),
              ],
            ),
          ),
        );
      },
    );
  }
}
