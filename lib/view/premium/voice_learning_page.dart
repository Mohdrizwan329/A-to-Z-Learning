import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class VoiceLearningPage extends StatefulWidget {
  const VoiceLearningPage({Key? key}) : super(key: key);

  @override
  State<VoiceLearningPage> createState() => _VoiceLearningPageState();
}

class _VoiceLearningPageState extends State<VoiceLearningPage> {
  final FlutterTts flutterTts = FlutterTts();
  String _selectedCategory = 'alphabets';
  int _currentIndex = 0;
  bool _isSpeaking = false;
  double _speechRate = 0.4;
  String _selectedLanguage = 'en-US';

  final Map<String, List<Map<String, String>>> learningData = {
    'alphabets': List.generate(26, (i) {
      final letter = String.fromCharCode(65 + i);
      return {
        'item': letter,
        'phonetic': _getPhonetic(letter),
        'word': _getExampleWord(letter),
      };
    }),
    'numbers': List.generate(20, (i) {
      final num = i + 1;
      return {
        'item': num.toString(),
        'phonetic': _getNumberWord(num),
        'word': '$num ${_getNumberWord(num)}',
      };
    }),
    'animals': [
      {'item': '🦁', 'phonetic': 'Lion', 'word': 'The lion is the king of jungle'},
      {'item': '🐘', 'phonetic': 'Elephant', 'word': 'Elephant has a long trunk'},
      {'item': '🐕', 'phonetic': 'Dog', 'word': 'Dog is a faithful animal'},
      {'item': '🐈', 'phonetic': 'Cat', 'word': 'Cat says meow meow'},
      {'item': '🐄', 'phonetic': 'Cow', 'word': 'Cow gives us milk'},
      {'item': '🐎', 'phonetic': 'Horse', 'word': 'Horse runs very fast'},
      {'item': '🐒', 'phonetic': 'Monkey', 'word': 'Monkey loves bananas'},
      {'item': '🦊', 'phonetic': 'Fox', 'word': 'Fox is very clever'},
      {'item': '🐻', 'phonetic': 'Bear', 'word': 'Bear lives in forest'},
      {'item': '🐰', 'phonetic': 'Rabbit', 'word': 'Rabbit has long ears'},
    ],
    'colors': [
      {'item': '🔴', 'phonetic': 'Red', 'word': 'Apple is red in color'},
      {'item': '🔵', 'phonetic': 'Blue', 'word': 'Sky is blue'},
      {'item': '🟢', 'phonetic': 'Green', 'word': 'Leaves are green'},
      {'item': '🟡', 'phonetic': 'Yellow', 'word': 'Sun is yellow'},
      {'item': '🟠', 'phonetic': 'Orange', 'word': 'Orange fruit is orange'},
      {'item': '🟣', 'phonetic': 'Purple', 'word': 'Grapes are purple'},
      {'item': '⚪', 'phonetic': 'White', 'word': 'Milk is white'},
      {'item': '⚫', 'phonetic': 'Black', 'word': 'Night sky is black'},
      {'item': '🟤', 'phonetic': 'Brown', 'word': 'Chocolate is brown'},
      {'item': '💗', 'phonetic': 'Pink', 'word': 'Rose is pink'},
    ],
    'fruits': [
      {'item': '🍎', 'phonetic': 'Apple', 'word': 'An apple a day keeps doctor away'},
      {'item': '🍌', 'phonetic': 'Banana', 'word': 'Banana is yellow and sweet'},
      {'item': '🍇', 'phonetic': 'Grapes', 'word': 'Grapes grow in bunches'},
      {'item': '🍊', 'phonetic': 'Orange', 'word': 'Orange is rich in vitamin C'},
      {'item': '🍓', 'phonetic': 'Strawberry', 'word': 'Strawberry is red and tasty'},
      {'item': '🥭', 'phonetic': 'Mango', 'word': 'Mango is the king of fruits'},
      {'item': '🍉', 'phonetic': 'Watermelon', 'word': 'Watermelon is juicy'},
      {'item': '🍑', 'phonetic': 'Peach', 'word': 'Peach is soft and sweet'},
      {'item': '🍒', 'phonetic': 'Cherry', 'word': 'Cherry is small and red'},
      {'item': '🥝', 'phonetic': 'Kiwi', 'word': 'Kiwi is green inside'},
    ],
  };

  static String _getPhonetic(String letter) {
    final phonetics = {
      'A': 'A for Apple',
      'B': 'B for Ball',
      'C': 'C for Cat',
      'D': 'D for Dog',
      'E': 'E for Elephant',
      'F': 'F for Fish',
      'G': 'G for Goat',
      'H': 'H for Horse',
      'I': 'I for Ice cream',
      'J': 'J for Jug',
      'K': 'K for Kite',
      'L': 'L for Lion',
      'M': 'M for Monkey',
      'N': 'N for Nest',
      'O': 'O for Orange',
      'P': 'P for Parrot',
      'Q': 'Q for Queen',
      'R': 'R for Rabbit',
      'S': 'S for Sun',
      'T': 'T for Tiger',
      'U': 'U for Umbrella',
      'V': 'V for Van',
      'W': 'W for Watch',
      'X': 'X for Xylophone',
      'Y': 'Y for Yak',
      'Z': 'Z for Zebra',
    };
    return phonetics[letter] ?? letter;
  }

