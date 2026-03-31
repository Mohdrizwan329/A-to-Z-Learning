import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class PhonicsPage extends StatefulWidget {
  const PhonicsPage({super.key});

  @override
  State<PhonicsPage> createState() => _PhonicsPageState();
}

class _PhonicsPageState extends State<PhonicsPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  int selectedIndex = -1;

  final List<Map<String, dynamic>> phonicsData = [
    {'letter': 'A', 'sound': 'æ', 'word': 'Apple', 'emoji': '🍎'},
    {'letter': 'B', 'sound': 'b', 'word': 'Ball', 'emoji': '⚽'},
    {'letter': 'C', 'sound': 'k', 'word': 'Cat', 'emoji': '🐱'},
    {'letter': 'D', 'sound': 'd', 'word': 'Dog', 'emoji': '🐕'},
    {'letter': 'E', 'sound': 'ɛ', 'word': 'Elephant', 'emoji': '🐘'},
    {'letter': 'F', 'sound': 'f', 'word': 'Fish', 'emoji': '🐟'},
    {'letter': 'G', 'sound': 'g', 'word': 'Grapes', 'emoji': '🍇'},
    {'letter': 'H', 'sound': 'h', 'word': 'House', 'emoji': '🏠'},
    {'letter': 'I', 'sound': 'ɪ', 'word': 'Ice cream', 'emoji': '🍦'},
    {'letter': 'J', 'sound': 'dʒ', 'word': 'Jug', 'emoji': '🫖'},
    {'letter': 'K', 'sound': 'k', 'word': 'Kite', 'emoji': '🪁'},
    {'letter': 'L', 'sound': 'l', 'word': 'Lion', 'emoji': '🦁'},
    {'letter': 'M', 'sound': 'm', 'word': 'Mango', 'emoji': '🥭'},
    {'letter': 'N', 'sound': 'n', 'word': 'Nest', 'emoji': '🪺'},
    {'letter': 'O', 'sound': 'ɒ', 'word': 'Orange', 'emoji': '🍊'},
    {'letter': 'P', 'sound': 'p', 'word': 'Parrot', 'emoji': '🦜'},
    {'letter': 'Q', 'sound': 'kw', 'word': 'Queen', 'emoji': '👸'},
    {'letter': 'R', 'sound': 'r', 'word': 'Rabbit', 'emoji': '🐰'},
    {'letter': 'S', 'sound': 's', 'word': 'Sun', 'emoji': '☀️'},
    {'letter': 'T', 'sound': 't', 'word': 'Tiger', 'emoji': '🐯'},
    {'letter': 'U', 'sound': 'ʌ', 'word': 'Umbrella', 'emoji': '☂️'},
    {'letter': 'V', 'sound': 'v', 'word': 'Van', 'emoji': '🚐'},
    {'letter': 'W', 'sound': 'w', 'word': 'Watch', 'emoji': '⌚'},
    {'letter': 'X', 'sound': 'ks', 'word': 'X-ray', 'emoji': '🩻'},
    {'letter': 'Y', 'sound': 'j', 'word': 'Yak', 'emoji': '🦬'},
    {'letter': 'Z', 'sound': 'z', 'word': 'Zebra', 'emoji': '🦓'},
  ];

  final List<List<Color>> gradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speakPhonics(String letter, String word) async {
    await flutterTts.speak("$letter says ${letter.toLowerCase()}, $letter for $word");
  }

  @override
  void dispose() {
    _floatController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Phonics',
      emoji: '🔤',
      bottomNavigationBar: const AdsScreen(),
      body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: phonicsData.length,
          itemBuilder: (context, index) {
            final item = phonicsData[index];
            final gradient = gradients[index % gradients.length];
            final isSelected = selectedIndex == index;

            return AnimatedBuilder(
              animation: _floatController,
              builder: (_, child) {
                final offset = (index % 2 == 0) ? _floatAnimation.value : -_floatAnimation.value;
                return Transform.translate(offset: Offset(0, offset), child: child);
              },
              child: GestureDetector(
                onTap: () {
                  TtsService.to.speak(item['word']);
                  setState(() => selectedIndex = index);
                  _speakPhonics(item['letter'], item['word']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected ? [Color(0xFFFFD700), Color(0xFFFFA500)] : gradient,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected ? Color(0xFFFFD700) : gradient[0]).withValues(alpha: 0.4),
                        blurRadius: isSelected ? 15 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['letter'], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("/${item['sound']}/", style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9))),
                      const SizedBox(height: 4),
                      Text(item['emoji'], style: const TextStyle(fontSize: 28)),
                      Text(item['word'], style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}
