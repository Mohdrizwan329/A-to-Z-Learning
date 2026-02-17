import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view/games/puzzle_game_page.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class GamesHubPage extends StatefulWidget {
  const GamesHubPage({super.key});

  @override
  State<GamesHubPage> createState() => _GamesHubPageState();
}

class _GamesHubPageState extends State<GamesHubPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late AnimationController _starController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> games = [
    {
      'title': 'Puzzle Game',
      'subtitle': 'Solve fun puzzles!',
      'emoji': '🧩',
      'gradient': [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
      'page': () => PuzzleGamePage(),
    },
    {
      'title': 'Memory Game',
      'subtitle': 'Train your brain!',
      'emoji': '🧠',
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
      'page': () => MemoryGamePage(),
    },
    {
      'title': 'Number Quiz',
      'subtitle': 'Test your math!',
      'emoji': '🔢',
      'gradient': [Color(0xFF56D97F), Color(0xFF4ECDC4)],
      'page': () => NumberQuizPage(),
    },
    {
      'title': 'Color Match',
      'subtitle': 'Match colors!',
      'emoji': '🌈',
      'gradient': [Color(0xFFFF6EB4), Color(0xFFf093fb)],
      'page': () => ColorMatchPage(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    _starController.dispose();
    super.dispose();
  }

  // Floating bubbles for playful effect (same as home screen)
  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(15, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Floating stars for extra fun effect
  List<Widget> _buildFloatingStars() {
    final random = math.Random(123);
    final starEmojis = ['⭐', '✨', '🌟', '💫'];
    return List.generate(8, (index) {
      final left = random.nextDouble() * 350 + 20;
      final top = random.nextDouble() * 600 + 100;
      final emoji = starEmojis[index % starEmojis.length];

      return AnimatedBuilder(
        animation: _starController,
        builder: (context, child) {
          final scale = 0.8 + (_starController.value * 0.4);
          final opacity = 0.3 + (_starController.value * 0.3);

          return Positioned(
            left: left,
            top: top,
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      bottomNavigationBar: const AdsScreen(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Kid-friendly rainbow gradient background (same as home screen)
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA), // Soft Purple
              Color(0xFF764BA2), // Deep Purple
              Color(0xFFf093fb), // Pink
              Color(0xFFf5576c), // Coral
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating bubbles background
            ..._buildFloatingBubbles(),
            // Floating stars
            ..._buildFloatingStars(),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header section with title
                  _buildHeader(),
                  // Games grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: games.length,
                      itemBuilder: (context, index) => _buildGameCard(index),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
          // Vibrant kid-friendly gradient - Coral to Pink to Orange
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B6B), // Coral Red
              Color(0xFFFF8E53), // Orange
              Color(0xFFFFAA5A), // Light Orange
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x40FF6B6B),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Fun ',
            style: GoogleFonts.baloo2(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
          Text(
            'Games',
            style: GoogleFonts.baloo2(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFE66D), // Yellow
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    return const SizedBox(height: 8);
  }

  Widget _buildGameCard(int index) {
    final game = games[index];
    final gradientList = game['gradient'];
    final gradient = (gradientList as List).cast<Color>();

    return GestureDetector(
      onTap: () => Get.to(game['page']),
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final offset = (index % 2 == 0)
              ? _floatAnimation.value * 0.5
              : -_floatAnimation.value * 0.5;
          return Transform.translate(offset: Offset(0, offset), child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Emoji
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            game['emoji']!,
                            style: const TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        game['title']!,
                        style: GoogleFonts.nunito(
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
            ],
          ),
        ),
      ),
    );
  }
}

// Memory Game using GradientScaffold
class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  // 100 emojis organized by categories
  final List<String> _allEmojis = [
    // Animals (25)
    '🐶', '🐱', '🐰', '🦊', '🐻', '🐼', '🦁', '🐯', '🐮', '🐷',
    '🐸', '🐵', '🦄', '🐝', '🦋', '🐢', '🐍', '🦎', '🦀', '🐙',
    '🦈', '🐳', '🐬', '🦭', '🐧',
    // Birds (10)
    '🦅', '🦆', '🦉', '🦜', '🐦', '🦢', '🦩', '🕊️', '🦚', '🐔',
    // Fruits (12)
    '🍎', '🍊', '🍋', '🍇', '🍓', '🍑', '🍒', '🥭', '🍍', '🥝',
    '🍌', '🍉',
    // Food (12)
    '🍕', '🍔', '🌮', '🍩', '🍰', '🧁', '🍪', '🍫', '🍟', '🌭',
    '🍿', '🥪',
    // Vegetables (8)
    '🥕', '🥦', '🌽', '🥬', '🍆', '🥒', '🌶️', '🧅',
    // Nature (10)
    '🌸', '🌻', '🌺', '🌷', '🌹', '🍀', '🌴', '🌵', '🍁', '🌲',
    // Sports & Objects (10)
    '⚽', '🏀', '🎾', '🎸', '🎹', '🎨', '🏈', '⚾', '🎱', '🏐',
    // Transport (8)
    '🚗', '🚕', '🚌', '✈️', '🚀', '🚁', '🛸', '⛵',
    // Weather & Sky (5)
    '☀️', '🌙', '⭐', '🌈', '❄️',
  ];

  late List<String> _levelEmojis; // Emojis for current level
  late List<String> _cards;
  late List<bool> _revealed;
  int? _firstIndex;
  int? _secondIndex;
  int _matches = 0;
  int _moves = 0;
  bool _canTap = true;
  int _currentLevel = 0;
  final int _totalLevels = 12; // 100 emojis / 8 per level = 12+ levels
  final int _emojisPerLevel = 8;
  bool _isLevelComplete = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _setupLevel();
  }

  void _setupLevel() {
    // Get emojis for current level (8 emojis per level)
    int startIndex = (_currentLevel * _emojisPerLevel) % _allEmojis.length;
    _levelEmojis = [];
    for (int i = 0; i < _emojisPerLevel; i++) {
      _levelEmojis.add(_allEmojis[(startIndex + i) % _allEmojis.length]);
    }

    _cards = [..._levelEmojis, ..._levelEmojis];
    _cards.shuffle();
    _revealed = List.filled(16, false);
    _firstIndex = null;
    _secondIndex = null;
    _matches = 0;
    _moves = 0;
    _canTap = true;
    _isLevelComplete = false;
  }

  void _clearAndRetry() {
    setState(() {
      _setupLevel();
    });
  }

  void _resetAllProgress() {
    setState(() {
      _currentLevel = 0;
      _setupLevel();
    });
  }

  void _goToPreviousLevel() {
    if (_currentLevel > 0) {
      setState(() {
        _currentLevel--;
        _setupLevel();
      });
    }
  }

  void _goToNextLevel() {
    if (_currentLevel < _totalLevels - 1) {
      setState(() {
        _currentLevel++;
        _setupLevel();
      });
    }
  }

  void _onCardTap(int index) {
    if (!_canTap || _revealed[index]) return;

    setState(() {
      _revealed[index] = true;

      if (_firstIndex == null) {
        _firstIndex = index;
      } else {
        _secondIndex = index;
        _moves++;
        _canTap = false;

        if (_cards[_firstIndex!] == _cards[_secondIndex!]) {
          _matches++;
          _firstIndex = null;
          _secondIndex = null;
          _canTap = true;

          if (_matches == 8) {
            _isLevelComplete = true;
            _showWinDialog();
          }
        } else {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _revealed[_firstIndex!] = false;
                _revealed[_secondIndex!] = false;
                _firstIndex = null;
                _secondIndex = null;
                _canTap = true;
              });
            }
          });
        }
      }
    });
  }

  void _showWinDialog() {
    bool isLastLevel = _currentLevel >= _totalLevels - 1;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastLevel ? "🏆" : "🎉",
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 16),
            Text(
              isLastLevel
                  ? 'All Levels Complete!'
                  : 'Level ${_currentLevel + 1} Complete!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFAA5A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completed in $_moves moves',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back();
                if (isLastLevel) {
                  _resetAllProgress();
                } else {
                  _goToNextLevel();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFAA5A),
                foregroundColor: Colors.white,
              ),
              child: Text(isLastLevel ? 'Play Again' : 'Next Level'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Memory Game',
      appBarGradient: const [
        Color(0xFFFF6B6B),
        Color(0xFFFF8E53),
        Color(0xFFFFAA5A),
      ],
      bodyGradient: const [
        Color(0xFF667EEA),
        Color(0xFF764BA2),
        Color(0xFFf093fb),
        Color(0xFFf5576c),
      ],
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
          onPressed: () => _resetAllProgress(),
        ),
      ],
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level ${_currentLevel + 1} of $_totalLevels',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${((_currentLevel + 1) / _totalLevels * 100).toInt()}%',
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
                    value: (_currentLevel + 1) / _totalLevels,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4CAF50),
                    ),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
          // Stats row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Matches: $_matches/8',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Moves: $_moves',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Cards grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _revealed[index]
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      color: _revealed[index] ? Colors.white : null,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _revealed[index]
                              ? Colors.black.withValues(alpha: 0.1)
                              : const Color(0xFFFFAA5A).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circle
                        if (!_revealed[index])
                          Positioned(
                            top: -10,
                            right: -10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                        // Emoji
                        Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _revealed[index]
                                  ? Colors.grey.withValues(alpha: 0.1)
                                  : Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _revealed[index] ? _cards[index] : '❓',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Clear & Try Again button (shown when not complete and has moves)
          if (!_isLevelComplete && _moves > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: _clearAndRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.refresh, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Clear & Try Again',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                GestureDetector(
                  onTap: _currentLevel > 0 ? _goToPreviousLevel : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: _currentLevel > 0
                          ? const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: _currentLevel > 0
                          ? null
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _currentLevel > 0
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF6B6B,
                                ).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: _currentLevel > 0
                              ? Colors.white
                              : Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Previous',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _currentLevel > 0
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Next button (only enabled when level is complete)
                GestureDetector(
                  onTap: _isLevelComplete && _currentLevel < _totalLevels - 1
                      ? _goToNextLevel
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          _isLevelComplete && _currentLevel < _totalLevels - 1
                          ? const LinearGradient(
                              colors: [Color(0xFF56D97F), Color(0xFF4ECDC4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color:
                          _isLevelComplete && _currentLevel < _totalLevels - 1
                          ? null
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          _isLevelComplete && _currentLevel < _totalLevels - 1
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF56D97F,
                                ).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Next',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                _isLevelComplete &&
                                    _currentLevel < _totalLevels - 1
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color:
                              _isLevelComplete &&
                                  _currentLevel < _totalLevels - 1
                              ? Colors.white
                              : Colors.white54,
                          size: 18,
                        ),
                      ],
                    ),
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

// Number Quiz Game using GradientScaffold
class NumberQuizPage extends StatefulWidget {
  const NumberQuizPage({super.key});

  @override
  State<NumberQuizPage> createState() => _NumberQuizPageState();
}

class _NumberQuizPageState extends State<NumberQuizPage> {
  int _num1 = 0;
  int _num2 = 0;
  String _operator = '+';
  int _correctAnswer = 0;
  List<int> _options = [];
  int _score = 0;
  int _question = 0;
  bool? _isCorrect;

  // Total 50 questions
  static const int _totalQuestions = 50;

  void _resetQuiz() {
    setState(() {
      _num1 = 0;
      _num2 = 0;
      _operator = '+';
      _correctAnswer = 0;
      _options = [];
      _score = 0;
      _question = 0;
      _isCorrect = null;
    });
    _generateQuestion();
  }

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      _isCorrect = null;
      _question++;
      _num1 = (DateTime.now().millisecond % 10) + 1;
      _num2 = (DateTime.now().microsecond % 10) + 1;

      final ops = ['+', '-', '×'];
      _operator = ops[_question % 3];

      switch (_operator) {
        case '+':
          _correctAnswer = _num1 + _num2;
          break;
        case '-':
          if (_num1 < _num2) {
            final temp = _num1;
            _num1 = _num2;
            _num2 = temp;
          }
          _correctAnswer = _num1 - _num2;
          break;
        case '×':
          _num1 = (_num1 % 5) + 1;
          _num2 = (_num2 % 5) + 1;
          _correctAnswer = _num1 * _num2;
          break;
      }

      _options = [_correctAnswer];
      while (_options.length < 4) {
        int wrong = _correctAnswer + (DateTime.now().microsecond % 5) - 2;
        if (wrong != _correctAnswer &&
            wrong >= 0 &&
            !_options.contains(wrong)) {
          _options.add(wrong);
        } else {
          _options.add(_correctAnswer + _options.length);
        }
      }
      _options.shuffle();
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _isCorrect = answer == _correctAnswer;
      if (_isCorrect!) _score += 10;
    });

    // Only auto-advance if correct
    if (_isCorrect!) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_question < _totalQuestions) {
          _generateQuestion();
        } else {
          _showResult();
        }
      });
    }
  }

  void _clearAndRetry() {
    setState(() {
      _isCorrect = null;
      _options.shuffle();
    });
  }

  void _showResult() {
    final maxScore = _totalQuestions * 10;
    final percentage = (_score / maxScore * 100).round();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              percentage >= 80
                  ? "🏆"
                  : percentage >= 60
                  ? "🌟"
                  : "⭐",
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 80
                  ? 'Excellent!'
                  : percentage >= 60
                  ? 'Great Job!'
                  : 'Good Try!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF56D97F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: $_score/$maxScore ($percentage%)',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Questions: $_totalQuestions',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _resetQuiz();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF56D97F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _question / _totalQuestions;
    final percentage = (progress * 100).round();

    return GradientScaffold(
      title: 'Number Quiz',
      appBarGradient: const [
        Color(0xFFFF6B6B),
        Color(0xFFFF8E53),
        Color(0xFFFFAA5A),
      ],
      bodyGradient: const [
        Color(0xFF667EEA),
        Color(0xFF764BA2),
        Color(0xFFf093fb),
        Color(0xFFf5576c),
      ],
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
          onPressed: _resetQuiz,
          tooltip: 'Reset Quiz',
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question $_question/$_totalQuestions',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF56D97F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score: $_score',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Max: ${_totalQuestions * 10}',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Question card - styled like home screen
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF56D97F), Color(0xFF4ECDC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF56D97F).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🔢', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$_num1 $_operator $_num2 = ?',
                        style: GoogleFonts.nunito(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (_isCorrect != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _isCorrect!
                              ? '✓ Correct!'
                              : '✗ Answer: $_correctAnswer',
                          style: TextStyle(
                            color: _isCorrect!
                                ? Colors.white
                                : const Color(0xFFFFE66D),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Options grid - styled like home screen cards
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: _options.map((option) {
                return GestureDetector(
                  onTap: _isCorrect == null ? () => _checkAnswer(option) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF56D97F), Color(0xFF4ECDC4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF56D97F).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circle
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$option',
                                style: GoogleFonts.nunito(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            // Clear & Try Again button (shown when wrong)
            if (_isCorrect == false)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: _clearAndRetry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Clear & Try Again',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button (disabled for quiz as questions are random)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Previous',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Next button (only enabled when correct)
                  GestureDetector(
                    onTap: _isCorrect == true && _question < _totalQuestions
                        ? _generateQuestion
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            _isCorrect == true && _question < _totalQuestions
                            ? const LinearGradient(
                                colors: [Color(0xFF56D97F), Color(0xFF4ECDC4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: _isCorrect == true && _question < _totalQuestions
                            ? null
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow:
                            _isCorrect == true && _question < _totalQuestions
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF56D97F,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  _isCorrect == true &&
                                      _question < _totalQuestions
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            color:
                                _isCorrect == true &&
                                    _question < _totalQuestions
                                ? Colors.white
                                : Colors.white54,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Color Match Game using GradientScaffold
class ColorMatchPage extends StatefulWidget {
  const ColorMatchPage({super.key});

  @override
  State<ColorMatchPage> createState() => _ColorMatchPageState();
}

class _ColorMatchPageState extends State<ColorMatchPage> {
  // 50 colors organized by categories
  final List<Map<String, dynamic>> _allColors = [
    // Basic Colors (10)
    {'name': 'Red', 'color': const Color(0xFFFF0000)},
    {'name': 'Blue', 'color': const Color(0xFF0000FF)},
    {'name': 'Green', 'color': const Color(0xFF00FF00)},
    {'name': 'Yellow', 'color': const Color(0xFFFFFF00)},
    {'name': 'Orange', 'color': const Color(0xFFFF8000)},
    {'name': 'Purple', 'color': const Color(0xFF800080)},
    {'name': 'Pink', 'color': const Color(0xFFFF69B4)},
    {'name': 'Brown', 'color': const Color(0xFF8B4513)},
    {'name': 'Black', 'color': const Color(0xFF000000)},
    {'name': 'White', 'color': const Color(0xFFFFFFFF)},
    // Light Colors (10)
    {'name': 'Light Blue', 'color': const Color(0xFF87CEEB)},
    {'name': 'Light Green', 'color': const Color(0xFF90EE90)},
    {'name': 'Light Pink', 'color': const Color(0xFFFFB6C1)},
    {'name': 'Light Yellow', 'color': const Color(0xFFFFFFE0)},
    {'name': 'Lavender', 'color': const Color(0xFFE6E6FA)},
    {'name': 'Peach', 'color': const Color(0xFFFFDAB9)},
    {'name': 'Mint', 'color': const Color(0xFF98FF98)},
    {'name': 'Cream', 'color': const Color(0xFFFFFDD0)},
    {'name': 'Coral', 'color': const Color(0xFFFF7F50)},
    {'name': 'Salmon', 'color': const Color(0xFFFA8072)},
    // Dark Colors (10)
    {'name': 'Dark Blue', 'color': const Color(0xFF00008B)},
    {'name': 'Dark Green', 'color': const Color(0xFF006400)},
    {'name': 'Dark Red', 'color': const Color(0xFF8B0000)},
    {'name': 'Navy', 'color': const Color(0xFF000080)},
    {'name': 'Maroon', 'color': const Color(0xFF800000)},
    {'name': 'Olive', 'color': const Color(0xFF808000)},
    {'name': 'Teal', 'color': const Color(0xFF008080)},
    {'name': 'Charcoal', 'color': const Color(0xFF36454F)},
    {'name': 'Burgundy', 'color': const Color(0xFF800020)},
    {'name': 'Forest', 'color': const Color(0xFF228B22)},
    // Special Colors (10)
    {'name': 'Gold', 'color': const Color(0xFFFFD700)},
    {'name': 'Silver', 'color': const Color(0xFFC0C0C0)},
    {'name': 'Cyan', 'color': const Color(0xFF00FFFF)},
    {'name': 'Magenta', 'color': const Color(0xFFFF00FF)},
    {'name': 'Violet', 'color': const Color(0xFF8B00FF)},
    {'name': 'Indigo', 'color': const Color(0xFF4B0082)},
    {'name': 'Turquoise', 'color': const Color(0xFF40E0D0)},
    {'name': 'Aqua', 'color': const Color(0xFF00FFFF)},
    {'name': 'Lime', 'color': const Color(0xFF32CD32)},
    {'name': 'Crimson', 'color': const Color(0xFFDC143C)},
    // Nature Colors (10)
    {'name': 'Sky Blue', 'color': const Color(0xFF87CEEB)},
    {'name': 'Grass', 'color': const Color(0xFF7CFC00)},
    {'name': 'Sand', 'color': const Color(0xFFC2B280)},
    {'name': 'Ocean', 'color': const Color(0xFF006994)},
    {'name': 'Sunset', 'color': const Color(0xFFFFAB4C)},
    {'name': 'Rose', 'color': const Color(0xFFFF007F)},
    {'name': 'Chocolate', 'color': const Color(0xFFD2691E)},
    {'name': 'Honey', 'color': const Color(0xFFEB9605)},
    {'name': 'Plum', 'color': const Color(0xFFDDA0DD)},
    {'name': 'Slate', 'color': const Color(0xFF708090)},
  ];

  // Total 50 questions
  static const int _totalQuestions = 50;

  int _currentColorIndex = 0;
  late List<String> _options;
  int _score = 0;
  int _question = 0;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _setupQuestion();
  }

  void _resetGame() {
    setState(() {
      _currentColorIndex = 0;
      _score = 0;
      _question = 0;
      _isCorrect = null;
    });
    _setupQuestion();
  }

  void _setupQuestion() {
    setState(() {
      _isCorrect = null;
      _question = _currentColorIndex + 1;
      _generateOptions();
    });
  }

  void _generateOptions() {
    final currentColor = _allColors[_currentColorIndex];
    _options = [currentColor['name']];

    // Add 3 random wrong options
    final availableColors = List<Map<String, dynamic>>.from(_allColors);
    availableColors.removeWhere((c) => c['name'] == currentColor['name']);
    availableColors.shuffle();

    for (int i = 0; i < 3 && i < availableColors.length; i++) {
      _options.add(availableColors[i]['name']);
    }
    _options.shuffle();
  }

  void _checkAnswer(String answer) {
    final currentColor = _allColors[_currentColorIndex];
    setState(() {
      _isCorrect = answer == currentColor['name'];
      if (_isCorrect!) _score += 10;
    });

    // Only auto-advance if correct
    if (_isCorrect!) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_currentColorIndex < _totalQuestions - 1) {
          _goToNext();
        } else {
          _showResult();
        }
      });
    }
  }

  void _clearAndRetry() {
    setState(() {
      _isCorrect = null;
      _options.shuffle();
    });
  }

  void _goToPrevious() {
    if (_currentColorIndex > 0) {
      setState(() {
        _currentColorIndex--;
        _isCorrect = null;
      });
      _setupQuestion();
    }
  }

  void _goToNext() {
    if (_currentColorIndex < _totalQuestions - 1) {
      setState(() {
        _currentColorIndex++;
        _isCorrect = null;
      });
      _setupQuestion();
    } else {
      _showResult();
    }
  }

  void _showResult() {
    final maxScore = _totalQuestions * 10;
    final percentage = (_score / maxScore * 100).round();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              percentage >= 80
                  ? "🏆"
                  : percentage >= 60
                  ? "🌈"
                  : "⭐",
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 80
                  ? 'Color Master!'
                  : percentage >= 60
                  ? 'Great Job!'
                  : 'Good Try!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6EB4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: $_score/$maxScore ($percentage%)',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Colors: $_totalQuestions',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6EB4),
                foregroundColor: Colors.white,
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _allColors[_currentColorIndex];
    final progress = _question / _totalQuestions;
    final percentage = (progress * 100).round();

    return GradientScaffold(
      title: 'Color Match',
      appBarGradient: const [
        Color(0xFFFF6B6B),
        Color(0xFFFF8E53),
        Color(0xFFFFAA5A),
      ],
      bodyGradient: const [
        Color(0xFF667EEA),
        Color(0xFF764BA2),
        Color(0xFFf093fb),
        Color(0xFFf5576c),
      ],
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
          onPressed: _resetGame,
          tooltip: 'Reset Game',
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Color $_question/$_totalQuestions',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6EB4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score: $_score',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Max: ${_totalQuestions * 10}',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Color display card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6EB4), Color(0xFFf093fb)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6EB4).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'What color is this?',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: currentColor['color'],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (currentColor['color'] as Color)
                                  .withValues(alpha: 0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      if (_isCorrect != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _isCorrect!
                              ? '✓ Correct!'
                              : '✗ It\'s ${currentColor['name']}',
                          style: TextStyle(
                            color: _isCorrect!
                                ? Colors.white
                                : const Color(0xFFFFE66D),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Options grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: _options.map((option) {
                final optionColor =
                    _allColors.firstWhere((c) => c['name'] == option)['color']
                        as Color;
                return GestureDetector(
                  onTap: _isCorrect == null ? () => _checkAnswer(option) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          optionColor,
                          optionColor.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: optionColor.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -8,
                          right: -8,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              option,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            // Clear & Try Again button (shown when wrong)
            if (_isCorrect == false)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: _clearAndRetry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Clear & Try Again',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  GestureDetector(
                    onTap: _currentColorIndex > 0 ? _goToPrevious : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: _currentColorIndex > 0
                            ? const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: _currentColorIndex > 0
                            ? null
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _currentColorIndex > 0
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: _currentColorIndex > 0
                                ? Colors.white
                                : Colors.white54,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Previous',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _currentColorIndex > 0
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Next button (only enabled when correct)
                  GestureDetector(
                    onTap:
                        _isCorrect == true &&
                            _currentColorIndex < _totalQuestions - 1
                        ? _goToNext
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            _isCorrect == true &&
                                _currentColorIndex < _totalQuestions - 1
                            ? const LinearGradient(
                                colors: [Color(0xFF56D97F), Color(0xFF4ECDC4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color:
                            _isCorrect == true &&
                                _currentColorIndex < _totalQuestions - 1
                            ? null
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow:
                            _isCorrect == true &&
                                _currentColorIndex < _totalQuestions - 1
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF56D97F,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  _isCorrect == true &&
                                      _currentColorIndex < _totalQuestions - 1
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            color:
                                _isCorrect == true &&
                                    _currentColorIndex < _totalQuestions - 1
                                ? Colors.white
                                : Colors.white54,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
