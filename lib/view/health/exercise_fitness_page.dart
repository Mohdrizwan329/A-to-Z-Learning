import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseFitnessPage extends StatefulWidget {
  const ExerciseFitnessPage({super.key});

  @override
  State<ExerciseFitnessPage> createState() => _ExerciseFitnessPageState();
}

class _ExerciseFitnessPageState extends State<ExerciseFitnessPage> with SingleTickerProviderStateMixin {
  int currentSection = 0;
  late AnimationController _bounceController;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Why Exercise?',
      'emoji': '💪',
      'color': Color(0xFFFF7043),
      'benefits': [
        {'icon': '💪', 'text': 'Makes muscles strong'},
        {'icon': '🦴', 'text': 'Keeps bones healthy'},
        {'icon': '❤️', 'text': 'Makes heart strong'},
        {'icon': '🧠', 'text': 'Helps brain think better'},
        {'icon': '😊', 'text': 'Makes you happy'},
        {'icon': '😴', 'text': 'Helps you sleep well'},
        {'icon': '🛡️', 'text': 'Keeps sickness away'},
      ],
    },
    {
      'title': 'Fun Exercises',
      'emoji': '🤸',
      'color': Color(0xFF42A5F5),
      'exercises': [
        {'name': 'Jumping Jacks', 'emoji': '⭐', 'duration': '20 jumps', 'benefit': 'Full body warm-up'},
        {'name': 'Running', 'emoji': '🏃', 'duration': '5 minutes', 'benefit': 'Strong legs & heart'},
        {'name': 'Stretching', 'emoji': '🧘', 'duration': '5 minutes', 'benefit': 'Flexibility'},
        {'name': 'Skipping Rope', 'emoji': '🪢', 'duration': '50 jumps', 'benefit': 'Coordination'},
        {'name': 'Dancing', 'emoji': '💃', 'duration': '10 minutes', 'benefit': 'Fun cardio'},
        {'name': 'Cycling', 'emoji': '🚴', 'duration': '15 minutes', 'benefit': 'Leg strength'},
      ],
    },
    {
      'title': 'Sports to Play',
      'emoji': '⚽',
      'color': Color(0xFF66BB6A),
      'sports': [
        {'name': 'Football', 'emoji': '⚽', 'players': 'Team', 'benefit': 'Running & teamwork'},
        {'name': 'Cricket', 'emoji': '🏏', 'players': 'Team', 'benefit': 'Hand-eye coordination'},
        {'name': 'Badminton', 'emoji': '🏸', 'players': '2 players', 'benefit': 'Quick reflexes'},
        {'name': 'Swimming', 'emoji': '🏊', 'players': 'Solo', 'benefit': 'Full body exercise'},
        {'name': 'Basketball', 'emoji': '🏀', 'players': 'Team', 'benefit': 'Jumping & running'},
        {'name': 'Yoga', 'emoji': '🧘', 'players': 'Solo', 'benefit': 'Flexibility & calm'},
      ],
    },
    {
      'title': 'Morning Routine',
      'emoji': '🌅',
      'color': Color(0xFFFFB74D),
      'routine': [
        {'step': 1, 'activity': 'Wake up and stretch in bed', 'emoji': '🛏️', 'time': '2 min'},
        {'step': 2, 'activity': 'Drink a glass of water', 'emoji': '💧', 'time': '1 min'},
        {'step': 3, 'activity': 'Do jumping jacks', 'emoji': '⭐', 'time': '2 min'},
        {'step': 4, 'activity': 'Touch your toes', 'emoji': '🦶', 'time': '1 min'},
        {'step': 5, 'activity': 'Run in place', 'emoji': '🏃', 'time': '2 min'},
        {'step': 6, 'activity': 'Take deep breaths', 'emoji': '🌬️', 'time': '1 min'},
      ],
    },
    {
      'title': 'Indoor Activities',
      'emoji': '🏠',
      'color': Color(0xFFAB47BC),
      'activities': [
        {'name': 'Dance to music', 'emoji': '🎶', 'space': 'Living room'},
        {'name': 'Yoga poses', 'emoji': '🧘', 'space': 'Any room'},
        {'name': 'Pillow fights', 'emoji': '🛋️', 'space': 'Bedroom'},
        {'name': 'Hide and seek', 'emoji': '🙈', 'space': 'Whole house'},
        {'name': 'Balloon games', 'emoji': '🎈', 'space': 'Living room'},
        {'name': 'Cleaning race', 'emoji': '🧹', 'space': 'Any room'},
      ],
    },
    {
      'title': 'Outdoor Activities',
      'emoji': '🌳',
      'color': Color(0xFF26A69A),
      'activities': [
        {'name': 'Play in the park', 'emoji': '🏞️', 'benefit': 'Fresh air & fun'},
        {'name': 'Fly a kite', 'emoji': '🪁', 'benefit': 'Running & coordination'},
        {'name': 'Play catch', 'emoji': '🥎', 'benefit': 'Hand-eye skills'},
        {'name': 'Climb trees (safely!)', 'emoji': '🌳', 'benefit': 'Arm strength'},
        {'name': 'Hopscotch', 'emoji': '🔢', 'benefit': 'Balance & jumping'},
        {'name': 'Nature walk', 'emoji': '🚶', 'benefit': 'Exploring & walking'},
      ],
    },
    {
      'title': 'Stay Safe!',
      'emoji': '⚠️',
      'color': Color(0xFFEF5350),
      'safetyTips': [
        {'tip': 'Always warm up before exercise', 'emoji': '🔥'},
        {'tip': 'Drink water during and after', 'emoji': '💧'},
        {'tip': 'Wear comfortable clothes', 'emoji': '👕'},
        {'tip': 'Use safety gear for sports', 'emoji': '🪖'},
        {'tip': 'Stop if you feel pain', 'emoji': '🛑'},
        {'tip': 'Rest when you\'re tired', 'emoji': '😴'},
        {'tip': 'Play in safe places', 'emoji': '🏟️'},
        {'tip': 'Tell adults if you get hurt', 'emoji': '🗣️'},
      ],
    },
    {
      'title': 'Exercise Goals',
      'emoji': '🎯',
      'color': Color(0xFF7986CB),
      'goals': [
        {'goal': 'Play for 60 minutes every day', 'emoji': '⏱️', 'reward': '🌟'},
        {'goal': 'Try a new sport each month', 'emoji': '🆕', 'reward': '🏆'},
        {'goal': 'Do 10 jumping jacks daily', 'emoji': '⭐', 'reward': '💪'},
        {'goal': 'Go for a family walk weekly', 'emoji': '👨‍👩‍👧', 'reward': '❤️'},
        {'goal': 'Stretch every morning', 'emoji': '🧘', 'reward': '🌈'},
        {'goal': 'Less screen time, more play time', 'emoji': '📵', 'reward': '🎮➡️🏃'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

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
          'Exercise & Fitness',
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
        if (section.containsKey('benefits')) _buildBenefitCards(section),
        if (section.containsKey('exercises')) _buildExerciseCards(section),
        if (section.containsKey('sports')) _buildSportsCards(section),
        if (section.containsKey('routine')) _buildRoutineCards(section),
        if (section.containsKey('activities')) _buildActivityCards(section),
        if (section.containsKey('safetyTips')) _buildSafetyCards(section),
        if (section.containsKey('goals')) _buildGoalCards(section),
      ],
    );
  }

  Widget _buildBenefitCards(Map<String, dynamic> section) {
    return Column(
      children: (section['benefits'] as List).map<Widget>((benefit) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(benefit['icon'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  benefit['text'],
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

  Widget _buildExerciseCards(Map<String, dynamic> section) {
    return Column(
      children: (section['exercises'] as List).map<Widget>((exercise) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(exercise['emoji'], style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      exercise['benefit'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  exercise['duration'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
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

  Widget _buildSportsCards(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: (section['sports'] as List).length,
      itemBuilder: (context, index) {
        final sport = section['sports'][index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(sport['emoji'], style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                sport['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 14,
                ),
              ),
              Text(
                sport['players'],
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sport['benefit'],
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoutineCards(Map<String, dynamic> section) {
    return Column(
      children: (section['routine'] as List).map<Widget>((step) {
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
                  step['activity'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Text(
                step['time'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
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
        final extraInfo = activity['space'] ?? activity['benefit'] ?? '';
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
                  child: Text(activity['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      extraInfo,
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

  Widget _buildSafetyCards(Map<String, dynamic> section) {
    return Column(
      children: (section['safetyTips'] as List).map<Widget>((tip) {
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Text(tip['emoji'], style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  tip['tip'],
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

  Widget _buildGoalCards(Map<String, dynamic> section) {
    return Column(
      children: (section['goals'] as List).map<Widget>((goal) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(goal['emoji'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  goal['goal'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(goal['reward'], style: const TextStyle(fontSize: 24)),
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
