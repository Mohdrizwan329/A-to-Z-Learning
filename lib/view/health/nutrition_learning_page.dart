import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionLearningPage extends StatefulWidget {
  const NutritionLearningPage({super.key});

  @override
  State<NutritionLearningPage> createState() => _NutritionLearningPageState();
}

class _NutritionLearningPageState extends State<NutritionLearningPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Nutrition?',
      'emoji': '🥗',
      'color': Color(0xFF66BB6A),
      'content': [
        {'icon': '🍎', 'text': 'Nutrition is about eating the right foods to stay healthy'},
        {'icon': '💪', 'text': 'Good food gives us energy to play and learn'},
        {'icon': '🧠', 'text': 'It helps our brain think better'},
        {'icon': '📏', 'text': 'It helps us grow tall and strong'},
        {'icon': '🛡️', 'text': 'It protects us from getting sick'},
      ],
    },
    {
      'title': 'Food Groups',
      'emoji': '🍽️',
      'color': Color(0xFF42A5F5),
      'groups': [
        {
          'name': 'Fruits & Vegetables',
          'emoji': '🥕🍇',
          'color': Colors.green,
          'foods': ['Apple', 'Banana', 'Carrot', 'Spinach'],
          'benefit': 'Vitamins & Fiber',
        },
        {
          'name': 'Grains',
          'emoji': '🍞🍚',
          'color': Colors.amber,
          'foods': ['Rice', 'Bread', 'Roti', 'Oats'],
          'benefit': 'Energy',
        },
        {
          'name': 'Protein',
          'emoji': '🥚🫘',
          'color': Colors.red,
          'foods': ['Eggs', 'Dal', 'Chicken', 'Fish'],
          'benefit': 'Muscle Building',
        },
        {
          'name': 'Dairy',
          'emoji': '🥛🧀',
          'color': Colors.blue,
          'foods': ['Milk', 'Cheese', 'Yogurt', 'Paneer'],
          'benefit': 'Strong Bones',
        },
      ],
    },
    {
      'title': 'Important Nutrients',
      'emoji': '💊',
      'color': Color(0xFFFF7043),
      'nutrients': [
        {'name': 'Vitamin A', 'emoji': '🥕', 'benefit': 'Good for eyes', 'found': 'Carrots, papaya'},
        {'name': 'Vitamin C', 'emoji': '🍊', 'benefit': 'Fights cold & flu', 'found': 'Oranges, lemons'},
        {'name': 'Vitamin D', 'emoji': '☀️', 'benefit': 'Strong bones', 'found': 'Sunlight, milk'},
        {'name': 'Calcium', 'emoji': '🥛', 'benefit': 'Healthy teeth & bones', 'found': 'Milk, cheese'},
        {'name': 'Iron', 'emoji': '🥬', 'benefit': 'Makes blood strong', 'found': 'Spinach, dates'},
        {'name': 'Protein', 'emoji': '🥚', 'benefit': 'Builds muscles', 'found': 'Eggs, dal, nuts'},
      ],
    },
    {
      'title': 'My Healthy Plate',
      'emoji': '🍽️',
      'color': Color(0xFF26A69A),
      'plate': [
        {'section': 'Half Plate', 'fill': 'Vegetables & Fruits', 'emoji': '🥗🍎', 'color': Colors.green},
        {'section': 'Quarter', 'fill': 'Grains (Roti/Rice)', 'emoji': '🍚', 'color': Colors.amber},
        {'section': 'Quarter', 'fill': 'Protein (Dal/Egg)', 'emoji': '🫘', 'color': Colors.red},
        {'section': 'Side', 'fill': 'Dairy (Milk/Curd)', 'emoji': '🥛', 'color': Colors.blue},
      ],
    },
    {
      'title': 'Healthy vs Junk',
      'emoji': '⚖️',
      'color': Color(0xFFAB47BC),
      'comparison': [
        {'healthy': 'Fresh fruits 🍎', 'junk': 'Candy 🍬'},
        {'healthy': 'Water 💧', 'junk': 'Soda 🥤'},
        {'healthy': 'Roti with dal 🫓', 'junk': 'Chips 🍟'},
        {'healthy': 'Homemade food 🍲', 'junk': 'Fast food 🍔'},
        {'healthy': 'Milk 🥛', 'junk': 'Sugary drinks 🧃'},
        {'healthy': 'Nuts 🥜', 'junk': 'Cookies 🍪'},
      ],
    },
    {
      'title': 'Water is Important!',
      'emoji': '💧',
      'color': Color(0xFF29B6F6),
      'waterFacts': [
        {'fact': 'Drink 6-8 glasses of water every day', 'emoji': '🥛'},
        {'fact': 'Water helps carry nutrients in your body', 'emoji': '🚚'},
        {'fact': 'It keeps your skin healthy', 'emoji': '✨'},
        {'fact': 'Drink water, not soda or juice', 'emoji': '🚫'},
        {'fact': 'Always carry a water bottle', 'emoji': '🍶'},
        {'fact': 'Drink more water when playing sports', 'emoji': '⚽'},
      ],
    },
    {
      'title': 'Healthy Eating Tips',
      'emoji': '⭐',
      'color': Color(0xFFFFB74D),
      'tips': [
        {'tip': 'Eat breakfast every morning', 'emoji': '🌅', 'why': 'Starts your day with energy'},
        {'tip': 'Eat 5 fruits and vegetables daily', 'emoji': '🍏', 'why': 'Full of vitamins'},
        {'tip': 'Chew your food well', 'emoji': '😋', 'why': 'Helps digestion'},
        {'tip': 'Don\'t skip meals', 'emoji': '⏰', 'why': 'Keeps energy steady'},
        {'tip': 'Eat slowly, not in a hurry', 'emoji': '🐢', 'why': 'Helps you feel full'},
        {'tip': 'Limit sweets and chips', 'emoji': '🍫', 'why': 'Too much is unhealthy'},
        {'tip': 'Try new healthy foods', 'emoji': '🥦', 'why': 'Variety is good'},
        {'tip': 'Wash hands before eating', 'emoji': '🧼', 'why': 'Keeps germs away'},
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
          'Nutrition Learning',
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
        if (section.containsKey('content')) _buildContentCards(section),
        if (section.containsKey('groups')) _buildFoodGroupCards(section),
        if (section.containsKey('nutrients')) _buildNutrientCards(section),
        if (section.containsKey('plate')) _buildPlateSection(section),
        if (section.containsKey('comparison')) _buildComparisonCards(section),
        if (section.containsKey('waterFacts')) _buildWaterFactCards(section),
        if (section.containsKey('tips')) _buildTipCards(section),
      ],
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children: (section['content'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(item['icon'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item['text'],
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

  Widget _buildFoodGroupCards(Map<String, dynamic> section) {
    return Column(
      children: (section['groups'] as List).map<Widget>((group) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (group['color'] as Color).withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(group['emoji'], style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: group['color'],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Gives: ${group['benefit']}',
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
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (group['foods'] as List).map<Widget>((food) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (group['color'] as Color).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      food,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: group['color'],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNutrientCards(Map<String, dynamic> section) {
    return Column(
      children: (section['nutrients'] as List).map<Widget>((nutrient) {
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
                  child: Text(nutrient['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nutrient['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      nutrient['benefit'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Found in: ${nutrient['found']}',
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade500,
                        fontSize: 12,
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

  Widget _buildPlateSection(Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Visual plate representation
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 4),
            ),
            child: Stack(
              children: [
                // Vegetables half
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 100,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                    child: const Center(child: Text('🥗🍎', style: TextStyle(fontSize: 30))),
                  ),
                ),
                // Grains quarter
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(100),
                      ),
                    ),
                    child: const Center(child: Text('🍚', style: TextStyle(fontSize: 24))),
                  ),
                ),
                // Protein quarter
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: const Center(child: Text('🫘', style: TextStyle(fontSize: 24))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          ...(section['plate'] as List).map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(item['emoji'], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '${item['section']}: ${item['fill']}',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.grey.shade700,
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

  Widget _buildComparisonCards(Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '✅ Healthy',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '❌ Junk',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(section['comparison'] as List).map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item['healthy'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.green.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('vs', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item['junk'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.red.shade700,
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildWaterFactCards(Map<String, dynamic> section) {
    return Column(
      children: (section['waterFacts'] as List).map<Widget>((fact) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(fact['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  fact['fact'],
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

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).map<Widget>((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['tip'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      tip['why'],
                      style: GoogleFonts.nunito(
                        color: section['color'],
                        fontSize: 12,
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
