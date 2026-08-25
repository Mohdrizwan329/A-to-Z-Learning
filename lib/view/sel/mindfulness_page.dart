import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class MindfulnessPage extends StatefulWidget {
  const MindfulnessPage({super.key});

  @override
  State<MindfulnessPage> createState() => _MindfulnessPageState();
}

class _MindfulnessPageState extends State<MindfulnessPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  // Track completed items
  Map<String, bool> exerciseChecks = {};
  Map<String, bool> visualChecks = {};
  Map<String, bool> affirmationChecks = {};

  // Home screen style animations
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> mindfulnessExercises = [
    {
      'name': 'Belly Breathing',
      'emoji': '🫁',
      'duration': '1 minute',
      'description': 'Put your hand on your belly and feel it rise and fall.',
      'instructions': [
        'Sit or lie down comfortably',
        'Put one hand on your belly',
        'Breathe in slowly - feel your belly rise',
        'Breathe out slowly - feel your belly fall',
        'Keep breathing slowly for one minute',
      ],
    },
    {
      'name': 'Listening Game',
      'emoji': '👂',
      'duration': '2 minutes',
      'description': 'Close your eyes and count all the sounds you hear.',
      'instructions': [
        'Sit quietly and close your eyes',
        'Listen carefully to everything around you',
        'Can you hear birds? Cars? Wind?',
        'Count how many different sounds you hear',
        'Open your eyes and tell someone what you heard',
      ],
    },
    {
      'name': '5 Senses Check',
      'emoji': '🌟',
      'duration': '3 minutes',
      'description': 'Notice what you can see, hear, smell, taste, and touch.',
      'instructions': [
        'Name 5 things you can SEE 👀',
        'Name 4 things you can TOUCH ✋',
        'Name 3 things you can HEAR 👂',
        'Name 2 things you can SMELL 👃',
        'Name 1 thing you can TASTE 👅',
      ],
    },
    {
      'name': 'Body Scan',
      'emoji': '🧘',
      'duration': '2 minutes',
      'description': 'Feel each part of your body from head to toes.',
      'instructions': [
        'Lie down or sit comfortably',
        'Close your eyes',
        'Notice your head... is it relaxed?',
        'Notice your shoulders, arms, hands',
        'Notice your tummy, legs, feet',
        'Take a deep breath and open your eyes',
      ],
    },
    {
      'name': 'Gratitude Moment',
      'emoji': '🙏',
      'duration': '2 minutes',
      'description': 'Think of 3 things you are thankful for today.',
      'instructions': [
        'Close your eyes and think',
        'What made you smile today?',
        'Who do you love?',
        'What are you thankful for?',
        'Say "thank you" in your mind',
      ],
    },
    {
      'name': 'Mindful Walking',
      'emoji': '🚶',
      'duration': '3 minutes',
      'description': 'Walk slowly and notice each step you take.',
      'instructions': [
        'Stand up and walk slowly',
        'Feel your feet touch the ground',
        'Notice how your body moves',
        'Look at what\'s around you',
        'Breathe calmly as you walk',
      ],
    },
    {
      'name': 'Rainbow Breathing',
      'emoji': '🌈',
      'duration': '2 minutes',
      'description': 'Breathe in colors of the rainbow one by one.',
      'instructions': [
        'Close your eyes and relax',
        'Breathe in RED - feel warm and strong',
        'Breathe in ORANGE - feel happy',
        'Breathe in YELLOW - feel bright like the sun',
        'Continue with GREEN, BLUE, PURPLE',
      ],
    },
    {
      'name': 'Finger Breathing',
      'emoji': '🖐️',
      'duration': '2 minutes',
      'description': 'Trace your fingers while breathing slowly.',
      'instructions': [
        'Hold up one hand',
        'Use other finger to trace up your thumb - breathe in',
        'Trace down your thumb - breathe out',
        'Continue with each finger',
        'Do all 5 fingers slowly',
      ],
    },
    {
      'name': 'Bubble Thoughts',
      'emoji': '🫧',
      'duration': '2 minutes',
      'description': 'Imagine putting worries in bubbles that float away.',
      'instructions': [
        'Think of something that worries you',
        'Imagine putting it in a bubble',
        'Watch the bubble float up and away',
        'The worry is gone!',
        'Do this for any other worries',
      ],
    },
    {
      'name': 'Star Stretch',
      'emoji': '⭐',
      'duration': '1 minute',
      'description': 'Stretch your body like a starfish.',
      'instructions': [
        'Stand with feet apart',
        'Stretch arms out wide',
        'Spread fingers like a star',
        'Take a big breath and stretch bigger',
        'Relax and repeat 3 times',
      ],
    },
    {
      'name': 'Turtle Time',
      'emoji': '🐢',
      'duration': '2 minutes',
      'description': 'Be slow and calm like a turtle.',
      'instructions': [
        'Imagine you are a turtle',
        'Pull your shoulders up like going into a shell',
        'Hold for 5 seconds',
        'Slowly lower shoulders down',
        'Feel calm and relaxed',
      ],
    },
    {
      'name': 'Balloon Belly',
      'emoji': '🎈',
      'duration': '2 minutes',
      'description': 'Inflate your belly like a balloon.',
      'instructions': [
        'Lie down comfortably',
        'Put hands on your belly',
        'Breathe in - make belly big like a balloon',
        'Breathe out - let the air out slowly',
        'Repeat 5 times',
      ],
    },
    {
      'name': 'Flower Sniff',
      'emoji': '🌸',
      'duration': '1 minute',
      'description': 'Smell a beautiful flower slowly.',
      'instructions': [
        'Imagine holding a flower',
        'Breathe in slowly through your nose',
        'Smell the sweet flower',
        'Breathe out through your mouth',
        'Enjoy the calm feeling',
      ],
    },
    {
      'name': 'Candle Blow',
      'emoji': '🕯️',
      'duration': '1 minute',
      'description': 'Blow out a candle gently without letting it go out.',
      'instructions': [
        'Imagine a candle in front of you',
        'Take a deep breath in',
        'Blow out slowly and gently',
        'Make the flame flicker but not go out',
        'Repeat 5 times',
      ],
    },
    {
      'name': 'Cloud Watching',
      'emoji': '☁️',
      'duration': '3 minutes',
      'description': 'Watch clouds and see what shapes you find.',
      'instructions': [
        'Lie on your back or sit comfortably',
        'Look up at the sky or ceiling',
        'Imagine fluffy white clouds',
        'What shapes do you see?',
        'Let your mind be peaceful',
      ],
    },
    {
      'name': 'Squeeze & Release',
      'emoji': '✊',
      'duration': '2 minutes',
      'description': 'Squeeze your muscles tight then let them go.',
      'instructions': [
        'Make tight fists with both hands',
        'Hold for 5 seconds',
        'Release and feel your hands relax',
        'Do the same with your feet',
        'Notice how relaxation feels',
      ],
    },
    {
      'name': 'Heartbeat Listen',
      'emoji': '💓',
      'duration': '2 minutes',
      'description': 'Find and listen to your heartbeat.',
      'instructions': [
        'Sit quietly and close your eyes',
        'Put hand on your chest',
        'Feel your heart beating',
        'Count 10 heartbeats',
        'Notice how steady it is',
      ],
    },
    {
      'name': 'Animal Breath',
      'emoji': '🦁',
      'duration': '2 minutes',
      'description': 'Breathe like different animals.',
      'instructions': [
        'Breathe like a lion - big breath, roar out',
        'Breathe like a bunny - quick small sniffs',
        'Breathe like a snake - long hissss out',
        'Breathe like a bear - slow and deep',
        'Which one feels best?',
      ],
    },
    {
      'name': 'Peaceful Place',
      'emoji': '🏝️',
      'duration': '3 minutes',
      'description': 'Imagine your favorite peaceful place.',
      'instructions': [
        'Close your eyes',
        'Think of your favorite calm place',
        'Maybe a beach, forest, or your room',
        'Imagine all the details',
        'Feel safe and happy there',
      ],
    },
    {
      'name': 'Counting Calm',
      'emoji': '🔢',
      'duration': '2 minutes',
      'description': 'Count backwards slowly to feel calm.',
      'instructions': [
        'Sit comfortably',
        'Take a deep breath',
        'Count slowly from 10 to 1',
        'Say each number on an exhale',
        'Feel calmer with each number',
      ],
    },
    {
      'name': 'Sunshine Warm',
      'emoji': '☀️',
      'duration': '2 minutes',
      'description': 'Imagine warm sunshine on your body.',
      'instructions': [
        'Close your eyes',
        'Imagine warm sunshine on your head',
        'Feel it move down to your face',
        'Feel warmth on shoulders, arms, body',
        'Let the warmth relax you',
      ],
    },
    {
      'name': 'Magic Carpet',
      'emoji': '🧞',
      'duration': '3 minutes',
      'description': 'Float on a magic carpet to peaceful places.',
      'instructions': [
        'Imagine sitting on a soft magic carpet',
        'It slowly lifts off the ground',
        'You float over beautiful mountains',
        'See rivers, forests, and clouds below',
        'Land gently back home',
      ],
    },
    {
      'name': 'Worry Monster',
      'emoji': '👾',
      'duration': '2 minutes',
      'description': 'Give your worries to a friendly monster.',
      'instructions': [
        'Imagine a friendly worry monster',
        'It loves eating worries!',
        'Tell it your worry',
        'Watch it gobble up the worry',
        'Thank the monster and feel lighter',
      ],
    },
    {
      'name': 'Tree Standing',
      'emoji': '🌳',
      'duration': '2 minutes',
      'description': 'Stand strong and steady like a tree.',
      'instructions': [
        'Stand with feet together',
        'Imagine roots growing from your feet',
        'Stand tall like a tree trunk',
        'Arms can be branches reaching up',
        'Feel strong and grounded',
      ],
    },
    {
      'name': 'Kind Thoughts',
      'emoji': '💝',
      'duration': '2 minutes',
      'description': 'Send kind thoughts to people you love.',
      'instructions': [
        'Sit quietly and close eyes',
        'Think of someone you love',
        'Send them a happy thought',
        'Think: "May you be happy"',
        'Do this for family and friends',
      ],
    },
  ];

  final List<Map<String, dynamic>> calmingVisuals = [
    {
      'name': 'Ocean Waves',
      'emoji': '🌊',
      'sound': 'Imagine gentle waves on the beach...',
    },
    {
      'name': 'Forest Trees',
      'emoji': '🌲',
      'sound': 'Picture a peaceful forest with tall trees...',
    },
    {
      'name': 'Starry Night',
      'emoji': '✨',
      'sound': 'Imagine looking at a sky full of stars...',
    },
    {
      'name': 'Floating Clouds',
      'emoji': '☁️',
      'sound': 'Picture soft fluffy clouds drifting by...',
    },
    {
      'name': 'Rainbow',
      'emoji': '🌈',
      'sound': 'Imagine a beautiful rainbow after rain...',
    },
    {
      'name': 'Butterfly Garden',
      'emoji': '🦋',
      'sound': 'Picture colorful butterflies in a garden...',
    },
    {
      'name': 'Gentle Rain',
      'emoji': '🌧️',
      'sound': 'Imagine soft rain drops falling on leaves...',
    },
    {
      'name': 'Mountain Peak',
      'emoji': '🏔️',
      'sound': 'Picture yourself on top of a beautiful mountain...',
    },
    {
      'name': 'Calm Lake',
      'emoji': '🏞️',
      'sound': 'Imagine a perfectly still, clear lake...',
    },
    {
      'name': 'Sunrise',
      'emoji': '🌅',
      'sound': 'Picture the sun slowly rising over the horizon...',
    },
    {
      'name': 'Moonlight',
      'emoji': '🌙',
      'sound': 'Imagine soft moonlight shining through your window...',
    },
    {
      'name': 'Flower Field',
      'emoji': '🌻',
      'sound': 'Picture a field full of beautiful sunflowers...',
    },
    {
      'name': 'Waterfall',
      'emoji': '💧',
      'sound': 'Imagine a gentle waterfall flowing peacefully...',
    },
    {
      'name': 'Snow Fall',
      'emoji': '❄️',
      'sound': 'Picture soft snowflakes gently falling down...',
    },
    {
      'name': 'Green Meadow',
      'emoji': '🌿',
      'sound': 'Imagine lying in a soft green meadow...',
    },
    {
      'name': 'Campfire',
      'emoji': '🔥',
      'sound': 'Picture a warm cozy campfire crackling...',
    },
    {
      'name': 'Hot Air Balloon',
      'emoji': '🎈',
      'sound': 'Imagine floating in a colorful hot air balloon...',
    },
    {
      'name': 'Coral Reef',
      'emoji': '🐠',
      'sound': 'Picture colorful fish swimming in clear water...',
    },
    {
      'name': 'Garden Path',
      'emoji': '🌷',
      'sound': 'Imagine walking on a beautiful garden path...',
    },
    {
      'name': 'Northern Lights',
      'emoji': '🌌',
      'sound': 'Picture magical lights dancing in the sky...',
    },
    {
      'name': 'Cherry Blossoms',
      'emoji': '🌸',
      'sound': 'Imagine pink petals falling like gentle snow...',
    },
    {
      'name': 'Cozy Blanket',
      'emoji': '🛋️',
      'sound': 'Picture yourself wrapped in a soft warm blanket...',
    },
    {
      'name': 'Hummingbird',
      'emoji': '🐦',
      'sound': 'Imagine a tiny hummingbird hovering by flowers...',
    },
    {
      'name': 'River Flow',
      'emoji': '🌊',
      'sound': 'Picture a gentle river flowing through a valley...',
    },
    {
      'name': 'Autumn Leaves',
      'emoji': '🍂',
      'sound': 'Imagine colorful leaves falling from trees...',
    },
  ];

  final List<String> affirmations = [
    'I am calm and peaceful 🕊️',
    'I am safe and loved 💕',
    'I breathe in peace, breathe out worry 🌬️',
    'My body is relaxed 😌',
    'I am right here, right now ✨',
    'Everything is okay 🌈',
    'I am brave and strong 💪',
    'I can do hard things 🌟',
    'My feelings matter 💜',
    'I am kind to myself 🤗',
    'I believe in myself ⭐',
    'I am a good friend 🤝',
    'Today is a new day 🌅',
    'I am thankful for today 🙏',
    'I spread kindness everywhere 💝',
    'I am creative and smart 🎨',
    'My smile makes others happy 😊',
    'I learn something new every day 📚',
    'I am unique and special 🦄',
    'I can handle anything 🛡️',
    'I am proud of who I am 🏆',
    'I make good choices 🎯',
    'I am helpful and caring 💗',
    'My dreams can come true 🌠',
    'I am patient and kind 🌸',
    'I love my family and friends 👨‍👩‍👧‍👦',
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize check maps
    for (var exercise in mindfulnessExercises) {
      exerciseChecks[exercise['name']] = false;
    }
    for (var visual in calmingVisuals) {
      visualChecks[visual['name']] = false;
    }
    for (var affirmation in affirmations) {
      affirmationChecks[affirmation] = false;
    }

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

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.35);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _resetProgress() {
    setState(() {
      exerciseChecks.updateAll((key, value) => false);
      visualChecks.updateAll((key, value) => false);
      affirmationChecks.updateAll((key, value) => false);
    });
  }

  int _getCompletedCount(Map<String, bool> checks) {
    return checks.values.where((v) => v).length;
  }

  double _getProgress(Map<String, bool> checks) {
    if (checks.isEmpty) return 0;
    return _getCompletedCount(checks) / checks.length;
  }

  String _getProgressString(Map<String, bool> checks) {
    return '${_getCompletedCount(checks)}/${checks.length}';
  }

  void _showExerciseDialog(int index) {
    final exercise = mindfulnessExercises[index];
    final instructions = exercise['instructions'] as List<String>;

    _speakText(instructions[0]);

    Get.dialog(
      _ExerciseDialog(
        exercise: exercise,
        instructions: instructions,
        onComplete: () {
          // Update progress immediately
          exerciseChecks[exercise['name']] = true;
          // Force rebuild of parent widget
          if (mounted) {
            setState(() {});
          }
          // Auto close dialog after showing completion message
          Future.delayed(const Duration(seconds: 3), () {
            if (Get.isDialogOpen == true) {
              flutterTts.stop();
              Get.back();
            }
          });
        },
        speakText: _speakText,
        stopTts: () => flutterTts.stop(),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    flutterTts.stop();
    super.dispose();
  }

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
          final top = startTop - (progress * MediaQuery.of(context).size.height * 0.5);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              size: 18,
            ),
          ),
          onPressed: () {
            flutterTts.stop();
            Get.back();
          },
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
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Mindfulness",
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
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Practice"),
            Tab(text: "Imagine"),
            Tab(text: "Calm"),
          ],
        ),
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
            // Floating bubbles background
            ..._buildFloatingBubbles(),
            // Main content
            TabBarView(
              controller: _tabController,
              children: [_buildPracticeTab(), _buildImagineTab(), _buildCalmTab()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(Map<String, bool> checks) {
    final progress = _getProgress(checks);
    final progressString = _getProgressString(checks);
    return Padding(
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
  }

  Widget _buildPracticeTab() {
    return Column(
      children: [
        _buildProgressBar(exerciseChecks),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mindfulnessExercises.length,
            itemBuilder: (context, index) {
              final exercise = mindfulnessExercises[index];
              final isChecked = exerciseChecks[exercise['name']] ?? false;
              final gradient = AppColors.getGradientForIndex(index);

              return AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, index.isEven ? _floatAnimation.value : -_floatAnimation.value),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    TtsService.to.speak(mindfulnessExercises[index]['name']);
                    _showExerciseDialog(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isChecked
                            ? [const Color(0xFF56D97F), const Color(0xFF81E89E)]
                            : gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isChecked
                                  ? const Color(0xFF56D97F)
                                  : gradient[0])
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              exercise['emoji'],
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                exercise['description'],
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    color: Colors.white70,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    exercise['duration'],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 32,
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

  Widget _buildImagineTab() {
    return Column(
      children: [
        _buildProgressBar(visualChecks),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: calmingVisuals.length,
            itemBuilder: (context, index) {
              final visual = calmingVisuals[index];
              final isChecked = visualChecks[visual['name']] ?? false;
              final gradient = AppColors.getGradientForIndex(index);

              return AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, index.isEven ? _floatAnimation.value : -_floatAnimation.value),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    _speakText(visual['sound']);
                    setState(() {
                      visualChecks[visual['name']] = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isChecked
                            ? [const Color(0xFF56D97F), const Color(0xFF81E89E)]
                            : gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isChecked
                                  ? const Color(0xFF56D97F)
                                  : gradient[0])
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              visual['emoji'],
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                visual['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Tap to imagine",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.volume_up,
                          color: Colors.white70,
                          size: 24,
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

  Widget _buildCalmTab() {
    return Column(
      children: [
        _buildProgressBar(affirmationChecks),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: affirmations.length,
            itemBuilder: (context, index) {
              final affirmation = affirmations[index];
              final isChecked = affirmationChecks[affirmation] ?? false;
              final gradient = AppColors.getGradientForIndex(index);

              return AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, index.isEven ? _floatAnimation.value : -_floatAnimation.value),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    _speakText(affirmation.replaceAll(RegExp(r'[^\w\s,]'), ''));
                    setState(() {
                      affirmationChecks[affirmation] = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isChecked
                            ? [const Color(0xFF56D97F), const Color(0xFF81E89E)]
                            : gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isChecked
                                  ? const Color(0xFF56D97F)
                                  : gradient[0])
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            affirmation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.volume_up,
                          color: Colors.white70,
                          size: 24,
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

// Separate StatefulWidget for the exercise dialog to properly manage timers
class _ExerciseDialog extends StatefulWidget {
  final Map<String, dynamic> exercise;
  final List<String> instructions;
  final VoidCallback onComplete;
  final Function(String) speakText;
  final VoidCallback stopTts;

  const _ExerciseDialog({
    required this.exercise,
    required this.instructions,
    required this.onComplete,
    required this.speakText,
    required this.stopTts,
  });

  @override
  State<_ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<_ExerciseDialog> {
  int dialogStep = 0;
  bool isRunning = true;
  bool hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _markComplete() {
    if (!hasCompleted) {
      hasCompleted = true;
      widget.onComplete();
    }
  }

  void _startAutoAdvance() {
    Future.delayed(const Duration(seconds: 6), () {
      if (!mounted || !isRunning) return;

      if (dialogStep < widget.instructions.length - 1) {
        setState(() => dialogStep++);
        widget.speakText(widget.instructions[dialogStep]);
        _startAutoAdvance();
      } else if (!hasCompleted) {
        // Mark complete immediately when reaching last step
        _markComplete();
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted && isRunning) {
            widget.speakText("Great job! You did it!");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
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
            Text(
              widget.exercise['emoji'],
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 12),
            Text(
              widget.exercise['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "Step ${dialogStep + 1} of ${widget.instructions.length}",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.instructions[dialogStep],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (dialogStep + 1) / widget.instructions.length,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    widget.speakText(widget.instructions[dialogStep]);
                  },
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text("Listen"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    isRunning = false;
                    widget.stopTts();
                    Get.back();
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text("Close"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
