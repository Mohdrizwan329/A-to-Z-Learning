import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GlobalCulturesPage extends StatefulWidget {
  const GlobalCulturesPage({super.key});

  @override
  State<GlobalCulturesPage> createState() => _GlobalCulturesPageState();
}

class _GlobalCulturesPageState extends State<GlobalCulturesPage> {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedCulture;

  final List<Map<String, dynamic>> cultures = [
    {
      'name': 'Indian Culture',
      'emoji': '🇮🇳',
      'color': Color(0xFFFF9933),
      'greeting': 'Namaste! 🙏',
      'greetingPronunciation': 'nah-mah-stay',
      'food': ['Curry', 'Biryani', 'Samosa', 'Naan'],
      'festival': 'Diwali - Festival of Lights 🪔',
      'clothing': 'Saree & Kurta',
      'music': 'Classical & Bollywood',
      'funFact': 'India has 22 official languages!',
      'dance': 'Bharatanatyam, Kathak',
    },
    {
      'name': 'Japanese Culture',
      'emoji': '🇯🇵',
      'color': Color(0xFFBC002D),
      'greeting': 'Konnichiwa! 👋',
      'greetingPronunciation': 'kon-nee-chee-wah',
      'food': ['Sushi', 'Ramen', 'Tempura', 'Mochi'],
      'festival': 'Hanami - Cherry Blossom Festival 🌸',
      'clothing': 'Kimono',
      'music': 'Traditional & J-Pop',
      'funFact': 'Bowing is a common greeting in Japan!',
      'dance': 'Kabuki, Bon Odori',
    },
    {
      'name': 'Mexican Culture',
      'emoji': '🇲🇽',
      'color': Color(0xFF006847),
      'greeting': 'Hola! 👋',
      'greetingPronunciation': 'oh-lah',
      'food': ['Tacos', 'Burritos', 'Quesadilla', 'Churros'],
      'festival': 'Día de los Muertos - Day of the Dead 💀',
      'clothing': 'Sombrero & Serape',
      'music': 'Mariachi',
      'funFact': 'Mexico gave the world chocolate!',
      'dance': 'Jarabe Tapatío',
    },
    {
      'name': 'Chinese Culture',
      'emoji': '🇨🇳',
      'color': Color(0xFFDE2910),
      'greeting': 'Nǐ hǎo! 你好',
      'greetingPronunciation': 'nee-how',
      'food': ['Dumplings', 'Noodles', 'Dim Sum', 'Rice'],
      'festival': 'Chinese New Year - Spring Festival 🧧',
      'clothing': 'Cheongsam & Hanfu',
      'music': 'Traditional Chinese Opera',
      'funFact': 'Dragons are symbols of good luck in China!',
      'dance': 'Dragon Dance, Lion Dance',
    },
    {
      'name': 'African Culture',
      'emoji': '🌍',
      'color': Color(0xFF008751),
      'greeting': 'Jambo! (Swahili) 👋',
      'greetingPronunciation': 'jahm-boh',
      'food': ['Jollof Rice', 'Fufu', 'Injera', 'Bobotie'],
      'festival': 'Kwanzaa - Harvest Festival 🌾',
      'clothing': 'Dashiki & Kente cloth',
      'music': 'Drums & Afrobeats',
      'funFact': 'Africa has over 2,000 languages!',
      'dance': 'Traditional Tribal Dances',
    },
    {
      'name': 'French Culture',
      'emoji': '🇫🇷',
      'color': Color(0xFF0055A4),
      'greeting': 'Bonjour! 👋',
      'greetingPronunciation': 'bohn-zhoor',
      'food': ['Croissant', 'Baguette', 'Crepes', 'Macarons'],
      'festival': 'Bastille Day - National Day 🎆',
      'clothing': 'Beret & Fashion',
      'music': 'Classical & Chanson',
      'funFact': 'French is spoken on 5 continents!',
      'dance': 'Ballet, Can-can',
    },
    {
      'name': 'Brazilian Culture',
      'emoji': '🇧🇷',
      'color': Color(0xFF009739),
      'greeting': 'Olá! 👋',
      'greetingPronunciation': 'oh-lah',
      'food': ['Feijoada', 'Pão de Queijo', 'Açaí', 'Brigadeiro'],
      'festival': 'Carnival - Street Festival 🎭',
      'clothing': 'Carnival Costumes',
      'music': 'Samba & Bossa Nova',
      'funFact': 'Brazil is the largest country in South America!',
      'dance': 'Samba, Capoeira',
    },
    {
      'name': 'American Culture',
      'emoji': '🇺🇸',
      'color': Color(0xFF3C3B6E),
      'greeting': 'Hello! Hey! 👋',
      'greetingPronunciation': 'heh-loh',
      'food': ['Hamburger', 'Hot Dog', 'Apple Pie', 'BBQ'],
      'festival': 'Thanksgiving - Gratitude Day 🦃',
      'clothing': 'Casual & Diverse',
      'music': 'Jazz, Rock, Hip-hop',
      'funFact': 'Baseball is called America\'s pastime!',
      'dance': 'Hip-hop, Line Dancing',
    },
    {
      'name': 'Australian Culture',
      'emoji': '🇦🇺',
      'color': Color(0xFF00008B),
      'greeting': 'G\'day mate! 👋',
      'greetingPronunciation': 'guh-day mayt',
      'food': ['Vegemite', 'Meat Pie', 'Lamingtons', 'BBQ'],
      'festival': 'Australia Day 🦘',
      'clothing': 'Casual & Akubra Hat',
      'music': 'Didgeridoo & Rock',
      'funFact': 'Aboriginal culture is 65,000 years old!',
      'dance': 'Aboriginal Corroboree',
    },
    {
      'name': 'Italian Culture',
      'emoji': '🇮🇹',
      'color': Color(0xFF009246),
      'greeting': 'Ciao! 👋',
      'greetingPronunciation': 'chow',
      'food': ['Pizza', 'Pasta', 'Gelato', 'Risotto'],
      'festival': 'Venice Carnival 🎭',
      'clothing': 'Fashion Capital Style',
      'music': 'Opera & Folk',
      'funFact': 'Italy has 55 UNESCO World Heritage Sites!',
      'dance': 'Tarantella',
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
                child: selectedCulture == null
                    ? _buildCultureGrid()
                    : _buildCultureDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCultureGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  '🌍 🌎 🌏',
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore cultures around the world!',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Choose a Culture to Explore',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: cultures.length,
            itemBuilder: (context, index) {
              return _buildCultureCard(cultures[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCultureCard(Map<String, dynamic> culture) {
    return GestureDetector(
      onTap: () {
        _speak(culture['name']);
        setState(() {
          selectedCulture = culture['name'];
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              culture['color'],
              culture['color'].withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: culture['color'].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    culture['emoji'],
                    style: const TextStyle(fontSize: 45),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    culture['name'].replaceAll(' Culture', ''),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCultureDetail() {
    final culture = cultures.firstWhere((c) => c['name'] == selectedCulture);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header Card with Greeting
          GestureDetector(
            onTap: () => _speak(culture['greeting']),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: culture['color'].withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(culture['emoji'], style: const TextStyle(fontSize: 70)),
                  const SizedBox(height: 12),
                  Text(
                    culture['greeting'],
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: culture['color'],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '(${culture['greetingPronunciation']})',
                        style: GoogleFonts.nunito(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.volume_up, color: culture['color'], size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Food Section
          _buildInfoSection(
            '🍽️',
            'Traditional Food',
            culture['food'],
            culture['color'],
          ),
          // Festival
          _buildSingleInfoCard('🎉', 'Main Festival', culture['festival'], culture['color']),
          // Clothing
          _buildSingleInfoCard('👗', 'Traditional Clothing', culture['clothing'], culture['color']),
          // Music
          _buildSingleInfoCard('🎵', 'Music', culture['music'], culture['color']),
          // Dance
          _buildSingleInfoCard('💃', 'Dance', culture['dance'], culture['color']),
          // Fun Fact
          Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                        culture['funFact'],
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

  Widget _buildInfoSection(String emoji, String title, List<dynamic> items, Color color) {
    return Container(
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
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map<Widget>((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.nunito(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleInfoCard(String emoji, String title, String value, Color color) {
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
                  title,
                  style: GoogleFonts.nunito(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
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
