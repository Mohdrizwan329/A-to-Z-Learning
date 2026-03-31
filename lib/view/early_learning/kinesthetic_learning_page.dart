import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class KinestheticLearningPage extends StatefulWidget {
  const KinestheticLearningPage({super.key});

  @override
  State<KinestheticLearningPage> createState() => _KinestheticLearningPageState();
}

class _KinestheticLearningPageState extends State<KinestheticLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentCategory = 0;

  // Track visited items per category
  final Map<int, Set<int>> _visitedItems = {};

  final List<KinestheticCategory> _categories = [
    KinestheticCategory(
      name: 'Tracing',
      emoji: '✍️',
      items: [
        KinestheticItem('Trace A', '🅰️', 'Move your finger to trace the letter A', 'A'),
        KinestheticItem('Trace B', '🅱️', 'Move your finger to trace the letter B', 'B'),
        KinestheticItem('Trace C', '©️', 'Move your finger to trace the letter C', 'C'),
        KinestheticItem('Trace D', '🇩', 'Move your finger to trace the letter D', 'D'),
        KinestheticItem('Trace E', '🇪', 'Move your finger to trace the letter E', 'E'),
        KinestheticItem('Trace F', '🇫', 'Move your finger to trace the letter F', 'F'),
        KinestheticItem('Trace G', '🇬', 'Move your finger to trace the letter G', 'G'),
        KinestheticItem('Trace H', '🇭', 'Move your finger to trace the letter H', 'H'),
        KinestheticItem('Trace I', '🇮', 'Move your finger to trace the letter I', 'I'),
        KinestheticItem('Trace J', '🇯', 'Move your finger to trace the letter J', 'J'),
        KinestheticItem('Trace 1', '1️⃣', 'Move your finger to trace number 1', '1'),
        KinestheticItem('Trace 2', '2️⃣', 'Move your finger to trace number 2', '2'),
        KinestheticItem('Trace 3', '3️⃣', 'Move your finger to trace number 3', '3'),
        KinestheticItem('Trace 4', '4️⃣', 'Move your finger to trace number 4', '4'),
        KinestheticItem('Trace 5', '5️⃣', 'Move your finger to trace number 5', '5'),
        KinestheticItem('Trace 6', '6️⃣', 'Move your finger to trace number 6', '6'),
        KinestheticItem('Trace 7', '7️⃣', 'Move your finger to trace number 7', '7'),
        KinestheticItem('Trace 8', '8️⃣', 'Move your finger to trace number 8', '8'),
        KinestheticItem('Trace 9', '9️⃣', 'Move your finger to trace number 9', '9'),
        KinestheticItem('Trace 0', '0️⃣', 'Move your finger to trace number 0', '0'),
      ],
    ),
    KinestheticCategory(
      name: 'Drag & Drop',
      emoji: '👆',
      items: [
        KinestheticItem('Sort Fruits', '🍎', 'Drag fruits to the correct box', 'fruits'),
        KinestheticItem('Sort Colors', '🎨', 'Match colors by dragging', 'colors'),
        KinestheticItem('Sort Shapes', '🔷', 'Drag shapes to match', 'shapes'),
        KinestheticItem('Sort Animals', '🐕', 'Drag animals to their homes', 'animals'),
        KinestheticItem('Sort Numbers', '🔢', 'Arrange numbers in order', 'numbers'),
        KinestheticItem('Sort Letters', '🔤', 'Arrange letters correctly', 'letters'),
        KinestheticItem('Sort Vehicles', '🚗', 'Drag vehicles to parking spots', 'vehicles'),
        KinestheticItem('Sort Foods', '🍔', 'Sort healthy and junk food', 'foods'),
        KinestheticItem('Sort Clothes', '👕', 'Match clothes to seasons', 'clothes'),
        KinestheticItem('Sort Birds', '🐦', 'Drag birds to their nests', 'birds'),
        KinestheticItem('Sort Toys', '🧸', 'Organize toys in boxes', 'toys'),
        KinestheticItem('Sort Tools', '🔧', 'Match tools to their use', 'tools'),
        KinestheticItem('Sort Flowers', '🌸', 'Arrange flowers by color', 'flowers'),
        KinestheticItem('Sort Insects', '🦋', 'Sort flying and crawling insects', 'insects'),
        KinestheticItem('Sort Planets', '🪐', 'Arrange planets in order', 'planets'),
        KinestheticItem('Sort Seasons', '🌻', 'Match items to seasons', 'seasons'),
        KinestheticItem('Sort Sports', '⚽', 'Match balls to sports', 'sports'),
        KinestheticItem('Sort Music', '🎵', 'Sort musical instruments', 'music'),
        KinestheticItem('Sort Weather', '☀️', 'Match weather to activities', 'weather'),
        KinestheticItem('Sort Sizes', '📏', 'Arrange by size order', 'sizes'),
      ],
    ),
    KinestheticCategory(
      name: 'Tapping',
      emoji: '👇',
      items: [
        KinestheticItem('Tap 3', '3️⃣', 'Tap to count 3 objects', '3'),
        KinestheticItem('Tap 5', '5️⃣', 'Tap to count 5 objects', '5'),
        KinestheticItem('Tap 7', '7️⃣', 'Tap to count 7 objects', '7'),
        KinestheticItem('Pop Bubbles', '🫧', 'Tap to pop the bubbles', 'bubbles'),
        KinestheticItem('Catch Stars', '⭐', 'Tap the falling stars', 'stars'),
        KinestheticItem('Hit Targets', '🎯', 'Tap the targets quickly', 'targets'),
        KinestheticItem('Tap 4', '4️⃣', 'Tap to count 4 objects', '4'),
        KinestheticItem('Tap 6', '6️⃣', 'Tap to count 6 objects', '6'),
        KinestheticItem('Tap 8', '8️⃣', 'Tap to count 8 objects', '8'),
        KinestheticItem('Tap 10', '🔟', 'Tap to count 10 objects', '10'),
        KinestheticItem('Pop Balloons', '🎈', 'Tap to pop colorful balloons', 'balloons'),
        KinestheticItem('Catch Hearts', '❤️', 'Tap the floating hearts', 'hearts'),
        KinestheticItem('Squash Bugs', '🐛', 'Tap the crawling bugs', 'bugs'),
        KinestheticItem('Catch Fruits', '🍓', 'Tap falling fruits', 'fruits'),
        KinestheticItem('Hit Moles', '🦫', 'Tap the popping moles', 'moles'),
        KinestheticItem('Catch Fish', '🐟', 'Tap the swimming fish', 'fish'),
        KinestheticItem('Pop Flowers', '🌺', 'Tap blooming flowers', 'flowers'),
        KinestheticItem('Catch Coins', '🪙', 'Tap falling coins', 'coins'),
        KinestheticItem('Hit Drums', '🥁', 'Tap the drums to make music', 'drums'),
        KinestheticItem('Catch Snowflakes', '❄️', 'Tap falling snowflakes', 'snowflakes'),
      ],
    ),
    KinestheticCategory(
      name: 'Swiping',
      emoji: '👋',
      items: [
        KinestheticItem('Animal Sounds', '🐕', 'Swipe to learn animal sounds', 'animals'),
        KinestheticItem('Color Match', '🌈', 'Swipe to match colors', 'colors'),
        KinestheticItem('Shape Match', '⬛', 'Swipe to match shapes', 'shapes'),
        KinestheticItem('Word Match', '📝', 'Swipe to match words', 'words'),
        KinestheticItem('Number Match', '🔢', 'Swipe to match numbers', 'numbers'),
        KinestheticItem('Picture Match', '🖼️', 'Swipe to match pictures', 'pictures'),
        KinestheticItem('Fruit Match', '🍎', 'Swipe to match fruits', 'fruits'),
        KinestheticItem('Vehicle Match', '🚗', 'Swipe to match vehicles', 'vehicles'),
        KinestheticItem('Food Match', '🍕', 'Swipe to match foods', 'foods'),
        KinestheticItem('Bird Match', '🦅', 'Swipe to match birds', 'birds'),
        KinestheticItem('Insect Match', '🦋', 'Swipe to match insects', 'insects'),
        KinestheticItem('Planet Match', '🪐', 'Swipe to match planets', 'planets'),
        KinestheticItem('Sport Match', '⚽', 'Swipe to match sports', 'sports'),
        KinestheticItem('Music Match', '🎵', 'Swipe to match instruments', 'instruments'),
        KinestheticItem('Weather Match', '☁️', 'Swipe to match weather', 'weather'),
        KinestheticItem('Season Match', '🌸', 'Swipe to match seasons', 'seasons'),
        KinestheticItem('Emotion Match', '😊', 'Swipe to match emotions', 'emotions'),
        KinestheticItem('Tool Match', '🔨', 'Swipe to match tools', 'tools'),
        KinestheticItem('Clothing Match', '👗', 'Swipe to match clothes', 'clothes'),
        KinestheticItem('Flower Match', '🌷', 'Swipe to match flowers', 'flowers'),
      ],
    ),
    KinestheticCategory(
      name: 'Motion',
      emoji: '📱',
      items: [
        KinestheticItem('Shake Reveal', '🎲', 'Shake device to reveal number', 'shake'),
        KinestheticItem('Tilt Balance', '⚖️', 'Tilt to balance objects', 'tilt'),
        KinestheticItem('Pinch Zoom', '🔍', 'Pinch to explore details', 'pinch'),
        KinestheticItem('Rotate Find', '🔄', 'Rotate to find hidden items', 'rotate'),
        KinestheticItem('Move Guide', '🧭', 'Move device to guide ball', 'move'),
        KinestheticItem('Draw Air', '✨', 'Draw patterns in the air', 'air'),
        KinestheticItem('Shake Colors', '🎨', 'Shake to mix colors', 'colors'),
        KinestheticItem('Tilt Maze', '🌀', 'Tilt to navigate the maze', 'maze'),
        KinestheticItem('Pinch Stars', '⭐', 'Pinch to collect stars', 'stars'),
        KinestheticItem('Rotate Puzzle', '🧩', 'Rotate pieces to solve puzzle', 'puzzle'),
        KinestheticItem('Move Paint', '🖌️', 'Move to paint a picture', 'paint'),
        KinestheticItem('Shake Music', '🎶', 'Shake to make music', 'music'),
        KinestheticItem('Tilt Water', '💧', 'Tilt to pour water', 'water'),
        KinestheticItem('Pinch Animals', '🦊', 'Pinch to zoom on animals', 'animals'),
        KinestheticItem('Rotate Wheel', '🎡', 'Rotate the wheel to spin', 'wheel'),
        KinestheticItem('Move Butterfly', '🦋', 'Move to guide butterfly', 'butterfly'),
        KinestheticItem('Shake Dice', '🎯', 'Shake to roll the dice', 'dice'),
        KinestheticItem('Tilt Snow', '❄️', 'Tilt to make snow fall', 'snow'),
        KinestheticItem('Pinch Bubbles', '🫧', 'Pinch to create bubbles', 'bubbles'),
        KinestheticItem('Rotate Clock', '🕐', 'Rotate to set the time', 'clock'),
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
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentCategory = _tabController.index);
        _speak(_categories[_tabController.index].name);
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
    for (int i = 0; i < _categories.length; i++) {
      final saved = _box.read<List>('kinesthetic_progress_$i');
      if (saved != null) {
        _visitedItems[i] = saved.map((e) => e as int).toSet();
      } else {
        _visitedItems[i] = {};
      }
    }
  }

  void _markItemVisited(int categoryIndex, int itemIndex) {
    _visitedItems[categoryIndex] ??= {};
    if (!_visitedItems[categoryIndex]!.contains(itemIndex)) {
      setState(() {
        _visitedItems[categoryIndex]!.add(itemIndex);
      });
      _box.write('kinesthetic_progress_$categoryIndex', _visitedItems[categoryIndex]!.toList());
    }
  }

  int get _totalItems {
    int total = 0;
    for (var cat in _categories) {
      total += cat.items.length;
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
      for (int i = 0; i < _categories.length; i++) {
        _visitedItems[i] = {};
        _box.remove('kinesthetic_progress_$i');
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

  void _onItemTap(KinestheticItem item, int itemIndex) {
    TtsService.to.speak(item.name);
    HapticFeedback.mediumImpact();
    _speak('${item.name}. ${item.description}');
    _markItemVisited(_currentCategory, itemIndex);
    _showItemDetail(item, itemIndex);
  }

  void _showItemDetail(KinestheticItem item, int itemIndex) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGradientButton(
                    icon: Icons.volume_up,
                    label: 'Listen',
                    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () => _speak('${item.name}. ${item.description}'),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
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
    final category = _categories[_currentCategory];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
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
          'Kinesthetic Learning',
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: _resetProgress,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabAlignment: TabAlignment.start,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: _categories.map((cat) {
            return Tab(
              child: Text(cat.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progressPercentage,
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Activities grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: category.items.length,
                  itemBuilder: (context, index) {
                    final item = category.items[index];
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
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.4),
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
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          child: Text(
                                            item.emoji,
                                            style: const TextStyle(fontSize: 42),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
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
                              if (_visitedItems[_currentCategory]?.contains(index) == true)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: gradient[0],
                                      size: 16,
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
      bottomNavigationBar: const AdsScreen(),
    );
  }
}

// Tracing Activity Screen
class _TracingScreen extends StatefulWidget {
  final String letter;
  final VoidCallback onComplete;

  const _TracingScreen({
    required this.letter,
    required this.onComplete,
  });

  @override
  State<_TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<_TracingScreen> {
  List<Offset> _points = [];
  bool _isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Text(
                        'Trace the Letter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Tracing area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          widget.letter,
                          style: TextStyle(
                            fontSize: 250,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _points.add(details.localPosition);
                          });
                        },
                        onPanEnd: (_) {
                          if (_points.length > 50) {
                            setState(() => _isComplete = true);
                          }
                        },
                        child: CustomPaint(
                          painter: _TracingPainter(points: _points),
                          size: Size.infinite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.refresh,
                      label: 'Clear',
                      gradient: [Colors.grey.shade600, Colors.grey.shade400],
                      onTap: () => setState(() {
                        _points.clear();
                        _isComplete = false;
                      }),
                    ),
                    _buildActionButton(
                      icon: Icons.check,
                      label: 'Done',
                      gradient: _isComplete
                          ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                          : [Colors.grey.shade400, Colors.grey.shade300],
                      onTap: _isComplete ? () {
                        widget.onComplete();
                        Get.back();
                      } : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final List<Offset> points;

  _TracingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF667EEA)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Drag Drop Activity Screen
class _DragDropScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const _DragDropScreen({required this.onComplete});

  @override
  State<_DragDropScreen> createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<_DragDropScreen> {
  final List<String> _fruits = ['🍎', '🍌', '🍇'];
  final List<String> _vegetables = ['🥕', '🥦', '🌽'];
  List<String> _fruitBox = [];
  List<String> _vegBox = [];

  @override
  Widget build(BuildContext context) {
    final allItems = [..._fruits, ..._vegetables]..shuffle();
    final remainingItems = allItems.where((item) => !_fruitBox.contains(item) && !_vegBox.contains(item)).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Text(
                        'Sort Fruits & Vegetables',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Drag items to the correct box!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Items to drag
              Wrap(
                spacing: 16,
                children: remainingItems.map((item) {
                  return Draggable<String>(
                    data: item,
                    feedback: Text(item, style: const TextStyle(fontSize: 50)),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: Text(item, style: const TextStyle(fontSize: 40)),
                    ),
                    child: Text(item, style: const TextStyle(fontSize: 40)),
                  );
                }).toList(),
              ),

              const Spacer(),

              // Drop zones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDropZone('Fruits 🍎', _fruitBox, _fruits, const Color(0xFFFF6B6B)),
                  _buildDropZone('Vegetables 🥕', _vegBox, _vegetables, const Color(0xFF4CAF50)),
                ],
              ),

              const SizedBox(height: 20),

              if (_fruitBox.length == _fruits.length && _vegBox.length == _vegetables.length)
                GestureDetector(
                  onTap: () {
                    widget.onComplete();
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'Complete!',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropZone(String label, List<String> box, List<String> expected, Color color) {
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        final data = details.data;
        if (expected.contains(data)) {
          setState(() => box.add(data));
          HapticFeedback.mediumImpact();
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 140,
          height: 160,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Wrap(
                children: box.map((item) => Text(item, style: const TextStyle(fontSize: 24))).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Tapping Activity Screen
class _TappingScreen extends StatefulWidget {
  final int targetCount;
  final VoidCallback onComplete;

  const _TappingScreen({
    required this.targetCount,
    required this.onComplete,
  });

  @override
  State<_TappingScreen> createState() => _TappingScreenState();
}

class _TappingScreenState extends State<_TappingScreen> {
  int _tapCount = 0;
  final List<String> _items = ['🌟', '🎈', '🦋', '🌸', '🍀', '⭐', '💫'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Tap ${widget.targetCount} times!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Count: $_tapCount / ${widget.targetCount}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: List.generate(widget.targetCount, (index) {
                      final isTapped = index < _tapCount;
                      return GestureDetector(
                        onTap: isTapped ? null : () {
                          setState(() => _tapCount++);
                          HapticFeedback.lightImpact();
                          if (_tapCount == widget.targetCount) {
                            Future.delayed(const Duration(milliseconds: 500), () {
                              widget.onComplete();
                              Get.back();
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isTapped
                                  ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                                  : [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _items[index % _items.length],
                              style: TextStyle(fontSize: isTapped ? 36 : 28),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Swiping Activity Screen
class _SwipingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const _SwipingScreen({required this.onComplete});

  @override
  State<_SwipingScreen> createState() => _SwipingScreenState();
}

class _SwipingScreenState extends State<_SwipingScreen> {
  final List<Map<String, String>> _pairs = [
    {'animal': '🐕', 'sound': 'Woof!'},
    {'animal': '🐱', 'sound': 'Meow!'},
    {'animal': '🐄', 'sound': 'Moo!'},
    {'animal': '🐓', 'sound': 'Cock-a-doodle!'},
    {'animal': '🐸', 'sound': 'Ribbit!'},
  ];
  int _currentIndex = 0;
  bool _showSound = false;

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _pairs.length) {
      return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 20),
                const Text(
                  'Great Job!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    widget.onComplete();
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'Complete!',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final pair = _pairs[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Text(
                        'Swipe to Learn!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      '${_currentIndex + 1}/${_pairs.length}',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null && details.primaryVelocity!.abs() > 100) {
                      setState(() {
                        _showSound = !_showSound;
                        if (_showSound) {
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              _currentIndex++;
                              _showSound = false;
                            });
                          });
                        }
                      });
                      HapticFeedback.mediumImpact();
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _showSound
                                ? Text(
                                    pair['sound']!,
                                    key: ValueKey('sound_$_currentIndex'),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    pair['animal']!,
                                    key: ValueKey('animal_$_currentIndex'),
                                    style: const TextStyle(fontSize: 120),
                                  ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            '👈 Swipe to hear the sound 👉',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KinestheticCategory {
  final String name;
  final String emoji;
  final List<KinestheticItem> items;

  KinestheticCategory({
    required this.name,
    required this.emoji,
    required this.items,
  });
}

class KinestheticItem {
  final String name;
  final String emoji;
  final String description;
  final String content;

  KinestheticItem(this.name, this.emoji, this.description, this.content);
}
