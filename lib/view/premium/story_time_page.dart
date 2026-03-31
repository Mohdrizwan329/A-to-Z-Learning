import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class StoryTimePage extends StatefulWidget {
  const StoryTimePage({Key? key}) : super(key: key);

  @override
  State<StoryTimePage> createState() => _StoryTimePageState();
}

class _StoryTimePageState extends State<StoryTimePage> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isPlaying = false;
  int _currentStoryIndex = 0;
  int _currentPageIndex = 0;

  final List<Map<String, dynamic>> stories = [
    {
      'title': 'The Thirsty Crow',
      'icon': '🐦',
      'color': Color(0xFF4ECDC4),
      'moral': 'Where there is a will, there is a way.',
      'pages': [
        {
          'image': '🐦☀️🏜️',
          'text': 'Once upon a time, there was a crow. It was a very hot summer day. The crow was very thirsty.',
        },
        {
          'image': '🐦👀🏺',
          'text': 'The crow flew here and there looking for water. At last, he saw a pot. He flew down to see if there was any water inside.',
        },
        {
          'image': '🏺💧',
          'text': 'Yes! There was some water in the pot. But the water was very low. The crow could not reach it with his beak.',
        },
        {
          'image': '🐦🤔💡',
          'text': 'The crow thought and thought. Then he had a clever idea! He saw some pebbles lying nearby.',
        },
        {
          'image': '🐦⚪🏺',
          'text': 'The crow picked up the pebbles one by one with his beak. He dropped them into the pot.',
        },
        {
          'image': '🏺💧⬆️',
          'text': 'Slowly, the water rose up! The clever crow dropped more and more pebbles until the water came to the top.',
        },
        {
          'image': '🐦😊💧',
          'text': 'Finally, the crow drank the water happily. His clever thinking saved his life!',
        },
      ],
    },
    {
      'title': 'The Lion and the Mouse',
      'icon': '🦁',
      'color': Color(0xFFFF6B6B),
      'moral': 'A friend in need is a friend indeed.',
      'pages': [
        {
          'image': '🦁😴🌳',
          'text': 'Once upon a time, a big lion was sleeping under a tree in the forest.',
        },
        {
          'image': '🐭🦁',
          'text': 'A little mouse came running and climbed on the lion. The lion woke up!',
        },
        {
          'image': '🦁😠🐭',
          'text': 'The lion caught the mouse in his big paw. He was very angry!',
        },
        {
          'image': '🐭🙏🦁',
          'text': '"Please let me go!" said the mouse. "One day I will help you!" The lion laughed but let the mouse go.',
        },
        {
          'image': '🦁🪢😰',
          'text': 'After some days, the lion got caught in a hunter\'s net. He tried hard but could not escape.',
        },
        {
          'image': '🐭🦷🪢',
          'text': 'The little mouse heard the lion\'s roar. She ran to help and started biting the net with her sharp teeth.',
        },
        {
          'image': '🦁🐭❤️',
          'text': 'Soon, the lion was free! He thanked the little mouse. They became best friends forever.',
        },
      ],
    },
    {
      'title': 'The Tortoise and the Hare',
      'icon': '🐢',
      'color': Color(0xFF56D97F),
      'moral': 'Slow and steady wins the race.',
      'pages': [
        {
          'image': '🐰🐢',
          'text': 'Once there was a hare who was very proud. He always made fun of the slow tortoise.',
        },
        {
          'image': '🐰😤🐢',
          'text': '"You are so slow!" laughed the hare. The tortoise said, "Let\'s have a race and see who wins!"',
        },
        {
          'image': '🏁🐰🐢',
          'text': 'The race began! The hare ran very fast. The tortoise walked slowly but did not stop.',
        },
        {
          'image': '🐰😴🌳',
          'text': 'The hare was far ahead. "I have lots of time," he thought. He lay down under a tree and fell asleep.',
        },
        {
          'image': '🐢🚶',
          'text': 'The tortoise kept walking slowly. He did not stop even for a minute. Step by step, he moved forward.',
        },
        {
          'image': '🐢🏁',
          'text': 'The tortoise passed the sleeping hare and crossed the finish line!',
        },
        {
          'image': '🐰😱🐢🏆',
          'text': 'The hare woke up and ran fast, but it was too late! The tortoise had won the race!',
        },
      ],
    },
    {
      'title': 'The Greedy Dog',
      'icon': '🐕',
      'color': Color(0xFFFFAA5A),
      'moral': 'Greed leads to loss.',
      'pages': [
        {
          'image': '🐕🍖',
          'text': 'Once there was a dog. He found a piece of meat and was very happy.',
        },
        {
          'image': '🐕🌉',
          'text': 'The dog was crossing a bridge over a river. He looked down into the water.',
        },
        {
          'image': '🐕👀🐕',
          'text': 'He saw his own reflection in the water. But he thought it was another dog with meat!',
        },
        {
          'image': '🐕😠',
          'text': '"That dog has a bigger piece of meat! I want that too!" thought the greedy dog.',
        },
        {
          'image': '🐕🗣️💧',
          'text': 'The dog opened his mouth to bark at the other dog. His meat fell into the water!',
        },
        {
          'image': '🐕😢',
          'text': 'The meat sank into the river. The dog lost his own meat because of greed.',
        },
        {
          'image': '🐕🚫',
          'text': 'The dog was very sad. He learned that being greedy only leads to losing what we already have.',
        },
      ],
    },
    {
      'title': 'The Fox and the Grapes',
      'icon': '🦊',
      'color': Color(0xFFA78BFA),
      'moral': 'It is easy to despise what you cannot get.',
      'pages': [
        {
          'image': '🦊☀️',
          'text': 'One hot summer day, a fox was walking through the forest. He was very hungry.',
        },
        {
          'image': '🦊👀🍇',
          'text': 'The fox saw a beautiful bunch of grapes hanging from a vine. They looked so juicy and sweet!',
        },
        {
          'image': '🦊⬆️🍇',
          'text': 'The fox jumped high to reach the grapes. But they were too high!',
        },
        {
          'image': '🦊💨🍇',
          'text': 'He tried again and again. He jumped as high as he could, but could not reach the grapes.',
        },
        {
          'image': '🦊😤',
          'text': 'Finally, the fox was tired. He could not jump anymore.',
        },
        {
          'image': '🦊🚶🍇',
          'text': 'The fox walked away saying, "Those grapes are sour anyway! I don\'t want them!"',
        },
        {
          'image': '🦊💭',
          'text': 'But deep inside, the fox knew the grapes were sweet. He just could not get them.',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);

    flutterTts.setCompletionHandler(() {
      setState(() => _isPlaying = false);
    });
  }

  Future<void> _speakText(String text) async {
    if (_isPlaying) {
      await flutterTts.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      await flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _nextPage() {
    final story = stories[_currentStoryIndex];
    if (_currentPageIndex < (story['pages'] as List).length - 1) {
      setState(() => _currentPageIndex++);
    }
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      setState(() => _currentPageIndex--);
    }
  }

  void _selectStory(int index) {
    setState(() {
      _currentStoryIndex = index;
      _currentPageIndex = 0;
    });
    flutterTts.stop();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    final story = stories[_currentStoryIndex];
    final pages = story['pages'] as List;
    final currentPage = pages[_currentPageIndex];
    final color = story['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
          "Story Time",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
        child: Column(
          children: [
            // Story Selector
            _buildStorySelector(),
            // Story Content
            Expanded(
              child: _buildStoryContent(story, currentPage, color, pages.length),
            ),
            // Navigation
            _buildNavigation(pages.length, color),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildStorySelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          final isSelected = _currentStoryIndex == index;
          final color = story['color'] as Color;

          return GestureDetector(
            onTap: () {
              TtsService.to.speak(story['title']);
              _selectStory(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(story['icon'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  Text(
                    (story['title'] as String).split(' ').last,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoryContent(
    Map<String, dynamic> story,
    Map<String, dynamic> currentPage,
    Color color,
    int totalPages,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Story Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  story['title'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Page ${_currentPageIndex + 1} of $totalPages',
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Story Page Card
          GestureDetector(
            onTap: () => _speakText(currentPage['text']),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Image/Emoji Section
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        currentPage['image'],
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text
                  Text(
                    currentPage['text'],
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Listen Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isPlaying ? color : color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPlaying ? Icons.stop : Icons.volume_up,
                          color: _isPlaying ? Colors.white : color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isPlaying ? 'Stop' : 'Tap to Listen',
                          style: TextStyle(
                            color: _isPlaying ? Colors.white : color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Moral (show on last page)
          if (_currentPageIndex == totalPages - 1) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    '✨ Moral of the Story ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story['moral'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigation(int totalPages, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Previous Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentPageIndex > 0 ? _previousPage : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                disabledForegroundColor: Colors.white30,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Page Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentPageIndex + 1}/$totalPages',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Next Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentPageIndex < totalPages - 1 ? _nextPage : null,
              icon: const Text('Next'),
              label: const Icon(Icons.arrow_forward),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                disabledForegroundColor: Colors.white30,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
