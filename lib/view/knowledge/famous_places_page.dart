import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FamousPlacesPage extends StatefulWidget {
  const FamousPlacesPage({super.key});

  @override
  State<FamousPlacesPage> createState() => _FamousPlacesPageState();
}

class _FamousPlacesPageState extends State<FamousPlacesPage> {
  final FlutterTts flutterTts = FlutterTts();
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> famousPlaces = [
    {
      'name': 'Taj Mahal',
      'emoji': '🕌',
      'country': 'India',
      'flag': '🇮🇳',
      'city': 'Agra',
      'type': 'Mausoleum',
      'builtIn': '1653',
      'color1': Color(0xFFFFFFFF),
      'color2': Color(0xFFE8D5B7),
      'funFact': 'It took 22 years and 20,000 workers to build!',
      'description': 'A beautiful white marble monument built by Emperor Shah Jahan for his beloved wife Mumtaz Mahal.',
      'isWonder': true,
    },
    {
      'name': 'Great Wall of China',
      'emoji': '🏯',
      'country': 'China',
      'flag': '🇨🇳',
      'city': 'Beijing Region',
      'type': 'Fortification',
      'builtIn': '7th Century BC',
      'color1': Color(0xFF8B4513),
      'color2': Color(0xFF654321),
      'funFact': 'It is over 21,000 kilometers long!',
      'description': 'The longest wall ever built, stretching across mountains and valleys of China.',
      'isWonder': true,
    },
    {
      'name': 'Eiffel Tower',
      'emoji': '🗼',
      'country': 'France',
      'flag': '🇫🇷',
      'city': 'Paris',
      'type': 'Iron Tower',
      'builtIn': '1889',
      'color1': Color(0xFF4A4A4A),
      'color2': Color(0xFF2C2C2C),
      'funFact': 'It was only meant to stand for 20 years!',
      'description': 'A famous iron tower and symbol of Paris, standing 330 meters tall.',
      'isWonder': false,
    },
    {
      'name': 'Pyramids of Giza',
      'emoji': '🔺',
      'country': 'Egypt',
      'flag': '🇪🇬',
      'city': 'Giza',
      'type': 'Ancient Tombs',
      'builtIn': '2560 BC',
      'color1': Color(0xFFE6C88C),
      'color2': Color(0xFFD4A84B),
      'funFact': 'They are over 4,500 years old!',
      'description': 'Ancient pyramid tombs of Egyptian pharaohs, the only remaining Ancient Wonder.',
      'isWonder': true,
    },
    {
      'name': 'Statue of Liberty',
      'emoji': '🗽',
      'country': 'United States',
      'flag': '🇺🇸',
      'city': 'New York',
      'type': 'Statue',
      'builtIn': '1886',
      'color1': Color(0xFF4DB6AC),
      'color2': Color(0xFF26A69A),
      'funFact': 'It was a gift from France to America!',
      'description': 'A copper statue representing freedom and democracy, welcoming visitors to America.',
      'isWonder': false,
    },
    {
      'name': 'Colosseum',
      'emoji': '🏟️',
      'country': 'Italy',
      'flag': '🇮🇹',
      'city': 'Rome',
      'type': 'Amphitheater',
      'builtIn': '80 AD',
      'color1': Color(0xFFD4A574),
      'color2': Color(0xFFB8956E),
      'funFact': 'It could hold 50,000 to 80,000 spectators!',
      'description': 'An ancient Roman arena where gladiators fought and games were held.',
      'isWonder': true,
    },
    {
      'name': 'Machu Picchu',
      'emoji': '🏔️',
      'country': 'Peru',
      'flag': '🇵🇪',
      'city': 'Cusco Region',
      'type': 'Ancient City',
      'builtIn': '1450 AD',
      'color1': Color(0xFF4CAF50),
      'color2': Color(0xFF388E3C),
      'funFact': 'It was hidden from the world for 400 years!',
      'description': 'An ancient Incan city high in the Andes Mountains of Peru.',
      'isWonder': true,
    },
    {
      'name': 'Big Ben',
      'emoji': '🕰️',
      'country': 'United Kingdom',
      'flag': '🇬🇧',
      'city': 'London',
      'type': 'Clock Tower',
      'builtIn': '1859',
      'color1': Color(0xFF5D4037),
      'color2': Color(0xFF3E2723),
      'funFact': 'Big Ben is actually the name of the bell, not the tower!',
      'description': 'A famous clock tower at the Houses of Parliament in London.',
      'isWonder': false,
    },
    {
      'name': 'Sydney Opera House',
      'emoji': '🎭',
      'country': 'Australia',
      'flag': '🇦🇺',
      'city': 'Sydney',
      'type': 'Performance Venue',
      'builtIn': '1973',
      'color1': Color(0xFFFFFFFF),
      'color2': Color(0xFF90CAF9),
      'funFact': 'Its roof has over 1 million tiles!',
      'description': 'A stunning building with sail-shaped roofs, home to performances and concerts.',
      'isWonder': false,
    },
    {
      'name': 'Christ the Redeemer',
      'emoji': '✝️',
      'country': 'Brazil',
      'flag': '🇧🇷',
      'city': 'Rio de Janeiro',
      'type': 'Statue',
      'builtIn': '1931',
      'color1': Color(0xFF009688),
      'color2': Color(0xFF00796B),
      'funFact': 'The statue is 30 meters tall with arms 28 meters wide!',
      'description': 'A giant statue of Jesus Christ overlooking Rio de Janeiro from a mountaintop.',
      'isWonder': true,
    },
    {
      'name': 'Petra',
      'emoji': '🏛️',
      'country': 'Jordan',
      'flag': '🇯🇴',
      'city': 'Petra',
      'type': 'Ancient City',
      'builtIn': '312 BC',
      'color1': Color(0xFFE57373),
      'color2': Color(0xFFD32F2F),
      'funFact': 'It is carved directly into pink sandstone cliffs!',
      'description': 'An ancient city with buildings carved into rose-red cliffs.',
      'isWonder': true,
    },
    {
      'name': 'Chichen Itza',
      'emoji': '🛕',
      'country': 'Mexico',
      'flag': '🇲🇽',
      'city': 'Yucatan',
      'type': 'Pyramid',
      'builtIn': '600 AD',
      'color1': Color(0xFF8D6E63),
      'color2': Color(0xFF6D4C41),
      'funFact': 'It creates a shadow serpent during equinoxes!',
      'description': 'An ancient Mayan pyramid temple with amazing astronomical features.',
      'isWonder': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
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
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: famousPlaces.length,
                  itemBuilder: (context, index) {
                    return _buildPlaceCard(famousPlaces[index]);
                  },
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }
  Color _getTextColor() {
    // Light backgrounds need dark text
    final place = famousPlaces[currentIndex];
    if (place['name'] == 'Taj Mahal' || place['name'] == 'Sydney Opera House') {
      return Colors.black87;
    }
    return Colors.white;
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '${currentIndex + 1}/${famousPlaces.length}',
            style: GoogleFonts.nunito(
              color: _getTextColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentIndex + 1) / famousPlaces.length,
                backgroundColor: Colors.black.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Main Card
          GestureDetector(
            onTap: () => _speak(place['name']),
            child: Container(
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
                  // Wonder badge
                  if (place['isWonder'])
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            'New 7 Wonder',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    place['emoji'],
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        place['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: place['color2'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.volume_up, color: place['color2'], size: 24),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(place['flag'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '${place['city']}, ${place['country']}',
                        style: GoogleFonts.nunito(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('📖', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    place['description'],
                    style: GoogleFonts.nunito(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Info Cards
          Row(
            children: [
              Expanded(
                child: _buildSmallInfoCard('🏷️', 'Type', place['type'], place['color2']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallInfoCard('📅', 'Built', place['builtIn'], place['color2']),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fun Fact
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fun Fact!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      Text(
                        place['funFact'],
                        style: GoogleFonts.nunito(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard(String emoji, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final place = famousPlaces[currentIndex];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentIndex > 0)
            ElevatedButton.icon(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: place['color2'],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 120),
          if (currentIndex < famousPlaces.length - 1)
            ElevatedButton.icon(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: place['color2'],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
