import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenshipBasicsPage extends StatefulWidget {
  const CitizenshipBasicsPage({super.key});

  @override
  State<CitizenshipBasicsPage> createState() => _CitizenshipBasicsPageState();
}

class _CitizenshipBasicsPageState extends State<CitizenshipBasicsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is a Country?',
      'emoji': '🌍',
      'color': Color(0xFF4FC3F7),
      'content': [
        {'icon': '🏛️', 'text': 'A country is a big area of land with its own government'},
        {'icon': '👥', 'text': 'Many people live together in a country'},
        {'icon': '🗣️', 'text': 'People in a country may speak the same language'},
        {'icon': '🎌', 'text': 'Every country has its own flag and symbols'},
        {'icon': '📜', 'text': 'Countries have rules called laws that everyone follows'},
      ],
    },
    {
      'title': 'What is a Citizen?',
      'emoji': '🧑‍🤝‍🧑',
      'color': Color(0xFF66BB6A),
      'content': [
        {'icon': '🏠', 'text': 'A citizen belongs to a country'},
        {'icon': '📝', 'text': 'Citizens have special rights in their country'},
        {'icon': '🤝', 'text': 'Citizens also have duties to their country'},
        {'icon': '👶', 'text': 'You become a citizen when you are born in a country'},
        {'icon': '🎂', 'text': 'Some people can become citizens later'},
      ],
    },
    {
      'title': 'Our National Symbols',
      'emoji': '🇮🇳',
      'color': Color(0xFFFF7043),
      'symbols': [
        {'name': 'National Flag', 'emoji': '🇮🇳', 'detail': 'Tiranga - Saffron, White, Green with Ashoka Chakra'},
        {'name': 'National Emblem', 'emoji': '🦁', 'detail': 'Four Lions - Satyameva Jayate'},
        {'name': 'National Bird', 'emoji': '🦚', 'detail': 'Peacock - Beautiful and graceful'},
        {'name': 'National Animal', 'emoji': '🐯', 'detail': 'Bengal Tiger - Strong and brave'},
        {'name': 'National Flower', 'emoji': '🪷', 'detail': 'Lotus - Pure and beautiful'},
        {'name': 'National Anthem', 'emoji': '🎵', 'detail': 'Jana Gana Mana - Written by Tagore'},
      ],
    },
    {
      'title': 'National Holidays',
      'emoji': '🎉',
      'color': Color(0xFFBA68C8),
      'holidays': [
        {'name': 'Republic Day', 'date': 'January 26', 'emoji': '🏛️', 'about': 'Our Constitution was adopted'},
        {'name': 'Independence Day', 'date': 'August 15', 'emoji': '🇮🇳', 'about': 'India became free in 1947'},
        {'name': 'Gandhi Jayanti', 'date': 'October 2', 'emoji': '👓', 'about': 'Birthday of Mahatma Gandhi'},
      ],
    },
    {
      'title': 'Leaders of Our Country',
      'emoji': '👔',
      'color': Color(0xFF26A69A),
      'leaders': [
        {'title': 'President', 'emoji': '🏰', 'role': 'Head of the country, lives in Rashtrapati Bhavan'},
        {'title': 'Prime Minister', 'emoji': '🏛️', 'role': 'Head of government, makes important decisions'},
        {'title': 'Chief Minister', 'emoji': '🏢', 'role': 'Head of a state government'},
        {'title': 'Governor', 'emoji': '🎖️', 'role': 'President\'s representative in a state'},
      ],
    },
    {
      'title': 'Being a Good Citizen',
      'emoji': '⭐',
      'color': Color(0xFFFFB74D),
      'tips': [
        {'tip': 'Follow rules and laws', 'emoji': '📋'},
        {'tip': 'Respect elders and teachers', 'emoji': '🙏'},
        {'tip': 'Keep your surroundings clean', 'emoji': '🧹'},
        {'tip': 'Help others in need', 'emoji': '🤝'},
        {'tip': 'Be honest and truthful', 'emoji': '💎'},
        {'tip': 'Love and respect your country', 'emoji': '❤️'},
        {'tip': 'Study well and be responsible', 'emoji': '📚'},
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
          'Citizenship Basics',
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
              _buildProgressIndicator(),
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
  Widget _buildProgressIndicator() {
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
              color: index == currentSection
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
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
              Text(section['emoji'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (section.containsKey('content')) _buildContentCards(section),
        if (section.containsKey('symbols')) _buildSymbolCards(section),
        if (section.containsKey('holidays')) _buildHolidayCards(section),
        if (section.containsKey('leaders')) _buildLeaderCards(section),
        if (section.containsKey('tips')) _buildTipCards(section),
      ],
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children: (section['content'] as List).map<Widget>((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(item['icon'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item['text'],
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSymbolCards(Map<String, dynamic> section) {
    return Column(
      children: (section['symbols'] as List).map<Widget>((symbol) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
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
                  child: Text(symbol['emoji'], style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      symbol['detail'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 14,
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

  Widget _buildHolidayCards(Map<String, dynamic> section) {
    return Column(
      children: (section['holidays'] as List).map<Widget>((holiday) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(holiday['emoji'], style: const TextStyle(fontSize: 28)),
                    Text(
                      holiday['date'],
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holiday['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      holiday['about'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 14,
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

  Widget _buildLeaderCards(Map<String, dynamic> section) {
    return Column(
      children: (section['leaders'] as List).map<Widget>((leader) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(leader['emoji'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leader['title'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      leader['role'],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 13,
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

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).asMap().entries.map<Widget>((entry) {
        final tip = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
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
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(tip['emoji'], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tip['tip'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
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
