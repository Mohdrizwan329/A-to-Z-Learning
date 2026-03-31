import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'package:jiyan_learning/services/tts_service.dart';

class FocusImprovementPage extends StatefulWidget {
  const FocusImprovementPage({super.key});

  @override
  State<FocusImprovementPage> createState() => _FocusImprovementPageState();
}

class _FocusImprovementPageState extends State<FocusImprovementPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();

  int currentGame = 0;
  int score = 0;
  bool isPlaying = false;

  // Focus exercises
  final List<Map<String, dynamic>> focusExercises = [
    {
      'name': 'Find the Object',
      'emoji': '🔍',
      'color': Color(0xFF4ECDC4),
      'description': 'Find the different object quickly!',
    },
    {
      'name': 'Color Focus',
      'emoji': '🎨',
      'color': Color(0xFFFF6B6B),
      'description': 'Tap only the matching colors!',
    },
    {
      'name': 'Number Sequence',
      'emoji': '🔢',
      'color': Color(0xFF667EEA),
      'description': 'Tap numbers in order 1, 2, 3...',
    },
    {
      'name': 'Spot the Star',
      'emoji': '⭐',
      'color': Color(0xFFFFAA5A),
      'description': 'Find the hidden star!',
    },
  ];

  // Find the Object game
  List<String> gridItems = [];
  String targetEmoji = '';
  int oddOneIndex = -1;

  // Color Focus game
  Color targetColor = Colors.red;
  List<Color> colorGrid = [];
  List<bool> colorTapped = [];
  int correctColorCount = 0;

  // Number Sequence game
  List<int> numberGrid = [];
  int nextNumber = 1;
  List<bool> numberTapped = [];

  // Spot the Star game
  List<String> starGrid = [];
  int starIndex = -1;
  bool starFound = false;

  late AnimationController _cardAnimController;
  late List<Animation<double>> _cardAnimations;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();
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
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _cardAnimations = List.generate(
      focusExercises.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardAnimController,
          curve: Interval(index * 0.12, (index * 0.12 + 0.4).clamp(0.0, 1.0), curve: Curves.easeOutBack),
        ),
      ),
    );
    _cardAnimController.forward();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _startGame(int gameIndex) {
    setState(() {
      currentGame = gameIndex;
      isPlaying = true;
    });

    switch (gameIndex) {
      case 0:
        _setupFindTheObject();
        break;
      case 1:
        _setupColorFocus();
        break;
      case 2:
        _setupNumberSequence();
        break;
      case 3:
        _setupSpotTheStar();
        break;
    }

    _speakText(focusExercises[gameIndex]['description']);
  }

  void _setupFindTheObject() {
    final emojis = ['🍎', '🍊', '🍋', '🍇', '🍓', '🥝', '🍑', '🥭'];
    final random = Random();
    targetEmoji = emojis[random.nextInt(emojis.length)];
    String oddEmoji = emojis.firstWhere((e) => e != targetEmoji);

    gridItems = List.generate(9, (_) => targetEmoji);
    oddOneIndex = random.nextInt(9);
    gridItems[oddOneIndex] = oddEmoji;
  }

  void _setupColorFocus() {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.orange];
    final random = Random();
    targetColor = colors[random.nextInt(colors.length)];

    colorGrid = List.generate(12, (_) => colors[random.nextInt(colors.length)]);
    colorTapped = List.generate(12, (_) => false);
    correctColorCount = colorGrid.where((c) => c == targetColor).length;
  }

  void _setupNumberSequence() {
    numberGrid = List.generate(9, (i) => i + 1);
    numberGrid.shuffle();
    nextNumber = 1;
    numberTapped = List.generate(9, (_) => false);
  }

  void _setupSpotTheStar() {
    final distractors = ['🌙', '☀️', '🌟', '💫', '✨'];
    final random = Random();

    starGrid = List.generate(16, (_) => distractors[random.nextInt(distractors.length)]);
    starIndex = random.nextInt(16);
    starGrid[starIndex] = '⭐';
    starFound = false;
  }

  void _checkFindTheObject(int index) {
    if (index == oddOneIndex) {
      setState(() => score += 10);
      _speakText('Great job! You found it!');
      _showSuccessDialog('You found the different one!');
    } else {
      _speakText('Try again!');
    }
  }

  void _checkColorTap(int index) {
    if (colorGrid[index] == targetColor && !colorTapped[index]) {
      setState(() {
        colorTapped[index] = true;
        score += 5;
      });

      int tappedCorrect = colorTapped.asMap().entries.where((e) => e.value && colorGrid[e.key] == targetColor).length;
      if (tappedCorrect == correctColorCount) {
        _speakText('Amazing! You found all colors!');
        _showSuccessDialog('You found all matching colors!');
      }
    }
  }

  void _checkNumberTap(int index) {
    if (numberGrid[index] == nextNumber) {
      setState(() {
        numberTapped[index] = true;
        nextNumber++;
        score += 5;
      });

      if (nextNumber > 9) {
        _speakText('Perfect sequence!');
        _showSuccessDialog('You completed the sequence!');
      }
    } else {
      _speakText('Find number $nextNumber');
    }
  }

  void _checkStarTap(int index) {
    if (index == starIndex) {
      setState(() {
        starFound = true;
        score += 15;
      });
      _speakText('You found the star!');
      _showSuccessDialog('Great focus! You found the star!');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Text('🎉', style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 12),
              const Text('Excellent!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15)),
              const SizedBox(height: 8),
              Text('Score: $score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => isPlaying = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text('Back', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _startGame(currentGame);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text('Play Again', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _stopGame() {
    setState(() {
      isPlaying = false;
    });
    _cardAnimController.reset();
    _cardAnimController.forward();
  }

  @override
  void dispose() {
    _cardAnimController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (isPlaying) {
                _stopGame();
              } else {
                Get.back();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
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
        title: const Text("Focus Training", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
            onPressed: () {
              ProgressService.to.resetProgress(ProgressService.kFocusTraining);
            },
          ),
        ],
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
        child: Stack(
          children: [
            ..._buildFloatingBubbles(),
            Positioned.fill(
              child: isPlaying ? _buildGameScreen() : _buildExerciseList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
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

  final List<List<Color>> _exerciseGradients = const [
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFFA78BFA), Color(0xFF7C3AED)],
    [Color(0xFFFFAA5A), Color(0xFFFF6B6B)],
  ];

  Widget _buildExerciseList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress bar
          Obx(() {
            final progress = ProgressService.to
                    .getProgressPercentage(ProgressService.kFocusTraining) /
                100;
            final progressString = ProgressService.to
                .getProgressString(ProgressService.kFocusTraining);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
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
                        '$progressString completed',
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
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),

          // Exercise cards with animation - 2 column grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: focusExercises.length,
            itemBuilder: (context, index) {
              final exercise = focusExercises[index];
              final animIndex = index.clamp(0, _cardAnimations.length - 1);
              final gradient = _exerciseGradients[index % _exerciseGradients.length];

              return AnimatedBuilder(
                animation: _cardAnimations[animIndex],
                builder: (context, child) {
                  final value = _cardAnimations[animIndex].value;
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    final offset = (index % 2 == 0)
                        ? _floatAnimation.value * 0.5
                        : -_floatAnimation.value * 0.5;
                    return Transform.translate(offset: Offset(0, offset), child: child);
                  },
                  child: GestureDetector(
                    onTap: () {
                      TtsService.to.speak(focusExercises[index]['name']);
                      _startGame(index);
                      ProgressService.to.markItemCompleted(
                        ProgressService.kFocusTraining,
                        index,
                      );
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
                          Positioned(
                            bottom: -10,
                            left: -10,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Text(exercise['emoji'], style: const TextStyle(fontSize: 30))),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  exercise['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(color: Color(0x40000000), offset: Offset(1, 1), blurRadius: 3)],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exercise['description'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Tips section
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: const [
                  Text("💡 Focus Tips", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text("• Take deep breaths before starting", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("• Find a quiet place to practice", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("• Try a little bit every day", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    switch (currentGame) {
      case 0:
        return _buildFindTheObjectGame();
      case 1:
        return _buildColorFocusGame();
      case 2:
        return _buildNumberSequenceGame();
      case 3:
        return _buildSpotTheStarGame();
      default:
        return const SizedBox();
    }
  }

  final List<List<Color>> _gameCardGradients = const [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFFA78BFA), Color(0xFF7C3AED)],
    [Color(0xFFFFAA5A), Color(0xFFFF6B6B)],
    [Color(0xFF56D97F), Color(0xFF11998E)],
    [Color(0xFFEC4899), Color(0xFFF472B6)],
    [Color(0xFF3B82F6), Color(0xFF60A5FA)],
    [Color(0xFFF59E0B), Color(0xFFEF4444)],
  ];

  Widget _buildGameTitleCard({required String emoji, required String title, String? subtitle}) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 0.3),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({required Widget child, required List<Color> gradient, VoidCallback? onTap, int index = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final offset = (index % 2 == 0) ? _floatAnimation.value * 0.5 : -_floatAnimation.value * 0.5;
          return Transform.translate(offset: Offset(0, offset), child: child);
        },
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: gradient[0].withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -10,
                  right: -10,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  left: -8,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)),
                  ),
                ),
                Center(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFindTheObjectGame() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildGameTitleCard(emoji: '🔍', title: '🔍 Find the Different One!'),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final gradient = _gameCardGradients[index % _gameCardGradients.length];
                return _buildGameCard(
                  index: index,
                  gradient: gradient,
                  onTap: () => _checkFindTheObject(index),
                  child: Text(gridItems[index], style: const TextStyle(fontSize: 45)),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildColorFocusGame() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildGameTitleCard(emoji: '🎨', title: '🎨 Tap All Matching Colors!'),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value * 0.4),
                child: child,
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: targetColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(color: targetColor.withValues(alpha: 0.5), blurRadius: 12, spreadRadius: 2),
                ],
              ),
              child: const Center(child: Text("Find\nThis", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 80)),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      final offset = (index % 2 == 0) ? _floatAnimation.value * 0.5 : -_floatAnimation.value * 0.5;
                      return Transform.translate(offset: Offset(0, offset), child: child);
                    },
                    child: GestureDetector(
                      onTap: () => _checkColorTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorGrid[index],
                          borderRadius: BorderRadius.circular(16),
                          border: colorTapped[index] ? Border.all(color: Colors.white, width: 3) : null,
                          boxShadow: [
                            BoxShadow(color: colorGrid[index].withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: colorTapped[index]
                            ? const Center(child: Icon(Icons.check, color: Colors.white, size: 30))
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildNumberSequenceGame() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildGameTitleCard(emoji: '🔢', title: '🔢 Tap Numbers in Order!'),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value * 0.3),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF667EEA).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Text("Find: $nextNumber", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final isTapped = numberTapped[index];
                final gradient = isTapped
                    ? const [Color(0xFF56D97F), Color(0xFF11998E)]
                    : _gameCardGradients[index % _gameCardGradients.length];
                return _buildGameCard(
                  index: index,
                  gradient: gradient,
                  onTap: isTapped ? null : () => _checkNumberTap(index),
                  child: Text(
                    '${numberGrid[index]}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }


  Widget _buildSpotTheStarGame() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildGameTitleCard(
            emoji: '⭐',
            title: '⭐ Spot the Star!',
            subtitle: starFound ? "Found it! 🎉" : "Find the ⭐ among the shapes",
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                final isStarSpot = index == starIndex && starFound;
                final gradient = isStarSpot
                    ? const [Color(0xFFFFD700), Color(0xFFFFA500)]
                    : _gameCardGradients[index % _gameCardGradients.length];
                return _buildGameCard(
                  index: index,
                  gradient: gradient,
                  onTap: starFound ? null : () => _checkStarTap(index),
                  child: Text(starGrid[index], style: const TextStyle(fontSize: 28)),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
