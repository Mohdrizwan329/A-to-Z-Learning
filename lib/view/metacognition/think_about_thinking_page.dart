import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ThinkAboutThinkingPage extends StatefulWidget {
  const ThinkAboutThinkingPage({super.key});

  @override
  State<ThinkAboutThinkingPage> createState() => _ThinkAboutThinkingPageState();
}

class _ThinkAboutThinkingPageState extends State<ThinkAboutThinkingPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;

  final List<Map<String, dynamic>> thinkingConcepts = [
    {
      'title': 'How Do You Learn?',
      'emoji': '🧠',
      'color': Color(0xFF6366F1),
      'question': 'What helps you learn best?',
      'options': [
        {'emoji': '👁️', 'text': 'Seeing pictures', 'type': 'Visual'},
        {'emoji': '👂', 'text': 'Listening', 'type': 'Auditory'},
        {'emoji': '✋', 'text': 'Doing things', 'type': 'Kinesthetic'},
      ],
      'tip': 'Everyone learns differently! Knowing how you learn helps you study better.',
    },
    {
      'title': 'Before You Start',
      'emoji': '🎯',
      'color': Color(0xFF10B981),
      'question': 'What should you think about before starting a task?',
      'steps': [
        {'emoji': '🤔', 'text': 'What do I need to do?'},
        {'emoji': '📋', 'text': 'What do I already know?'},
        {'emoji': '🛠️', 'text': 'What tools do I need?'},
        {'emoji': '⏰', 'text': 'How long will it take?'},
      ],
      'tip': 'Planning before you start makes everything easier!',
    },
    {
      'title': 'While You Work',
      'emoji': '💭',
      'color': Color(0xFFF59E0B),
      'question': 'What should you ask yourself while working?',
      'steps': [
        {'emoji': '✅', 'text': 'Am I doing this right?'},
        {'emoji': '🆘', 'text': 'Do I need help?'},
        {'emoji': '🔄', 'text': 'Should I try a different way?'},
        {'emoji': '🎯', 'text': 'Am I staying focused?'},
      ],
      'tip': 'Checking your work while doing it helps you catch mistakes!',
    },
    {
      'title': 'After You Finish',
      'emoji': '🏁',
      'color': Color(0xFFEC4899),
      'question': 'What should you think about after finishing?',
      'steps': [
        {'emoji': '🤔', 'text': 'Did I do my best?'},
        {'emoji': '📝', 'text': 'What did I learn?'},
        {'emoji': '💪', 'text': 'What was hard?'},
        {'emoji': '🌟', 'text': 'What can I do better next time?'},
      ],
      'tip': 'Reflecting helps you become a better learner!',
    },
    {
      'title': 'Problem Solving',
      'emoji': '🧩',
      'color': Color(0xFF8B5CF6),
      'question': 'What to do when you\'re stuck?',
      'steps': [
        {'emoji': '😤', 'text': 'Take a deep breath'},
        {'emoji': '🔍', 'text': 'Read the problem again'},
        {'emoji': '✂️', 'text': 'Break it into smaller parts'},
        {'emoji': '🙋', 'text': 'Ask for help if needed'},
      ],
      'tip': 'Getting stuck is normal! Smart kids know how to get unstuck.',
    },
    {
      'title': 'Memory Tricks',
      'emoji': '🎪',
      'color': Color(0xFF06B6D4),
      'question': 'How can you remember things better?',
      'tricks': [
        {'emoji': '🎵', 'text': 'Make a song', 'example': 'ABC song'},
        {'emoji': '🖼️', 'text': 'Draw a picture', 'example': 'Mind maps'},
        {'emoji': '📖', 'text': 'Tell a story', 'example': 'Connect ideas'},
        {'emoji': '🔁', 'text': 'Repeat it', 'example': 'Practice daily'},
      ],
      'tip': 'Different tricks work for different things. Try them all!',
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
    final concept = thinkingConcepts[currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Think About Thinking',
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
        decoration: BoxDecoration(
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
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressDots(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildConceptCard(concept),
                ),
              ),
              _buildNavigationButtons(concept),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProgressDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(thinkingConcepts.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: index == currentIndex ? 24 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConceptCard(Map<String, dynamic> concept) {
    return Column(
      children: [
        // Main Card
        GestureDetector(
          onTap: () => _speak(concept['title']),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  concept['emoji'],
                  style: const TextStyle(fontSize: 70),
                ),
                const SizedBox(height: 12),
                Text(
                  concept['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: concept['color'],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  concept['question'],
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Content based on type
        if (concept.containsKey('options'))
          _buildOptionsCard(concept)
        else if (concept.containsKey('steps'))
          _buildStepsCard(concept)
        else if (concept.containsKey('tricks'))
          _buildTricksCard(concept),
        const SizedBox(height: 16),
        // Tip Card
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
                child: Text(
                  concept['tip'],
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsCard(Map<String, dynamic> concept) {
    return Column(
      children: (concept['options'] as List).map<Widget>((option) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(option['emoji'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['text'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: concept['color'],
                      ),
                    ),
                    Text(
                      option['type'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepsCard(Map<String, dynamic> concept) {
    return Column(
      children: (concept['steps'] as List).asMap().entries.map<Widget>((entry) {
        final index = entry.key;
        final step = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: concept['color'],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(step['emoji'], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step['text'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTricksCard(Map<String, dynamic> concept) {
    return Column(
      children: (concept['tricks'] as List).map<Widget>((trick) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(trick['emoji'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trick['text'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: concept['color'],
                      ),
                    ),
                    Text(
                      'Example: ${trick['example']}',
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons(Map<String, dynamic> concept) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentIndex > 0)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentIndex--;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: concept['color'],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 100),
          if (currentIndex < thinkingConcepts.length - 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentIndex++;
                });
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: concept['color'],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.check),
              label: const Text('Done!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
