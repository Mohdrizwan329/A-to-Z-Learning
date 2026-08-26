import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ExerciseFitnessDetailPage extends StatefulWidget {
  final int sectionIndex;

  const ExerciseFitnessDetailPage({super.key, required this.sectionIndex});

  @override
  State<ExerciseFitnessDetailPage> createState() =>
      _ExerciseFitnessDetailPageState();
}

class _ExerciseFitnessDetailPageState extends State<ExerciseFitnessDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> sections = [
    {
      'title': 'Why Exercise?',
      'emoji': '💪',
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
      'exercises': [
        {
          'name': 'Jumping Jacks',
          'emoji': '⭐',
          'duration': '20 jumps',
          'benefit': 'Full body warm-up',
        },
        {
          'name': 'Running',
          'emoji': '🏃',
          'duration': '5 minutes',
          'benefit': 'Strong legs & heart',
        },
        {
          'name': 'Stretching',
          'emoji': '🧘',
          'duration': '5 minutes',
          'benefit': 'Flexibility',
        },
        {
          'name': 'Skipping Rope',
          'emoji': '🪢',
          'duration': '50 jumps',
          'benefit': 'Coordination',
        },
        {
          'name': 'Dancing',
          'emoji': '💃',
          'duration': '10 minutes',
          'benefit': 'Fun cardio',
        },
        {
          'name': 'Cycling',
          'emoji': '🚴',
          'duration': '15 minutes',
          'benefit': 'Leg strength',
        },
      ],
    },
    {
      'title': 'Sports to Play',
      'emoji': '⚽',
      'sports': [
        {
          'name': 'Football',
          'emoji': '⚽',
          'players': 'Team',
          'benefit': 'Running & teamwork',
        },
        {
          'name': 'Cricket',
          'emoji': '🏏',
          'players': 'Team',
          'benefit': 'Hand-eye coordination',
        },
        {
          'name': 'Badminton',
          'emoji': '🏸',
          'players': '2 players',
          'benefit': 'Quick reflexes',
        },
        {
          'name': 'Swimming',
          'emoji': '🏊',
          'players': 'Solo',
          'benefit': 'Full body exercise',
        },
        {
          'name': 'Basketball',
          'emoji': '🏀',
          'players': 'Team',
          'benefit': 'Jumping & running',
        },
        {
          'name': 'Yoga',
          'emoji': '🧘',
          'players': 'Solo',
          'benefit': 'Flexibility & calm',
        },
      ],
    },
    {
      'title': 'Morning Routine',
      'emoji': '🌅',
      'routine': [
        {
          'step': 1,
          'activity': 'Wake up and stretch in bed',
          'emoji': '🛏️',
          'time': '2 min',
        },
        {
          'step': 2,
          'activity': 'Drink a glass of water',
          'emoji': '💧',
          'time': '1 min',
        },
        {
          'step': 3,
          'activity': 'Do jumping jacks',
          'emoji': '⭐',
          'time': '2 min',
        },
        {
          'step': 4,
          'activity': 'Touch your toes',
          'emoji': '🦶',
          'time': '1 min',
        },
        {'step': 5, 'activity': 'Run in place', 'emoji': '🏃', 'time': '2 min'},
        {
          'step': 6,
          'activity': 'Take deep breaths',
          'emoji': '🌬️',
          'time': '1 min',
        },
      ],
    },
    {
      'title': 'Indoor Activities',
      'emoji': '🏠',
      'activities': [
        {'name': 'Dance to music', 'emoji': '🎶', 'info': 'Living room'},
        {'name': 'Yoga poses', 'emoji': '🧘', 'info': 'Any room'},
        {'name': 'Pillow fights', 'emoji': '🛋️', 'info': 'Bedroom'},
        {'name': 'Hide and seek', 'emoji': '🙈', 'info': 'Whole house'},
        {'name': 'Balloon games', 'emoji': '🎈', 'info': 'Living room'},
        {'name': 'Cleaning race', 'emoji': '🧹', 'info': 'Any room'},
      ],
    },
    {
      'title': 'Outdoor Activities',
      'emoji': '🌳',
      'activities': [
        {'name': 'Play in the park', 'emoji': '🏞️', 'info': 'Fresh air & fun'},
        {'name': 'Fly a kite', 'emoji': '🪁', 'info': 'Running & coordination'},
        {'name': 'Play catch', 'emoji': '🥎', 'info': 'Hand-eye skills'},
        {
          'name': 'Climb trees (safely!)',
          'emoji': '🌳',
          'info': 'Arm strength',
        },
        {'name': 'Hopscotch', 'emoji': '🔢', 'info': 'Balance & jumping'},
        {'name': 'Nature walk', 'emoji': '🚶', 'info': 'Exploring & walking'},
      ],
    },
    {
      'title': 'Stay Safe!',
      'emoji': '⚠️',
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
      'goals': [
        {
          'goal': 'Play for 60 minutes every day',
          'emoji': '⏱️',
          'reward': '🌟',
        },
        {'goal': 'Try a new sport each month', 'emoji': '🆕', 'reward': '🏆'},
        {'goal': 'Do 10 jumping jacks daily', 'emoji': '⭐', 'reward': '💪'},
        {
          'goal': 'Go for a family walk weekly',
          'emoji': '👨‍👩‍👧',
          'reward': '❤️',
        },
        {'goal': 'Stretch every morning', 'emoji': '🧘', 'reward': '🌈'},
        {
          'goal': 'Less screen time, more play time',
          'emoji': '📵',
          'reward': '🎮➡️🏃',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
    TtsService.to.speak(sections[widget.sectionIndex]['title']);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = sections[widget.sectionIndex];
    final gradient = AppColors.getGradientForIndex(widget.sectionIndex);

    return GradientScaffold(
      title: section['title'],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Main Card
            buildFloatingItem(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      section['emoji'],
                      style: const TextStyle(fontSize: 70),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      section['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Content based on type
            if (section.containsKey('benefits')) _buildBenefitCards(section),
            if (section.containsKey('exercises')) _buildExerciseCards(section),
            if (section.containsKey('sports')) _buildSportsCards(section),
            if (section.containsKey('routine')) _buildRoutineCards(section),
            if (section.containsKey('activities')) _buildActivityCards(section),
            if (section.containsKey('safetyTips')) _buildSafetyCards(section),
            if (section.containsKey('goals')) _buildGoalCards(section),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCards(Map<String, dynamic> section) {
    return Column(
      children: (section['benefits'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final benefit = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(benefit['icon'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    benefit['text'],
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExerciseCards(Map<String, dynamic> section) {
    return Column(
      children: (section['exercises'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final exercise = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(exercise['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        exercise['benefit'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    exercise['duration'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSportsCards(Map<String, dynamic> section) {
    return Column(
      children: (section['sports'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final sport = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(sport['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        sport['benefit'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    sport['players'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRoutineCards(Map<String, dynamic> section) {
    return Column(
      children: (section['routine'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final step = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${step['step']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(step['emoji'], style: const TextStyle(fontSize: 24)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    step['activity'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    step['time'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityCards(Map<String, dynamic> section) {
    return Column(
      children: (section['activities'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final activity = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(activity['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        activity['info'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSafetyCards(Map<String, dynamic> section) {
    return Column(
      children: (section['safetyTips'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final tip = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    tip['tip'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoalCards(Map<String, dynamic> section) {
    return Column(
      children: (section['goals'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final goal = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(goal['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    goal['goal'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(goal['reward'], style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
