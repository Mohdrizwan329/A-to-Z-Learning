import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({super.key});

  @override
  State<GoalSettingPage> createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends State<GoalSettingPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is a Goal?',
      'emoji': '🎯',
      'color': Color(0xFFFF6B6B),
      'content': [
        {'icon': '🎯', 'text': 'A goal is something you want to achieve'},
        {'icon': '🌟', 'text': 'It gives you something to work towards'},
        {'icon': '📈', 'text': 'Goals help you grow and improve'},
        {'icon': '💪', 'text': 'Anyone can set and reach goals!'},
      ],
    },
    {
      'title': 'Types of Goals',
      'emoji': '📊',
      'color': Color(0xFF4ECDC4),
      'types': [
        {'type': 'Daily Goals', 'emoji': '📅', 'example': 'Finish homework today', 'time': 'Today'},
        {'type': 'Weekly Goals', 'emoji': '📆', 'example': 'Read 2 books this week', 'time': '7 days'},
        {'type': 'Monthly Goals', 'emoji': '🗓️', 'example': 'Learn 10 new words', 'time': '30 days'},
        {'type': 'Big Dreams', 'emoji': '⭐', 'example': 'Become a scientist', 'time': 'Future'},
      ],
    },
    {
      'title': 'SMART Goals',
      'emoji': '🧠',
      'color': Color(0xFF45B7D1),
      'smart': [
        {'letter': 'S', 'word': 'Specific', 'meaning': 'Be clear about what you want', 'example': 'I want to read 1 book'},
        {'letter': 'M', 'word': 'Measurable', 'meaning': 'Know how to track it', 'example': 'Read 20 pages each day'},
        {'letter': 'A', 'word': 'Achievable', 'meaning': 'Make it possible', 'example': 'A book I can understand'},
        {'letter': 'R', 'word': 'Relevant', 'meaning': 'It matters to you', 'example': 'A topic I like'},
        {'letter': 'T', 'word': 'Time-bound', 'meaning': 'Set a deadline', 'example': 'Finish in 2 weeks'},
      ],
    },
    {
      'title': 'Setting Your Goals',
      'emoji': '✍️',
      'color': Color(0xFFFFB74D),
      'steps': [
        {'step': 1, 'action': 'Dream big! What do you want?', 'emoji': '💭'},
        {'step': 2, 'action': 'Write your goal down', 'emoji': '📝'},
        {'step': 3, 'action': 'Break it into small steps', 'emoji': '🪜'},
        {'step': 4, 'action': 'Set a deadline', 'emoji': '⏰'},
        {'step': 5, 'action': 'Start working on it!', 'emoji': '🚀'},
        {'step': 6, 'action': 'Track your progress', 'emoji': '📊'},
      ],
    },
    {
      'title': 'Goal Examples',
      'emoji': '📚',
      'color': Color(0xFF9575CD),
      'examples': [
        {'area': 'School', 'goals': ['Get better grades', 'Finish homework on time', 'Learn a new subject']},
        {'area': 'Health', 'goals': ['Eat fruits daily', 'Exercise 30 minutes', 'Sleep on time']},
        {'area': 'Skills', 'goals': ['Learn to draw', 'Play an instrument', 'Learn to swim']},
        {'area': 'Behavior', 'goals': ['Be more patient', 'Help others more', 'Listen better']},
      ],
    },
    {
      'title': 'Staying Motivated',
      'emoji': '💪',
      'color': Color(0xFF66BB6A),
      'tips': [
        {'tip': 'Remember WHY you started', 'emoji': '🧠'},
        {'tip': 'Celebrate small wins', 'emoji': '🎉'},
        {'tip': 'Don\'t give up when it\'s hard', 'emoji': '💪'},
        {'tip': 'Ask for help when needed', 'emoji': '🤝'},
        {'tip': 'Picture yourself achieving it', 'emoji': '🌈'},
        {'tip': 'Reward yourself for progress', 'emoji': '🏆'},
      ],
    },
    {
      'title': 'Goal Tracker',
      'emoji': '📊',
      'color': Color(0xFF26A69A),
      'tracker': [
        {'status': 'Not Started', 'emoji': '⚪', 'color': Colors.grey},
        {'status': 'Just Started', 'emoji': '🔵', 'color': Colors.blue},
        {'status': 'Working On It', 'emoji': '🟡', 'color': Colors.amber},
        {'status': 'Almost There', 'emoji': '🟠', 'color': Colors.orange},
        {'status': 'Done!', 'emoji': '🟢', 'color': Colors.green},
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
          'Goal Setting',
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
        if (section.containsKey('types')) _buildTypeCards(section),
        if (section.containsKey('smart')) _buildSmartCards(section),
        if (section.containsKey('steps')) _buildStepCards(section),
        if (section.containsKey('examples')) _buildExampleCards(section),
        if (section.containsKey('tips')) _buildTipCards(section),
        if (section.containsKey('tracker')) _buildTrackerCards(section),
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

  Widget _buildTypeCards(Map<String, dynamic> section) {
    return Column(
      children: (section['types'] as List).map<Widget>((type) {
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
                  child: Text(type['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['type'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      type['example'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type['time'],
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: section['color'],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSmartCards(Map<String, dynamic> section) {
    return Column(
      children: (section['smart'] as List).map<Widget>((smart) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: section['color'],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    smart['letter'],
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
                      smart['word'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      smart['meaning'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: section['color'].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '💡 ${smart['example']}',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
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

  Widget _buildStepCards(Map<String, dynamic> section) {
    return Column(
      children: (section['steps'] as List).map<Widget>((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: section['color'],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step['step']}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(step['emoji'], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  step['action'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 14,
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
                example['area'],
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
                children: (example['goals'] as List).map<Widget>((goal) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🎯 $goal',
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

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).map<Widget>((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  tip['tip'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrackerCards(Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Track Your Goals!',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: section['color'],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          ...(section['tracker'] as List).map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(item['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item['status'],
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: item['color'],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
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
