import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleExperimentsPage extends StatefulWidget {
  const SimpleExperimentsPage({super.key});

  @override
  State<SimpleExperimentsPage> createState() => _SimpleExperimentsPageState();
}

class _SimpleExperimentsPageState extends State<SimpleExperimentsPage> {
  int selectedExperiment = -1;

  final List<Map<String, dynamic>> experiments = [
    {
      'name': 'Volcano Eruption',
      'emoji': '🌋',
      'color': Color(0xFFFF5722),
      'difficulty': 'Easy',
      'time': '10 min',
      'materials': ['Baking soda', 'Vinegar', 'Dish soap', 'Food coloring', 'Bottle'],
      'steps': [
        'Put the bottle in a tray',
        'Add 2 spoons of baking soda',
        'Add a few drops of food coloring',
        'Add a drop of dish soap',
        'Slowly pour vinegar and watch!',
      ],
      'science': 'Vinegar (acid) reacts with baking soda (base) to make carbon dioxide gas!',
    },
    {
      'name': 'Rainbow Milk',
      'emoji': '🌈🥛',
      'color': Color(0xFFE91E63),
      'difficulty': 'Easy',
      'time': '5 min',
      'materials': ['Milk', 'Food coloring', 'Dish soap', 'Plate', 'Cotton swab'],
      'steps': [
        'Pour milk into the plate',
        'Add drops of different colors',
        'Dip cotton swab in dish soap',
        'Touch the milk with the swab',
        'Watch colors dance and swirl!',
      ],
      'science': 'Soap breaks the surface tension of milk, making colors move!',
    },
    {
      'name': 'Floating Egg',
      'emoji': '🥚',
      'color': Color(0xFF4CAF50),
      'difficulty': 'Easy',
      'time': '5 min',
      'materials': ['2 glasses', 'Water', 'Salt', '2 eggs'],
      'steps': [
        'Fill both glasses with water',
        'Add lots of salt to one glass and stir',
        'Put an egg in plain water - it sinks!',
        'Put an egg in salty water - it floats!',
      ],
      'science': 'Salt water is denser than plain water, so objects float more easily!',
    },
    {
      'name': 'Walking Water',
      'emoji': '💧',
      'color': Color(0xFF2196F3),
      'difficulty': 'Medium',
      'time': '1 hour',
      'materials': ['3 glasses', 'Paper towels', 'Food coloring', 'Water'],
      'steps': [
        'Place 3 glasses in a row',
        'Fill glass 1 with red water, glass 3 with blue',
        'Leave glass 2 empty',
        'Fold paper towels and connect glasses',
        'Wait and watch water walk!',
      ],
      'science': 'Water travels up the paper towel through capillary action!',
    },
    {
      'name': 'Dancing Raisins',
      'emoji': '🍇',
      'color': Color(0xFF9C27B0),
      'difficulty': 'Easy',
      'time': '5 min',
      'materials': ['Clear soda', 'Glass', 'Raisins'],
      'steps': [
        'Pour soda into a tall glass',
        'Drop in a few raisins',
        'Watch them sink... then rise!',
        'They dance up and down!',
      ],
      'science': 'Gas bubbles stick to raisins and lift them up. At the top, bubbles pop and raisins sink again!',
    },
    {
      'name': 'Invisible Ink',
      'emoji': '📝',
      'color': Color(0xFFFF9800),
      'difficulty': 'Medium',
      'time': '15 min',
      'materials': ['Lemon juice', 'White paper', 'Cotton swab', 'Lamp or iron'],
      'steps': [
        'Dip cotton swab in lemon juice',
        'Write a secret message',
        'Let it dry completely',
        'Hold paper near a warm lamp',
        'Watch your message appear!',
      ],
      'science': 'Heat oxidizes the lemon juice, turning it brown and revealing the message!',
    },
    {
      'name': 'Balloon Rocket',
      'emoji': '🎈🚀',
      'color': Color(0xFF00BCD4),
      'difficulty': 'Easy',
      'time': '10 min',
      'materials': ['Balloon', 'String', 'Straw', 'Tape'],
      'steps': [
        'Thread string through straw',
        'Tie string across the room',
        'Blow up balloon (don\'t tie it)',
        'Tape balloon to straw',
        'Let go and watch it zoom!',
      ],
      'science': 'Air rushing out pushes the balloon forward - this is Newton\'s Third Law!',
    },
    {
      'name': 'Crystal Garden',
      'emoji': '💎',
      'color': Color(0xFF673AB7),
      'difficulty': 'Hard',
      'time': '1-3 days',
      'materials': ['Salt', 'Hot water', 'String', 'Pencil', 'Glass jar'],
      'steps': [
        'Dissolve lots of salt in hot water',
        'Tie string to pencil',
        'Hang string in the jar',
        'Wait 1-3 days',
        'Watch crystals grow on the string!',
      ],
      'science': 'As water evaporates, salt molecules arrange into beautiful crystal shapes!',
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
          'Science Experiments',
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
                child: selectedExperiment == -1
                    ? _buildExperimentList()
                    : _buildExperimentDetail(experiments[selectedExperiment]),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildExperimentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: experiments.length,
      itemBuilder: (context, index) {
        final exp = experiments[index];
        return GestureDetector(
          onTap: () => setState(() => selectedExperiment = index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: exp['color'].withValues(alpha: 0.3),
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
                      color: exp['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(exp['emoji'], style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: exp['color'],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: exp['color'].withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                exp['difficulty'],
                                style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: exp['color'],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '⏱️ ${exp['time']}',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: exp['color'], size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExperimentDetail(Map<String, dynamic> exp) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(exp['emoji'], style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge(exp['difficulty'], exp['color']),
                    const SizedBox(width: 12),
                    _buildBadge('⏱️ ${exp['time']}', Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Materials
          _buildSection(
            'Materials You Need',
            '🧪',
            exp['color'],
            Column(
              children: (exp['materials'] as List).map<Widget>((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: exp['color'], size: 20),
                      const SizedBox(width: 10),
                      Text(m, style: GoogleFonts.nunito(fontSize: 14)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Steps
          _buildSection(
            'How to Do It',
            '📋',
            exp['color'],
            Column(
              children: (exp['steps'] as List).asMap().entries.map<Widget>((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: exp['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Science explanation
          _buildSection(
            'The Science Behind It',
            '🧠',
            exp['color'],
            Text(
              exp['science'],
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
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
