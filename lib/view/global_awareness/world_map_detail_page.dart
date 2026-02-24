import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class WorldMapDetailPage extends StatefulWidget {
  final int sectionIndex;

  const WorldMapDetailPage({super.key, required this.sectionIndex});

  @override
  State<WorldMapDetailPage> createState() => _WorldMapDetailPageState();
}

class _WorldMapDetailPageState extends State<WorldMapDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> _sections = [
    {
      'title': 'The World Map',
      'emoji': '🗺️',
      'color': Color(0xFF4CAF50),
      'description':
          'A map shows us places on Earth! Let\'s learn how to read maps and explore our amazing world.',
      'mapElements': [
        {'name': 'Continents', 'emoji': '🌍', 'desc': '7 large land areas'},
        {'name': 'Oceans', 'emoji': '🌊', 'desc': '5 big water bodies'},
        {'name': 'Countries', 'emoji': '🏳️', 'desc': 'Many nations on Earth'},
        {'name': 'Cities', 'emoji': '🏙️', 'desc': 'Where people live'},
      ],
    },
    {
      'title': 'Continents',
      'emoji': '🌍',
      'color': Color(0xFF2196F3),
      'continents': [
        {
          'name': 'Asia',
          'emoji': '🌏',
          'fact': 'Largest continent!',
          'countries': '48 countries',
        },
        {
          'name': 'Africa',
          'emoji': '🌍',
          'fact': 'Has the Sahara Desert',
          'countries': '54 countries',
        },
        {
          'name': 'North America',
          'emoji': '🌎',
          'fact': 'Has the Grand Canyon',
          'countries': '23 countries',
        },
        {
          'name': 'South America',
          'emoji': '🌎',
          'fact': 'Amazon Rainforest is here',
          'countries': '12 countries',
        },
        {
          'name': 'Europe',
          'emoji': '🏰',
          'fact': 'Many old castles',
          'countries': '44 countries',
        },
        {
          'name': 'Australia/Oceania',
          'emoji': '🦘',
          'fact': 'Island continent',
          'countries': '14 countries',
        },
        {
          'name': 'Antarctica',
          'emoji': '🐧',
          'fact': 'Coldest & covered in ice',
          'countries': 'No countries!',
        },
      ],
    },
    {
      'title': 'Oceans',
      'emoji': '🌊',
      'color': Color(0xFF0277BD),
      'oceans': [
        {
          'name': 'Pacific Ocean',
          'emoji': '🐋',
          'fact': 'Largest ocean - covers 30% of Earth!',
          'animals': ['Whales', 'Dolphins', 'Sea Turtles'],
        },
        {
          'name': 'Atlantic Ocean',
          'emoji': '🦈',
          'fact': 'Second largest ocean',
          'animals': ['Sharks', 'Swordfish', 'Manatees'],
        },
        {
          'name': 'Indian Ocean',
          'emoji': '🐠',
          'fact': 'Warmest ocean',
          'animals': ['Coral Fish', 'Rays', 'Seahorses'],
        },
        {
          'name': 'Southern Ocean',
          'emoji': '🐧',
          'fact': 'Around Antarctica',
          'animals': ['Penguins', 'Seals', 'Krill'],
        },
        {
          'name': 'Arctic Ocean',
          'emoji': '🐻‍❄️',
          'fact': 'Smallest & coldest',
          'animals': ['Polar Bears', 'Walrus', 'Narwhals'],
        },
      ],
    },
    {
      'title': 'Directions',
      'emoji': '🧭',
      'color': Color(0xFFFF5722),
      'description':
          'Directions help us find our way! The compass shows 4 main directions.',
      'directions': [
        {
          'name': 'North',
          'emoji': '⬆️',
          'symbol': 'N',
          'color': Color(0xFF2196F3),
        },
        {
          'name': 'South',
          'emoji': '⬇️',
          'symbol': 'S',
          'color': Color(0xFFE91E63),
        },
        {
          'name': 'East',
          'emoji': '➡️',
          'symbol': 'E',
          'color': Color(0xFF4CAF50),
        },
        {
          'name': 'West',
          'emoji': '⬅️',
          'symbol': 'W',
          'color': Color(0xFFFF9800),
        },
      ],
      'tip': 'The sun rises in the East and sets in the West!',
    },
    {
      'title': 'Map Symbols',
      'emoji': '📍',
      'color': Color(0xFF9C27B0),
      'description':
          'Maps use symbols to show different things. Learn these symbols!',
      'symbols': [
        {'symbol': '🏔️', 'means': 'Mountains'},
        {'symbol': '🌲', 'means': 'Forests'},
        {'symbol': '🏜️', 'means': 'Deserts'},
        {'symbol': '🌊', 'means': 'Water/Rivers'},
        {'symbol': '✈️', 'means': 'Airports'},
        {'symbol': '🏥', 'means': 'Hospitals'},
        {'symbol': '🏫', 'means': 'Schools'},
        {'symbol': '🛤️', 'means': 'Railways'},
        {'symbol': '🛣️', 'means': 'Roads'},
        {'symbol': '⭐', 'means': 'Capital City'},
      ],
    },
    {
      'title': 'Special Lines',
      'emoji': '📐',
      'color': Color(0xFF673AB7),
      'lines': [
        {
          'name': 'Equator',
          'emoji': '🌡️',
          'desc': 'Middle line - divides Earth in half! It\'s very hot here.',
        },
        {
          'name': 'Prime Meridian',
          'emoji': '🕐',
          'desc': 'Vertical line at 0° - divides East and West',
        },
        {
          'name': 'Tropic of Cancer',
          'emoji': '☀️',
          'desc': 'North of Equator - hot climate',
        },
        {
          'name': 'Tropic of Capricorn',
          'emoji': '☀️',
          'desc': 'South of Equator - hot climate',
        },
        {
          'name': 'Arctic Circle',
          'emoji': '❄️',
          'desc': 'Very cold, near North Pole',
        },
        {
          'name': 'Antarctic Circle',
          'emoji': '🧊',
          'desc': 'Very cold, near South Pole',
        },
      ],
    },
    {
      'title': 'Types of Maps',
      'emoji': '🗂️',
      'color': Color(0xFF00BCD4),
      'mapTypes': [
        {
          'type': 'Political Map',
          'emoji': '🏳️',
          'shows': 'Countries and borders',
        },
        {
          'type': 'Physical Map',
          'emoji': '🏔️',
          'shows': 'Mountains, rivers, lakes',
        },
        {
          'type': 'Climate Map',
          'emoji': '🌡️',
          'shows': 'Weather patterns',
        },
        {
          'type': 'Road Map',
          'emoji': '🛣️',
          'shows': 'Streets and highways',
        },
        {
          'type': 'Treasure Map',
          'emoji': '🗺️',
          'shows': 'Where to find treasure!',
        },
      ],
    },
    {
      'title': 'Map Explorer!',
      'emoji': '🧭',
      'color': Color(0xFFFF9800),
      'activities': [
        {
          'activity': 'Find Your Country',
          'emoji': '🏠',
          'desc': 'Look for India on a map!',
        },
        {
          'activity': 'Count Oceans',
          'emoji': '🌊',
          'desc': 'Point to all 5 oceans',
        },
        {
          'activity': 'Name Continents',
          'emoji': '🌍',
          'desc': 'Can you name all 7?',
        },
        {
          'activity': 'Draw a Map',
          'emoji': '✏️',
          'desc': 'Draw your home to school route',
        },
        {
          'activity': 'Virtual Travel',
          'emoji': '✈️',
          'desc': 'Plan a trip on the map!',
        },
      ],
      'funFact':
          'If you could travel at the speed of light, it would take 0.13 seconds to go around the Earth!',
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
      title: section['title'],
      emoji: section['emoji'],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildSectionContent(section),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    switch (widget.sectionIndex) {
      case 0:
        return _buildIntroSection(section);
      case 1:
        return _buildContinentsSection(section);
      case 2:
        return _buildOceansSection(section);
      case 3:
        return _buildDirectionsSection(section);
      case 4:
        return _buildSymbolsSection(section);
      case 5:
        return _buildLinesSection(section);
      case 6:
        return _buildMapTypesSection(section);
      case 7:
        return _buildExplorerSection(section);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Builds a gradient card item with float animation (like home screen)
  Widget _buildGradientItem({
    required int index,
    required Widget child,
    double borderRadius = 20,
  }) {
    final gradient = AppColors.getGradientForIndex(index);
    return buildFloatingItem(
      index: index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 40,
                height: 40,
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
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['mapElements'].length, (index) {
          final element = section['mapElements'][index];
          return _buildGradientItem(
            index: index,
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
                      element['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        element['name'],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        element['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
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

  Widget _buildContinentsSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '7 Great Land Masses',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['continents'].length, (index) {
          final continent = section['continents'][index];
          return _buildGradientItem(
            index: index,
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
                      continent['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        continent['name'],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        continent['fact'],
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      Text(
                        continent['countries'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
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

  Widget _buildOceansSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '5 Great Bodies of Water',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['oceans'].length, (index) {
          final ocean = section['oceans'][index];
          return _buildGradientItem(
            index: index,
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
                          ocean['emoji'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ocean['name'],
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ocean['fact'],
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: List.generate(ocean['animals'].length, (i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ocean['animals'][i],
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDirectionsSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['directions'].length, (index) {
          final direction = section['directions'][index];
          return _buildGradientItem(
            index: index,
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
                      direction['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  direction['symbol'],
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  direction['name'],
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('☀️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['tip'],
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSymbolsSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['symbols'].length, (index) {
          final symbol = section['symbols'][index];
          return _buildGradientItem(
            index: index,
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
                      symbol['symbol'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  symbol['means'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLinesSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Important lines on the map!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['lines'].length, (index) {
          final line = section['lines'][index];
          return _buildGradientItem(
            index: index,
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
                      line['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line['name'],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        line['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
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

  Widget _buildMapTypesSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Different maps show different things!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['mapTypes'].length, (index) {
          final mapType = section['mapTypes'][index];
          return _buildGradientItem(
            index: index,
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
                      mapType['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mapType['type'],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Shows: ${mapType['shows']}',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
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

  Widget _buildExplorerSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Fun activities to try!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['activities'].length, (index) {
          final activity = section['activities'][index];
          return _buildGradientItem(
            index: index,
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
                      activity['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['activity'],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        activity['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('🚀', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fun Fact!',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      section['funFact'],
                      style: GoogleFonts.nunito(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
