import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RecyclingKidsPage extends StatefulWidget {
  const RecyclingKidsPage({super.key});

  @override
  State<RecyclingKidsPage> createState() => _RecyclingKidsPageState();
}

class _RecyclingKidsPageState extends State<RecyclingKidsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Recycling?',
      'emoji': '♻️',
      'color': Color(0xFF66BB6A),
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
      'color': Color(0xFF42A5F5),
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
      'color': Color(0xFFFF7043),
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
      'color': Color(0xFF26A69A),
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
      'color': Color(0xFFEF5350),
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
      'color': Color(0xFFAB47BC),
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
      'color': Color(0xFFFFB74D),
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
  Widget build(BuildContext context) {
    final section = sections[currentSection];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Recycling for Kids',
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
        if (section.containsKey('items')) _buildItemsCards(section),
        if (section.containsKey('bins')) _buildBinCards(section),
        if (section.containsKey('recyclable')) _buildRecyclableCards(section),
        if (section.containsKey('notRecyclable')) _buildNotRecyclableCards(section),
        if (section.containsKey('projects')) _buildProjectCards(section),
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

  Widget _buildItemsCards(Map<String, dynamic> section) {
    return Column(
      children: (section['items'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(item['emoji'], style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              Text(
                item['name'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
              ),
              Text(
                item['meaning'],
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['example'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
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

  Widget _buildBinCards(Map<String, dynamic> section) {
    return Column(
      children: (section['bins'] as List).map<Widget>((bin) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(bin['emoji'], style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bin['color']} Bin',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      bin['for'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(bin['items'], style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecyclableCards(Map<String, dynamic> section) {
    return Column(
      children: (section['recyclable'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(item['emoji'], style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['item'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      item['tip'],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('✅', style: TextStyle(fontSize: 24)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotRecyclableCards(Map<String, dynamic> section) {
    return Column(
      children: (section['notRecyclable'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(item['emoji'], style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['item'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      item['why'],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('❌', style: TextStyle(fontSize: 24)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjectCards(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: (section['projects'] as List).length,
      itemBuilder: (context, index) {
        final project = section['projects'][index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(project['emoji'], style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                project['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'From: ${project['from']}',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).asMap().entries.map<Widget>((entry) {
        final tip = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
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
                child: Text(
                  tip['tip'],
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
