import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class SaveEnvironmentPage extends StatefulWidget {
  const SaveEnvironmentPage({super.key});

  @override
  State<SaveEnvironmentPage> createState() => _SaveEnvironmentPageState();
}

class _SaveEnvironmentPageState extends State<SaveEnvironmentPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Our Beautiful Earth',
      'emoji': '🌍',
      'color': Color(0xFF4CAF50),
      'description':
          'Earth is our home! It gives us air, water, food, and so much more. Let\'s learn how to protect it!',
      'earthGifts': [
        {'item': 'Clean Air', 'emoji': '💨'},
        {'item': 'Fresh Water', 'emoji': '💧'},
        {'item': 'Yummy Food', 'emoji': '🍎'},
        {'item': 'Beautiful Nature', 'emoji': '🌸'},
        {'item': 'Animals Friends', 'emoji': '🐾'},
        {'item': 'Sunshine', 'emoji': '☀️'},
      ],
    },
    {
      'title': 'Why Save Environment?',
      'emoji': '❓',
      'color': Color(0xFF2196F3),
      'description': 'The Earth needs our help! Some things are hurting it:',
      'problems': [
        {
          'problem': 'Pollution',
          'emoji': '🏭',
          'effect': 'Makes air and water dirty',
          'color': Color(0xFF9E9E9E)
        },
        {
          'problem': 'Cutting Trees',
          'emoji': '🪓',
          'effect': 'Animals lose their homes',
          'color': Color(0xFF795548)
        },
        {
          'problem': 'Too Much Plastic',
          'emoji': '🥤',
          'effect': 'Hurts ocean animals',
          'color': Color(0xFF00BCD4)
        },
        {
          'problem': 'Wasting Water',
          'emoji': '🚿',
          'effect': 'Less water for everyone',
          'color': Color(0xFF2196F3)
        },
      ],
    },
    {
      'title': 'Save Water',
      'emoji': '💧',
      'color': Color(0xFF03A9F4),
      'description': 'Water is precious! Here\'s how you can save it:',
      'tips': [
        {
          'action': 'Turn off tap while brushing',
          'emoji': '🚿',
          'saves': 'Saves 6 liters!'
        },
        {
          'action': 'Take short showers',
          'emoji': '🛁',
          'saves': 'Saves lots of water!'
        },
        {
          'action': 'Fix leaky taps',
          'emoji': '🔧',
          'saves': 'No drip, drip, drip!'
        },
        {
          'action': 'Use a bucket, not a hose',
          'emoji': '🪣',
          'saves': 'For washing cars!'
        },
        {
          'action': 'Water plants in evening',
          'emoji': '🌱',
          'saves': 'Less water evaporates!'
        },
      ],
      'funFact':
          'Only 1% of Earth\'s water is drinkable! The rest is salty or frozen.',
    },
    {
      'title': 'Save Energy',
      'emoji': '⚡',
      'color': Color(0xFFFF9800),
      'description': 'Energy comes from Earth\'s resources. Let\'s use less!',
      'tips': [
        {
          'action': 'Turn off lights',
          'emoji': '💡',
          'when': 'When leaving a room'
        },
        {
          'action': 'Unplug devices',
          'emoji': '🔌',
          'when': 'When not using them'
        },
        {
          'action': 'Open curtains',
          'emoji': '🪟',
          'when': 'Use sunlight during day'
        },
        {
          'action': 'Use fans first',
          'emoji': '🌀',
          'when': 'Before turning on AC'
        },
        {
          'action': 'Walk or cycle',
          'emoji': '🚴',
          'when': 'For short distances'
        },
      ],
      'renewables': [
        {'source': 'Solar', 'emoji': '☀️'},
        {'source': 'Wind', 'emoji': '💨'},
        {'source': 'Water', 'emoji': '🌊'},
      ],
    },
    {
      'title': 'Reduce, Reuse, Recycle',
      'emoji': '♻️',
      'color': Color(0xFF8BC34A),
      'description': 'The 3 Rs help us make less garbage!',
      'threeRs': [
        {
          'r': 'Reduce',
          'emoji': '📉',
          'meaning': 'Use less stuff',
          'examples': ['Use less paper', 'Buy only what you need', 'Say no to extra packaging'],
          'color': Color(0xFFE91E63)
        },
        {
          'r': 'Reuse',
          'emoji': '🔄',
          'meaning': 'Use things again',
          'examples': ['Reuse bags', 'Donate old toys', 'Use both sides of paper'],
          'color': Color(0xFF9C27B0)
        },
        {
          'r': 'Recycle',
          'emoji': '♻️',
          'meaning': 'Make into new things',
          'examples': ['Recycle bottles', 'Recycle paper', 'Recycle cans'],
          'color': Color(0xFF4CAF50)
        },
      ],
    },
    {
      'title': 'Plant Trees',
      'emoji': '🌳',
      'color': Color(0xFF388E3C),
      'description': 'Trees are Earth\'s superheroes! They help us in so many ways:',
      'benefits': [
        {'benefit': 'Make oxygen we breathe', 'emoji': '💨'},
        {'benefit': 'Clean the air', 'emoji': '🌫️'},
        {'benefit': 'Home for animals', 'emoji': '🐿️'},
        {'benefit': 'Give us shade', 'emoji': '🌥️'},
        {'benefit': 'Give us fruits', 'emoji': '🍎'},
        {'benefit': 'Stop soil from washing away', 'emoji': '🏔️'},
      ],
      'challenge': 'Plant a tree and watch it grow! Name it and take care of it.',
    },
    {
      'title': 'Say No to Plastic',
      'emoji': '🚫',
      'color': Color(0xFF00BCD4),
      'description': 'Plastic never goes away! It hurts animals and the ocean.',
      'alternatives': [
        {
          'plastic': 'Plastic bags',
          'use': 'Cloth bags',
          'plasticEmoji': '🛍️',
          'useEmoji': '👜'
        },
        {
          'plastic': 'Plastic bottles',
          'use': 'Steel/Glass bottle',
          'plasticEmoji': '🍾',
          'useEmoji': '🫙'
        },
        {
          'plastic': 'Plastic straws',
          'use': 'Paper/Steel straws',
          'plasticEmoji': '🥤',
          'useEmoji': '🧃'
        },
        {
          'plastic': 'Plastic boxes',
          'use': 'Steel tiffin',
          'plasticEmoji': '📦',
          'useEmoji': '🥡'
        },
      ],
      'sadFact': 'Every year, 8 million tons of plastic goes into the ocean!',
    },
    {
      'title': 'Protect Animals',
      'emoji': '🐾',
      'color': Color(0xFFFF5722),
      'description': 'Animals are part of our Earth family. Let\'s protect them!',
      'endangered': [
        {'animal': 'Tigers', 'emoji': '🐅'},
        {'animal': 'Elephants', 'emoji': '🐘'},
        {'animal': 'Pandas', 'emoji': '🐼'},
        {'animal': 'Whales', 'emoji': '🐋'},
        {'animal': 'Sea Turtles', 'emoji': '🐢'},
        {'animal': 'Polar Bears', 'emoji': '🐻‍❄️'},
      ],
      'howToHelp': [
        'Don\'t litter - animals eat trash',
        'Don\'t disturb wildlife',
        'Support animal shelters',
        'Learn about endangered animals',
      ],
    },
    {
      'title': 'Be an Eco Hero!',
      'emoji': '🦸',
      'color': Color(0xFF673AB7),
      'heroActions': [
        {'action': 'Plant a tree or flower', 'emoji': '🌱'},
        {'action': 'Pick up litter', 'emoji': '🗑️'},
        {'action': 'Use cloth bags', 'emoji': '👜'},
        {'action': 'Save water & electricity', 'emoji': '💡'},
        {'action': 'Walk or cycle more', 'emoji': '🚶'},
        {'action': 'Teach others about environment', 'emoji': '📢'},
        {'action': 'Love and respect nature', 'emoji': '💚'},
      ],
      'pledge':
          'I promise to take care of Earth and be an Eco Hero every day!',
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
          'Save Environment',
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
            margin: EdgeInsets.symmetric(horizontal: 3),
            width: currentSection == index ? 20 : 8,
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
        return _buildEarthSection(section);
      case 1:
        return _buildWhySaveSection(section);
      case 2:
        return _buildSaveWaterSection(section);
      case 3:
        return _buildSaveEnergySection(section);
      case 4:
        return _build3RsSection(section);
      case 5:
        return _buildPlantTreesSection(section);
      case 6:
        return _buildNoPlasticSection(section);
      case 7:
        return _buildProtectAnimalsSection(section);
      case 8:
        return _buildEcoHeroSection(section);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildEarthSection(Map<String, dynamic> section) {
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
          'Earth gives us:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(section['earthGifts'].length, (index) {
            final gift = section['earthGifts'][index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(gift['emoji'], style: TextStyle(fontSize: 36)),
                  SizedBox(height: 4),
                  Text(
                    gift['item'],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
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

  Widget _buildWhySaveSection(Map<String, dynamic> section) {
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
        ...List.generate(section['problems'].length, (index) {
          final problem = section['problems'][index];
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
                    color: problem['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(problem['emoji'], style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        problem['problem'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: problem['color'],
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        problem['effect'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.warning_amber, color: Colors.amber, size: 28),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSaveWaterSection(Map<String, dynamic> section) {
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
        ...List.generate(section['tips'].length, (index) {
          final tip = section['tips'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(tip['emoji'], style: TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['action'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        tip['saves'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: Colors.green),
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
              Text('💡', style: TextStyle(fontSize: 28)),
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
                      style: GoogleFonts.nunito(fontSize: 14),
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

  Widget _buildSaveEnergySection(Map<String, dynamic> section) {
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
        ...List.generate(section['tips'].length, (index) {
          final tip = section['tips'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(tip['emoji'], style: TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['action'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        tip['when'],
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
        Text(
          'Clean Energy Sources:',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(section['renewables'].length, (index) {
            final source = section['renewables'][index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(source['emoji'], style: TextStyle(fontSize: 36)),
                  Text(
                    source['source'],
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
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

  Widget _build3RsSection(Map<String, dynamic> section) {
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
        ...List.generate(section['threeRs'].length, (index) {
          final r = section['threeRs'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: r['color'], width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: r['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Text(r['emoji'], style: TextStyle(fontSize: 24)),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['r'],
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: r['color'],
                          ),
                        ),
                        Text(
                          r['meaning'],
                          style: GoogleFonts.nunito(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ...List.generate(r['examples'].length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(left: 50, bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check, color: r['color'], size: 18),
                        SizedBox(width: 8),
                        Text(
                          r['examples'][i],
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPlantTreesSection(Map<String, dynamic> section) {
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
        ...List.generate(section['benefits'].length, (index) {
          final benefit = section['benefits'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(benefit['emoji'], style: TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    benefit['benefit'],
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
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
              Text('🌟', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge!',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      section['challenge'],
                      style: GoogleFonts.nunito(fontSize: 14),
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

  Widget _buildNoPlasticSection(Map<String, dynamic> section) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🥤', style: TextStyle(fontSize: 60)),
            Text(section['emoji'], style: TextStyle(fontSize: 40)),
          ],
        ),
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
          'Switch from plastic to:',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        ...List.generate(section['alternatives'].length, (index) {
          final alt = section['alternatives'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(alt['plasticEmoji'], style: TextStyle(fontSize: 32)),
                      Text(
                        alt['plastic'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: section['color'], size: 32),
                Expanded(
                  child: Column(
                    children: [
                      Text(alt['useEmoji'], style: TextStyle(fontSize: 32)),
                      Text(
                        alt['use'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.green,
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
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text('😢', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['sadFact'],
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white,
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

  Widget _buildProtectAnimalsSection(Map<String, dynamic> section) {
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
          'Endangered Animals:',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(section['endangered'].length, (index) {
            final animal = section['endangered'][index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(animal['emoji'], style: TextStyle(fontSize: 36)),
                  SizedBox(height: 4),
                  Text(
                    animal['animal'],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Help:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
              ),
              SizedBox(height: 8),
              ...List.generate(section['howToHelp'].length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: section['color'], size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          section['howToHelp'][index],
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEcoHeroSection(Map<String, dynamic> section) {
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
          'You can save the Earth!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: List.generate(section['heroActions'].length, (index) {
              final action = section['heroActions'][index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: section['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: section['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Text(action['emoji'],
                          style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        action['action'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text('🤝', style: TextStyle(fontSize: 40)),
              SizedBox(height: 8),
              Text(
                'My Pledge:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                section['pledge'],
                style: GoogleFonts.nunito(fontSize: 16),
                textAlign: TextAlign.center,
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
                  TtsService.to.speak(sections[currentSection]['title']);
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
                  TtsService.to.speak(sections[currentSection]['title']);
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
