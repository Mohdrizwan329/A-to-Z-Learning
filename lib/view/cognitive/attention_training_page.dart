import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'package:jiyan_learning/services/tts_service.dart';

class AttentionTrainingPage extends StatefulWidget {
  const AttentionTrainingPage({super.key});

  @override
  State<AttentionTrainingPage> createState() => _AttentionTrainingPageState();
}

class _AttentionTrainingPageState extends State<AttentionTrainingPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _bounceController;

  int currentExercise = -1;
  int score = 0;
  int level = 1;
  bool isPlaying = false;

  // Exercise types
  final List<Map<String, dynamic>> exercises = [
    {
      'name': 'Follow the Ball',
      'emoji': '🔴',
      'color': Color(0xFFFF6B6B),
      'description': 'Watch the ball and tap where it stops!',
    },
    {
      'name': 'Listen & Count',
      'emoji': '👂',
      'color': Color(0xFF4ECDC4),
      'description': 'Count how many times you hear the sound!',
    },
    {
      'name': 'Quick Tap',
      'emoji': '👆',
      'color': Color(0xFF667EEA),
      'description': 'Tap the target as fast as you can!',
    },
    {
      'name': 'Remember Order',
      'emoji': '🧠',
      'color': Color(0xFFA78BFA),
      'description': 'Remember the order of colors!',
    },
    {
      'name': 'Sustained Focus',
      'emoji': '👁️',
      'color': Color(0xFFFFAA5A),
      'description': 'Keep watching, tap when you see the star!',
    },
  ];

  // Follow the Ball game
  List<int> ballPath = [];
  int currentBallPosition = 0;
  bool showingPath = false;
  bool waitingForAnswer = false;
  int correctPosition = -1;

  // Listen & Count game
  int soundCount = 0;
  int correctSoundCount = 0;
  bool countingPhase = false;

  // Quick Tap game
  int targetPosition = -1;
  int quickTapScore = 0;
  int quickTapRounds = 0;
  Timer? quickTapTimer;

  // Remember Order game
  List<Color> colorSequence = [];
  List<Color> userSequence = [];
  int showingIndex = -1;
  bool showingSequence = false;
  bool inputPhase = false;
  final List<Color> availableColors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];

  // Sustained Focus game
  List<String> streamItems = [];
  int currentStreamIndex = 0;
  int starCount = 0;
  int missedStars = 0;
  bool streamRunning = false;
  Timer? streamTimer;

  late AnimationController _cardAnimController;
  late List<Animation<double>> _cardAnimations;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
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
      exercises.length,
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

  void _startExercise(int index) {
    setState(() {
      currentExercise = index;
      isPlaying = true;
    });

    _speakText(exercises[index]['description']);

    switch (index) {
      case 0:
        _setupFollowTheBall();
        break;
      case 1:
        _setupListenAndCount();
        break;
      case 2:
        _setupQuickTap();
        break;
      case 3:
        _setupRememberOrder();
        break;
      case 4:
        _setupSustainedFocus();
        break;
    }
  }

  // Follow the Ball
  void _setupFollowTheBall() async {
    final random = Random();
    int pathLength = 3 + level;
    ballPath = List.generate(pathLength, (_) => random.nextInt(9));
    correctPosition = ballPath.last;

    setState(() {
      showingPath = true;
      currentBallPosition = 0;
    });

    for (int i = 0; i < ballPath.length; i++) {
      await Future.delayed(Duration(milliseconds: 600 - (level * 50).clamp(0, 300)));
      if (!isPlaying) return;
      if (!mounted) return;
      setState(() => currentBallPosition = ballPath[i]);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      showingPath = false;
      waitingForAnswer = true;
    });
  }

  void _checkBallAnswer(int position) {
    if (position == correctPosition) {
      setState(() {
        score += 10;
        level = (level < 5) ? level + 1 : level;
      });
      _speakText('Correct! Great attention!');
      _showSuccess('You tracked the ball perfectly!');
    } else {
      _speakText('Not quite. Try again!');
      setState(() => waitingForAnswer = false);
      _setupFollowTheBall();
    }
  }

  // Listen & Count
  void _setupListenAndCount() async {
    final random = Random();
    correctSoundCount = 2 + random.nextInt(4 + level);
    soundCount = 0;

    setState(() => countingPhase = true);
    _speakText('Listen and count the beeps!');

    await Future.delayed(const Duration(seconds: 1));

    for (int i = 0; i < correctSoundCount; i++) {
      if (!isPlaying) return;
      _speakText('beep');
      await Future.delayed(Duration(milliseconds: 800 - (level * 50).clamp(0, 400)));
    }

    await Future.delayed(const Duration(milliseconds: 500));
    _speakText('How many beeps did you hear?');
  }

  void _checkSoundCount(int count) {
    if (count == correctSoundCount) {
      setState(() {
        score += 15;
        level = (level < 5) ? level + 1 : level;
      });
      _speakText('Correct! You counted $count beeps!');
      _showSuccess('Perfect counting!');
    } else {
      _speakText('It was $correctSoundCount beeps. Try again!');
      _setupListenAndCount();
    }
  }

  // Quick Tap
  void _setupQuickTap() {
    quickTapScore = 0;
    quickTapRounds = 0;
    _showNextTarget();
  }

  void _showNextTarget() {
    if (quickTapRounds >= 10) {
      _showSuccess('Quick Tap Complete! Score: $quickTapScore/10');
      return;
    }

    final random = Random();
    setState(() {
      targetPosition = random.nextInt(9);
    });

    quickTapTimer?.cancel();
    quickTapTimer = Timer(Duration(milliseconds: 2000 - (level * 200).clamp(0, 1000)), () {
      if (!mounted) return;
      if (isPlaying) {
        setState(() {
          quickTapRounds++;
          targetPosition = -1;
        });
        Future.delayed(const Duration(milliseconds: 300), _showNextTarget);
      }
    });
  }

  void _tapTarget(int position) {
    if (position == targetPosition) {
      quickTapTimer?.cancel();
      setState(() {
        quickTapScore++;
        quickTapRounds++;
        score += 5;
        targetPosition = -1;
      });
      Future.delayed(const Duration(milliseconds: 300), _showNextTarget);
    }
  }

  // Remember Order
  void _setupRememberOrder() async {
    final random = Random();
    int sequenceLength = 2 + level;
    colorSequence = List.generate(sequenceLength, (_) => availableColors[random.nextInt(4)]);
    userSequence = [];

    setState(() {
      showingSequence = true;
      inputPhase = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < colorSequence.length; i++) {
      if (!isPlaying) return;
      if (!mounted) return;
      setState(() => showingIndex = i);
      await Future.delayed(Duration(milliseconds: 800 - (level * 50).clamp(0, 400)));
      if (!mounted) return;
      setState(() => showingIndex = -1);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (!mounted) return;
    setState(() {
      showingSequence = false;
      inputPhase = true;
    });
    _speakText('Now tap the colors in order!');
  }

  void _tapColor(Color color) {
    userSequence.add(color);

    int index = userSequence.length - 1;
    if (userSequence[index] != colorSequence[index]) {
      _speakText('Wrong order. Try again!');
      _setupRememberOrder();
      return;
    }

    if (userSequence.length == colorSequence.length) {
      setState(() {
        score += 20;
        level = (level < 5) ? level + 1 : level;
      });
      _speakText('Perfect memory!');
      _showSuccess('You remembered all ${colorSequence.length} colors!');
    }
  }

  // Sustained Focus
  void _setupSustainedFocus() {
    final random = Random();
    streamItems = List.generate(30, (i) {
      if (random.nextInt(5) == 0) return '⭐';
      return ['🔵', '🟢', '🟡', '🟠'][random.nextInt(4)];
    });
    currentStreamIndex = 0;
    starCount = 0;
    missedStars = 0;
    streamRunning = true;

    _speakText('Tap when you see the star!');

    streamTimer = Timer.periodic(Duration(milliseconds: 1200 - (level * 100).clamp(0, 600)), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (!isPlaying || currentStreamIndex >= streamItems.length) {
        timer.cancel();
        if (isPlaying) {
          int totalStars = streamItems.where((e) => e == '⭐').length;
          _showSuccess('You caught $starCount out of $totalStars stars!');
        }
        return;
      }

      if (streamItems[currentStreamIndex] == '⭐') {
        missedStars++;
      }

      setState(() => currentStreamIndex++);
    });
  }

  void _tapStream() {
    if (currentStreamIndex > 0 && streamItems[currentStreamIndex - 1] == '⭐') {
      setState(() {
        starCount++;
        missedStars--;
        score += 10;
      });
    }
  }

  void _showSuccess(String message) {
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
              const Text('Great Job!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
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
                        _stopExercise();
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
                        _startExercise(currentExercise);
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

  void _stopExercise() {
    quickTapTimer?.cancel();
    streamTimer?.cancel();
    setState(() {
      currentExercise = -1;
      isPlaying = false;
      showingPath = false;
      waitingForAnswer = false;
      countingPhase = false;
      showingSequence = false;
      inputPhase = false;
      streamRunning = false;
    });
    _cardAnimController.reset();
    _cardAnimController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _cardAnimController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    quickTapTimer?.cancel();
    streamTimer?.cancel();
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
                _stopExercise();
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
        title: const Text("Attention Training", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
              ProgressService.to.resetProgress(ProgressService.kAttentionTraining);
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
              child: currentExercise == -1 ? _buildExerciseList() : _buildExerciseScreen(),
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
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
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
                    .getProgressPercentage(ProgressService.kAttentionTraining) /
                100;
            final progressString = ProgressService.to
                .getProgressString(ProgressService.kAttentionTraining);
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
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
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
                      TtsService.to.speak(exercises[index]['name']);
                      _startExercise(index);
                      ProgressService.to.markItemCompleted(
                        ProgressService.kAttentionTraining,
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

          // Progress info
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Level", "$level", "🎯"),
                  _buildStatItem("Score", "$score", "⭐"),
                  _buildStatItem("Exercises", "${exercises.length}", "📝"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildExerciseScreen() {
    switch (currentExercise) {
      case 0:
        return _buildFollowTheBall();
      case 1:
        return _buildListenAndCount();
      case 2:
        return _buildQuickTap();
      case 3:
        return _buildRememberOrder();
      case 4:
        return _buildSustainedFocus();
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

  Widget _buildGameTitleCard({required String title, String? subtitle}) {
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

  Widget _buildFollowTheBall() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildGameTitleCard(
            title: showingPath ? "Watch the ball! 👀" : waitingForAnswer ? "Where did it stop? 🤔" : "Get ready...",
          ),
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
                bool hasBall = showingPath && currentBallPosition == index;
                final gradient = hasBall
                    ? const [Color(0xFFFF6B6B), Color(0xFFFF8E53)]
                    : _gameCardGradients[index % _gameCardGradients.length];
                return _buildGameCard(
                  index: index,
                  gradient: gradient,
                  onTap: waitingForAnswer ? () => _checkBallAnswer(index) : null,
                  child: hasBall ? const Text("🔴", style: TextStyle(fontSize: 40)) : const SizedBox(),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildListenAndCount() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value * 0.5),
                child: child,
              );
            },
            child: const Text("👂", style: TextStyle(fontSize: 80)),
          ),
          const SizedBox(height: 16),
          _buildGameTitleCard(title: "How many beeps?"),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(8, (i) {
              final gradient = _gameCardGradients[i % _gameCardGradients.length];
              return SizedBox(
                width: 65,
                height: 65,
                child: _buildGameCard(
                  index: i,
                  gradient: gradient,
                  onTap: () => _checkSoundCount(i + 1),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuickTap() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildGameTitleCard(
            title: "Quick Tap! Round ${quickTapRounds + 1}/10",
            subtitle: "Score: $quickTapScore",
          ),
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
                bool isTarget = targetPosition == index;
                final gradient = isTarget
                    ? const [Color(0xFF56D97F), Color(0xFF11998E)]
                    : _gameCardGradients[index % _gameCardGradients.length];
                return _buildGameCard(
                  index: index,
                  gradient: gradient,
                  onTap: isTarget ? () => _tapTarget(index) : null,
                  child: isTarget ? const Text("👆", style: TextStyle(fontSize: 40)) : const SizedBox(),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildRememberOrder() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildGameTitleCard(
            title: showingSequence ? "Watch the colors! 👀" : inputPhase ? "Tap in order! (${userSequence.length}/${colorSequence.length})" : "Get ready...",
          ),
          const SizedBox(height: 24),
          if (showingSequence && showingIndex >= 0)
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value * 0.4),
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorSequence[showingIndex],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: colorSequence[showingIndex].withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
              ),
            ),
          if (inputPhase) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: userSequence.map((color) {
                return Container(
                  width: 35,
                  height: 35,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 16,
              children: availableColors.map((color) {
                return GestureDetector(
                  onTap: () => _tapColor(color),
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSustainedFocus() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildGameTitleCard(
            title: "Stars caught: $starCount ⭐",
            subtitle: "${currentStreamIndex}/${streamItems.length}",
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value * 0.5),
                child: child,
              );
            },
            child: GestureDetector(
              onTap: _tapStream,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFAA5A), Color(0xFFFF6B6B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFFAA5A).withValues(alpha: 0.4), blurRadius: 15, spreadRadius: 3),
                  ],
                ),
                child: Center(
                  child: Text(
                    currentStreamIndex < streamItems.length ? streamItems[currentStreamIndex] : "✅",
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text("Tap when you see ⭐", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
