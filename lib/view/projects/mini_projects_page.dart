import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MiniProjectsPage extends StatefulWidget {
  const MiniProjectsPage({super.key});

  @override
  State<MiniProjectsPage> createState() => _MiniProjectsPageState();
}

class _MiniProjectsPageState extends State<MiniProjectsPage> {
  String? selectedProject;

  final List<Map<String, dynamic>> projects = [
    {
      'name': 'Rainbow in a Jar',
      'emoji': '🌈',
      'color': Color(0xFFFF6B6B),
      'difficulty': 'Easy',
      'time': '15 mins',
      'category': 'Science',
      'description': 'Create beautiful rainbow layers using water and sugar!',
      'materials': ['Glass jar', 'Water', 'Sugar', 'Food coloring', 'Spoon'],
      'steps': [
        'Mix different amounts of sugar with water for each color',
        'Add food coloring to each mixture',
        'Carefully pour heaviest (most sugar) layer first',
        'Slowly add lighter layers on top',
        'Watch the rainbow appear!',
      ],
      'learning': 'Density - heavier liquids sink, lighter ones float!',
    },
    {
      'name': 'Paper Airplane Contest',
      'emoji': '✈️',
      'color': Color(0xFF4ECDC4),
      'difficulty': 'Easy',
      'time': '20 mins',
      'category': 'Engineering',
      'description': 'Design and test different paper airplane designs!',
      'materials': ['Paper sheets', 'Ruler', 'Tape (optional)', 'Measuring tape'],
      'steps': [
        'Fold 3 different airplane designs',
        'Name each airplane',
        'Test each one and measure how far it flies',
        'Record your results',
        'Which design won? Why?',
      ],
      'learning': 'Aerodynamics - how shapes affect flight!',
    },
    {
      'name': 'Mini Garden',
      'emoji': '🌱',
      'color': Color(0xFF10B981),
      'difficulty': 'Medium',
      'time': '30 mins + waiting',
      'category': 'Nature',
      'description': 'Grow your own plants from seeds in small containers!',
      'materials': ['Small pots or cups', 'Soil', 'Seeds', 'Water', 'Sunny spot'],
      'steps': [
        'Fill containers with soil',
        'Make small holes for seeds',
        'Place seeds and cover lightly',
        'Water gently',
        'Put in sunny place and water daily',
      ],
      'learning': 'Plant life cycle - seeds need water, soil, and sunlight!',
    },
    {
      'name': 'Homemade Volcano',
      'emoji': '🌋',
      'color': Color(0xFFF59E0B),
      'difficulty': 'Easy',
      'time': '20 mins',
      'category': 'Science',
      'description': 'Make an erupting volcano with kitchen ingredients!',
      'materials': ['Baking soda', 'Vinegar', 'Food coloring', 'Container', 'Tray'],
      'steps': [
        'Place container on tray',
        'Add 2 tablespoons baking soda',
        'Add red food coloring',
        'Pour vinegar and watch it erupt!',
        'Try different amounts to see what happens',
      ],
      'learning': 'Chemical reaction - acid and base create gas bubbles!',
    },
    {
      'name': 'Weather Station',
      'emoji': '☁️',
      'color': Color(0xFF45B7D1),
      'difficulty': 'Medium',
      'time': '1 week project',
      'category': 'Science',
      'description': 'Track weather for a week and make predictions!',
      'materials': ['Paper', 'Crayons', 'Thermometer', 'Rain gauge (cup)'],
      'steps': [
        'Create a weather chart for 7 days',
        'Check weather at same time each day',
        'Draw the weather symbols',
        'Record temperature if you can',
        'Try to predict tomorrow\'s weather!',
      ],
      'learning': 'Weather patterns - observe and predict nature!',
    },
    {
      'name': 'Recycled Robot',
      'emoji': '🤖',
      'color': Color(0xFF8B5CF6),
      'difficulty': 'Medium',
      'time': '45 mins',
      'category': 'Art & Recycling',
      'description': 'Build a robot friend from items you would throw away!',
      'materials': ['Cardboard boxes', 'Bottle caps', 'Toilet paper rolls', 'Glue', 'Paint'],
      'steps': [
        'Collect recyclable items',
        'Plan your robot design',
        'Glue pieces together',
        'Add details like eyes and buttons',
        'Paint and decorate!',
      ],
      'learning': 'Recycling creativity - old items become new creations!',
    },
    {
      'name': 'Shadow Puppets',
      'emoji': '🎭',
      'color': Color(0xFFEC4899),
      'difficulty': 'Easy',
      'time': '30 mins',
      'category': 'Art',
      'description': 'Create puppet characters and put on a shadow show!',
      'materials': ['Cardboard', 'Sticks', 'Scissors', 'Flashlight', 'White sheet'],
      'steps': [
        'Draw character shapes on cardboard',
        'Cut out the shapes carefully',
        'Attach sticks to hold them',
        'Set up flashlight and white sheet',
        'Create your shadow show!',
      ],
      'learning': 'Light and shadows - how light creates shadows!',
    },
    {
      'name': 'Counting Books',
      'emoji': '📖',
      'color': Color(0xFF06B6D4),
      'difficulty': 'Easy',
      'time': '40 mins',
      'category': 'Math & Art',
      'description': 'Make your own counting book from 1 to 10!',
      'materials': ['Paper', 'Crayons', 'Stapler', 'Stickers (optional)'],
      'steps': [
        'Fold papers to make a book',
        'Write numbers 1-10, one per page',
        'Draw that many objects on each page',
        'Decorate your cover',
        'Read your book to someone!',
      ],
      'learning': 'Counting practice - connect numbers to quantities!',
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
          'Mini Projects',
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
                child: selectedProject == null
                    ? _buildProjectsList()
                    : _buildProjectDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProjectsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Intro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🎨', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learn By Doing!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Pick a project and create something amazing',
                        style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Projects List
          ...projects.map((project) => _buildProjectCard(project)),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProject = project['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              project['color'],
              project['color'].withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: project['color'].withValues(alpha: 0.4),
              blurRadius: 8,
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
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  project['emoji'],
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTag(project['difficulty'], Colors.white),
                      const SizedBox(width: 8),
                      _buildTag(project['time'], Colors.white.withValues(alpha: 0.8)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project['category'],
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
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

  Widget _buildProjectDetail() {
    final project = projects.firstWhere((p) => p['name'] == selectedProject);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: project['color'].withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(project['emoji'], style: const TextStyle(fontSize: 70)),
                const SizedBox(height: 12),
                Text(
                  project['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: project['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project['description'],
                  style: GoogleFonts.nunito(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDetailTag('⏱️ ${project['time']}', project['color']),
                    const SizedBox(width: 8),
                    _buildDetailTag('📊 ${project['difficulty']}', project['color']),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Materials
          _buildSection(
            '🛠️',
            'What You Need',
            project['materials'],
            project['color'],
            isList: true,
          ),
          // Steps
          _buildStepsSection(project),
          // Learning
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                const Text('🧠', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What You\'ll Learn:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      Text(
                        project['learning'],
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
          const SizedBox(height: 20),
          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  '🎉 Let\'s Go!',
                  'Gather your materials and start your ${project['name']}!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: project['color'],
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              icon: const Text('🚀', style: TextStyle(fontSize: 20)),
              label: Text(
                'Start Project!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: project['color'],
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
        ),
      ),
    );
  }

  Widget _buildSection(String emoji, String title, List<dynamic> items, Color color, {bool isList = false}) {
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
                  border: Border.all(color: color.withValues(alpha: 0.3)),
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

  Widget _buildStepsSection(Map<String, dynamic> project) {
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
                'Steps',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: project['color'],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate((project['steps'] as List).length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: project['color'],
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
                      project['steps'][index],
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
