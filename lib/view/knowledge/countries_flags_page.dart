import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class CountriesFlagsPage extends StatefulWidget {
  const CountriesFlagsPage({super.key});

  @override
  State<CountriesFlagsPage> createState() => _CountriesFlagsPageState();
}

class _CountriesFlagsPageState extends State<CountriesFlagsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> countries = [
    {
      'name': 'India',
      'capital': 'New Delhi',
      'flag': '🇮🇳',
      'continent': 'Asia',
      'language': 'Hindi, English',
      'currency': 'Indian Rupee',
      'funFact': 'India has the largest postal network in the world!',
    },
    {
      'name': 'United States',
      'capital': 'Washington D.C.',
      'flag': '🇺🇸',
      'continent': 'North America',
      'language': 'English',
      'currency': 'US Dollar',
      'funFact': 'The US has no official language!',
    },
    {
      'name': 'United Kingdom',
      'capital': 'London',
      'flag': '🇬🇧',
      'continent': 'Europe',
      'language': 'English',
      'currency': 'Pound Sterling',
      'funFact': 'Big Ben is actually the name of the bell, not the tower!',
    },
    {
      'name': 'Japan',
      'capital': 'Tokyo',
      'flag': '🇯🇵',
      'continent': 'Asia',
      'language': 'Japanese',
      'currency': 'Japanese Yen',
      'funFact': 'Japan has over 6,800 islands!',
    },
    {
      'name': 'Australia',
      'capital': 'Canberra',
      'flag': '🇦🇺',
      'continent': 'Oceania',
      'language': 'English',
      'currency': 'Australian Dollar',
      'funFact': 'Australia has the longest fence in the world!',
    },
    {
      'name': 'Brazil',
      'capital': 'Brasília',
      'flag': '🇧🇷',
      'continent': 'South America',
      'language': 'Portuguese',
      'currency': 'Brazilian Real',
      'funFact': 'Brazil is home to the Amazon Rainforest!',
    },
    {
      'name': 'France',
      'capital': 'Paris',
      'flag': '🇫🇷',
      'continent': 'Europe',
      'language': 'French',
      'currency': 'Euro',
      'funFact': 'France is the most visited country in the world!',
    },
    {
      'name': 'China',
      'capital': 'Beijing',
      'flag': '🇨🇳',
      'continent': 'Asia',
      'language': 'Mandarin Chinese',
      'currency': 'Chinese Yuan',
      'funFact': 'China invented paper, compass, and fireworks!',
    },
    {
      'name': 'Germany',
      'capital': 'Berlin',
      'flag': '🇩🇪',
      'continent': 'Europe',
      'language': 'German',
      'currency': 'Euro',
      'funFact': 'Germany has over 20,000 castles!',
    },
    {
      'name': 'Canada',
      'capital': 'Ottawa',
      'flag': '🇨🇦',
      'continent': 'North America',
      'language': 'English, French',
      'currency': 'Canadian Dollar',
      'funFact': 'Canada has more lakes than all other countries combined!',
    },
    {
      'name': 'Russia',
      'capital': 'Moscow',
      'flag': '🇷🇺',
      'continent': 'Europe/Asia',
      'language': 'Russian',
      'currency': 'Russian Ruble',
      'funFact': 'Russia is the largest country in the world!',
    },
    {
      'name': 'Egypt',
      'capital': 'Cairo',
      'flag': '🇪🇬',
      'continent': 'Africa',
      'language': 'Arabic',
      'currency': 'Egyptian Pound',
      'funFact': 'The Great Pyramid is one of the Seven Wonders!',
    },
    {
      'name': 'South Africa',
      'capital': 'Pretoria',
      'flag': '🇿🇦',
      'continent': 'Africa',
      'language': '11 Official Languages',
      'currency': 'South African Rand',
      'funFact': 'South Africa has 3 capital cities!',
    },
    {
      'name': 'Italy',
      'capital': 'Rome',
      'flag': '🇮🇹',
      'continent': 'Europe',
      'language': 'Italian',
      'currency': 'Euro',
      'funFact': 'Italy has the most UNESCO World Heritage Sites!',
    },
    {
      'name': 'Spain',
      'capital': 'Madrid',
      'flag': '🇪🇸',
      'continent': 'Europe',
      'language': 'Spanish',
      'currency': 'Euro',
      'funFact': 'Spanish is spoken in 21 countries!',
    },
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
      title: 'Countries & Flags',
      actions: [
        Container(
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(
                ProgressService.kCountriesFlags,
              );
              setState(() {});
            },
            icon: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
        ),
      ],
      body: Column(
        children: [
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kCountriesFlags,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kCountriesFlags,
            );
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // The reader's font size can be 30% larger than this row was drawn for.
                      Flexible(
                        child: const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '$progressString completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10.h,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.r,
                crossAxisSpacing: 16.r,
                childAspectRatio: 1.0,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                final gradient = AppColors.getGradientForIndex(index);
                return buildFloatingItem(
                  index: index,
                  child: GradientCard(
                    gradient: gradient,
                    isSelected: false,
                    onTap: () {
                      TtsService.to.speak(country['name']);
                      ProgressService.to.markItemCompleted(
                        ProgressService.kCountriesFlags,
                        index,
                      );
                      Get.to(
                        () => CountryDetailPage(
                          country: country,
                          speakText: _speakText,
                        ),
                      );
                    },
                    pulseAnimation: pulseAnimation,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country['flag'],
                            style: const TextStyle(fontSize: 48),
                          ),
                          SizedBox(height: 8.h),
                          GradientCardText(text: country['name'], fontSize: 13),
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

class CountryDetailPage extends StatefulWidget {
  final Map<String, dynamic> country;
  final void Function(String) speakText;

  const CountryDetailPage({
    super.key,
    required this.country,
    required this.speakText,
  });

  @override
  State<CountryDetailPage> createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage>
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
    final c = widget.country;
    final items = [
      {'emoji': '🏛️', 'label': 'Capital', 'value': c['capital']},
      {'emoji': '🌍', 'label': 'Continent', 'value': c['continent']},
      {'emoji': '🗣️', 'label': 'Language', 'value': c['language']},
      {'emoji': '💰', 'label': 'Currency', 'value': c['currency']},
      {'emoji': '💡', 'label': 'Fun Fact', 'value': c['funFact']},
    ];

    return GradientScaffold(
      title: c['name'],
      body: GridView.builder(
        padding: EdgeInsets.all(12.r),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.r,
          crossAxisSpacing: 12.r,
          childAspectRatio: 1.0,
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
              onTap: () =>
                  widget.speakText("${item['label']}. ${item['value']}"),
              pulseAnimation: pulseAnimation,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          item['emoji']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item['label']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // A fact or a story is prose, not a single value: it
                    // takes what room the square tile has left and shortens
                    // rather than overflowing it.
                    Flexible(
                      child: GradientCardText(
                        text: item['value']!,
                        fontSize: 12,
                        maxLines: 4,
                      ),
                    ),
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
