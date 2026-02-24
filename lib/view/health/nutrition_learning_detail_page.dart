import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class NutritionLearningDetailPage extends StatefulWidget {
  final int sectionIndex;

  const NutritionLearningDetailPage({super.key, required this.sectionIndex});

  @override
  State<NutritionLearningDetailPage> createState() =>
      _NutritionLearningDetailPageState();
}

class _NutritionLearningDetailPageState
    extends State<NutritionLearningDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Nutrition?',
      'emoji': '🥗',
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
      'groups': [
        {
          'name': 'Fruits & Vegetables',
          'emoji': '🥕🍇',
          'foods': ['Apple', 'Banana', 'Carrot', 'Spinach'],
          'benefit': 'Vitamins & Fiber',
        },
        {
          'name': 'Grains',
          'emoji': '🍞🍚',
          'foods': ['Rice', 'Bread', 'Roti', 'Oats'],
          'benefit': 'Energy',
        },
        {
          'name': 'Protein',
          'emoji': '🥚🫘',
          'foods': ['Eggs', 'Dal', 'Chicken', 'Fish'],
          'benefit': 'Muscle Building',
        },
        {
          'name': 'Dairy',
          'emoji': '🥛🧀',
          'foods': ['Milk', 'Cheese', 'Yogurt', 'Paneer'],
          'benefit': 'Strong Bones',
        },
      ],
    },
    {
      'title': 'Important Nutrients',
      'emoji': '💊',
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
      'plate': [
        {'section': 'Half Plate', 'fill': 'Vegetables & Fruits', 'emoji': '🥗🍎'},
        {'section': 'Quarter', 'fill': 'Grains (Roti/Rice)', 'emoji': '🍚'},
        {'section': 'Quarter', 'fill': 'Protein (Dal/Egg)', 'emoji': '🫘'},
        {'section': 'Side', 'fill': 'Dairy (Milk/Curd)', 'emoji': '🥛'},
      ],
    },
    {
      'title': 'Healthy vs Junk',
      'emoji': '⚖️',
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
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = sections[widget.sectionIndex];
    final gradient = AppColors.getGradientForIndex(widget.sectionIndex);

    return GradientScaffold(
      title: section['title'],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main Card
            buildFloatingItem(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      section['emoji'],
                      style: const TextStyle(fontSize: 70),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      section['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Content based on type
            if (section.containsKey('content'))
              _buildContentCards(section),
            if (section.containsKey('groups'))
              _buildFoodGroupCards(section),
            if (section.containsKey('nutrients'))
              _buildNutrientCards(section),
            if (section.containsKey('plate'))
              _buildPlateCards(section),
            if (section.containsKey('comparison'))
              _buildComparisonCards(section),
            if (section.containsKey('waterFacts'))
              _buildWaterFactCards(section),
            if (section.containsKey('tips'))
              _buildTipCards(section),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['content'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final item = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(item['icon'], style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['text'],
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFoodGroupCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['groups'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final group = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(group['emoji'],
                        style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group['name'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Gives: ${group['benefit']}',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 13,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (group['foods'] as List).map<Widget>((food) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        food,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNutrientCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['nutrients'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final nutrient = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(nutrient['emoji'],
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nutrient['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        nutrient['benefit'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 13,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Found in: ${nutrient['found']}',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
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

  Widget _buildPlateCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['plate'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final item = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(item['emoji'], style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['section'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        item['fill'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 13,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
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

  Widget _buildComparisonCards(Map<String, dynamic> section) {
    final comparisons = section['comparison'] as List;
    return Column(
      children: [
        // Header
        buildFloatingItem(
          index: 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '✅ Healthy',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'vs',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                Expanded(
                  child: Text(
                    '❌ Junk',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...comparisons.asMap().entries.map<Widget>((entry) {
          final idx = entry.key;
          final item = entry.value;
          final cardGradient =
              AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
          return buildFloatingItem(
            index: idx + 2,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: cardGradient[0].withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item['healthy'],
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    'vs',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item['junk'],
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildWaterFactCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['waterFacts'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final fact = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(fact['emoji'], style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    fact['fact'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children:
          (section['tips'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final tip = entry.value;
        final cardGradient =
            AppColors.getGradientForIndex(widget.sectionIndex + idx + 1);
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        tip['why'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
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
}
