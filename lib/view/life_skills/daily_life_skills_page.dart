import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class DailyLifeSkillsPage extends StatefulWidget {
  const DailyLifeSkillsPage({super.key});

  @override
  State<DailyLifeSkillsPage> createState() => _DailyLifeSkillsPageState();
}

class _DailyLifeSkillsPageState extends State<DailyLifeSkillsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Getting Dressed',
      'emoji': '👕',
      'color': Color(0xFF2196F3),
      'intro': 'Dressing yourself is an important skill!',
      'steps': [
        {'step': 'Pick out your clothes the night before', 'emoji': '🌙'},
        {'step': 'Start with underwear', 'emoji': '👙'},
        {'step': 'Put on your shirt', 'emoji': '👕'},
        {'step': 'Put on your pants or skirt', 'emoji': '👖'},
        {'step': 'Put on your socks', 'emoji': '🧦'},
        {'step': 'Put on your shoes', 'emoji': '👟'},
      ],
      'tips': [
        'Check the weather before choosing clothes',
        'Look for labels to find the back',
        'Practice buttons and zippers',
        'Lay clothes out in order',
      ],
    },
    {
      'title': 'Tying Shoelaces',
      'emoji': '👟',
      'color': Color(0xFF4CAF50),
      'intro': 'Learn the bunny ears method!',
      'steps': [
        {'step': 'Cross laces making an X', 'emoji': '❌'},
        {'step': 'Pull one lace under and through', 'emoji': '🔄'},
        {'step': 'Pull both laces tight', 'emoji': '💪'},
        {'step': 'Make two "bunny ears" loops', 'emoji': '🐰'},
        {'step': 'Cross the bunny ears', 'emoji': '❌'},
        {'step': 'Push one ear through the hole', 'emoji': '🕳️'},
        {'step': 'Pull both ears tight', 'emoji': '✨'},
      ],
      'tip':
          'Practice makes perfect! Try on a shoe that\'s not on your foot first.',
    },
    {
      'title': 'Making Your Bed',
      'emoji': '🛏️',
      'color': Color(0xFF9C27B0),
      'intro': 'A made bed makes your room look great!',
      'steps': [
        {'step': 'Pull up the flat sheet', 'emoji': '📄'},
        {'step': 'Pull up the blanket or quilt', 'emoji': '🏔️'},
        {'step': 'Smooth out the wrinkles', 'emoji': '✋'},
        {'step': 'Put pillows at the top', 'emoji': '🛋️'},
        {'step': 'Add any stuffed animals', 'emoji': '🧸'},
      ],
      'benefits': [
        'Room looks neat and tidy',
        'Feels good to accomplish something',
        'More comfortable to sleep in later',
      ],
    },
    {
      'title': 'Setting the Table',
      'emoji': '🍽️',
      'color': Color(0xFFFF9800),
      'intro': 'Help your family at mealtime!',
      'placement': [
        {'item': 'Plate', 'where': 'In the center', 'emoji': '🍽️'},
        {'item': 'Fork', 'where': 'Left of plate', 'emoji': '🍴'},
        {'item': 'Knife', 'where': 'Right of plate (blade in)', 'emoji': '🔪'},
        {'item': 'Spoon', 'where': 'Right of knife', 'emoji': '🥄'},
        {'item': 'Glass', 'where': 'Above the knife', 'emoji': '🥛'},
        {'item': 'Napkin', 'where': 'Under fork or on plate', 'emoji': '🧻'},
      ],
      'tip':
          'Remember: Fork has 4 letters, Left has 4 letters. Fork goes on the Left!',
    },
    {
      'title': 'Packing Your Bag',
      'emoji': '🎒',
      'color': Color(0xFFE91E63),
      'intro': 'Be ready for school or trips!',
      'checklist': [
        {'item': 'Books and notebooks', 'emoji': '📚'},
        {'item': 'Pencil case', 'emoji': '✏️'},
        {'item': 'Homework folder', 'emoji': '📁'},
        {'item': 'Lunch or lunch money', 'emoji': '🍎'},
        {'item': 'Water bottle', 'emoji': '💧'},
        {'item': 'Any special items for today', 'emoji': '📝'},
      ],
      'tips': [
        'Pack your bag the night before',
        'Use the same spots for items',
        'Check your schedule for special items',
        'Empty your bag at the end of each day',
      ],
    },
    {
      'title': 'Keeping Your Room Clean',
      'emoji': '🧹',
      'color': Color(0xFF00BCD4),
      'intro': 'A clean room is a happy room!',
      'dailyTasks': [
        {'task': 'Make your bed', 'emoji': '🛏️'},
        {'task': 'Put dirty clothes in hamper', 'emoji': '👕'},
        {'task': 'Put toys away after playing', 'emoji': '🧸'},
        {'task': 'Put books back on shelf', 'emoji': '📚'},
        {'task': 'Throw trash in the bin', 'emoji': '🗑️'},
      ],
      'weeklyTasks': [
        {'task': 'Dust surfaces', 'emoji': '✨'},
        {'task': 'Organize drawers', 'emoji': '🗄️'},
        {'task': 'Vacuum or sweep floor', 'emoji': '🧹'},
      ],
      'tip': 'The "10-minute pickup" - set a timer and clean until it rings!',
    },
    {
      'title': 'Basic Cooking Skills',
      'emoji': '🍳',
      'color': Color(0xFF795548),
      'intro': 'Learn to help in the kitchen safely!',
      'safetyFirst': [
        {
          'rule': 'Always ask an adult before using the kitchen',
          'emoji': '👨‍👩‍👧',
        },
        {'rule': 'Wash hands before cooking', 'emoji': '🧼'},
        {'rule': 'Be careful with sharp objects', 'emoji': '🔪'},
        {'rule': 'Never touch hot stoves or ovens', 'emoji': '🔥'},
        {'rule': 'Clean up spills right away', 'emoji': '🧽'},
      ],
      'simpleSkills': [
        {'skill': 'Washing fruits and vegetables', 'emoji': '🍎'},
        {'skill': 'Making a sandwich', 'emoji': '🥪'},
        {'skill': 'Pouring drinks', 'emoji': '🥛'},
        {'skill': 'Mixing ingredients', 'emoji': '🥣'},
        {'skill': 'Setting a timer', 'emoji': '⏰'},
      ],
    },
    {
      'title': 'Taking Care of Pets',
      'emoji': '🐕',
      'color': Color(0xFF673AB7),
      'intro': 'Pets depend on us to take care of them!',
      'responsibilities': [
        {'task': 'Feed them at the same time each day', 'emoji': '🍖'},
        {'task': 'Make sure they have fresh water', 'emoji': '💧'},
        {'task': 'Play with them', 'emoji': '🎾'},
        {'task': 'Keep their area clean', 'emoji': '🧹'},
        {'task': 'Give them love and attention', 'emoji': '❤️'},
        {'task': 'Tell adults if they seem sick', 'emoji': '🏥'},
      ],
      'petTypes': [
        {'pet': 'Dogs', 'emoji': '🐕', 'need': 'Walks and exercise'},
        {'pet': 'Cats', 'emoji': '🐈', 'need': 'Playtime and clean litter box'},
        {'pet': 'Fish', 'emoji': '🐟', 'need': 'Clean tank and proper food'},
        {'pet': 'Birds', 'emoji': '🐦', 'need': 'Clean cage and seeds'},
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
          'Daily Life Skills',
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
                  padding: EdgeInsets.all(16.r),
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: index == currentSection ? 20 : 8,
            height: 8.h,
            decoration: BoxDecoration(
              color: index == currentSection
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4.r),
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
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20.r,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(section['emoji'], style: const TextStyle(fontSize: 50)),
              SizedBox(height: 12.h),
              Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                section['intro'],
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        _buildDynamicContent(section),
      ],
    );
  }

  Widget _buildDynamicContent(Map<String, dynamic> section) {
    switch (section['title']) {
      case 'Getting Dressed':
        return _buildStepsWithTips(section);
      case 'Tying Shoelaces':
        return _buildShoelaces(section);
      case 'Making Your Bed':
        return _buildBedMaking(section);
      case 'Setting the Table':
        return _buildTableSetting(section);
      case 'Packing Your Bag':
        return _buildBagPacking(section);
      case 'Keeping Your Room Clean':
        return _buildRoomCleaning(section);
      case 'Basic Cooking Skills':
        return _buildCooking(section);
      case 'Taking Care of Pets':
        return _buildPetCare(section);
      default:
        return const SizedBox();
    }
  }

  Widget _buildStepsWithTips(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📋 Steps:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              ...(section['steps'] as List).asMap().entries.map((entry) {
                final step = entry.value;
                return _buildStep(
                  entry.key + 1,
                  step['step'],
                  step['emoji'],
                  section['color'],
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Tips:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              ...(section['tips'] as List).map((tip) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18.r),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          tip,
                          style: GoogleFonts.nunito(fontSize: 13),
                        ),
                      ),
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

  Widget _buildShoelaces(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: (section['steps'] as List).asMap().entries.map<Widget>((
              entry,
            ) {
              final step = entry.value;
              return _buildStep(
                entry.key + 1,
                step['step'],
                step['emoji'],
                section['color'],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              const Text('🐰', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  section['tip'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBedMaking(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: (section['steps'] as List).asMap().entries.map<Widget>((
              entry,
            ) {
              final step = entry.value;
              return _buildStep(
                entry.key + 1,
                step['step'],
                step['emoji'],
                section['color'],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✨ Benefits:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              ...(section['benefits'] as List).map((benefit) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.purple,
                        size: 18.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(benefit, style: GoogleFonts.nunito(fontSize: 13)),
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

  Widget _buildTableSetting(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: (section['placement'] as List).map<Widget>((item) {
              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Text(item['emoji'], style: const TextStyle(fontSize: 28)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['item'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['where'],
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
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  section['tip'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBagPacking(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📝 Checklist:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              ...(section['checklist'] as List).map((item) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: section['color'], width: 2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 16.r,
                          color: section['color'],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                      SizedBox(width: 8.w),
                      Text(
                        item['item'],
                        style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Tips:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              ...(section['tips'] as List).map((tip) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.pink, size: 18.r),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          tip,
                          style: GoogleFonts.nunito(fontSize: 13),
                        ),
                      ),
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

  Widget _buildRoomCleaning(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📅 Daily Tasks:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ...(section['dailyTasks'] as List).map((task) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Text(task['emoji'], style: const TextStyle(fontSize: 20)),
                      SizedBox(width: 10.w),
                      Text(
                        task['task'],
                        style: GoogleFonts.nunito(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.cyan.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📆 Weekly Tasks:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ...(section['weeklyTasks'] as List).map((task) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Text(task['emoji'], style: const TextStyle(fontSize: 20)),
                      SizedBox(width: 10.w),
                      Text(
                        task['task'],
                        style: GoogleFonts.nunito(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              const Text('⏰', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  section['tip'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCooking(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8.w),
                  Text(
                    'Safety First!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ...(section['safetyFirst'] as List).map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 18)),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          item['rule'],
                          style: GoogleFonts.nunito(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🍳 Skills You Can Learn:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ...(section['simpleSkills'] as List).map((skill) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Text(
                        skill['emoji'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        skill['skill'],
                        style: GoogleFonts.nunito(fontSize: 14),
                      ),
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

  Widget _buildPetCare(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💕 Responsibilities:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ...(section['responsibilities'] as List).map((task) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Text(task['emoji'], style: const TextStyle(fontSize: 20)),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          task['task'],
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🐾 Different Pets Need:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ...(section['petTypes'] as List).map((pet) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Text(pet['emoji'], style: const TextStyle(fontSize: 24)),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet['pet'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              pet['need'],
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
      ],
    );
  }

  Widget _buildStep(int number, String step, String emoji, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(emoji, style: const TextStyle(fontSize: 22)),
          SizedBox(width: 8.w),
          Expanded(child: Text(step, style: GoogleFonts.nunito(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildNavButtons(Map<String, dynamic> section) {
    return Padding(
      padding: EdgeInsets.all(20.r),
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
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            )
          else
            SizedBox(width: 100.w),
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
                  borderRadius: BorderRadius.circular(12.r),
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
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
