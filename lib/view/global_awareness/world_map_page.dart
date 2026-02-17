import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorldMapPage extends StatefulWidget {
  const WorldMapPage({super.key});

  @override
  State<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
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
          'color': Color(0xFFE91E63),
          'countries': '48 countries'
        },
        {
          'name': 'Africa',
          'emoji': '🌍',
          'fact': 'Has the Sahara Desert',
          'color': Color(0xFFFF9800),
          'countries': '54 countries'
        },
        {
          'name': 'North America',
          'emoji': '🌎',
          'fact': 'Has the Grand Canyon',
          'color': Color(0xFF9C27B0),
          'countries': '23 countries'
        },
        {
          'name': 'South America',
          'emoji': '🌎',
          'fact': 'Amazon Rainforest is here',
          'color': Color(0xFF4CAF50),
          'countries': '12 countries'
        },
        {
          'name': 'Europe',
          'emoji': '🏰',
          'fact': 'Many old castles',
          'color': Color(0xFF3F51B5),
          'countries': '44 countries'
        },
        {
          'name': 'Australia/Oceania',
          'emoji': '🦘',
          'fact': 'Island continent',
          'color': Color(0xFF00BCD4),
          'countries': '14 countries'
        },
        {
          'name': 'Antarctica',
          'emoji': '🐧',
          'fact': 'Coldest & covered in ice',
          'color': Color(0xFF607D8B),
          'countries': 'No countries!'
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
          'animals': ['Whales', 'Dolphins', 'Sea Turtles']
        },
        {
          'name': 'Atlantic Ocean',
          'emoji': '🦈',
          'fact': 'Second largest ocean',
          'animals': ['Sharks', 'Swordfish', 'Manatees']
        },
        {
          'name': 'Indian Ocean',
          'emoji': '🐠',
          'fact': 'Warmest ocean',
          'animals': ['Coral Fish', 'Rays', 'Seahorses']
        },
        {
          'name': 'Southern Ocean',
          'emoji': '🐧',
          'fact': 'Around Antarctica',
          'animals': ['Penguins', 'Seals', 'Krill']
        },
        {
          'name': 'Arctic Ocean',
          'emoji': '🐻‍❄️',
          'fact': 'Smallest & coldest',
          'animals': ['Polar Bears', 'Walrus', 'Narwhals']
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
        {'name': 'North', 'emoji': '⬆️', 'symbol': 'N', 'color': Color(0xFF2196F3)},
        {'name': 'South', 'emoji': '⬇️', 'symbol': 'S', 'color': Color(0xFFE91E63)},
        {'name': 'East', 'emoji': '➡️', 'symbol': 'E', 'color': Color(0xFF4CAF50)},
        {'name': 'West', 'emoji': '⬅️', 'symbol': 'W', 'color': Color(0xFFFF9800)},
      ],
      'tip': 'The sun rises in the East and sets in the West!',
    },
    {
      'title': 'Map Symbols',
      'emoji': '📍',
      'color': Color(0xFF9C27B0),
      'description': 'Maps use symbols to show different things. Learn these symbols!',
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
          'color': Color(0xFFE53935)
        },
        {
          'name': 'Prime Meridian',
          'emoji': '🕐',
          'desc': 'Vertical line at 0° - divides East and West',
          'color': Color(0xFF4CAF50)
        },
        {
          'name': 'Tropic of Cancer',
          'emoji': '☀️',
          'desc': 'North of Equator - hot climate',
          'color': Color(0xFFFF9800)
        },
        {
          'name': 'Tropic of Capricorn',
          'emoji': '☀️',
          'desc': 'South of Equator - hot climate',
          'color': Color(0xFFFF9800)
        },
        {
          'name': 'Arctic Circle',
          'emoji': '❄️',
          'desc': 'Very cold, near North Pole',
          'color': Color(0xFF03A9F4)
        },
        {
          'name': 'Antarctic Circle',
          'emoji': '🧊',
          'desc': 'Very cold, near South Pole',
          'color': Color(0xFF03A9F4)
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
          'color': Color(0xFFE91E63)
        },
        {
          'type': 'Physical Map',
          'emoji': '🏔️',
          'shows': 'Mountains, rivers, lakes',
          'color': Color(0xFF4CAF50)
        },
        {
          'type': 'Climate Map',
          'emoji': '🌡️',
          'shows': 'Weather patterns',
          'color': Color(0xFFFF9800)
        },
        {
          'type': 'Road Map',
          'emoji': '🛣️',
          'shows': 'Streets and highways',
          'color': Color(0xFF9C27B0)
        },
        {
          'type': 'Treasure Map',
          'emoji': '🗺️',
          'shows': 'Where to find treasure!',
          'color': Color(0xFFFFD54F)
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
          'desc': 'Look for India on a map!'
        },
        {
          'activity': 'Count Oceans',
          'emoji': '🌊',
          'desc': 'Point to all 5 oceans'
        },
        {
          'activity': 'Name Continents',
          'emoji': '🌍',
          'desc': 'Can you name all 7?'
        },
        {
          'activity': 'Draw a Map',
          'emoji': '✏️',
          'desc': 'Draw your home to school route'
        },
        {
          'activity': 'Virtual Travel',
          'emoji': '✈️',
          'desc': 'Plan a trip on the map!'
        },
      ],
      'funFact':
          'If you could travel at the speed of light, it would take 0.13 seconds to go around the Earth!',
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
          'World Map',
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressDots(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: _buildSectionContent(section),
                ),
              ),
              _buildNavigationButtons(section),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProgressDots() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: currentSection == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentSection == index
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
    switch (currentSection) {
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
        return SizedBox.shrink();
    }
  }

  Widget _buildIntroSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: List.generate(section['mapElements'].length, (index) {
            final element = section['mapElements'][index];
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(element['emoji'], style: TextStyle(fontSize: 36)),
                  SizedBox(height: 8),
                  Text(
                    element['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                  ),
                  Text(
                    element['desc'],
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildContinentsSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          '7 Great Land Masses',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['continents'].length, (index) {
          final continent = section['continents'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: continent['color'], width: 2),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: continent['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(continent['emoji'], style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        continent['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: continent['color'],
                        ),
                      ),
                      Text(
                        continent['fact'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        continent['countries'],
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          '5 Great Bodies of Water',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['oceans'].length, (index) {
          final ocean = section['oceans'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(ocean['emoji'], style: TextStyle(fontSize: 32)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ocean['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: section['color'],
                            ),
                          ),
                          Text(
                            ocean['fact'],
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: List.generate(ocean['animals'].length, (i) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: section['color'].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ocean['animals'][i],
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: section['color'],
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
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDirectionItem(section['directions'][0]),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDirectionItem(section['directions'][3]),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.explore, color: Colors.white, size: 40),
                  ),
                  _buildDirectionItem(section['directions'][2]),
                ],
              ),
              _buildDirectionItem(section['directions'][1]),
            ],
          ),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text('☀️', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
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

  Widget _buildDirectionItem(Map<String, dynamic> direction) {
    return Column(
      children: [
        Text(direction['emoji'], style: TextStyle(fontSize: 28)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: direction['color'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            direction['symbol'],
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          direction['name'],
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: direction['color'],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSymbolsSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2,
          children: List.generate(section['symbols'].length, (index) {
            final symbol = section['symbols'][index];
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(symbol['symbol'], style: TextStyle(fontSize: 28)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      symbol['means'],
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLinesSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Important lines on the map!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['lines'].length, (index) {
          final line = section['lines'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: line['color'], width: 4)),
            ),
            child: Row(
              children: [
                Text(line['emoji'], style: TextStyle(fontSize: 28)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: line['color'],
                        ),
                      ),
                      Text(
                        line['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
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
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Different maps show different things!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['mapTypes'].length, (index) {
          final mapType = section['mapTypes'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: mapType['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(mapType['emoji'], style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mapType['type'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: mapType['color'],
                        ),
                      ),
                      Text(
                        'Shows: ${mapType['shows']}',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
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
        Text(section['emoji'], style: TextStyle(fontSize: 80)),
        SizedBox(height: 16),
        Text(
          section['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Fun activities to try!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['activities'].length, (index) {
          final activity = section['activities'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(activity['emoji'], style: TextStyle(fontSize: 24)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['activity'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        activity['desc'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text('🚀', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
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

  Widget _buildNavigationButtons(Map<String, dynamic> section) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentSection > 0)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    currentSection--;
                  });
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          if (currentSection > 0) SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                if (currentSection < sections.length - 1) {
                  setState(() {
                    currentSection++;
                  });
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                currentSection < sections.length - 1
                    ? Icons.arrow_forward
                    : Icons.check_circle,
              ),
              label: Text(
                currentSection < sections.length - 1 ? 'Next' : 'Done',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'] as Color,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
