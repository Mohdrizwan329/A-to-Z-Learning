import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class InfographicsPage extends StatefulWidget {
  const InfographicsPage({super.key});

  @override
  State<InfographicsPage> createState() => _InfographicsPageState();
}

class _InfographicsPageState extends State<InfographicsPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> bodyPartsInfographics = [
    {
      'title': 'My Body Parts',
      'emoji': '🧒',
      'color': Color(0xFF4ECDC4),
      'parts': [
        {'name': 'Head', 'emoji': '🧠', 'fact': 'Brain lives here! It helps you think.', 'position': Offset(0.5, 0.1)},
        {'name': 'Eyes', 'emoji': '👀', 'fact': 'Two eyes help you see the world!', 'position': Offset(0.5, 0.15)},
        {'name': 'Ears', 'emoji': '👂', 'fact': 'Ears help you hear sounds!', 'position': Offset(0.3, 0.15)},
        {'name': 'Nose', 'emoji': '👃', 'fact': 'Nose helps you smell flowers!', 'position': Offset(0.5, 0.2)},
        {'name': 'Mouth', 'emoji': '👄', 'fact': 'Mouth helps you eat and talk!', 'position': Offset(0.5, 0.25)},
        {'name': 'Hands', 'emoji': '🖐️', 'fact': 'Hands help you hold and write!', 'position': Offset(0.2, 0.5)},
        {'name': 'Heart', 'emoji': '❤️', 'fact': 'Heart pumps blood in your body!', 'position': Offset(0.5, 0.4)},
        {'name': 'Legs', 'emoji': '🦵', 'fact': 'Legs help you walk and run!', 'position': Offset(0.5, 0.75)},
        {'name': 'Feet', 'emoji': '🦶', 'fact': 'Feet help you stand and balance!', 'position': Offset(0.5, 0.9)},
      ],
    },
  ];

  final List<Map<String, dynamic>> solarSystemInfographics = [
    {
      'title': 'Our Solar System',
      'emoji': '🌞',
      'color': Color(0xFFFFD93D),
      'planets': [
        {'name': 'Sun', 'emoji': '☀️', 'fact': 'The Sun is a giant ball of fire!', 'color': Color(0xFFFFD93D), 'size': 80.0},
        {'name': 'Mercury', 'emoji': '🪨', 'fact': 'Smallest and closest to Sun!', 'color': Color(0xFF9E9E9E), 'size': 20.0},
        {'name': 'Venus', 'emoji': '🌕', 'fact': 'Hottest planet! Very cloudy.', 'color': Color(0xFFFFB74D), 'size': 30.0},
        {'name': 'Earth', 'emoji': '🌍', 'fact': 'Our home! Has water and life.', 'color': Color(0xFF4CAF50), 'size': 32.0},
        {'name': 'Mars', 'emoji': '🔴', 'fact': 'The Red Planet! Has mountains.', 'color': Color(0xFFE53935), 'size': 28.0},
        {'name': 'Jupiter', 'emoji': '🟤', 'fact': 'Biggest planet! Has many moons.', 'color': Color(0xFFFF8A65), 'size': 55.0},
        {'name': 'Saturn', 'emoji': '🪐', 'fact': 'Has beautiful rings around it!', 'color': Color(0xFFFFCC80), 'size': 50.0},
        {'name': 'Uranus', 'emoji': '🔵', 'fact': 'Tilted planet! Very cold.', 'color': Color(0xFF4DD0E1), 'size': 40.0},
        {'name': 'Neptune', 'emoji': '🔵', 'fact': 'Farthest planet! Very windy.', 'color': Color(0xFF1E88E5), 'size': 38.0},
      ],
    },
  ];

  final List<Map<String, dynamic>> foodPyramidInfographics = [
    {
      'title': 'Healthy Food Pyramid',
      'emoji': '🥗',
      'color': Color(0xFF56D97F),
      'levels': [
        {
          'name': 'Sweets & Fats',
          'emoji': '🍬🍫🍰',
          'items': ['Candy', 'Cake', 'Chips'],
          'advice': 'Eat very little! Only sometimes.',
          'color': Color(0xFFFF6B6B),
          'height': 0.12,
        },
        {
          'name': 'Dairy & Protein',
          'emoji': '🥛🍗🥚',
          'items': ['Milk', 'Eggs', 'Chicken', 'Fish'],
          'advice': 'Eat 2-3 times a day. Makes you strong!',
          'color': Color(0xFF667EEA),
          'height': 0.18,
        },
        {
          'name': 'Fruits & Vegetables',
          'emoji': '🍎🥕🥦',
          'items': ['Apples', 'Carrots', 'Broccoli', 'Oranges'],
          'advice': 'Eat lots! 5 portions every day.',
          'color': Color(0xFF56D97F),
          'height': 0.25,
        },
        {
          'name': 'Grains & Cereals',
          'emoji': '🍞🍚🥣',
          'items': ['Bread', 'Rice', 'Cereal', 'Pasta'],
          'advice': 'Eat most! Gives you energy.',
          'color': Color(0xFFFFAA5A),
          'height': 0.35,
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> animalHabitats = [
    {
      'title': 'Where Animals Live',
      'emoji': '🏠',
      'color': Color(0xFFA78BFA),
      'habitats': [
        {
          'name': 'Forest',
          'emoji': '🌲',
          'animals': ['🦁 Lion', '🐘 Elephant', '🦊 Fox', '🐻 Bear', '🦌 Deer'],
          'color': Color(0xFF2E7D32),
          'fact': 'Forests have many trees and animals!',
        },
        {
          'name': 'Ocean',
          'emoji': '🌊',
          'animals': ['🐋 Whale', '🐬 Dolphin', '🦈 Shark', '🐙 Octopus', '🐠 Fish'],
          'color': Color(0xFF1565C0),
          'fact': 'Oceans are home to many sea creatures!',
        },
        {
          'name': 'Desert',
          'emoji': '🏜️',
          'animals': ['🐫 Camel', '🦎 Lizard', '🦂 Scorpion', '🐍 Snake'],
          'color': Color(0xFFFFB74D),
          'fact': 'Deserts are hot and dry places!',
        },
        {
          'name': 'Arctic',
          'emoji': '🧊',
          'animals': ['🐧 Penguin', '🐻‍❄️ Polar Bear', '🦭 Seal', '🐋 Whale'],
          'color': Color(0xFF4DD0E1),
          'fact': 'Arctic is very cold with ice and snow!',
        },
        {
          'name': 'Farm',
          'emoji': '🏡',
          'animals': ['🐄 Cow', '🐷 Pig', '🐔 Chicken', '🐑 Sheep', '🐴 Horse'],
          'color': Color(0xFF8D6E63),
          'fact': 'Farms have animals that help us!',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> weatherInfographics = [
    {
      'title': 'Weather Types',
      'emoji': '🌤️',
      'color': Color(0xFF64B5F6),
      'weathers': [
        {'name': 'Sunny', 'emoji': '☀️', 'description': 'Bright and warm! Great for playing outside.', 'color': Color(0xFFFFD93D)},
        {'name': 'Rainy', 'emoji': '🌧️', 'description': 'Water falls from clouds. Use umbrella!', 'color': Color(0xFF64B5F6)},
        {'name': 'Cloudy', 'emoji': '☁️', 'description': 'Sky is covered with clouds. No sun today.', 'color': Color(0xFF90A4AE)},
        {'name': 'Snowy', 'emoji': '❄️', 'description': 'Cold and white! Build a snowman.', 'color': Color(0xFFE1F5FE)},
        {'name': 'Windy', 'emoji': '💨', 'description': 'Air moves fast! Hold your hat.', 'color': Color(0xFFB0BEC5)},
        {'name': 'Stormy', 'emoji': '⛈️', 'description': 'Thunder and lightning! Stay inside.', 'color': Color(0xFF5C6BC0)},
      ],
    },
  ];

  final List<Map<String, dynamic>> lifecycleInfographics = [
    {
      'title': 'Life Cycles',
      'emoji': '🔄',
      'color': Color(0xFF81C784),
      'cycles': [
        {
          'name': 'Butterfly',
          'stages': [
            {'stage': 'Egg', 'emoji': '🥚', 'desc': 'Tiny egg on a leaf'},
            {'stage': 'Caterpillar', 'emoji': '🐛', 'desc': 'Eats lots of leaves'},
            {'stage': 'Chrysalis', 'emoji': '🫛', 'desc': 'Transforms inside'},
            {'stage': 'Butterfly', 'emoji': '🦋', 'desc': 'Beautiful wings!'},
          ],
          'color': Color(0xFFA78BFA),
        },
        {
          'name': 'Frog',
          'stages': [
            {'stage': 'Eggs', 'emoji': '🔵', 'desc': 'Eggs in water'},
            {'stage': 'Tadpole', 'emoji': '🐟', 'desc': 'Baby frog with tail'},
            {'stage': 'Froglet', 'emoji': '🐸', 'desc': 'Grows legs'},
            {'stage': 'Adult Frog', 'emoji': '🐸', 'desc': 'Jumps and croaks!'},
          ],
          'color': Color(0xFF4CAF50),
        },
        {
          'name': 'Plant',
          'stages': [
            {'stage': 'Seed', 'emoji': '🌰', 'desc': 'Small seed planted'},
            {'stage': 'Sprout', 'emoji': '🌱', 'desc': 'Baby plant grows'},
            {'stage': 'Plant', 'emoji': '🌿', 'desc': 'Leaves grow big'},
            {'stage': 'Flower', 'emoji': '🌸', 'desc': 'Beautiful bloom!'},
          ],
          'color': Color(0xFFE91E63),
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 6, vsync: this);
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
          onPressed: () {
            flutterTts.stop();
            Get.back();
          },
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
        title: const Text("Infographics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Body", icon: Icon(Icons.accessibility_new, size: 18)),
            Tab(text: "Space", icon: Icon(Icons.rocket_launch, size: 18)),
            Tab(text: "Food", icon: Icon(Icons.restaurant, size: 18)),
            Tab(text: "Animals", icon: Icon(Icons.pets, size: 18)),
            Tab(text: "Weather", icon: Icon(Icons.wb_sunny, size: 18)),
            Tab(text: "Life Cycle", icon: Icon(Icons.loop, size: 18)),
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
            _buildBodyPartsInfographic(),
            _buildSolarSystemInfographic(),
            _buildFoodPyramidInfographic(),
            _buildAnimalHabitatsInfographic(),
            _buildWeatherInfographic(),
            _buildLifecycleInfographic(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildBodyPartsInfographic() {
    final data = bodyPartsInfographics[0];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🧒", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(data['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Tap each part to learn!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 20),
          ...(data['parts'] as List<Map<String, dynamic>>).map((part) {
            return GestureDetector(
              onTap: () { TtsService.to.speak(part['name']); _showPartDetails(part, data['color']); },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: data['color'].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Text(part['emoji'], style: const TextStyle(fontSize: 35)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(part['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(part['fact'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    Icon(Icons.volume_up, color: data['color']),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSolarSystemInfographic() {
    final data = solarSystemInfographics[0];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🌞", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(data['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Explore our solar system!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: (data['planets'] as List<Map<String, dynamic>>).map((planet) {
                return GestureDetector(
                  onTap: () { TtsService.to.speak(planet['name']); _showPlanetDetails(planet); },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: planet['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: planet['color'].withValues(alpha: 0.5), width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: planet['size'],
                          height: planet['size'],
                          decoration: BoxDecoration(
                            color: planet['color'],
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: planet['color'].withValues(alpha: 0.5), blurRadius: 10)],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(planet['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(planet['fact'], style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                            ],
                          ),
                        ),
                        Text(planet['emoji'], style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPyramidInfographic() {
    final data = foodPyramidInfographics[0];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🥗", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(data['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Eat healthy, stay healthy!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 20),
          ...(data['levels'] as List<Map<String, dynamic>>).reversed.map((level) {
            return GestureDetector(
              onTap: () { TtsService.to.speak(level['name']); _showFoodLevelDetails(level); },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ClipPath(
                  clipper: TrapezoidClipper(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: level['color'],
                    ),
                    child: Column(
                      children: [
                        Text(level['emoji'], style: const TextStyle(fontSize: 30)),
                        const SizedBox(height: 4),
                        Text(level['name'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(level['advice'], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnimalHabitatsInfographic() {
    final data = animalHabitats[0];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🏠", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(data['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Discover animal homes!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 20),
          ...(data['habitats'] as List<Map<String, dynamic>>).map((habitat) {
            return GestureDetector(
              onTap: () { TtsService.to.speak(habitat['name']); _showHabitatDetails(habitat); },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: habitat['color'].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: habitat['color'],
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Text(habitat['emoji'], style: const TextStyle(fontSize: 35)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(habitat['name'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                Text(habitat['fact'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (habitat['animals'] as List<String>).map((animal) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: habitat['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(animal, style: TextStyle(fontSize: 14, color: habitat['color'])),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeatherInfographic() {
    final data = weatherInfographics[0];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🌤️", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(data['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Learn about weather!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: (data['weathers'] as List).length,
            itemBuilder: (context, index) {
              final weather = data['weathers'][index];
              return GestureDetector(
                onTap: () {
                  TtsService.to.speak(weather['name']);
                  _speakText("${weather['name']}. ${weather['description']}");
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: weather['color'].withValues(alpha: 0.3), blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(weather['emoji'], style: const TextStyle(fontSize: 45)),
                      const SizedBox(height: 8),
                      Text(weather['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: weather['color'])),
                      const SizedBox(height: 6),
                      Text(weather['description'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLifecycleInfographic() {
    final data = lifecycleInfographics[0];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🔄", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(data['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("See how things grow!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 20),
          ...(data['cycles'] as List<Map<String, dynamic>>).map((cycle) {
            return GestureDetector(
              onTap: () { TtsService.to.speak(cycle['name']); _showLifecycleDetails(cycle); },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: cycle['color'].withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Column(
                  children: [
                    Text("${cycle['name']} Life Cycle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cycle['color'])),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: (cycle['stages'] as List<Map<String, dynamic>>).asMap().entries.map((entry) {
                        final stage = entry.value;
                        final isLast = entry.key == (cycle['stages'] as List).length - 1;
                        return Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: cycle['color'].withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: cycle['color'], width: 2),
                                      ),
                                      child: Center(child: Text(stage['emoji'], style: const TextStyle(fontSize: 22))),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(stage['stage'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: cycle['color'])),
                                  ],
                                ),
                              ),
                              if (!isLast)
                                Icon(Icons.arrow_forward, size: 16, color: cycle['color']),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showPartDetails(Map<String, dynamic> part, Color color) {
    _speakText("${part['name']}. ${part['fact']}");
    Get.snackbar(
      part['name'],
      part['fact'],
      icon: Text(part['emoji'], style: const TextStyle(fontSize: 30)),
      backgroundColor: Colors.white,
      colorText: color,
      duration: const Duration(seconds: 3),
    );
  }

  void _showPlanetDetails(Map<String, dynamic> planet) {
    _speakText("${planet['name']}. ${planet['fact']}");
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: planet['color'],
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: planet['color'].withValues(alpha: 0.5), blurRadius: 30)],
              ),
            ),
            const SizedBox(height: 20),
            Text(planet['name'], style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: planet['color'])),
            const SizedBox(height: 12),
            Text(planet['fact'], style: const TextStyle(fontSize: 16, color: Colors.white70), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(backgroundColor: planet['color']),
              child: const Text("Close", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodLevelDetails(Map<String, dynamic> level) {
    _speakText("${level['name']}. ${level['advice']}. Foods include: ${(level['items'] as List).join(', ')}");
  }

  void _showHabitatDetails(Map<String, dynamic> habitat) {
    _speakText("${habitat['name']}. ${habitat['fact']}. Animals here are: ${(habitat['animals'] as List).join(', ')}");
  }

  void _showLifecycleDetails(Map<String, dynamic> cycle) {
    final stages = (cycle['stages'] as List<Map<String, dynamic>>).map((s) => "${s['stage']}: ${s['desc']}").join('. ');
    _speakText("${cycle['name']} life cycle. $stages");
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.1, 0);
    path.lineTo(size.width * 0.9, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
