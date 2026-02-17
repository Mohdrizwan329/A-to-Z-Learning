import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class SpellingPracticePage extends StatefulWidget {
  const SpellingPracticePage({super.key});

  @override
  State<SpellingPracticePage> createState() => _SpellingPracticePageState();
}

class _SpellingPracticePageState extends State<SpellingPracticePage> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  int currentWordIndex = 0;
  int score = 0;
  bool showResult = false;
  bool isCorrect = false;
  String userInput = "";

  final List<Map<String, dynamic>> spellingWords = [
    {'word': 'APPLE', 'hint': 'A red fruit', 'emoji': '🍎'},
    {'word': 'BANANA', 'hint': 'A yellow fruit', 'emoji': '🍌'},
    {'word': 'CAT', 'hint': 'A pet that meows', 'emoji': '🐱'},
    {'word': 'DOG', 'hint': 'A pet that barks', 'emoji': '🐕'},
    {'word': 'ELEPHANT', 'hint': 'Big animal with trunk', 'emoji': '🐘'},
    {'word': 'FISH', 'hint': 'Lives in water', 'emoji': '🐟'},
    {'word': 'GIRL', 'hint': 'Young female', 'emoji': '👧'},
    {'word': 'HOUSE', 'hint': 'Place to live', 'emoji': '🏠'},
    {'word': 'ICE', 'hint': 'Frozen water', 'emoji': '🧊'},
    {'word': 'JAM', 'hint': 'Sweet spread', 'emoji': '🍯'},
    {'word': 'KITE', 'hint': 'Flies in the sky', 'emoji': '🪁'},
    {'word': 'LION', 'hint': 'King of jungle', 'emoji': '🦁'},
    {'word': 'MOON', 'hint': 'Shines at night', 'emoji': '🌙'},
    {'word': 'NEST', 'hint': 'Bird\'s home', 'emoji': '🪺'},
    {'word': 'ORANGE', 'hint': 'A citrus fruit', 'emoji': '🍊'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  Future<void> _speakWord() async {
    await flutterTts.speak(spellingWords[currentWordIndex]['word']);
  }

  void _checkSpelling() {
    final correctWord = spellingWords[currentWordIndex]['word'];
    isCorrect = userInput.toUpperCase().trim() == correctWord;
    if (isCorrect) {
      score += 10;
      flutterTts.speak("Correct! Well done!");
    } else {
      flutterTts.speak("Try again! The word is $correctWord");
    }
    setState(() => showResult = true);
  }

  void _nextWord() {
    setState(() {
      if (currentWordIndex < spellingWords.length - 1) {
        currentWordIndex++;
      } else {
        currentWordIndex = 0;
      }
      _textController.clear();
      userInput = "";
      showResult = false;
    });
  }

  void _resetCurrent() {
    setState(() {
      _textController.clear();
      userInput = "";
      showResult = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = spellingWords[currentWordIndex];

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
        title: const Text("Spelling Practice", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Progress indicator
                Text(
                  "Word ${currentWordIndex + 1} of ${spellingWords.length}",
                  style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 30),
                // Emoji display
                Text(currentWord['emoji'], style: const TextStyle(fontSize: 100)),
                const SizedBox(height: 20),
                // Hint
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Hint: ${currentWord['hint']}",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                // Listen button
                ElevatedButton.icon(
                  onPressed: _speakWord,
                  icon: const Icon(Icons.volume_up, size: 28),
                  label: const Text("Listen to Word", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFAA5A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 30),
                // Text input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: showResult
                        ? Border.all(color: isCorrect ? Colors.green : Colors.red, width: 3)
                        : null,
                  ),
                  child: TextField(
                    controller: _textController,
                    enabled: !showResult,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: "Type the word",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20, letterSpacing: 1),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    onChanged: (value) => userInput = value,
                  ),
                ),
                const SizedBox(height: 20),
                // Result message
                if (showResult)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isCorrect ? "Correct! 🎉" : "Answer: ${currentWord['word']}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                // Action buttons
                if (!showResult)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: userInput.isNotEmpty ? _checkSpelling : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF56D97F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Check Spelling", style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                if (showResult)
                  Row(
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
                          onPressed: _nextWord,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF56D97F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text("Next Word", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }
}
