import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CountriesFlagsPage extends StatefulWidget {
  const CountriesFlagsPage({super.key});

  @override
  State<CountriesFlagsPage> createState() => _CountriesFlagsPageState();
}

class _CountriesFlagsPageState extends State<CountriesFlagsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Countries & Flags',
      'emoji': '🌍',
      'color': Color(0xFF2196F3),
      'description':
          'Every country has its own special flag! Flags are symbols that represent nations and their people.',
      'continents': [
        {'name': 'Asia', 'emoji': '🌏'},
        {'name': 'Europe', 'emoji': '🌍'},
        {'name': 'Africa', 'emoji': '🌍'},
        {'name': 'North America', 'emoji': '🌎'},
        {'name': 'South America', 'emoji': '🌎'},
        {'name': 'Australia', 'emoji': '🌏'},
        {'name': 'Antarctica', 'emoji': '🧊'},
      ],
    },
    {
      'title': 'Asian Countries',
      'emoji': '🌏',
      'color': Color(0xFFE91E63),
      'countries': [
        {'name': 'India', 'flag': '🇮🇳', 'capital': 'New Delhi', 'famous': 'Taj Mahal'},
        {'name': 'China', 'flag': '🇨🇳', 'capital': 'Beijing', 'famous': 'Great Wall'},
        {'name': 'Japan', 'flag': '🇯🇵', 'capital': 'Tokyo', 'famous': 'Mount Fuji'},
        {'name': 'South Korea', 'flag': '🇰🇷', 'capital': 'Seoul', 'famous': 'K-Pop'},
        {'name': 'Thailand', 'flag': '🇹🇭', 'capital': 'Bangkok', 'famous': 'Temples'},
        {'name': 'UAE', 'flag': '🇦🇪', 'capital': 'Abu Dhabi', 'famous': 'Burj Khalifa'},
      ],
    },
    {
      'title': 'European Countries',
      'emoji': '🏰',
      'color': Color(0xFF4CAF50),
      'countries': [
        {'name': 'United Kingdom', 'flag': '🇬🇧', 'capital': 'London', 'famous': 'Big Ben'},
        {'name': 'France', 'flag': '🇫🇷', 'capital': 'Paris', 'famous': 'Eiffel Tower'},
        {'name': 'Germany', 'flag': '🇩🇪', 'capital': 'Berlin', 'famous': 'Castles'},
        {'name': 'Italy', 'flag': '🇮🇹', 'capital': 'Rome', 'famous': 'Colosseum'},
        {'name': 'Spain', 'flag': '🇪🇸', 'capital': 'Madrid', 'famous': 'Football'},
        {'name': 'Switzerland', 'flag': '🇨🇭', 'capital': 'Bern', 'famous': 'Alps'},
      ],
    },
    {
      'title': 'American Countries',
      'emoji': '🗽',
      'color': Color(0xFF9C27B0),
      'countries': [
        {'name': 'USA', 'flag': '🇺🇸', 'capital': 'Washington DC', 'famous': 'Statue of Liberty'},
        {'name': 'Canada', 'flag': '🇨🇦', 'capital': 'Ottawa', 'famous': 'Maple Syrup'},
        {'name': 'Mexico', 'flag': '🇲🇽', 'capital': 'Mexico City', 'famous': 'Pyramids'},
        {'name': 'Brazil', 'flag': '🇧🇷', 'capital': 'Brasilia', 'famous': 'Amazon Forest'},
        {'name': 'Argentina', 'flag': '🇦🇷', 'capital': 'Buenos Aires', 'famous': 'Football'},
        {'name': 'Peru', 'flag': '🇵🇪', 'capital': 'Lima', 'famous': 'Machu Picchu'},
      ],
    },
    {
      'title': 'African Countries',
      'emoji': '🦁',
      'color': Color(0xFFFF9800),
      'countries': [
        {'name': 'Egypt', 'flag': '🇪🇬', 'capital': 'Cairo', 'famous': 'Pyramids'},
        {'name': 'South Africa', 'flag': '🇿🇦', 'capital': 'Pretoria', 'famous': 'Safari'},
        {'name': 'Kenya', 'flag': '🇰🇪', 'capital': 'Nairobi', 'famous': 'Wildlife'},
        {'name': 'Nigeria', 'flag': '🇳🇬', 'capital': 'Abuja', 'famous': 'Music'},
        {'name': 'Morocco', 'flag': '🇲🇦', 'capital': 'Rabat', 'famous': 'Markets'},
        {'name': 'Tanzania', 'flag': '🇹🇿', 'capital': 'Dodoma', 'famous': 'Serengeti'},
      ],
    },
    {
      'title': 'Oceania Countries',
      'emoji': '🦘',
      'color': Color(0xFF00BCD4),
      'countries': [
        {'name': 'Australia', 'flag': '🇦🇺', 'capital': 'Canberra', 'famous': 'Sydney Opera House'},
        {'name': 'New Zealand', 'flag': '🇳🇿', 'capital': 'Wellington', 'famous': 'Kiwis'},
        {'name': 'Fiji', 'flag': '🇫🇯', 'capital': 'Suva', 'famous': 'Islands'},
        {'name': 'Papua New Guinea', 'flag': '🇵🇬', 'capital': 'Port Moresby', 'famous': 'Rainforests'},
      ],
    },
    {
      'title': 'Flag Colors & Meanings',
      'emoji': '🎨',
      'color': Color(0xFF673AB7),
      'meanings': [
        {'color': 'Red', 'colorCode': Color(0xFFE53935), 'meaning': 'Courage, Strength, Love'},
        {'color': 'Blue', 'colorCode': Color(0xFF1E88E5), 'meaning': 'Peace, Sky, Ocean'},
        {'color': 'Green', 'colorCode': Color(0xFF43A047), 'meaning': 'Nature, Growth, Hope'},
        {'color': 'White', 'colorCode': Color(0xFFFFFFFF), 'meaning': 'Peace, Purity'},
        {'color': 'Yellow/Gold', 'colorCode': Color(0xFFFFD54F), 'meaning': 'Sun, Wealth, Happiness'},
        {'color': 'Orange', 'colorCode': Color(0xFFFF7043), 'meaning': 'Courage, Sacrifice'},
      ],
    },
    {
      'title': 'Flag Quiz!',
      'emoji': '🧩',
      'color': Color(0xFFFF5722),
      'quiz': [
        {'flag': '🇮🇳', 'options': ['India', 'Ireland', 'Italy'], 'answer': 0},
        {'flag': '🇯🇵', 'options': ['China', 'Japan', 'Korea'], 'answer': 1},
        {'flag': '🇫🇷', 'options': ['France', 'Germany', 'Italy'], 'answer': 0},
        {'flag': '🇧🇷', 'options': ['Argentina', 'Mexico', 'Brazil'], 'answer': 2},
        {'flag': '🇦🇺', 'options': ['UK', 'Australia', 'New Zealand'], 'answer': 1},
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
          'Countries & Flags',
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
      case 2:
      case 3:
      case 4:
      case 5:
        return _buildCountriesSection(section);
      case 6:
        return _buildMeaningsSection(section);
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
        Text(
          '7 Continents of the World:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        ...List.generate(section['continents'].length, (index) {
          final continent = section['continents'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(continent['emoji'], style: TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Text(
                  continent['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: section['color'],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCountriesSection(Map<String, dynamic> section) {
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
        ...List.generate(section['countries'].length, (index) {
          final country = section['countries'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(country['flag'], style: TextStyle(fontSize: 48)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_city,
                              size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            country['capital'],
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            country['famous'],
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
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

  Widget _buildMeaningsSection(Map<String, dynamic> section) {
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
          'Colors in flags have special meanings!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['meanings'].length, (index) {
          final meaning = section['meanings'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: meaning['colorCode'],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    border: meaning['color'] == 'White'
                        ? Border.all(color: Colors.grey[300]!)
                        : null,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meaning['color'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: section['color'],
                          ),
                        ),
                        Text(
                          meaning['meaning'],
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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
          'Can you guess the country?',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['quiz'].length, (index) {
          final quiz = section['quiz'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(quiz['flag'], style: TextStyle(fontSize: 56)),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: List.generate(quiz['options'].length, (i) {
                    final isAnswer = i == quiz['answer'];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isAnswer
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isAnswer ? Colors.green : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        quiz['options'][i],
                        style: GoogleFonts.nunito(
                          fontWeight:
                              isAnswer ? FontWeight.bold : FontWeight.normal,
                          color: isAnswer ? Colors.green : Colors.grey[600],
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
