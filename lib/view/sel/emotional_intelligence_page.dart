import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class EmotionalIntelligencePage extends StatefulWidget {
  const EmotionalIntelligencePage({super.key});

  @override
  State<EmotionalIntelligencePage> createState() =>
      _EmotionalIntelligencePageState();
}

class _EmotionalIntelligencePageState extends State<EmotionalIntelligencePage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  int selectedEmotion = 0;
  bool _currentEmotionTapped = false;
  Set<int> _viewedEmotions = {};
  Set<int> _viewedQuiz = {};

  final List<Map<String, dynamic>> emotions = [
    {
      'name': 'Happy',
      'emoji': '😊',
      'description': 'When something good happens and you feel joy inside!',
      'examples': [
        'Getting a gift',
        'Playing with friends',
        'Eating ice cream',
      ],
    },
    {
      'name': 'Sad',
      'emoji': '😢',
      'description': 'When something makes you feel down or upset.',
      'examples': ['Missing a friend', 'Losing a toy', 'Saying goodbye'],
    },
    {
      'name': 'Angry',
      'emoji': '😠',
      'description': 'When something feels unfair or frustrating.',
      'examples': [
        'Someone takes your toy',
        'Things don\'t go your way',
        'Waiting too long',
      ],
    },
    {
      'name': 'Scared',
      'emoji': '😨',
      'description': 'When something feels unsafe or unknown.',
      'examples': ['Dark room', 'Loud noises', 'New places'],
    },
    {
      'name': 'Surprised',
      'emoji': '😲',
      'description': 'When something unexpected happens!',
      'examples': ['A surprise party', 'Finding something new', 'Magic tricks'],
    },
    {
      'name': 'Excited',
      'emoji': '🤩',
      'description': 'When you can\'t wait for something fun!',
      'examples': ['Birthday coming', 'Going to park', 'Special treats'],
    },
    {
      'name': 'Calm',
      'emoji': '😌',
      'description': 'When you feel peaceful and relaxed.',
      'examples': ['After rest', 'Reading a book', 'Deep breaths'],
    },
    {
      'name': 'Worried',
      'emoji': '😟',
      'description': 'When you think something bad might happen.',
      'examples': [
        'First day of school',
        'Before a test',
        'When someone is late',
      ],
    },
    {
      'name': 'Proud',
      'emoji': '🥳',
      'description': 'When you did something great!',
      'examples': ['Good grades', 'Helping others', 'Learning new skill'],
    },
    {
      'name': 'Shy',
      'emoji': '🙈',
      'description': 'When you feel nervous around new people.',
      'examples': [
        'Meeting new friends',
        'Speaking in front of others',
        'New situations',
      ],
    },
    {
      'name': 'Lonely',
      'emoji': '😔',
      'description': 'When you feel alone and want company.',
      'examples': ['No one to play with', 'Missing family', 'Being left out'],
    },
    {
      'name': 'Grateful',
      'emoji': '🥰',
      'description': 'When you feel thankful for what you have.',
      'examples': ['Getting help', 'Receiving gifts', 'Kind words'],
    },
    {
      'name': 'Jealous',
      'emoji': '😒',
      'description': 'When you want what someone else has.',
      'examples': [
        'Friend\'s new toy',
        'Someone gets attention',
        'Others winning',
      ],
    },
    {
      'name': 'Embarrassed',
      'emoji': '😅',
      'description': 'When you feel awkward or ashamed.',
      'examples': [
        'Making mistakes',
        'Tripping in public',
        'Forgetting something',
      ],
    },
    {
      'name': 'Bored',
      'emoji': '😑',
      'description': 'When nothing seems interesting.',
      'examples': ['Rainy day inside', 'Nothing to do', 'Waiting too long'],
    },
    {
      'name': 'Nervous',
      'emoji': '😰',
      'description': 'When you feel uneasy about something.',
      'examples': ['Before performance', 'Meeting new people', 'Taking tests'],
    },
    {
      'name': 'Hopeful',
      'emoji': '🤞',
      'description': 'When you expect something good to happen.',
      'examples': ['Wishing for a pet', 'Hoping to win', 'Waiting for results'],
    },
    {
      'name': 'Disappointed',
      'emoji': '😞',
      'description': 'When things don\'t go as expected.',
      'examples': ['Plans cancelled', 'Didn\'t get what wanted', 'Lost a game'],
    },
    {
      'name': 'Frustrated',
      'emoji': '😤',
      'description': 'When something is hard and you feel stuck.',
      'examples': [
        'Can\'t solve puzzle',
        'Things not working',
        'Learning is slow',
      ],
    },
    {
      'name': 'Loving',
      'emoji': '💕',
      'description': 'When you feel deep affection for someone.',
      'examples': ['Hugging family', 'Playing with pets', 'Best friends'],
    },
    {
      'name': 'Curious',
      'emoji': '🤔',
      'description': 'When you want to learn or know more.',
      'examples': ['Asking questions', 'Exploring new things', 'Reading books'],
    },
    {
      'name': 'Brave',
      'emoji': '😎',
      'description': 'When you face your fears courageously.',
      'examples': [
        'Trying new things',
        'Standing up for others',
        'Facing challenges',
      ],
    },
    {
      'name': 'Tired',
      'emoji': '😴',
      'description': 'When your body needs rest.',
      'examples': ['After playing', 'Late at night', 'Busy day'],
    },
    {
      'name': 'Silly',
      'emoji': '🤪',
      'description': 'When you feel playful and goofy.',
      'examples': ['Making jokes', 'Acting funny', 'Playing games'],
    },
    {
      'name': 'Peaceful',
      'emoji': '☺️',
      'description': 'When everything feels just right.',
      'examples': ['Quiet time', 'Nature walks', 'After meditation'],
    },
    {
      'name': 'Determined',
      'emoji': '💪',
      'description': 'When you won\'t give up on something.',
      'examples': [
        'Practicing hard',
        'Finishing homework',
        'Learning to ride bike',
      ],
    },
    {
      'name': 'Hurt',
      'emoji': '🥺',
      'description': 'When someone or something causes you pain.',
      'examples': ['Unkind words', 'Being left out', 'Broken promises'],
    },
    {
      'name': 'Cheerful',
      'emoji': '😄',
      'description': 'When you feel bright and happy.',
      'examples': ['Sunny days', 'Fun activities', 'Good news'],
    },
    {
      'name': 'Anxious',
      'emoji': '😬',
      'description': 'When you feel worried and restless.',
      'examples': ['Big events coming', 'New situations', 'Waiting for news'],
    },
    {
      'name': 'Content',
      'emoji': '🙂',
      'description': 'When you feel satisfied and happy.',
      'examples': ['Good meal', 'Comfortable place', 'Nice conversation'],
    },
    {
      'name': 'Overwhelmed',
      'emoji': '😵',
      'description': 'When too much is happening at once.',
      'examples': ['Too many tasks', 'Loud places', 'Many emotions'],
    },
    {
      'name': 'Inspired',
      'emoji': '✨',
      'description': 'When you feel motivated to create.',
      'examples': ['Seeing art', 'Hearing stories', 'Meeting heroes'],
    },
    {
      'name': 'Guilty',
      'emoji': '😓',
      'description': 'When you feel bad about something you did.',
      'examples': ['Telling a lie', 'Breaking rules', 'Hurting someone'],
    },
    {
      'name': 'Relaxed',
      'emoji': '😊',
      'description': 'When your body and mind feel at ease.',
      'examples': ['Vacation', 'Watching clouds', 'Cozy blanket'],
    },
    {
      'name': 'Appreciated',
      'emoji': '💖',
      'description': 'When you feel valued by others.',
      'examples': ['Thank you notes', 'Compliments', 'Recognition'],
    },
    {
      'name': 'Confused',
      'emoji': '😕',
      'description': 'When you don\'t understand something.',
      'examples': ['Hard problems', 'Mixed messages', 'New concepts'],
    },
    {
      'name': 'Impatient',
      'emoji': '⏰',
      'description': 'When you want things to happen faster.',
      'examples': ['Waiting in line', 'Long car rides', 'Slow downloads'],
    },
    {
      'name': 'Amazed',
      'emoji': '🤯',
      'description': 'When something incredible happens.',
      'examples': ['Magic shows', 'Amazing facts', 'Beautiful sights'],
    },
    {
      'name': 'Safe',
      'emoji': '🏠',
      'description': 'When you feel protected and secure.',
      'examples': ['With family', 'At home', 'With trusted friends'],
    },
    {
      'name': 'Uncomfortable',
      'emoji': '😣',
      'description': 'When something doesn\'t feel right.',
      'examples': ['Tight clothes', 'Awkward situations', 'Strange places'],
    },
    {
      'name': 'Joyful',
      'emoji': '😁',
      'description': 'When you feel great happiness inside.',
      'examples': ['Celebrations', 'Achievements', 'Special moments'],
    },
    {
      'name': 'Thoughtful',
      'emoji': '💭',
      'description': 'When you think deeply about something.',
      'examples': ['Problem solving', 'Planning', 'Remembering'],
    },
    {
      'name': 'Confident',
      'emoji': '😏',
      'description': 'When you believe in yourself.',
      'examples': ['After practice', 'Knowing answers', 'Good at something'],
    },
    {
      'name': 'Generous',
      'emoji': '🤲',
      'description': 'When you want to share with others.',
      'examples': ['Giving gifts', 'Sharing food', 'Helping others'],
    },
    {
      'name': 'Helpless',
      'emoji': '😿',
      'description': 'When you can\'t change something.',
      'examples': ['Too hard', 'No control', 'Need help'],
    },
    {
      'name': 'Optimistic',
      'emoji': '🌈',
      'description': 'When you expect the best outcome.',
      'examples': ['New beginnings', 'After setbacks', 'Planning future'],
    },
    {
      'name': 'Grumpy',
      'emoji': '😾',
      'description': 'When little things annoy you.',
      'examples': ['Tired mornings', 'Hungry', 'Things going wrong'],
    },
    {
      'name': 'Friendly',
      'emoji': '👋',
      'description': 'When you want to connect with others.',
      'examples': ['Meeting people', 'Playing together', 'Being kind'],
    },
    {
      'name': 'Respected',
      'emoji': '🙌',
      'description': 'When others treat you with honor.',
      'examples': ['Being listened to', 'Valued opinions', 'Fair treatment'],
    },
    {
      'name': 'Empathetic',
      'emoji': '💗',
      'description': 'When you understand how others feel.',
      'examples': [
        'Comforting friends',
        'Sharing feelings',
        'Being supportive',
      ],
    },
  ];

  final List<Map<String, dynamic>> emotionQuiz = [
    {
      'situation': 'Your friend shares their toy with you',
      'correctEmotion': 'Happy',
      'emoji': '🧸',
    },
    {
      'situation': 'You can\'t find your favorite book',
      'correctEmotion': 'Sad',
      'emoji': '📚',
    },
    {
      'situation': 'Someone pushed you in line',
      'correctEmotion': 'Angry',
      'emoji': '😤',
    },
    {
      'situation': 'You hear a very loud noise',
      'correctEmotion': 'Scared',
      'emoji': '💥',
    },
    {
      'situation': 'Your birthday party is tomorrow!',
      'correctEmotion': 'Excited',
      'emoji': '🎂',
    },
    {
      'situation': 'You helped your mom clean up',
      'correctEmotion': 'Proud',
      'emoji': '✨',
    },
    {
      'situation': 'You got a surprise gift',
      'correctEmotion': 'Surprised',
      'emoji': '🎁',
    },
    {
      'situation': 'You have a big test tomorrow',
      'correctEmotion': 'Worried',
      'emoji': '📝',
    },
    {
      'situation': 'Your pet is sleeping peacefully',
      'correctEmotion': 'Calm',
      'emoji': '🐱',
    },
    {
      'situation': 'You met a new classmate',
      'correctEmotion': 'Shy',
      'emoji': '👋',
    },
    {
      'situation': 'No one is home and you miss family',
      'correctEmotion': 'Lonely',
      'emoji': '🏠',
    },
    {
      'situation': 'Someone said thank you for your help',
      'correctEmotion': 'Grateful',
      'emoji': '🙏',
    },
    {
      'situation': 'Your friend got a new toy you wanted',
      'correctEmotion': 'Jealous',
      'emoji': '🧸',
    },
    {
      'situation': 'You tripped and fell in front of everyone',
      'correctEmotion': 'Embarrassed',
      'emoji': '😅',
    },
    {
      'situation': 'It\'s raining and you can\'t go outside',
      'correctEmotion': 'Bored',
      'emoji': '🌧️',
    },
    {
      'situation': 'You have to speak in front of the class',
      'correctEmotion': 'Nervous',
      'emoji': '🎤',
    },
    {
      'situation': 'You\'re waiting to hear about a competition',
      'correctEmotion': 'Hopeful',
      'emoji': '🏆',
    },
    {
      'situation': 'Your favorite show got cancelled',
      'correctEmotion': 'Disappointed',
      'emoji': '📺',
    },
    {
      'situation': 'A puzzle is really hard to solve',
      'correctEmotion': 'Frustrated',
      'emoji': '🧩',
    },
    {
      'situation': 'You\'re hugging your grandparents',
      'correctEmotion': 'Loving',
      'emoji': '👴',
    },
    {
      'situation': 'You want to know how something works',
      'correctEmotion': 'Curious',
      'emoji': '🔍',
    },
    {
      'situation': 'You tried something scary and did it',
      'correctEmotion': 'Brave',
      'emoji': '🦁',
    },
    {
      'situation': 'You played all day and need sleep',
      'correctEmotion': 'Tired',
      'emoji': '😴',
    },
    {
      'situation': 'You\'re making funny faces with friends',
      'correctEmotion': 'Silly',
      'emoji': '🤪',
    },
    {
      'situation': 'You\'re sitting by a quiet lake',
      'correctEmotion': 'Peaceful',
      'emoji': '🏞️',
    },
    {
      'situation': 'You won\'t stop until you finish',
      'correctEmotion': 'Determined',
      'emoji': '💪',
    },
    {
      'situation': 'Someone said mean words to you',
      'correctEmotion': 'Hurt',
      'emoji': '💔',
    },
    {
      'situation': 'The sun is shining and birds are singing',
      'correctEmotion': 'Cheerful',
      'emoji': '☀️',
    },
    {
      'situation': 'A big event is coming and you\'re restless',
      'correctEmotion': 'Anxious',
      'emoji': '📅',
    },
    {
      'situation': 'You ate your favorite meal',
      'correctEmotion': 'Content',
      'emoji': '🍕',
    },
    {
      'situation': 'Too many things happening at once',
      'correctEmotion': 'Overwhelmed',
      'emoji': '🌀',
    },
    {
      'situation': 'You saw an amazing painting',
      'correctEmotion': 'Inspired',
      'emoji': '🎨',
    },
    {
      'situation': 'You told a lie and feel bad',
      'correctEmotion': 'Guilty',
      'emoji': '😓',
    },
    {
      'situation': 'You\'re lying on a soft bed',
      'correctEmotion': 'Relaxed',
      'emoji': '🛏️',
    },
    {
      'situation': 'Someone wrote you a thank you card',
      'correctEmotion': 'Appreciated',
      'emoji': '💌',
    },
    {
      'situation': 'You don\'t understand the instructions',
      'correctEmotion': 'Confused',
      'emoji': '❓',
    },
    {
      'situation': 'The line is moving very slowly',
      'correctEmotion': 'Impatient',
      'emoji': '⏰',
    },
    {
      'situation': 'You saw a magic trick',
      'correctEmotion': 'Amazed',
      'emoji': '🪄',
    },
    {
      'situation': 'You\'re at home with your family',
      'correctEmotion': 'Safe',
      'emoji': '👨‍👩‍👧',
    },
    {
      'situation': 'Your shoes are too tight',
      'correctEmotion': 'Uncomfortable',
      'emoji': '👟',
    },
    {
      'situation': 'You won a prize at school',
      'correctEmotion': 'Joyful',
      'emoji': '🏅',
    },
    {
      'situation': 'You\'re thinking about your future',
      'correctEmotion': 'Thoughtful',
      'emoji': '💭',
    },
    {
      'situation': 'You know you can do it',
      'correctEmotion': 'Confident',
      'emoji': '⭐',
    },
    {
      'situation': 'You want to share your lunch',
      'correctEmotion': 'Generous',
      'emoji': '🍱',
    },
    {
      'situation': 'You can\'t fix the broken toy',
      'correctEmotion': 'Helpless',
      'emoji': '🔧',
    },
    {
      'situation': 'You believe tomorrow will be better',
      'correctEmotion': 'Optimistic',
      'emoji': '🌅',
    },
    {
      'situation': 'You woke up on the wrong side',
      'correctEmotion': 'Grumpy',
      'emoji': '😾',
    },
    {
      'situation': 'You want to make new friends',
      'correctEmotion': 'Friendly',
      'emoji': '🤝',
    },
    {
      'situation': 'Everyone listens when you speak',
      'correctEmotion': 'Respected',
      'emoji': '🎤',
    },
    {
      'situation': 'You understand why your friend is sad',
      'correctEmotion': 'Empathetic',
      'emoji': '💗',
    },
  ];

  int currentQuizIndex = 0;
  int quizScore = 0;
  bool showQuizResult = false;
  bool _currentQuizTapped = false;

  void _resetProgress() {
    setState(() {
      _viewedEmotions.clear();
      _viewedQuiz.clear();
      selectedEmotion = 0;
      currentQuizIndex = 0;
      quizScore = 0;
      showQuizResult = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initTts();

    // Float animation like home screen
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _nextEmotion() {
    if (!_currentEmotionTapped) {
      return;
    }
    setState(() {
      selectedEmotion = (selectedEmotion + 1) % emotions.length;
      _currentEmotionTapped = false;
    });
  }

  void _previousEmotion() {
    setState(() {
      selectedEmotion =
          (selectedEmotion - 1 + emotions.length) % emotions.length;
      _viewedEmotions.add(selectedEmotion);
    });
    final emotion = emotions[selectedEmotion];
    _speakText('${emotion['name']}. ${emotion['description']}');
  }

  void _checkQuizAnswer(String emotion) {
    setState(() {
      _viewedQuiz.add(currentQuizIndex);
    });

    if (emotion == emotionQuiz[currentQuizIndex]['correctEmotion']) {
      setState(() => quizScore++);
      _speakText('Correct! That\'s right!');
    } else {
      _speakText(
        'Good try! The answer was ${emotionQuiz[currentQuizIndex]['correctEmotion']}',
      );
    }

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (currentQuizIndex < emotionQuiz.length - 1) {
          currentQuizIndex++;
          _currentQuizTapped = false;
        } else {
          showQuizResult = true;
        }
      });
    });
  }

  void _resetQuiz() {
    setState(() {
      currentQuizIndex = 0;
      quizScore = 0;
      showQuizResult = false;
      _viewedQuiz.clear();
      _currentQuizTapped = false;
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Widget _buildProgressBar(int viewed, int total) {
    final progress = total > 0 ? viewed / total : 0.0;
    final percentage = (progress * 100).round();
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
                '$viewed / $total ($percentage%)',
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
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
            ),
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
            " Emotions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _resetProgress,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              Tab(text: "Learn"),
              Tab(text: "Quiz"),
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
          child: TabBarView(children: [_buildLearnTab(), _buildQuizTab()]),
        ),
        bottomNavigationBar: const AdsScreen(),
      ),
    );
  }

  Widget _buildLearnTab() {
    final emotion = emotions[selectedEmotion];
    final isCompleted = _viewedEmotions.contains(selectedEmotion);
    final gradient = AppColors.getGradientForIndex(selectedEmotion);

    return Column(
      children: [
        _buildProgressBar(_viewedEmotions.length, emotions.length),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Main Emotion Card with float animation
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      TtsService.to.speak(emotions[selectedEmotion]['name']);
                      setState(() {
                        _viewedEmotions.add(selectedEmotion);
                        _currentEmotionTapped = true;
                      });
                      _speakText(
                        '${emotion['name']}. ${emotion['description']}',
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                          // Decorative circle
                          Positioned(
                            top: -20,
                            right: -20,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              // Emoji in circle
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    emotion['emoji'],
                                    style: const TextStyle(fontSize: 45),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                emotion['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                emotion['description'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),

                              // Examples
                              const Icon(
                                Icons.volume_up,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ],
                          ),
                          // Tick mark if completed
                          if (isCompleted)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _previousEmotion,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Previous"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _nextEmotion,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF56D97F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizTab() {
    if (showQuizResult) {
      return Center(
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quizScore >= emotionQuiz.length * 0.7 ? "🌟" : "💪",
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  quizScore >= emotionQuiz.length * 0.7
                      ? "Excellent!"
                      : "Good Try!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF764BA2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "You got $quizScore out of ${emotionQuiz.length} correct!",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _resetQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Try Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF56D97F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final quiz = emotionQuiz[currentQuizIndex];
    final isCompleted = _viewedQuiz.contains(currentQuizIndex);
    final gradient = AppColors.getGradientForIndex(currentQuizIndex);

    return Column(
      children: [
        _buildProgressBar(_viewedQuiz.length, emotionQuiz.length),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Question ${currentQuizIndex + 1}/${emotionQuiz.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentQuizTapped = true;
                      });
                      _speakText(quiz['situation']);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    quiz['emoji'],
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "How would you feel if...",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                quiz['situation'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              const Icon(
                                Icons.volume_up,
                                color: Colors.white70,
                                size: 24,
                              ),
                            ],
                          ),
                          if (isCompleted)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_currentQuizTapped)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children:
                        [
                          'Happy',
                          'Sad',
                          'Angry',
                          'Scared',
                          'Excited',
                          'Proud',
                          'Surprised',
                          'Worried',
                          'Calm',
                          'Shy',
                          'Lonely',
                          'Grateful',
                        ].map((emotionName) {
                          final emotionData = emotions.firstWhere(
                            (e) => e['name'] == emotionName,
                            orElse: () => {'emoji': '😊', 'name': emotionName},
                          );
                          final btnGradient = AppColors.getGradientForIndex(
                            emotions.indexWhere(
                              (e) => e['name'] == emotionName,
                            ),
                          );
                          return GestureDetector(
                            onTap: () => _checkQuizAnswer(emotionName),
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: btnGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: btnGradient[0].withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    emotionData['emoji'],
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    emotionName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
