import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class ReadingFluencyPage extends StatefulWidget {
  const ReadingFluencyPage({super.key});

  @override
  State<ReadingFluencyPage> createState() => _ReadingFluencyPageState();
}

class _ReadingFluencyPageState extends State<ReadingFluencyPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentStoryIndex = 0;
  int currentSentenceIndex = 0;
  bool isReading = false;
  Set<int> completedSentences = {};

  final List<Map<String, dynamic>> stories = [
    {
      'title': 'The Happy Cat',
      'emoji': '🐱',
      'sentences': [
        'The cat is happy.',
        'It plays with a ball.',
        'The ball is red.',
        'The cat runs fast.',
        'It jumps up high.',
      ],
    },
    {
      'title': 'My Dog',
      'emoji': '🐕',
      'sentences': [
        'I have a dog.',
        'My dog is brown.',
        'It likes to run.',
        'We play in the park.',
        'I love my dog.',
      ],
    },
    {
      'title': 'The Sun',
      'emoji': '☀️',
      'sentences': [
        'The sun is bright.',
        'It comes up in the morning.',
        'The sun gives us light.',
        'It makes us warm.',
        'The sun goes down at night.',
      ],
    },
    {
      'title': 'My School',
      'emoji': '🏫',
      'sentences': [
        'I go to school.',
        'My school is big.',
        'I learn to read.',
        'I have many friends.',
        'I like my school.',
      ],
    },
    {
      'title': 'The Garden',
      'emoji': '🌻',
      'sentences': [
        'We have a garden.',
        'Flowers grow in it.',
        'The flowers are pretty.',
        'Bees come to visit.',
        'I water the plants.',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.35);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _readSentence(int index) async {
    final sentences = stories[currentStoryIndex]['sentences'] as List<String>;
    setState(() {
      currentSentenceIndex = index;
      isReading = true;
    });
    await flutterTts.speak(sentences[index]);
    setState(() {
      isReading = false;
      completedSentences.add(index);
    });
  }

  Future<void> _readFullStory() async {
    final sentences = stories[currentStoryIndex]['sentences'] as List<String>;
    setState(() => isReading = true);

    for (int i = 0; i < sentences.length; i++) {
      if (!isReading) break;
      setState(() => currentSentenceIndex = i);
      await flutterTts.speak(sentences[i]);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => completedSentences.add(i));
    }

    setState(() => isReading = false);
  }

  void _stopReading() {
    flutterTts.stop();
    setState(() => isReading = false);
  }

  void _nextStory() {
    setState(() {
      if (currentStoryIndex < stories.length - 1) {
        currentStoryIndex++;
      } else {
        currentStoryIndex = 0;
      }
      currentSentenceIndex = 0;
      completedSentences.clear();
    });
  }

  void _previousStory() {
    setState(() {
      if (currentStoryIndex > 0) {
        currentStoryIndex--;
      } else {
        currentStoryIndex = stories.length - 1;
      }
      currentSentenceIndex = 0;
      completedSentences.clear();
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = stories[currentStoryIndex];
    final sentences = currentStory['sentences'] as List<String>;

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
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text("Reading Fluency", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        child: SafeArea(
          child: Column(
            children: [
              // Story selector
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _previousStory,
                      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF764BA2)),
                    ),
                    Column(
                      children: [
                        Text(currentStory['emoji'], style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(
                          currentStory['title'],
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF764BA2)),
                        ),
                        Text(
                          "Story ${currentStoryIndex + 1} of ${stories.length}",
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _nextStory,
                      icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF764BA2)),
                    ),
                  ],
                ),
              ),
              // Read all button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: isReading ? _stopReading : _readFullStory,
                  icon: Icon(isReading ? Icons.stop : Icons.play_arrow, size: 28),
                  label: Text(isReading ? "Stop Reading" : "Read Full Story", style: const TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isReading ? Colors.red : Color(0xFF56D97F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Sentences
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sentences.length,
                  itemBuilder: (context, index) {
                    final isCurrentSentence = currentSentenceIndex == index && isReading;
                    final isCompleted = completedSentences.contains(index);

                    return GestureDetector(
                      onTap: isReading ? null : () => _readSentence(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCurrentSentence
                              ? Color(0xFFFFD700)
                              : isCompleted
                                  ? Colors.green.shade100
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: isCurrentSentence
                              ? Border.all(color: Color(0xFFFFAA00), width: 3)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isCompleted ? Colors.green : Color(0xFF764BA2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: isCompleted
                                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                                    : Text(
                                        "${index + 1}",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                sentences[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isCurrentSentence ? FontWeight.bold : FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.volume_up,
                              color: isCurrentSentence ? Color(0xFFFFAA00) : Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Progress
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "${completedSentences.length}/${sentences.length} sentences read",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }
}