  static String _getExampleWord(String letter) {
    final words = {
      'A': 'Apple, Ant, Aeroplane',
      'B': 'Ball, Bat, Butterfly',
      'C': 'Cat, Car, Cake',
      'D': 'Dog, Duck, Drum',
      'E': 'Elephant, Egg, Eagle',
      'F': 'Fish, Flower, Fan',
      'G': 'Goat, Grass, Guitar',
      'H': 'Horse, House, Hat',
      'I': 'Ice cream, Ink, Island',
      'J': 'Jug, Jam, Jacket',
      'K': 'Kite, King, Kangaroo',
      'L': 'Lion, Lamp, Leaf',
      'M': 'Monkey, Moon, Mountain',
      'N': 'Nest, Nose, Notebook',
      'O': 'Orange, Owl, Octopus',
      'P': 'Parrot, Pen, Piano',
      'Q': 'Queen, Quilt, Question',
      'R': 'Rabbit, Rain, Rose',
      'S': 'Sun, Star, Snake',
      'T': 'Tiger, Tree, Train',
      'U': 'Umbrella, Unicorn, Up',
      'V': 'Van, Violin, Vase',
      'W': 'Watch, Water, Window',
      'X': 'Xylophone, X-ray, Box',
      'Y': 'Yak, Yellow, Yo-yo',
      'Z': 'Zebra, Zoo, Zero',
    };
    return words[letter] ?? '';
  }

  static String _getNumberWord(int num) {
    final words = [
      '', 'One', 'Two', 'Three', 'Four', 'Five',
      'Six', 'Seven', 'Eight', 'Nine', 'Ten',
      'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
      'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen', 'Twenty'
    ];
    return words[num];
  }

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage(_selectedLanguage);
    await flutterTts.setSpeechRate(_speechRate);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });

    flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await flutterTts.stop();
    }
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentData = learningData[_selectedCategory]!;
    final currentItem = currentData[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Voice Learning",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _showSettingsDialog,
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
        child: Column(
          children: [
            // Category Selector
            _buildCategorySelector(),
            // Main Content
            Expanded(
              child: _buildMainContent(currentItem),
            ),
            // Navigation Controls
            _buildNavigationControls(currentData.length),
            // Progress Indicator
            _buildProgressIndicator(currentData.length),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      {'id': 'alphabets', 'name': 'ABC', 'icon': '🔤'},
      {'id': 'numbers', 'name': '123', 'icon': '🔢'},
      {'id': 'animals', 'name': 'Animals', 'icon': '🦁'},
      {'id': 'colors', 'name': 'Colors', 'icon': '🎨'},
      {'id': 'fruits', 'name': 'Fruits', 'icon': '🍎'},
    ];

    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['id'];

          return GestureDetector(
            onTap: () {
              TtsService.to.speak(cat['name']!);
              setState(() {
                _selectedCategory = cat['id']!;
                _currentIndex = 0;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(cat['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    cat['name']!,
                    style: TextStyle(
                      color: isSelected ? Color(0xFF667EEA) : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main Item Card
          GestureDetector(
            onTap: () => _speak(item['phonetic']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _isSpeaking
                        ? Colors.blue.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.2),
                    blurRadius: _isSpeaking ? 30 : 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Speaking indicator
                  if (_isSpeaking)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.volume_up, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Speaking...',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  // Item display
                  Text(
                    item['item']!,
                    style: TextStyle(
                      fontSize: _selectedCategory == 'alphabets' ? 120 : 80,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF667EEA),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Phonetic text
                  Text(
                    item['phonetic']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Tap to hear
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.touch_app, color: Colors.grey, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Tap to hear',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Example/Sentence
          GestureDetector(
            onTap: () => _speak(item['word']!),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white30),
              ),
              child: Column(
                children: [
                  const Text(
                    'Example:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['word']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.volume_up, color: Colors.white60, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(int totalItems) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous Button
          _buildNavButton(
            icon: Icons.arrow_back_ios,
            onTap: _currentIndex > 0
                ? () => setState(() => _currentIndex--)
                : null,
          ),
          // Speak All Button
          GestureDetector(
            onTap: () => _speakAll(),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                _isSpeaking ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          // Next Button
          _buildNavButton(
            icon: Icons.arrow_forward_ios,
            onTap: _currentIndex < totalItems - 1
                ? () => setState(() => _currentIndex++)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white : Colors.white30,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: onTap != null ? Color(0xFF667EEA) : Colors.white54,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int totalItems) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} of $totalItems',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                '${((_currentIndex + 1) / totalItems * 100).round()}%',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / totalItems,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _speakAll() async {
    if (_isSpeaking) {
      await flutterTts.stop();
      return;
    }

    final currentData = learningData[_selectedCategory]!;
    final item = currentData[_currentIndex];
    await _speak('${item['phonetic']}. ${item['word']}');
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Voice Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Speech Rate
                  const Text('Speech Speed'),
                  Slider(
                    value: _speechRate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: _speechRate < 0.4
                        ? 'Slow'
                        : (_speechRate > 0.6 ? 'Fast' : 'Normal'),
                    onChanged: (value) {
                      setModalState(() => _speechRate = value);
                      setState(() {});
                      flutterTts.setSpeechRate(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Language
                  const Text('Language'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildLanguageChip('English (US)', 'en-US', setModalState),
                      _buildLanguageChip('English (UK)', 'en-GB', setModalState),
                      _buildLanguageChip('Hindi', 'hi-IN', setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF667EEA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageChip(String label, String langCode, StateSetter setModalState) {
    final isSelected = _selectedLanguage == langCode;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() => _selectedLanguage = langCode);
        setState(() {});
        flutterTts.setLanguage(langCode);
      },
      selectedColor: Color(0xFF667EEA),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
