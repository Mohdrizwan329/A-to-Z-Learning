import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ComputerAwarenessPage extends StatefulWidget {
  const ComputerAwarenessPage({super.key});

  @override
  State<ComputerAwarenessPage> createState() => _ComputerAwarenessPageState();
}

class _ComputerAwarenessPageState extends State<ComputerAwarenessPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is a Computer?',
      'emoji': '🖥️',
      'color': Color(0xFF2196F3),
      'content': 'A computer is an electronic machine that can store, process, and display information!',
      'parts': [
        {'name': 'Brain', 'computer': 'CPU', 'emoji': '🧠'},
        {'name': 'Memory', 'computer': 'RAM', 'emoji': '💭'},
        {'name': 'Storage', 'computer': 'Hard Drive', 'emoji': '📦'},
        {'name': 'Eyes', 'computer': 'Monitor', 'emoji': '👀'},
      ],
      'fact': 'The first computer was as big as a whole room!',
    },
    {
      'title': 'Computer Parts',
      'emoji': '🔧',
      'color': Color(0xFF4CAF50),
      'parts': [
        {'name': 'Monitor', 'emoji': '🖥️', 'desc': 'Shows pictures and text'},
        {'name': 'Keyboard', 'emoji': '⌨️', 'desc': 'Type letters and numbers'},
        {'name': 'Mouse', 'emoji': '🖱️', 'desc': 'Point and click on things'},
        {'name': 'CPU', 'emoji': '💻', 'desc': 'The computer\'s brain'},
        {'name': 'Speakers', 'emoji': '🔊', 'desc': 'Play sounds and music'},
        {'name': 'Webcam', 'emoji': '📷', 'desc': 'Takes pictures and video'},
      ],
    },
    {
      'title': 'Types of Computers',
      'emoji': '📱',
      'color': Color(0xFF9C27B0),
      'types': [
        {'name': 'Desktop', 'emoji': '🖥️', 'desc': 'Stays on a desk', 'good': 'Big screen, powerful'},
        {'name': 'Laptop', 'emoji': '💻', 'desc': 'Portable computer', 'good': 'Take anywhere'},
        {'name': 'Tablet', 'emoji': '📱', 'desc': 'Touch screen', 'good': 'Easy to carry'},
        {'name': 'Smartphone', 'emoji': '📲', 'desc': 'Mini computer + phone', 'good': 'Fits in pocket'},
      ],
    },
    {
      'title': 'What Can Computers Do?',
      'emoji': '✨',
      'color': Color(0xFFFF9800),
      'abilities': [
        {'action': 'Write', 'emoji': '✍️', 'example': 'Type stories and homework'},
        {'action': 'Draw', 'emoji': '🎨', 'example': 'Create digital art'},
        {'action': 'Play', 'emoji': '🎮', 'example': 'Fun games and puzzles'},
        {'action': 'Learn', 'emoji': '📚', 'example': 'Watch educational videos'},
        {'action': 'Talk', 'emoji': '💬', 'example': 'Video call friends & family'},
        {'action': 'Calculate', 'emoji': '🔢', 'example': 'Solve math problems'},
        {'action': 'Store', 'emoji': '📁', 'example': 'Keep photos and files'},
        {'action': 'Search', 'emoji': '🔍', 'example': 'Find information online'},
      ],
    },
    {
      'title': 'Taking Care of Computers',
      'emoji': '🛡️',
      'color': Color(0xFFE91E63),
      'rules': [
        {'rule': 'Keep food and drinks away', 'emoji': '🍔🚫', 'why': 'Spills can damage computers'},
        {'rule': 'Wash hands before using', 'emoji': '🧼', 'why': 'Keeps keyboard clean'},
        {'rule': 'Handle gently', 'emoji': '🤲', 'why': 'Computers are delicate'},
        {'rule': 'Turn off properly', 'emoji': '⚡', 'why': 'Helps computer last longer'},
        {'rule': 'Keep screen clean', 'emoji': '✨', 'why': 'Better to see things'},
        {'rule': 'Don\'t touch screen with fingers', 'emoji': '👆🚫', 'why': 'Leaves marks'},
      ],
    },
    {
      'title': 'Computer Words',
      'emoji': '📖',
      'color': Color(0xFF00BCD4),
      'vocabulary': [
        {'word': 'Software', 'meaning': 'Programs that run on computer', 'emoji': '💿'},
        {'word': 'Hardware', 'meaning': 'Parts you can touch', 'emoji': '🔧'},
        {'word': 'File', 'meaning': 'A saved document or picture', 'emoji': '📄'},
        {'word': 'Folder', 'meaning': 'Holds many files together', 'emoji': '📁'},
        {'word': 'Icon', 'meaning': 'Small picture you can click', 'emoji': '🖼️'},
        {'word': 'Desktop', 'meaning': 'Main screen when computer starts', 'emoji': '🏠'},
        {'word': 'Browser', 'meaning': 'Used to go on internet', 'emoji': '🌐'},
        {'word': 'Download', 'meaning': 'Get something from internet', 'emoji': '⬇️'},
      ],
    },
    {
      'title': 'Fun Computer Facts',
      'emoji': '🤓',
      'color': Color(0xFF795548),
      'facts': [
        {'fact': 'The first mouse was made of wood!', 'emoji': '🪵'},
        {'fact': 'Computers can do millions of calculations per second', 'emoji': '⚡'},
        {'fact': 'The word "bug" came from a real bug in a computer', 'emoji': '🐛'},
        {'fact': 'The first computer game was made in 1962', 'emoji': '🎮'},
        {'fact': 'Smartphones are more powerful than old supercomputers', 'emoji': '📱'},
        {'fact': 'There are over 2 billion computers in the world', 'emoji': '🌍'},
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
          'Computer Basics',
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
              Text(section['emoji'], style: const TextStyle(fontSize: 50)),
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
              if (section.containsKey('content')) ...[
                const SizedBox(height: 12),
                Text(
                  section['content'],
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section['title'] == 'What is a Computer?')
          _buildComputerIntro(section),
        if (section['title'] == 'Computer Parts')
          _buildComputerParts(section),
        if (section['title'] == 'Types of Computers')
          _buildComputerTypes(section),
        if (section['title'] == 'What Can Computers Do?')
          _buildAbilities(section),
        if (section['title'] == 'Taking Care of Computers')
          _buildCareRules(section),
        if (section['title'] == 'Computer Words')
          _buildVocabulary(section),
        if (section['title'] == 'Fun Computer Facts')
          _buildFacts(section),
      ],
    );
  }

  Widget _buildComputerIntro(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                'Computer is Like a Person!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
              ),
              const SizedBox(height: 12),
              ...(section['parts'] as List).map((part) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(part['emoji'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your ${part['name']} = Computer\'s ${part['computer']}',
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['fact'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComputerParts(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: (section['parts'] as List).length,
      itemBuilder: (context, index) {
        final part = section['parts'][index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(part['emoji'], style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                part['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
              ),
              Text(
                part['desc'],
                style: GoogleFonts.nunito(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComputerTypes(Map<String, dynamic> section) {
    return Column(
      children: (section['types'] as List).map<Widget>((type) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(type['emoji'], style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      type['desc'],
                      style: GoogleFonts.nunito(fontSize: 12),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '✓ ${type['good']}',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Colors.green.shade700,
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

  Widget _buildAbilities(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: (section['abilities'] as List).length,
      itemBuilder: (context, index) {
        final ability = section['abilities'][index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ability['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                ability['action'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
              ),
              Text(
                ability['example'],
                style: GoogleFonts.nunito(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCareRules(Map<String, dynamic> section) {
    return Column(
      children: (section['rules'] as List).map<Widget>((rule) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(rule['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule['rule'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      rule['why'],
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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

  Widget _buildVocabulary(Map<String, dynamic> section) {
    return Column(
      children: (section['vocabulary'] as List).map<Widget>((vocab) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(vocab['emoji'], style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vocab['word'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                    Text(
                      vocab['meaning'],
                      style: GoogleFonts.nunito(fontSize: 12),
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

  Widget _buildFacts(Map<String, dynamic> section) {
    return Column(
      children: (section['facts'] as List).asMap().entries.map<Widget>((entry) {
        final fact = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: section['color'],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  fact['fact'],
                  style: GoogleFonts.nunito(fontSize: 14),
                ),
              ),
              Text(fact['emoji'], style: const TextStyle(fontSize: 24)),
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
