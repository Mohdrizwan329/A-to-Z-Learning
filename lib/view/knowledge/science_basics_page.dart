import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/services/tts_service.dart';

class ScienceBasicsPage extends StatefulWidget {
  const ScienceBasicsPage({super.key});

  @override
  State<ScienceBasicsPage> createState() => _ScienceBasicsPageState();
}

class _ScienceBasicsPageState extends State<ScienceBasicsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

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
    initGridAnimations(this);
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
    disposeGridAnimations();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Science Basics',
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(ProgressService.kScienceTopics);
              setState(() {});
            },
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelPadding: const EdgeInsets.symmetric(horizontal: 24),
        tabs: const [
          Tab(text: "Topics"),
          Tab(text: "Facts"),
          Tab(text: "Experiments"),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Obx(() {
            final progress = ProgressService.to.getProgressPercentage(ProgressService.kScienceTopics) / 100;
            final progressString = ProgressService.to.getProgressString(ProgressService.kScienceTopics);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$progressString completed',
                        style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTopicsTab(),
                _buildFactsTab(),
                _buildExperimentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final gradient = AppColors.getGradientForIndex(index);

        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () {
              TtsService.to.speak(cat['name']);
              ProgressService.to.markItemCompleted(ProgressService.kScienceTopics, index);
              Get.to(() => ScienceTopicDetailPage(
                title: cat['name'],
                items: List<Map<String, dynamic>>.from(cat['items']),
                color: cat['color'],
                speakText: _speakText,
              ));
            },
            pulseAnimation: pulseAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(cat['emoji'], style: const TextStyle(fontSize: 42)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GradientCardText(text: cat['name'], fontSize: 13),
                ],
              ),
            ),
          ),
        );
      },
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

// Detail page for a science topic
class ScienceTopicDetailPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Color color;
  final void Function(String) speakText;

  const ScienceTopicDetailPage({
    super.key,
    required this.title,
    required this.items,
    required this.color,
    required this.speakText,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: title,
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: items.length > 5 ? 1.0 : 0.85,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: () => speakText("${item['name']}. ${item['description'] ?? item['fact'] ?? item['example'] ?? item['source'] ?? item['traits'] ?? ''}"),
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
                      item['description'] ?? item['fact'] ?? item['example'] ?? item['source'] ?? item['traits'] ?? '',
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
    );
  }
}
