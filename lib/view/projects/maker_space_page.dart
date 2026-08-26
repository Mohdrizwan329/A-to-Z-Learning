import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class MakerSpacePage extends StatefulWidget {
  const MakerSpacePage({super.key});

  @override
  State<MakerSpacePage> createState() => _MakerSpacePageState();
}

class _MakerSpacePageState extends State<MakerSpacePage> {
  String? selectedChallenge;

  final List<Map<String, dynamic>> challenges = [
    {
      'name': 'Build a Tower',
      'emoji': '🏗️',
      'color': Color(0xFF6366F1),
      'difficulty': 'Easy',
      'time': '15 mins',
      'goal': 'Build the tallest tower you can!',
      'materials': [
        {'name': 'Paper cups', 'emoji': '🥤'},
        {'name': 'Playing cards', 'emoji': '🃏'},
        {'name': 'Blocks', 'emoji': '🧱'},
        {'name': 'Books', 'emoji': '📚'},
      ],
      'tips': ['Start with a wide base', 'Stack carefully', 'Balance is key!'],
      'questions': [
        'How tall can you make it?',
        'What shape is strongest?',
        'Why did it fall?',
      ],
    },
    {
      'name': 'Bridge Builder',
      'emoji': '🌉',
      'color': Color(0xFFEC4899),
      'difficulty': 'Medium',
      'time': '30 mins',
      'goal': 'Build a bridge that can hold a toy car!',
      'materials': [
        {'name': 'Popsicle sticks', 'emoji': '🪵'},
        {'name': 'Tape', 'emoji': '🩹'},
        {'name': 'Paper', 'emoji': '📄'},
        {'name': 'Cardboard', 'emoji': '📦'},
      ],
      'tips': [
        'Triangles are strong shapes',
        'Connect pieces firmly',
        'Test with small weights first',
      ],
      'questions': [
        'How much weight can it hold?',
        'Which design is strongest?',
        'What would make it better?',
      ],
    },
    {
      'name': 'Marble Run',
      'emoji': '🔵',
      'color': Color(0xFF10B981),
      'difficulty': 'Medium',
      'time': '45 mins',
      'goal': 'Create a track for a marble to roll down!',
      'materials': [
        {'name': 'Cardboard tubes', 'emoji': '🧻'},
        {'name': 'Tape', 'emoji': '🩹'},
        {'name': 'Scissors', 'emoji': '✂️'},
        {'name': 'Box or wall', 'emoji': '📦'},
      ],
      'tips': [
        'Start high, end low',
        'Make gentle slopes',
        'Add curves for fun!',
      ],
      'questions': [
        'How long is your track?',
        'How fast does the marble go?',
        'Can you make it jump?',
      ],
    },
    {
      'name': 'Boat That Floats',
      'emoji': '⛵',
      'color': Color(0xFF3B82F6),
      'difficulty': 'Easy',
      'time': '20 mins',
      'goal': 'Build a boat that floats and carries coins!',
      'materials': [
        {'name': 'Aluminum foil', 'emoji': '🪞'},
        {'name': 'Plastic bottles', 'emoji': '🧴'},
        {'name': 'Styrofoam', 'emoji': '📦'},
        {'name': 'Straws', 'emoji': '🥤'},
      ],
      'tips': [
        'Air helps things float',
        'Wide and flat is good',
        'Keep water out!',
      ],
      'questions': [
        'How many coins can it hold?',
        'Why do some shapes float better?',
        'What makes boats sink?',
      ],
    },
    {
      'name': 'Egg Drop Challenge',
      'emoji': '🥚',
      'color': Color(0xFFF59E0B),
      'difficulty': 'Hard',
      'time': '45 mins',
      'goal': 'Protect an egg from breaking when dropped!',
      'materials': [
        {'name': 'Cotton balls', 'emoji': '☁️'},
        {'name': 'Bubble wrap', 'emoji': '🫧'},
        {'name': 'Paper', 'emoji': '📄'},
        {'name': 'Straws', 'emoji': '🥤'},
        {'name': 'Tape', 'emoji': '🩹'},
      ],
      'tips': [
        'Cushion all sides',
        'Slow the fall down',
        'Test from low heights first',
      ],
      'questions': [
        'What materials absorb impact?',
        'How high can you drop it?',
        'Why did it survive (or not)?',
      ],
    },
    {
      'name': 'Catapult Creator',
      'emoji': '🏹',
      'color': Color(0xFF8B5CF6),
      'difficulty': 'Medium',
      'time': '30 mins',
      'goal': 'Build a catapult to launch a cotton ball!',
      'materials': [
        {'name': 'Popsicle sticks', 'emoji': '🪵'},
        {'name': 'Rubber bands', 'emoji': '🔗'},
        {'name': 'Plastic spoon', 'emoji': '🥄'},
        {'name': 'Tape', 'emoji': '🩹'},
      ],
      'tips': [
        'Rubber bands store energy',
        'Longer arm = further launch',
        'Aim carefully!',
      ],
      'questions': [
        'How far can you launch?',
        'What angle works best?',
        'How does it store energy?',
      ],
    },
    {
      'name': 'Parachute Drop',
      'emoji': '🪂',
      'color': Color(0xFFEF4444),
      'difficulty': 'Easy',
      'time': '15 mins',
      'goal': 'Make a parachute that falls slowly!',
      'materials': [
        {'name': 'Plastic bag', 'emoji': '🛍️'},
        {'name': 'String', 'emoji': '🧵'},
        {'name': 'Small toy', 'emoji': '🧸'},
        {'name': 'Scissors', 'emoji': '✂️'},
      ],
      'tips': [
        'Bigger is often better',
        'Equal length strings',
        'No holes in canopy!',
      ],
      'questions': [
        'How slow does it fall?',
        'What size works best?',
        'How does air help?',
      ],
    },
    {
      'name': 'Wind Spinner',
      'emoji': '🌀',
      'color': Color(0xFF06B6D4),
      'difficulty': 'Easy',
      'time': '20 mins',
      'goal': 'Create something that spins in the wind!',
      'materials': [
        {'name': 'Paper plate', 'emoji': '🍽️'},
        {'name': 'Pencil', 'emoji': '✏️'},
        {'name': 'Scissors', 'emoji': '✂️'},
        {'name': 'String', 'emoji': '🧵'},
      ],
      'tips': [
        'Curves catch wind',
        'Balance is important',
        'Test in different winds',
      ],
      'questions': [
        'What makes it spin faster?',
        'Does size matter?',
        'How does wind create motion?',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Maker Space',
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
              Expanded(
                child: selectedChallenge == null
                    ? _buildChallengesList()
                    : _buildChallengeDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengesList() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          // Intro Banner
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                const Text('🚀', style: TextStyle(fontSize: 40)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Design • Build • Test!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Choose a challenge and create something amazing',
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Challenges List
          ...challenges.map((challenge) => _buildChallengeCard(challenge)),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(Map<String, dynamic> challenge) {
    Color difficultyColor;
    switch (challenge['difficulty']) {
      case 'Easy':
        difficultyColor = Colors.green;
        break;
      case 'Medium':
        difficultyColor = Colors.orange;
        break;
      default:
        difficultyColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        TtsService.to.speak(challenge['name']);
        setState(() {
          selectedChallenge = challenge['name'];
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              challenge['color'],
              challenge['color'].withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: challenge['color'].withValues(alpha: 0.4),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  challenge['emoji'],
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    challenge['goal'],
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Two tags together are wider than the card on a small
                  // phone, so each is allowed to shrink.
                  Row(
                    children: [
                      Flexible(
                        child: _buildTag(
                          challenge['difficulty'],
                          difficultyColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: _buildTag(
                          '⏱️ ${challenge['time']}',
                          Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.r),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildChallengeDetail() {
    final challenge = challenges.firstWhere(
      (c) => c['name'] == selectedChallenge,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          // Header Card
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: challenge['color'].withValues(alpha: 0.4),
                  blurRadius: 20.r,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(challenge['emoji'], style: const TextStyle(fontSize: 70)),
                SizedBox(height: 12.h),
                Text(
                  challenge['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: challenge['color'],
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: challenge['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          challenge['goal'],
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: challenge['color'],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Materials
          _buildMaterialsSection(challenge),
          // Tips
          _buildListSection(
            '💡',
            'Tips for Success',
            challenge['tips'],
            challenge['color'],
          ),
          // Think About
          _buildListSection(
            '🤔',
            'Think About...',
            challenge['questions'],
            challenge['color'],
          ),
          SizedBox(height: 20.h),
          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  '🛠️ Let\'s Build!',
                  'Gather materials and start your ${challenge['name']}!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: challenge['color'],
                  colorText: Colors.white,
                  margin: EdgeInsets.all(16.r),
                  borderRadius: 12.r,
                );
              },
              icon: const Text('🚀', style: TextStyle(fontSize: 20)),
              label: Text(
                'Start Challenge!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: challenge['color'],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsSection(Map<String, dynamic> challenge) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🧰', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8.w),
              Text(
                'Materials (pick any!)',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: challenge['color'],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            children: (challenge['materials'] as List).map<Widget>((material) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: challenge['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      material['emoji'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      material['name'],
                      style: GoogleFonts.nunito(
                        color: challenge['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(
    String emoji,
    String title,
    List<dynamic> items,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...items.map<Widget>((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: color, size: 20.r),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade700,
                        fontSize: 14,
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
  }
}
