import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class SentenceFormationPage extends StatefulWidget {
  const SentenceFormationPage({super.key});

  @override
  State<SentenceFormationPage> createState() => _SentenceFormationPageState();
}

class _SentenceFormationPageState extends State<SentenceFormationPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentSentenceIndex = 0;
  List<String> selectedWords = [];
  int score = 0;
  bool showResult = false;
  bool isCorrect = false;

  final List<Map<String, dynamic>> sentences = [
    {
      'sentence': 'The cat is sleeping',
      'emoji': '🐱😴',
      'words': ['The', 'cat', 'is', 'sleeping', 'dog', 'running'],
    },
    {
      'sentence': 'I love my mom',
      'emoji': '❤️👩',
      'words': ['I', 'love', 'my', 'mom', 'hate', 'dad'],
    },
    {
      'sentence': 'The sun is hot',
      'emoji': '☀️🔥',
      'words': ['The', 'sun', 'is', 'hot', 'cold', 'moon'],
    },
    {
      'sentence': 'Birds can fly',
      'emoji': '🐦✈️',
      'words': ['Birds', 'can', 'fly', 'swim', 'fish', 'run'],
    },
    {
      'sentence': 'I go to school',
      'emoji': '🎒🏫',
      'words': ['I', 'go', 'to', 'school', 'home', 'play'],
    },
    {
      'sentence': 'The apple is red',
      'emoji': '🍎',
      'words': ['The', 'apple', 'is', 'red', 'blue', 'banana'],
    },
    {
      'sentence': 'Dogs like bones',
      'emoji': '🐕🦴',
      'words': ['Dogs', 'like', 'bones', 'cats', 'hate', 'fish'],
    },
    {
      'sentence': 'I can read books',
      'emoji': '📚👦',
      'words': ['I', 'can', 'read', 'books', 'write', 'sing'],
    },
    {
      'sentence': 'The sky is blue',
      'emoji': '🌤️💙',
      'words': ['The', 'sky', 'is', 'blue', 'green', 'ground'],
    },
    {
      'sentence': 'We play games',
      'emoji': '🎮👫',
      'words': ['We', 'play', 'games', 'They', 'work', 'sleep'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _shuffleWords();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _shuffleWords() {
    sentences[currentSentenceIndex]['words'].shuffle();
  }

  void _selectWord(String word) {
    if (showResult) return;
    setState(() {
      selectedWords.add(word);
    });
  }

  void _removeWord(int index) {
    if (showResult) return;
    setState(() => selectedWords.removeAt(index));
  }

  void _checkSentence() {
    final correctSentence = sentences[currentSentenceIndex]['sentence'];
    final userSentence = selectedWords.join(' ');
    isCorrect = userSentence == correctSentence;

    if (isCorrect) {
      score += 15;
      flutterTts.speak("Excellent! $correctSentence");
    } else {
      flutterTts.speak("Try again!");
    }
    setState(() => showResult = true);
  }

  void _nextSentence() {
    setState(() {
      if (currentSentenceIndex < sentences.length - 1) {
        currentSentenceIndex++;
      } else {
        currentSentenceIndex = 0;
      }
      selectedWords.clear();
      showResult = false;
      _shuffleWords();
    });
  }

  void _resetCurrent() {
    setState(() {
      selectedWords.clear();
      showResult = false;
    });
  }

  void _speakSentence() {
    flutterTts.speak(sentences[currentSentenceIndex]['sentence']);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentData = sentences[currentSentenceIndex];
    final words = List<String>.from(currentData['words']);
    final correctWordCount = currentData['sentence'].split(' ').length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              ),
          ),
        ),
        title: const Text("Sentence Formation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Emoji hint
              Text(currentData['emoji'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                "Form a sentence!",
                style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.8)),
              ),
              // Hint button
              TextButton.icon(
                onPressed: _speakSentence,
                icon: const Icon(Icons.lightbulb, color: Colors.yellow),
                label: const Text("Listen to hint", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              // Selected words area
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(minHeight: 80),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: showResult
                      ? Border.all(color: isCorrect ? Colors.green : Colors.red, width: 3)
                      : null,
                ),
                child: selectedWords.isEmpty
                    ? Center(
                        child: Text(
                          "Tap words below to form sentence",
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedWords.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _removeWord(entry.key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: showResult
                                      ? (isCorrect
                                          ? [Colors.green.shade400, Colors.green.shade600]
                                          : [Colors.red.shade400, Colors.red.shade600])
                                      : [Color(0xFF667EEA), Color(0xFF764BA2)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 24),
              // Available words
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: words.map((word) {
                    final timesUsed = selectedWords.where((w) => w == word).length;
                    final timesAvailable = words.where((w) => w == word).length;
                    final isUsed = timesUsed >= timesAvailable;

                    return GestureDetector(
                      onTap: isUsed ? null : () => _selectWord(word),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isUsed
                                ? [Colors.grey.shade400, Colors.grey.shade500]
                                : [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          word,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isUsed ? Colors.grey.shade600 : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: showResult
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _resetCurrent,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text("Try Again", style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _nextSentence,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF56D97F),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selectedWords.length >= correctWordCount ? _checkSentence : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF56D97F),
                            disabledBackgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            selectedWords.length >= correctWordCount ? "Check Sentence" : "Select $correctWordCount words",
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }
}
