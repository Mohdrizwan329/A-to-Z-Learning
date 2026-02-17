import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkingMemoryPage extends StatefulWidget {
  const WorkingMemoryPage({super.key});

  @override
  State<WorkingMemoryPage> createState() => _WorkingMemoryPageState();
}

class _WorkingMemoryPageState extends State<WorkingMemoryPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Working Memory?',
      'emoji': '🧠',
      'color': Color(0xFF7E57C2),
      'content': [
        {'icon': '🧠', 'text': 'Working memory is like a mental sticky note'},
        {'icon': '📝', 'text': 'It helps you remember things for a short time'},
        {'icon': '🔢', 'text': 'Like remembering a phone number while dialing'},
        {'icon': '📚', 'text': 'It helps you follow instructions and learn'},
        {'icon': '💪', 'text': 'You can train your memory to be stronger!'},
      ],
    },
    {
      'title': 'Memory Games',
      'emoji': '🎮',
      'color': Color(0xFF42A5F5),
      'games': [
        {'name': 'Simon Says', 'emoji': '🔴🔵🟢🟡', 'how': 'Remember the color pattern and repeat it'},
        {'name': 'Memory Cards', 'emoji': '🃏', 'how': 'Find matching pairs by remembering positions'},
        {'name': 'Number Chain', 'emoji': '🔢', 'how': 'Remember and repeat growing number sequences'},
        {'name': 'Story Recall', 'emoji': '📖', 'how': 'Listen to a story and answer questions'},
        {'name': 'Shopping List', 'emoji': '🛒', 'how': 'Remember items without writing them'},
      ],
    },
    {
      'title': 'Remember These!',
      'emoji': '👀',
      'color': Color(0xFFFF7043),
      'challenges': [
        {'level': 'Easy', 'items': '🍎 🍌 🍇', 'count': 3},
        {'level': 'Medium', 'items': '🐶 🐱 🐰 🐻 🦊', 'count': 5},
        {'level': 'Hard', 'items': '⭐ 🌙 ☀️ 🌈 ⚡ 🌺 🍀', 'count': 7},
      ],
    },
    {
      'title': 'Memory Tricks',
      'emoji': '✨',
      'color': Color(0xFF66BB6A),
      'tricks': [
        {'trick': 'Chunking', 'emoji': '🧩', 'how': 'Break big info into small groups', 'example': '123-456-7890 is easier than 1234567890'},
        {'trick': 'Rhyming', 'emoji': '🎵', 'how': 'Make it into a song or rhyme', 'example': 'In 1492, Columbus sailed the ocean blue'},
        {'trick': 'Pictures', 'emoji': '🖼️', 'how': 'Create mental images', 'example': 'Imagine an apple to remember "A"'},
        {'trick': 'Stories', 'emoji': '📖', 'how': 'Link items in a story', 'example': 'The cat ate the apple on the chair'},
        {'trick': 'Repeat', 'emoji': '🔁', 'how': 'Say it again and again', 'example': 'Repeat the phone number 3 times'},
      ],
    },
    {
      'title': 'Follow Instructions',
      'emoji': '📋',
      'color': Color(0xFFFFB74D),
      'instructions': [
        {'steps': 2, 'example': 'Touch your nose, then clap your hands', 'emoji': '👃👏'},
        {'steps': 3, 'example': 'Stand up, turn around, sit down', 'emoji': '🧍🔄🪑'},
        {'steps': 4, 'example': 'Jump, touch toes, wave, smile', 'emoji': '🦘👆👋😊'},
        {'steps': 5, 'example': 'Clap, stomp, spin, jump, bow', 'emoji': '👏🦶🔄🦘🙇'},
      ],
    },
    {
      'title': 'Number Memory',
      'emoji': '🔢',
      'color': Color(0xFFEC407A),
      'numbers': [
        {'sequence': '3 - 7', 'digits': 2, 'level': 'Beginner'},
        {'sequence': '5 - 2 - 9', 'digits': 3, 'level': 'Easy'},
        {'sequence': '4 - 8 - 1 - 6', 'digits': 4, 'level': 'Medium'},
        {'sequence': '7 - 3 - 9 - 2 - 5', 'digits': 5, 'level': 'Hard'},
        {'sequence': '1 - 4 - 7 - 2 - 8 - 5', 'digits': 6, 'level': 'Expert'},
      ],
    },
    {
      'title': 'Daily Memory Practice',
      'emoji': '📅',
      'color': Color(0xFF26A69A),
      'activities': [
        {'activity': 'Memorize your daily schedule', 'emoji': '📆'},
        {'activity': 'Remember what you had for breakfast', 'emoji': '🥣'},
        {'activity': 'Recall 5 things you saw on the way', 'emoji': '👀'},
        {'activity': 'Remember names of new people', 'emoji': '👋'},
        {'activity': 'Recite a poem from memory', 'emoji': '📜'},
        {'activity': 'Play memory card games', 'emoji': '🃏'},
        {'activity': 'Draw something from memory', 'emoji': '🎨'},
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
          'Working Memory',
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
              Text(section['emoji'], style: const TextStyle(fontSize: 60)),
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
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section.containsKey('content')) _buildContentCards(section),
        if (section.containsKey('games')) _buildGameCards(section),
        if (section.containsKey('challenges')) _buildChallengeCards(section),
        if (section.containsKey('tricks')) _buildTrickCards(section),
        if (section.containsKey('instructions')) _buildInstructionCards(section),
        if (section.containsKey('numbers')) _buildNumberCards(section),
        if (section.containsKey('activities')) _buildActivityCards(section),
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
                  child: Text(game['emoji'].toString().substring(0, 2), style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game['name'],
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

  Widget _buildChallengeCards(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(
          'Look, Remember, Recall!',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...(section['challenges'] as List).map<Widget>((challenge) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: section['color'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        challenge['level'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '${challenge['count']} items',
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  challenge['items'],
                  style: const TextStyle(fontSize: 36, letterSpacing: 8),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrickCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tricks'] as List).map<Widget>((trick) {
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
                  Text(trick['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Text(
                    trick['trick'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                trick['how'],
                style: GoogleFonts.nunito(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '💡 ${trick['example']}',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
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

  Widget _buildInstructionCards(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(
          'Follow the Steps!',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...(section['instructions'] as List).map<Widget>((inst) {
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
                    color: section['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${inst['steps']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inst['example'],
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        inst['emoji'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNumberCards(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(
          'Remember the Numbers!',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...(section['numbers'] as List).map<Widget>((num) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    num['level'],
                    style: GoogleFonts.poppins(
                      color: section['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    num['sequence'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Text(
                  '${num['digits']} digits',
                  style: GoogleFonts.nunito(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActivityCards(Map<String, dynamic> section) {
    return Column(
      children: (section['activities'] as List).map<Widget>((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(activity['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  activity['activity'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.check_circle_outline, color: section['color']),
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
