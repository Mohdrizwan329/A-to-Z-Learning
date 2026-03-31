import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class MapsDirectionsPage extends StatefulWidget {
  const MapsDirectionsPage({super.key});

  @override
  State<MapsDirectionsPage> createState() => _MapsDirectionsPageState();
}

class _MapsDirectionsPageState extends State<MapsDirectionsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Directions',
      'emoji': '🧭',
      'color': Color(0xFF4FC3F7),
      'items': [
        {'name': 'North', 'emoji': '⬆️', 'hindi': 'उत्तर', 'tip': 'Where the sun rises is East, North is on your left'},
        {'name': 'South', 'emoji': '⬇️', 'hindi': 'दक्षिण', 'tip': 'Opposite of North'},
        {'name': 'East', 'emoji': '➡️', 'hindi': 'पूर्व', 'tip': 'Where the sun rises'},
        {'name': 'West', 'emoji': '⬅️', 'hindi': 'पश्चिम', 'tip': 'Where the sun sets'},
      ],
    },
    {
      'title': 'Left & Right',
      'emoji': '👐',
      'color': Color(0xFFFF6B6B),
      'items': [
        {'name': 'Left', 'emoji': '👈', 'hindi': 'बाएं', 'tip': 'Make an L with your left hand!'},
        {'name': 'Right', 'emoji': '👉', 'hindi': 'दाएं', 'tip': 'The hand you write with (usually)'},
        {'name': 'Straight', 'emoji': '⬆️', 'hindi': 'सीधा', 'tip': 'Go forward without turning'},
        {'name': 'Turn Around', 'emoji': '🔄', 'hindi': 'पीछे मुड़ो', 'tip': 'Go back the way you came'},
      ],
    },
    {
      'title': 'Map Symbols',
      'emoji': '🗺️',
      'color': Color(0xFF66BB6A),
      'items': [
        {'name': 'Road', 'emoji': '🛣️', 'symbol': '━━━', 'meaning': 'Path for cars and buses'},
        {'name': 'Railway', 'emoji': '🚂', 'symbol': '┼┼┼', 'meaning': 'Path for trains'},
        {'name': 'River', 'emoji': '🌊', 'symbol': '〰️', 'meaning': 'Water flowing through land'},
        {'name': 'Mountain', 'emoji': '⛰️', 'symbol': '▲', 'meaning': 'Very high land'},
        {'name': 'Forest', 'emoji': '🌲', 'symbol': '🌳🌳', 'meaning': 'Area with many trees'},
        {'name': 'Building', 'emoji': '🏢', 'symbol': '■', 'meaning': 'Houses, schools, shops'},
      ],
    },
    {
      'title': 'Places in Town',
      'emoji': '🏘️',
      'color': Color(0xFFFFB74D),
      'items': [
        {'name': 'School', 'emoji': '🏫', 'purpose': 'Where we learn'},
        {'name': 'Hospital', 'emoji': '🏥', 'purpose': 'Where doctors help sick people'},
        {'name': 'Post Office', 'emoji': '📮', 'purpose': 'Where we send letters'},
        {'name': 'Market', 'emoji': '🏪', 'purpose': 'Where we buy food and things'},
        {'name': 'Park', 'emoji': '🏞️', 'purpose': 'Where we play and relax'},
        {'name': 'Temple/Mosque/Church', 'emoji': '🛕', 'purpose': 'Where we pray'},
      ],
    },
    {
      'title': 'Reading a Map',
      'emoji': '📍',
      'color': Color(0xFFBA68C8),
      'steps': [
        {'step': 1, 'text': 'Find "You Are Here" mark', 'emoji': '📍'},
        {'step': 2, 'text': 'Look for North arrow', 'emoji': '🧭'},
        {'step': 3, 'text': 'Find where you want to go', 'emoji': '🎯'},
        {'step': 4, 'text': 'Follow the path/road', 'emoji': '👣'},
        {'step': 5, 'text': 'Look for landmarks to guide you', 'emoji': '🏛️'},
      ],
    },
    {
      'title': 'Giving Directions',
      'emoji': '🗣️',
      'color': Color(0xFF4DB6AC),
      'phrases': [
        {'phrase': 'Go straight', 'emoji': '⬆️'},
        {'phrase': 'Turn left', 'emoji': '↩️'},
        {'phrase': 'Turn right', 'emoji': '↪️'},
        {'phrase': 'It\'s next to...', 'emoji': '👉'},
        {'phrase': 'It\'s opposite to...', 'emoji': '↔️'},
        {'phrase': 'It\'s between...', 'emoji': '⬌'},
        {'phrase': 'Cross the road', 'emoji': '🚶'},
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
          'Maps & Directions',
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: index == currentSection ? 24 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: index == currentSection ? Colors.white : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(5),
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
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              Text(section['emoji'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(section['title'], style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: section['color'])),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section.containsKey('items')) _buildItemCards(section),
        if (section.containsKey('steps')) _buildStepCards(section),
        if (section.containsKey('phrases')) _buildPhraseCards(section),
      ],
    );
  }

  Widget _buildItemCards(Map<String, dynamic> section) {
    return Column(
      children: (section['items'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: section['color'].withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(item['emoji'], style: const TextStyle(fontSize: 32))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: section['color'], fontSize: 18)),
                    if (item.containsKey('hindi')) Text(item['hindi'], style: GoogleFonts.nunito(color: Colors.grey.shade600)),
                    if (item.containsKey('tip')) Text(item['tip'], style: GoogleFonts.nunito(color: Colors.grey.shade700, fontSize: 12)),
                    if (item.containsKey('meaning')) Text(item['meaning'], style: GoogleFonts.nunito(color: Colors.grey.shade700, fontSize: 12)),
                    if (item.containsKey('purpose')) Text(item['purpose'], style: GoogleFonts.nunito(color: Colors.grey.shade700, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepCards(Map<String, dynamic> section) {
    return Column(
      children: (section['steps'] as List).map<Widget>((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: section['color'], shape: BoxShape.circle),
                child: Center(child: Text('${step['step']}', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
              ),
              const SizedBox(width: 16),
              Text(step['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(child: Text(step['text'], style: GoogleFonts.nunito(fontWeight: FontWeight.w600, color: Colors.grey.shade700))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhraseCards(Map<String, dynamic> section) {
    return Column(
      children: (section['phrases'] as List).map<Widget>((phrase) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Text(phrase['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(child: Text('"${phrase['phrase']}"', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: section['color'], fontSize: 16))),
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
              onPressed: () {
                setState(() => currentSection--);
                TtsService.to.speak(sections[currentSection]['title']);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: section['color'], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )
          else const SizedBox(width: 100),
          if (currentSection < sections.length - 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() => currentSection++);
                TtsService.to.speak(sections[currentSection]['title']);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: section['color'], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.check),
              label: const Text('Done!'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
        ],
      ),
    );
  }
}
