import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CognitiveFlexibilityPage extends StatefulWidget {
  const CognitiveFlexibilityPage({super.key});

  @override
  State<CognitiveFlexibilityPage> createState() => _CognitiveFlexibilityPageState();
}

class _CognitiveFlexibilityPageState extends State<CognitiveFlexibilityPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Flexible Thinking?',
      'emoji': '🧠🔄',
      'color': Color(0xFF9575CD),
      'content': [
        {'icon': '🔄', 'text': 'Flexible thinking means being able to change your mind'},
        {'icon': '💡', 'text': 'It\'s about seeing things in different ways'},
        {'icon': '🛤️', 'text': 'When one way doesn\'t work, try another!'},
        {'icon': '🎨', 'text': 'Creative people are flexible thinkers'},
        {'icon': '⭐', 'text': 'It helps you solve problems better!'},
      ],
    },
    {
      'title': 'Be Like Water',
      'emoji': '💧',
      'color': Color(0xFF42A5F5),
      'examples': [
        {'situation': 'If the playground is closed', 'rigid': '😢 I can\'t play!', 'flexible': '🎮 I\'ll play inside!'},
        {'situation': 'If your friend is busy', 'rigid': '😤 I have no one to play with', 'flexible': '👋 I\'ll ask someone else'},
        {'situation': 'If it rains on picnic day', 'rigid': '😭 Day is ruined!', 'flexible': '🏠 Indoor picnic fun!'},
        {'situation': 'If you lose a game', 'rigid': '😠 This is unfair!', 'flexible': '📚 I\'ll learn and try again'},
      ],
    },
    {
      'title': 'Switch It Up!',
      'emoji': '🔀',
      'color': Color(0xFF66BB6A),
      'switches': [
        {'from': 'Using right hand', 'to': 'Try left hand', 'emoji': '✋🤚'},
        {'from': 'Walking to school', 'to': 'Take a new route', 'emoji': '🚶🛤️'},
        {'from': 'Same breakfast', 'to': 'Try new food', 'emoji': '🥣🍳'},
        {'from': 'One way to solve', 'to': 'Find 3 ways', 'emoji': '1️⃣➡️3️⃣'},
        {'from': 'Always same seat', 'to': 'Sit somewhere new', 'emoji': '🪑🔄'},
      ],
    },
    {
      'title': 'Multiple Solutions',
      'emoji': '🔧',
      'color': Color(0xFFFF7043),
      'problems': [
        {
          'problem': 'You forgot your pencil',
          'solutions': ['Ask a friend to borrow', 'Use a pen instead', 'Ask the teacher'],
        },
        {
          'problem': 'You can\'t reach something high',
          'solutions': ['Use a stool', 'Ask a tall person', 'Use a stick'],
        },
        {
          'problem': 'Your friend is upset',
          'solutions': ['Give them space', 'Talk to them', 'Do something kind'],
        },
      ],
    },
    {
      'title': 'Different Perspectives',
      'emoji': '👀',
      'color': Color(0xFFEC407A),
      'perspectives': [
        {'thing': 'A ball', 'views': ['A toy to play with', 'Something round', 'A bouncy thing', 'A circle when you look from above']},
        {'thing': 'Rain', 'views': ['Fun to splash in', 'Makes plants grow', 'Can be cold', 'Makes rainbow after']},
        {'thing': 'A box', 'views': ['Container for things', 'A car to play with', 'A house for toys', 'A drum to beat']},
      ],
    },
    {
      'title': 'When Plans Change',
      'emoji': '📅❌',
      'color': Color(0xFFFFB74D),
      'scenarios': [
        {'change': 'Trip cancelled', 'thoughts': ['It\'s okay, we can go later', 'Let\'s plan something else fun'], 'emoji': '✈️❌'},
        {'change': 'Favorite toy broke', 'thoughts': ['Maybe we can fix it', 'I have other toys too'], 'emoji': '��💔'},
        {'change': 'Power went out', 'thoughts': ['Candle time is cozy', 'Let\'s play board games'], 'emoji': '💡❌'},
        {'change': 'Best friend moved', 'thoughts': ['We can video call', 'I\'ll make new friends too'], 'emoji': '👋🏠'},
      ],
    },
    {
      'title': 'Brain Flexibility Games',
      'emoji': '🎮',
      'color': Color(0xFF26A69A),
      'games': [
        {'game': 'Opposite Day', 'how': 'Say the opposite of everything', 'emoji': '⬆️⬇️'},
        {'game': 'What Else?', 'how': 'Think of 5 uses for any object', 'emoji': '🥄'},
        {'game': 'Category Switch', 'how': 'Name animals, then switch to fruits', 'emoji': '🐶🍎'},
        {'game': 'Role Reversal', 'how': 'Pretend you\'re the parent/teacher', 'emoji': '👨‍👧'},
        {'game': 'Story Twist', 'how': 'Change a story\'s ending', 'emoji': '📖✨'},
        {'game': 'New Rules', 'how': 'Play a game with new made-up rules', 'emoji': '🎲'},
      ],
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
          'Flexible Thinking',
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section.containsKey('content')) _buildContentCards(section),
        if (section.containsKey('examples')) _buildExampleCards(section),
        if (section.containsKey('switches')) _buildSwitchCards(section),
        if (section.containsKey('problems')) _buildProblemCards(section),
        if (section.containsKey('perspectives')) _buildPerspectiveCards(section),
        if (section.containsKey('scenarios')) _buildScenarioCards(section),
        if (section.containsKey('games')) _buildGameCards(section),
      ],
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children: (section['content'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(item['icon'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item['text'],
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

  Widget _buildExampleCards(Map<String, dynamic> section) {
    return Column(
      children: (section['examples'] as List).map<Widget>((example) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                example['situation'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text('❌ Rigid', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            example['rigid'],
                            style: GoogleFonts.nunito(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text('✅ Flexible', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            example['flexible'],
                            style: GoogleFonts.nunito(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwitchCards(Map<String, dynamic> section) {
    return Column(
      children: (section['switches'] as List).map<Widget>((sw) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(sw['emoji'], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From: ${sw['from']}',
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.arrow_forward, color: section['color'], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          sw['to'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: section['color'],
                            fontSize: 14,
                          ),
                        ),
                      ],
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

  Widget _buildProblemCards(Map<String, dynamic> section) {
    return Column(
      children: (section['problems'] as List).map<Widget>((problem) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('❓', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      problem['problem'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...(problem['solutions'] as List).asMap().entries.map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
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
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPerspectiveCards(Map<String, dynamic> section) {
    return Column(
      children: (section['perspectives'] as List).map<Widget>((persp) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                persp['thing'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (persp['views'] as List).map<Widget>((view) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '👁️ $view',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: section['color'],
                        fontSize: 12,
                      ),
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

  Widget _buildScenarioCards(Map<String, dynamic> section) {
    return Column(
      children: (section['scenarios'] as List).map<Widget>((scenario) {
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
                  Text(scenario['emoji'], style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      scenario['change'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...(scenario['thoughts'] as List).map<Widget>((thought) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Text('💭', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          thought,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGameCards(Map<String, dynamic> section) {
    return Column(
      children: (section['games'] as List).map<Widget>((game) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
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
                  child: Text(game['emoji'], style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game['game'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      game['how'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 13,
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

  Widget _buildNavButtons(Map<String, dynamic> section) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentSection > 0)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection--),
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
              onPressed: () => setState(() => currentSection++),
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
