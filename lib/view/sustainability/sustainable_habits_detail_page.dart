import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class SustainableHabitsDetailPage extends StatefulWidget {
  final int sectionIndex;

  const SustainableHabitsDetailPage({super.key, required this.sectionIndex});

  @override
  State<SustainableHabitsDetailPage> createState() =>
      _SustainableHabitsDetailPageState();
}

class _SustainableHabitsDetailPageState
    extends State<SustainableHabitsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Save Water',
      'emoji': '💧',
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
      'habits': [
        {'habit': 'Plant a tree or flower', 'emoji': '🌳', 'saves': 'Clean air'},
        {'habit': 'Take care of plants at home', 'emoji': '🪴', 'saves': 'Fresh oxygen'},
        {'habit': 'Don\'t pick flowers from gardens', 'emoji': '🌸', 'saves': 'Let them bloom'},
        {'habit': 'Make compost from food scraps', 'emoji': '🥕', 'saves': 'Natural fertilizer'},
        {'habit': 'Grow your own vegetables', 'emoji': '🥬', 'saves': 'Fresh and healthy'},
        {'habit': 'Create a small garden', 'emoji': '🏡', 'saves': 'Green space'},
      ],
    },
    {
      'title': 'Clean Travel',
      'emoji': '🚲',
      'habits': [
        {'habit': 'Walk to nearby places', 'emoji': '🚶', 'saves': 'No pollution + exercise'},
        {'habit': 'Ride a bicycle', 'emoji': '🚲', 'saves': 'Zero emissions'},
        {'habit': 'Use public transport', 'emoji': '🚌', 'saves': 'Less cars on road'},
        {'habit': 'Carpool with friends', 'emoji': '🚗', 'saves': 'Share the ride'},
        {'habit': 'Turn off car engine at signals', 'emoji': '🚦', 'saves': 'Save fuel'},
      ],
    },
    {
      'title': 'Protect Nature',
      'emoji': '🦋',
      'habits': [
        {'habit': 'Never litter', 'emoji': '🚯', 'saves': 'Keep nature clean'},
        {'habit': 'Pick up trash you see', 'emoji': '🧹', 'saves': 'Be a cleanup hero'},
        {'habit': 'Don\'t disturb wildlife', 'emoji': '🦊', 'saves': 'Let animals live peacefully'},
        {'habit': 'Feed birds and animals', 'emoji': '🐦', 'saves': 'Help them survive'},
        {'habit': 'Use eco-friendly products', 'emoji': '🧴', 'saves': 'Less chemicals'},
        {'habit': 'Respect all living things', 'emoji': '🌺', 'saves': 'Everything has a purpose'},
      ],
    },
    {
      'title': 'Daily Pledge',
      'emoji': '✋',
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
    final section = sections[widget.sectionIndex];
    return GradientScaffold(
      title: section['title'] ?? '',
      emoji: section['emoji'] ?? '',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: widget.sectionIndex == 6
            ? _buildPledgeSection(section)
            : _buildHabitsSection(section),
      ),
    );
  }

  Widget _buildGradientItem({
    required int itemIndex,
    required Widget child,
  }) {
    final gradient = AppColors.getGradientForIndex(itemIndex);
    return buildFloatingItem(
      index: itemIndex,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildHabitsSection(Map<String, dynamic> section) {
    final habits = section['habits'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: habits.map<Widget>((habit) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      habit['emoji'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['habit'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          habit['saves'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPledgeSection(Map<String, dynamic> section) {
    final pledges = section['pledges'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: [
        ...pledges.map<Widget>((pledge) {
          final idx = itemIndex++;
          final isLast = idx == pledges.length - 1;
          return _buildGradientItem(
            itemIndex: idx,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isLast
                          ? const Text('🌟', style: TextStyle(fontSize: 20))
                          : const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      pledge ?? '',
                      style: GoogleFonts.nunito(
                        fontSize: isLast ? 18 : 16,
                        fontWeight:
                            isLast ? FontWeight.bold : FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
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
            backgroundColor: Colors.white,
            foregroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
