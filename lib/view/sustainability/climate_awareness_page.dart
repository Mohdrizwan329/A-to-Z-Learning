import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClimateAwarenessPage extends StatefulWidget {
  const ClimateAwarenessPage({super.key});

  @override
  State<ClimateAwarenessPage> createState() => _ClimateAwarenessPageState();
}

class _ClimateAwarenessPageState extends State<ClimateAwarenessPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Climate?',
      'emoji': '🌡️',
      'color': Color(0xFF42A5F5),
      'content': [
        {'icon': '☀️', 'text': 'Climate is the usual weather in a place over many years'},
        {'icon': '🌧️', 'text': 'Some places are usually hot, some are usually cold'},
        {'icon': '🌍', 'text': 'Weather changes every day, but climate stays mostly the same'},
        {'icon': '📅', 'text': 'Scientists study weather for 30+ years to understand climate'},
      ],
    },
    {
      'title': 'Climate is Changing',
      'emoji': '🌡️⬆️',
      'color': Color(0xFFFF7043),
      'content': [
        {'icon': '🔥', 'text': 'The Earth is getting warmer than before'},
        {'icon': '🏭', 'text': 'Smoke from factories and cars makes Earth warmer'},
        {'icon': '🌳', 'text': 'Cutting down too many trees makes it worse'},
        {'icon': '😟', 'text': 'This change is called Global Warming or Climate Change'},
      ],
    },
    {
      'title': 'The Greenhouse Effect',
      'emoji': '🏠',
      'color': Color(0xFF66BB6A),
      'content': [
        {'icon': '☀️', 'text': 'Sun sends heat to Earth to keep us warm'},
        {'icon': '🌫️', 'text': 'Some gases in the air trap this heat like a blanket'},
        {'icon': '🏡', 'text': 'It\'s like a greenhouse that keeps plants warm'},
        {'icon': '⚠️', 'text': 'Too many gases = too much heat = Earth gets too hot'},
      ],
      'visual': true,
    },
    {
      'title': 'What\'s Happening?',
      'emoji': '😢',
      'color': Color(0xFFEF5350),
      'effects': [
        {'effect': 'Ice is Melting', 'emoji': '🧊', 'detail': 'Polar bears are losing their homes'},
        {'effect': 'Sea Levels Rising', 'emoji': '🌊', 'detail': 'Oceans are getting higher'},
        {'effect': 'More Storms', 'emoji': '🌀', 'detail': 'Hurricanes and floods happen more'},
        {'effect': 'Droughts', 'emoji': '🏜️', 'detail': 'Some places have less rain'},
        {'effect': 'Animals in Danger', 'emoji': '🦋', 'detail': 'Many species are dying'},
      ],
    },
    {
      'title': 'Climate Zones',
      'emoji': '🗺️',
      'color': Color(0xFF26A69A),
      'zones': [
        {'name': 'Tropical', 'emoji': '🌴', 'weather': 'Hot and rainy all year'},
        {'name': 'Desert', 'emoji': '🏜️', 'weather': 'Very hot and dry'},
        {'name': 'Temperate', 'emoji': '🍂', 'weather': 'Not too hot, not too cold'},
        {'name': 'Polar', 'emoji': '❄️', 'weather': 'Very cold with ice and snow'},
      ],
    },
    {
      'title': 'Weather vs Climate',
      'emoji': '⚡',
      'color': Color(0xFFAB47BC),
      'comparison': [
        {'weather': 'Today is sunny', 'climate': 'This area is usually sunny'},
        {'weather': 'It rained this morning', 'climate': 'Monsoon season brings rain'},
        {'weather': 'It\'s snowing now', 'climate': 'Winters here are cold'},
        {'weather': 'Changes every day', 'climate': 'Stays the same for years'},
      ],
    },
    {
      'title': 'How Can YOU Help?',
      'emoji': '🦸',
      'color': Color(0xFFFFB74D),
      'tips': [
        {'tip': 'Turn off lights when not using', 'emoji': '💡', 'saves': 'Energy'},
        {'tip': 'Walk or cycle instead of car rides', 'emoji': '🚲', 'saves': 'Fuel'},
        {'tip': 'Plant trees and take care of plants', 'emoji': '🌱', 'saves': 'Air'},
        {'tip': 'Don\'t waste water', 'emoji': '💧', 'saves': 'Water'},
        {'tip': 'Use less plastic', 'emoji': '🚫', 'saves': 'Ocean'},
        {'tip': 'Reduce, Reuse, Recycle', 'emoji': '♻️', 'saves': 'Resources'},
        {'tip': 'Eat more vegetables, less meat', 'emoji': '🥗', 'saves': 'Land'},
        {'tip': 'Tell others about climate change', 'emoji': '🗣️', 'saves': 'Future'},
      ],
    },
    {
      'title': 'Climate Heroes',
      'emoji': '🌟',
      'color': Color(0xFF7986CB),
      'heroes': [
        {'name': 'Scientists', 'emoji': '👩‍🔬', 'role': 'Study the climate and find solutions'},
        {'name': 'Activists', 'emoji': '📢', 'role': 'Spread awareness about climate change'},
        {'name': 'Engineers', 'emoji': '👷', 'role': 'Create clean energy like solar panels'},
        {'name': 'You!', 'emoji': '🌟', 'role': 'Every small action helps save our planet'},
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
          'Climate Awareness',
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
              Text(section['emoji'], style: const TextStyle(fontSize: 60)),
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
        if (section.containsKey('content')) _buildContentCards(section),
        if (section.containsKey('effects')) _buildEffectCards(section),
        if (section.containsKey('zones')) _buildZoneCards(section),
        if (section.containsKey('comparison')) _buildComparisonCards(section),
        if (section.containsKey('tips')) _buildTipCards(section),
        if (section.containsKey('heroes')) _buildHeroCards(section),
      ],
    );
  }

  Widget _buildContentCards(Map<String, dynamic> section) {
    return Column(
      children: [
        ...(section['content'] as List).map<Widget>((item) {
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
        }),
        if (section.containsKey('visual') && section['visual'] == true)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '☀️\n⬇️\n🌍',
                  style: const TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sun → Heat → Earth\nGases trap heat like a blanket',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEffectCards(Map<String, dynamic> section) {
    return Column(
      children: (section['effects'] as List).map<Widget>((effect) {
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
                  child: Text(effect['emoji'], style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      effect['effect'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      effect['detail'],
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

  Widget _buildZoneCards(Map<String, dynamic> section) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: (section['zones'] as List).length,
      itemBuilder: (context, index) {
        final zone = section['zones'][index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(zone['emoji'], style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                zone['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                  fontSize: 16,
                ),
              ),
              Text(
                zone['weather'],
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComparisonCards(Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⛅ Weather',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🌍 Climate',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(section['comparison'] as List).map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item['weather'],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Text('↔️'),
                  Expanded(
                    child: Text(
                      item['climate'],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTipCards(Map<String, dynamic> section) {
    return Column(
      children: (section['tips'] as List).map<Widget>((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['tip'],
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Saves: ${tip['saves']}',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: section['color'],
                        fontWeight: FontWeight.bold,
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

  Widget _buildHeroCards(Map<String, dynamic> section) {
    return Column(
      children: (section['heroes'] as List).map<Widget>((hero) {
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
                  child: Text(hero['emoji'], style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: section['color'],
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      hero['role'],
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
