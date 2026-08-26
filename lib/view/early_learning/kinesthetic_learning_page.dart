import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class KinestheticLearningPage extends StatefulWidget {
  const KinestheticLearningPage({super.key});

  @override
  State<KinestheticLearningPage> createState() =>
      _KinestheticLearningPageState();
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
        KinestheticItem(
          'Trace A',
          '🅰️',
          'Move your finger to trace the letter A',
          'A',
        ),
        KinestheticItem(
          'Trace B',
          '🅱️',
          'Move your finger to trace the letter B',
          'B',
        ),
        KinestheticItem(
          'Trace C',
          '©️',
          'Move your finger to trace the letter C',
          'C',
        ),
        KinestheticItem(
          'Trace D',
          '🇩',
          'Move your finger to trace the letter D',
          'D',
        ),
        KinestheticItem(
          'Trace E',
          '🇪',
          'Move your finger to trace the letter E',
          'E',
        ),
        KinestheticItem(
          'Trace F',
          '🇫',
          'Move your finger to trace the letter F',
          'F',
        ),
        KinestheticItem(
          'Trace G',
          '🇬',
          'Move your finger to trace the letter G',
          'G',
        ),
        KinestheticItem(
          'Trace H',
          '🇭',
          'Move your finger to trace the letter H',
          'H',
        ),
        KinestheticItem(
          'Trace I',
          '🇮',
          'Move your finger to trace the letter I',
          'I',
        ),
        KinestheticItem(
          'Trace J',
          '🇯',
          'Move your finger to trace the letter J',
          'J',
        ),
        KinestheticItem(
          'Trace 1',
          '1️⃣',
          'Move your finger to trace number 1',
          '1',
        ),
        KinestheticItem(
          'Trace 2',
          '2️⃣',
          'Move your finger to trace number 2',
          '2',
        ),
        KinestheticItem(
          'Trace 3',
          '3️⃣',
          'Move your finger to trace number 3',
          '3',
        ),
        KinestheticItem(
          'Trace 4',
          '4️⃣',
          'Move your finger to trace number 4',
          '4',
        ),
        KinestheticItem(
          'Trace 5',
          '5️⃣',
          'Move your finger to trace number 5',
          '5',
        ),
        KinestheticItem(
          'Trace 6',
          '6️⃣',
          'Move your finger to trace number 6',
          '6',
        ),
        KinestheticItem(
          'Trace 7',
          '7️⃣',
          'Move your finger to trace number 7',
          '7',
        ),
        KinestheticItem(
          'Trace 8',
          '8️⃣',
          'Move your finger to trace number 8',
          '8',
        ),
        KinestheticItem(
          'Trace 9',
          '9️⃣',
          'Move your finger to trace number 9',
          '9',
        ),
        KinestheticItem(
          'Trace 0',
          '0️⃣',
          'Move your finger to trace number 0',
          '0',
        ),
      ],
    ),
    KinestheticCategory(
      name: 'Drag & Drop',
      emoji: '👆',
      items: [
        KinestheticItem(
          'Sort Fruits',
          '🍎',
          'Drag fruits to the correct box',
          'fruits',
        ),
        KinestheticItem(
          'Sort Colors',
          '🎨',
          'Match colors by dragging',
          'colors',
        ),
        KinestheticItem('Sort Shapes', '🔷', 'Drag shapes to match', 'shapes'),
        KinestheticItem(
          'Sort Animals',
          '🐕',
          'Drag animals to their homes',
          'animals',
        ),
        KinestheticItem(
          'Sort Numbers',
          '🔢',
          'Arrange numbers in order',
          'numbers',
        ),
        KinestheticItem(
          'Sort Letters',
          '🔤',
          'Arrange letters correctly',
          'letters',
        ),
        KinestheticItem(
          'Sort Vehicles',
          '🚗',
          'Drag vehicles to parking spots',
          'vehicles',
        ),
        KinestheticItem(
          'Sort Foods',
          '🍔',
          'Sort healthy and junk food',
          'foods',
        ),
        KinestheticItem(
          'Sort Clothes',
          '👕',
          'Match clothes to seasons',
          'clothes',
        ),
        KinestheticItem(
          'Sort Birds',
          '🐦',
          'Drag birds to their nests',
          'birds',
        ),
        KinestheticItem('Sort Toys', '🧸', 'Organize toys in boxes', 'toys'),
        KinestheticItem(
          'Sort Tools',
          '🔧',
          'Match tools to their use',
          'tools',
        ),
        KinestheticItem(
          'Sort Flowers',
          '🌸',
          'Arrange flowers by color',
          'flowers',
        ),
        KinestheticItem(
          'Sort Insects',
          '🦋',
          'Sort flying and crawling insects',
          'insects',
        ),
        KinestheticItem(
          'Sort Planets',
          '🪐',
          'Arrange planets in order',
          'planets',
        ),
        KinestheticItem(
          'Sort Seasons',
          '🌻',
          'Match items to seasons',
          'seasons',
        ),
        KinestheticItem('Sort Sports', '⚽', 'Match balls to sports', 'sports'),
        KinestheticItem(
          'Sort Music',
          '🎵',
          'Sort musical instruments',
          'music',
        ),
        KinestheticItem(
          'Sort Weather',
          '☀️',
          'Match weather to activities',
          'weather',
        ),
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
        KinestheticItem(
          'Pop Bubbles',
          '🫧',
          'Tap to pop the bubbles',
          'bubbles',
        ),
        KinestheticItem('Catch Stars', '⭐', 'Tap the falling stars', 'stars'),
        KinestheticItem(
          'Hit Targets',
          '🎯',
          'Tap the targets quickly',
          'targets',
        ),
        KinestheticItem('Tap 4', '4️⃣', 'Tap to count 4 objects', '4'),
        KinestheticItem('Tap 6', '6️⃣', 'Tap to count 6 objects', '6'),
        KinestheticItem('Tap 8', '8️⃣', 'Tap to count 8 objects', '8'),
        KinestheticItem('Tap 10', '🔟', 'Tap to count 10 objects', '10'),
        KinestheticItem(
          'Pop Balloons',
          '🎈',
          'Tap to pop colorful balloons',
          'balloons',
        ),
        KinestheticItem(
          'Catch Hearts',
          '❤️',
          'Tap the floating hearts',
          'hearts',
        ),
        KinestheticItem('Squash Bugs', '🐛', 'Tap the crawling bugs', 'bugs'),
        KinestheticItem('Catch Fruits', '🍓', 'Tap falling fruits', 'fruits'),
        KinestheticItem('Hit Moles', '🦫', 'Tap the popping moles', 'moles'),
        KinestheticItem('Catch Fish', '🐟', 'Tap the swimming fish', 'fish'),
        KinestheticItem('Pop Flowers', '🌺', 'Tap blooming flowers', 'flowers'),
        KinestheticItem('Catch Coins', '🪙', 'Tap falling coins', 'coins'),
        KinestheticItem(
          'Hit Drums',
          '🥁',
          'Tap the drums to make music',
          'drums',
        ),
        KinestheticItem(
          'Catch Snowflakes',
          '❄️',
          'Tap falling snowflakes',
          'snowflakes',
        ),
      ],
    ),
    KinestheticCategory(
      name: 'Swiping',
      emoji: '👋',
      items: [
        KinestheticItem(
          'Animal Sounds',
          '🐕',
          'Swipe to learn animal sounds',
          'animals',
        ),
        KinestheticItem('Color Match', '🌈', 'Swipe to match colors', 'colors'),
        KinestheticItem('Shape Match', '⬛', 'Swipe to match shapes', 'shapes'),
        KinestheticItem('Word Match', '📝', 'Swipe to match words', 'words'),
        KinestheticItem(
          'Number Match',
          '🔢',
          'Swipe to match numbers',
          'numbers',
        ),
        KinestheticItem(
          'Picture Match',
          '🖼️',
          'Swipe to match pictures',
          'pictures',
        ),
        KinestheticItem('Fruit Match', '🍎', 'Swipe to match fruits', 'fruits'),
        KinestheticItem(
          'Vehicle Match',
          '🚗',
          'Swipe to match vehicles',
          'vehicles',
        ),
        KinestheticItem('Food Match', '🍕', 'Swipe to match foods', 'foods'),
        KinestheticItem('Bird Match', '🦅', 'Swipe to match birds', 'birds'),
        KinestheticItem(
          'Insect Match',
          '🦋',
          'Swipe to match insects',
          'insects',
        ),
        KinestheticItem(
          'Planet Match',
          '🪐',
          'Swipe to match planets',
          'planets',
        ),
        KinestheticItem('Sport Match', '⚽', 'Swipe to match sports', 'sports'),
        KinestheticItem(
          'Music Match',
          '🎵',
          'Swipe to match instruments',
          'instruments',
        ),
        KinestheticItem(
          'Weather Match',
          '☁️',
          'Swipe to match weather',
          'weather',
        ),
        KinestheticItem(
          'Season Match',
          '🌸',
          'Swipe to match seasons',
          'seasons',
        ),
        KinestheticItem(
          'Emotion Match',
          '😊',
          'Swipe to match emotions',
          'emotions',
        ),
        KinestheticItem('Tool Match', '🔨', 'Swipe to match tools', 'tools'),
        KinestheticItem(
          'Clothing Match',
          '👗',
          'Swipe to match clothes',
          'clothes',
        ),
        KinestheticItem(
          'Flower Match',
          '🌷',
          'Swipe to match flowers',
          'flowers',
        ),
      ],
    ),
    KinestheticCategory(
      name: 'Motion',
      emoji: '📱',
      items: [
        KinestheticItem(
          'Shake Reveal',
          '🎲',
          'Shake device to reveal number',
          'shake',
        ),
        KinestheticItem(
          'Tilt Balance',
          '⚖️',
          'Tilt to balance objects',
          'tilt',
        ),
        KinestheticItem(
          'Pinch Zoom',
          '🔍',
          'Pinch to explore details',
          'pinch',
        ),
        KinestheticItem(
          'Rotate Find',
          '🔄',
          'Rotate to find hidden items',
          'rotate',
        ),
        KinestheticItem(
          'Move Guide',
          '🧭',
          'Move device to guide ball',
          'move',
        ),
        KinestheticItem('Draw Air', '✨', 'Draw patterns in the air', 'air'),
        KinestheticItem('Shake Colors', '🎨', 'Shake to mix colors', 'colors'),
        KinestheticItem('Tilt Maze', '🌀', 'Tilt to navigate the maze', 'maze'),
        KinestheticItem('Pinch Stars', '⭐', 'Pinch to collect stars', 'stars'),
        KinestheticItem(
          'Rotate Puzzle',
          '🧩',
          'Rotate pieces to solve puzzle',
          'puzzle',
        ),
        KinestheticItem(
          'Move Paint',
          '🖌️',
          'Move to paint a picture',
          'paint',
        ),
        KinestheticItem('Shake Music', '🎶', 'Shake to make music', 'music'),
        KinestheticItem('Tilt Water', '💧', 'Tilt to pour water', 'water'),
        KinestheticItem(
          'Pinch Animals',
          '🦊',
          'Pinch to zoom on animals',
          'animals',
        ),
        KinestheticItem(
          'Rotate Wheel',
          '🎡',
          'Rotate the wheel to spin',
          'wheel',
        ),
        KinestheticItem(
          'Move Butterfly',
          '🦋',
          'Move to guide butterfly',
          'butterfly',
        ),
        KinestheticItem('Shake Dice', '🎯', 'Shake to roll the dice', 'dice'),
        KinestheticItem('Tilt Snow', '❄️', 'Tilt to make snow fall', 'snow'),
        KinestheticItem(
          'Pinch Bubbles',
          '🫧',
          'Pinch to create bubbles',
          'bubbles',
        ),
        KinestheticItem(
          'Rotate Clock',
          '🕐',
          'Rotate to set the time',
          'clock',
        ),
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
      _box.write(
        'kinesthetic_progress_$categoryIndex',
        _visitedItems[categoryIndex]!.toList(),
      );
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
              SizedBox(height: 8.h),
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 24.h),
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
    final category = _categories[_currentCategory];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
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
          tabs: _categories.map((cat) {
            return Tab(
              child: Text(
                cat.name,
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
                        Flexible(
                          child: const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '$_progressString completed',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
              // Activities grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(12.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
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
                              if (_visitedItems[_currentCategory]?.contains(
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

// Tracing Activity Screen
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
// Tapping Activity Screen
// Swiping Activity Screen
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
