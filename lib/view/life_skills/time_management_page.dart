import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeManagementPage extends StatefulWidget {
  const TimeManagementPage({super.key});

  @override
  State<TimeManagementPage> createState() => _TimeManagementPageState();
}

class _TimeManagementPageState extends State<TimeManagementPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Time?',
      'emoji': '⏰',
      'color': Color(0xFF2196F3),
      'intro': 'Time is something we can\'t see, but it\'s always moving forward!',
      'concepts': [
        {'unit': 'Seconds', 'emoji': '⚡', 'example': 'Count: 1, 2, 3...'},
        {'unit': 'Minutes', 'emoji': '⏱️', 'example': '60 seconds = 1 minute'},
        {'unit': 'Hours', 'emoji': '🕐', 'example': '60 minutes = 1 hour'},
        {'unit': 'Days', 'emoji': '📅', 'example': '24 hours = 1 day'},
        {'unit': 'Weeks', 'emoji': '📆', 'example': '7 days = 1 week'},
      ],
      'funFact': 'Time is the only thing we can\'t get back once it\'s gone!',
    },
    {
      'title': 'Reading a Clock',
      'emoji': '🕐',
      'color': Color(0xFF4CAF50),
      'intro': 'Learn to tell time like a pro!',
      'parts': [
        {'part': 'Hour Hand', 'emoji': '👆', 'desc': 'Short hand - shows the hour'},
        {'part': 'Minute Hand', 'emoji': '☝️', 'desc': 'Long hand - shows the minutes'},
        {'part': 'Second Hand', 'emoji': '💨', 'desc': 'Thin hand - counts seconds'},
      ],
      'practice': [
        {'time': '3:00', 'read': 'Three o\'clock'},
        {'time': '6:30', 'read': 'Half past six'},
        {'time': '9:15', 'read': 'Quarter past nine'},
        {'time': '12:45', 'read': 'Quarter to one'},
      ],
      'tip': 'Practice reading clocks every day!',
    },
    {
      'title': 'Daily Routine',
      'emoji': '📋',
      'color': Color(0xFF9C27B0),
      'intro': 'A routine helps you know what to do and when!',
      'morningRoutine': [
        {'time': '7:00 AM', 'task': 'Wake up', 'emoji': '🌅'},
        {'time': '7:15 AM', 'task': 'Brush teeth & wash face', 'emoji': '🪥'},
        {'time': '7:30 AM', 'task': 'Get dressed', 'emoji': '👕'},
        {'time': '7:45 AM', 'task': 'Eat breakfast', 'emoji': '🥣'},
        {'time': '8:00 AM', 'task': 'Leave for school', 'emoji': '🎒'},
      ],
      'eveningRoutine': [
        {'time': '4:00 PM', 'task': 'Snack time', 'emoji': '🍎'},
        {'time': '4:30 PM', 'task': 'Homework', 'emoji': '📚'},
        {'time': '5:30 PM', 'task': 'Free play', 'emoji': '🎮'},
        {'time': '7:00 PM', 'task': 'Dinner', 'emoji': '🍽️'},
        {'time': '8:00 PM', 'task': 'Bath & bedtime routine', 'emoji': '🛁'},
        {'time': '8:30 PM', 'task': 'Sleep', 'emoji': '😴'},
      ],
    },
    {
      'title': 'Planning Ahead',
      'emoji': '📅',
      'color': Color(0xFFFF9800),
      'intro': 'Planning helps you get things done on time!',
      'tools': [
        {'tool': 'Calendar', 'emoji': '📅', 'use': 'Mark important dates'},
        {'tool': 'To-Do List', 'emoji': '📝', 'use': 'Write tasks to complete'},
        {'tool': 'Timer', 'emoji': '⏱️', 'use': 'Track time for tasks'},
        {'tool': 'Reminder', 'emoji': '🔔', 'use': 'Alert for important things'},
      ],
      'steps': [
        {'step': 'Write down what you need to do', 'emoji': '✏️'},
        {'step': 'Decide when to do each task', 'emoji': '⏰'},
        {'step': 'Do the most important things first', 'emoji': '⭐'},
        {'step': 'Check off completed tasks', 'emoji': '✅'},
      ],
    },
    {
      'title': 'Being On Time',
      'emoji': '⏰',
      'color': Color(0xFFE91E63),
      'intro': 'Being punctual shows respect for others!',
      'whyImportant': [
        {'reason': 'Shows you care about others', 'emoji': '💕'},
        {'reason': 'People can trust you', 'emoji': '🤝'},
        {'reason': 'Less stress and rushing', 'emoji': '😌'},
        {'reason': 'You don\'t miss important things', 'emoji': '🎯'},
      ],
      'tips': [
        {'tip': 'Get ready the night before', 'emoji': '🌙'},
        {'tip': 'Set an alarm', 'emoji': '⏰'},
        {'tip': 'Leave extra time', 'emoji': '🚶'},
        {'tip': 'Know how long things take', 'emoji': '⏱️'},
        {'tip': 'Don\'t start new tasks before leaving', 'emoji': '🚫'},
      ],
    },
    {
      'title': 'Avoiding Procrastination',
      'emoji': '🚀',
      'color': Color(0xFF00BCD4),
      'intro': 'Procrastination means putting things off. Let\'s beat it!',
      'whyWeDelay': [
        {'reason': 'Task seems too big', 'emoji': '😰'},
        {'reason': 'Don\'t know how to start', 'emoji': '🤷'},
        {'reason': 'Something else is more fun', 'emoji': '🎮'},
        {'reason': 'Scared of failing', 'emoji': '😟'},
      ],
      'solutions': [
        {'problem': 'Task too big', 'solution': 'Break it into small steps', 'emoji': '🔨'},
        {'problem': 'Don\'t know how', 'solution': 'Ask for help', 'emoji': '🙋'},
        {'problem': 'Distracted', 'solution': 'Remove distractions first', 'emoji': '📵'},
        {'problem': 'No motivation', 'solution': 'Reward yourself after', 'emoji': '🎁'},
      ],
      'rule': 'If it takes 2 minutes, do it now!',
    },
    {
      'title': 'Making Time for Fun',
      'emoji': '🎉',
      'color': Color(0xFF795548),
      'intro': 'Balance is key! Work hard, play hard!',
      'activities': [
        {'activity': 'Play outside', 'emoji': '⚽', 'benefit': 'Exercise & fresh air'},
        {'activity': 'Read for fun', 'emoji': '📖', 'benefit': 'Imagination & learning'},
        {'activity': 'Art & crafts', 'emoji': '🎨', 'benefit': 'Creativity'},
        {'activity': 'Play with friends', 'emoji': '👫', 'benefit': 'Social skills'},
        {'activity': 'Family time', 'emoji': '👨‍👩‍👧', 'benefit': 'Bonding'},
        {'activity': 'Rest & relax', 'emoji': '😌', 'benefit': 'Recharge energy'},
      ],
      'balance': 'Finish your responsibilities first, then enjoy your free time guilt-free!',
    },
    {
      'title': 'Weekly Planner',
      'emoji': '📆',
      'color': Color(0xFF673AB7),
      'intro': 'Plan your week for success!',
      'days': [
        {'day': 'Monday', 'emoji': '🔵', 'focus': 'Start strong'},
        {'day': 'Tuesday', 'emoji': '🟢', 'focus': 'Keep going'},
        {'day': 'Wednesday', 'emoji': '🟡', 'focus': 'Halfway there!'},
        {'day': 'Thursday', 'emoji': '🟠', 'focus': 'Almost weekend'},
        {'day': 'Friday', 'emoji': '🔴', 'focus': 'Finish tasks'},
        {'day': 'Saturday', 'emoji': '🟣', 'focus': 'Fun & hobbies'},
        {'day': 'Sunday', 'emoji': '⚪', 'focus': 'Rest & prepare'},
      ],
      'weeklyTips': [
        'Review last week\'s goals',
        'Set 3 main goals for the week',
        'Plan special activities',
        'Leave time for unexpected things',
        'End the week with reflection',
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
          'Time Management',
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
              const SizedBox(height: 8),
              Text(
                section['intro'],
                style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDynamicContent(section),
      ],
    );
  }

  Widget _buildDynamicContent(Map<String, dynamic> section) {
    switch (section['title']) {
      case 'What is Time?':
        return _buildWhatIsTime(section);
      case 'Reading a Clock':
        return _buildReadingClock(section);
      case 'Daily Routine':
        return _buildDailyRoutine(section);
      case 'Planning Ahead':
        return _buildPlanning(section);
      case 'Being On Time':
        return _buildPunctuality(section);
      case 'Avoiding Procrastination':
        return _buildProcrastination(section);
      case 'Making Time for Fun':
        return _buildFunTime(section);
      case 'Weekly Planner':
        return _buildWeeklyPlanner(section);
      default:
        return const SizedBox();
    }
  }

  Widget _buildWhatIsTime(Map<String, dynamic> section) {
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
              Text('⏰ Time Units:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['concepts'] as List).map((concept) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(concept['emoji'], style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              concept['unit'],
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              concept['example'],
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
              const Text('💡', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['funFact'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadingClock(Map<String, dynamic> section) {
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
              Text('🕐 Clock Parts:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['parts'] as List).map((part) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(part['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(part['part'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(part['desc'], style: GoogleFonts.nunito(fontSize: 11)),
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📖 Practice Reading:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['practice'] as List).map((p) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p['time'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      Text('→', style: const TextStyle(fontSize: 18)),
                      Text(p['read'], style: GoogleFonts.nunito()),
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

  Widget _buildDailyRoutine(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🌅 Morning Routine:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['morningRoutine'] as List).map((item) {
                return _buildRoutineItem(item, section['color']);
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🌙 Evening Routine:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['eveningRoutine'] as List).map((item) {
                return _buildRoutineItem(item, section['color']);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineItem(Map<String, dynamic> item, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item['time'],
              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Text(item['emoji'], style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(child: Text(item['task'], style: GoogleFonts.nunito(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildPlanning(Map<String, dynamic> section) {
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
              Text('🧰 Planning Tools:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: (section['tools'] as List).length,
                itemBuilder: (context, index) {
                  final tool = section['tools'][index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tool['emoji'], style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(tool['tool'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(tool['use'], style: GoogleFonts.nunito(fontSize: 10), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📝 Planning Steps:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['steps'] as List).asMap().entries.map((entry) {
                final step = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
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
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(step['emoji'], style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(step['step'], style: GoogleFonts.nunito(fontSize: 13))),
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

  Widget _buildPunctuality(Map<String, dynamic> section) {
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
              Text('❓ Why Be On Time?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['whyImportant'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item['reason'], style: GoogleFonts.nunito(fontSize: 14))),
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
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💡 Tips to Be On Time:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['tips'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(tip['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(tip['tip'], style: GoogleFonts.nunito(fontSize: 14))),
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

  Widget _buildProcrastination(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('😰 Why We Delay:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['whyWeDelay'] as List).map((reason) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(reason['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(reason['reason'], style: GoogleFonts.nunito(fontSize: 14)),
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✅ Solutions:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['solutions'] as List).map((sol) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(sol['emoji'], style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sol['problem'], style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey)),
                            Text(sol['solution'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
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
              const Text('⚡', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['rule'],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFunTime(Map<String, dynamic> section) {
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
              Text('🎉 Fun Activities:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['activities'] as List).map((activity) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(activity['emoji'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity['activity'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(activity['benefit'], style: GoogleFonts.nunito(fontSize: 11)),
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('⚖️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['balance'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyPlanner(Map<String, dynamic> section) {
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
              Text('📅 Days of the Week:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['days'] as List).map((day) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(day['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(day['day'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                      Text(day['focus'], style: GoogleFonts.nunito(fontSize: 11)),
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
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💡 Weekly Planning Tips:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['weeklyTips'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.purple, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip, style: GoogleFonts.nunito(fontSize: 13))),
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
