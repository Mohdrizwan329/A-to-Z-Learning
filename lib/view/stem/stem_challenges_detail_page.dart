import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class StemChallengesDetailPage extends StatefulWidget {
  final int challengeIndex;

  const StemChallengesDetailPage({super.key, required this.challengeIndex});

  @override
  State<StemChallengesDetailPage> createState() =>
      _StemChallengesDetailPageState();
}

class _StemChallengesDetailPageState extends State<StemChallengesDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> _challenges = [
    {
      'name': 'Egg Drop Challenge',
      'emoji': '🥚',
      'difficulty': 'Medium',
      'time': '30 min',
      'goal': 'Protect an egg from a 2-meter drop!',
      'materials': [
        'Raw egg',
        'Paper',
        'Tape',
        'Straws',
        'Cotton balls',
        'Plastic bag',
      ],
      'rules': [
        'Build a protective case for your egg',
        'Drop it from 2 meters high',
        'If the egg survives, you win!',
      ],
      'tips': [
        'Cushioning absorbs impact',
        'Slow the fall with a parachute',
        'Surround egg completely',
      ],
      'science':
          'You\'re reducing the force of impact by spreading it over time and area!',
    },
    {
      'name': 'Paper Airplane Contest',
      'emoji': '✈️',
      'difficulty': 'Easy',
      'time': '20 min',
      'goal': 'Build a plane that flies the farthest!',
      'materials': ['Paper', 'Ruler', 'Paper clips (optional)'],
      'rules': [
        'Use only one sheet of paper',
        'No cutting or tearing',
        'Throw from the same spot',
      ],
      'tips': [
        'Symmetry is key',
        'Fold edges sharply',
        'Add weight to nose for distance',
      ],
      'science':
          'Aerodynamics - how air flows around objects affects flight!',
    },
    {
      'name': 'Straw Bridge',
      'emoji': '🌉',
      'difficulty': 'Hard',
      'time': '45 min',
      'goal': 'Build a bridge that holds the most weight!',
      'materials': [
        '20 straws',
        'Tape',
        'Scissors',
        'Small weights or coins',
      ],
      'rules': [
        'Bridge must span 30cm gap',
        'Use only given materials',
        'Add weights until it breaks',
      ],
      'tips': [
        'Triangles are strongest',
        'Bundle straws together',
        'Test as you build',
      ],
      'science':
          'Structural engineering - shapes and connections affect strength!',
    },
    {
      'name': 'Marshmallow Tower',
      'emoji': '🗼',
      'difficulty': 'Easy',
      'time': '20 min',
      'goal': 'Build the tallest tower in 18 minutes!',
      'materials': [
        '20 spaghetti sticks',
        '1 meter tape',
        '1 meter string',
        '1 marshmallow',
      ],
      'rules': [
        'Marshmallow must be on top',
        'Tower must stand on its own',
        'Measure from table to marshmallow',
      ],
      'tips': [
        'Start with a wide base',
        'Build in stages',
        'Don\'t wait to put marshmallow on top',
      ],
      'science':
          'Testing designs early (prototyping) helps find problems!',
    },
    {
      'name': 'Boat Float Challenge',
      'emoji': '⛵',
      'difficulty': 'Medium',
      'time': '30 min',
      'goal': 'Build a boat that holds the most coins!',
      'materials': ['Aluminum foil', 'Water tub', 'Coins for testing'],
      'rules': [
        'Use one 15x15cm foil sheet',
        'Boat must float',
        'Add coins until it sinks',
      ],
      'tips': [
        'Flat bottom = more stable',
        'High sides keep water out',
        'Spread weight evenly',
      ],
      'science':
          'Buoyancy - objects float when they displace enough water!',
    },
    {
      'name': 'Catapult Launch',
      'emoji': '🎯',
      'difficulty': 'Medium',
      'time': '40 min',
      'goal': 'Launch an object to hit a target!',
      'materials': [
        'Popsicle sticks',
        'Rubber bands',
        'Plastic spoon',
        'Small balls or pompoms',
      ],
      'rules': [
        'Build a working catapult',
        'Hit targets at different distances',
        'Points for accuracy',
      ],
      'tips': [
        'More rubber bands = more power',
        'Adjust angle for distance',
        'Practice your aim',
      ],
      'science':
          'Stored energy (potential) converts to motion energy (kinetic)!',
    },
    {
      'name': 'Marble Run',
      'emoji': '🔵',
      'difficulty': 'Hard',
      'time': '45 min',
      'goal': 'Create the longest marble run!',
      'materials': [
        'Cardboard tubes',
        'Paper plates',
        'Tape',
        'Scissors',
        'Marbles',
      ],
      'rules': [
        'Marble must complete the run',
        'Use only given materials',
        'Time how long marble takes',
      ],
      'tips': [
        'Gentle slopes keep marble moving',
        'Add curves and loops',
        'Test each section',
      ],
      'science':
          'Gravity pulls the marble down, speed depends on slope angle!',
    },
    {
      'name': 'Wind Powered Car',
      'emoji': '🚗',
      'difficulty': 'Hard',
      'time': '45 min',
      'goal': 'Build a car powered only by wind!',
      'materials': [
        'Cardboard',
        'Straws',
        'Bottle caps',
        'Paper for sail',
        'Tape',
      ],
      'rules': [
        'Car must move using wind only',
        'Use a fan or blow on it',
        'Measure distance traveled',
      ],
      'tips': [
        'Big sail catches more wind',
        'Light body moves easier',
        'Wheels must spin freely',
      ],
      'science':
          'Wind energy converts to motion - this is how sailboats work!',
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0, pulseMax: 1.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = _challenges[widget.challengeIndex];

    return GradientScaffold(
      title: challenge['name'] ?? '',
      emoji: challenge['emoji'] ?? '',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildChallengeContent(challenge),
      ),
    );
  }

  Widget _buildGradientItem({required int index, required Widget child}) {
    final gradient = AppColors.getGradientForIndex(index);
    return buildFloatingItem(
      index: index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeContent(Map<String, dynamic> challenge) {
    final materials = challenge['materials'] as List? ?? [];
    final rules = challenge['rules'] as List? ?? [];
    final tips = challenge['tips'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: [
        // Header
        Text(challenge['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        // Difficulty & Time tags
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                challenge['difficulty'] ?? '',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '⏱️ ${challenge['time'] ?? ''}',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Goal card
        _buildGradientItem(
          index: itemIndex++,
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🎯', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goal',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      challenge['goal'] ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Materials card
        _buildGradientItem(
          index: itemIndex++,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🧪', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Materials',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: materials.map<Widget>((m) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m ?? '',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Rules
        ...List.generate(rules.length, (index) {
          return _buildGradientItem(
            index: itemIndex++,
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rules[index] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // Tips
        ...List.generate(tips.length, (index) {
          return _buildGradientItem(
            index: itemIndex++,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('💡', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tips[index] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // Science card
        _buildGradientItem(
          index: itemIndex,
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🧠', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Science',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      challenge['science'] ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
