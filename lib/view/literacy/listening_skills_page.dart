import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class ListeningSkillsPage extends StatefulWidget {
  const ListeningSkillsPage({super.key});

  @override
  State<ListeningSkillsPage> createState() => _ListeningSkillsPageState();
}

class _ListeningSkillsPageState extends State<ListeningSkillsPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int currentQuestionIndex = 0;
  int score = 0;
  bool hasPlayed = false;
  String? selectedAnswer;
  bool showResult = false;

  final List<Map<String, dynamic>> questions = [
    {
      'audio': 'What animal says meow?',
      'correctAnswer': '🐱',
      'options': ['🐱', '🐕', '🐦', '🐟'],
      'optionLabels': ['Cat', 'Dog', 'Bird', 'Fish'],
    },
    {
      'audio': 'What color is the sky?',
      'correctAnswer': '🔵',
      'options': ['🔴', '🔵', '🟢', '🟡'],
      'optionLabels': ['Red', 'Blue', 'Green', 'Yellow'],
    },
    {
      'audio': 'What do we use to write?',
      'correctAnswer': '✏️',
      'options': ['🍎', '✏️', '⚽', '🎸'],
      'optionLabels': ['Apple', 'Pencil', 'Ball', 'Guitar'],
    },
    {
      'audio': 'What fruit is yellow and curved?',
      'correctAnswer': '🍌',
      'options': ['🍎', '🍊', '🍌', '🍇'],
      'optionLabels': ['Apple', 'Orange', 'Banana', 'Grapes'],
    },
    {
      'audio': 'Where do fish live?',
      'correctAnswer': '🌊',
      'options': ['🏔️', '🌊', '🌲', '🏠'],
      'optionLabels': ['Mountain', 'Water', 'Forest', 'House'],
    },
    {
      'audio': 'What gives us light during the day?',
      'correctAnswer': '☀️',
      'options': ['🌙', '⭐', '☀️', '💡'],
      'optionLabels': ['Moon', 'Star', 'Sun', 'Lamp'],
    },
    {
      'audio': 'What do birds use to fly?',
      'correctAnswer': '🪽',
      'options': ['🦶', '🪽', '🖐️', '👂'],
      'optionLabels': ['Feet', 'Wings', 'Hands', 'Ears'],
    },
    {
      'audio': 'What season is very cold with snow?',
      'correctAnswer': '❄️',
      'options': ['☀️', '🌸', '🍂', '❄️'],
      'optionLabels': ['Summer', 'Spring', 'Autumn', 'Winter'],
    },
    {
      'audio': 'What do we wear on our feet?',
      'correctAnswer': '👟',
      'options': ['👒', '👟', '🧤', '👔'],
      'optionLabels': ['Hat', 'Shoes', 'Gloves', 'Shirt'],
    },
    {
      'audio': 'How many legs does a spider have?',
      'correctAnswer': '8️⃣',
      'options': ['4️⃣', '6️⃣', '8️⃣', '2️⃣'],
      'optionLabels': ['Four', 'Six', 'Eight', 'Two'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _playQuestion() async {
    await flutterTts.speak(questions[currentQuestionIndex]['audio']);
    setState(() => hasPlayed = true);
  }

  void _selectAnswer(String answer) {
    if (showResult || !hasPlayed) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    final correct = questions[currentQuestionIndex]['correctAnswer'];
    final isCorrect = selectedAnswer == correct;

    if (isCorrect) {
      score += 10;
      flutterTts.speak("Correct! Well done!");
    } else {
      flutterTts.speak("Oops! Try to listen more carefully next time.");
    }

    setState(() => showResult = true);
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex = 0;
        score = 0;
      }
      hasPlayed = false;
      selectedAnswer = null;
      showResult = false;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final options = question['options'] as List<String>;
    final optionLabels = question['optionLabels'] as List<String>;
    final correctAnswer = question['correctAnswer'];

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
        title: const Text("Listening Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
              const SizedBox(height: 20),
              // Progress
              Text(
                "Question ${currentQuestionIndex + 1} of ${questions.length}",
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: 30),
              // Play button
              ScaleTransition(
                scale: hasPlayed ? const AlwaysStoppedAnimation(1.0) : _pulseAnimation,
                child: GestureDetector(
                  onTap: _playQuestion,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: hasPlayed
                            ? [Color(0xFF56D97F), Color(0xFF11998E)]
                            : [Color(0xFFFFAA5A), Color(0xFFFF6B6B)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (hasPlayed ? Color(0xFF56D97F) : Color(0xFFFFAA5A)).withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          hasPlayed ? Icons.replay : Icons.volume_up,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hasPlayed ? "Play Again" : "Listen",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                hasPlayed ? "Select the correct answer" : "Tap to listen to the question",
                style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.9)),
              ),
              const Spacer(),
              // Options grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final label = optionLabels[index];
                    final isSelected = selectedAnswer == option;
                    final isCorrectOption = option == correctAnswer;

                    Color getBgColor() {
                      if (showResult) {
                        if (isCorrectOption) return Colors.green;
                        if (isSelected && !isCorrectOption) return Colors.red;
                      }
                      if (isSelected) return Color(0xFFFFD700);
                      return Colors.white;
                    }

                    return GestureDetector(
                      onTap: () => _selectAnswer(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: getBgColor(),
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected && !showResult
                              ? Border.all(color: Color(0xFFFFAA00), width: 4)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(option, style: const TextStyle(fontSize: 40)),
                            const SizedBox(height: 8),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: showResult && isCorrectOption
                                    ? Colors.white
                                    : (showResult && isSelected && !isCorrectOption)
                                        ? Colors.white
                                        : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              // Action button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: showResult
                      ? ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF56D97F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            currentQuestionIndex < questions.length - 1 ? "Next Question" : "Start Over",
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: (hasPlayed && selectedAnswer != null) ? _checkAnswer : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF56D97F),
                            disabledBackgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            hasPlayed
                                ? (selectedAnswer != null ? "Check Answer" : "Select an option")
                                : "Listen first",
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
