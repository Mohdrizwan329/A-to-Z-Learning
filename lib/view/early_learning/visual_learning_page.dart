import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class VisualLearningPage extends StatefulWidget {
  const VisualLearningPage({super.key});

  @override
  State<VisualLearningPage> createState() => _VisualLearningPageState();
}

class _VisualLearningPageState extends State<VisualLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentSection = 0;

  // Track visited items per section
  final Map<int, Set<int>> _visitedItems = {};

  final List<VisualSection> _sections = [
    VisualSection(
      name: 'Colors',
      emoji: '🎨',
      gradient: [Colors.red, Colors.orange],
      items: [
        VisualItem('Red', '🔴', Colors.red, [
          'Apple',
          'Fire truck',
          'Strawberry',
        ]),
        VisualItem('Blue', '🔵', Colors.blue, ['Sky', 'Ocean', 'Blueberry']),
        VisualItem('Yellow', '🟡', Colors.yellow, ['Sun', 'Banana', 'Lemon']),
        VisualItem('Green', '🟢', Colors.green, ['Grass', 'Tree', 'Frog']),
        VisualItem('Orange', '🟠', Colors.orange, [
          'Orange',
          'Carrot',
          'Pumpkin',
        ]),
        VisualItem('Purple', '🟣', Colors.purple, [
          'Grapes',
          'Eggplant',
          'Lavender',
        ]),
        VisualItem('Pink', '🩷', Colors.pink, [
          'Flamingo',
          'Rose',
          'Cotton candy',
        ]),
        VisualItem('Brown', '🟤', Colors.brown, ['Chocolate', 'Bear', 'Wood']),
        VisualItem('Black', '⚫', Colors.black, ['Night sky', 'Crow', 'Tire']),
        VisualItem('White', '⚪', Colors.white, ['Snow', 'Cloud', 'Milk']),
        VisualItem('Gray', '🩶', Colors.grey, ['Elephant', 'Rock', 'Mouse']),
        VisualItem('Cyan', '🩵', Colors.cyan, ['Pool water', 'Ice', 'Glacier']),
        VisualItem('Magenta', '💜', Colors.pinkAccent, [
          'Flower',
          'Butterfly',
          'Gem',
        ]),
        VisualItem('Gold', '🥇', Colors.amber, ['Medal', 'Crown', 'Coin']),
        VisualItem('Silver', '🥈', Colors.blueGrey, [
          'Spoon',
          'Mirror',
          'Ring',
        ]),
        VisualItem('Turquoise', '💎', Colors.teal, [
          'Ocean',
          'Peacock',
          'Jewel',
        ]),
        VisualItem('Coral', '🪸', Colors.deepOrange, [
          'Reef',
          'Sunset',
          'Salmon',
        ]),
        VisualItem('Navy', '🫐', Colors.indigo, ['Sailor', 'Whale', 'Jeans']),
        VisualItem('Lime', '🍈', Colors.lime, [
          'Lime fruit',
          'Tennis ball',
          'Parrot',
        ]),
        VisualItem('Maroon', '🍷', Colors.brown, [
          'Wine',
          'Autumn leaf',
          'Cherry',
        ]),
      ],
    ),
    VisualSection(
      name: 'Shapes',
      emoji: '🔷',
      gradient: [Colors.blue, Colors.cyan],
      items: [
        VisualItem('Circle', '⭕', Colors.red, ['Ball', 'Wheel', 'Cookie']),
        VisualItem('Square', '🟧', Colors.orange, ['Window', 'Box', 'Tile']),
        VisualItem('Triangle', '🔺', Colors.green, [
          'Roof',
          'Pizza slice',
          'Pyramid',
        ]),
        VisualItem('Rectangle', '🟦', Colors.blue, ['Door', 'Book', 'Phone']),
        VisualItem('Star', '⭐', Colors.yellow, [
          'Night star',
          'Sheriff badge',
          'Starfish',
        ]),
        VisualItem('Heart', '❤️', Colors.pink, [
          'Love symbol',
          'Valentine',
          'Card',
        ]),
        VisualItem('Diamond', '💎', Colors.cyan, [
          'Gem',
          'Kite',
          'Playing card',
        ]),
        VisualItem('Oval', '🥚', Colors.white, ['Egg', 'Mirror', 'Face']),
        VisualItem('Pentagon', '⬠', Colors.purple, [
          'Building',
          'Home plate',
          'Sign',
        ]),
        VisualItem('Hexagon', '⬡', Colors.amber, [
          'Honeycomb',
          'Bolt',
          'Snowflake',
        ]),
        VisualItem('Octagon', '🛑', Colors.red, [
          'Stop sign',
          'Window',
          'Table',
        ]),
        VisualItem('Crescent', '🌙', Colors.yellow, [
          'Moon',
          'Croissant',
          'Banana',
        ]),
        VisualItem('Arrow', '➡️', Colors.blue, [
          'Sign',
          'Compass',
          'Direction',
        ]),
        VisualItem('Cross', '✝️', Colors.brown, [
          'Plus sign',
          'Hospital',
          'Treasure map',
        ]),
        VisualItem('Cube', '🧊', Colors.lightBlue, ['Ice', 'Dice', 'Box']),
        VisualItem('Sphere', '🔮', Colors.purple, [
          'Crystal ball',
          'Globe',
          'Marble',
        ]),
        VisualItem('Cylinder', '🥫', Colors.red, ['Can', 'Pillar', 'Log']),
        VisualItem('Cone', '🍦', Colors.brown, [
          'Ice cream',
          'Party hat',
          'Traffic cone',
        ]),
        VisualItem('Pyramid', '🔺', Colors.amber, [
          'Egypt',
          'Tent',
          'Mountain',
        ]),
        VisualItem('Spiral', '🌀', Colors.blue, ['Shell', 'Spring', 'Galaxy']),
      ],
    ),
    VisualSection(
      name: 'Patterns',
      emoji: '🔳',
      gradient: [Colors.purple, Colors.pink],
      items: [
        VisualItem('Stripes', '🦓', Colors.black, [
          'Zebra',
          'Candy cane',
          'Flag',
        ]),
        VisualItem('Dots', '🐞', Colors.red, ['Ladybug', 'Polka dots', 'Dice']),
        VisualItem('Zigzag', '⚡', Colors.yellow, [
          'Lightning',
          'Mountains',
          'Waves',
        ]),
        VisualItem('Checks', '🏁', Colors.grey, [
          'Chess board',
          'Tablecloth',
          'Race flag',
        ]),
        VisualItem('Spiral', '🌀', Colors.blue, [
          'Snail shell',
          'Tornado',
          'Lollipop',
        ]),
        VisualItem('Rainbow', '🌈', Colors.purple, [
          'After rain',
          'Prism',
          'Art',
        ]),
        VisualItem('Plaid', '🧣', Colors.red, ['Scarf', 'Blanket', 'Shirt']),
        VisualItem('Floral', '🌸', Colors.pink, [
          'Dress',
          'Wallpaper',
          'Garden',
        ]),
        VisualItem('Camouflage', '🪖', Colors.green, [
          'Army',
          'Jungle',
          'Hunting',
        ]),
        VisualItem('Paisley', '🥒', Colors.teal, ['Bandana', 'Tie', 'Fabric']),
        VisualItem('Geometric', '🔷', Colors.blue, [
          'Tiles',
          'Art',
          'Building',
        ]),
        VisualItem('Animal Print', '🐆', Colors.orange, [
          'Leopard',
          'Tiger',
          'Giraffe',
        ]),
        VisualItem('Waves', '🌊', Colors.blue, ['Ocean', 'Hair', 'Sound']),
        VisualItem('Stars', '✨', Colors.yellow, [
          'Night sky',
          'Decoration',
          'Magic',
        ]),
        VisualItem('Hearts', '💕', Colors.pink, [
          'Valentine',
          'Love',
          'Decoration',
        ]),
        VisualItem('Bubbles', '🫧', Colors.lightBlue, [
          'Soap',
          'Fizz',
          'Water',
        ]),
        VisualItem('Grid', '🔲', Colors.grey, [
          'Graph paper',
          'Window',
          'Game board',
        ]),
        VisualItem('Mosaic', '🎨', Colors.purple, ['Art', 'Tiles', 'Church']),
        VisualItem('Marble', '🪨', Colors.grey, ['Stone', 'Counter', 'Statue']),
        VisualItem('Tie Dye', '👕', Colors.purple, [
          'T-shirt',
          'Festival',
          'Art',
        ]),
      ],
    ),
    VisualSection(
      name: 'Sizes',
      emoji: '📏',
      gradient: [Colors.teal, Colors.green],
      items: [
        VisualItem('Big', '🐘', Colors.grey, ['Elephant', 'House', 'Mountain']),
        VisualItem('Small', '🐜', Colors.brown, ['Ant', 'Seed', 'Button']),
        VisualItem('Tall', '🦒', Colors.orange, ['Giraffe', 'Tower', 'Tree']),
        VisualItem('Short', '🐁', Colors.grey, ['Mouse', 'Cup', 'Stool']),
        VisualItem('Wide', '🌊', Colors.blue, ['Ocean', 'Road', 'Field']),
        VisualItem('Narrow', '🚪', Colors.brown, [
          'Door crack',
          'Alley',
          'Ribbon',
        ]),
        VisualItem('Huge', '🦣', Colors.brown, [
          'Mammoth',
          'Whale',
          'Dinosaur',
        ]),
        VisualItem('Tiny', '🔬', Colors.grey, ['Germ', 'Atom', 'Dust']),
        VisualItem('Long', '🐍', Colors.green, ['Snake', 'Train', 'River']),
        VisualItem('Thick', '📚', Colors.brown, ['Book', 'Tree trunk', 'Rope']),
        VisualItem('Thin', '📄', Colors.white, ['Paper', 'String', 'Wire']),
        VisualItem('Deep', '🌊', Colors.indigo, ['Ocean', 'Cave', 'Well']),
        VisualItem('Shallow', '🏖️', Colors.cyan, [
          'Puddle',
          'Pool edge',
          'Stream',
        ]),
        VisualItem('Heavy', '🏋️', Colors.grey, ['Weights', 'Rock', 'Truck']),
        VisualItem('Light', '🪶', Colors.white, [
          'Feather',
          'Balloon',
          'Cloud',
        ]),
        VisualItem('Giant', '🗿', Colors.grey, ['Statue', 'Building', 'Whale']),
        VisualItem('Mini', '🧸', Colors.brown, ['Toy', 'Model', 'Baby shoe']),
        VisualItem('Massive', '🏔️', Colors.grey, [
          'Mountain',
          'Ship',
          'Planet',
        ]),
        VisualItem('Petite', '🌸', Colors.pink, ['Flower', 'Fairy', 'Gem']),
        VisualItem('Medium', '🐕', Colors.brown, ['Dog', 'Chair', 'Ball']),
      ],
    ),
  ];

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadProgress();
    _tabController = TabController(length: _sections.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentSection = _tabController.index);
        _speak(_sections[_tabController.index].name);
      }
    });
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  void _loadProgress() {
    for (int i = 0; i < _sections.length; i++) {
      final saved = _box.read<List>('visual_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _markItemVisited(int sectionIndex, int itemIndex) {
    _visitedItems[sectionIndex] ??= {};
    if (!_visitedItems[sectionIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[sectionIndex]!.add(itemIndex);
      });
      _box.write(
        'visual_progress_$sectionIndex',
        _visitedItems[sectionIndex]!.toList(),
      );
    }
  }

  int get _totalItems {
    int total = 0;
    for (var sec in _sections) {
      total += sec.items.length;
    }
    return total;
  }

  int get _completedItems {
    int completed = 0;
    for (var entry in _visitedItems.entries) {
      completed += entry.value.length;
    }
    return completed;
  }

  double get _progressPercentage {
    if (_totalItems == 0) return 0;
    return _completedItems / _totalItems;
  }

  String get _progressString => '$_completedItems/$_totalItems';

  void _resetProgress() {
    setState(() {
      for (int i = 0; i < _sections.length; i++) {
        _visitedItems[i] = {};
        _box.remove('visual_progress_$i');
      }
    });
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.2);
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _onItemTap(VisualItem item, int itemIndex) {
    TtsService.to.speak(item.name);
    HapticFeedback.mediumImpact();
    _speak('${item.name}. Examples: ${item.examples.join(", ")}');
    _markItemVisited(_currentSection, itemIndex);
    _showItemDetail(item);
  }

  void _showItemDetail(VisualItem item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 60)),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),
              const Text(
                'Examples:',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.r,
                runSpacing: 8.r,
                alignment: WrapAlignment.center,
                children: item.examples.map((example) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      example,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGradientButton(
                    icon: Icons.volume_up,
                    label: 'Listen',
                    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () => _speak(
                      '${item.name}. Examples: ${item.examples.join(", ")}',
                    ),
                  ),
                  _buildGradientButton(
                    icon: Icons.close,
                    label: 'Close',
                    gradient: const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _floatController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = _sections[_currentSection];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          onPressed: () => Get.back(),
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
        title: const Text(
          'Visual Learning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
            ),
            onPressed: _resetProgress,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3.r,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
          tabs: _sections.map((sec) {
            return Tab(
              child: Text(
                sec.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress bar
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // The reader's font size can be 30% larger than this row was drawn for.
                        Flexible(
                          child: const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '$_progressString completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: _progressPercentage,
                        minHeight: 10.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Visual items grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(12.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: section.items.length,
                  itemBuilder: (context, index) {
                    final item = section.items[index];
                    final gradients = [
                      [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
                      [const Color(0xFF45B7D1), const Color(0xFF74C9DB)],
                      [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)],
                      [const Color(0xFF56D97F), const Color(0xFF81E89E)],
                      [const Color(0xFFFF6EB4), const Color(0xFFFF9ECE)],
                      [const Color(0xFF4ECDC4), const Color(0xFF7EDDD6)],
                    ];
                    final gradient = gradients[index % gradients.length];
                    return AnimatedBuilder(
                      animation: _floatController,
                      builder: (_, child) {
                        final offset = (index % 2 == 0)
                            ? _floatAnimation.value
                            : -_floatAnimation.value;
                        return Transform.translate(
                          offset: Offset(0, offset),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () => _onItemTap(item, index),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.4),
                                blurRadius: 12.r,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -20.h,
                                right: -20.w,
                                child: Container(
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 75.w,
                                        height: 75.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.emoji,
                                            style: const TextStyle(
                                              fontSize: 42,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.1,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Checkmark badge when visited
                              if (_visitedItems[_currentSection]?.contains(
                                    index,
                                  ) ==
                                  true)
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: gradient[0],
                                      size: 16.r,
                                    ),
                                  ),
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
          ),
        ),
      ),
    );
  }
}

class VisualSection {
  final String name;
  final String emoji;
  final List<Color> gradient;
  final List<VisualItem> items;

  VisualSection({
    required this.name,
    required this.emoji,
    required this.gradient,
    required this.items,
  });
}

class VisualItem {
  final String name;
  final String emoji;
  final Color color;
  final List<String> examples;

  VisualItem(this.name, this.emoji, this.color, this.examples);
}
