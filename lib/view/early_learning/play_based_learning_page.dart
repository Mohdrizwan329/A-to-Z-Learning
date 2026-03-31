import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class PlayBasedLearningPage extends StatefulWidget {
  const PlayBasedLearningPage({super.key});

  @override
  State<PlayBasedLearningPage> createState() => _PlayBasedLearningPageState();
}

class _PlayBasedLearningPageState extends State<PlayBasedLearningPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final GetStorage _box = GetStorage();
  int _currentCategory = 0;

  // Track visited items per category
  final Map<int, Set<int>> _visitedItems = {};

  final List<PlayCategory> _categories = [
    PlayCategory(
      name: 'Memory Games',
      emoji: '🧠',
      items: [
        PlayItem('Card Match', '🃏', 'Match pairs of cards', GameType.memory),
        PlayItem(
          'Picture Memory',
          '🖼️',
          'Remember and match pictures',
          GameType.memory,
        ),
        PlayItem(
          'Sound Memory',
          '🔊',
          'Match sounds together',
          GameType.memory,
        ),
        PlayItem(
          'Color Memory',
          '🎨',
          'Remember color patterns',
          GameType.memory,
        ),
        PlayItem(
          'Shape Memory',
          '🔷',
          'Match shapes together',
          GameType.memory,
        ),
        PlayItem('Animal Memory', '🐕', 'Match animal pairs', GameType.memory),
        PlayItem(
          'Fruit Match',
          '🍎',
          'Match fruit pairs together',
          GameType.memory,
        ),
        PlayItem(
          'Number Memory',
          '🔢',
          'Remember number sequences',
          GameType.memory,
        ),
        PlayItem('Letter Memory', '🔤', 'Match letter pairs', GameType.memory),
        PlayItem('Vehicle Match', '🚗', 'Match vehicle pairs', GameType.memory),
        PlayItem('Food Memory', '🍕', 'Remember food items', GameType.memory),
        PlayItem('Emoji Match', '😊', 'Match emoji pairs', GameType.memory),
        PlayItem(
          'Music Memory',
          '🎵',
          'Remember musical notes',
          GameType.memory,
        ),
        PlayItem('Nature Memory', '🌸', 'Match nature items', GameType.memory),
        PlayItem(
          'Sports Match',
          '⚽',
          'Match sports equipment',
          GameType.memory,
        ),
        PlayItem('Tool Memory', '🔧', 'Match tool pairs', GameType.memory),
        PlayItem(
          'Weather Match',
          '☀️',
          'Match weather symbols',
          GameType.memory,
        ),
        PlayItem(
          'Flag Memory',
          '🏁',
          'Remember flag patterns',
          GameType.memory,
        ),
        PlayItem('Planet Match', '🪐', 'Match planet pairs', GameType.memory),
        PlayItem('Ocean Memory', '🐠', 'Match sea creatures', GameType.memory),
      ],
    ),
    PlayCategory(
      name: 'Puzzle Games',
      emoji: '🧩',
      items: [
        PlayItem(
          'Jigsaw Puzzle',
          '🧩',
          'Complete the picture puzzle',
          GameType.puzzle,
        ),
        PlayItem(
          'Pattern Puzzle',
          '🔶',
          'Complete the pattern',
          GameType.puzzle,
        ),
        PlayItem(
          'Number Puzzle',
          '🔢',
          'Arrange numbers correctly',
          GameType.puzzle,
        ),
        PlayItem(
          'Word Puzzle',
          '📝',
          'Form words from letters',
          GameType.puzzle,
        ),
        PlayItem(
          'Logic Puzzle',
          '🤔',
          'Solve the logic problem',
          GameType.puzzle,
        ),
        PlayItem('Maze Puzzle', '🏃', 'Find the way out', GameType.puzzle),
        PlayItem(
          'Sliding Puzzle',
          '🔀',
          'Slide tiles to solve',
          GameType.puzzle,
        ),
        PlayItem('Crossword', '✏️', 'Fill in the crossword', GameType.puzzle),
        PlayItem(
          'Sudoku Kids',
          '9️⃣',
          'Simple number grid puzzle',
          GameType.puzzle,
        ),
        PlayItem('Shape Fit', '🔲', 'Fit shapes in holes', GameType.puzzle),
        PlayItem(
          'Picture Sort',
          '🖼️',
          'Sort pictures correctly',
          GameType.puzzle,
        ),
        PlayItem(
          'Missing Piece',
          '❓',
          'Find the missing piece',
          GameType.puzzle,
        ),
        PlayItem(
          'Connect Dots',
          '⚫',
          'Connect dots to make pictures',
          GameType.puzzle,
        ),
        PlayItem('Tangram', '📐', 'Create shapes with pieces', GameType.puzzle),
        PlayItem(
          'Block Tower',
          '🧱',
          'Stack blocks correctly',
          GameType.puzzle,
        ),
        PlayItem(
          'Sequence Puzzle',
          '1️⃣',
          'Complete the sequence',
          GameType.puzzle,
        ),
        PlayItem(
          'Mirror Image',
          '🪞',
          'Complete the mirror image',
          GameType.puzzle,
        ),
        PlayItem(
          'Rotation Puzzle',
          '🔄',
          'Rotate to complete picture',
          GameType.puzzle,
        ),
        PlayItem(
          'Shadow Match',
          '👤',
          'Match objects to shadows',
          GameType.puzzle,
        ),
        PlayItem(
          'Story Sequence',
          '📚',
          'Arrange story in order',
          GameType.puzzle,
        ),
      ],
    ),
    PlayCategory(
      name: 'Action Games',
      emoji: '🎮',
      items: [
        PlayItem(
          'Color Pop',
          '🎈',
          'Pop the right colored bubbles',
          GameType.colorPop,
        ),
        PlayItem(
          'Number Jump',
          '🔢',
          'Jump on numbers in order',
          GameType.numberJump,
        ),
        PlayItem('Catch Stars', '⭐', 'Catch falling stars', GameType.action),
        PlayItem('Pop Bubbles', '🫧', 'Pop all the bubbles', GameType.action),
        PlayItem(
          'Hit Targets',
          '🎯',
          'Hit the moving targets',
          GameType.action,
        ),
        PlayItem('Race Track', '🏎️', 'Race to the finish', GameType.action),
        PlayItem(
          'Fruit Catcher',
          '🍇',
          'Catch falling fruits',
          GameType.action,
        ),
        PlayItem(
          'Balloon Float',
          '🎈',
          'Keep balloons afloat',
          GameType.action,
        ),
        PlayItem('Duck Hunt', '🦆', 'Catch the flying ducks', GameType.action),
        PlayItem(
          'Ball Bounce',
          '🏀',
          'Bounce ball into basket',
          GameType.action,
        ),
        PlayItem('Fish Catch', '🐟', 'Catch swimming fish', GameType.action),
        PlayItem('Bug Squash', '🐛', 'Tap the bugs quickly', GameType.action),
        PlayItem('Coin Collect', '🪙', 'Collect golden coins', GameType.action),
        PlayItem(
          'Rocket Launch',
          '🚀',
          'Launch rockets to space',
          GameType.action,
        ),
        PlayItem('Gem Grab', '💎', 'Grab falling gems', GameType.action),
        PlayItem('Apple Pick', '🍎', 'Pick apples from tree', GameType.action),
        PlayItem('Candy Catch', '🍬', 'Catch sweet candies', GameType.action),
        PlayItem('Bird Fly', '🐦', 'Help bird fly through', GameType.action),
        PlayItem(
          'Snowball Throw',
          '⛄',
          'Throw snowballs at targets',
          GameType.action,
        ),
        PlayItem(
          'Leaf Collect',
          '🍂',
          'Collect falling leaves',
          GameType.action,
        ),
      ],
    ),
    PlayCategory(
      name: 'Creative Games',
      emoji: '🎨',
      items: [
        PlayItem(
          'Color & Draw',
          '🖌️',
          'Create beautiful art',
          GameType.creative,
        ),
        PlayItem('Shape Builder', '🔷', 'Build with shapes', GameType.creative),
        PlayItem(
          'Story Maker',
          '📖',
          'Create your own story',
          GameType.creative,
        ),
        PlayItem('Music Maker', '🎵', 'Make your own music', GameType.creative),
        PlayItem(
          'Animal Creator',
          '🦁',
          'Design fun animals',
          GameType.creative,
        ),
        PlayItem('House Builder', '🏠', 'Build a house', GameType.creative),
        PlayItem('Face Maker', '😀', 'Create funny faces', GameType.creative),
        PlayItem(
          'Robot Builder',
          '🤖',
          'Build your own robot',
          GameType.creative,
        ),
        PlayItem('Car Designer', '🚗', 'Design a cool car', GameType.creative),
        PlayItem(
          'Garden Creator',
          '🌷',
          'Create beautiful garden',
          GameType.creative,
        ),
        PlayItem('Pizza Maker', '🍕', 'Design your pizza', GameType.creative),
        PlayItem(
          'Ice Cream Shop',
          '🍦',
          'Make ice cream sundae',
          GameType.creative,
        ),
        PlayItem('Dress Up', '👗', 'Dress up characters', GameType.creative),
        PlayItem(
          'Castle Builder',
          '🏰',
          'Build a magical castle',
          GameType.creative,
        ),
        PlayItem(
          'Space Station',
          '🛸',
          'Create space station',
          GameType.creative,
        ),
        PlayItem(
          'Monster Maker',
          '👾',
          'Create friendly monsters',
          GameType.creative,
        ),
        PlayItem('Aquarium', '🐠', 'Design your aquarium', GameType.creative),
        PlayItem(
          'Cake Decorator',
          '🎂',
          'Decorate birthday cake',
          GameType.creative,
        ),
        PlayItem(
          'Card Creator',
          '💌',
          'Make greeting cards',
          GameType.creative,
        ),
        PlayItem(
          'Superhero Maker',
          '🦸',
          'Create superhero',
          GameType.creative,
        ),
      ],
    ),
    PlayCategory(
      name: 'Learning Games',
      emoji: '📚',
      items: [
        PlayItem(
          'Letter Match',
          '🔤',
          'Match letters together',
          GameType.learning,
        ),
        PlayItem(
          'Number Fun',
          '🔢',
          'Learn numbers playfully',
          GameType.learning,
        ),
        PlayItem('Color Quiz', '🌈', 'Identify colors', GameType.learning),
        PlayItem('Shape Quiz', '⭐', 'Identify shapes', GameType.learning),
        PlayItem('Animal Quiz', '🐘', 'Learn about animals', GameType.learning),
        PlayItem('Word Builder', '📝', 'Build simple words', GameType.learning),
        PlayItem(
          'Counting Game',
          '🔟',
          'Learn to count objects',
          GameType.learning,
        ),
        PlayItem(
          'ABC Order',
          '🅰️',
          'Arrange letters in order',
          GameType.learning,
        ),
        PlayItem('Sight Words', '👁️', 'Learn common words', GameType.learning),
        PlayItem('Phonics Fun', '📣', 'Learn letter sounds', GameType.learning),
        PlayItem('Math Facts', '➕', 'Learn basic math', GameType.learning),
        PlayItem('Time Teller', '⏰', 'Learn to tell time', GameType.learning),
        PlayItem('Money Match', '💰', 'Learn about coins', GameType.learning),
        PlayItem('Size Sort', '📏', 'Sort by size', GameType.learning),
        PlayItem('Pattern Match', '🔶', 'Complete patterns', GameType.learning),
        PlayItem('Opposites', '↔️', 'Learn opposite words', GameType.learning),
        PlayItem('Rhyme Time', '🎤', 'Find rhyming words', GameType.learning),
        PlayItem('Body Parts', '🫀', 'Learn body parts', GameType.learning),
        PlayItem(
          'Weather Learn',
          '🌤️',
          'Learn about weather',
          GameType.learning,
        ),
        PlayItem(
          'Seasons Quiz',
          '🍂',
          'Learn about seasons',
          GameType.learning,
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
      final saved = _box.read<List>('play_progress_$i');
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
        'play_progress_$categoryIndex',
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
        _box.remove('play_progress_$i');
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

  void _onItemTap(PlayItem item, int itemIndex) {
    TtsService.to.speak(item.name);
    HapticFeedback.mediumImpact();
    _speak('${item.name}. ${item.description}');
    _markItemVisited(_currentCategory, itemIndex);
    _showItemDetail(item);
  }

  void _showItemDetail(PlayItem item) {
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
                    icon: Icons.play_arrow,
                    label: 'Play',
                    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () {
                      Get.back();
                      _playGame(item);
                    },
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

  void _playGame(PlayItem item) {
    HapticFeedback.mediumImpact();

    switch (item.type) {
      case GameType.memory:
        Get.to(() => _MemoryGameScreen(onComplete: _onGameComplete));
        break;
      case GameType.colorPop:
        Get.to(() => _ColorPopScreen(onComplete: _onGameComplete));
        break;
      case GameType.numberJump:
        Get.to(() => _NumberJumpScreen(onComplete: _onGameComplete));
        break;
      default:
        _showComingSoon(item);
    }
  }

  void _showComingSoon(PlayItem item) {
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
              Text(item.emoji, style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Coming Soon!',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              _buildGradientButton(
                icon: Icons.check,
                label: 'OK',
                gradient: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGameComplete(int stars) {
    HapticFeedback.heavyImpact();
    _speak('Great job! You earned $stars stars!');

    Get.snackbar(
      '⭐ You earned $stars stars!',
      'Keep playing and learning!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.amber,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
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
          'Play & Learning',
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
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
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
              // Games grid
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 75,
                                        height: 75,
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
                              if (_visitedItems[_currentCategory]?.contains(
                                    index,
                                  ) ==
                                  true)
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

// Memory Game Screen
class _MemoryGameScreen extends StatefulWidget {
  final Function(int) onComplete;

  const _MemoryGameScreen({required this.onComplete});

  @override
  State<_MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<_MemoryGameScreen> {
  final List<String> _emojis = ['🍎', '🍌', '🍇', '🍊', '🍎', '🍌', '🍇', '🍊'];
  List<bool> _revealed = [];
  List<bool> _matched = [];
  int? _firstIndex;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _emojis.shuffle();
    _revealed = List.filled(_emojis.length, false);
    _matched = List.filled(_emojis.length, false);
  }

  void _onCardTap(int index) {
    if (_revealed[index] || _matched[index]) return;

    HapticFeedback.lightImpact();
    setState(() {
      _revealed[index] = true;
      _moves++;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
    } else {
      if (_emojis[_firstIndex!] == _emojis[index]) {
        setState(() {
          _matched[_firstIndex!] = true;
          _matched[index] = true;
        });
        _firstIndex = null;

        if (_matched.every((m) => m)) {
          Future.delayed(const Duration(milliseconds: 500), () {
            final stars = _moves <= 10 ? 3 : (_moves <= 15 ? 2 : 1);
            widget.onComplete(stars);
            Get.back();
          });
        }
      } else {
        final first = _firstIndex;
        _firstIndex = null;
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _revealed[first!] = false;
            _revealed[index] = false;
          });
        });
      }
    }
  }

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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Moves: $_moves',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: _emojis.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _matched[index]
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF66BB6A),
                                    ]
                                  : (_revealed[index]
                                        ? [Colors.white, Colors.white]
                                        : [
                                            const Color(0xFFFF6B6B),
                                            const Color(0xFFFF8E53),
                                          ]),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _revealed[index] || _matched[index]
                                  ? _emojis[index]
                                  : '?',
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    },
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

// Color Pop Game
class _ColorPopScreen extends StatefulWidget {
  final Function(int) onComplete;

  const _ColorPopScreen({required this.onComplete});

  @override
  State<_ColorPopScreen> createState() => _ColorPopScreenState();
}

class _ColorPopScreenState extends State<_ColorPopScreen> {
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow},
  ];
  late Map<String, dynamic> _targetColor;
  int _score = 0;
  int _round = 0;
  final int _totalRounds = 5;
  final Random _random = Random();
  List<Offset> _bubbles = [];

  @override
  void initState() {
    super.initState();
    _generateRound();
  }

  void _generateRound() {
    _targetColor = _colors[_random.nextInt(_colors.length)];
    _bubbles = List.generate(8, (i) {
      return Offset(
        50.0 + _random.nextDouble() * 250,
        100.0 + _random.nextDouble() * 400,
      );
    });
    setState(() {});
  }

  void _onBubbleTap(int index, Color bubbleColor) {
    HapticFeedback.lightImpact();
    if (bubbleColor == _targetColor['color']) {
      setState(() {
        _score++;
        _round++;
      });
      if (_round >= _totalRounds) {
        widget.onComplete(_score >= 4 ? 3 : (_score >= 2 ? 2 : 1));
        Get.back();
      } else {
        _generateRound();
      }
    }
  }

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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Round ${_round + 1}/$_totalRounds',
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
              const SizedBox(height: 20),
              Text(
                'Pop the ${_targetColor['name']} bubbles!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _targetColor['color'],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
              Expanded(
                child: Stack(
                  children: List.generate(_bubbles.length, (index) {
                    final bubbleColor =
                        _colors[index % _colors.length]['color'] as Color;
                    return Positioned(
                      left: _bubbles[index].dx,
                      top: _bubbles[index].dy,
                      child: GestureDetector(
                        onTap: () => _onBubbleTap(index, bubbleColor),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: bubbleColor.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: bubbleColor.withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Number Jump Game
class _NumberJumpScreen extends StatefulWidget {
  final Function(int) onComplete;

  const _NumberJumpScreen({required this.onComplete});

  @override
  State<_NumberJumpScreen> createState() => _NumberJumpScreenState();
}

class _NumberJumpScreenState extends State<_NumberJumpScreen> {
  final List<int> _numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int _nextNumber = 1;
  int _mistakes = 0;
  late List<int> _shuffledNumbers;

  @override
  void initState() {
    super.initState();
    _shuffledNumbers = List.from(_numbers)..shuffle();
  }

  void _onNumberTap(int number) {
    HapticFeedback.lightImpact();
    if (number == _nextNumber) {
      setState(() => _nextNumber++);
      if (_nextNumber > 9) {
        final stars = _mistakes == 0 ? 3 : (_mistakes <= 2 ? 2 : 1);
        widget.onComplete(stars);
        Get.back();
      }
    } else {
      setState(() => _mistakes++);
    }
  }

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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Find number $_nextNumber',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                    itemCount: _shuffledNumbers.length,
                    itemBuilder: (context, index) {
                      final number = _shuffledNumbers[index];
                      final isFound = number < _nextNumber;

                      return GestureDetector(
                        onTap: isFound ? null : () => _onNumberTap(number),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isFound
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF66BB6A),
                                    ]
                                  : [
                                      const Color(0xFFFF6B6B),
                                      const Color(0xFFFF8E53),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (isFound ? Colors.green : Colors.red)
                                    .withValues(alpha: 0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              isFound ? '✓' : '$number',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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

enum GameType {
  memory,
  colorPop,
  numberJump,
  puzzle,
  action,
  creative,
  learning,
}

class PlayCategory {
  final String name;
  final String emoji;
  final List<PlayItem> items;

  PlayCategory({required this.name, required this.emoji, required this.items});
}

class PlayItem {
  final String name;
  final String emoji;
  final String description;
  final GameType type;

  PlayItem(this.name, this.emoji, this.description, this.type);
}
