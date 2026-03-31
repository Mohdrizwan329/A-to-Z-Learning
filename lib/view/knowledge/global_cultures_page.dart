import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/services/tts_service.dart';

class GlobalCulturesPage extends StatefulWidget {
  const GlobalCulturesPage({super.key});

  @override
  State<GlobalCulturesPage> createState() => _GlobalCulturesPageState();
}

class _GlobalCulturesPageState extends State<GlobalCulturesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> cultures = [
    {'name': 'Indian Culture', 'emoji': '🇮🇳', 'greeting': 'Namaste!', 'greetingPronunciation': 'nah-mah-stay', 'food': ['Curry', 'Biryani', 'Samosa', 'Naan'], 'festival': 'Diwali - Festival of Lights', 'clothing': 'Saree & Kurta', 'music': 'Classical & Bollywood', 'funFact': 'India has 22 official languages!', 'dance': 'Bharatanatyam, Kathak'},
    {'name': 'Japanese Culture', 'emoji': '🇯🇵', 'greeting': 'Konnichiwa!', 'greetingPronunciation': 'kon-nee-chee-wah', 'food': ['Sushi', 'Ramen', 'Tempura', 'Mochi'], 'festival': 'Hanami - Cherry Blossom Festival', 'clothing': 'Kimono', 'music': 'Traditional & J-Pop', 'funFact': 'Bowing is a common greeting in Japan!', 'dance': 'Kabuki, Bon Odori'},
    {'name': 'Mexican Culture', 'emoji': '🇲🇽', 'greeting': 'Hola!', 'greetingPronunciation': 'oh-lah', 'food': ['Tacos', 'Burritos', 'Quesadilla', 'Churros'], 'festival': 'Dia de los Muertos', 'clothing': 'Sombrero & Serape', 'music': 'Mariachi', 'funFact': 'Mexico gave the world chocolate!', 'dance': 'Jarabe Tapatio'},
    {'name': 'Chinese Culture', 'emoji': '🇨🇳', 'greeting': 'Ni hao!', 'greetingPronunciation': 'nee-how', 'food': ['Dumplings', 'Noodles', 'Dim Sum', 'Rice'], 'festival': 'Chinese New Year', 'clothing': 'Cheongsam & Hanfu', 'music': 'Traditional Chinese Opera', 'funFact': 'Dragons are symbols of good luck!', 'dance': 'Dragon Dance, Lion Dance'},
    {'name': 'African Culture', 'emoji': '🌍', 'greeting': 'Jambo!', 'greetingPronunciation': 'jahm-boh', 'food': ['Jollof Rice', 'Fufu', 'Injera', 'Bobotie'], 'festival': 'Kwanzaa - Harvest Festival', 'clothing': 'Dashiki & Kente cloth', 'music': 'Drums & Afrobeats', 'funFact': 'Africa has over 2,000 languages!', 'dance': 'Traditional Tribal Dances'},
    {'name': 'French Culture', 'emoji': '🇫🇷', 'greeting': 'Bonjour!', 'greetingPronunciation': 'bohn-zhoor', 'food': ['Croissant', 'Baguette', 'Crepes', 'Macarons'], 'festival': 'Bastille Day', 'clothing': 'Beret & Fashion', 'music': 'Classical & Chanson', 'funFact': 'French is spoken on 5 continents!', 'dance': 'Ballet, Can-can'},
    {'name': 'Brazilian Culture', 'emoji': '🇧🇷', 'greeting': 'Ola!', 'greetingPronunciation': 'oh-lah', 'food': ['Feijoada', 'Pao de Queijo', 'Acai', 'Brigadeiro'], 'festival': 'Carnival - Street Festival', 'clothing': 'Carnival Costumes', 'music': 'Samba & Bossa Nova', 'funFact': 'Brazil is the largest country in South America!', 'dance': 'Samba, Capoeira'},
    {'name': 'American Culture', 'emoji': '🇺🇸', 'greeting': 'Hello!', 'greetingPronunciation': 'heh-loh', 'food': ['Hamburger', 'Hot Dog', 'Apple Pie', 'BBQ'], 'festival': 'Thanksgiving', 'clothing': 'Casual & Diverse', 'music': 'Jazz, Rock, Hip-hop', 'funFact': 'Baseball is called America\'s pastime!', 'dance': 'Hip-hop, Line Dancing'},
    {'name': 'Australian Culture', 'emoji': '🇦🇺', 'greeting': 'G\'day mate!', 'greetingPronunciation': 'guh-day mayt', 'food': ['Vegemite', 'Meat Pie', 'Lamingtons', 'BBQ'], 'festival': 'Australia Day', 'clothing': 'Casual & Akubra Hat', 'music': 'Didgeridoo & Rock', 'funFact': 'Aboriginal culture is 65,000 years old!', 'dance': 'Aboriginal Corroboree'},
    {'name': 'Italian Culture', 'emoji': '🇮🇹', 'greeting': 'Ciao!', 'greetingPronunciation': 'chow', 'food': ['Pizza', 'Pasta', 'Gelato', 'Risotto'], 'festival': 'Venice Carnival', 'clothing': 'Fashion Capital Style', 'music': 'Opera & Folk', 'funFact': 'Italy has 55 UNESCO World Heritage Sites!', 'dance': 'Tarantella'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
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
    disposeGridAnimations();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Global Cultures',
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(ProgressService.kGlobalCultures);
              setState(() {});
            },
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
        ),
      ],
      bottomNavigationBar: const AdsScreen(),
      body: Column(
        children: [
          Obx(() {
            final progress = ProgressService.to.getProgressPercentage(ProgressService.kGlobalCultures) / 100;
            final progressString = ProgressService.to.getProgressString(ProgressService.kGlobalCultures);
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
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.0,
              ),
              itemCount: cultures.length,
              itemBuilder: (context, index) {
                final culture = cultures[index];
                final gradient = AppColors.getGradientForIndex(index);
                return buildFloatingItem(
                  index: index,
                  child: GradientCard(
                    gradient: gradient,
                    isSelected: false,
                    onTap: () {
                      TtsService.to.speak(culture['name']);
                      ProgressService.to.markItemCompleted(ProgressService.kGlobalCultures, index);
                      Get.to(() => CultureDetailPage(culture: culture, speakText: _speakText));
                    },
                    pulseAnimation: pulseAnimation,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(culture['emoji'], style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          GradientCardText(
                            text: culture['name'].replaceAll(' Culture', ''),
                            fontSize: 13,
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

class CultureDetailPage extends StatefulWidget {
  final Map<String, dynamic> culture;
  final void Function(String) speakText;

  const CultureDetailPage({super.key, required this.culture, required this.speakText});

  @override
  State<CultureDetailPage> createState() => _CultureDetailPageState();
}

class _CultureDetailPageState extends State<CultureDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.culture;
    final foodStr = (c['food'] as List).join(', ');
    final items = [
      {'emoji': '👋', 'label': 'Greeting', 'value': '${c['greeting']} (${c['greetingPronunciation']})'},
      {'emoji': '🍽️', 'label': 'Food', 'value': foodStr},
      {'emoji': '🎉', 'label': 'Festival', 'value': c['festival']},
      {'emoji': '👗', 'label': 'Clothing', 'value': c['clothing']},
      {'emoji': '🎵', 'label': 'Music', 'value': c['music']},
      {'emoji': '💃', 'label': 'Dance', 'value': c['dance']},
      {'emoji': '💡', 'label': 'Fun Fact', 'value': c['funFact']},
    ];

    return GradientScaffold(
      title: c['name'],
      bottomNavigationBar: const AdsScreen(),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: GradientCard(
              gradient: gradient,
              isSelected: false,
              onTap: () => widget.speakText("${item['label']}. ${item['value']}"),
              pulseAnimation: pulseAnimation,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                      child: Center(child: Text(item['emoji']!, style: const TextStyle(fontSize: 24))),
                    ),
                    const SizedBox(height: 6),
                    Text(item['label']!, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    GradientCardText(text: item['value']!, fontSize: 11),
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
