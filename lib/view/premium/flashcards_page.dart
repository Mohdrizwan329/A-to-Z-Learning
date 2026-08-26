import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;
  int _currentIndex = 0;
  String _selectedDeck = 'animals';

  final Map<String, List<Map<String, dynamic>>> flashcardDecks = {
    'animals': [
      {'front': '🦁', 'back': 'LION', 'hint': 'King of the Jungle'},
      {'front': '🐘', 'back': 'ELEPHANT', 'hint': 'Largest land animal'},
      {'front': '🐕', 'back': 'DOG', 'hint': 'Man\'s best friend'},
      {'front': '🐈', 'back': 'CAT', 'hint': 'Says meow'},
      {'front': '🐄', 'back': 'COW', 'hint': 'Gives us milk'},
      {'front': '🦊', 'back': 'FOX', 'hint': 'Clever animal'},
      {'front': '🐻', 'back': 'BEAR', 'hint': 'Loves honey'},
      {'front': '🐰', 'back': 'RABBIT', 'hint': 'Has long ears'},
      {'front': '🦋', 'back': 'BUTTERFLY', 'hint': 'Beautiful wings'},
      {'front': '🐢', 'back': 'TURTLE', 'hint': 'Carries its home'},
    ],
    'fruits': [
      {'front': '🍎', 'back': 'APPLE', 'hint': 'Keeps doctor away'},
      {'front': '🍌', 'back': 'BANANA', 'hint': 'Yellow and curved'},
      {'front': '🍇', 'back': 'GRAPES', 'hint': 'Grows in bunches'},
      {'front': '🍊', 'back': 'ORANGE', 'hint': 'Rich in Vitamin C'},
      {'front': '🍓', 'back': 'STRAWBERRY', 'hint': 'Red and sweet'},
      {'front': '🥭', 'back': 'MANGO', 'hint': 'King of fruits'},
      {
        'front': '🍉',
        'back': 'WATERMELON',
        'hint': 'Green outside, red inside',
      },
      {'front': '🍒', 'back': 'CHERRY', 'hint': 'Small and red'},
      {'front': '🍑', 'back': 'PEACH', 'hint': 'Soft and fuzzy'},
      {'front': '🥝', 'back': 'KIWI', 'hint': 'Brown outside, green inside'},
    ],
    'vegetables': [
      {'front': '🥕', 'back': 'CARROT', 'hint': 'Orange and crunchy'},
      {'front': '🥔', 'back': 'POTATO', 'hint': 'Grows underground'},
      {'front': '🍅', 'back': 'TOMATO', 'hint': 'Red and juicy'},
      {'front': '🥒', 'back': 'CUCUMBER', 'hint': 'Cool and green'},
      {'front': '🌽', 'back': 'CORN', 'hint': 'Yellow kernels'},
      {'front': '🥬', 'back': 'CABBAGE', 'hint': 'Green leafy vegetable'},
      {'front': '🧅', 'back': 'ONION', 'hint': 'Makes you cry'},
      {'front': '🧄', 'back': 'GARLIC', 'hint': 'Strong smell'},
      {'front': '🌶️', 'back': 'CHILI', 'hint': 'Very spicy'},
      {'front': '🥦', 'back': 'BROCCOLI', 'hint': 'Looks like a tree'},
    ],
    'shapes': [
      {'front': '⭐', 'back': 'STAR', 'hint': '5 points'},
      {'front': '❤️', 'back': 'HEART', 'hint': 'Symbol of love'},
      {'front': '🔵', 'back': 'CIRCLE', 'hint': 'Round shape'},
      {'front': '🔶', 'back': 'DIAMOND', 'hint': '4 equal sides tilted'},
      {'front': '🔺', 'back': 'TRIANGLE', 'hint': '3 sides'},
      {'front': '⬛', 'back': 'SQUARE', 'hint': '4 equal sides'},
      {'front': '🔷', 'back': 'RHOMBUS', 'hint': 'Tilted square'},
      {'front': '⬜', 'back': 'RECTANGLE', 'hint': '4 sides, 2 long 2 short'},
      {'front': '⬡', 'back': 'HEXAGON', 'hint': '6 sides'},
      {'front': '🔘', 'back': 'OVAL', 'hint': 'Stretched circle'},
    ],
    'bodyparts': [
      {'front': '👀', 'back': 'EYES', 'hint': 'We see with these'},
      {'front': '👂', 'back': 'EARS', 'hint': 'We hear with these'},
      {'front': '👃', 'back': 'NOSE', 'hint': 'We smell with this'},
      {'front': '👄', 'back': 'MOUTH', 'hint': 'We eat with this'},
      {'front': '✋', 'back': 'HAND', 'hint': 'Has 5 fingers'},
      {'front': '🦶', 'back': 'FOOT', 'hint': 'Has 5 toes'},
      {'front': '🦷', 'back': 'TEETH', 'hint': 'We chew with these'},
      {'front': '👅', 'back': 'TONGUE', 'hint': 'We taste with this'},
      {'front': '💪', 'back': 'ARM', 'hint': 'Has elbow'},
      {'front': '🦵', 'back': 'LEG', 'hint': 'Has knee'},
    ],
  };

  final Map<String, Color> deckColors = {
    'animals': Color(0xFFFF6B6B),
    'fruits': Color(0xFF4ECDC4),
    'vegetables': Color(0xFF56D97F),
    'shapes': Color(0xFFA78BFA),
    'bodyparts': Color(0xFFFFAA5A),
  };

  // Track known/unknown cards
  final Set<int> knownCards = {};

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  void _nextCard() {
    final deck = flashcardDecks[_selectedDeck]!;
    if (_currentIndex < deck.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
      _flipController.reset();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
      });
      _flipController.reset();
    }
  }

  void _markAsKnown() {
    knownCards.add(_currentIndex);
    _nextCard();
  }

  void _shuffleDeck() {
    setState(() {
      flashcardDecks[_selectedDeck]!.shuffle();
      _currentIndex = 0;
      _isFlipped = false;
      knownCards.clear();
    });
    _flipController.reset();
    Get.snackbar(
      'Shuffled!',
      'Cards have been shuffled.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deck = flashcardDecks[_selectedDeck]!;
    final currentCard = deck[_currentIndex];
    final color = deckColors[_selectedDeck]!;

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
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Flashcards",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white),
            onPressed: _shuffleDeck,
          ),
        ],
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
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          // Portrait-shaped content: in landscape the body is barely 300pt tall,
          // which is shorter than this column needs. Scroll when that happens and
          // stay exactly as before whenever there is room.
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Deck Selector
                  _buildDeckSelector(),
                  // Progress
                  _buildProgress(deck.length),
                  // Flashcard
                  SizedBox(
                    // A share of the viewport rather than `Expanded`:
                    // `Expanded` inside a scroll view needs an `IntrinsicHeight`
                    // above it, and a scrollable cannot report an intrinsic
                    // height - it throws.
                    height: max(200.h, constraints.maxHeight * 0.55),
                    child: GestureDetector(
                      onTap: _flipCard,
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          _nextCard();
                        } else if (details.primaryVelocity! > 0) {
                          _previousCard();
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _flipAnimation,
                        builder: (context, child) {
                          final angle = _flipAnimation.value * pi;
                          final showBack = angle > pi / 2;

                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: showBack
                                ? Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(pi),
                                    child: _buildCardBack(currentCard, color),
                                  )
                                : _buildCardFront(currentCard, color),
                          );
                        },
                      ),
                    ),
                  ),
                  // Action Buttons
                  _buildActionButtons(color),
                  // Navigation
                  _buildNavigation(deck.length),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeckSelector() {
    final decks = [
      {'id': 'animals', 'name': 'Animals', 'icon': '🦁'},
      {'id': 'fruits', 'name': 'Fruits', 'icon': '🍎'},
      {'id': 'vegetables', 'name': 'Veggies', 'icon': '🥕'},
      {'id': 'shapes', 'name': 'Shapes', 'icon': '⭐'},
      {'id': 'bodyparts', 'name': 'Body', 'icon': '👀'},
    ];

    return Container(
      height: 60.h,
      margin: EdgeInsets.all(16.r),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: decks.length,
        itemBuilder: (context, index) {
          final deck = decks[index];
          final isSelected = _selectedDeck == deck['id'];
          final color = deckColors[deck['id']]!;

          return GestureDetector(
            onTap: () {
              TtsService.to.speak(deck['name']!);
              setState(() {
                _selectedDeck = deck['id']!;
                _currentIndex = 0;
                _isFlipped = false;
                knownCards.clear();
              });
              _flipController.reset();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white24,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Text(deck['icon']!, style: const TextStyle(fontSize: 20)),
                  SizedBox(width: 6.w),
                  Text(
                    deck['name']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgress(int total) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Card ${_currentIndex + 1} of $total',
              style: const TextStyle(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Known: ${knownCards.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(Map<String, dynamic> card, Color color) {
    return Container(
      margin: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              card['front'],
              style: const TextStyle(fontSize: 120),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb_outline, color: color, size: 20.r),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    card['hint'],
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Flexible(
            child: Text(
              'Tap to reveal answer',
              style: TextStyle(color: Colors.grey.shade500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Map<String, dynamic> card, Color color) {
    return Container(
      margin: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(card['front'], style: const TextStyle(fontSize: 60)),
          SizedBox(height: 24.h),
          Text(
            card['back'],
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              card['hint'],
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Don't Know Button
          _buildActionButton(
            icon: Icons.close,
            label: "Don't Know",
            color: Colors.red,
            onTap: _nextCard,
          ),
          // Know Button
          _buildActionButton(
            icon: Icons.check,
            label: "Know It!",
            color: Colors.green,
            onTap: _markAsKnown,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30.r),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(int total) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: _currentIndex > 0 ? _previousCard : null,
              icon: Icon(
                Icons.arrow_back,
                color: _currentIndex > 0 ? Colors.white : Colors.white30,
              ),
              label: Text(
                'Previous',
                style: TextStyle(
                  color: _currentIndex > 0 ? Colors.white : Colors.white30,
                ),
              ),
            ),
            // Card indicators
            Row(
              children: List.generate(total > 10 ? 10 : total, (index) {
                final actualIndex = total > 10
                    ? (_currentIndex ~/ 10) * 10 + index
                    : index;
                if (actualIndex >= total) return const SizedBox.shrink();

                return Container(
                  width: 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: actualIndex == _currentIndex
                        ? Colors.white
                        : (knownCards.contains(actualIndex)
                              ? Colors.green
                              : Colors.white30),
                  ),
                );
              }),
            ),
            TextButton.icon(
              onPressed: _currentIndex < total - 1 ? _nextCard : null,
              icon: Text(
                'Next',
                style: TextStyle(
                  color: _currentIndex < total - 1
                      ? Colors.white
                      : Colors.white30,
                ),
              ),
              label: Icon(
                Icons.arrow_forward,
                color: _currentIndex < total - 1
                    ? Colors.white
                    : Colors.white30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
