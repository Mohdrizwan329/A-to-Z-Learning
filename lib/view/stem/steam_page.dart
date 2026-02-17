import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SteamPage extends StatefulWidget {
  const SteamPage({super.key});

  @override
  State<SteamPage> createState() => _SteamPageState();
}

class _SteamPageState extends State<SteamPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is STEAM?',
      'emoji': '🎨🔬',
      'color': Color(0xFFE91E63),
      'content': [
        {'letter': 'S', 'word': 'Science', 'emoji': '🔬'},
        {'letter': 'T', 'word': 'Technology', 'emoji': '💻'},
        {'letter': 'E', 'word': 'Engineering', 'emoji': '⚙️'},
        {'letter': 'A', 'word': 'Art', 'emoji': '🎨'},
        {'letter': 'M', 'word': 'Math', 'emoji': '🔢'},
      ],
      'description': 'STEAM adds Art to STEM! Creativity + Science = Amazing things!',
    },
    {
      'title': 'Color Science',
      'emoji': '🌈',
      'color': Color(0xFF9C27B0),
      'projects': [
        {
          'name': 'Chromatography Art',
          'emoji': '🖌️',
          'how': 'Separate colors in markers using water and coffee filters',
          'science': 'Different pigments travel at different speeds',
        },
        {
          'name': 'Color Mixing',
          'emoji': '🎨',
          'how': 'Mix primary colors to make new colors',
          'science': 'Light and pigments mix differently!',
        },
        {
          'name': 'Tie-Dye Patterns',
          'emoji': '👕',
          'how': 'Create patterns using dye and rubber bands',
          'science': 'Barriers control where dye goes',
        },
      ],
    },
    {
      'title': 'Nature Art',
      'emoji': '🍃',
      'color': Color(0xFF4CAF50),
      'projects': [
        {
          'name': 'Leaf Prints',
          'emoji': '🍂',
          'how': 'Paint leaves and press on paper',
          'science': 'Leaves have unique vein patterns',
        },
        {
          'name': 'Nature Collage',
          'emoji': '🌸',
          'how': 'Arrange flowers, leaves, sticks into art',
          'science': 'Symmetry and patterns in nature',
        },
        {
          'name': 'Rock Painting',
          'emoji': '🪨',
          'how': 'Paint smooth rocks with designs',
          'science': 'Rocks are formed over millions of years',
        },
      ],
    },
    {
      'title': 'Math Art',
      'emoji': '📐',
      'color': Color(0xFF2196F3),
      'projects': [
        {
          'name': 'Symmetry Art',
          'emoji': '🦋',
          'how': 'Fold paper, paint one side, press together',
          'science': 'Symmetry - both sides match!',
        },
        {
          'name': 'Tessellations',
          'emoji': '🔷',
          'how': 'Create repeating shape patterns',
          'science': 'Shapes that fit together without gaps',
        },
        {
          'name': 'Spiral Art',
          'emoji': '🌀',
          'how': 'Draw spirals using the Fibonacci sequence',
          'science': 'This pattern appears in shells and flowers!',
        },
        {
          'name': 'Geometric Shapes',
          'emoji': '📐',
          'how': 'Use ruler and compass to draw patterns',
          'science': 'Geometry creates beautiful designs',
        },
      ],
    },
    {
      'title': 'Music & Sound',
      'emoji': '🎵',
      'color': Color(0xFFFF9800),
      'projects': [
        {
          'name': 'Water Xylophone',
          'emoji': '🥛',
          'how': 'Fill glasses with different water levels',
          'science': 'Water level changes the pitch',
        },
        {
          'name': 'Rubber Band Guitar',
          'emoji': '🎸',
          'how': 'Stretch rubber bands over a box',
          'science': 'Thickness and tightness change sound',
        },
        {
          'name': 'Drum Making',
          'emoji': '🥁',
          'how': 'Cover containers with stretched material',
          'science': 'Vibrations create sound waves',
        },
      ],
    },
    {
      'title': 'Light & Shadow',
      'emoji': '💡',
      'color': Color(0xFFFFEB3B),
      'projects': [
        {
          'name': 'Shadow Puppets',
          'emoji': '🎭',
          'how': 'Cut out shapes and use a light source',
          'science': 'Light travels in straight lines',
        },
        {
          'name': 'Sun Prints',
          'emoji': '☀️',
          'how': 'Place objects on sun-sensitive paper',
          'science': 'UV light changes certain materials',
        },
        {
          'name': 'Rainbow Maker',
          'emoji': '🌈',
          'how': 'Use a prism or CD to split light',
          'science': 'White light contains all colors!',
        },
      ],
    },
    {
      'title': 'Building Art',
      'emoji': '🏗️',
      'color': Color(0xFF795548),
      'projects': [
        {
          'name': 'Paper Sculptures',
          'emoji': '📄',
          'how': 'Fold, cut, and shape paper into 3D art',
          'science': 'Engineering with paper strength',
        },
        {
          'name': 'Cardboard Creations',
          'emoji': '📦',
          'how': 'Build robots, houses, or vehicles',
          'science': 'Structural engineering principles',
        },
        {
          'name': 'Recycled Art',
          'emoji': '♻️',
          'how': 'Make art from recycled materials',
          'science': 'Sustainability and creativity combined',
        },
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
          'STEAM Learning',
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
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section.containsKey('content') && section['title'] == 'What is STEAM?')
          _buildSteamLetters(section),
        if (section.containsKey('projects'))
          _buildProjectCards(section),
      ],
    );
  }

  Widget _buildSteamLetters(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (section['content'] as List).map<Widget>((item) {
                  return Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: section['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item['letter'],
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(item['emoji'], style: const TextStyle(fontSize: 20)),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                section['description'],
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                '🎨 + 🔬 = ✨',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Art makes science creative!\nScience makes art meaningful!',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCards(Map<String, dynamic> section) {
    return Column(
      children: (section['projects'] as List).map<Widget>((project) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: section['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(project['emoji'], style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      project['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🎨', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            project['how'],
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🔬', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            project['science'],
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: section['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
