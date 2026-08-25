import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'package:jiyan_learning/services/tts_service.dart';

class ImaginationPage extends StatefulWidget {
  const ImaginationPage({super.key});

  @override
  State<ImaginationPage> createState() => _ImaginationPageState();
}

class _ImaginationPageState extends State<ImaginationPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnimation;
  int currentActivity = 0;

  final List<Map<String, dynamic>> imaginationActivities = [
    {
      'title': 'Cloud Watching',
      'emoji': '☁️',
      'color': Color(0xFF4ECDC4),
      'description': 'Look at the clouds! What shapes do you see?',
      'prompts': [
        'Is that cloud a bunny or a dragon?',
        'Can you find a cloud that looks like a car?',
        'What would happen if you could ride on a cloud?',
        'Imagine the clouds are made of cotton candy!',
      ],
    },
    {
      'title': 'Superhero Powers',
      'emoji': '🦸',
      'color': Color(0xFFFF6B6B),
      'description': 'If you had superpowers, what would they be?',
      'prompts': [
        'Would you fly like a bird or run super fast?',
        'What would your superhero name be?',
        'Who would you help with your powers?',
        'What color would your superhero costume be?',
      ],
    },
    {
      'title': 'Magic World',
      'emoji': '✨',
      'color': Color(0xFFA78BFA),
      'description': 'Imagine you live in a magical world!',
      'prompts': [
        'What magical creature would be your friend?',
        'Would you live in a castle or a treehouse?',
        'What magic spell would you want to learn?',
        'What would your magic wand look like?',
      ],
    },
    {
      'title': 'Under the Sea',
      'emoji': '🧜',
      'color': Color(0xFF667EEA),
      'description': 'Pretend you can breathe underwater!',
      'prompts': [
        'What fish would you swim with?',
        'Would you live in a shell house or coral cave?',
        'What treasure would you find?',
        'What games would you play with dolphins?',
      ],
    },
    {
      'title': 'Space Adventure',
      'emoji': '🚀',
      'color': Color(0xFF56D97F),
      'description': 'Blast off to outer space!',
      'prompts': [
        'Which planet would you visit first?',
        'What would aliens look like?',
        'What would you eat in space?',
        'Would you bounce on the moon?',
      ],
    },
    {
      'title': 'Animal Talk',
      'emoji': '🦁',
      'color': Color(0xFFFFAA5A),
      'description': 'What if you could talk to animals?',
      'prompts': [
        'What would your pet say to you?',
        'What secrets would birds tell you?',
        'What would elephants talk about?',
        'Would you ask a fish about the ocean?',
      ],
    },
  ];

  final List<Map<String, dynamic>> whatIfQuestions = [
    {'question': 'What if trees could walk?', 'emoji': '🌳'},
    {'question': 'What if ice cream never melted?', 'emoji': '🍦'},
    {'question': 'What if you were tiny like an ant?', 'emoji': '🐜'},
    {'question': 'What if you could be invisible?', 'emoji': '👻'},
    {'question': 'What if toys came alive at night?', 'emoji': '🧸'},
    {'question': 'What if you could paint the sky?', 'emoji': '🎨'},
    {'question': 'What if dinosaurs came back?', 'emoji': '🦕'},
    {'question': 'What if your house was made of candy?', 'emoji': '🍬'},
    {'question': 'What if you had wings?', 'emoji': '🪽'},
    {'question': 'What if you could talk to plants?', 'emoji': '🌻'},
  ];

  final List<Map<String, dynamic>> pretendGames = [
    {'game': 'Pretend to be a chef cooking a feast!', 'emoji': '👨‍🍳', 'color': Color(0xFFFF6B6B)},
    {'game': 'Pretend to be a doctor helping patients!', 'emoji': '👩‍⚕️', 'color': Color(0xFF4ECDC4)},
    {'game': 'Pretend to be a pilot flying a plane!', 'emoji': '👨‍✈️', 'color': Color(0xFF667EEA)},
    {'game': 'Pretend to be a teacher in a classroom!', 'emoji': '👩‍🏫', 'color': Color(0xFF56D97F)},
    {'game': 'Pretend to be a firefighter saving the day!', 'emoji': '👨‍🚒', 'color': Color(0xFFFFAA5A)},
    {'game': 'Pretend to be an explorer in a jungle!', 'emoji': '🧭', 'color': Color(0xFFA78BFA)},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _sparkleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );
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
    _sparkleController.dispose();
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
          title: const Text("Imagination", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              Tab(text: "Imagine", icon: Icon(Icons.auto_awesome, size: 20)),
              Tab(text: "What If?", icon: Icon(Icons.help_outline, size: 20)),
              Tab(text: "Pretend", icon: Icon(Icons.theater_comedy, size: 20)),
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
              _buildImagineTab(),
              _buildWhatIfTab(),
              _buildPretendTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Animated header
          AnimatedBuilder(
            animation: _sparkleController,
            builder: (context, child) {
              return Transform.scale(
                scale: _sparkleAnimation.value,
                child: const Text("✨🌈💫", style: TextStyle(fontSize: 50)),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            "Let's Use Our Imagination!",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Pick a world to explore",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Activity cards
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: imaginationActivities.length,
            itemBuilder: (context, index) {
              final activity = imaginationActivities[index];
              final isExpanded = currentActivity == index;

              return GestureDetector(
                onTap: () {
                  TtsService.to.speak(activity['title']);
                  setState(() => currentActivity = index);
                  _speakText(activity['description']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isExpanded
                        ? LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)])
                        : LinearGradient(colors: [activity['color'], activity['color'].withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(20),
                    border: isExpanded ? Border.all(color: Colors.white, width: 2) : null,
                    boxShadow: [
                      BoxShadow(
                        color: (isExpanded ? Color(0xFFFFD700) : activity['color']).withValues(alpha: 0.4),
                        blurRadius: isExpanded ? 15 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(activity['emoji'], style: const TextStyle(fontSize: 35)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity['title'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text(
                                  activity['description'],
                                  style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9)),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white30),
                        const SizedBox(height: 12),
                        const Text(
                          "Think about...",
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...((activity['prompts'] as List<String>).map((prompt) {
                          return GestureDetector(
                            onTap: () => _speakText(prompt),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Text("💭", style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      prompt,
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                                ],
                              ),
                            ),
                          );
                        })),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIfTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🤔", style: TextStyle(fontSize: 60)),
          const SizedBox(height: 8),
          const Text(
            "What If...?",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Think about these fun questions!",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 24),

          // What if cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: whatIfQuestions.length,
            itemBuilder: (context, index) {
              final question = whatIfQuestions[index];
              final colors = [
                [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                [Color(0xFF667EEA), Color(0xFF764BA2)],
                [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
                [Color(0xFF56D97F), Color(0xFF11998E)],
                [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
              ];
              final gradient = colors[index % colors.length];

              return GestureDetector(
                onTap: () => _speakText(question['question']),
                child: Container(
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
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(question['emoji'], style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          question['question'],
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Random question button
          ElevatedButton.icon(
            onPressed: () {
              final random = whatIfQuestions[Random().nextInt(whatIfQuestions.length)];
              _speakText(random['question']);
            },
            icon: const Icon(Icons.shuffle, size: 24),
            label: const Text("Random Question!", style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFAA5A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPretendTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🎭", style: TextStyle(fontSize: 60)),
          const SizedBox(height: 8),
          const Text(
            "Let's Pretend!",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Act out these fun roles!",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Pretend game cards
          ...pretendGames.map((game) {
            return GestureDetector(
              onTap: () => _speakText(game['game']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [game['color'], game['color'].withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: game['color'].withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(game['emoji'], style: const TextStyle(fontSize: 35))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        game['game'],
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Tips section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "🌟 Imagination Tips 🌟",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTip("Use your hands to act things out!"),
                _buildTip("Make funny sounds and voices!"),
                _buildTip("Use pillows and blankets as props!"),
                _buildTip("Invite friends to play along!"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Text("✨", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
