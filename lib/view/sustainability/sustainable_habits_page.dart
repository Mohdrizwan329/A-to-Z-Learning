import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SustainableHabitsPage extends StatefulWidget {
  const SustainableHabitsPage({super.key});

  @override
  State<SustainableHabitsPage> createState() => _SustainableHabitsPageState();
}

class _SustainableHabitsPageState extends State<SustainableHabitsPage> {
  int currentCategory = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Save Water',
      'emoji': '💧',
      'color': Color(0xFF42A5F5),
      'habits': [
        {'habit': 'Turn off tap while brushing teeth', 'emoji': '🪥', 'saves': '6 liters per minute!'},
        {'habit': 'Take shorter showers', 'emoji': '🚿', 'saves': 'Up to 150 liters!'},
        {'habit': 'Fix leaky taps', 'emoji': '🔧', 'saves': '20 liters per day'},
        {'habit': 'Use a bucket instead of running water', 'emoji': '🪣', 'saves': 'So much water!'},
        {'habit': 'Water plants in the evening', 'emoji': '🌱', 'saves': 'Less evaporation'},
        {'habit': 'Don\'t waste drinking water', 'emoji': '🥛', 'saves': 'Finish your glass'},
      ],
    },
    {
      'title': 'Save Energy',
      'emoji': '⚡',
      'color': Color(0xFFFFB74D),
      'habits': [
        {'habit': 'Turn off lights when leaving a room', 'emoji': '💡', 'saves': 'Electricity'},
        {'habit': 'Unplug devices when not in use', 'emoji': '🔌', 'saves': 'Standby power'},
        {'habit': 'Use natural light during day', 'emoji': '☀️', 'saves': 'No need for lights'},
        {'habit': 'Open windows instead of AC', 'emoji': '🪟', 'saves': 'Cool breeze is free'},
        {'habit': 'Turn off TV when not watching', 'emoji': '📺', 'saves': 'Energy'},
        {'habit': 'Use LED bulbs', 'emoji': '💡', 'saves': 'They use less power'},
      ],
    },
    {
      'title': 'Reduce Waste',
      'emoji': '🗑️',
      'color': Color(0xFF66BB6A),
      'habits': [
        {'habit': 'Carry a reusable water bottle', 'emoji': '🍶', 'saves': 'Plastic bottles'},
        {'habit': 'Use cloth bags for shopping', 'emoji': '🛍️', 'saves': 'Plastic bags'},
        {'habit': 'Use both sides of paper', 'emoji': '📄', 'saves': 'Trees'},
        {'habit': 'Finish your food - no waste', 'emoji': '🍽️', 'saves': 'Food waste'},
        {'habit': 'Say no to plastic straws', 'emoji': '🥤', 'saves': 'Ocean pollution'},
        {'habit': 'Reuse gift wrapping paper', 'emoji': '🎁', 'saves': 'Paper waste'},
      ],
    },
    {
      'title': 'Go Green',
      'emoji': '🌿',
      'color': Color(0xFF4CAF50),
      'habits': [
        {'habit': 'Plant a tree or flower', 'emoji': '🌳', 'impact': 'Clean air'},
        {'habit': 'Take care of plants at home', 'emoji': '🪴', 'impact': 'Fresh oxygen'},
        {'habit': 'Don\'t pick flowers from gardens', 'emoji': '🌸', 'impact': 'Let them bloom'},
        {'habit': 'Make compost from food scraps', 'emoji': '🥕', 'impact': 'Natural fertilizer'},
        {'habit': 'Grow your own vegetables', 'emoji': '🥬', 'impact': 'Fresh and healthy'},
        {'habit': 'Create a small garden', 'emoji': '🏡', 'impact': 'Green space'},
      ],
    },
    {
      'title': 'Clean Travel',
      'emoji': '🚲',
      'color': Color(0xFF26A69A),
      'habits': [
        {'habit': 'Walk to nearby places', 'emoji': '🚶', 'benefit': 'No pollution + exercise'},
        {'habit': 'Ride a bicycle', 'emoji': '🚲', 'benefit': 'Zero emissions'},
        {'habit': 'Use public transport', 'emoji': '🚌', 'benefit': 'Less cars on road'},
        {'habit': 'Carpool with friends', 'emoji': '🚗', 'benefit': 'Share the ride'},
        {'habit': 'Turn off car engine at signals', 'emoji': '🚦', 'benefit': 'Save fuel'},
      ],
    },
    {
      'title': 'Protect Nature',
      'emoji': '🦋',
      'color': Color(0xFFAB47BC),
      'habits': [
        {'habit': 'Never litter', 'emoji': '🚯', 'why': 'Keep nature clean'},
        {'habit': 'Pick up trash you see', 'emoji': '🧹', 'why': 'Be a cleanup hero'},
        {'habit': 'Don\'t disturb wildlife', 'emoji': '🦊', 'why': 'Let animals live peacefully'},
        {'habit': 'Feed birds and animals', 'emoji': '🐦', 'why': 'Help them survive'},
        {'habit': 'Use eco-friendly products', 'emoji': '🧴', 'why': 'Less chemicals'},
        {'habit': 'Respect all living things', 'emoji': '🌺', 'why': 'Everything has a purpose'},
      ],
    },
    {
      'title': 'Daily Pledge',
      'emoji': '✋',
      'color': Color(0xFFEC407A),
      'pledges': [
        'I will save water every day',
        'I will turn off lights when not needed',
        'I will not waste food',
        'I will plant trees and plants',
        'I will not litter',
        'I will protect animals and birds',
        'I will teach others to go green',
        'I am an Earth Protector! 🌍',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final category = categories[currentCategory];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Sustainable Habits',
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
              _buildCategoryChips(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildCategoryContent(category),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = index == currentCategory;
          return GestureDetector(
            onTap: () => setState(() => currentCategory = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat['emoji'], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    cat['title'],
                    style: GoogleFonts.poppins(
                      color: isSelected ? cat['color'] : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryContent(Map<String, dynamic> category) {
    return Column(
      children: [
        const SizedBox(height: 16),
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
              Text(category['emoji'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                category['title'],
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: category['color'],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (category.containsKey('habits')) _buildHabitCards(category),
        if (category.containsKey('pledges')) _buildPledgeCards(category),
      ],
    );
  }

  Widget _buildHabitCards(Map<String, dynamic> category) {
    return Column(
      children: (category['habits'] as List).map<Widget>((habit) {
        final extraInfo = habit['saves'] ?? habit['impact'] ?? habit['benefit'] ?? habit['why'] ?? '';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: category['color'].withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: category['color'].withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(habit['emoji'], style: const TextStyle(fontSize: 28)),
              ),
            ),
            title: Text(
              habit['habit'],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              extraInfo,
              style: GoogleFonts.nunito(
                color: category['color'],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.eco, color: Colors.green, size: 20),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPledgeCards(Map<String, dynamic> category) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'My Green Pledge',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: category['color'],
            ),
          ),
          const SizedBox(height: 16),
          ...(category['pledges'] as List).asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final pledge = entry.value;
            final isLast = index == (category['pledges'] as List).length - 1;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isLast
                    ? category['color'].withValues(alpha: 0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: isLast
                    ? Border.all(color: category['color'], width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isLast ? category['color'] : Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isLast
                          ? const Text('🌟', style: TextStyle(fontSize: 16))
                          : const Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pledge,
                      style: GoogleFonts.nunito(
                        fontWeight: isLast ? FontWeight.bold : FontWeight.w600,
                        color: isLast ? category['color'] : Colors.grey.shade700,
                        fontSize: isLast ? 16 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Get.snackbar(
                '🌍 Congratulations!',
                'You are now an Earth Protector!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            icon: const Text('✋', style: TextStyle(fontSize: 20)),
            label: Text(
              'I Take This Pledge!',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: category['color'],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
