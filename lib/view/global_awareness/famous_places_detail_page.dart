import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class FamousPlacesDetailPage extends StatefulWidget {
  final int sectionIndex;

  const FamousPlacesDetailPage({super.key, required this.sectionIndex});

  @override
  State<FamousPlacesDetailPage> createState() => _FamousPlacesDetailPageState();
}

class _FamousPlacesDetailPageState extends State<FamousPlacesDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Wonders of the World',
      'emoji': '🏛️',
      'description':
          'Explore the most amazing places on Earth! These famous landmarks are visited by millions of people every year.',
      'categories': [
        {'name': 'Ancient Wonders', 'emoji': '🏛️'},
        {'name': 'Modern Wonders', 'emoji': '🏗️'},
        {'name': 'Natural Wonders', 'emoji': '🌋'},
        {'name': 'Famous Buildings', 'emoji': '🏰'},
      ],
    },
    {
      'title': 'Seven Wonders',
      'emoji': '🌟',
      'subtitle': 'New Seven Wonders of the World',
      'items': [
        {
          'name': 'Great Wall of China',
          'country': 'China',
          'flag': '🇨🇳',
          'emoji': '🧱',
          'fact': 'Over 13,000 miles long!',
        },
        {
          'name': 'Petra',
          'country': 'Jordan',
          'flag': '🇯🇴',
          'emoji': '🏛️',
          'fact': 'City carved into pink rock',
        },
        {
          'name': 'Christ the Redeemer',
          'country': 'Brazil',
          'flag': '🇧🇷',
          'emoji': '✝️',
          'fact': '98 feet tall statue',
        },
        {
          'name': 'Machu Picchu',
          'country': 'Peru',
          'flag': '🇵🇪',
          'emoji': '🏔️',
          'fact': 'Ancient Incan city in the clouds',
        },
        {
          'name': 'Chichen Itza',
          'country': 'Mexico',
          'flag': '🇲🇽',
          'emoji': '🔺',
          'fact': 'Mayan pyramid temple',
        },
        {
          'name': 'Colosseum',
          'country': 'Italy',
          'flag': '🇮🇹',
          'emoji': '🏟️',
          'fact': 'Ancient Roman arena',
        },
        {
          'name': 'Taj Mahal',
          'country': 'India',
          'flag': '🇮🇳',
          'emoji': '🕌',
          'fact': 'Made of white marble',
        },
      ],
    },
    {
      'title': 'Famous Landmarks',
      'emoji': '🗼',
      'items': [
        {
          'name': 'Eiffel Tower',
          'country': 'France',
          'flag': '🇫🇷',
          'emoji': '🗼',
          'fact': 'Made of iron, 1,063 feet tall',
        },
        {
          'name': 'Statue of Liberty',
          'country': 'USA',
          'flag': '🇺🇸',
          'emoji': '🗽',
          'fact': 'Gift from France',
        },
        {
          'name': 'Big Ben',
          'country': 'UK',
          'flag': '🇬🇧',
          'emoji': '🕰️',
          'fact': 'Famous clock tower in London',
        },
        {
          'name': 'Sydney Opera House',
          'country': 'Australia',
          'flag': '🇦🇺',
          'emoji': '🎭',
          'fact': 'Looks like sails on water',
        },
        {
          'name': 'Leaning Tower of Pisa',
          'country': 'Italy',
          'flag': '🇮🇹',
          'emoji': '🗼',
          'fact': 'It leans but doesn\'t fall!',
        },
        {
          'name': 'Burj Khalifa',
          'country': 'UAE',
          'flag': '🇦🇪',
          'emoji': '🏢',
          'fact': 'Tallest building in the world!',
        },
      ],
    },
    {
      'title': 'Natural Wonders',
      'emoji': '🌊',
      'subtitle': 'Nature\'s Amazing Creations',
      'items': [
        {
          'name': 'Grand Canyon',
          'country': 'USA',
          'flag': '🇺🇸',
          'emoji': '🏜️',
          'fact': 'Carved by the Colorado River',
        },
        {
          'name': 'Victoria Falls',
          'country': 'Zimbabwe/Zambia',
          'flag': '🇿🇼',
          'emoji': '💦',
          'fact': 'Largest waterfall by area',
        },
        {
          'name': 'Great Barrier Reef',
          'country': 'Australia',
          'flag': '🇦🇺',
          'emoji': '🐠',
          'fact': 'Largest coral reef system',
        },
        {
          'name': 'Mount Everest',
          'country': 'Nepal/Tibet',
          'flag': '🇳🇵',
          'emoji': '🏔️',
          'fact': 'Tallest mountain on Earth',
        },
        {
          'name': 'Amazon Rainforest',
          'country': 'Brazil',
          'flag': '🇧🇷',
          'emoji': '🌳',
          'fact': 'World\'s largest rainforest',
        },
        {
          'name': 'Northern Lights',
          'country': 'Arctic',
          'flag': '🌌',
          'emoji': '✨',
          'fact': 'Dancing lights in the sky',
        },
      ],
    },
    {
      'title': 'Ancient Wonders',
      'emoji': '⚱️',
      'subtitle': 'Built thousands of years ago!',
      'items': [
        {
          'name': 'Great Pyramid of Giza',
          'country': 'Egypt',
          'flag': '🇪🇬',
          'emoji': '🔺',
          'fact': 'Only ancient wonder still standing!',
        },
        {
          'name': 'Sphinx',
          'country': 'Egypt',
          'flag': '🇪🇬',
          'emoji': '🦁',
          'fact': 'Lion body with human head',
        },
        {
          'name': 'Stonehenge',
          'country': 'England',
          'flag': '🇬🇧',
          'emoji': '🪨',
          'fact': 'Mysterious stone circle',
        },
        {
          'name': 'Angkor Wat',
          'country': 'Cambodia',
          'flag': '🇰🇭',
          'emoji': '🛕',
          'fact': 'Largest religious monument',
        },
        {
          'name': 'Parthenon',
          'country': 'Greece',
          'flag': '🇬🇷',
          'emoji': '🏛️',
          'fact': 'Ancient Greek temple',
        },
      ],
    },
    {
      'title': 'Famous Castles',
      'emoji': '🏰',
      'subtitle': 'Royal homes from around the world',
      'items': [
        {
          'name': 'Neuschwanstein Castle',
          'country': 'Germany',
          'flag': '🇩🇪',
          'emoji': '🏰',
          'fact': 'Inspired Disney Castle!',
        },
        {
          'name': 'Windsor Castle',
          'country': 'England',
          'flag': '🇬🇧',
          'emoji': '🏰',
          'fact': 'Where the King lives!',
        },
        {
          'name': 'Palace of Versailles',
          'country': 'France',
          'flag': '🇫🇷',
          'emoji': '🏰',
          'fact': 'Has 2,300 rooms!',
        },
        {
          'name': 'Himeji Castle',
          'country': 'Japan',
          'flag': '🇯🇵',
          'emoji': '🏰',
          'fact': 'Called the White Heron Castle',
        },
        {
          'name': 'Alhambra',
          'country': 'Spain',
          'flag': '🇪🇸',
          'emoji': '🏰',
          'fact': 'Beautiful Islamic architecture',
        },
      ],
    },
    {
      'title': 'Places in India',
      'emoji': '🇮🇳',
      'subtitle': 'Incredible India!',
      'places': [
        {
          'name': 'Taj Mahal',
          'city': 'Agra',
          'emoji': '🕌',
          'fact': 'Symbol of love, built by Shah Jahan',
        },
        {
          'name': 'Red Fort',
          'city': 'Delhi',
          'emoji': '🏰',
          'fact': 'Made of red sandstone',
        },
        {
          'name': 'Gateway of India',
          'city': 'Mumbai',
          'emoji': '🚪',
          'fact': 'Built in 1924',
        },
        {
          'name': 'Qutub Minar',
          'city': 'Delhi',
          'emoji': '🗼',
          'fact': 'Tallest brick minaret',
        },
        {
          'name': 'Hawa Mahal',
          'city': 'Jaipur',
          'emoji': '🏛️',
          'fact': 'Palace of Winds with 953 windows',
        },
        {
          'name': 'Golden Temple',
          'city': 'Amritsar',
          'emoji': '🛕',
          'fact': 'Covered in real gold!',
        },
        {
          'name': 'Mysore Palace',
          'city': 'Mysore',
          'emoji': '🏰',
          'fact': 'Beautiful lights at night',
        },
        {
          'name': 'Ajanta & Ellora Caves',
          'city': 'Maharashtra',
          'emoji': '🕳️',
          'fact': 'Ancient rock-cut caves',
        },
      ],
    },
    {
      'title': 'World Explorer Quiz!',
      'emoji': '🧭',
      'quiz': [
        {
          'question': 'Where is the Eiffel Tower?',
          'answer': 'Paris, France',
          'emoji': '🗼',
        },
        {
          'question': 'Which wonder is in India?',
          'answer': 'Taj Mahal',
          'emoji': '🕌',
        },
        {
          'question': 'What\'s the tallest mountain?',
          'answer': 'Mount Everest',
          'emoji': '🏔️',
        },
        {
          'question': 'Where are the Pyramids?',
          'answer': 'Egypt',
          'emoji': '🔺',
        },
        {
          'question': 'What inspired Disney Castle?',
          'answer': 'Neuschwanstein Castle',
          'emoji': '🏰',
        },
      ],
      'badge': 'You are now a World Explorer! Keep discovering!',
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
    final section = _sections[widget.sectionIndex];

    return GradientScaffold(
      title: section['title'] ?? '',
      emoji: section['emoji'] ?? '',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: _buildSectionContent(section),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    switch (widget.sectionIndex) {
      case 0:
        return _buildIntroSection(section);
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        return _buildPlacesSection(section);
      case 6:
        return _buildIndiaSection(section);
      case 7:
        return _buildQuizSection(section);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGradientItem({required int index, required Widget child}) {
    final gradient = AppColors.getGradientForIndex(index);
    return buildFloatingItem(
      index: index,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10.h,
              right: -10.w,
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection(Map<String, dynamic> section) {
    final categories =
        section['categories'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            section['description'] ?? '',
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        ...List.generate(categories.length, (index) {
          final category = categories[index];
          return _buildGradientItem(
            index: index,
            child: Row(
              children: [
                Container(
                  width: 55.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      category['emoji'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    category['name'] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPlacesSection(Map<String, dynamic> section) {
    final items = section['items'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        if (section['subtitle'] != null) ...[
          SizedBox(height: 8.h),
          Text(
            section['subtitle'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
        SizedBox(height: 24.h),
        ...List.generate(items.length, (index) {
          final item = items[index];
          return _buildGradientItem(
            index: index,
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item['emoji'] ?? '',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            item['flag'] ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item['country'] ?? '',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14.r, color: Colors.amber),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              item['fact'] ?? '',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[200],
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
        }),
      ],
    );
  }

  Widget _buildIndiaSection(Map<String, dynamic> section) {
    final places = section['places'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        if (section['subtitle'] != null) ...[
          SizedBox(height: 8.h),
          Text(
            section['subtitle'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
        SizedBox(height: 24.h),
        ...List.generate(places.length, (index) {
          final place = places[index];
          return _buildGradientItem(
            index: index,
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      place['emoji'] ?? '',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['name'] ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14.r,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            place['city'] ?? '',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14.r, color: Colors.amber),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              place['fact'] ?? '',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[200],
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
        }),
      ],
    );
  }

  Widget _buildQuizSection(Map<String, dynamic> section) {
    final quizItems = section['quiz'] as List<Map<String, dynamic>>? ?? [];
    return Column(
      children: [
        Text(section['emoji'] ?? '', style: const TextStyle(fontSize: 80)),
        SizedBox(height: 16.h),
        Text(
          section['title'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Test your knowledge!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24.h),
        ...List.generate(quizItems.length, (index) {
          final quiz = quizItems[index];
          return _buildGradientItem(
            index: index,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        quiz['question'] ?? '',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      quiz['emoji'] ?? '',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        quiz['answer'] ?? '',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 16.h),
        _buildGradientItem(
          index: quizItems.length,
          child: Column(
            children: [
              const Text('🏆🌍🎉', style: TextStyle(fontSize: 40)),
              SizedBox(height: 8.h),
              Text(
                section['badge'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
