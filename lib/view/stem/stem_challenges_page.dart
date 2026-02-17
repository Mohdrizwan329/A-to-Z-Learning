import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StemChallengesPage extends StatefulWidget {
  const StemChallengesPage({super.key});

  @override
  State<StemChallengesPage> createState() => _StemChallengesPageState();
}

class _StemChallengesPageState extends State<StemChallengesPage> {
  int selectedChallenge = -1;

  final List<Map<String, dynamic>> challenges = [
    {
      'name': 'Egg Drop Challenge',
      'emoji': '🥚',
      'color': Color(0xFFFFB74D),
      'difficulty': 'Medium',
      'time': '30 min',
      'goal': 'Protect an egg from a 2-meter drop!',
      'materials': ['Raw egg', 'Paper', 'Tape', 'Straws', 'Cotton balls', 'Plastic bag'],
      'rules': [
        'Build a protective case for your egg',
        'Drop it from 2 meters high',
        'If the egg survives, you win!',
      ],
      'tips': ['Cushioning absorbs impact', 'Slow the fall with a parachute', 'Surround egg completely'],
      'science': 'You\'re reducing the force of impact by spreading it over time and area!',
    },
    {
      'name': 'Paper Airplane Contest',
      'emoji': '✈️',
      'color': Color(0xFF42A5F5),
      'difficulty': 'Easy',
      'time': '20 min',
      'goal': 'Build a plane that flies the farthest!',
      'materials': ['Paper', 'Ruler', 'Paper clips (optional)'],
      'rules': [
        'Use only one sheet of paper',
        'No cutting or tearing',
        'Throw from the same spot',
      ],
      'tips': ['Symmetry is key', 'Fold edges sharply', 'Add weight to nose for distance'],
      'science': 'Aerodynamics - how air flows around objects affects flight!',
    },
    {
      'name': 'Straw Bridge',
      'emoji': '🌉',
      'color': Color(0xFF66BB6A),
      'difficulty': 'Hard',
      'time': '45 min',
      'goal': 'Build a bridge that holds the most weight!',
      'materials': ['20 straws', 'Tape', 'Scissors', 'Small weights or coins'],
      'rules': [
        'Bridge must span 30cm gap',
        'Use only given materials',
        'Add weights until it breaks',
      ],
      'tips': ['Triangles are strongest', 'Bundle straws together', 'Test as you build'],
      'science': 'Structural engineering - shapes and connections affect strength!',
    },
    {
      'name': 'Marshmallow Tower',
      'emoji': '🗼',
      'color': Color(0xFF9C27B0),
      'difficulty': 'Easy',
      'time': '20 min',
      'goal': 'Build the tallest tower in 18 minutes!',
      'materials': ['20 spaghetti sticks', '1 meter tape', '1 meter string', '1 marshmallow'],
      'rules': [
        'Marshmallow must be on top',
        'Tower must stand on its own',
        'Measure from table to marshmallow',
      ],
      'tips': ['Start with a wide base', 'Build in stages', 'Don\'t wait to put marshmallow on top'],
      'science': 'Testing designs early (prototyping) helps find problems!',
    },
    {
      'name': 'Boat Float Challenge',
      'emoji': '⛵',
      'color': Color(0xFF00BCD4),
      'difficulty': 'Medium',
      'time': '30 min',
      'goal': 'Build a boat that holds the most coins!',
      'materials': ['Aluminum foil', 'Water tub', 'Coins for testing'],
      'rules': [
        'Use one 15x15cm foil sheet',
        'Boat must float',
        'Add coins until it sinks',
      ],
      'tips': ['Flat bottom = more stable', 'High sides keep water out', 'Spread weight evenly'],
      'science': 'Buoyancy - objects float when they displace enough water!',
    },
    {
      'name': 'Catapult Launch',
      'emoji': '🎯',
      'color': Color(0xFFFF5722),
      'difficulty': 'Medium',
      'time': '40 min',
      'goal': 'Launch an object to hit a target!',
      'materials': ['Popsicle sticks', 'Rubber bands', 'Plastic spoon', 'Small balls or pompoms'],
      'rules': [
        'Build a working catapult',
        'Hit targets at different distances',
        'Points for accuracy',
      ],
      'tips': ['More rubber bands = more power', 'Adjust angle for distance', 'Practice your aim'],
      'science': 'Stored energy (potential) converts to motion energy (kinetic)!',
    },
    {
      'name': 'Marble Run',
      'emoji': '🔵',
      'color': Color(0xFF7E57C2),
      'difficulty': 'Hard',
      'time': '45 min',
      'goal': 'Create the longest marble run!',
      'materials': ['Cardboard tubes', 'Paper plates', 'Tape', 'Scissors', 'Marbles'],
      'rules': [
        'Marble must complete the run',
        'Use only given materials',
        'Time how long marble takes',
      ],
      'tips': ['Gentle slopes keep marble moving', 'Add curves and loops', 'Test each section'],
      'science': 'Gravity pulls the marble down, speed depends on slope angle!',
    },
    {
      'name': 'Wind Powered Car',
      'emoji': '🚗💨',
      'color': Color(0xFF26A69A),
      'difficulty': 'Hard',
      'time': '45 min',
      'goal': 'Build a car powered only by wind!',
      'materials': ['Cardboard', 'Straws', 'Bottle caps', 'Paper for sail', 'Tape'],
      'rules': [
        'Car must move using wind only',
        'Use a fan or blow on it',
        'Measure distance traveled',
      ],
      'tips': ['Big sail catches more wind', 'Light body moves easier', 'Wheels must spin freely'],
      'science': 'Wind energy converts to motion - this is how sailboats work!',
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
          'STEM Challenges',
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
              Expanded(
                child: selectedChallenge == -1
                    ? _buildChallengeList()
                    : _buildChallengeDetail(challenges[selectedChallenge]),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildChallengeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return GestureDetector(
          onTap: () => setState(() => selectedChallenge = index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: challenge['color'].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: challenge['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(challenge['emoji'], style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: challenge['color'],
                          ),
                        ),
                        Text(
                          challenge['goal'],
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildTag(challenge['difficulty'], challenge['color']),
                            const SizedBox(width: 8),
                            Text('⏱️ ${challenge['time']}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: challenge['color'], size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildChallengeDetail(Map<String, dynamic> challenge) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(challenge['emoji'], style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag(challenge['difficulty'], challenge['color']),
                    const SizedBox(width: 12),
                    _buildTag('⏱️ ${challenge['time']}', Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: challenge['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🎯 ${challenge['goal']}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: challenge['color'],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Materials
          _buildSection('Materials', '🧪', challenge['color'],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (challenge['materials'] as List).map<Widget>((m) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: challenge['color'].withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    m,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Rules
          _buildSection('Rules', '📋', challenge['color'],
            Column(
              children: (challenge['rules'] as List).asMap().entries.map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: challenge['color'],
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
                      Expanded(child: Text(entry.value, style: GoogleFonts.nunito(fontSize: 14))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Tips
          _buildSection('Tips', '💡', challenge['color'],
            Column(
              children: (challenge['tips'] as List).map<Widget>((tip) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: challenge['color'], size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip, style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Science
          _buildSection('The Science', '🧠', challenge['color'],
            Text(
              challenge['science'],
              style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String emoji, Color color, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
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
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }
}
