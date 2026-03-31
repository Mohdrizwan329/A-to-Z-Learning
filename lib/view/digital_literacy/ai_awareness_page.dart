import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class AiAwarenessPage extends StatefulWidget {
  const AiAwarenessPage({super.key});

  @override
  State<AiAwarenessPage> createState() => _AiAwarenessPageState();
}

class _AiAwarenessPageState extends State<AiAwarenessPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is AI?',
      'emoji': '🤖',
      'color': Color(0xFF673AB7),
      'intro': 'AI stands for Artificial Intelligence. It\'s a computer program that can think and learn!',
      'explanation': [
        {'human': 'Our brain thinks', 'ai': 'AI uses computer programs to think', 'emoji': '🧠'},
        {'human': 'We learn from experience', 'ai': 'AI learns from lots of data', 'emoji': '📚'},
        {'human': 'We recognize faces', 'ai': 'AI can recognize faces too!', 'emoji': '👤'},
        {'human': 'We understand speech', 'ai': 'AI can understand voice commands', 'emoji': '🗣️'},
      ],
      'funFact': 'AI can learn to play games, recognize pictures, and even create art!',
    },
    {
      'title': 'AI in Daily Life',
      'emoji': '🏠',
      'color': Color(0xFF2196F3),
      'intro': 'AI is all around us! Here are places you might find AI:',
      'examples': [
        {'name': 'Voice Assistants', 'emoji': '🔊', 'example': 'Alexa, Siri, Google Assistant', 'does': 'Answers questions, plays music'},
        {'name': 'Smart TVs', 'emoji': '📺', 'example': 'Netflix, YouTube', 'does': 'Suggests shows you might like'},
        {'name': 'Games', 'emoji': '🎮', 'example': 'Video game characters', 'does': 'Computer players that play against you'},
        {'name': 'Cameras', 'emoji': '📷', 'example': 'Phone camera', 'does': 'Recognizes faces, adds filters'},
        {'name': 'Toys', 'emoji': '🧸', 'example': 'Smart robots, talking toys', 'does': 'Responds to what you say'},
        {'name': 'Search', 'emoji': '🔍', 'example': 'Google', 'does': 'Finds what you\'re looking for'},
      ],
    },
    {
      'title': 'How AI Learns',
      'emoji': '📚',
      'color': Color(0xFF4CAF50),
      'intro': 'AI learns by looking at lots and lots of examples!',
      'steps': [
        {'step': 'Collect Data', 'emoji': '📊', 'desc': 'AI needs lots of pictures, words, or numbers to learn from'},
        {'step': 'Find Patterns', 'emoji': '🔍', 'desc': 'AI looks for what\'s the same in all examples'},
        {'step': 'Learn Rules', 'emoji': '📝', 'desc': 'AI figures out rules from the patterns'},
        {'step': 'Make Predictions', 'emoji': '🎯', 'desc': 'AI uses rules to guess about new things'},
        {'step': 'Get Better', 'emoji': '📈', 'desc': 'When AI is wrong, it learns and improves'},
      ],
      'example': {
        'title': 'Example: Teaching AI to recognize cats',
        'process': ['Show it 1000s of cat photos', 'AI learns: cats have whiskers, pointy ears, fur', 'Now it can spot cats in new photos!'],
      },
    },
    {
      'title': 'What AI Can Do',
      'emoji': '✨',
      'color': Color(0xFFFF9800),
      'abilities': [
        {'can': 'See', 'emoji': '👁️', 'examples': ['Recognize faces', 'Read text in photos', 'Identify objects']},
        {'can': 'Hear', 'emoji': '👂', 'examples': ['Understand speech', 'Transcribe audio', 'Identify sounds']},
        {'can': 'Speak', 'emoji': '🗣️', 'examples': ['Read text aloud', 'Answer questions', 'Have conversations']},
        {'can': 'Create', 'emoji': '🎨', 'examples': ['Make art', 'Write stories', 'Compose music']},
        {'can': 'Play', 'emoji': '🎮', 'examples': ['Beat you at chess', 'Play video games', 'Solve puzzles']},
        {'can': 'Help', 'emoji': '🤝', 'examples': ['Answer homework questions', 'Translate languages', 'Find information']},
      ],
    },
    {
      'title': 'What AI Can\'t Do',
      'emoji': '🚫',
      'color': Color(0xFFE91E63),
      'intro': 'AI is smart, but it\'s not perfect! Here\'s what AI can\'t do:',
      'limitations': [
        {'cant': 'Feel emotions', 'emoji': '❤️', 'why': 'AI doesn\'t have real feelings like you do'},
        {'cant': 'Be creative like humans', 'emoji': '💡', 'why': 'AI copies patterns, it doesn\'t truly imagine'},
        {'cant': 'Understand everything', 'emoji': '🤔', 'why': 'AI can make mistakes with tricky questions'},
        {'cant': 'Have opinions', 'emoji': '💭', 'why': 'AI doesn\'t have personal beliefs'},
        {'cant': 'Replace friends', 'emoji': '👫', 'why': 'Real friendships are special and human'},
        {'cant': 'Always be right', 'emoji': '❌', 'why': 'AI can make mistakes! Always double-check'},
      ],
      'remember': 'AI is a tool to help us, not to replace us!',
    },
    {
      'title': 'AI Safety Tips',
      'emoji': '🛡️',
      'color': Color(0xFF00BCD4),
      'tips': [
        {'tip': 'Don\'t share personal info with AI', 'emoji': '🔒', 'why': 'Keep your private data safe'},
        {'tip': 'Ask parents before using AI tools', 'emoji': '👨‍👩‍👧', 'why': 'They can help choose safe apps'},
        {'tip': 'Don\'t believe everything AI says', 'emoji': '🤨', 'why': 'AI can make mistakes'},
        {'tip': 'Use AI for learning, not cheating', 'emoji': '📚', 'why': 'Learning yourself is important'},
        {'tip': 'Remember AI isn\'t a real friend', 'emoji': '🤖', 'why': 'Real relationships matter more'},
        {'tip': 'Tell an adult if AI shows something bad', 'emoji': '🚨', 'why': 'Get help if you see anything wrong'},
      ],
    },
    {
      'title': 'AI for Good',
      'emoji': '🌟',
      'color': Color(0xFF9C27B0),
      'intro': 'AI can help make the world better!',
      'goodExamples': [
        {'use': 'Healthcare', 'emoji': '🏥', 'how': 'AI helps doctors find diseases early'},
        {'use': 'Environment', 'emoji': '🌍', 'how': 'AI tracks pollution and protects animals'},
        {'use': 'Education', 'emoji': '📖', 'how': 'AI makes learning more fun and personal'},
        {'use': 'Accessibility', 'emoji': '♿', 'how': 'AI helps people who can\'t see or hear'},
        {'use': 'Science', 'emoji': '🔬', 'how': 'AI helps discover new medicines'},
        {'use': 'Safety', 'emoji': '🚗', 'how': 'AI makes cars and planes safer'},
      ],
    },
    {
      'title': 'AI Quiz Time!',
      'emoji': '🎯',
      'color': Color(0xFFFF5722),
      'quizQuestions': [
        {'q': 'What does AI stand for?', 'a': 'Artificial Intelligence', 'emoji': '🤖'},
        {'q': 'Can AI feel real emotions?', 'a': 'No, AI doesn\'t have feelings', 'emoji': '❤️'},
        {'q': 'How does AI learn?', 'a': 'By looking at lots of examples', 'emoji': '📚'},
        {'q': 'Should you share personal info with AI?', 'a': 'No! Keep private things private', 'emoji': '🔒'},
        {'q': 'Is AI always correct?', 'a': 'No, AI can make mistakes', 'emoji': '❌'},
      ],
      'conclusion': 'Great job! You now know the basics of AI!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final section = sections[currentSection];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'AI for Kids',
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
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
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
                  padding: const EdgeInsets.all(16),
                  child: _buildSectionContent(section),
                ),
              ),
              _buildNavButtons(section),
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
        children: List.generate(sections.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: index == currentSection ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == currentSection
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
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
              Text(section['emoji'], style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 12),
              Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
                textAlign: TextAlign.center,
              ),
              if (section.containsKey('intro')) ...[
                const SizedBox(height: 12),
                Text(
                  section['intro'],
                  style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section['title'] == 'What is AI?')
          _buildWhatIsAI(section),
        if (section['title'] == 'AI in Daily Life')
          _buildDailyLife(section),
        if (section['title'] == 'How AI Learns')
          _buildHowAILearns(section),
        if (section['title'] == 'What AI Can Do')
          _buildWhatAICan(section),
        if (section['title'] == 'What AI Can\'t Do')
          _buildWhatAICant(section),
        if (section['title'] == 'AI Safety Tips')
          _buildSafetyTips(section),
        if (section['title'] == 'AI for Good')
          _buildAIForGood(section),
        if (section['title'] == 'AI Quiz Time!')
          _buildQuiz(section),
      ],
    );
  }

  Widget _buildWhatIsAI(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🧠 Human vs AI:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...(section['explanation'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '👤 Human: ${item['human']}',
                              style: GoogleFonts.nunito(fontSize: 12),
                            ),
                            Text(
                              '🤖 AI: ${item['ai']}',
                              style: GoogleFonts.nunito(fontSize: 12),
                            ),
                          ],
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['funFact'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyLife(Map<String, dynamic> section) {
    return Column(
      children: (section['examples'] as List).map<Widget>((example) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(example['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      example['example'],
                      style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Text(
                      '→ ${example['does']}',
                      style: GoogleFonts.nunito(fontSize: 12),
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

  Widget _buildHowAILearns(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: (section['steps'] as List).asMap().entries.map<Widget>((entry) {
              final step = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: section['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(step['emoji'], style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 6),
                              Text(
                                step['step'],
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          Text(
                            step['desc'],
                            style: GoogleFonts.nunito(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🐱 ${section['example']['title']}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(section['example']['process'] as List).asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${entry.key + 1}.', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entry.value, style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhatAICan(Map<String, dynamic> section) {
    return Column(
      children: (section['abilities'] as List).map<Widget>((ability) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(ability['emoji'], style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI Can ${ability['can']}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (ability['examples'] as List).map<Widget>((ex) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ex,
                      style: GoogleFonts.nunito(fontSize: 11),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWhatAICant(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['limitations'] as List).map<Widget>((limit) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(limit['emoji'], style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '❌ ${limit['cant']}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        limit['why'],
                        style: GoogleFonts.nunito(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['remember'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyTips(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).map<Widget>((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(tip['emoji'], style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['tip'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      tip['why'],
                      style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade600),
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

  Widget _buildAIForGood(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: (section['goodExamples'] as List).length,
      itemBuilder: (context, index) {
        final example = section['goodExamples'][index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(example['emoji'], style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                example['use'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                example['how'],
                style: GoogleFonts.nunito(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuiz(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['quizQuestions'] as List).asMap().entries.map((entry) {
          final q = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: section['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        q['q'],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Text(q['emoji'], style: const TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          q['a'],
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                section['conclusion'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavButtons(Map<String, dynamic> section) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentSection > 0)
            ElevatedButton.icon(
              onPressed: () {
                setState(() => currentSection--);
                TtsService.to.speak(sections[currentSection]['title']);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 100),
          if (currentSection < sections.length - 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() => currentSection++);
                TtsService.to.speak(sections[currentSection]['title']);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
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
