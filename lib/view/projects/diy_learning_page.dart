import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DiyLearningPage extends StatefulWidget {
  const DiyLearningPage({super.key});

  @override
  State<DiyLearningPage> createState() => _DiyLearningPageState();
}

class _DiyLearningPageState extends State<DiyLearningPage> {
  String? selectedCategory;
  String? selectedItem;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Math Tools',
      'emoji': '🔢',
      'color': Color(0xFF6366F1),
      'description': 'Make your own math learning tools',
      'items': [
        {
          'name': 'Number Line Bracelet',
          'emoji': '📏',
          'materials': ['Beads', 'String', 'Number stickers'],
          'steps': [
            'String beads 0-10 on bracelet',
            'Add number stickers to each bead',
            'Wear it to practice counting!',
          ],
          'learning': 'Practice counting and number order',
        },
        {
          'name': 'Dice Math Game',
          'emoji': '🎲',
          'materials': ['Paper', 'Scissors', 'Markers'],
          'steps': [
            'Draw dice template on paper',
            'Cut out and fold into cube',
            'Write numbers or dots on each side',
            'Roll and add numbers together!',
          ],
          'learning': 'Practice addition with fun dice rolls',
        },
        {
          'name': 'Shape Sorter Box',
          'emoji': '🔷',
          'materials': ['Cardboard box', 'Scissors', 'Colored paper'],
          'steps': [
            'Cut different shapes in box lid',
            'Make matching cardboard shapes',
            'Decorate with colors',
            'Sort shapes into the box!',
          ],
          'learning': 'Learn shapes and matching',
        },
      ],
    },
    {
      'name': 'Reading Helpers',
      'emoji': '📚',
      'color': Color(0xFFEC4899),
      'description': 'Create tools to help you read',
      'items': [
        {
          'name': 'Word Family Wheel',
          'emoji': '🎡',
          'materials': ['2 paper plates', 'Brass fastener', 'Markers'],
          'steps': [
            'Cut window in top plate',
            'Write word endings on bottom plate',
            'Write beginning letters around window',
            'Connect with fastener and spin!',
          ],
          'learning': 'Practice word families like -at, -an, -op',
        },
        {
          'name': 'Sight Word Flashcards',
          'emoji': '🃏',
          'materials': ['Index cards', 'Markers', 'Ring clip'],
          'steps': [
            'Write sight words on cards',
            'Add fun drawings',
            'Punch hole and connect with ring',
            'Practice anywhere!',
          ],
          'learning': 'Learn common words by sight',
        },
        {
          'name': 'Story Stones',
          'emoji': '🪨',
          'materials': ['Smooth stones', 'Paint', 'Clear sealant'],
          'steps': [
            'Collect smooth stones',
            'Paint pictures: characters, places, objects',
            'Let dry and seal',
            'Pick stones to make stories!',
          ],
          'learning': 'Creative storytelling practice',
        },
      ],
    },
    {
      'name': 'Science Kits',
      'emoji': '🔬',
      'color': Color(0xFF10B981),
      'description': 'Build science exploration tools',
      'items': [
        {
          'name': 'Bug Viewer Box',
          'emoji': '🐛',
          'materials': ['Plastic container', 'Magnifying glass', 'Mesh fabric'],
          'steps': [
            'Cut hole in lid',
            'Glue mesh over hole for air',
            'Add magnifying glass to side',
            'Collect and observe bugs safely!',
          ],
          'learning': 'Observe insects up close',
        },
        {
          'name': 'Rain Gauge',
          'emoji': '🌧️',
          'materials': ['Plastic bottle', 'Ruler', 'Permanent marker'],
          'steps': [
            'Cut top off bottle',
            'Mark measurements on side',
            'Place outside when it rains',
            'Measure rainfall each day!',
          ],
          'learning': 'Track weather and measurements',
        },
        {
          'name': 'Magnet Discovery Kit',
          'emoji': '🧲',
          'materials': ['Magnet', 'Small box', 'Various objects'],
          'steps': [
            'Collect small objects (clips, coins, toys)',
            'Test each with your magnet',
            'Sort into "magnetic" and "not magnetic"',
            'Record your findings!',
          ],
          'learning': 'Discover magnetic properties',
        },
      ],
    },
    {
      'name': 'Art Materials',
      'emoji': '🎨',
      'color': Color(0xFFF59E0B),
      'description': 'Make your own art supplies',
      'items': [
        {
          'name': 'Homemade Playdough',
          'emoji': '🟡',
          'materials': ['Flour', 'Salt', 'Water', 'Food coloring', 'Oil'],
          'steps': [
            'Mix 1 cup flour + 1/2 cup salt',
            'Add 1/2 cup water + 1 tbsp oil',
            'Add food coloring',
            'Knead until smooth!',
          ],
          'learning': 'Create and mold shapes',
        },
        {
          'name': 'Nature Paintbrushes',
          'emoji': '🌿',
          'materials': ['Sticks', 'Leaves', 'Flowers', 'String'],
          'steps': [
            'Collect interesting plants',
            'Tie leaves/flowers to sticks',
            'Dip in paint',
            'Create unique textures!',
          ],
          'learning': 'Explore textures and patterns',
        },
        {
          'name': 'Recycled Stamps',
          'emoji': '♻️',
          'materials': ['Bottle caps', 'Foam', 'Cardboard tubes'],
          'steps': [
            'Cut shapes from foam',
            'Glue to caps or tubes',
            'Dip in paint',
            'Stamp patterns and designs!',
          ],
          'learning': 'Patterns and recycling creativity',
        },
      ],
    },
    {
      'name': 'Music Makers',
      'emoji': '🎵',
      'color': Color(0xFF8B5CF6),
      'description': 'Create musical instruments',
      'items': [
        {
          'name': 'Shaker Eggs',
          'emoji': '🥚',
          'materials': ['Plastic eggs', 'Rice/beans', 'Tape'],
          'steps': [
            'Fill eggs with rice or beans',
            'Tape closed securely',
            'Decorate if you want',
            'Shake along to music!',
          ],
          'learning': 'Rhythm and beat patterns',
        },
        {
          'name': 'Rubber Band Guitar',
          'emoji': '🎸',
          'materials': ['Tissue box', 'Rubber bands', 'Cardboard tube'],
          'steps': [
            'Stretch rubber bands over box opening',
            'Attach tube as neck',
            'Pluck different bands',
            'Each makes a different sound!',
          ],
          'learning': 'Sound vibrations and pitch',
        },
        {
          'name': 'Rain Stick',
          'emoji': '🌧️',
          'materials': ['Paper towel tube', 'Toothpicks', 'Rice', 'Tape'],
          'steps': [
            'Poke toothpicks through tube in spiral',
            'Cover one end with paper',
            'Add rice inside',
            'Cover other end and decorate!',
          ],
          'learning': 'Sound effects and rhythm',
        },
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
          'DIY Learning',
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
                child: selectedItem != null
                    ? _buildItemDetail()
                    : selectedCategory != null
                        ? _buildCategoryItems()
                        : _buildCategoriesGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCategoriesGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Intro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('✨', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Make Your Own!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Create learning tools with stuff at home',
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
          const SizedBox(height: 20),
          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(categories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category['name'];
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category['color'],
              category['color'].withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: category['color'].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category['emoji'],
                style: const TextStyle(fontSize: 45),
              ),
              const SizedBox(height: 8),
              Text(
                category['name'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${(category['items'] as List).length} projects',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItems() {
    final category = categories.firstWhere((c) => c['name'] == selectedCategory);
    final items = category['items'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category['color'].withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(category['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category['description'],
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Items List
          ...items.map<Widget>((item) => _buildItemCard(item, category['color'])),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = item['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(item['emoji'], style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    item['learning'],
                    style: GoogleFonts.nunito(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetail() {
    final category = categories.firstWhere((c) => c['name'] == selectedCategory);
    final item = (category['items'] as List).firstWhere((i) => i['name'] == selectedItem);
    final color = category['color'];

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
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(item['emoji'], style: const TextStyle(fontSize: 70)),
                const SizedBox(height: 12),
                Text(
                  item['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Materials
          _buildSection('🛠️', 'Materials', item['materials'], color),
          // Steps
          _buildStepsSection(item['steps'], color),
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
                const Text('💡', style: TextStyle(fontSize: 28)),
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
                        item['learning'],
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
                  '🎨 Let\'s Make It!',
                  'Gather your materials and start creating!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: color,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              icon: const Text('✨', style: TextStyle(fontSize: 20)),
              label: Text(
                'Start Making!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
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

  Widget _buildStepsSection(List<dynamic> steps, Color color) {
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
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
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
                      steps[index],
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
