import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class CountriesFlagsDetailPage extends StatefulWidget {
  final int sectionIndex;

  const CountriesFlagsDetailPage({super.key, required this.sectionIndex});

  @override
  State<CountriesFlagsDetailPage> createState() =>
      _CountriesFlagsDetailPageState();
}

class _CountriesFlagsDetailPageState extends State<CountriesFlagsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Countries & Flags',
      'emoji': '🌍',
      'description':
          'Every country has its own special flag! Flags are symbols that represent nations and their people.',
      'continents': [
        {'name': 'Asia', 'emoji': '🌏', 'flags': '🇮🇳 🇨🇳 🇯🇵'},
        {'name': 'Europe', 'emoji': '🌍', 'flags': '🇬🇧 🇫🇷 🇩🇪'},
        {'name': 'Africa', 'emoji': '🌍', 'flags': '🇪🇬 🇿🇦 🇰🇪'},
        {'name': 'North America', 'emoji': '🌎', 'flags': '🇺🇸 🇨🇦 🇲🇽'},
        {'name': 'South America', 'emoji': '🌎', 'flags': '🇧🇷 🇦🇷 🇵🇪'},
        {'name': 'Australia', 'emoji': '🌏', 'flags': '🇦🇺 🇳🇿 🇫🇯'},
        {'name': 'Antarctica', 'emoji': '🧊', 'flags': '🏳️'},
      ],
    },
    {
      'title': 'Asian Countries',
      'emoji': '🌏',
      'countries': [
        {
          'name': 'India',
          'flag': '🇮🇳',
          'capital': 'New Delhi',
          'famous': 'Taj Mahal',
        },
        {
          'name': 'China',
          'flag': '🇨🇳',
          'capital': 'Beijing',
          'famous': 'Great Wall',
        },
        {
          'name': 'Japan',
          'flag': '🇯🇵',
          'capital': 'Tokyo',
          'famous': 'Mount Fuji',
        },
        {
          'name': 'South Korea',
          'flag': '🇰🇷',
          'capital': 'Seoul',
          'famous': 'K-Pop',
        },
        {
          'name': 'Thailand',
          'flag': '🇹🇭',
          'capital': 'Bangkok',
          'famous': 'Temples',
        },
        {
          'name': 'UAE',
          'flag': '🇦🇪',
          'capital': 'Abu Dhabi',
          'famous': 'Burj Khalifa',
        },
      ],
    },
    {
      'title': 'European Countries',
      'emoji': '🏰',
      'countries': [
        {
          'name': 'United Kingdom',
          'flag': '🇬🇧',
          'capital': 'London',
          'famous': 'Big Ben',
        },
        {
          'name': 'France',
          'flag': '🇫🇷',
          'capital': 'Paris',
          'famous': 'Eiffel Tower',
        },
        {
          'name': 'Germany',
          'flag': '🇩🇪',
          'capital': 'Berlin',
          'famous': 'Castles',
        },
        {
          'name': 'Italy',
          'flag': '🇮🇹',
          'capital': 'Rome',
          'famous': 'Colosseum',
        },
        {
          'name': 'Spain',
          'flag': '🇪🇸',
          'capital': 'Madrid',
          'famous': 'Football',
        },
        {
          'name': 'Switzerland',
          'flag': '🇨🇭',
          'capital': 'Bern',
          'famous': 'Alps',
        },
      ],
    },
    {
      'title': 'American Countries',
      'emoji': '🗽',
      'countries': [
        {
          'name': 'USA',
          'flag': '🇺🇸',
          'capital': 'Washington DC',
          'famous': 'Statue of Liberty',
        },
        {
          'name': 'Canada',
          'flag': '🇨🇦',
          'capital': 'Ottawa',
          'famous': 'Maple Syrup',
        },
        {
          'name': 'Mexico',
          'flag': '🇲🇽',
          'capital': 'Mexico City',
          'famous': 'Pyramids',
        },
        {
          'name': 'Brazil',
          'flag': '🇧🇷',
          'capital': 'Brasilia',
          'famous': 'Amazon Forest',
        },
        {
          'name': 'Argentina',
          'flag': '🇦🇷',
          'capital': 'Buenos Aires',
          'famous': 'Football',
        },
        {
          'name': 'Peru',
          'flag': '🇵🇪',
          'capital': 'Lima',
          'famous': 'Machu Picchu',
        },
      ],
    },
    {
      'title': 'African Countries',
      'emoji': '🦁',
      'countries': [
        {
          'name': 'Egypt',
          'flag': '🇪🇬',
          'capital': 'Cairo',
          'famous': 'Pyramids',
        },
        {
          'name': 'South Africa',
          'flag': '🇿🇦',
          'capital': 'Pretoria',
          'famous': 'Safari',
        },
        {
          'name': 'Kenya',
          'flag': '🇰🇪',
          'capital': 'Nairobi',
          'famous': 'Wildlife',
        },
        {
          'name': 'Nigeria',
          'flag': '🇳🇬',
          'capital': 'Abuja',
          'famous': 'Music',
        },
        {
          'name': 'Morocco',
          'flag': '🇲🇦',
          'capital': 'Rabat',
          'famous': 'Markets',
        },
        {
          'name': 'Tanzania',
          'flag': '🇹🇿',
          'capital': 'Dodoma',
          'famous': 'Serengeti',
        },
      ],
    },
    {
      'title': 'Oceania Countries',
      'emoji': '🦘',
      'countries': [
        {
          'name': 'Australia',
          'flag': '🇦🇺',
          'capital': 'Canberra',
          'famous': 'Sydney Opera House',
        },
        {
          'name': 'New Zealand',
          'flag': '🇳🇿',
          'capital': 'Wellington',
          'famous': 'Kiwis',
        },
        {
          'name': 'Fiji',
          'flag': '🇫🇯',
          'capital': 'Suva',
          'famous': 'Islands',
        },
        {
          'name': 'Papua New Guinea',
          'flag': '🇵🇬',
          'capital': 'Port Moresby',
          'famous': 'Rainforests',
        },
      ],
    },
    {
      'title': 'Flag Colors & Meanings',
      'emoji': '🎨',
      'meanings': [
        {'color': 'Red', 'meaning': 'Courage, Strength, Love'},
        {'color': 'Blue', 'meaning': 'Peace, Sky, Ocean'},
        {'color': 'Green', 'meaning': 'Nature, Growth, Hope'},
        {'color': 'White', 'meaning': 'Peace, Purity'},
        {'color': 'Yellow/Gold', 'meaning': 'Sun, Wealth, Happiness'},
        {'color': 'Orange', 'meaning': 'Courage, Sacrifice'},
      ],
    },
    {
      'title': 'Flag Quiz!',
      'emoji': '🧩',
      'quiz': [
        {
          'flag': '🇮🇳',
          'options': ['India', 'Ireland', 'Italy'],
          'answer': 0,
        },
        {
          'flag': '🇯🇵',
          'options': ['China', 'Japan', 'Korea'],
          'answer': 1,
        },
        {
          'flag': '🇫🇷',
          'options': ['France', 'Germany', 'Italy'],
          'answer': 0,
        },
        {
          'flag': '🇧🇷',
          'options': ['Argentina', 'Mexico', 'Brazil'],
          'answer': 2,
        },
        {
          'flag': '🇦🇺',
          'options': ['UK', 'Australia', 'New Zealand'],
          'answer': 1,
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
        return const SizedBox.shrink();
    }
  }

  Widget _buildGradientItem({required int index, required Widget child}) {
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
          borderRadius: BorderRadius.circular(20),
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
        Text(
          '7 Continents of the World:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
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
                        continent['flags'] ?? '',
                        style: const TextStyle(fontSize: 20),
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

  Widget _buildCountriesSection(Map<String, dynamic> section) {
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
        const SizedBox(height: 24),
        ...List.generate(section['countries'].length, (index) {
          final country = section['countries'][index];
          return _buildGradientItem(
            index: index,
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
                      country['flag'],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country['name'],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_city,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            country['capital'],
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            country['famous'],
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[200],
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
          'Colors in flags have special meanings!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['meanings'].length, (index) {
          final meaning = section['meanings'][index];
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
                    child: Text('🎨', style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meaning['color'],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        meaning['meaning'],
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

  Widget _buildQuizSection(Map<String, dynamic> section) {
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
          'Can you guess the country?',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['quiz'].length, (index) {
          final quiz = section['quiz'][index];
          return _buildGradientItem(
            index: index,
            child: Column(
              children: [
                Text(quiz['flag'], style: const TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: List.generate(quiz['options'].length, (i) {
                    final isAnswer = i == quiz['answer'];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isAnswer
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isAnswer
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        quiz['options'][i],
                        style: GoogleFonts.nunito(
                          fontWeight: isAnswer
                              ? FontWeight.bold
                              : FontWeight.normal,
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
}
