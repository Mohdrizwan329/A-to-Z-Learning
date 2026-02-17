import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class SightWordsPage extends StatefulWidget {
  const SightWordsPage({super.key});

  @override
  State<SightWordsPage> createState() => _SightWordsPageState();
}

class _SightWordsPageState extends State<SightWordsPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  int currentLevel = 0;
  Set<int> learnedWords = {};

  final List<Map<String, dynamic>> levels = [
    {
      'name': 'Pre-K',
      'color': Color(0xFF4ECDC4),
      'words': ['a', 'and', 'away', 'big', 'blue', 'can', 'come', 'down', 'find', 'for', 'funny', 'go', 'help', 'here', 'I', 'in', 'is', 'it', 'jump', 'little'],
    },
    {
      'name': 'Kindergarten',
      'color': Color(0xFFFF6B6B),
      'words': ['all', 'am', 'are', 'at', 'ate', 'be', 'black', 'brown', 'but', 'came', 'did', 'do', 'eat', 'four', 'get', 'good', 'have', 'he', 'into', 'like'],
    },
    {
      'name': 'Grade 1',
      'color': Color(0xFFFFAA5A),
      'words': ['after', 'again', 'an', 'any', 'ask', 'as', 'by', 'could', 'every', 'fly', 'from', 'give', 'going', 'had', 'has', 'her', 'him', 'his', 'how', 'just'],
    },
    {
      'name': 'Grade 2',
      'color': Color(0xFFA78BFA),
      'words': ['always', 'around', 'because', 'been', 'before', 'best', 'both', 'buy', 'call', 'cold', 'does', 'done', 'fast', 'first', 'found', 'gave', 'goes', 'green', 'its', 'made'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  Future<void> _speakWord(String word) async {
    await flutterTts.speak(word);
  }

  @override
  void dispose() {
    _floatController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWords = levels[currentLevel]['words'] as List<String>;
    final levelColor = levels[currentLevel]['color'] as Color;

    return GradientScaffold(
      title: 'Sight Words',
      emoji: '👀',
      bottomNavigationBar: const AdsScreen(),
      body: Column(
          children: [
            // Level selector
            Container(
              height: 60,
              margin: const EdgeInsets.all(12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  final isSelected = currentLevel == index;
                  return GestureDetector(
                    onTap: () => setState(() {
                      currentLevel = index;
                      learnedWords.clear();
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? level['color'] : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      ),
                      child: Center(
                        child: Text(
                          level['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text("${learnedWords.length}/${currentWords.length} learned", style: const TextStyle(color: Colors.white70)),
                  const Spacer(),
                  Text("⭐ ${learnedWords.length * 5} pts", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Words grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: currentWords.length,
                itemBuilder: (context, index) {
                  final word = currentWords[index];
                  final isLearned = learnedWords.contains(index);

                  return AnimatedBuilder(
                    animation: _floatController,
                    builder: (_, child) {
                      final offset = (index % 2 == 0) ? _floatAnimation.value : -_floatAnimation.value;
                      return Transform.translate(offset: Offset(0, offset), child: child);
                    },
                    child: GestureDetector(
                      onTap: () {
                        _speakWord(word);
                        setState(() => learnedWords.add(index));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isLearned
                                ? [Color(0xFF56D97F), Color(0xFF81E89E)]
                                : [levelColor, levelColor.withValues(alpha: 0.7)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: levelColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                word,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (isLearned)
                              const Positioned(
                                top: 4,
                                right: 4,
                                child: Icon(Icons.check_circle, color: Colors.white, size: 16),
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
        ),
    );
  }
}
