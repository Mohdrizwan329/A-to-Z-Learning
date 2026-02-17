import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalCulturesPage extends StatefulWidget {
  const GlobalCulturesPage({super.key});

  @override
  State<GlobalCulturesPage> createState() => _GlobalCulturesPageState();
}

class _GlobalCulturesPageState extends State<GlobalCulturesPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'World Cultures',
      'emoji': '🌍',
      'color': Color(0xFF9C27B0),
      'description':
          'Every country has its own special culture! Culture includes food, clothes, music, dance, and traditions that make each place unique.',
      'elements': [
        {'name': 'Food', 'emoji': '🍜'},
        {'name': 'Clothes', 'emoji': '👘'},
        {'name': 'Music', 'emoji': '🎵'},
        {'name': 'Dance', 'emoji': '💃'},
        {'name': 'Festivals', 'emoji': '🎉'},
        {'name': 'Languages', 'emoji': '🗣️'},
      ],
    },
    {
      'title': 'Asian Cultures',
      'emoji': '🌏',
      'color': Color(0xFFE91E63),
      'cultures': [
        {
          'country': 'India',
          'flag': '🇮🇳',
          'food': 'Curry & Biryani',
          'dress': 'Saree & Kurta',
          'festival': 'Diwali',
          'greeting': 'Namaste 🙏'
        },
        {
          'country': 'Japan',
          'flag': '🇯🇵',
          'food': 'Sushi & Ramen',
          'dress': 'Kimono',
          'festival': 'Cherry Blossom',
          'greeting': 'Konnichiwa'
        },
        {
          'country': 'China',
          'flag': '🇨🇳',
          'food': 'Noodles & Dim Sum',
          'dress': 'Hanfu',
          'festival': 'Chinese New Year',
          'greeting': 'Ni Hao'
        },
        {
          'country': 'Thailand',
          'flag': '🇹🇭',
          'food': 'Pad Thai',
          'dress': 'Chut Thai',
          'festival': 'Songkran',
          'greeting': 'Sawadee'
        },
      ],
    },
    {
      'title': 'European Cultures',
      'emoji': '🏰',
      'color': Color(0xFF2196F3),
      'cultures': [
        {
          'country': 'France',
          'flag': '🇫🇷',
          'food': 'Croissants & Crepes',
          'dress': 'Beret & Stripes',
          'festival': 'Bastille Day',
          'greeting': 'Bonjour'
        },
        {
          'country': 'Italy',
          'flag': '🇮🇹',
          'food': 'Pizza & Pasta',
          'dress': 'Fashion Capital!',
          'festival': 'Carnival',
          'greeting': 'Ciao'
        },
        {
          'country': 'Spain',
          'flag': '🇪🇸',
          'food': 'Paella & Tapas',
          'dress': 'Flamenco Dress',
          'festival': 'La Tomatina',
          'greeting': 'Hola'
        },
        {
          'country': 'Germany',
          'flag': '🇩🇪',
          'food': 'Pretzels & Sausages',
          'dress': 'Lederhosen',
          'festival': 'Oktoberfest',
          'greeting': 'Guten Tag'
        },
      ],
    },
    {
      'title': 'African Cultures',
      'emoji': '🦁',
      'color': Color(0xFFFF9800),
      'cultures': [
        {
          'country': 'Egypt',
          'flag': '🇪🇬',
          'food': 'Koshari & Falafel',
          'dress': 'Galabeya',
          'festival': 'Sham el-Nessim',
          'greeting': 'Salaam'
        },
        {
          'country': 'Kenya',
          'flag': '🇰🇪',
          'food': 'Ugali & Nyama Choma',
          'dress': 'Kikoy & Kanga',
          'festival': 'Madaraka Day',
          'greeting': 'Jambo'
        },
        {
          'country': 'Nigeria',
          'flag': '🇳🇬',
          'food': 'Jollof Rice',
          'dress': 'Agbada & Gele',
          'festival': 'Eyo Festival',
          'greeting': 'Bawo ni'
        },
        {
          'country': 'South Africa',
          'flag': '🇿🇦',
          'food': 'Braai & Bobotie',
          'dress': 'Colorful Prints',
          'festival': 'Heritage Day',
          'greeting': 'Sawubona'
        },
      ],
    },
    {
      'title': 'American Cultures',
      'emoji': '🗽',
      'color': Color(0xFF4CAF50),
      'cultures': [
        {
          'country': 'USA',
          'flag': '🇺🇸',
          'food': 'Burgers & Apple Pie',
          'dress': 'Jeans & T-shirt',
          'festival': 'Thanksgiving',
          'greeting': 'Hello'
        },
        {
          'country': 'Mexico',
          'flag': '🇲🇽',
          'food': 'Tacos & Burritos',
          'dress': 'Sombrero & Serape',
          'festival': 'Day of the Dead',
          'greeting': 'Hola'
        },
        {
          'country': 'Brazil',
          'flag': '🇧🇷',
          'food': 'Feijoada & Açaí',
          'dress': 'Carnival Costumes',
          'festival': 'Rio Carnival',
          'greeting': 'Olá'
        },
        {
          'country': 'Argentina',
          'flag': '🇦🇷',
          'food': 'Asado & Empanadas',
          'dress': 'Gaucho Attire',
          'festival': 'Tango Festival',
          'greeting': 'Hola'
        },
      ],
    },
    {
      'title': 'World Greetings',
      'emoji': '👋',
      'color': Color(0xFF00BCD4),
      'greetings': [
        {'language': 'English', 'greeting': 'Hello', 'emoji': '🇬🇧'},
        {'language': 'Spanish', 'greeting': 'Hola', 'emoji': '🇪🇸'},
        {'language': 'French', 'greeting': 'Bonjour', 'emoji': '🇫🇷'},
        {'language': 'Hindi', 'greeting': 'Namaste', 'emoji': '🇮🇳'},
        {'language': 'Japanese', 'greeting': 'Konnichiwa', 'emoji': '🇯🇵'},
        {'language': 'Chinese', 'greeting': 'Ni Hao', 'emoji': '🇨🇳'},
        {'language': 'Arabic', 'greeting': 'Salaam', 'emoji': '🇸🇦'},
        {'language': 'Swahili', 'greeting': 'Jambo', 'emoji': '🇰🇪'},
        {'language': 'Korean', 'greeting': 'Annyeong', 'emoji': '🇰🇷'},
        {'language': 'German', 'greeting': 'Guten Tag', 'emoji': '🇩🇪'},
      ],
    },
    {
      'title': 'World Foods',
      'emoji': '🍜',
      'color': Color(0xFFFF5722),
      'foods': [
        {'food': 'Pizza', 'country': 'Italy', 'emoji': '🍕'},
        {'food': 'Sushi', 'country': 'Japan', 'emoji': '🍣'},
        {'food': 'Tacos', 'country': 'Mexico', 'emoji': '🌮'},
        {'food': 'Curry', 'country': 'India', 'emoji': '🍛'},
        {'food': 'Croissant', 'country': 'France', 'emoji': '🥐'},
        {'food': 'Noodles', 'country': 'China', 'emoji': '🍜'},
        {'food': 'Kebab', 'country': 'Turkey', 'emoji': '🥙'},
        {'food': 'Falafel', 'country': 'Middle East', 'emoji': '🧆'},
      ],
    },
    {
      'title': 'World Celebrations',
      'emoji': '🎉',
      'color': Color(0xFF673AB7),
      'celebrations': [
        {
          'festival': 'Diwali',
          'country': 'India',
          'emoji': '🪔',
          'about': 'Festival of Lights'
        },
        {
          'festival': 'Christmas',
          'country': 'Worldwide',
          'emoji': '🎄',
          'about': 'Birth of Jesus'
        },
        {
          'festival': 'Chinese New Year',
          'country': 'China',
          'emoji': '🧧',
          'about': 'Lunar New Year'
        },
        {
          'festival': 'Holi',
          'country': 'India',
          'emoji': '🎨',
          'about': 'Festival of Colors'
        },
        {
          'festival': 'Eid',
          'country': 'Islamic World',
          'emoji': '🌙',
          'about': 'End of Ramadan'
        },
        {
          'festival': 'Carnival',
          'country': 'Brazil',
          'emoji': '🎭',
          'about': 'Dance & Costumes'
        },
      ],
    },
    {
      'title': 'Be a World Citizen!',
      'emoji': '🌟',
      'color': Color(0xFF795548),
      'tips': [
        {
          'tip': 'Respect all cultures',
          'emoji': '🙏',
          'desc': 'Every culture is special'
        },
        {
          'tip': 'Try new foods',
          'emoji': '🍴',
          'desc': 'Taste dishes from other countries'
        },
        {
          'tip': 'Learn new words',
          'emoji': '📚',
          'desc': 'Say hello in different languages'
        },
        {
          'tip': 'Celebrate diversity',
          'emoji': '🌈',
          'desc': 'Our differences make us beautiful'
        },
        {
          'tip': 'Make global friends',
          'emoji': '🤝',
          'desc': 'Connect with kids worldwide'
        },
        {
          'tip': 'Be curious',
          'emoji': '🔍',
          'desc': 'Ask questions and learn'
        },
      ],
      'motto': 'Different cultures, One world, One family!',
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
          'Global Cultures',
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
        return _buildIntroSection(section);
      case 1:
      case 2:
      case 3:
      case 4:
        return _buildCulturesSection(section);
      case 5:
        return _buildGreetingsSection(section);
      case 6:
        return _buildFoodsSection(section);
      case 7:
        return _buildCelebrationsSection(section);
      case 8:
        return _buildCitizenSection(section);
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
          'Culture includes:',
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
          children: List.generate(section['elements'].length, (index) {
            final element = section['elements'][index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(element['emoji'], style: TextStyle(fontSize: 36)),
                  SizedBox(height: 4),
                  Text(
                    element['name'],
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
      ],
    );
  }

  Widget _buildCulturesSection(Map<String, dynamic> section) {
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
        ...List.generate(section['cultures'].length, (index) {
          final culture = section['cultures'][index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(culture['flag'], style: TextStyle(fontSize: 40)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            culture['country'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: section['color'],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: section['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              culture['greeting'],
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: section['color'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCultureItem(
                          '🍜', 'Food', culture['food'], section['color']),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildCultureItem(
                          '👘', 'Dress', culture['dress'], section['color']),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildCultureItem(
                    '🎉', 'Festival', culture['festival'], section['color']),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCultureItem(
      String emoji, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingsSection(Map<String, dynamic> section) {
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
          'Say Hello in different languages!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: List.generate(section['greetings'].length, (index) {
            final greeting = section['greetings'][index];
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(greeting['emoji'], style: TextStyle(fontSize: 24)),
                      SizedBox(width: 8),
                      Text(
                        greeting['language'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    greeting['greeting'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
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

  Widget _buildFoodsSection(Map<String, dynamic> section) {
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
          'Delicious dishes from around the world!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(section['foods'].length, (index) {
            final food = section['foods'][index];
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(food['emoji'], style: TextStyle(fontSize: 40)),
                  SizedBox(height: 8),
                  Text(
                    food['food'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: section['color'],
                    ),
                  ),
                  Text(
                    food['country'],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  Widget _buildCelebrationsSection(Map<String, dynamic> section) {
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
          'Festivals celebrated around the world!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 24),
        ...List.generate(section['celebrations'].length, (index) {
          final celebration = section['celebrations'][index];
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
                  child: Text(celebration['emoji'],
                      style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        celebration['festival'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        celebration['country'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        celebration['about'],
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

  Widget _buildCitizenSection(Map<String, dynamic> section) {
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
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(tip['emoji'], style: TextStyle(fontSize: 24)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['tip'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                      ),
                      Text(
                        tip['desc'],
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
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text('🌍🤝🌏', style: TextStyle(fontSize: 36)),
              SizedBox(height: 8),
              Text(
                section['motto'],
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
