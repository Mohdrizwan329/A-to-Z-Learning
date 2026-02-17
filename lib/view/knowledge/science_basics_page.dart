import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class ScienceBasicsPage extends StatefulWidget {
  const ScienceBasicsPage({super.key});

  @override
  State<ScienceBasicsPage> createState() => _ScienceBasicsPageState();
}

class _ScienceBasicsPageState extends State<ScienceBasicsPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  int selectedCategory = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'States of Matter',
      'emoji': '🧊',
      'color': Color(0xFF4ECDC4),
      'items': [
        {'name': 'Solid', 'emoji': '🧊', 'example': 'Ice, Rock, Wood', 'description': 'Has fixed shape and size'},
        {'name': 'Liquid', 'emoji': '💧', 'example': 'Water, Milk, Juice', 'description': 'Takes shape of container'},
        {'name': 'Gas', 'emoji': '💨', 'example': 'Air, Steam, Oxygen', 'description': 'Spreads everywhere'},
      ],
    },
    {
      'name': 'Human Senses',
      'emoji': '👁️',
      'color': Color(0xFFFF6B6B),
      'items': [
        {'name': 'Sight', 'emoji': '👁️', 'organ': 'Eyes', 'description': 'We see with our eyes'},
        {'name': 'Hearing', 'emoji': '👂', 'organ': 'Ears', 'description': 'We hear with our ears'},
        {'name': 'Smell', 'emoji': '👃', 'organ': 'Nose', 'description': 'We smell with our nose'},
        {'name': 'Taste', 'emoji': '👅', 'organ': 'Tongue', 'description': 'We taste with our tongue'},
        {'name': 'Touch', 'emoji': '✋', 'organ': 'Skin', 'description': 'We feel with our skin'},
      ],
    },
    {
      'name': 'Solar System',
      'emoji': '🪐',
      'color': Color(0xFF667EEA),
      'items': [
        {'name': 'Sun', 'emoji': '☀️', 'fact': 'The biggest star in our solar system'},
        {'name': 'Mercury', 'emoji': '🔴', 'fact': 'Closest planet to the Sun'},
        {'name': 'Venus', 'emoji': '🟠', 'fact': 'Hottest planet'},
        {'name': 'Earth', 'emoji': '🌍', 'fact': 'Our home planet with water'},
        {'name': 'Mars', 'emoji': '🔴', 'fact': 'The Red Planet'},
        {'name': 'Jupiter', 'emoji': '🟤', 'fact': 'Largest planet'},
        {'name': 'Saturn', 'emoji': '🪐', 'fact': 'Has beautiful rings'},
        {'name': 'Uranus', 'emoji': '🔵', 'fact': 'Rotates on its side'},
        {'name': 'Neptune', 'emoji': '🔵', 'fact': 'Farthest from Sun'},
      ],
    },
    {
      'name': 'Simple Machines',
      'emoji': '⚙️',
      'color': Color(0xFFFFAA5A),
      'items': [
        {'name': 'Lever', 'emoji': '🎚️', 'example': 'See-saw, Scissors', 'description': 'Lifts heavy things'},
        {'name': 'Wheel', 'emoji': '🛞', 'example': 'Car wheel, Bicycle', 'description': 'Helps things move'},
        {'name': 'Pulley', 'emoji': '🏗️', 'example': 'Well, Flag pole', 'description': 'Lifts things up'},
        {'name': 'Inclined Plane', 'emoji': '📐', 'example': 'Ramp, Slide', 'description': 'Makes lifting easier'},
        {'name': 'Screw', 'emoji': '🔩', 'example': 'Bottle cap, Screw', 'description': 'Holds things together'},
        {'name': 'Wedge', 'emoji': '🔺', 'example': 'Axe, Knife', 'description': 'Splits things apart'},
      ],
    },
    {
      'name': 'Living vs Non-Living',
      'emoji': '🌱',
      'color': Color(0xFF56D97F),
      'items': [
        {'name': 'Living Things', 'emoji': '🌱', 'examples': 'Plants, Animals, Humans', 'traits': 'Grow, Breathe, Eat, Move'},
        {'name': 'Non-Living Things', 'emoji': '🪨', 'examples': 'Rocks, Water, Air', 'traits': 'Don\'t grow or breathe'},
      ],
    },
    {
      'name': 'Energy Types',
      'emoji': '⚡',
      'color': Color(0xFFA78BFA),
      'items': [
        {'name': 'Light Energy', 'emoji': '💡', 'source': 'Sun, Bulb, Fire'},
        {'name': 'Heat Energy', 'emoji': '🔥', 'source': 'Fire, Sun, Stove'},
        {'name': 'Sound Energy', 'emoji': '🔊', 'source': 'Music, Voice, Thunder'},
        {'name': 'Electrical Energy', 'emoji': '⚡', 'source': 'Battery, Power plant'},
        {'name': 'Solar Energy', 'emoji': '☀️', 'source': 'Sun'},
      ],
    },
  ];

  final List<Map<String, dynamic>> experiments = [
    {
      'title': 'Rainbow in a Glass',
      'emoji': '🌈',
      'steps': ['Add sugar and water', 'Add food colors', 'Layer carefully', 'See the rainbow!'],
      'science': 'Different densities create layers',
    },
    {
      'title': 'Volcano Eruption',
      'emoji': '🌋',
      'steps': ['Make a volcano shape', 'Add baking soda', 'Pour vinegar', 'Watch it erupt!'],
      'science': 'Acid + Base = Gas bubbles',
    },
    {
      'title': 'Dancing Raisins',
      'emoji': '🍇',
      'steps': ['Fill glass with soda', 'Drop raisins in', 'Watch them dance!', 'Gas bubbles lift them'],
      'science': 'CO2 bubbles make them float',
    },
    {
      'title': 'Invisible Ink',
      'emoji': '🍋',
      'steps': ['Squeeze lemon juice', 'Write with juice', 'Let it dry', 'Heat to reveal!'],
      'science': 'Lemon juice oxidizes when heated',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
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
        title: const Text("Science Basics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Topics", icon: Icon(Icons.science, size: 20)),
            Tab(text: "Facts", icon: Icon(Icons.lightbulb, size: 20)),
            Tab(text: "Experiments", icon: Icon(Icons.biotech, size: 20)),
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
            _buildTopicsTab(),
            _buildFactsTab(),
            _buildExperimentsTab(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildTopicsTab() {
    return Column(
      children: [
        // Category selector
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selectedCategory == index;
              return GestureDetector(
                onTap: () => setState(() => selectedCategory = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected ? [cat['color'], cat['color'].withValues(alpha: 0.7)] : [Colors.white, Colors.white],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat['emoji'], style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        cat['name'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : cat['color'],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Items grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: categories[selectedCategory]['items'].length > 5 ? 1.0 : 0.85,
            ),
            itemCount: (categories[selectedCategory]['items'] as List).length,
            itemBuilder: (context, index) {
              final item = categories[selectedCategory]['items'][index];
              final color = categories[selectedCategory]['color'] as Color;

              return GestureDetector(
                onTap: () => _speakText("${item['name']}. ${item['description'] ?? item['fact'] ?? item['example'] ?? ''}"),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item['emoji'], style: const TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        Text(
                          item['name'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'] ?? item['fact'] ?? item['example'] ?? '',
                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.9)),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFactsTab() {
    final facts = [
      {'emoji': '💧', 'fact': 'Water boils at 100°C and freezes at 0°C'},
      {'emoji': '🌍', 'fact': 'Earth takes 24 hours to rotate once'},
      {'emoji': '🦴', 'fact': 'Humans have 206 bones in their body'},
      {'emoji': '❤️', 'fact': 'Your heart beats about 100,000 times a day'},
      {'emoji': '🌈', 'fact': 'A rainbow has 7 colors: VIBGYOR'},
      {'emoji': '☀️', 'fact': 'Light travels faster than sound'},
      {'emoji': '🐋', 'fact': 'Blue whale is the largest animal on Earth'},
      {'emoji': '🌙', 'fact': 'Moon has no light of its own'},
      {'emoji': '🧠', 'fact': 'Brain controls everything in your body'},
      {'emoji': '🌱', 'fact': 'Plants make food using sunlight'},
      {'emoji': '🔥', 'fact': 'Fire needs oxygen to burn'},
      {'emoji': '⚡', 'fact': 'Lightning is hotter than the Sun\'s surface'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: facts.length,
      itemBuilder: (context, index) {
        final fact = facts[index];
        final colors = [
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
          [Color(0xFF56D97F), Color(0xFF11998E)],
          [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        ];
        final gradient = colors[index % colors.length];

        return GestureDetector(
          onTap: () => _speakText(fact['fact']!),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(fact['emoji']!, style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text(
                    fact['fact']!,
                    style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.volume_up, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExperimentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: experiments.length,
      itemBuilder: (context, index) {
        final exp = experiments[index];
        final colors = [
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
        ];
        final gradient = colors[index % colors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(exp['emoji'], style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 12),
                    Text(
                      exp['title'],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Steps:", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(
                  (exp['steps'] as List).length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text("${i + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(exp['steps'][i], style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text("🧪", style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Science: ${exp['science']}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
