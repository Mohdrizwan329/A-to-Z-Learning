import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class ConversationPracticePage extends StatefulWidget {
  const ConversationPracticePage({super.key});

  @override
  State<ConversationPracticePage> createState() => _ConversationPracticePageState();
}

class _ConversationPracticePageState extends State<ConversationPracticePage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  int currentDialogueIndex = 0;
  int currentLineIndex = 0;
  bool isPlaying = false;

  final List<Map<String, dynamic>> greetings = [
    {'phrase': 'Hello!', 'emoji': '👋', 'response': 'Hello! How are you?'},
    {'phrase': 'Good morning!', 'emoji': '🌅', 'response': 'Good morning! Did you sleep well?'},
    {'phrase': 'Good afternoon!', 'emoji': '☀️', 'response': 'Good afternoon! How is your day?'},
    {'phrase': 'Good evening!', 'emoji': '🌆', 'response': 'Good evening! Nice to see you!'},
    {'phrase': 'Good night!', 'emoji': '🌙', 'response': 'Good night! Sweet dreams!'},
    {'phrase': 'How are you?', 'emoji': '🙂', 'response': 'I am fine, thank you!'},
    {'phrase': 'Nice to meet you!', 'emoji': '🤝', 'response': 'Nice to meet you too!'},
    {'phrase': 'Goodbye!', 'emoji': '👋', 'response': 'Goodbye! See you later!'},
    {'phrase': 'See you later!', 'emoji': '✌️', 'response': 'See you! Take care!'},
    {'phrase': 'Thank you!', 'emoji': '🙏', 'response': 'You are welcome!'},
  ];

  final List<Map<String, dynamic>> politeExpressions = [
    {'phrase': 'Please', 'emoji': '🙏', 'usage': 'Use when asking for something', 'example': 'Can I have some water, please?'},
    {'phrase': 'Thank you', 'emoji': '💝', 'usage': 'Use to show gratitude', 'example': 'Thank you for helping me!'},
    {'phrase': 'You\'re welcome', 'emoji': '😊', 'usage': 'Reply to thank you', 'example': 'You\'re welcome! Anytime!'},
    {'phrase': 'Excuse me', 'emoji': '🙋', 'usage': 'To get attention politely', 'example': 'Excuse me, where is the library?'},
    {'phrase': 'I\'m sorry', 'emoji': '😔', 'usage': 'When you make a mistake', 'example': 'I\'m sorry I broke your pencil.'},
    {'phrase': 'May I?', 'emoji': '❓', 'usage': 'Asking for permission', 'example': 'May I go to the bathroom?'},
    {'phrase': 'Pardon me', 'emoji': '👂', 'usage': 'When you didn\'t hear', 'example': 'Pardon me? Can you repeat that?'},
    {'phrase': 'After you', 'emoji': '🚪', 'usage': 'Being polite at doors', 'example': 'After you! Please go first.'},
  ];

  final List<Map<String, dynamic>> dialogues = [
    {
      'title': 'At the Store',
      'emoji': '🏪',
      'color': Color(0xFF4ECDC4),
      'characters': ['Shopkeeper', 'Child'],
      'lines': [
        {'speaker': 'Shopkeeper', 'text': 'Hello! How can I help you?'},
        {'speaker': 'Child', 'text': 'Hello! I would like to buy an apple, please.'},
        {'speaker': 'Shopkeeper', 'text': 'Sure! Here you go. That will be 10 rupees.'},
        {'speaker': 'Child', 'text': 'Here is the money. Thank you!'},
        {'speaker': 'Shopkeeper', 'text': 'You\'re welcome! Have a nice day!'},
        {'speaker': 'Child', 'text': 'You too! Goodbye!'},
      ],
    },
    {
      'title': 'Making a Friend',
      'emoji': '👫',
      'color': Color(0xFFFF6B6B),
      'characters': ['You', 'New Friend'],
      'lines': [
        {'speaker': 'You', 'text': 'Hi! My name is Rahul. What\'s your name?'},
        {'speaker': 'New Friend', 'text': 'Hello Rahul! I am Priya. Nice to meet you!'},
        {'speaker': 'You', 'text': 'Nice to meet you too! Do you want to play?'},
        {'speaker': 'New Friend', 'text': 'Yes! What game should we play?'},
        {'speaker': 'You', 'text': 'Let\'s play catch! Do you like catch?'},
        {'speaker': 'New Friend', 'text': 'I love catch! Let\'s go!'},
      ],
    },
    {
      'title': 'At School',
      'emoji': '🏫',
      'color': Color(0xFF667EEA),
      'characters': ['Teacher', 'Student'],
      'lines': [
        {'speaker': 'Teacher', 'text': 'Good morning, class!'},
        {'speaker': 'Student', 'text': 'Good morning, Teacher!'},
        {'speaker': 'Teacher', 'text': 'Did everyone finish their homework?'},
        {'speaker': 'Student', 'text': 'Yes, Teacher! I finished it.'},
        {'speaker': 'Teacher', 'text': 'Very good! Please open your books.'},
        {'speaker': 'Student', 'text': 'Excuse me, Teacher. Which page?'},
        {'speaker': 'Teacher', 'text': 'Page 25, please.'},
        {'speaker': 'Student', 'text': 'Thank you, Teacher!'},
      ],
    },
    {
      'title': 'At the Doctor',
      'emoji': '👨‍⚕️',
      'color': Color(0xFFA78BFA),
      'characters': ['Doctor', 'Child'],
      'lines': [
        {'speaker': 'Doctor', 'text': 'Hello! What brings you here today?'},
        {'speaker': 'Child', 'text': 'Hello Doctor. I have a tummy ache.'},
        {'speaker': 'Doctor', 'text': 'I see. Does it hurt a lot?'},
        {'speaker': 'Child', 'text': 'A little bit. I ate too much ice cream.'},
        {'speaker': 'Doctor', 'text': 'Okay. Take this medicine and rest.'},
        {'speaker': 'Child', 'text': 'Thank you, Doctor!'},
      ],
    },
    {
      'title': 'Phone Call',
      'emoji': '📞',
      'color': Color(0xFFFFAA5A),
      'characters': ['You', 'Friend'],
      'lines': [
        {'speaker': 'You', 'text': 'Hello! May I speak to Arjun, please?'},
        {'speaker': 'Friend', 'text': 'Hi! This is Arjun speaking.'},
        {'speaker': 'You', 'text': 'Hi Arjun! This is Riya. How are you?'},
        {'speaker': 'Friend', 'text': 'I am good! What\'s up?'},
        {'speaker': 'You', 'text': 'Would you like to come to my birthday party?'},
        {'speaker': 'Friend', 'text': 'Yes! I would love to! When is it?'},
        {'speaker': 'You', 'text': 'It\'s on Saturday at 4 PM.'},
        {'speaker': 'Friend', 'text': 'Great! I will be there. Thank you for inviting me!'},
      ],
    },
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

  void _playDialogue(int dialogueIndex) async {
    final dialogue = dialogues[dialogueIndex];
    final lines = dialogue['lines'] as List<Map<String, dynamic>>;

    setState(() {
      currentDialogueIndex = dialogueIndex;
      isPlaying = true;
      currentLineIndex = 0;
    });

    for (int i = 0; i < lines.length; i++) {
      if (!isPlaying || !mounted) break;
      setState(() => currentLineIndex = i);
      await flutterTts.speak(lines[i]['text']);
      await Future.delayed(const Duration(seconds: 3));
    }

    if (!mounted) return;
    setState(() => isPlaying = false);
  }

  void _stopDialogue() {
    flutterTts.stop();
    setState(() => isPlaying = false);
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
          onPressed: () {
            if (isPlaying) _stopDialogue();
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
        title: const Text("Conversation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Greetings", icon: Icon(Icons.waving_hand, size: 20)),
            Tab(text: "Polite", icon: Icon(Icons.favorite, size: 20)),
            Tab(text: "Dialogues", icon: Icon(Icons.chat, size: 20)),
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
            _buildGreetingsTab(),
            _buildPoliteTab(),
            _buildDialoguesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: greetings.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("👋", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Daily Greetings", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Tap to hear and practice!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final greeting = greetings[index - 1];
        return GestureDetector(
          onTap: () {
            TtsService.to.speak(greeting['phrase']);
            _speakText("${greeting['phrase']} ${greeting['response']}");
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(greeting['emoji'], style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greeting['phrase'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF667EEA))),
                      const SizedBox(height: 4),
                      Text("→ ${greeting['response']}", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const Icon(Icons.volume_up, color: Color(0xFF667EEA)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPoliteTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: politeExpressions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🙏", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Polite Words", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Learn to speak kindly!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final expression = politeExpressions[index - 1];
        final colors = [Color(0xFF4ECDC4), Color(0xFFFF6B6B), Color(0xFF667EEA), Color(0xFFFFAA5A), Color(0xFFA78BFA), Color(0xFF56D97F)];
        final color = colors[(index - 1) % colors.length];

        return GestureDetector(
          onTap: () {
            TtsService.to.speak(expression['phrase']);
            _speakText("${expression['phrase']}. ${expression['example']}");
          },
          child: Container(
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
                    gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Text(expression['emoji'], style: const TextStyle(fontSize: 30)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(expression['phrase'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white70),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("📝", style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(expression['usage'], style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Text("💬", style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(child: Text("\"${expression['example']}\"", style: TextStyle(color: color, fontStyle: FontStyle.italic))),
                          ],
                        ),
                      ),
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

  Widget _buildDialoguesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dialogues.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🎭", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Practice Dialogues", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Listen to real conversations!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final dialogue = dialogues[index - 1];
        final isCurrentlyPlaying = isPlaying && currentDialogueIndex == index - 1;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: dialogue['color'].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [dialogue['color'], dialogue['color'].withValues(alpha: 0.7)]),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Text(dialogue['emoji'], style: const TextStyle(fontSize: 35)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dialogue['title'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${(dialogue['lines'] as List).length} lines", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        TtsService.to.speak(dialogue['title']);
                        isCurrentlyPlaying ? _stopDialogue() : _playDialogue(index - 1);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCurrentlyPlaying ? Icons.stop : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: (dialogue['lines'] as List<Map<String, dynamic>>).asMap().entries.map((entry) {
                    final lineIndex = entry.key;
                    final line = entry.value;
                    final isCurrentLine = isCurrentlyPlaying && lineIndex == currentLineIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCurrentLine ? dialogue['color'].withValues(alpha: 0.2) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: isCurrentLine ? Border.all(color: dialogue['color'], width: 2) : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: dialogue['color'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(line['speaker'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              line['text'],
                              style: TextStyle(color: isCurrentLine ? dialogue['color'] : Colors.grey.shade700, fontWeight: isCurrentLine ? FontWeight.bold : FontWeight.normal),
                            ),
                          ),
                        ],
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
