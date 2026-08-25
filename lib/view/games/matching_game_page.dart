import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class MatchingGamePage extends StatefulWidget {
  const MatchingGamePage({super.key});

  @override
  State<MatchingGamePage> createState() => _MatchingGamePageState();
}

class _MatchingGamePageState extends State<MatchingGamePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  // Tab 1 - Farm Animals (items 1-10)
  final List<Map<String, String>> _leftItems1 = [
    {'id': '1', 'emoji': '🐶', 'label': 'Dog'},
    {'id': '2', 'emoji': '🐱', 'label': 'Cat'},
    {'id': '3', 'emoji': '🐮', 'label': 'Cow'},
    {'id': '4', 'emoji': '🐷', 'label': 'Pig'},
    {'id': '5', 'emoji': '🦁', 'label': 'Lion'},
    {'id': '6', 'emoji': '🐸', 'label': 'Frog'},
    {'id': '7', 'emoji': '🐔', 'label': 'Chicken'},
    {'id': '8', 'emoji': '🦆', 'label': 'Duck'},
    {'id': '9', 'emoji': '🐑', 'label': 'Sheep'},
    {'id': '10', 'emoji': '🐴', 'label': 'Horse'},
  ];

  final List<Map<String, String>> _rightItems1 = [
    {'id': '1', 'sound': 'Bark', 'emoji': '🗣️'},
    {'id': '2', 'sound': 'Meow', 'emoji': '🗣️'},
    {'id': '3', 'sound': 'Moo', 'emoji': '🗣️'},
    {'id': '4', 'sound': 'Oink', 'emoji': '🗣️'},
    {'id': '5', 'sound': 'Roar', 'emoji': '🗣️'},
    {'id': '6', 'sound': 'Ribbit', 'emoji': '🗣️'},
    {'id': '7', 'sound': 'Cluck', 'emoji': '🗣️'},
    {'id': '8', 'sound': 'Quack', 'emoji': '🗣️'},
    {'id': '9', 'sound': 'Baa', 'emoji': '🗣️'},
    {'id': '10', 'sound': 'Neigh', 'emoji': '🗣️'},
  ];

  // Tab 2 - Wild Animals (items 11-20)
  final List<Map<String, String>> _leftItems2 = [
    {'id': '11', 'emoji': '🦉', 'label': 'Owl'},
    {'id': '12', 'emoji': '🐍', 'label': 'Snake'},
    {'id': '13', 'emoji': '🐵', 'label': 'Monkey'},
    {'id': '14', 'emoji': '🐺', 'label': 'Wolf'},
    {'id': '15', 'emoji': '🐝', 'label': 'Bee'},
    {'id': '16', 'emoji': '🐘', 'label': 'Elephant'},
    {'id': '17', 'emoji': '🦃', 'label': 'Turkey'},
    {'id': '18', 'emoji': '🐐', 'label': 'Goat'},
    {'id': '19', 'emoji': '🦅', 'label': 'Eagle'},
    {'id': '20', 'emoji': '🐻', 'label': 'Bear'},
  ];

  final List<Map<String, String>> _rightItems2 = [
    {'id': '11', 'sound': 'Hoot', 'emoji': '🗣️'},
    {'id': '12', 'sound': 'Hiss', 'emoji': '🗣️'},
    {'id': '13', 'sound': 'Ooh-ooh', 'emoji': '🗣️'},
    {'id': '14', 'sound': 'Howl', 'emoji': '🗣️'},
    {'id': '15', 'sound': 'Buzz', 'emoji': '🗣️'},
    {'id': '16', 'sound': 'Trumpet', 'emoji': '🗣️'},
    {'id': '17', 'sound': 'Gobble', 'emoji': '🗣️'},
    {'id': '18', 'sound': 'Bleat', 'emoji': '🗣️'},
    {'id': '19', 'sound': 'Screech', 'emoji': '🗣️'},
    {'id': '20', 'sound': 'Growl', 'emoji': '🗣️'},
  ];

  String? _selectedLeft;
  String? _selectedRight;
  final List<String> _matchedIds1 = [];
  final List<String> _matchedIds2 = [];
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _rightItems1.shuffle();
    _rightItems2.shuffle();

    // Initialize home screen style animations
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  // Build floating bubbles like home screen
  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top =
              startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  List<String> get _currentMatchedIds =>
      _tabController.index == 0 ? _matchedIds1 : _matchedIds2;
  List<Map<String, String>> get _currentLeftItems =>
      _tabController.index == 0 ? _leftItems1 : _leftItems2;

  void _onLeftTap(String id) {
    if (_currentMatchedIds.contains(id)) return;
    final leftItem = _currentLeftItems.firstWhere((item) => item['id'] == id, orElse: () => {});
    if (leftItem.containsKey('label')) TtsService.to.speak(leftItem['label']!);
    setState(() {
      _selectedLeft = id;
      _checkMatch();
    });
  }

  void _onRightTap(String id) {
    if (_currentMatchedIds.contains(id)) return;
    setState(() {
      _selectedRight = id;
      _checkMatch();
    });
  }

  void _checkMatch() {
    if (_selectedLeft != null && _selectedRight != null) {
      if (_selectedLeft == _selectedRight) {
        // Correct match!
        setState(() {
          _currentMatchedIds.add(_selectedLeft!);
          _score += 20;
          _selectedLeft = null;
          _selectedRight = null;
        });

        if (_currentMatchedIds.length == _currentLeftItems.length) {
          _showWinDialog();
        }
      } else {
        // Wrong match - reset after delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _selectedLeft = null;
              _selectedRight = null;
            });
          }
        });
      }
    }
  }

  void _showWinDialog() {
    final tabName = _tabController.index == 0 ? 'Farm Animals' : 'Wild Animals';
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🎉", style: TextStyle(fontSize: 70)),
            const SizedBox(height: 16),
            Text(
              '$tabName Complete!',
              style: GoogleFonts.baloo2(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF56D97F),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    'Score: $_score points',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Exit',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _resetCurrentTab();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF56D97F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Play Again',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _resetCurrentTab() {
    setState(() {
      if (_tabController.index == 0) {
        _matchedIds1.clear();
        _rightItems1.shuffle();
      } else {
        _matchedIds2.clear();
        _rightItems2.shuffle();
      }
      _selectedLeft = null;
      _selectedRight = null;
      _score = 0;
    });
  }

  void _resetAllGame() {
    setState(() {
      _matchedIds1.clear();
      _matchedIds2.clear();
      _selectedLeft = null;
      _selectedRight = null;
      _score = 0;
      _rightItems1.shuffle();
      _rightItems2.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            // Vibrant kid-friendly gradient - Coral to Pink to Orange (same as Home)
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
        title: Text(
          'Match Animals',
          style: GoogleFonts.baloo2(
            fontSize: 22,
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
            onPressed: _resetAllGame,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _selectedLeft = null;
              _selectedRight = null;
            });
          },
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: 'Farm Animals'),
            Tab(text: 'Wild Animals'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Kid-friendly rainbow gradient background (same as Home)
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
            // Floating bubbles background
            ..._buildFloatingBubbles(),
            SafeArea(
              child: Column(
                children: [
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 4),
                                Text(
                                  'Progress: $_score',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_currentMatchedIds.length}/${_currentLeftItems.length} matched',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _currentLeftItems.isEmpty
                                ? 0
                                : _currentMatchedIds.length /
                                      _currentLeftItems.length,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF56D97F),
                            ),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Instructions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Match animals with their sounds!',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // TabBarView for matching content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildMatchingContent(
                          _leftItems1,
                          _rightItems1,
                          _matchedIds1,
                        ),
                        _buildMatchingContent(
                          _leftItems2,
                          _rightItems2,
                          _matchedIds2,
                        ),
                      ],
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

  Widget _buildMatchingContent(
    List<Map<String, String>> leftItems,
    List<Map<String, String>> rightItems,
    List<String> matchedIds,
  ) {
    // Home screen style gradients
    final leftGradients = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
      [const Color(0xFF56D97F), const Color(0xFF11998E)],
      [const Color(0xFFFF6EB4), const Color(0xFFFF9A9E)],
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF45B7D1), const Color(0xFF2C7DA0)],
      [const Color(0xFFFFAA5A), const Color(0xFFFF8E53)],
      [const Color(0xFF20BF55), const Color(0xFF01BAEF)],
    ];

    final rightGradients = [
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFFFAA5A), const Color(0xFFFF8E53)],
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF20BF55), const Color(0xFF01BAEF)],
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
      [const Color(0xFF56D97F), const Color(0xFF11998E)],
      [const Color(0xFF45B7D1), const Color(0xFF2C7DA0)],
      [const Color(0xFFFF6EB4), const Color(0xFFFF9A9E)],
    ];

    return Row(
      children: [
        // Left column - Animals
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: leftItems.length,
            itemBuilder: (context, index) {
              final item = leftItems[index];
              final isMatched = matchedIds.contains(item['id']);
              final isSelected = _selectedLeft == item['id'];
              final gradient = leftGradients[index % leftGradients.length];

              return AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final offset = index.isEven
                      ? _floatAnimation.value * 0.5
                      : -_floatAnimation.value * 0.5;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () => _onLeftTap(item['id']!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isMatched
                          ? const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFFFE66D), width: 3)
                          : null,
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
                        // Decorative circle (Home screen style)
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Circular emoji container (Home screen style)
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    item['emoji']!,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Label
                              Text(
                                item['label']!,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Checkmark if matched
                              if (isMatched)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                            ],
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

        // Connection line visual
        SizedBox(
          width: 24,
          child: Center(
            child: Container(
              width: 3,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.4),
                    Colors.white.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),

        // Right column - Sounds
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: rightItems.length,
            itemBuilder: (context, index) {
              final item = rightItems[index];
              final isMatched = matchedIds.contains(item['id']);
              final isSelected = _selectedRight == item['id'];
              final gradient = rightGradients[index % rightGradients.length];

              return AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  // Opposite direction for right column
                  final offset = index.isEven
                      ? -_floatAnimation.value * 0.5
                      : _floatAnimation.value * 0.5;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () => _onRightTap(item['id']!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isMatched
                          ? const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFFFE66D), width: 3)
                          : null,
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
                        // Decorative circle (Home screen style)
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Circular emoji container (Home screen style)
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '🗣️',
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Sound label
                              Text(
                                item['sound']!,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Checkmark if matched
                              if (isMatched)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                            ],
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
    );
  }
}
