import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WorldMapPage extends StatefulWidget {
  const WorldMapPage({super.key});

  @override
  State<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedContinent;

  final List<Map<String, dynamic>> continents = [
    {
      'name': 'Asia',
      'emoji': '🌏',
      'color': Color(0xFFFF6B6B),
      'countries': 48,
      'population': '4.7 Billion',
      'largestCountry': 'Russia/China',
      'funFact': 'Asia is the largest continent and home to Mount Everest!',
      'famousFor': ['Great Wall of China', 'Taj Mahal', 'Mount Fuji'],
    },
    {
      'name': 'Africa',
      'emoji': '🌍',
      'color': Color(0xFF4ECDC4),
      'countries': 54,
      'population': '1.4 Billion',
      'largestCountry': 'Algeria',
      'funFact': 'Africa has the longest river - the Nile!',
      'famousFor': ['Pyramids of Giza', 'Safari', 'Victoria Falls'],
    },
    {
      'name': 'North America',
      'emoji': '🌎',
      'color': Color(0xFF45B7D1),
      'countries': 23,
      'population': '580 Million',
      'largestCountry': 'Canada',
      'funFact': 'North America has the Grand Canyon!',
      'famousFor': ['Statue of Liberty', 'Niagara Falls', 'Hollywood'],
    },
    {
      'name': 'South America',
      'emoji': '🌎',
      'color': Color(0xFF96CEB4),
      'countries': 12,
      'population': '430 Million',
      'largestCountry': 'Brazil',
      'funFact': 'South America has the Amazon Rainforest!',
      'famousFor': ['Amazon River', 'Machu Picchu', 'Christ the Redeemer'],
    },
    {
      'name': 'Europe',
      'emoji': '🌍',
      'color': Color(0xFFDDA0DD),
      'countries': 44,
      'population': '750 Million',
      'largestCountry': 'Ukraine',
      'funFact': 'Europe has the most countries in a small area!',
      'famousFor': ['Eiffel Tower', 'Colosseum', 'Big Ben'],
    },
    {
      'name': 'Australia',
      'emoji': '🌏',
      'color': Color(0xFFFFB347),
      'countries': 1,
      'population': '25 Million',
      'largestCountry': 'Australia',
      'funFact': 'Australia is both a country and a continent!',
      'famousFor': ['Sydney Opera House', 'Great Barrier Reef', 'Kangaroos'],
    },
    {
      'name': 'Antarctica',
      'emoji': '🧊',
      'color': Color(0xFF87CEEB),
      'countries': 0,
      'population': '~5,000 researchers',
      'largestCountry': 'No countries',
      'funFact': 'Antarctica is the coldest place on Earth!',
      'famousFor': ['Penguins', 'Icebergs', 'Research Stations'],
    },
  ];

  final List<Map<String, dynamic>> oceans = [
    {'name': 'Pacific Ocean', 'emoji': '🌊', 'size': 'Largest'},
    {'name': 'Atlantic Ocean', 'emoji': '🌊', 'size': '2nd Largest'},
    {'name': 'Indian Ocean', 'emoji': '🌊', 'size': '3rd Largest'},
    {'name': 'Arctic Ocean', 'emoji': '❄️', 'size': 'Smallest'},
    {'name': 'Southern Ocean', 'emoji': '🐧', 'size': 'Around Antarctica'},
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
          'World Map for Kids',
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
        decoration: const BoxDecoration(
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
              Expanded(
                child: selectedContinent == null
                    ? _buildMainView()
                    : _buildContinentDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildMainView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Earth Animation
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 0.1,
                  child: child,
                );
              },
              child: const Text('🌍', style: TextStyle(fontSize: 80)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tap a continent to explore!',
              style: GoogleFonts.nunito(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Continents Section
          Text(
            '🌍 7 Continents',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...continents.map((continent) => _buildContinentTile(continent)),
          const SizedBox(height: 24),
          // Oceans Section
          Text(
            '🌊 5 Oceans',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: oceans.map((ocean) => _buildOceanChip(ocean)).toList(),
          ),
          const SizedBox(height: 24),
          // Fun Facts Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Did You Know?',
                      style: GoogleFonts.poppins(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Earth is called the "Blue Planet" because 71% is water!\n'
                  '• There are 195 countries in the world\n'
                  '• The equator divides Earth into North and South',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinentTile(Map<String, dynamic> continent) {
    return GestureDetector(
      onTap: () {
        _speak(continent['name']);
        setState(() {
          selectedContinent = continent['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              continent['color'].withValues(alpha: 0.8),
              continent['color'].withValues(alpha: 0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: continent['color'].withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(continent['emoji'], style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    continent['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${continent['countries']} countries • ${continent['population']}',
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOceanChip(Map<String, dynamic> ocean) {
    return GestureDetector(
      onTap: () => _speak(ocean['name']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ocean['emoji'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ocean['name'],
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  ocean['size'],
                  style: GoogleFonts.nunito(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinentDetail() {
    final continent = continents.firstWhere((c) => c['name'] == selectedContinent);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: continent['color'].withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(continent['emoji'], style: const TextStyle(fontSize: 80)),
                const SizedBox(height: 16),
                Text(
                  continent['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: continent['color'],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Info Cards
          _buildDetailCard('🏳️', 'Countries', '${continent['countries']}', continent['color']),
          _buildDetailCard('👥', 'Population', continent['population'], continent['color']),
          _buildDetailCard('📏', 'Largest', continent['largestCountry'], continent['color']),
          // Famous Places
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏛️', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Famous For:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: continent['color'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (continent['famousFor'] as List).map((place) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: continent['color'].withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        place,
                        style: GoogleFonts.nunito(
                          color: continent['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
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
                          color: Colors.amber,
                        ),
                      ),
                      Text(
                        continent['funFact'],
                        style: GoogleFonts.nunito(
                          color: Colors.white,
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

  Widget _buildDetailCard(String emoji, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
