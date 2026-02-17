import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearningStrategyPage extends StatefulWidget {
  const LearningStrategyPage({super.key});

  @override
  State<LearningStrategyPage> createState() => _LearningStrategyPageState();
}

class _LearningStrategyPageState extends State<LearningStrategyPage> {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedStrategy;

  final List<Map<String, dynamic>> strategies = [
    {
      'name': 'Chunking',
      'emoji': '🧩',
      'color': Color(0xFF6366F1),
      'tagline': 'Break it into pieces!',
      'description': 'Break big things into small pieces to learn easier.',
      'example': 'Instead of learning 123456789, learn 123-456-789',
      'steps': [
        'Look at the big thing you need to learn',
        'Break it into 3-4 smaller parts',
        'Learn one part at a time',
        'Put it all together!',
      ],
      'bestFor': ['Phone numbers', 'Long words', 'Big problems'],
    },
    {
      'name': 'Visualization',
      'emoji': '🎨',
      'color': Color(0xFFEC4899),
      'tagline': 'See it in your mind!',
      'description': 'Create pictures in your mind to remember things.',
      'example': 'To remember "CAT", picture a cat in your mind',
      'steps': [
        'Close your eyes',
        'Create a picture in your mind',
        'Add colors and details',
        'Open eyes and recall the picture',
      ],
      'bestFor': ['New words', 'Stories', 'Places'],
    },
    {
      'name': 'Repetition',
      'emoji': '🔄',
      'color': Color(0xFF10B981),
      'tagline': 'Practice makes perfect!',
      'description': 'Repeat things many times to remember them forever.',
      'example': 'Say "2+2=4" many times until you never forget',
      'steps': [
        'Learn something new',
        'Say it out loud 5 times',
        'Write it 3 times',
        'Review it tomorrow',
      ],
      'bestFor': ['Math facts', 'Spelling', 'Alphabet'],
    },
    {
      'name': 'Association',
      'emoji': '🔗',
      'color': Color(0xFFF59E0B),
      'tagline': 'Connect new to old!',
      'description': 'Link new things to things you already know.',
      'example': 'The word "EIGHT" looks like it has 8 letters!',
      'steps': [
        'Think of something you know well',
        'Find something similar in the new thing',
        'Create a connection between them',
        'Use this link to remember',
      ],
      'bestFor': ['New vocabulary', 'Names', 'Facts'],
    },
    {
      'name': 'Rhyme & Song',
      'emoji': '🎵',
      'color': Color(0xFF8B5CF6),
      'tagline': 'Sing it to remember!',
      'description': 'Turn information into songs or rhymes.',
      'example': 'Twinkle Twinkle ABC song helps learn alphabet!',
      'steps': [
        'Take what you need to learn',
        'Make it rhyme or add a tune',
        'Sing it several times',
        'The melody helps you remember!',
      ],
      'bestFor': ['ABCs', 'Days of week', 'Months'],
    },
    {
      'name': 'Storytelling',
      'emoji': '📚',
      'color': Color(0xFF06B6D4),
      'tagline': 'Make it a story!',
      'description': 'Create a story to connect ideas together.',
      'example': 'To remember APPLE, BANANA, CAT: "An Apple fell on a Banana which scared a Cat"',
      'steps': [
        'List the things you need to remember',
        'Create characters from them',
        'Make up a fun story',
        'Tell the story to remember!',
      ],
      'bestFor': ['Lists', 'Sequences', 'Vocabulary'],
    },
    {
      'name': 'Drawing',
      'emoji': '✏️',
      'color': Color(0xFFEF4444),
      'tagline': 'Draw to learn!',
      'description': 'Draw pictures to understand and remember.',
      'example': 'Draw a picture of a story to remember it',
      'steps': [
        'Read or hear the information',
        'Get paper and colors',
        'Draw what you learned',
        'Look at your drawing to recall',
      ],
      'bestFor': ['Stories', 'Science concepts', 'History'],
    },
    {
      'name': 'Teach Someone',
      'emoji': '👨‍🏫',
      'color': Color(0xFF14B8A6),
      'tagline': 'Be the teacher!',
      'description': 'Teach what you learn to someone else.',
      'example': 'Teach your teddy bear the ABCs!',
      'steps': [
        'Learn something new',
        'Pretend you are the teacher',
        'Explain it to a friend, pet, or toy',
        'Teaching helps you understand better!',
      ],
      'bestFor': ['Everything!', 'Math', 'Reading'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Learning Strategies',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: selectedStrategy == null
                    ? _buildStrategiesGrid()
                    : _buildStrategyDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStrategiesGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Intro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🧠', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learn How to Learn!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Pick a strategy to discover how it works',
                        style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: strategies.length,
            itemBuilder: (context, index) {
              return _buildStrategyCard(strategies[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyCard(Map<String, dynamic> strategy) {
    return GestureDetector(
      onTap: () {
        _speak(strategy['name']);
        setState(() {
          selectedStrategy = strategy['name'];
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              strategy['color'],
              strategy['color'].withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: strategy['color'].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                strategy['emoji'],
                style: const TextStyle(fontSize: 45),
              ),
              const SizedBox(height: 8),
              Text(
                strategy['name'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                strategy['tagline'],
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrategyDetail() {
    final strategy = strategies.firstWhere((s) => s['name'] == selectedStrategy);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: strategy['color'].withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  strategy['emoji'],
                  style: const TextStyle(fontSize: 70),
                ),
                const SizedBox(height: 12),
                Text(
                  strategy['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: strategy['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strategy['description'],
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Example Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Example:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      Text(
                        strategy['example'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Steps
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('📝', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'How to Use:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: strategy['color'],
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate((strategy['steps'] as List).length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: strategy['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            strategy['steps'][index],
                            style: GoogleFonts.nunito(
                              color: Colors.grey.shade700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Best For
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: strategy['color'].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Best For:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (strategy['bestFor'] as List).map<Widget>((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item,
                        style: GoogleFonts.nunito(
                          color: strategy['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Try It Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  '🎉 Great!',
                  'Now try using ${strategy['name']} in your next lesson!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: strategy['color'],
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              icon: const Text('🚀', style: TextStyle(fontSize: 20)),
              label: Text(
                'I\'ll Try This!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: strategy['color'],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
