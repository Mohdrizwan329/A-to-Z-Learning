import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class SteamDetailPage extends StatefulWidget {
  final int sectionIndex;

  const SteamDetailPage({super.key, required this.sectionIndex});

  @override
  State<SteamDetailPage> createState() => _SteamDetailPageState();
}

class _SteamDetailPageState extends State<SteamDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is STEAM?',
      'emoji': '🎨🔬',
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
        child: widget.sectionIndex == 0
            ? _buildSteamIntroSection(section)
            : _buildProjectsSection(section),
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

  Widget _buildSteamIntroSection(Map<String, dynamic> section) {
    final content = section['content'] as List;
    int itemIndex = 0;

    return Column(
      children: [
        // STEAM letters
        ...content.map<Widget>((item) {
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
                        item['letter'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['word'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          item['emoji'] ?? '',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        // Description card
        _buildGradientItem(
          itemIndex: itemIndex++,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '🎨 + 🔬 = ✨',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  section['description'] ?? '',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Art makes science creative!\nScience makes art meaningful!',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                          project['emoji'] ?? '',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        project['name'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // How to do it
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎨', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          project['how'] ?? '',
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
                const SizedBox(height: 8),
                // Science behind it
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🔬', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          project['science'] ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
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
}
