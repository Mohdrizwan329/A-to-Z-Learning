import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class AnimatedVideosPage extends StatefulWidget {
  const AnimatedVideosPage({super.key});

  @override
  State<AnimatedVideosPage> createState() => _AnimatedVideosPageState();
}

class _AnimatedVideosPageState extends State<AnimatedVideosPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  // Animation controllers for demo animations
  late AnimationController _bounceController;
  late AnimationController _rotateController;
  late AnimationController _scaleController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> alphabetVideos = [
    {
      'letter': 'A',
      'word': 'Apple',
      'emoji': '🍎',
      'color': Color(0xFFFF6B6B),
      'fact': 'A is for Apple! Apples are crunchy and sweet.',
    },
    {
      'letter': 'B',
      'word': 'Ball',
      'emoji': '⚽',
      'color': Color(0xFF4ECDC4),
      'fact': 'B is for Ball! Balls are round and bouncy.',
    },
    {
      'letter': 'C',
      'word': 'Cat',
      'emoji': '🐱',
      'color': Color(0xFFFFD93D),
      'fact': 'C is for Cat! Cats say meow meow.',
    },
    {
      'letter': 'D',
      'word': 'Dog',
      'emoji': '🐕',
      'color': Color(0xFFA78BFA),
      'fact': 'D is for Dog! Dogs are our best friends.',
    },
    {
      'letter': 'E',
      'word': 'Elephant',
      'emoji': '🐘',
      'color': Color(0xFF667EEA),
      'fact': 'E is for Elephant! Elephants have long trunks.',
    },
    {
      'letter': 'F',
      'word': 'Fish',
      'emoji': '🐟',
      'color': Color(0xFF56D97F),
      'fact': 'F is for Fish! Fish swim in water.',
    },
    {
      'letter': 'G',
      'word': 'Grapes',
      'emoji': '🍇',
      'color': Color(0xFF9B59B6),
      'fact': 'G is for Grapes! Grapes grow in bunches.',
    },
    {
      'letter': 'H',
      'word': 'House',
      'emoji': '🏠',
      'color': Color(0xFFE74C3C),
      'fact': 'H is for House! We live in houses.',
    },
  ];

  final List<Map<String, dynamic>> numberVideos = [
    {
      'number': '1',
      'word': 'One',
      'emoji': '☝️',
      'color': Color(0xFFFF6B6B),
      'example': 'One sun in the sky ☀️',
    },
    {
      'number': '2',
      'word': 'Two',
      'emoji': '✌️',
      'color': Color(0xFF4ECDC4),
      'example': 'Two eyes to see 👀',
    },
    {
      'number': '3',
      'word': 'Three',
      'emoji': '🤟',
      'color': Color(0xFFFFD93D),
      'example': 'Three little pigs 🐷🐷🐷',
    },
    {
      'number': '4',
      'word': 'Four',
      'emoji': '🖐️',
      'color': Color(0xFFA78BFA),
      'example': 'Four wheels on a car 🚗',
    },
    {
      'number': '5',
      'word': 'Five',
      'emoji': '🖐️',
      'color': Color(0xFF667EEA),
      'example': 'Five fingers on hand ✋',
    },
    {
      'number': '6',
      'word': 'Six',
      'emoji': '6️⃣',
      'color': Color(0xFF56D97F),
      'example': 'Six legs on insects 🐜',
    },
    {
      'number': '7',
      'word': 'Seven',
      'emoji': '7️⃣',
      'color': Color(0xFF9B59B6),
      'example': 'Seven days in week 📅',
    },
    {
      'number': '8',
      'word': 'Eight',
      'emoji': '8️⃣',
      'color': Color(0xFFE74C3C),
      'example': 'Eight legs on spider 🕷️',
    },
    {
      'number': '9',
      'word': 'Nine',
      'emoji': '9️⃣',
      'color': Color(0xFFFF8E53),
      'example': 'Nine planets we knew 🪐',
    },
    {
      'number': '10',
      'word': 'Ten',
      'emoji': '🔟',
      'color': Color(0xFF00B894),
      'example': 'Ten toes on feet 🦶🦶',
    },
  ];

  final List<Map<String, dynamic>> rhymeVideos = [
    {
      'title': 'Twinkle Twinkle',
      'emoji': '⭐',
      'color': Color(0xFFFFD93D),
      'lyrics':
          'Twinkle twinkle little star,\nHow I wonder what you are!\nUp above the world so high,\nLike a diamond in the sky!',
      'actions': ['Point up', 'Make diamond shape', 'Wave hands'],
    },
    {
      'title': 'Wheels on the Bus',
      'emoji': '🚌',
      'color': Color(0xFFFF6B6B),
      'lyrics':
          'The wheels on the bus go round and round,\nRound and round, round and round!\nThe wheels on the bus go round and round,\nAll through the town!',
      'actions': ['Roll arms', 'Beep horn', 'Wave bye'],
    },
    {
      'title': 'If You\'re Happy',
      'emoji': '😊',
      'color': Color(0xFF4ECDC4),
      'lyrics':
          'If you\'re happy and you know it, clap your hands! 👏👏\nIf you\'re happy and you know it, clap your hands! 👏👏\nIf you\'re happy and you know it,\nAnd you really want to show it,\nIf you\'re happy and you know it, clap your hands! 👏👏',
      'actions': ['Clap hands', 'Stomp feet', 'Shout hooray'],
    },
    {
      'title': 'Head Shoulders',
      'emoji': '🧒',
      'color': Color(0xFFA78BFA),
      'lyrics':
          'Head, shoulders, knees and toes, knees and toes!\nHead, shoulders, knees and toes, knees and toes!\nAnd eyes and ears and mouth and nose,\nHead, shoulders, knees and toes, knees and toes!',
      'actions': ['Touch head', 'Touch shoulders', 'Touch knees'],
    },
    {
      'title': 'Baby Shark',
      'emoji': '🦈',
      'color': Color(0xFF667EEA),
      'lyrics':
          'Baby shark, doo doo doo doo doo doo!\nBaby shark, doo doo doo doo doo doo!\nBaby shark, doo doo doo doo doo doo!\nBaby shark!',
      'actions': ['Small chomps', 'Big chomps', 'Swim away'],
    },
  ];

  final List<Map<String, dynamic>> storyVideos = [
    {
      'title': 'The Hungry Caterpillar',
      'emoji': '🐛',
      'color': Color(0xFF56D97F),
      'scenes': [
        {'text': 'One day, a tiny egg lay on a leaf 🥚🍃', 'emoji': '🥚'},
        {'text': 'Pop! Out came a tiny caterpillar 🐛', 'emoji': '🐛'},
        {'text': 'He was very very hungry! 😋', 'emoji': '😋'},
        {'text': 'He ate apples, oranges, and cake 🍎🍊🍰', 'emoji': '🍎'},
        {'text': 'He became a beautiful butterfly! 🦋', 'emoji': '🦋'},
      ],
    },
    {
      'title': 'Three Little Pigs',
      'emoji': '🐷',
      'color': Color(0xFFFFAA5A),
      'scenes': [
        {'text': 'Three little pigs built their houses 🏠', 'emoji': '🐷'},
        {'text': 'First pig made a straw house 🌾', 'emoji': '🌾'},
        {'text': 'Second pig made a stick house 🪵', 'emoji': '🪵'},
        {'text': 'Third pig made a brick house 🧱', 'emoji': '🧱'},
        {'text': 'Wolf couldn\'t blow the brick house! 💪', 'emoji': '💪'},
      ],
    },
    {
      'title': 'The Lion and Mouse',
      'emoji': '🦁',
      'color': Color(0xFFFFD93D),
      'scenes': [
        {'text': 'A big lion was sleeping 😴🦁', 'emoji': '😴'},
        {'text': 'A tiny mouse woke him up! 🐭', 'emoji': '🐭'},
        {'text': 'Lion let the mouse go 🤝', 'emoji': '🤝'},
        {'text': 'Later, mouse saved lion from a net! 🕸️', 'emoji': '🕸️'},
        {'text': 'Small friends can help big friends! ❤️', 'emoji': '❤️'},
      ],
    },
  ];

  int selectedVideoIndex = 0;
  int currentSceneIndex = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotateController);
    _scaleAnimation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _playAnimation() {
    _bounceController.forward(from: 0);
    _rotateController.repeat();
    _scaleController.repeat(reverse: true);
    setState(() => isPlaying = true);
  }

  void _stopAnimation() {
    _bounceController.stop();
    _rotateController.stop();
    _scaleController.stop();
    setState(() => isPlaying = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bounceController.dispose();
    _rotateController.dispose();
    _scaleController.dispose();
    flutterTts.stop();
    super.dispose();
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
              size: 20,
            ),
          ),
          onPressed: () {
            _stopAnimation();
            flutterTts.stop();
            Get.back();
          },
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
          "Alphabet Animated Learning",
          style: TextStyle(
            fontSize: 18,
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
            onPressed: () {
              _stopAnimation();
              flutterTts.stop();
              selectedVideoIndex = 0;
              currentSceneIndex = 0;
              ProgressService.to.resetProgress(ProgressService.kAnimatedABC);
              ProgressService.to.resetProgress(
                ProgressService.kAnimatedNumbers,
              );
              ProgressService.to.resetProgress(ProgressService.kAnimatedRhymes);
              ProgressService.to.resetProgress(
                ProgressService.kAnimatedStories,
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: "ABC"),
            Tab(text: "123"),
            Tab(text: "Rhymes"),
            Tab(text: "Stories"),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAlphabetVideos(),
            _buildNumberVideos(),
            _buildRhymeVideos(),
            _buildStoryVideos(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildProgressBar(String progressKey) {
    return Obx(() {
      final _ = ProgressService.to.completedItems[progressKey];
      final progress =
          ProgressService.to.getProgressPercentage(progressKey) / 100;
      final progressString = ProgressService.to.getProgressString(progressKey);
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
    });
  }

  Widget _buildAlphabetVideos() {
    return Column(
      children: [
        _buildProgressBar(ProgressService.kAnimatedABC),
        Expanded(
          child: Obx(() {
            final _ =
                ProgressService.to.completedItems[ProgressService.kAnimatedABC];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alphabetVideos.length,
              itemBuilder: (context, index) {
                final video = alphabetVideos[index];
                final isCompleted = ProgressService.to.isItemCompleted(
                  ProgressService.kAnimatedABC,
                  index,
                );
                return GestureDetector(
                  onTap: () {
                    _showAlphabetAnimation(video);
                    ProgressService.to.markItemCompleted(
                      ProgressService.kAnimatedABC,
                      index,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          video['color'],
                          video['color'].withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: video['color'].withValues(alpha: 0.4),
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
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  video['letter'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${video['letter']} for ${video['word']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${video['emoji']} Tap to animate!",
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNumberVideos() {
    return Column(
      children: [
        _buildProgressBar(ProgressService.kAnimatedNumbers),
        Expanded(
          child: Obx(() {
            final _ = ProgressService
                .to
                .completedItems[ProgressService.kAnimatedNumbers];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: numberVideos.length,
              itemBuilder: (context, index) {
                final video = numberVideos[index];
                final isCompleted = ProgressService.to.isItemCompleted(
                  ProgressService.kAnimatedNumbers,
                  index,
                );
                return GestureDetector(
                  onTap: () {
                    _showNumberAnimation(video);
                    ProgressService.to.markItemCompleted(
                      ProgressService.kAnimatedNumbers,
                      index,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          video['color'],
                          video['color'].withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: video['color'].withValues(alpha: 0.4),
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
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  video['number'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video['word'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    video['example'],
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRhymeVideos() {
    return Column(
      children: [
        _buildProgressBar(ProgressService.kAnimatedRhymes),
        Expanded(
          child: Obx(() {
            final _ = ProgressService
                .to
                .completedItems[ProgressService.kAnimatedRhymes];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rhymeVideos.length,
              itemBuilder: (context, index) {
                final rhyme = rhymeVideos[index];
                final isCompleted = ProgressService.to.isItemCompleted(
                  ProgressService.kAnimatedRhymes,
                  index,
                );
                return GestureDetector(
                  onTap: () {
                    _showRhymeAnimation(rhyme);
                    ProgressService.to.markItemCompleted(
                      ProgressService.kAnimatedRhymes,
                      index,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          rhyme['color'],
                          rhyme['color'].withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: rhyme['color'].withValues(alpha: 0.4),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      rhyme['emoji'],
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    rhyme['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isCompleted)
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.play_circle_filled,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (rhyme['actions'] as List<String>).map((
                                action,
                              ) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    action,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStoryVideos() {
    return Column(
      children: [
        _buildProgressBar(ProgressService.kAnimatedStories),
        Expanded(
          child: Obx(() {
            final _ = ProgressService
                .to
                .completedItems[ProgressService.kAnimatedStories];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: storyVideos.length,
              itemBuilder: (context, index) {
                final story = storyVideos[index];
                final isCompleted = ProgressService.to.isItemCompleted(
                  ProgressService.kAnimatedStories,
                  index,
                );
                return GestureDetector(
                  onTap: () {
                    _showStoryAnimation(story);
                    ProgressService.to.markItemCompleted(
                      ProgressService.kAnimatedStories,
                      index,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          story['color'],
                          story['color'].withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: story['color'].withValues(alpha: 0.4),
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
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  story['emoji'],
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${(story['scenes'] as List).length} scenes • Tap to watch",
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showAlphabetAnimation(Map<String, dynamic> video) {
    _playAnimation();
    _speakText("${video['letter']} for ${video['word']}. ${video['fact']}");

    Get.dialog(
      Dialog(
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
              AnimatedBuilder(
                animation: Listenable.merge([
                  _bounceController,
                  _rotateController,
                  _scaleController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: Transform.rotate(
                      angle: _rotateAnimation.value * 0.1,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              video['letter'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(video['emoji'], style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 12),
              Text(
                "${video['letter']} for ${video['word']}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  video['fact'],
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _speakText(
                      "${video['letter']} for ${video['word']}. ${video['fact']}",
                    ),
                    icon: const Icon(Icons.replay, size: 18),
                    label: const Text("Listen"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _stopAnimation();
                      flutterTts.stop();
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
      ),
      barrierDismissible: true,
    );
  }

  void _showNumberAnimation(Map<String, dynamic> video) {
    _playAnimation();
    _speakText(
      "Number ${video['number']}. ${video['word']}. ${video['example']}",
    );

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _scaleController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        video['number'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              video['word'],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                video['example'],
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _speakText(
                    "Number ${video['number']}. ${video['word']}. ${video['example']}",
                  ),
                  icon: const Icon(Icons.replay),
                  label: const Text("Listen Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _stopAnimation();
                    flutterTts.stop();
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
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
      isScrollControlled: true,
    );
  }

  void _showRhymeAnimation(Map<String, dynamic> rhyme) {
    _speakText(rhyme['lyrics']);

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  rhyme['emoji'],
                  style: const TextStyle(fontSize: 45),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rhyme['title'],
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    rhyme['lyrics'],
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.8,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Actions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: (rhyme['actions'] as List<String>).map((action) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("👋 ", style: TextStyle(fontSize: 14)),
                      Text(
                        action,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _speakText(rhyme['lyrics']),
                  icon: const Icon(Icons.replay),
                  label: const Text("Sing Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    flutterTts.stop();
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
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
      isScrollControlled: true,
    );
  }

  void _showStoryAnimation(Map<String, dynamic> story) {
    currentSceneIndex = 0;
    final scenes = story['scenes'] as List<Map<String, dynamic>>;
    _speakText(scenes[0]['text']);

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  story['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(scenes.length, (i) {
                    return Container(
                      width: 30,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i <= currentSceneIndex
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                TweenAnimationBuilder<double>(
                  key: ValueKey(currentSceneIndex),
                  tween: Tween(begin: 0.5, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        scenes[currentSceneIndex]['emoji'],
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    scenes[currentSceneIndex]['text'],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: currentSceneIndex > 0
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: currentSceneIndex > 0
                            ? () {
                                setModalState(() => currentSceneIndex--);
                                _speakText(scenes[currentSceneIndex]['text']);
                              }
                            : null,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: currentSceneIndex > 0
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                          size: 24,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _speakText(scenes[currentSceneIndex]['text']),
                      icon: const Icon(Icons.volume_up),
                      label: const Text("Listen"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: currentSceneIndex < scenes.length - 1
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: currentSceneIndex < scenes.length - 1
                            ? () {
                                setModalState(() => currentSceneIndex++);
                                _speakText(scenes[currentSceneIndex]['text']);
                              }
                            : null,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: currentSceneIndex < scenes.length - 1
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    flutterTts.stop();
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
