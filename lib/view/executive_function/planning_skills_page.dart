import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanningSkillsPage extends StatefulWidget {
  const PlanningSkillsPage({super.key});

  @override
  State<PlanningSkillsPage> createState() => _PlanningSkillsPageState();
}

class _PlanningSkillsPageState extends State<PlanningSkillsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Planning?',
      'emoji': '📋',
      'color': Color(0xFF5C6BC0),
      'content': [
        {'icon': '🤔', 'text': 'Planning means thinking before you do something'},
        {'icon': '📝', 'text': 'It helps you decide what to do first, second, third...'},
        {'icon': '🎯', 'text': 'Good planning helps you finish tasks easily'},
        {'icon': '⭐', 'text': 'Everyone can learn to plan better!'},
      ],
    },
    {
      'title': 'Plan Your Morning',
      'emoji': '🌅',
      'color': Color(0xFFFF7043),
      'steps': [
        {'step': 1, 'task': 'Wake up when alarm rings', 'emoji': '⏰'},
        {'step': 2, 'task': 'Brush your teeth', 'emoji': '🪥'},
        {'step': 3, 'task': 'Take a bath', 'emoji': '🚿'},
        {'step': 4, 'task': 'Get dressed', 'emoji': '👕'},
        {'step': 5, 'task': 'Eat breakfast', 'emoji': '🥣'},
        {'step': 6, 'task': 'Pack your bag', 'emoji': '🎒'},
        {'step': 7, 'task': 'Go to school', 'emoji': '🏫'},
      ],
    },
    {
      'title': 'Plan Your Homework',
      'emoji': '📚',
      'color': Color(0xFF42A5F5),
      'steps': [
        {'step': 1, 'task': 'Find a quiet place', 'emoji': '🤫'},
        {'step': 2, 'task': 'Gather all materials', 'emoji': '✏️'},
        {'step': 3, 'task': 'List all homework tasks', 'emoji': '📋'},
        {'step': 4, 'task': 'Do the hardest one first', 'emoji': '💪'},
        {'step': 5, 'task': 'Take short breaks', 'emoji': '☕'},
        {'step': 6, 'task': 'Check your work', 'emoji': '✅'},
        {'step': 7, 'task': 'Put homework in bag', 'emoji': '🎒'},
      ],
    },
    {
      'title': 'Plan a Party!',
      'emoji': '🎉',
      'color': Color(0xFFEC407A),
      'planning': [
        {'what': 'When?', 'emoji': '📅', 'think': 'Pick a day and time'},
        {'what': 'Where?', 'emoji': '🏠', 'think': 'At home or a park?'},
        {'what': 'Who?', 'emoji': '👫', 'think': 'Make a guest list'},
        {'what': 'Food?', 'emoji': '🍰', 'think': 'Cake, snacks, drinks'},
        {'what': 'Games?', 'emoji': '🎮', 'think': 'Musical chairs, pass the parcel'},
        {'what': 'Decorations?', 'emoji': '🎈', 'think': 'Balloons, banners'},
      ],
    },
    {
      'title': 'Think First!',
      'emoji': '🧠',
      'color': Color(0xFF66BB6A),
      'questions': [
        {'q': 'What do I need to do?', 'emoji': '❓'},
        {'q': 'What do I need to use?', 'emoji': '🔧'},
        {'q': 'How long will it take?', 'emoji': '⏱️'},
        {'q': 'What should I do first?', 'emoji': '1️⃣'},
        {'q': 'What might go wrong?', 'emoji': '⚠️'},
        {'q': 'How can I fix problems?', 'emoji': '🔧'},
      ],
    },
    {
      'title': 'Planning Tools',
      'emoji': '🛠️',
      'color': Color(0xFFFFB74D),
      'tools': [
        {'name': 'To-Do List', 'emoji': '📝', 'use': 'Write down all tasks'},
        {'name': 'Calendar', 'emoji': '📅', 'use': 'Mark important days'},
        {'name': 'Checklist', 'emoji': '✅', 'use': 'Tick off completed tasks'},
        {'name': 'Timer', 'emoji': '⏰', 'use': 'Set time for each task'},
        {'name': 'Chart', 'emoji': '📊', 'use': 'Track your progress'},
      ],
    },
    {
      'title': 'Practice Planning',
      'emoji': '🎯',
      'color': Color(0xFF26A69A),
      'activities': [
        {'activity': 'Plan tomorrow\'s clothes tonight', 'emoji': '👗'},
        {'activity': 'Make a weekend activity plan', 'emoji': '📋'},
        {'activity': 'Plan what to pack for a trip', 'emoji': '🧳'},
        {'activity': 'Plan steps to build a LEGO set', 'emoji': '🧱'},
        {'activity': 'Plan a drawing before starting', 'emoji': '🎨'},
        {'activity': 'Plan your playtime activities', 'emoji': '⚽'},
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
          'Planning Skills',
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
        if (section.containsKey('steps')) _buildStepCards(section),
        if (section.containsKey('planning')) _buildPlanningCards(section),
        if (section.containsKey('questions')) _buildQuestionCards(section),
        if (section.containsKey('tools')) _buildToolCards(section),
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
              Text(step['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step['task'],
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

  Widget _buildPlanningCards(Map<String, dynamic> section) {
    return Column(
      children: (section['planning'] as List).map<Widget>((plan) {
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
                  child: Text(plan['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan['what'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      plan['think'],
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

  Widget _buildQuestionCards(Map<String, dynamic> section) {
    return Column(
      children: (section['questions'] as List).asMap().entries.map<Widget>((entry) {
        final q = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(q['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  q['q'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: section['color'],
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

  Widget _buildToolCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tools'] as List).map<Widget>((tool) {
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
                  child: Text(tool['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      tool['use'],
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
              Icon(Icons.arrow_forward_ios, size: 16, color: section['color']),
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
