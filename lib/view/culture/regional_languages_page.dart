import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/services/tts_service.dart';

class RegionalLanguagesPage extends StatefulWidget {
  const RegionalLanguagesPage({super.key});

  @override
  State<RegionalLanguagesPage> createState() => _RegionalLanguagesPageState();
}

class _RegionalLanguagesPageState extends State<RegionalLanguagesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  int selectedLanguageIndex = 0;

  final List<Map<String, dynamic>> indianLanguages = [
    {'name': 'Hindi', 'script': 'Devanagari', 'emoji': '🇮🇳', 'hello': 'नमस्ते', 'pronunciation': 'Namaste', 'region': 'North India', 'letters': ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ']},
    {'name': 'Tamil', 'script': 'Tamil', 'emoji': '🏛️', 'hello': 'வணக்கம்', 'pronunciation': 'Vanakkam', 'region': 'Tamil Nadu', 'letters': ['அ', 'ஆ', 'இ', 'ஈ', 'உ', 'ஊ', 'எ', 'ஏ', 'ஐ', 'ஒ']},
    {'name': 'Telugu', 'script': 'Telugu', 'emoji': '🎬', 'hello': 'నమస్కారం', 'pronunciation': 'Namaskaram', 'region': 'Andhra Pradesh', 'letters': ['అ', 'ఆ', 'ఇ', 'ఈ', 'ఉ', 'ఊ', 'ఎ', 'ఏ', 'ఐ', 'ఒ']},
    {'name': 'Kannada', 'script': 'Kannada', 'emoji': '🌴', 'hello': 'ನಮಸ್ಕಾರ', 'pronunciation': 'Namaskara', 'region': 'Karnataka', 'letters': ['ಅ', 'ಆ', 'ಇ', 'ಈ', 'ಉ', 'ಊ', 'ಎ', 'ಏ', 'ಐ', 'ಒ']},
    {'name': 'Malayalam', 'script': 'Malayalam', 'emoji': '🥥', 'hello': 'നമസ്കാരം', 'pronunciation': 'Namaskaram', 'region': 'Kerala', 'letters': ['അ', 'ആ', 'ഇ', 'ഈ', 'ഉ', 'ഊ', 'എ', 'ഏ', 'ഐ', 'ഒ']},
    {'name': 'Bengali', 'script': 'Bengali', 'emoji': '🐅', 'hello': 'নমস্কার', 'pronunciation': 'Nomoshkar', 'region': 'West Bengal', 'letters': ['অ', 'আ', 'ই', 'ঈ', 'উ', 'ঊ', 'এ', 'ঐ', 'ও', 'ঔ']},
    {'name': 'Gujarati', 'script': 'Gujarati', 'emoji': '🦁', 'hello': 'નમસ્તે', 'pronunciation': 'Namaste', 'region': 'Gujarat', 'letters': ['અ', 'આ', 'ઇ', 'ઈ', 'ઉ', 'ઊ', 'એ', 'ઐ', 'ઓ', 'ઔ']},
    {'name': 'Marathi', 'script': 'Devanagari', 'emoji': '🏰', 'hello': 'नमस्कार', 'pronunciation': 'Namaskar', 'region': 'Maharashtra', 'letters': ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ']},
    {'name': 'Punjabi', 'script': 'Gurmukhi', 'emoji': '🌾', 'hello': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ', 'pronunciation': 'Sat Sri Akal', 'region': 'Punjab', 'letters': ['ੳ', 'ਅ', 'ੲ', 'ਸ', 'ਹ', 'ਕ', 'ਖ', 'ਗ', 'ਘ', 'ਙ']},
    {'name': 'Odia', 'script': 'Odia', 'emoji': '🛕', 'hello': 'ନମସ୍କାର', 'pronunciation': 'Namaskar', 'region': 'Odisha', 'letters': ['ଅ', 'ଆ', 'ଇ', 'ଈ', 'ଉ', 'ଊ', 'ଏ', 'ଐ', 'ଓ', 'ଔ']},
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
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ProgressService.to.markItemCompleted(ProgressService.kRegionalLanguages, _tabController.index);
      }
    });
    ProgressService.to.markItemCompleted(ProgressService.kRegionalLanguages, 0);
    initGridAnimations(this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  @override
  void dispose() {
    _tabController.dispose();
    disposeGridAnimations();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Indian Languages',
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(ProgressService.kRegionalLanguages);
              setState(() {});
            },
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelPadding: const EdgeInsets.symmetric(horizontal: 24),
        tabs: const [
          Tab(text: "Languages"),
          Tab(text: "Words"),
          Tab(text: "Numbers"),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            final progress = ProgressService.to.getProgressPercentage(ProgressService.kRegionalLanguages) / 100;
            final progressString = ProgressService.to.getProgressString(ProgressService.kRegionalLanguages);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progress', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                      Text('$progressString completed', style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress, minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLanguagesTab(),
                _buildWordsTab(),
                _buildNumbersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85,
      ),
      itemCount: indianLanguages.length,
      itemBuilder: (context, index) {
        final lang = indianLanguages[index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () {
              TtsService.to.speak(lang['name']);
              setState(() => selectedLanguageIndex = index);
              _speakText(lang['pronunciation']);
            },
            pulseAnimation: pulseAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang['emoji'], style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 4),
                  GradientCardText(text: lang['name'], fontSize: 13),
                  const SizedBox(height: 4),
                  Text(lang['hello'], style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('(${lang['pronunciation']})', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8))),
                ],
              ),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButton<int>(
              value: selectedLanguageIndex,
              dropdownColor: const Color(0xFF764BA2),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: indianLanguages.asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text("${entry.value['emoji']} ${entry.value['name']}"),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedLanguageIndex = value ?? 0),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.0,
            ),
            itemCount: commonWords.length,
            itemBuilder: (context, index) {
              final word = commonWords[index];
              final translation = index < wordList.length ? wordList[index] : '';
              final gradient = AppColors.getGradientForIndex(index);
              return buildFloatingItem(
                index: index,
                child: GradientCard(
                  gradient: gradient,
                  isSelected: false,
                  onTap: () => _speakText(translation),
                  pulseAnimation: pulseAnimation,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(word['emoji'], style: const TextStyle(fontSize: 30)),
                        const SizedBox(height: 4),
                        Text(word['english'], style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 4),
                        GradientCardText(text: translation, fontSize: 14),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNumbersTab() {
    final selectedLang = indianLanguages[selectedLanguageIndex];
    final langName = selectedLang['name'] as String;
    final numList = numberTranslations[langName] ?? [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButton<int>(
              value: selectedLanguageIndex,
              dropdownColor: const Color(0xFF764BA2),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: indianLanguages.asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text("${entry.value['emoji']} ${entry.value['name']}"),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedLanguageIndex = value ?? 0),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.0,
            ),
            itemCount: numbers.length,
            itemBuilder: (context, index) {
              final num = numbers[index];
              final translation = index < numList.length ? numList[index] : '';
              final gradient = AppColors.getGradientForIndex(index);
              return buildFloatingItem(
                index: index,
                child: GradientCard(
                  gradient: gradient,
                  isSelected: false,
                  onTap: () => _speakText(translation),
                  pulseAnimation: pulseAnimation,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(num['number'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(translation, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(num['english'], style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
