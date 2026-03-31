import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class PronunciationPracticePage extends StatefulWidget {
  const PronunciationPracticePage({super.key});

  @override
  State<PronunciationPracticePage> createState() => _PronunciationPracticePageState();
}

class _PronunciationPracticePageState extends State<PronunciationPracticePage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  double speechRate = 0.4;

  final List<Map<String, dynamic>> vowelSounds = [
    {'letter': 'A', 'sound': 'æ', 'word': 'Apple', 'emoji': '🍎', 'color': Color(0xFFFF6B6B)},
    {'letter': 'E', 'sound': 'ɛ', 'word': 'Elephant', 'emoji': '🐘', 'color': Color(0xFF667EEA)},
    {'letter': 'I', 'sound': 'ɪ', 'word': 'Igloo', 'emoji': '🏠', 'color': Color(0xFF4ECDC4)},
    {'letter': 'O', 'sound': 'ɒ', 'word': 'Orange', 'emoji': '🍊', 'color': Color(0xFFFFAA5A)},
    {'letter': 'U', 'sound': 'ʌ', 'word': 'Umbrella', 'emoji': '☂️', 'color': Color(0xFFA78BFA)},
  ];

  final List<Map<String, dynamic>> consonantSounds = [
    {'letters': 'TH', 'words': ['Think', 'Thank', 'Three'], 'tip': 'Put tongue between teeth', 'emoji': '👅', 'color': Color(0xFF56D97F)},
    {'letters': 'SH', 'words': ['Ship', 'Shoe', 'Shell'], 'tip': 'Lips forward like kissing', 'emoji': '💋', 'color': Color(0xFFFF8E53)},
    {'letters': 'CH', 'words': ['Chair', 'Cheese', 'Child'], 'tip': 'Start with T, end with SH', 'emoji': '🧀', 'color': Color(0xFFFFD93D)},
    {'letters': 'R', 'words': ['Red', 'Rain', 'Run'], 'tip': 'Tongue curves back', 'emoji': '🌧️', 'color': Color(0xFF667EEA)},
    {'letters': 'L', 'words': ['Lion', 'Lamp', 'Love'], 'tip': 'Tongue touches roof', 'emoji': '🦁', 'color': Color(0xFFFF6B6B)},
    {'letters': 'W', 'words': ['Water', 'Wind', 'Wave'], 'tip': 'Round your lips', 'emoji': '💨', 'color': Color(0xFF4ECDC4)},
  ];

  final List<Map<String, dynamic>> tongTwisters = [
    {
      'title': 'Peter Piper',
      'text': 'Peter Piper picked a peck of pickled peppers',
      'focus': 'P sound',
      'emoji': '🌶️',
      'color': Color(0xFFFF6B6B),
    },
    {
      'title': 'She Sells',
      'text': 'She sells seashells by the seashore',
      'focus': 'S and SH sounds',
      'emoji': '🐚',
      'color': Color(0xFF4ECDC4),
    },
    {
      'title': 'Red Lorry',
      'text': 'Red lorry, yellow lorry',
      'focus': 'R and L sounds',
      'emoji': '🚗',
      'color': Color(0xFFFFD93D),
    },
    {
      'title': 'Toy Boat',
      'text': 'Toy boat, toy boat, toy boat',
      'focus': 'T and B sounds',
      'emoji': '⛵',
      'color': Color(0xFF667EEA),
    },
    {
      'title': 'Fuzzy Wuzzy',
      'text': 'Fuzzy Wuzzy was a bear',
      'focus': 'W and Z sounds',
      'emoji': '🐻',
      'color': Color(0xFFA78BFA),
    },
    {
      'title': 'Unique New York',
      'text': 'You know New York, you need New York',
      'focus': 'N and Y sounds',
      'emoji': '🗽',
      'color': Color(0xFF56D97F),
    },
  ];

  final List<Map<String, dynamic>> wordPairs = [
    {'word1': 'Ship', 'word2': 'Sheep', 'difference': 'Short I vs Long E', 'emoji': '🚢🐑'},
    {'word1': 'Bat', 'word2': 'Bet', 'difference': 'A vs E sound', 'emoji': '🦇🎰'},
    {'word1': 'Cat', 'word2': 'Cut', 'difference': 'A vs U sound', 'emoji': '🐱✂️'},
    {'word1': 'Pin', 'word2': 'Pen', 'difference': 'I vs E sound', 'emoji': '📌✏️'},
    {'word1': 'Full', 'word2': 'Fool', 'difference': 'Short U vs Long OO', 'emoji': '😊🤡'},
    {'word1': 'Red', 'word2': 'Led', 'difference': 'R vs L sound', 'emoji': '🔴💡'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(speechRate);
  }

  void _speakText(String text) async {
    await flutterTts.setSpeechRate(speechRate);
    flutterTts.speak(text);
  }

  void _speakSlow(String text) async {
    await flutterTts.setSpeechRate(0.2);
    await flutterTts.speak(text);
    await Future.delayed(const Duration(seconds: 2));
    await flutterTts.setSpeechRate(speechRate);
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              ),
          ),
        ),
        title: const Text("Pronunciation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Vowels", icon: Icon(Icons.record_voice_over, size: 20)),
            Tab(text: "Sounds", icon: Icon(Icons.mic, size: 20)),
            Tab(text: "Twisters", icon: Icon(Icons.loop, size: 20)),
            Tab(text: "Compare", icon: Icon(Icons.compare_arrows, size: 20)),
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
        child: Column(
          children: [
            // Speed Control
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.speed, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text("Speed:", style: TextStyle(color: Colors.white, fontSize: 14)),
                  Slider(
                    value: speechRate,
                    min: 0.1,
                    max: 0.6,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) {
                      setState(() => speechRate = value);
                    },
                  ),
                  Text(
                    speechRate < 0.3 ? "Slow" : speechRate < 0.5 ? "Normal" : "Fast",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVowelsTab(),
                  _buildSoundsTab(),
                  _buildTwistersTab(),
                  _buildCompareTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildVowelsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vowelSounds.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🔤", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Vowel Sounds", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("A, E, I, O, U - The singing letters!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final vowel = vowelSounds[index - 1];
        return GestureDetector(
          onTap: () {
            TtsService.to.speak(vowel['word']);
            _speakSlow("${vowel['letter']}. ${vowel['word']}");
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: vowel['color'].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [vowel['color'], vowel['color'].withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(vowel['letter'], style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(vowel['emoji'], style: const TextStyle(fontSize: 30)),
                          const SizedBox(width: 10),
                          Text(vowel['word'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: vowel['color'])),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: vowel['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text("Sound: /${vowel['sound']}/", style: TextStyle(fontSize: 14, color: vowel['color'])),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.volume_up, color: vowel['color'], size: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSoundsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consonantSounds.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("👄", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Consonant Sounds", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Learn tricky consonant combinations!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final sound = consonantSounds[index - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [sound['color'], sound['color'].withValues(alpha: 0.7)]),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Text(sound['emoji'], style: const TextStyle(fontSize: 35)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sound['letters'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(sound['tip'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: (sound['words'] as List<String>).map((word) {
                    return GestureDetector(
                      onTap: () {
                        TtsService.to.speak(word);
                        _speakSlow(word);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: sound['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sound['color'], width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(word, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: sound['color'])),
                            const SizedBox(width: 6),
                            Icon(Icons.volume_up, color: sound['color'], size: 18),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTwistersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tongTwisters.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("😜", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Tongue Twisters", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Fun phrases to practice sounds!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final twister = tongTwisters[index - 1];
        return GestureDetector(
          onTap: () {
            TtsService.to.speak(twister['title']);
            _speakText(twister['text']);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [twister['color'], twister['color'].withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: twister['color'].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(twister['emoji'], style: const TextStyle(fontSize: 40)),
                          const SizedBox(width: 12),
                          Text(twister['title'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        twister['text'],
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text("Focus: ${twister['focus']}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.volume_up, color: Colors.white),
                      SizedBox(width: 8),
                      Text("Tap to hear!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildCompareTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: wordPairs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("🔄", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Word Pairs", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Hear the difference between similar words!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final pair = wordPairs[index - 1];
        final colors = [
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
          [Color(0xFF56D97F), Color(0xFF11998E)],
          [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        ];
        final gradient = colors[(index - 1) % colors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: gradient[0].withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Text(pair['emoji'], style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        TtsService.to.speak(pair['word1']);
                        _speakSlow(pair['word1']);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradient),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(pair['word1'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("vs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        TtsService.to.speak(pair['word2']);
                        _speakSlow(pair['word2']);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [gradient[1], gradient[0]]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(pair['word2'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: gradient[0].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(pair['difference'], style: TextStyle(fontSize: 14, color: gradient[0], fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        );
      },
    );
  }
}
