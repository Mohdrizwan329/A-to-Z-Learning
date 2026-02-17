import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class RegionalLanguagesPage extends StatefulWidget {
  const RegionalLanguagesPage({super.key});

  @override
  State<RegionalLanguagesPage> createState() => _RegionalLanguagesPageState();
}

class _RegionalLanguagesPageState extends State<RegionalLanguagesPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  int selectedLanguageIndex = 0;

  final List<Map<String, dynamic>> indianLanguages = [
    {
      'name': 'Hindi',
      'script': 'Devanagari',
      'emoji': '🇮🇳',
      'color': Color(0xFFFF6B6B),
      'hello': 'नमस्ते',
      'pronunciation': 'Namaste',
      'region': 'North India',
      'letters': ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ'],
    },
    {
      'name': 'Tamil',
      'script': 'Tamil',
      'emoji': '🏛️',
      'color': Color(0xFF667EEA),
      'hello': 'வணக்கம்',
      'pronunciation': 'Vanakkam',
      'region': 'Tamil Nadu',
      'letters': ['அ', 'ஆ', 'இ', 'ஈ', 'உ', 'ஊ', 'எ', 'ஏ', 'ஐ', 'ஒ'],
    },
    {
      'name': 'Telugu',
      'script': 'Telugu',
      'emoji': '🎬',
      'color': Color(0xFF56D97F),
      'hello': 'నమస్కారం',
      'pronunciation': 'Namaskaram',
      'region': 'Andhra Pradesh & Telangana',
      'letters': ['అ', 'ఆ', 'ఇ', 'ఈ', 'ఉ', 'ఊ', 'ఎ', 'ఏ', 'ఐ', 'ఒ'],
    },
    {
      'name': 'Kannada',
      'script': 'Kannada',
      'emoji': '🌴',
      'color': Color(0xFFFFAA5A),
      'hello': 'ನಮಸ್ಕಾರ',
      'pronunciation': 'Namaskara',
      'region': 'Karnataka',
      'letters': ['ಅ', 'ಆ', 'ಇ', 'ಈ', 'ಉ', 'ಊ', 'ಎ', 'ಏ', 'ಐ', 'ಒ'],
    },
    {
      'name': 'Malayalam',
      'script': 'Malayalam',
      'emoji': '🥥',
      'color': Color(0xFFA78BFA),
      'hello': 'നമസ്കാരം',
      'pronunciation': 'Namaskaram',
      'region': 'Kerala',
      'letters': ['അ', 'ആ', 'ഇ', 'ഈ', 'ഉ', 'ഊ', 'എ', 'ഏ', 'ഐ', 'ഒ'],
    },
    {
      'name': 'Bengali',
      'script': 'Bengali',
      'emoji': '🐅',
      'color': Color(0xFF4ECDC4),
      'hello': 'নমস্কার',
      'pronunciation': 'Nomoshkar',
      'region': 'West Bengal',
      'letters': ['অ', 'আ', 'ই', 'ঈ', 'উ', 'ঊ', 'এ', 'ঐ', 'ও', 'ঔ'],
    },
    {
      'name': 'Gujarati',
      'script': 'Gujarati',
      'emoji': '🦁',
      'color': Color(0xFFFFD93D),
      'hello': 'નમસ્તે',
      'pronunciation': 'Namaste',
      'region': 'Gujarat',
      'letters': ['અ', 'આ', 'ઇ', 'ઈ', 'ઉ', 'ઊ', 'એ', 'ઐ', 'ઓ', 'ઔ'],
    },
    {
      'name': 'Marathi',
      'script': 'Devanagari',
      'emoji': '🏰',
      'color': Color(0xFFFF8E53),
      'hello': 'नमस्कार',
      'pronunciation': 'Namaskar',
      'region': 'Maharashtra',
      'letters': ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ'],
    },
    {
      'name': 'Punjabi',
      'script': 'Gurmukhi',
      'emoji': '🌾',
      'color': Color(0xFF00CED1),
      'hello': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ',
      'pronunciation': 'Sat Sri Akal',
      'region': 'Punjab',
      'letters': ['ੳ', 'ਅ', 'ੲ', 'ਸ', 'ਹ', 'ਕ', 'ਖ', 'ਗ', 'ਘ', 'ਙ'],
    },
    {
      'name': 'Odia',
      'script': 'Odia',
      'emoji': '🛕',
      'color': Color(0xFF9B59B6),
      'hello': 'ନମସ୍କାର',
      'pronunciation': 'Namaskar',
      'region': 'Odisha',
      'letters': ['ଅ', 'ଆ', 'ଇ', 'ଈ', 'ଉ', 'ଊ', 'ଏ', 'ଐ', 'ଓ', 'ଔ'],
    },
  ];

  final List<Map<String, dynamic>> commonWords = [
    {'english': 'Hello', 'emoji': '👋'},
    {'english': 'Thank You', 'emoji': '🙏'},
    {'english': 'Water', 'emoji': '💧'},
    {'english': 'Food', 'emoji': '🍽️'},
    {'english': 'Mother', 'emoji': '👩'},
    {'english': 'Father', 'emoji': '👨'},
    {'english': 'Friend', 'emoji': '👫'},
    {'english': 'Love', 'emoji': '❤️'},
  ];

  final Map<String, List<String>> translations = {
    'Hindi': ['नमस्ते', 'धन्यवाद', 'पानी', 'खाना', 'माँ', 'पिताजी', 'दोस्त', 'प्यार'],
    'Tamil': ['வணக்கம்', 'நன்றி', 'தண்ணீர்', 'உணவு', 'அம்மா', 'அப்பா', 'நண்பர்', 'காதல்'],
    'Telugu': ['నమస్కారం', 'ధన్యవాదాలు', 'నీళ్ళు', 'భోజనం', 'అమ్మ', 'నాన్న', 'స్నేహితుడు', 'ప్రేమ'],
    'Kannada': ['ನಮಸ್ಕಾರ', 'ಧನ್ಯವಾದ', 'ನೀರು', 'ಊಟ', 'ಅಮ್ಮ', 'ಅಪ್ಪ', 'ಸ್ನೇಹಿತ', 'ಪ್ರೀತಿ'],
    'Malayalam': ['നമസ്കാരം', 'നന്ദി', 'വെള്ളം', 'ഭക്ഷണം', 'അമ്മ', 'അച്ഛൻ', 'സുഹൃത്ത്', 'സ്നേഹം'],
    'Bengali': ['নমস্কার', 'ধন্যবাদ', 'জল', 'খাবার', 'মা', 'বাবা', 'বন্ধু', 'ভালোবাসা'],
    'Gujarati': ['નમસ્તે', 'આભાર', 'પાણી', 'ખોરાક', 'મા', 'પિતા', 'મિત્ર', 'પ્રેમ'],
    'Marathi': ['नमस्कार', 'धन्यवाद', 'पाणी', 'जेवण', 'आई', 'वडील', 'मित्र', 'प्रेम'],
    'Punjabi': ['ਸਤ ਸ੍ਰੀ ਅਕਾਲ', 'ਧੰਨਵਾਦ', 'ਪਾਣੀ', 'ਭੋਜਨ', 'ਮਾਂ', 'ਪਿਤਾ', 'ਦੋਸਤ', 'ਪਿਆਰ'],
    'Odia': ['ନମସ୍କାର', 'ଧନ୍ୟବାଦ', 'ପାଣି', 'ଖାଦ୍ୟ', 'ମା', 'ବାପା', 'ବନ୍ଧୁ', 'ପ୍ରେମ'],
  };

  final List<Map<String, dynamic>> numbers = [
    {'number': '1', 'english': 'One'},
    {'number': '2', 'english': 'Two'},
    {'number': '3', 'english': 'Three'},
    {'number': '4', 'english': 'Four'},
    {'number': '5', 'english': 'Five'},
    {'number': '6', 'english': 'Six'},
    {'number': '7', 'english': 'Seven'},
    {'number': '8', 'english': 'Eight'},
    {'number': '9', 'english': 'Nine'},
    {'number': '10', 'english': 'Ten'},
  ];

  final Map<String, List<String>> numberTranslations = {
    'Hindi': ['एक', 'दो', 'तीन', 'चार', 'पांच', 'छह', 'सात', 'आठ', 'नौ', 'दस'],
    'Tamil': ['ஒன்று', 'இரண்டு', 'மூன்று', 'நான்கு', 'ஐந்து', 'ஆறு', 'ஏழு', 'எட்டு', 'ஒன்பது', 'பத்து'],
    'Telugu': ['ఒకటి', 'రెండు', 'మూడు', 'నాలుగు', 'ఐదు', 'ఆరు', 'ఏడు', 'ఎనిమిది', 'తొమ్మిది', 'పది'],
    'Kannada': ['ಒಂದು', 'ಎರಡು', 'ಮೂರು', 'ನಾಲ್ಕು', 'ಐದು', 'ಆರು', 'ಏಳು', 'ಎಂಟು', 'ಒಂಬತ್ತು', 'ಹತ್ತು'],
    'Malayalam': ['ഒന്ന്', 'രണ്ട്', 'മൂന്ന്', 'നാല്', 'അഞ്ച്', 'ആറ്', 'ഏഴ്', 'എട്ട്', 'ഒൻപത്', 'പത്ത്'],
    'Bengali': ['এক', 'দুই', 'তিন', 'চার', 'পাঁচ', 'ছয়', 'সাত', 'আট', 'নয়', 'দশ'],
    'Gujarati': ['એક', 'બે', 'ત્રણ', 'ચાર', 'પાંચ', 'છ', 'સાત', 'આઠ', 'નવ', 'દસ'],
    'Marathi': ['एक', 'दोन', 'तीन', 'चार', 'पाच', 'सहा', 'सात', 'आठ', 'नऊ', 'दहा'],
    'Punjabi': ['ਇੱਕ', 'ਦੋ', 'ਤਿੰਨ', 'ਚਾਰ', 'ਪੰਜ', 'ਛੇ', 'ਸੱਤ', 'ਅੱਠ', 'ਨੌਂ', 'ਦਸ'],
    'Odia': ['ଏକ', 'ଦୁଇ', 'ତିନି', 'ଚାରି', 'ପାଞ୍ଚ', 'ଛଅ', 'ସାତ', 'ଆଠ', 'ନଅ', 'ଦଶ'],
  };

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
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
        title: const Text("Indian Languages", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Languages", icon: Icon(Icons.language, size: 20)),
            Tab(text: "Words", icon: Icon(Icons.text_fields, size: 20)),
            Tab(text: "Numbers", icon: Icon(Icons.numbers, size: 20)),
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
            _buildLanguagesTab(),
            _buildWordsTab(),
            _buildNumbersTab(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildLanguagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: indianLanguages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const Text("📚", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text("Languages of India", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Learn to say Hello in 10 languages!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final lang = indianLanguages[index - 1];
        return GestureDetector(
          onTap: () {
            setState(() => selectedLanguageIndex = index - 1);
            _speakText(lang['pronunciation']);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: lang['color'].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [lang['color'], lang['color'].withValues(alpha: 0.7)]),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Text(lang['emoji'], style: const TextStyle(fontSize: 30)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lang['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("${lang['script']} Script • ${lang['region']}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(lang['hello'], style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: lang['color'])),
                      const SizedBox(height: 4),
                      Text("(${lang['pronunciation']})", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: (lang['letters'] as List<String>).map((letter) {
                          return Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: lang['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text(letter, style: TextStyle(fontSize: 18, color: lang['color']))),
                          );
                        }).toList(),
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

  Widget _buildWordsTab() {
    final selectedLang = indianLanguages[selectedLanguageIndex];
    final langName = selectedLang['name'] as String;
    final wordList = translations[langName] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("💬", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          const Text("Common Words", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Language Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<int>(
              value: selectedLanguageIndex,
              dropdownColor: Color(0xFF764BA2),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: indianLanguages.asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text("${entry.value['emoji']} ${entry.value['name']}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedLanguageIndex = value ?? 0);
              },
            ),
          ),
          const SizedBox(height: 20),

          // Words Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: commonWords.length,
            itemBuilder: (context, index) {
              final word = commonWords[index];
              final translation = index < wordList.length ? wordList[index] : '';

              return GestureDetector(
                onTap: () => _speakText(translation),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(word['emoji'], style: const TextStyle(fontSize: 35)),
                      const SizedBox(height: 8),
                      Text(word['english'], style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(translation, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: selectedLang['color'])),
                      const SizedBox(height: 4),
                      Icon(Icons.volume_up, size: 18, color: selectedLang['color']),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumbersTab() {
    final selectedLang = indianLanguages[selectedLanguageIndex];
    final langName = selectedLang['name'] as String;
    final numList = numberTranslations[langName] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🔢", style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          const Text("Numbers 1-10", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Language Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<int>(
              value: selectedLanguageIndex,
              dropdownColor: Color(0xFF764BA2),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: indianLanguages.asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text("${entry.value['emoji']} ${entry.value['name']}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedLanguageIndex = value ?? 0);
              },
            ),
          ),
          const SizedBox(height: 20),

          // Numbers Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: numbers.length,
            itemBuilder: (context, index) {
              final num = numbers[index];
              final translation = index < numList.length ? numList[index] : '';
              final colors = [
                Color(0xFF4ECDC4), Color(0xFFFF6B6B), Color(0xFF667EEA),
                Color(0xFFFFAA5A), Color(0xFF56D97F), Color(0xFFA78BFA),
                Color(0xFFFFD93D), Color(0xFFFF8E53), Color(0xFF00CED1),
                Color(0xFF9B59B6),
              ];

              return GestureDetector(
                onTap: () => _speakText(translation),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [colors[index], colors[index].withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: colors[index].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(num['number'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(translation, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(num['english'], style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
