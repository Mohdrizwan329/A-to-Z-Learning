import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class CulturalAwarenessPage extends StatefulWidget {
  const CulturalAwarenessPage({super.key});

  @override
  State<CulturalAwarenessPage> createState() => _CulturalAwarenessPageState();
}

class _CulturalAwarenessPageState extends State<CulturalAwarenessPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> traditions = [
    {
      'name': 'Namaste',
      'emoji': '🙏',
      'description': 'Greeting with folded hands to show respect',
      'color': Color(0xFFFF6B6B),
    },
    {
      'name': 'Touching Feet',
      'emoji': '🦶',
      'description': 'Touching elders feet to get their blessings',
      'color': Color(0xFF667EEA),
    },
    {
      'name': 'Rangoli',
      'emoji': '🎨',
      'description': 'Colorful patterns made on floor during festivals',
      'color': Color(0xFF56D97F),
    },
    {
      'name': 'Diya Lighting',
      'emoji': '🪔',
      'description': 'Lighting oil lamps to bring light and positivity',
      'color': Color(0xFFFFAA5A),
    },
    {
      'name': 'Mehndi',
      'emoji': '✋',
      'description': 'Beautiful henna designs on hands for celebrations',
      'color': Color(0xFFA78BFA),
    },
    {
      'name': 'Aarti',
      'emoji': '🔥',
      'description': 'Waving lighted lamp in circular motion as prayer',
      'color': Color(0xFF4ECDC4),
    },
    {
      'name': 'Tilak',
      'emoji': '🔴',
      'description': 'Red mark on forehead for blessings and welcome',
      'color': Color(0xFFFFD93D),
    },
    {
      'name': 'Garland Welcome',
      'emoji': '💐',
      'description': 'Welcoming guests with flower garlands',
      'color': Color(0xFFFF8E53),
    },
  ];

  final List<Map<String, dynamic>> clothing = [
    {
      'name': 'Saree',
      'emoji': '👗',
      'region': 'All India',
      'description': 'Beautiful draped cloth worn by women',
      'color': Color(0xFFFF6B6B),
    },
    {
      'name': 'Kurta Pajama',
      'emoji': '👔',
      'region': 'North India',
      'description': 'Long shirt with loose pants for men',
      'color': Color(0xFF667EEA),
    },
    {
      'name': 'Lehenga Choli',
      'emoji': '👘',
      'region': 'North India',
      'description': 'Long skirt with short blouse for special occasions',
      'color': Color(0xFF56D97F),
    },
    {
      'name': 'Dhoti',
      'emoji': '🩱',
      'region': 'All India',
      'description': 'Wrapped cloth worn by men on lower body',
      'color': Color(0xFFFFAA5A),
    },
    {
      'name': 'Salwar Kameez',
      'emoji': '👚',
      'region': 'North India',
      'description': 'Long tunic with loose pants for women',
      'color': Color(0xFFA78BFA),
    },
    {
      'name': 'Mundu',
      'emoji': '🧣',
      'region': 'Kerala',
      'description': 'White cloth wrapped around waist',
      'color': Color(0xFF4ECDC4),
    },
    {
      'name': 'Turban',
      'emoji': '🎀',
      'region': 'Rajasthan & Punjab',
      'description': 'Colorful headwear showing honor and respect',
      'color': Color(0xFFFFD93D),
    },
    {
      'name': 'Sherwani',
      'emoji': '🥼',
      'region': 'All India',
      'description': 'Long coat worn by groom at weddings',
      'color': Color(0xFFFF8E53),
    },
  ];

  final List<Map<String, dynamic>> foods = [
    {'name': 'Roti', 'emoji': '🫓', 'region': 'North India', 'description': 'Flat bread made from wheat flour', 'color': Color(0xFFFFAA5A)},
    {'name': 'Rice', 'emoji': '🍚', 'region': 'South & East India', 'description': 'Main food in many states', 'color': Color(0xFF4ECDC4)},
    {'name': 'Dal', 'emoji': '🥣', 'region': 'All India', 'description': 'Lentil soup eaten with rice or roti', 'color': Color(0xFFFFD93D)},
    {'name': 'Samosa', 'emoji': '🥟', 'region': 'All India', 'description': 'Triangle snack filled with potatoes', 'color': Color(0xFFFF6B6B)},
    {'name': 'Dosa', 'emoji': '🥞', 'region': 'South India', 'description': 'Crispy crepe made from rice batter', 'color': Color(0xFF667EEA)},
    {'name': 'Biryani', 'emoji': '🍲', 'region': 'Hyderabad', 'description': 'Spiced rice dish with meat or vegetables', 'color': Color(0xFF56D97F)},
    {'name': 'Laddu', 'emoji': '🟡', 'region': 'All India', 'description': 'Sweet ball shaped dessert', 'color': Color(0xFFA78BFA)},
    {'name': 'Chai', 'emoji': '☕', 'region': 'All India', 'description': 'Sweet spiced tea with milk', 'color': Color(0xFFFF8E53)},
  ];

  final List<Map<String, dynamic>> arts = [
    {'name': 'Classical Dance', 'emoji': '💃', 'examples': 'Bharatanatyam, Kathak, Odissi', 'color': Color(0xFFFF6B6B)},
    {'name': 'Folk Dance', 'emoji': '🕺', 'examples': 'Bhangra, Garba, Bihu', 'color': Color(0xFF667EEA)},
    {'name': 'Classical Music', 'emoji': '🎵', 'examples': 'Raag, Carnatic, Hindustani', 'color': Color(0xFF56D97F)},
    {'name': 'Musical Instruments', 'emoji': '🪘', 'examples': 'Tabla, Sitar, Veena, Flute', 'color': Color(0xFFFFAA5A)},
    {'name': 'Painting', 'emoji': '🖼️', 'examples': 'Madhubani, Warli, Tanjore', 'color': Color(0xFFA78BFA)},
    {'name': 'Pottery', 'emoji': '🏺', 'examples': 'Clay pots, Terracotta', 'color': Color(0xFF4ECDC4)},
    {'name': 'Weaving', 'emoji': '🧵', 'examples': 'Silk weaving, Carpet making', 'color': Color(0xFFFFD93D)},
    {'name': 'Sculpture', 'emoji': '🗿', 'examples': 'Stone carving, Metal work', 'color': Color(0xFFFF8E53)},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text("Indian Culture", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: "Traditions", icon: Icon(Icons.auto_awesome, size: 20)),
            Tab(text: "Clothing", icon: Icon(Icons.checkroom, size: 20)),
            Tab(text: "Food", icon: Icon(Icons.restaurant, size: 20)),
            Tab(text: "Arts", icon: Icon(Icons.palette, size: 20)),
          ],
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTraditionsTab(),
            _buildClothingTab(),
            _buildFoodTab(),
            _buildArtsTab(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildTraditionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: traditions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🙏", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Indian Traditions", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Beautiful customs we follow!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final tradition = traditions[index - 1];
        return GestureDetector(
          onTap: () => _speakText("${tradition['name']}. ${tradition['description']}"),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
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
                    color: tradition['color'].withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(tradition['emoji'], style: const TextStyle(fontSize: 32))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tradition['name'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tradition['color'])),
                      const SizedBox(height: 4),
                      Text(tradition['description'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Icon(Icons.volume_up, color: tradition['color']),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClothingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clothing.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("👗", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Traditional Clothing", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Beautiful clothes from different regions!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final cloth = clothing[index - 1];
        return GestureDetector(
          onTap: () => _speakText("${cloth['name']}. ${cloth['description']}"),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [cloth['color'], cloth['color'].withValues(alpha: 0.7)]),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Text(cloth['emoji'], style: const TextStyle(fontSize: 35)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cloth['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(cloth['region'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white70),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(cloth['description'], style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFoodTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: foods.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("🍽️", style: TextStyle(fontSize: 40)),
              Text("Indian Food", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          );
        }
        if (index == 1) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Delicious dishes!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
            ],
          );
        }

        final food = foods[index - 2];
        return GestureDetector(
          onTap: () => _speakText("${food['name']}. ${food['description']}"),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(food['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(food['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: food['color'])),
                const SizedBox(height: 4),
                Text(food['region'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(food['description'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 4),
                Icon(Icons.volume_up, size: 18, color: food['color']),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: arts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🎭", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Arts & Crafts", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Rich artistic heritage of India!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final art = arts[index - 1];
        return GestureDetector(
          onTap: () => _speakText("${art['name']}. Examples include ${art['examples']}"),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [art['color'], art['color'].withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: art['color'].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Text(art['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(art['name'], style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(art['examples'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.volume_up, color: Colors.white70),
              ],
            ),
          ),
        );
      },
    );
  }
}
