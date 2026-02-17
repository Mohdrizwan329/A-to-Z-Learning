import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'dart:async';
import 'dart:math';

class FocusImprovementPage extends StatefulWidget {
  const FocusImprovementPage({super.key});

  @override
  State<FocusImprovementPage> createState() => _FocusImprovementPageState();
}

class _FocusImprovementPageState extends State<FocusImprovementPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
      'name': 'Breathing Focus',
      'emoji': '🧘',
      'color': Color(0xFFA78BFA),
      'description': 'Follow the breathing circle',
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

  // Breathing game
  bool isBreathing = false;
  String breathPhase = 'Ready';

  // Spot the Star game
  List<String> starGrid = [];
  int starIndex = -1;
  bool starFound = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
        _startBreathing();
        break;
      case 4:
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

  void _startBreathing() {
    isBreathing = true;
    _pulseController.repeat(reverse: true);
    _runBreathingCycle();
  }

  void _runBreathingCycle() async {
    if (!isBreathing) return;

    setState(() => breathPhase = 'Breathe In');
    _speakText('Breathe in');
    await Future.delayed(const Duration(seconds: 4));

    if (!isBreathing) return;
    setState(() => breathPhase = 'Hold');
    _speakText('Hold');
    await Future.delayed(const Duration(seconds: 2));

    if (!isBreathing) return;
    setState(() => breathPhase = 'Breathe Out');
    _speakText('Breathe out');
    await Future.delayed(const Duration(seconds: 4));

    if (isBreathing) _runBreathingCycle();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Excellent!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('Score: $score', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isPlaying = false);
            },
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame(currentGame);
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _stopGame() {
    setState(() {
      isPlaying = false;
      isBreathing = false;
    });
    _pulseController.stop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (isPlaying) {
              _stopGame();
            } else {
              Get.back();
            }
          },
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
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("⭐ $score", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        child: isPlaying ? _buildGameScreen() : _buildExerciseList(),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildExerciseList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🎯", style: TextStyle(fontSize: 60)),
          const SizedBox(height: 8),
          const Text(
            "Focus Your Mind!",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Train your brain with these exercises",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Exercise cards
          ...focusExercises.asMap().entries.map((entry) {
            final index = entry.key;
            final exercise = entry.value;

            return GestureDetector(
              onTap: () => _startGame(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [exercise['color'], exercise['color'].withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: exercise['color'].withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(exercise['emoji'], style: const TextStyle(fontSize: 35))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['name'],
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            exercise['description'],
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Tips section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
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
        return _buildBreathingGame();
      case 4:
        return _buildSpotTheStarGame();
      default:
        return const SizedBox();
    }
  }

  Widget _buildFindTheObjectGame() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("🔍 Find the Different One!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _checkFindTheObject(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
                    ],
                  ),
                  child: Center(
                    child: Text(gridItems[index], style: const TextStyle(fontSize: 45)),
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
        _buildBackButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildColorFocusGame() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("🎨 Tap All Matching Colors!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: targetColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: const Center(child: Text("Find\nThis", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _checkColorTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorGrid[index],
                    borderRadius: BorderRadius.circular(12),
                    border: colorTapped[index] ? Border.all(color: Colors.white, width: 3) : null,
                  ),
                  child: colorTapped[index]
                      ? const Center(child: Icon(Icons.check, color: Colors.white, size: 30))
                      : null,
                ),
              );
            },
          ),
        ),
        const Spacer(),
        _buildBackButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNumberSequenceGame() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("🔢 Tap Numbers in Order!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text("Find: $nextNumber", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final isTapped = numberTapped[index];
              return GestureDetector(
                onTap: isTapped ? null : () => _checkNumberTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isTapped ? Color(0xFF56D97F) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${numberGrid[index]}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isTapped ? Colors.white : Color(0xFF667EEA),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
        _buildBackButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBreathingGame() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(breathPhase, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFA78BFA).withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text("🧘", style: TextStyle(fontSize: 60)),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        Text(
          breathPhase == 'Breathe In' ? 'Slowly breathe in...' :
          breathPhase == 'Hold' ? 'Hold your breath...' :
          breathPhase == 'Breathe Out' ? 'Slowly breathe out...' : 'Get ready...',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16),
        ),
        const SizedBox(height: 60),
        ElevatedButton.icon(
          onPressed: _stopGame,
          icon: const Icon(Icons.stop),
          label: const Text("Stop Exercise"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6B6B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }

  Widget _buildSpotTheStarGame() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("⭐ Spot the Star!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          starFound ? "Found it! 🎉" : "Find the ⭐ among the shapes",
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              final isStarSpot = index == starIndex && starFound;
              return GestureDetector(
                onTap: starFound ? null : () => _checkStarTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isStarSpot ? Color(0xFFFFD700) : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: isStarSpot ? Border.all(color: Colors.white, width: 3) : null,
                  ),
                  child: Center(
                    child: Text(starGrid[index], style: const TextStyle(fontSize: 28)),
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
        _buildBackButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBackButton() {
    return ElevatedButton.icon(
      onPressed: _stopGame,
      icon: const Icon(Icons.arrow_back),
      label: const Text("Back to Exercises"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
