import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class RecyclingKidsDetailPage extends StatefulWidget {
  final int sectionIndex;

  const RecyclingKidsDetailPage({super.key, required this.sectionIndex});

  @override
  State<RecyclingKidsDetailPage> createState() =>
      _RecyclingKidsDetailPageState();
}

class _RecyclingKidsDetailPageState extends State<RecyclingKidsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Recycling?',
      'emoji': '♻️',
      'content': [
        {'icon': '🔄', 'text': 'Recycling means turning old things into new things'},
        {'icon': '🌍', 'text': 'It helps keep our Earth clean and healthy'},
        {'icon': '🗑️', 'text': 'Instead of throwing things away, we give them a new life'},
        {'icon': '🏭', 'text': 'Old materials go to special factories to become new items'},
        {'icon': '💚', 'text': 'Recycling is one of the best ways to help our planet!'},
      ],
    },
    {
      'title': 'The 3 R\'s',
      'emoji': '🌟',
      'items': [
        {
          'name': 'Reduce',
          'emoji': '📉',
          'meaning': 'Use less stuff',
          'example': 'Use a reusable water bottle instead of buying plastic bottles',
        },
        {
          'name': 'Reuse',
          'emoji': '🔁',
          'meaning': 'Use things again',
          'example': 'Use old jars to store things, make toys from boxes',
        },
        {
          'name': 'Recycle',
          'emoji': '♻️',
          'meaning': 'Turn old things into new things',
          'example': 'Put paper, plastic, and metal in recycling bins',
        },
      ],
    },
    {
      'title': 'Recycling Bins',
      'emoji': '🗑️',
      'bins': [
        {'color': 'Blue', 'emoji': '🔵', 'for': 'Paper & Cardboard', 'items': '📄 📰 📦'},
        {'color': 'Green', 'emoji': '🟢', 'for': 'Glass', 'items': '🍾 🥃 🫙'},
        {'color': 'Yellow', 'emoji': '🟡', 'for': 'Plastic & Metal', 'items': '🥤 🥫 🍶'},
        {'color': 'Brown/Green', 'emoji': '🟤', 'for': 'Food Waste', 'items': '🍎 🥕 🍌'},
        {'color': 'Black/Grey', 'emoji': '⚫', 'for': 'General Waste', 'items': '🧹'},
      ],
    },
    {
      'title': 'What Can Be Recycled?',
      'emoji': '✅',
      'recyclable': [
        {'item': 'Paper', 'emoji': '📄', 'tip': 'Newspapers, magazines, notebooks'},
        {'item': 'Cardboard', 'emoji': '📦', 'tip': 'Boxes, packaging'},
        {'item': 'Plastic Bottles', 'emoji': '🍶', 'tip': 'Water and juice bottles'},
        {'item': 'Glass Bottles', 'emoji': '🍾', 'tip': 'Jam jars, sauce bottles'},
        {'item': 'Metal Cans', 'emoji': '🥫', 'tip': 'Food tins, drink cans'},
        {'item': 'Clothes', 'emoji': '👕', 'tip': 'Donate or recycle old clothes'},
      ],
    },
    {
      'title': 'Not Recyclable',
      'emoji': '❌',
      'notRecyclable': [
        {'item': 'Food-stained paper', 'emoji': '🍕', 'why': 'Oil and food makes it dirty'},
        {'item': 'Styrofoam', 'emoji': '🥡', 'why': 'It\'s hard to break down'},
        {'item': 'Plastic bags', 'emoji': '🛍️', 'why': 'They jam recycling machines'},
        {'item': 'Broken glass', 'emoji': '💔', 'why': 'It can hurt workers'},
        {'item': 'Batteries', 'emoji': '🔋', 'why': 'Need special recycling'},
      ],
    },
    {
      'title': 'Fun Recycling Projects',
      'emoji': '🎨',
      'projects': [
        {'name': 'Bird Feeder', 'emoji': '🐦', 'from': 'Plastic bottle'},
        {'name': 'Pencil Holder', 'emoji': '✏️', 'from': 'Tin can'},
        {'name': 'Flower Pot', 'emoji': '🌸', 'from': 'Plastic bottle'},
        {'name': 'Robot', 'emoji': '🤖', 'from': 'Cardboard boxes'},
        {'name': 'Piggy Bank', 'emoji': '🐷', 'from': 'Plastic bottle'},
        {'name': 'Wind Chime', 'emoji': '🎐', 'from': 'Old keys and cans'},
      ],
    },
    {
      'title': 'Be a Recycling Hero!',
      'emoji': '🦸',
      'tips': [
        {'tip': 'Always check if something can be recycled before throwing it away', 'emoji': '🔍'},
        {'tip': 'Rinse containers before recycling them', 'emoji': '🚿'},
        {'tip': 'Flatten cardboard boxes to save space', 'emoji': '📦'},
        {'tip': 'Teach your friends and family about recycling', 'emoji': '👨‍👩‍👧‍👦'},
        {'tip': 'Start a recycling corner at home', 'emoji': '🏠'},
        {'tip': 'Say no to plastic bags - bring your own bag!', 'emoji': '🛍️'},
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
        child: _buildSectionContent(section),
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

  Widget _buildSectionContent(Map<String, dynamic> section) {
    switch (widget.sectionIndex) {
      case 0:
        return _buildContentSection(section);
      case 1:
        return _buildThreeRsSection(section);
      case 2:
        return _buildBinsSection(section);
      case 3:
        return _buildRecyclableSection(section);
      case 4:
        return _buildNotRecyclableSection(section);
      case 5:
        return _buildProjectsSection(section);
      case 6:
        return _buildTipsSection(section);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildContentSection(Map<String, dynamic> section) {
    final content = section['content'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: content.map<Widget>((item) {
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
                      item['icon'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item['text'] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildThreeRsSection(Map<String, dynamic> section) {
    final items = section['items'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: items.map<Widget>((item) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item['emoji'] ?? '',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['name'] ?? '',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  item['meaning'] ?? '',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item['example'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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

  Widget _buildBinsSection(Map<String, dynamic> section) {
    final bins = section['bins'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: bins.map<Widget>((bin) {
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
                      bin['emoji'] ?? '',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bin['color'] ?? ''} Bin',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        bin['for'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bin['items'] ?? '',
                        style: const TextStyle(fontSize: 18),
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

  Widget _buildRecyclableSection(Map<String, dynamic> section) {
    final recyclable = section['recyclable'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: recyclable.map<Widget>((item) {
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
                      item['emoji'] ?? '',
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
                        item['item'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        item['tip'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('✅', style: TextStyle(fontSize: 22)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotRecyclableSection(Map<String, dynamic> section) {
    final notRecyclable = section['notRecyclable'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: notRecyclable.map<Widget>((item) {
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
                      item['emoji'] ?? '',
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
                        item['item'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        item['why'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('❌', style: TextStyle(fontSize: 22)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjectsSection(Map<String, dynamic> section) {
    final projects = section['projects'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: projects.map<Widget>((project) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      project['emoji'] ?? '',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['name'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'From: ${project['from'] ?? ''}',
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

  Widget _buildTipsSection(Map<String, dynamic> section) {
    final tips = section['tips'] as List? ?? [];
    int itemIndex = 0;

    return Column(
      children: tips.map<Widget>((tip) {
        final idx = itemIndex++;
        return _buildGradientItem(
          itemIndex: idx,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      tip['emoji'] ?? '',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    tip['tip'] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
}
