import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CountriesFlagsPage extends StatefulWidget {
  const CountriesFlagsPage({super.key});

  @override
  State<CountriesFlagsPage> createState() => _CountriesFlagsPageState();
}

class _CountriesFlagsPageState extends State<CountriesFlagsPage> {
  final FlutterTts flutterTts = FlutterTts();
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> countries = [
    {
      'name': 'India',
      'capital': 'New Delhi',
      'flag': '🇮🇳',
      'continent': 'Asia',
      'language': 'Hindi, English',
      'currency': 'Indian Rupee',
      'color1': Color(0xFFFF9933),
      'color2': Color(0xFF138808),
      'funFact': 'India has the largest postal network in the world!',
    },
    {
      'name': 'United States',
      'capital': 'Washington D.C.',
      'flag': '🇺🇸',
      'continent': 'North America',
      'language': 'English',
      'currency': 'US Dollar',
      'color1': Color(0xFF3C3B6E),
      'color2': Color(0xFFB22234),
      'funFact': 'The US has no official language!',
    },
    {
      'name': 'United Kingdom',
      'capital': 'London',
      'flag': '🇬🇧',
      'continent': 'Europe',
      'language': 'English',
      'currency': 'Pound Sterling',
      'color1': Color(0xFF012169),
      'color2': Color(0xFFC8102E),
      'funFact': 'Big Ben is actually the name of the bell, not the tower!',
    },
    {
      'name': 'Japan',
      'capital': 'Tokyo',
      'flag': '🇯🇵',
      'continent': 'Asia',
      'language': 'Japanese',
      'currency': 'Japanese Yen',
      'color1': Color(0xFFBC002D),
      'color2': Color(0xFFFFFFFF),
      'funFact': 'Japan has over 6,800 islands!',
    },
    {
      'name': 'Australia',
      'capital': 'Canberra',
      'flag': '🇦🇺',
      'continent': 'Oceania',
      'language': 'English',
      'currency': 'Australian Dollar',
      'color1': Color(0xFF00008B),
      'color2': Color(0xFFFFD700),
      'funFact': 'Australia has the longest fence in the world!',
    },
    {
      'name': 'Brazil',
      'capital': 'Brasília',
      'flag': '🇧🇷',
      'continent': 'South America',
      'language': 'Portuguese',
      'currency': 'Brazilian Real',
      'color1': Color(0xFF009739),
      'color2': Color(0xFFFEDD00),
      'funFact': 'Brazil is home to the Amazon Rainforest!',
    },
    {
      'name': 'France',
      'capital': 'Paris',
      'flag': '🇫🇷',
      'continent': 'Europe',
      'language': 'French',
      'currency': 'Euro',
      'color1': Color(0xFF0055A4),
      'color2': Color(0xFFEF4135),
      'funFact': 'France is the most visited country in the world!',
    },
    {
      'name': 'China',
      'capital': 'Beijing',
      'flag': '🇨🇳',
      'continent': 'Asia',
      'language': 'Mandarin Chinese',
      'currency': 'Chinese Yuan',
      'color1': Color(0xFFDE2910),
      'color2': Color(0xFFFFDE00),
      'funFact': 'China invented paper, compass, and fireworks!',
    },
    {
      'name': 'Germany',
      'capital': 'Berlin',
      'flag': '🇩🇪',
      'continent': 'Europe',
      'language': 'German',
      'currency': 'Euro',
      'color1': Color(0xFF000000),
      'color2': Color(0xFFFFCC00),
      'funFact': 'Germany has over 20,000 castles!',
    },
    {
      'name': 'Canada',
      'capital': 'Ottawa',
      'flag': '🇨🇦',
      'continent': 'North America',
      'language': 'English, French',
      'currency': 'Canadian Dollar',
      'color1': Color(0xFFFF0000),
      'color2': Color(0xFFFFFFFF),
      'funFact': 'Canada has more lakes than all other countries combined!',
    },
    {
      'name': 'Russia',
      'capital': 'Moscow',
      'flag': '🇷🇺',
      'continent': 'Europe/Asia',
      'language': 'Russian',
      'currency': 'Russian Ruble',
      'color1': Color(0xFF0039A6),
      'color2': Color(0xFFD52B1E),
      'funFact': 'Russia is the largest country in the world!',
    },
    {
      'name': 'Egypt',
      'capital': 'Cairo',
      'flag': '🇪🇬',
      'continent': 'Africa',
      'language': 'Arabic',
      'currency': 'Egyptian Pound',
      'color1': Color(0xFFCE1126),
      'color2': Color(0xFF000000),
      'funFact': 'The Great Pyramid is one of the Seven Wonders!',
    },
    {
      'name': 'South Africa',
      'capital': 'Pretoria',
      'flag': '🇿🇦',
      'continent': 'Africa',
      'language': '11 Official Languages',
      'currency': 'South African Rand',
      'color1': Color(0xFF007749),
      'color2': Color(0xFFFFB81C),
      'funFact': 'South Africa has 3 capital cities!',
    },
    {
      'name': 'Italy',
      'capital': 'Rome',
      'flag': '🇮🇹',
      'continent': 'Europe',
      'language': 'Italian',
      'currency': 'Euro',
      'color1': Color(0xFF009246),
      'color2': Color(0xFFCE2B37),
      'funFact': 'Italy has the most UNESCO World Heritage Sites!',
    },
    {
      'name': 'Spain',
      'capital': 'Madrid',
      'flag': '🇪🇸',
      'continent': 'Europe',
      'language': 'Spanish',
      'currency': 'Euro',
      'color1': Color(0xFFAA151B),
      'color2': Color(0xFFF1BF00),
      'funFact': 'Spanish is spoken in 21 countries!',
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
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    return _buildCountryCard(countries[index]);
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
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '${currentIndex + 1}/${countries.length}',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentIndex + 1) / countries.length,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCard(Map<String, dynamic> country) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Flag
          GestureDetector(
            onTap: () => _speak(country['name']),
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
                  Text(
                    country['flag'],
                    style: const TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        country['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: country['color1'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.volume_up,
                        color: country['color1'],
                        size: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Info Cards
          _buildInfoCard('🏛️', 'Capital', country['capital'], country['color1']),
          _buildInfoCard('🌍', 'Continent', country['continent'], country['color1']),
          _buildInfoCard('🗣️', 'Language', country['language'], country['color1']),
          _buildInfoCard('💰', 'Currency', country['currency'], country['color1']),
          // Fun Fact
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.amber,
                width: 2,
              ),
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
                        country['funFact'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey.shade700,
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

  Widget _buildInfoCard(String emoji, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: GoogleFonts.nunito(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
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
                foregroundColor: countries[currentIndex]['color1'],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 120),
          if (currentIndex < countries.length - 1)
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
                foregroundColor: countries[currentIndex]['color1'],
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
