import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class HomeExperimentsPage extends StatefulWidget {
  const HomeExperimentsPage({super.key});

  @override
  State<HomeExperimentsPage> createState() => _HomeExperimentsPageState();
}

class _HomeExperimentsPageState extends State<HomeExperimentsPage> {
  String? selectedExperiment;

  final List<Map<String, dynamic>> experiments = [
    {
      'name': 'Dancing Raisins',
      'emoji': '💃',
      'color': Color(0xFF9B59B6),
      'time': '5 mins',
      'safetyLevel': 'Very Safe',
      'description': 'Watch raisins dance up and down in bubbly water!',
      'materials': ['Clear glass', 'Sparkling water or soda', 'Raisins'],
      'steps': [
        'Fill glass with sparkling water',
        'Drop in 4-5 raisins',
        'Watch them sink, then rise, then sink again!',
      ],
      'science': 'Bubbles stick to raisins and lift them up. At the top, bubbles pop and raisins sink!',
      'tryThis': 'Try with other small objects - do they dance too?',
    },
    {
      'name': 'Magic Milk',
      'emoji': '🥛',
      'color': Color(0xFFE91E63),
      'time': '10 mins',
      'safetyLevel': 'Very Safe',
      'description': 'Create swirling colors in milk with dish soap!',
      'materials': ['Plate', 'Whole milk', 'Food coloring', 'Dish soap', 'Cotton swab'],
      'steps': [
        'Pour milk to cover plate bottom',
        'Add drops of different food colors',
        'Dip cotton swab in dish soap',
        'Touch the milk surface and watch magic happen!',
      ],
      'science': 'Soap breaks up the fat in milk, making colors swirl and move!',
      'tryThis': 'Try with skim milk vs whole milk - which works better?',
    },
    {
      'name': 'Walking Water',
      'emoji': '🌈',
      'color': Color(0xFF3498DB),
      'time': '30 mins',
      'safetyLevel': 'Very Safe',
      'description': 'Watch water walk from one glass to another!',
      'materials': ['6 glasses', 'Water', 'Paper towels', 'Red, yellow, blue food coloring'],
      'steps': [
        'Fill 3 glasses with water (leave 3 empty)',
        'Add colors: red, yellow, blue to filled glasses',
        'Place in circle, alternating filled/empty',
        'Connect with folded paper towels',
        'Wait and watch water walk!',
      ],
      'science': 'Capillary action - water molecules pull each other up the paper towel!',
      'tryThis': 'See what new colors form where waters meet!',
    },
    {
      'name': 'Invisible Ink',
      'emoji': '🔍',
      'color': Color(0xFFF39C12),
      'time': '15 mins',
      'safetyLevel': 'Adult Help Needed',
      'description': 'Write secret messages that appear like magic!',
      'materials': ['Lemon juice', 'White paper', 'Cotton swab', 'Lamp (with adult)'],
      'steps': [
        'Dip cotton swab in lemon juice',
        'Write a secret message on paper',
        'Let it dry completely',
        'Hold paper near warm lamp (with adult help)',
        'Watch your message appear!',
      ],
      'science': 'Lemon juice turns brown when heated because it oxidizes!',
      'tryThis': 'Try with milk or apple juice - do they work too?',
    },
    {
      'name': 'Balloon Rocket',
      'emoji': '🎈',
      'color': Color(0xFF1ABC9C),
      'time': '10 mins',
      'safetyLevel': 'Very Safe',
      'description': 'Launch a balloon across the room on a string!',
      'materials': ['Balloon', 'String', 'Straw', 'Tape', '2 chairs'],
      'steps': [
        'Thread string through straw',
        'Tie string between 2 chairs',
        'Blow up balloon (don\'t tie it!)',
        'Tape balloon to straw',
        'Let go and watch it zoom!',
      ],
      'science': 'Air rushes out the back, pushing the balloon forward - Newton\'s 3rd Law!',
      'tryThis': 'What happens with bigger or smaller balloons?',
    },
    {
      'name': 'Floating Egg',
      'emoji': '🥚',
      'color': Color(0xFF27AE60),
      'time': '10 mins',
      'safetyLevel': 'Very Safe',
      'description': 'Make an egg float in the middle of a glass!',
      'materials': ['Tall glass', 'Water', 'Salt', 'Egg', 'Spoon'],
      'steps': [
        'Fill glass halfway with warm water',
        'Stir in lots of salt until dissolved',
        'Slowly pour fresh water on top',
        'Gently lower egg into glass',
        'Watch it float in the middle!',
      ],
      'science': 'Salt water is denser than fresh water. The egg floats where waters meet!',
      'tryThis': 'How much salt does it take to make the egg float on top?',
    },
    {
      'name': 'Cloud in a Jar',
      'emoji': '☁️',
      'color': Color(0xFF5DADE2),
      'time': '10 mins',
      'safetyLevel': 'Adult Help Needed',
      'description': 'Create your own cloud inside a jar!',
      'materials': ['Glass jar with lid', 'Hot water', 'Ice cubes', 'Hairspray'],
      'steps': [
        'Pour hot water in jar (1 inch)',
        'Swirl it around',
        'Quick spray of hairspray inside (adult help)',
        'Put lid with ice on top',
        'Watch cloud form!',
      ],
      'science': 'Warm water vapor rises, hits cold air, and condenses on hairspray particles!',
      'tryThis': 'Open the lid and watch the cloud escape!',
    },
    {
      'name': 'Pepper Scatter',
      'emoji': '🫧',
      'color': Color(0xFF8E44AD),
      'time': '5 mins',
      'safetyLevel': 'Very Safe',
      'description': 'Make pepper run away from your finger!',
      'materials': ['Bowl of water', 'Black pepper', 'Dish soap'],
      'steps': [
        'Fill bowl with water',
        'Sprinkle pepper on top',
        'Dip finger in dish soap',
        'Touch the water center',
        'Watch pepper race to the edges!',
      ],
      'science': 'Soap breaks the water surface tension, pulling water (and pepper) outward!',
      'tryThis': 'Try with other spices - does it work the same?',
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
          'Home Experiments',
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
                child: selectedExperiment == null
                    ? _buildExperimentsList()
                    : _buildExperimentDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildExperimentsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Safety Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safety First!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Always do experiments with an adult nearby',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Experiments List
          ...experiments.map((exp) => _buildExperimentCard(exp)),
        ],
      ),
    );
  }

  Widget _buildExperimentCard(Map<String, dynamic> experiment) {
    return GestureDetector(
      onTap: () {
        TtsService.to.speak(experiment['name']);
        setState(() {
          selectedExperiment = experiment['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: experiment['color'].withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    experiment['color'],
                    experiment['color'].withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  experiment['emoji'],
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experiment['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: experiment['color'],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    experiment['description'],
                    style: GoogleFonts.nunito(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildTag('⏱️ ${experiment['time']}', experiment['color']),
                      const SizedBox(width: 6),
                      _buildTag(
                        experiment['safetyLevel'] == 'Adult Help Needed' ? '👨‍👩‍👧' : '✅',
                        experiment['safetyLevel'] == 'Adult Help Needed'
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: experiment['color'], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExperimentDetail() {
    final experiment = experiments.firstWhere((e) => e['name'] == selectedExperiment);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: experiment['color'].withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(experiment['emoji'], style: const TextStyle(fontSize: 70)),
                const SizedBox(height: 12),
                Text(
                  experiment['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: experiment['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDetailTag('⏱️ ${experiment['time']}', experiment['color']),
                    const SizedBox(width: 8),
                    _buildDetailTag(
                      experiment['safetyLevel'] == 'Adult Help Needed'
                          ? '👨‍👩‍👧 Adult Help'
                          : '✅ Very Safe',
                      experiment['safetyLevel'] == 'Adult Help Needed'
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Materials
          _buildSection('🛠️', 'You\'ll Need:', experiment['materials'], experiment['color']),
          // Steps
          _buildStepsSection(experiment),
          // Science
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: experiment['color'].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔬', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Science:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        experiment['science'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Try This
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Try This Too:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      Text(
                        experiment['tryThis'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  '🧪 Experiment Time!',
                  'Gather your materials and let\'s do science!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: experiment['color'],
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              icon: const Text('🚀', style: TextStyle(fontSize: 20)),
              label: Text(
                'Start Experiment!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: experiment['color'],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSection(String emoji, String title, List<dynamic> items, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map<Widget>((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.nunito(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection(Map<String, dynamic> experiment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Steps:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: experiment['color'],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate((experiment['steps'] as List).length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: experiment['color'],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
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
                      experiment['steps'][index],
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
