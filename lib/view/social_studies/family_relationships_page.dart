import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FamilyRelationshipsPage extends StatefulWidget {
  const FamilyRelationshipsPage({super.key});

  @override
  State<FamilyRelationshipsPage> createState() => _FamilyRelationshipsPageState();
}

class _FamilyRelationshipsPageState extends State<FamilyRelationshipsPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'My Family',
      'emoji': '👨‍👩‍👧‍👦',
      'color': Color(0xFFFF6B6B),
      'members': [
        {'name': 'Mother', 'emoji': '👩', 'hindi': 'माँ (Maa)', 'role': 'Takes care of us with love'},
        {'name': 'Father', 'emoji': '👨', 'hindi': 'पिता (Pita)', 'role': 'Protects and provides for family'},
        {'name': 'Sister', 'emoji': '👧', 'hindi': 'बहन (Behen)', 'role': 'A friend to play and share with'},
        {'name': 'Brother', 'emoji': '👦', 'hindi': 'भाई (Bhai)', 'role': 'A friend to learn and grow with'},
      ],
    },
    {
      'title': 'Grandparents',
      'emoji': '👴👵',
      'color': Color(0xFF4ECDC4),
      'members': [
        {'name': 'Grandfather', 'emoji': '👴', 'hindi': 'दादा/नाना', 'role': 'Tells stories and gives wisdom'},
        {'name': 'Grandmother', 'emoji': '👵', 'hindi': 'दादी/नानी', 'role': 'Cooks yummy food and gives hugs'},
      ],
    },
    {
      'title': 'Extended Family',
      'emoji': '👥',
      'color': Color(0xFF45B7D1),
      'members': [
        {'name': 'Uncle', 'emoji': '👨', 'hindi': 'चाचा/मामा', 'role': 'Father\'s or Mother\'s brother'},
        {'name': 'Aunt', 'emoji': '👩', 'hindi': 'चाची/मामी', 'role': 'Father\'s or Mother\'s sister'},
        {'name': 'Cousin', 'emoji': '🧒', 'hindi': 'चचेरा भाई/बहन', 'role': 'Uncle or Aunt\'s children'},
      ],
    },
    {
      'title': 'Family Values',
      'emoji': '❤️',
      'color': Color(0xFF9B59B6),
      'values': [
        {'name': 'Love', 'emoji': '💕', 'meaning': 'Care for each other always'},
        {'name': 'Respect', 'emoji': '🙏', 'meaning': 'Listen and be polite to elders'},
        {'name': 'Sharing', 'emoji': '🤝', 'meaning': 'Share toys, food, and happiness'},
        {'name': 'Helping', 'emoji': '🤲', 'meaning': 'Help with chores and tasks'},
        {'name': 'Honesty', 'emoji': '✨', 'meaning': 'Always tell the truth'},
      ],
    },
    {
      'title': 'Types of Families',
      'emoji': '🏠',
      'color': Color(0xFFF39C12),
      'types': [
        {'name': 'Nuclear Family', 'emoji': '👨‍👩‍👧', 'desc': 'Parents and children living together'},
        {'name': 'Joint Family', 'emoji': '👨‍👩‍👧‍👦👴👵', 'desc': 'Grandparents, parents, and children together'},
        {'name': 'Single Parent', 'emoji': '👩‍👧', 'desc': 'One parent taking care of children'},
        {'name': 'Extended Family', 'emoji': '👥', 'desc': 'Relatives living together or nearby'},
      ],
    },
    {
      'title': 'Being a Good Family Member',
      'emoji': '🌟',
      'color': Color(0xFF1ABC9C),
      'tips': [
        {'emoji': '👂', 'tip': 'Listen to your parents and elders'},
        {'emoji': '🤗', 'tip': 'Give hugs and say "I love you"'},
        {'emoji': '🧹', 'tip': 'Help with household chores'},
        {'emoji': '📚', 'tip': 'Do your homework on time'},
        {'emoji': '😊', 'tip': 'Be kind to your siblings'},
        {'emoji': '🙏', 'tip': 'Say please and thank you'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

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
          'Family & Relationships',
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
        GestureDetector(
          onTap: () => _speak(section['title']),
          child: Container(
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
        ),
        const SizedBox(height: 20),
        if (section.containsKey('members')) ..._buildMemberCards(section),
        if (section.containsKey('values')) ..._buildValueCards(section),
        if (section.containsKey('types')) ..._buildTypeCards(section),
        if (section.containsKey('tips')) ..._buildTipCards(section),
      ],
    );
  }

  List<Widget> _buildMemberCards(Map<String, dynamic> section) {
    return (section['members'] as List).map<Widget>((member) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Text(member['emoji'], style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: section['color'], fontSize: 18)),
                  Text(member['hindi'], style: GoogleFonts.nunito(color: Colors.grey.shade600, fontSize: 14)),
                  Text(member['role'], style: GoogleFonts.nunito(color: Colors.grey.shade700, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildValueCards(Map<String, dynamic> section) {
    return (section['values'] as List).map<Widget>((value) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Text(value['emoji'], style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: section['color'])),
                  Text(value['meaning'], style: GoogleFonts.nunito(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildTypeCards(Map<String, dynamic> section) {
    return (section['types'] as List).map<Widget>((type) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Text(type['emoji'], style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: section['color'])),
                  Text(type['desc'], style: GoogleFonts.nunito(color: Colors.grey.shade700, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildTipCards(Map<String, dynamic> section) {
    return (section['tips'] as List).map<Widget>((tip) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(child: Text(tip['tip'], style: GoogleFonts.nunito(color: Colors.grey.shade700, fontWeight: FontWeight.w600))),
          ],
        ),
      );
    }).toList();
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: section['color'], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )
          else const SizedBox(width: 100),
          if (currentSection < sections.length - 1)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection++),
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
