import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ConfidenceBuildingPage extends StatefulWidget {
  const ConfidenceBuildingPage({super.key});

  @override
  State<ConfidenceBuildingPage> createState() => _ConfidenceBuildingPageState();
}

class _ConfidenceBuildingPageState extends State<ConfidenceBuildingPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> affirmations = [
    {'text': 'I am brave and strong!', 'emoji': '💪'},
    {'text': 'I can do hard things!', 'emoji': '⭐'},
    {'text': 'I am kind and caring!', 'emoji': '💖'},
    {'text': 'I am smart and creative!', 'emoji': '🧠'},
    {'text': 'I am loved!', 'emoji': '🥰'},
    {'text': 'I am a good friend!', 'emoji': '🤝'},
    {'text': 'I believe in myself!', 'emoji': '✨'},
    {'text': 'I learn from mistakes!', 'emoji': '📚'},
    {'text': 'I am unique and special!', 'emoji': '🌈'},
    {'text': 'I can try new things!', 'emoji': '🚀'},
    {'text': 'I am worthy of good things!', 'emoji': '🏆'},
    {'text': 'I am helpful and kind!', 'emoji': '🙌'},
    {'text': 'I can solve problems!', 'emoji': '🧩'},
    {'text': 'I am a great learner!', 'emoji': '📖'},
    {'text': 'I make good choices!', 'emoji': '✅'},
    {'text': 'I am patient and calm!', 'emoji': '🧘'},
    {'text': 'I can be anything I want!', 'emoji': '🦸'},
    {'text': 'I am getting better every day!', 'emoji': '📈'},
    {'text': 'I am a good listener!', 'emoji': '👂'},
    {'text': 'I am grateful and happy!', 'emoji': '🙏'},
    {'text': 'I can make a difference!', 'emoji': '🌟'},
    {'text': 'I am proud of who I am!', 'emoji': '😊'},
    {'text': 'I can handle challenges!', 'emoji': '💎'},
    {'text': 'I spread happiness!', 'emoji': '☀️'},
    {'text': 'I am creative and imaginative!', 'emoji': '🎨'},
    {'text': 'I am a problem solver!', 'emoji': '🔧'},
    {'text': 'I can achieve my dreams!', 'emoji': '🌙'},
    {'text': 'I am important and valued!', 'emoji': '👑'},
    {'text': 'I make my family proud!', 'emoji': '👨‍👩‍👧'},
    {'text': 'I can do amazing things!', 'emoji': '🎯'},
    {'text': 'I am full of energy!', 'emoji': '⚡'},
    {'text': 'I am a superhero!', 'emoji': '🦸‍♂️'},
    {'text': 'I have a beautiful heart!', 'emoji': '❤️'},
    {'text': 'I am always improving!', 'emoji': '📊'},
    {'text': 'I respect everyone!', 'emoji': '🤗'},
    {'text': 'I am responsible!', 'emoji': '✊'},
    {'text': 'I make wise decisions!', 'emoji': '🦉'},
    {'text': 'I am generous!', 'emoji': '🎁'},
    {'text': 'I bring joy to others!', 'emoji': '🎈'},
    {'text': 'I am a winner!', 'emoji': '🥇'},
    {'text': 'I have great ideas!', 'emoji': '💡'},
    {'text': 'I am fearless!', 'emoji': '🦅'},
    {'text': 'I love learning!', 'emoji': '📝'},
    {'text': 'I am trustworthy!', 'emoji': '🔐'},
    {'text': 'I am adventurous!', 'emoji': '🗺️'},
    {'text': 'I shine bright!', 'emoji': '💫'},
    {'text': 'I am focused!', 'emoji': '🎯'},
    {'text': 'I never give up!', 'emoji': '🏋️'},
    {'text': 'I am a champion!', 'emoji': '🏅'},
  ];

  final List<Map<String, dynamic>> confidenceTips = [
    {
      'title': 'Stand Tall',
      'emoji': '🧍',
      'tip':
          'Good posture makes you feel strong! Stand straight with your shoulders back.',
    },
    {
      'title': 'Smile',
      'emoji': '😊',
      'tip': 'Smiling makes you and others feel happy! Try it now!',
    },
    {
      'title': 'Speak Up',
      'emoji': '🗣️',
      'tip': 'Your voice matters! Speak clearly so people can hear you.',
    },
    {
      'title': 'Try New Things',
      'emoji': '🌟',
      'tip': 'It\'s okay to be scared. Being brave means trying anyway!',
    },
    {
      'title': 'Make Eye Contact',
      'emoji': '👀',
      'tip': 'Look at people when you talk. It shows you\'re confident!',
    },
    {
      'title': 'Celebrate Wins',
      'emoji': '🎉',
      'tip': 'Be proud of yourself, even for small things!',
    },
    {
      'title': 'Practice Daily',
      'emoji': '📅',
      'tip': 'Do something small every day to build confidence!',
    },
    {
      'title': 'Be Positive',
      'emoji': '➕',
      'tip': 'Replace negative thoughts with positive ones!',
    },
    {
      'title': 'Accept Mistakes',
      'emoji': '🔄',
      'tip': 'Mistakes help you learn and grow stronger!',
    },
    {
      'title': 'Set Goals',
      'emoji': '🎯',
      'tip': 'Set small goals and achieve them one by one!',
    },
    {
      'title': 'Help Others',
      'emoji': '🤲',
      'tip': 'Helping others makes you feel good about yourself!',
    },
    {
      'title': 'Stay Calm',
      'emoji': '🧘',
      'tip': 'Take deep breaths when you feel nervous!',
    },
    {
      'title': 'Be Prepared',
      'emoji': '📋',
      'tip': 'Preparation helps you feel more confident!',
    },
    {
      'title': 'Ask Questions',
      'emoji': '❓',
      'tip': 'It\'s brave to ask when you don\'t understand!',
    },
    {
      'title': 'Be Yourself',
      'emoji': '🦋',
      'tip': 'You are special just the way you are!',
    },
    {
      'title': 'Use Strong Voice',
      'emoji': '📢',
      'tip': 'Speak with a clear and steady voice!',
    },
    {
      'title': 'Take Breaks',
      'emoji': '☕',
      'tip': 'Rest when you need to recharge your energy!',
    },
    {
      'title': 'Learn New Skills',
      'emoji': '🎓',
      'tip': 'Learning new things builds confidence!',
    },
    {
      'title': 'Stay Organized',
      'emoji': '📁',
      'tip': 'Being organized helps you feel in control!',
    },
    {
      'title': 'Face Your Fears',
      'emoji': '🦁',
      'tip': 'Facing fears makes them smaller over time!',
    },
    {
      'title': 'Be Patient',
      'emoji': '⏰',
      'tip': 'Good things take time. Be patient with yourself!',
    },
    {
      'title': 'Dress Well',
      'emoji': '👔',
      'tip': 'Looking good helps you feel good!',
    },
    {
      'title': 'Exercise',
      'emoji': '🏃',
      'tip': 'Moving your body makes you feel strong!',
    },
    {
      'title': 'Read Books',
      'emoji': '📚',
      'tip': 'Reading makes you smarter and more confident!',
    },
    {
      'title': 'Say Thank You',
      'emoji': '🙏',
      'tip': 'Gratitude makes you feel happy and positive!',
    },
    {
      'title': 'Make Friends',
      'emoji': '👫',
      'tip': 'Good friends support and encourage you!',
    },
    {
      'title': 'Share Ideas',
      'emoji': '💡',
      'tip': 'Your ideas are valuable. Share them!',
    },
    {
      'title': 'Stay Curious',
      'emoji': '🔍',
      'tip': 'Asking questions shows you want to learn!',
    },
    {
      'title': 'Keep Trying',
      'emoji': '💪',
      'tip': 'Never give up! Keep trying until you succeed!',
    },
    {
      'title': 'Believe in You',
      'emoji': '⭐',
      'tip': 'You can do anything you set your mind to!',
    },
    {
      'title': 'Listen Carefully',
      'emoji': '👂',
      'tip': 'Good listeners understand better and learn more!',
    },
    {
      'title': 'Be Honest',
      'emoji': '💎',
      'tip': 'Honesty builds trust and makes you stronger!',
    },
    {
      'title': 'Accept Compliments',
      'emoji': '🌸',
      'tip': 'Say thank you when someone praises you!',
    },
    {
      'title': 'Take Initiative',
      'emoji': '🚀',
      'tip': 'Start things without being told. Be a leader!',
    },
    {
      'title': 'Stay Focused',
      'emoji': '🎯',
      'tip': 'Concentrate on one thing at a time!',
    },
    {
      'title': 'Laugh Often',
      'emoji': '😂',
      'tip': 'Laughter reduces stress and boosts confidence!',
    },
    {
      'title': 'Eat Healthy',
      'emoji': '🥗',
      'tip': 'Healthy food gives you energy and clear thinking!',
    },
    {
      'title': 'Sleep Well',
      'emoji': '😴',
      'tip': 'Good sleep helps you feel fresh and confident!',
    },
    {
      'title': 'Practice Gratitude',
      'emoji': '🌻',
      'tip': 'Being thankful makes you happier and stronger!',
    },
    {
      'title': 'Visualize Success',
      'emoji': '🏆',
      'tip': 'Imagine yourself succeeding before you try!',
    },
    {
      'title': 'Speak Kindly',
      'emoji': '💬',
      'tip': 'Be nice to yourself and others with words!',
    },
    {
      'title': 'Embrace Change',
      'emoji': '🦋',
      'tip': 'Change helps you grow. Welcome it!',
    },
    {
      'title': 'Work Hard',
      'emoji': '⚒️',
      'tip': 'Hard work always pays off in the end!',
    },
    {
      'title': 'Stay Humble',
      'emoji': '🙏',
      'tip': 'Be proud but not boastful. Stay grounded!',
    },
    {
      'title': 'Create Art',
      'emoji': '🎨',
      'tip': 'Express yourself through drawing, music, or writing!',
    },
    {
      'title': 'Play Games',
      'emoji': '🎮',
      'tip': 'Playing teaches strategy and builds confidence!',
    },
    {
      'title': 'Explore Nature',
      'emoji': '🌳',
      'tip': 'Nature calms your mind and refreshes you!',
    },
    {
      'title': 'Be Punctual',
      'emoji': '⏱️',
      'tip': 'Being on time shows respect and responsibility!',
    },
    {
      'title': 'Celebrate Others',
      'emoji': '👏',
      'tip': 'Being happy for others makes you happier too!',
    },
  ];

  final List<Map<String, dynamic>> iCanStatements = [
    {'statement': 'I can ride a bike', 'emoji': '🚲'},
    {'statement': 'I can make friends', 'emoji': '👫'},
    {'statement': 'I can read a book', 'emoji': '📖'},
    {'statement': 'I can help others', 'emoji': '🤲'},
    {'statement': 'I can draw a picture', 'emoji': '🎨'},
    {'statement': 'I can sing a song', 'emoji': '🎵'},
    {'statement': 'I can count to 100', 'emoji': '🔢'},
    {'statement': 'I can tie my shoes', 'emoji': '👟'},
    {'statement': 'I can be kind', 'emoji': '💝'},
    {'statement': 'I can share', 'emoji': '🤝'},
    {'statement': 'I can swim', 'emoji': '🏊'},
    {'statement': 'I can dance', 'emoji': '💃'},
    {'statement': 'I can write my name', 'emoji': '✍️'},
    {'statement': 'I can play sports', 'emoji': '⚽'},
    {'statement': 'I can cook food', 'emoji': '🍳'},
    {'statement': 'I can clean my room', 'emoji': '🧹'},
    {'statement': 'I can speak English', 'emoji': '🗣️'},
    {'statement': 'I can use a computer', 'emoji': '💻'},
    {'statement': 'I can solve puzzles', 'emoji': '🧩'},
    {'statement': 'I can plant trees', 'emoji': '🌱'},
    {'statement': 'I can tell time', 'emoji': '⏰'},
    {'statement': 'I can brush my teeth', 'emoji': '🪥'},
    {'statement': 'I can say sorry', 'emoji': '🙇'},
    {'statement': 'I can say thank you', 'emoji': '🙏'},
    {'statement': 'I can make my bed', 'emoji': '🛏️'},
    {'statement': 'I can play music', 'emoji': '🎸'},
    {'statement': 'I can build things', 'emoji': '🏗️'},
    {'statement': 'I can run fast', 'emoji': '🏃'},
    {'statement': 'I can be a leader', 'emoji': '👑'},
    {'statement': 'I can learn anything', 'emoji': '🎓'},
    {'statement': 'I can climb a tree', 'emoji': '🌲'},
    {'statement': 'I can bake a cake', 'emoji': '🎂'},
    {'statement': 'I can play chess', 'emoji': '♟️'},
    {'statement': 'I can paint', 'emoji': '🖌️'},
    {'statement': 'I can take photos', 'emoji': '📷'},
    {'statement': 'I can fold paper', 'emoji': '📄'},
    {'statement': 'I can jump rope', 'emoji': '🪢'},
    {'statement': 'I can fly a kite', 'emoji': '🪁'},
    {'statement': 'I can catch a ball', 'emoji': '⚾'},
    {'statement': 'I can skate', 'emoji': '⛸️'},
    {'statement': 'I can garden', 'emoji': '🌷'},
    {'statement': 'I can do magic tricks', 'emoji': '🪄'},
    {'statement': 'I can tell jokes', 'emoji': '🤣'},
    {'statement': 'I can recite poems', 'emoji': '📜'},
    {'statement': 'I can speak Hindi', 'emoji': '🇮🇳'},
    {'statement': 'I can do yoga', 'emoji': '🧘'},
    {'statement': 'I can meditate', 'emoji': '🕯️'},
    {'statement': 'I can save money', 'emoji': '💰'},
    {'statement': 'I can be brave', 'emoji': '🦁'},
  ];

  int selectedAffirmation = 0;
  bool _currentAffirmationTapped = false;
  Set<int> _viewedAffirmations = {};
  Set<int> _viewedTips = {};
  Set<int> _viewedStatements = {};

  void _resetProgress() {
    setState(() {
      _viewedAffirmations.clear();
      _viewedTips.clear();
      _viewedStatements.clear();
      selectedAffirmation = 0;
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

  void _nextAffirmation() {
    if (!_currentAffirmationTapped) {
      return;
    }
    setState(() {
      selectedAffirmation = (selectedAffirmation + 1) % affirmations.length;
      _currentAffirmationTapped = false;
    });
  }

  void _previousAffirmation() {
    setState(() {
      selectedAffirmation =
          (selectedAffirmation - 1 + affirmations.length) % affirmations.length;
      _viewedAffirmations.add(selectedAffirmation);
    });
    _speakText(affirmations[selectedAffirmation]['text']);
  }

  void _viewTip(int index) {
    setState(() {
      _viewedTips.add(index);
    });
  }

  void _viewStatement(int index) {
    setState(() {
      _viewedStatements.add(index);
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
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  '$viewed / $total ($percentage%)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFAA5A),
                ],
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
            "Be Confident!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: GestureDetector(
                onTap: _resetProgress,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3.r,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
            tabs: [
              Tab(text: "Say It!"),
              Tab(text: "Tips"),
              Tab(text: "I Can!"),
            ],
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
              stops: [0.0, 0.3, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TabBarView(
            children: [
              _buildAffirmationsTab(),
              _buildTipsTab(),
              _buildICanTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAffirmationsTab() {
    final affirmation = affirmations[selectedAffirmation];
    final isCompleted = _viewedAffirmations.contains(selectedAffirmation);
    final gradient = AppColors.getGradientForIndex(selectedAffirmation);

    return Column(
      children: [
        _buildProgressBar(_viewedAffirmations.length, affirmations.length),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                // Main Affirmation Card with float animation
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
                      TtsService.to.speak(
                        affirmations[selectedAffirmation]['text'],
                      );
                      setState(() {
                        _viewedAffirmations.add(selectedAffirmation);
                        _currentAffirmationTapped = true;
                      });
                      _speakText(affirmation['text']);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32.r),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withValues(alpha: 0.4),
                            blurRadius: 12.r,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Decorative circle
                          Positioned(
                            top: -20.h,
                            right: -20.w,
                            child: Container(
                              width: 80.w,
                              height: 80.h,
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
                                width: 80.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    affirmation['emoji'],
                                    style: const TextStyle(fontSize: 45),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                affirmation['text'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              Icon(
                                Icons.volume_up,
                                color: Colors.white70,
                                size: 30.r,
                              ),
                            ],
                          ),
                          // Tick mark if completed
                          if (isCompleted)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _previousAffirmation,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Previous"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      ElevatedButton.icon(
                        onPressed: _nextAffirmation,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Next"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF56D97F),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsTab() {
    return Column(
      children: [
        _buildProgressBar(_viewedTips.length, confidenceTips.length),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: confidenceTips.length,
            itemBuilder: (context, index) {
              final tip = confidenceTips[index];
              final isCompleted = _viewedTips.contains(index);
              final gradient = AppColors.getGradientForIndex(index);

              return GestureDetector(
                onTap: () {
                  _viewTip(index);
                  _speakText("${tip['title']}. ${tip['tip']}");
                },
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    final offset = (index % 2 == 0)
                        ? _floatAnimation.value * 0.5
                        : -_floatAnimation.value * 0.5;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.3),
                          blurRadius: 8.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  topRight: Radius.circular(20.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        tip['emoji'],
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  Expanded(
                                    child: Text(
                                      tip['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.volume_up,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.r),
                              child: Text(
                                tip['tip'],
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Tick mark if completed
                        if (isCompleted)
                          Positioned(
                            top: 10.h,
                            right: 10.w,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16.r,
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
    );
  }

  Widget _buildICanTab() {
    return Column(
      children: [
        _buildProgressBar(_viewedStatements.length, iCanStatements.length),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.r,
                    crossAxisSpacing: 12.r,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: iCanStatements.length,
                  itemBuilder: (context, index) {
                    final statement = iCanStatements[index];
                    final gradient = AppColors.getGradientForIndex(index);
                    final isCompleted = _viewedStatements.contains(index);

                    return GestureDetector(
                      onTap: () {
                        _viewStatement(index);
                        _speakText(statement['statement']);
                      },
                      child: AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final offset = (index % 2 == 0)
                              ? _floatAnimation.value * 0.5
                              : -_floatAnimation.value * 0.5;
                          return Transform.translate(
                            offset: Offset(0, offset),
                            child: child,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.4),
                                blurRadius: 8.r,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Decorative circle like home screen
                              Positioned(
                                top: -15.h,
                                right: -15.w,
                                child: Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Emoji in circle like home screen
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          statement['emoji'],
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: Text(
                                        statement['statement'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Tick mark if completed
                              if (isCompleted)
                                Positioned(
                                  bottom: 6.h,
                                  right: 6.w,
                                  child: Container(
                                    padding: EdgeInsets.all(2.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14.r,
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
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "🌈 Remember!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "You are amazing just the way you are!",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Keep learning and growing!",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
