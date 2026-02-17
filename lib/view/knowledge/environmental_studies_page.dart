import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class EnvironmentalStudiesPage extends StatefulWidget {
  const EnvironmentalStudiesPage({super.key});

  @override
  State<EnvironmentalStudiesPage> createState() => _EnvironmentalStudiesPageState();
}

class _EnvironmentalStudiesPageState extends State<EnvironmentalStudiesPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  int selectedTopicIndex = -1;

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Save Water',
      'emoji': '💧',
      'color': Color(0xFF4ECDC4),
      'facts': [
        'Turn off tap while brushing teeth',
        'Take shorter showers',
        'Fix leaking taps',
        'Use a bucket instead of hose',
        'Collect rainwater for plants',
      ],
      'tip': 'Every drop counts! Save water for the future.',
    },
    {
      'title': 'Save Trees',
      'emoji': '🌳',
      'color': Color(0xFF56D97F),
      'facts': [
        'Trees give us oxygen to breathe',
        'Trees are home to many animals',
        'Plant more trees on Earth Day',
        'Use both sides of paper',
        'Trees help cool the earth',
      ],
      'tip': 'Trees are our best friends. Plant one today!',
    },
    {
      'title': 'Reduce Pollution',
      'emoji': '🏭',
      'color': Color(0xFF667EEA),
      'facts': [
        'Walk or cycle for short distances',
        'Use public transport',
        'Don\'t burn garbage',
        'Use electric vehicles',
        'Keep your surroundings clean',
      ],
      'tip': 'Clean air is healthy air!',
    },
    {
      'title': 'Recycling',
      'emoji': '♻️',
      'color': Color(0xFFFFAA5A),
      'facts': [
        'Separate wet and dry waste',
        'Recycle paper, plastic, and glass',
        'Make compost from food waste',
        'Reuse old items creatively',
        'Say no to single-use plastic',
      ],
      'tip': 'Reduce, Reuse, Recycle!',
    },
    {
      'title': 'Save Energy',
      'emoji': '💡',
      'color': Color(0xFFFF6B6B),
      'facts': [
        'Turn off lights when not needed',
        'Use LED bulbs',
        'Unplug chargers when done',
        'Use sunlight during the day',
        'Close doors to keep rooms cool/warm',
      ],
      'tip': 'Save energy, save money!',
    },
    {
      'title': 'Protect Animals',
      'emoji': '🦁',
      'color': Color(0xFFA78BFA),
      'facts': [
        'Don\'t litter in forests',
        'Never harm wild animals',
        'Support wildlife conservation',
        'Keep pets safe and healthy',
        'Don\'t buy products from endangered animals',
      ],
      'tip': 'Animals are our friends, not enemies!',
    },
  ];

  final List<Map<String, dynamic>> ecosystems = [
    {'name': 'Forest', 'emoji': '🌲', 'description': 'Home to trees and animals', 'color': Color(0xFF228B22)},
    {'name': 'Ocean', 'emoji': '🌊', 'description': 'Full of fish and corals', 'color': Color(0xFF1E90FF)},
    {'name': 'Desert', 'emoji': '🏜️', 'description': 'Hot and sandy with cacti', 'color': Color(0xFFDEB887)},
    {'name': 'Arctic', 'emoji': '🧊', 'description': 'Cold with polar bears', 'color': Color(0xFFADD8E6)},
    {'name': 'Grassland', 'emoji': '🌾', 'description': 'Open fields with zebras', 'color': Color(0xFF9ACD32)},
    {'name': 'Rainforest', 'emoji': '🌴', 'description': 'Wet with many species', 'color': Color(0xFF006400)},
  ];

  final List<Map<String, dynamic>> quizQuestions = [
    {'question': 'What should we save to help fish?', 'options': ['Water', 'Fire', 'Sand'], 'correct': 'Water'},
    {'question': 'What do trees give us?', 'options': ['Oxygen', 'Smoke', 'Dust'], 'correct': 'Oxygen'},
    {'question': 'What does ♻️ symbol mean?', 'options': ['Recycle', 'Danger', 'Stop'], 'correct': 'Recycle'},
    {'question': 'Which is a clean energy?', 'options': ['Solar', 'Coal', 'Oil'], 'correct': 'Solar'},
    {'question': 'Where do polar bears live?', 'options': ['Arctic', 'Desert', 'Forest'], 'correct': 'Arctic'},
  ];

  int currentQuizIndex = 0;
  String? selectedAnswer;
  bool showQuizResult = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _checkAnswer(String answer) {
    if (showQuizResult) return;
    setState(() {
      selectedAnswer = answer;
      showQuizResult = true;
      if (answer == quizQuestions[currentQuizIndex]['correct']) {
        score += 10;
        flutterTts.speak("Correct!");
      } else {
        flutterTts.speak("The answer is ${quizQuestions[currentQuizIndex]['correct']}");
      }
    });
  }

  void _nextQuiz() {
    setState(() {
      if (currentQuizIndex < quizQuestions.length - 1) {
        currentQuizIndex++;
      } else {
        currentQuizIndex = 0;
        score = 0;
      }
      selectedAnswer = null;
      showQuizResult = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text("Environment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Learn", icon: Icon(Icons.eco, size: 20)),
            Tab(text: "Ecosystems", icon: Icon(Icons.park, size: 20)),
            Tab(text: "Quiz", icon: Icon(Icons.quiz, size: 20)),
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
            _buildLearnTab(),
            _buildEcosystemsTab(),
            _buildQuizTab(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildLearnTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        final isExpanded = selectedTopicIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTopicIndex = isExpanded ? -1 : index;
            });
            _speakText(topic['title']);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [topic['color'], topic['color'].withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: topic['color'].withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(topic['emoji'], style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          topic['title'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                if (isExpanded)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          (topic['facts'] as List).length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("✓ ", style: TextStyle(color: Colors.white, fontSize: 16)),
                                Expanded(
                                  child: Text(
                                    topic['facts'][i],
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text("💡", style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  topic['tip'],
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEcosystemsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: ecosystems.length,
      itemBuilder: (context, index) {
        final ecosystem = ecosystems[index];
        return GestureDetector(
          onTap: () => _speakText("${ecosystem['name']}. ${ecosystem['description']}"),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ecosystem['color'], ecosystem['color'].withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: ecosystem['color'].withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ecosystem['emoji'], style: const TextStyle(fontSize: 50)),
                const SizedBox(height: 12),
                Text(
                  ecosystem['name'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    ecosystem['description'],
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.volume_up, color: Colors.white, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizTab() {
    final quiz = quizQuestions[currentQuizIndex];
    final options = quiz['options'] as List<String>;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text("🌍", style: TextStyle(fontSize: 50)),
                const SizedBox(height: 16),
                Text(
                  quiz['question'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF764BA2)),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Question ${currentQuizIndex + 1} of ${quizQuestions.length}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...options.map((option) {
            final isCorrect = option == quiz['correct'];
            final isSelected = selectedAnswer == option;

            Color bgColor = Colors.white;
            if (showQuizResult) {
              if (isCorrect) {
                bgColor = Colors.green;
              } else if (isSelected) {
                bgColor = Colors.red;
              }
            }

            return GestureDetector(
              onTap: () => _checkAnswer(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected && !showQuizResult ? Border.all(color: Color(0xFF764BA2), width: 3) : null,
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: showQuizResult && (isCorrect || isSelected) ? Colors.white : Color(0xFF764BA2),
                    ),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          if (showQuizResult)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF56D97F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(currentQuizIndex < quizQuestions.length - 1 ? "Next Question" : "Start Over", style: const TextStyle(fontSize: 18)),
              ),
            ),
        ],
      ),
    );
  }
}
