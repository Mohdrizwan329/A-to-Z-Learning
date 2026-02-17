import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FamousPlacesPage extends StatefulWidget {
  const FamousPlacesPage({super.key});

  @override
  State<FamousPlacesPage> createState() => _FamousPlacesPageState();
}

class _FamousPlacesPageState extends State<FamousPlacesPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Wonders of the World',
      'emoji': '🏛️',
      'color': Color(0xFF673AB7),
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
      'color': Color(0xFFE91E63),
      'wonders': [
        {
          'name': 'Great Wall of China',
          'country': 'China',
          'flag': '🇨🇳',
          'emoji': '🧱',
          'fact': 'Over 13,000 miles long!'
        },
        {
          'name': 'Petra',
          'country': 'Jordan',
          'flag': '🇯🇴',
          'emoji': '🏛️',
          'fact': 'City carved into pink rock'
        },
        {
          'name': 'Christ the Redeemer',
          'country': 'Brazil',
          'flag': '🇧🇷',
          'emoji': '✝️',
          'fact': '98 feet tall statue'
        },
        {
          'name': 'Machu Picchu',
          'country': 'Peru',
          'flag': '🇵🇪',
          'emoji': '🏔️',
          'fact': 'Ancient Incan city in the clouds'
        },
        {
          'name': 'Chichen Itza',
          'country': 'Mexico',
          'flag': '🇲🇽',
          'emoji': '🔺',
          'fact': 'Mayan pyramid temple'
        },
        {
          'name': 'Colosseum',
          'country': 'Italy',
          'flag': '🇮🇹',
          'emoji': '🏟️',
          'fact': 'Ancient Roman arena'
        },
        {
          'name': 'Taj Mahal',
          'country': 'India',
          'flag': '🇮🇳',
          'emoji': '🕌',
          'fact': 'Made of white marble'
        },
      ],
    },
    {
      'title': 'Famous Landmarks',
      'emoji': '🗼',
      'color': Color(0xFF2196F3),
      'landmarks': [
        {
          'name': 'Eiffel Tower',
          'country': 'France',
          'flag': '🇫🇷',
          'emoji': '🗼',
          'fact': 'Made of iron, 1,063 feet tall'
        },
        {
          'name': 'Statue of Liberty',
          'country': 'USA',
          'flag': '🇺🇸',
          'emoji': '🗽',
          'fact': 'Gift from France'
        },
        {
          'name': 'Big Ben',
          'country': 'UK',
          'flag': '🇬🇧',
          'emoji': '🕰️',
          'fact': 'Famous clock tower in London'
        },
        {
          'name': 'Sydney Opera House',
          'country': 'Australia',
          'flag': '🇦🇺',
          'emoji': '🎭',
          'fact': 'Looks like sails on water'
        },
        {
          'name': 'Leaning Tower of Pisa',
          'country': 'Italy',
          'flag': '🇮🇹',
          'emoji': '🗼',
          'fact': 'It leans but doesn\'t fall!'
        },
        {
          'name': 'Burj Khalifa',
          'country': 'UAE',
          'flag': '🇦🇪',
          'emoji': '🏢',
          'fact': 'Tallest building in the world!'
        },
      ],
    },
    {
      'title': 'Natural Wonders',
      'emoji': '🌊',
      'color': Color(0xFF4CAF50),
      'wonders': [
        {
          'name': 'Grand Canyon',
          'country': 'USA',
          'flag': '🇺🇸',
          'emoji': '🏜️',
          'fact': 'Carved by the Colorado River'
        },
        {
          'name': 'Victoria Falls',
          'country': 'Zimbabwe/Zambia',
          'flag': '🇿🇼',
          'emoji': '💦',
          'fact': 'Largest waterfall by area'
        },
        {
          'name': 'Great Barrier Reef',
          'country': 'Australia',
          'flag': '🇦🇺',
          'emoji': '🐠',
          'fact': 'Largest coral reef system'
        },
        {
          'name': 'Mount Everest',
          'country': 'Nepal/Tibet',
          'flag': '🇳🇵',
          'emoji': '🏔️',
          'fact': 'Tallest mountain on Earth'
        },
        {
          'name': 'Amazon Rainforest',
          'country': 'Brazil',
          'flag': '🇧🇷',
          'emoji': '🌳',
          'fact': 'World\'s largest rainforest'
        },
        {
          'name': 'Northern Lights',
          'country': 'Arctic',
          'flag': '🌌',
          'emoji': '✨',
          'fact': 'Dancing lights in the sky'
        },
      ],
    },
    {
      'title': 'Ancient Wonders',
      'emoji': '⚱️',
      'color': Color(0xFFFF9800),
      'wonders': [
        {
          'name': 'Great Pyramid of Giza',
          'country': 'Egypt',
          'flag': '🇪🇬',
          'emoji': '🔺',
          'fact': 'Only ancient wonder still standing!'
        },
        {
          'name': 'Sphinx',
          'country': 'Egypt',
          'flag': '🇪🇬',
          'emoji': '🦁',
          'fact': 'Lion body with human head'
        },
        {
          'name': 'Stonehenge',
          'country': 'England',
          'flag': '🇬🇧',
          'emoji': '🪨',
          'fact': 'Mysterious stone circle'
        },
        {
          'name': 'Angkor Wat',
          'country': 'Cambodia',
          'flag': '🇰🇭',
          'emoji': '🛕',
          'fact': 'Largest religious monument'
        },
        {
          'name': 'Parthenon',
          'country': 'Greece',
          'flag': '🇬🇷',
          'emoji': '🏛️',
          'fact': 'Ancient Greek temple'
        },
      ],
    },
    {
      'title': 'Famous Castles',
      'emoji': '🏰',
      'color': Color(0xFF9C27B0),
      'castles': [
        {
          'name': 'Neuschwanstein Castle',
          'country': 'Germany',
          'flag': '🇩🇪',
          'fact': 'Inspired Disney Castle!'
        },
        {
          'name': 'Windsor Castle',
          'country': 'England',
          'flag': '🇬🇧',
          'fact': 'Where the King lives!'
        },
        {
          'name': 'Palace of Versailles',
          'country': 'France',
          'flag': '🇫🇷',
          'fact': 'Has 2,300 rooms!'
        },
        {
          'name': 'Himeji Castle',
          'country': 'Japan',
          'flag': '🇯🇵',
          'fact': 'Called the White Heron Castle'
        },
        {
          'name': 'Alhambra',
          'country': 'Spain',
          'flag': '🇪🇸',
          'fact': 'Beautiful Islamic architecture'
        },
      ],
    },
    {
      'title': 'Places in India',
      'emoji': '🇮🇳',
      'color': Color(0xFFFF5722),
      'places': [
        {
          'name': 'Taj Mahal',
          'city': 'Agra',
          'emoji': '🕌',
          'fact': 'Symbol of love, built by Shah Jahan'
        },
        {
          'name': 'Red Fort',
          'city': 'Delhi',
          'emoji': '🏰',
          'fact': 'Made of red sandstone'
        },
        {
          'name': 'Gateway of India',
          'city': 'Mumbai',
          'emoji': '🚪',
          'fact': 'Built in 1924'
        },
        {
          'name': 'Qutub Minar',
          'city': 'Delhi',
          'emoji': '🗼',
          'fact': 'Tallest brick minaret'
        },
        {
          'name': 'Hawa Mahal',
          'city': 'Jaipur',
          'emoji': '🏛️',
          'fact': 'Palace of Winds with 953 windows'
        },
        {
          'name': 'Golden Temple',
          'city': 'Amritsar',
          'emoji': '🛕',
          'fact': 'Covered in real gold!'
        },
        {
          'name': 'Mysore Palace',
          'city': 'Mysore',
          'emoji': '🏰',
          'fact': 'Beautiful lights at night'
        },
        {
          'name': 'Ajanta & Ellora Caves',
          'city': 'Maharashtra',
          'emoji': '🕳️',
          'fact': 'Ancient rock-cut caves'
        },
      ],
    },
    {
      'title': 'World Explorer Quiz!',
      'emoji': '🧭',
      'color': Color(0xFF00BCD4),
      'quiz': [
        {
          'question': 'Where is the Eiffel Tower?',
          'answer': 'Paris, France',
          'emoji': '🗼'
        },
        {
          'question': 'Which wonder is in India?',
          'answer': 'Taj Mahal',
          'emoji': '🕌'
        },
        {
          'question': 'What\'s the tallest mountain?',
          'answer': 'Mount Everest',
          'emoji': '🏔️'
        },
        {
          'question': 'Where are the Pyramids?',
          'answer': 'Egypt',
          'emoji': '🔺'
        },
        {
          'question': 'What inspired Disney Castle?',
          'answer': 'Neuschwanstein Castle',
          'emoji': '🏰'
        },
      ],
      'badge': 'You are now a World Explorer! Keep discovering!',
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
          'Famous Places',
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
        return _buildSevenWondersSection(section);
      case 2:
        return _buildLandmarksSection(section);
      case 3:
        return _buildNaturalWondersSection(section);
      case 4:
        return _buildAncientWondersSection(section);
      case 5:
        return _buildCastlesSection(section);
      case 6:
        return _buildIndiaPlacesSection(section);
      case 7:
        return _buildQuizSection(section);
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
          children: List.generate(section['categories'].length, (index) {
            final category = section['categories'][index];
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category['emoji'], style: TextStyle(fontSize: 40)),
                  SizedBox(height: 8),
                  Text(
                    category['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
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

  Widget _buildSevenWondersSection(Map<String, dynamic> section) {
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
          'New Seven Wonders of the World',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['wonders'].length, (index) {
          final wonder = section['wonders'][index];
          return _buildPlaceCard(wonder, section['color']);
        }),
      ],
    );
  }

  Widget _buildLandmarksSection(Map<String, dynamic> section) {
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
        SizedBox(height: 24),
        ...List.generate(section['landmarks'].length, (index) {
          final landmark = section['landmarks'][index];
          return _buildPlaceCard(landmark, section['color']);
        }),
      ],
    );
  }

  Widget _buildNaturalWondersSection(Map<String, dynamic> section) {
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
          'Nature\'s Amazing Creations',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['wonders'].length, (index) {
          final wonder = section['wonders'][index];
          return _buildPlaceCard(wonder, section['color']);
        }),
      ],
    );
  }

  Widget _buildAncientWondersSection(Map<String, dynamic> section) {
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
          'Built thousands of years ago!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['wonders'].length, (index) {
          final wonder = section['wonders'][index];
          return _buildPlaceCard(wonder, section['color']);
        }),
      ],
    );
  }

  Widget _buildCastlesSection(Map<String, dynamic> section) {
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
          'Royal homes from around the world',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['castles'].length, (index) {
          final castle = section['castles'][index];
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
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text('🏰', style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        castle['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Row(
                        children: [
                          Text(castle['flag'], style: TextStyle(fontSize: 14)),
                          SizedBox(width: 4),
                          Text(
                            castle['country'],
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        castle['fact'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.amber[700],
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

  Widget _buildIndiaPlacesSection(Map<String, dynamic> section) {
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
          'Incredible India!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['places'].length, (index) {
          final place = section['places'][index];
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
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(place['emoji'], style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey[600]),
                          SizedBox(width: 2),
                          Text(
                            place['city'],
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        place['fact'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.amber[700],
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

  Widget _buildQuizSection(Map<String, dynamic> section) {
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
          'Test your knowledge!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['quiz'].length, (index) {
          final quiz = section['quiz'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: section['color'],
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
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        quiz['question'],
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Text(quiz['emoji'], style: TextStyle(fontSize: 24)),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        quiz['answer'],
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text('🏆🌍🎉', style: TextStyle(fontSize: 40)),
              SizedBox(height: 8),
              Text(
                section['badge'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place, Color color) {
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
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(place['emoji'], style: TextStyle(fontSize: 28)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Row(
                  children: [
                    Text(place['flag'], style: TextStyle(fontSize: 14)),
                    SizedBox(width: 4),
                    Text(
                      place['country'],
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  place['fact'],
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
