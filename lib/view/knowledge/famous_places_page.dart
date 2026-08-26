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

class FamousPlacesPage extends StatefulWidget {
  const FamousPlacesPage({super.key});

  @override
  State<FamousPlacesPage> createState() => _FamousPlacesPageState();
}

class _FamousPlacesPageState extends State<FamousPlacesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> famousPlaces = [
    {
      'name': 'Taj Mahal',
      'emoji': '🕌',
      'country': 'India',
      'flag': '🇮🇳',
      'city': 'Agra',
      'type': 'Mausoleum',
      'builtIn': '1653',
      'funFact': 'It took 22 years and 20,000 workers to build!',
      'description':
          'A beautiful white marble monument built by Emperor Shah Jahan.',
      'isWonder': true,
    },
    {
      'name': 'Great Wall of China',
      'emoji': '🏯',
      'country': 'China',
      'flag': '🇨🇳',
      'city': 'Beijing Region',
      'type': 'Fortification',
      'builtIn': '7th Century BC',
      'funFact': 'It is over 21,000 kilometers long!',
      'description': 'The longest wall ever built across China.',
      'isWonder': true,
    },
    {
      'name': 'Eiffel Tower',
      'emoji': '🗼',
      'country': 'France',
      'flag': '🇫🇷',
      'city': 'Paris',
      'type': 'Iron Tower',
      'builtIn': '1889',
      'funFact': 'It was only meant to stand for 20 years!',
      'description': 'A famous iron tower and symbol of Paris.',
      'isWonder': false,
    },
    {
      'name': 'Pyramids of Giza',
      'emoji': '🔺',
      'country': 'Egypt',
      'flag': '🇪🇬',
      'city': 'Giza',
      'type': 'Ancient Tombs',
      'builtIn': '2560 BC',
      'funFact': 'They are over 4,500 years old!',
      'description': 'Ancient pyramid tombs of Egyptian pharaohs.',
      'isWonder': true,
    },
    {
      'name': 'Statue of Liberty',
      'emoji': '🗽',
      'country': 'United States',
      'flag': '🇺🇸',
      'city': 'New York',
      'type': 'Statue',
      'builtIn': '1886',
      'funFact': 'It was a gift from France to America!',
      'description': 'A copper statue representing freedom and democracy.',
      'isWonder': false,
    },
    {
      'name': 'Colosseum',
      'emoji': '🏟️',
      'country': 'Italy',
      'flag': '🇮🇹',
      'city': 'Rome',
      'type': 'Amphitheater',
      'builtIn': '80 AD',
      'funFact': 'It could hold 50,000 to 80,000 spectators!',
      'description': 'An ancient Roman arena for gladiator fights.',
      'isWonder': true,
    },
    {
      'name': 'Machu Picchu',
      'emoji': '🏔️',
      'country': 'Peru',
      'flag': '🇵🇪',
      'city': 'Cusco Region',
      'type': 'Ancient City',
      'builtIn': '1450 AD',
      'funFact': 'It was hidden from the world for 400 years!',
      'description': 'An ancient Incan city high in the Andes Mountains.',
      'isWonder': true,
    },
    {
      'name': 'Big Ben',
      'emoji': '🕰️',
      'country': 'United Kingdom',
      'flag': '🇬🇧',
      'city': 'London',
      'type': 'Clock Tower',
      'builtIn': '1859',
      'funFact': 'Big Ben is actually the name of the bell!',
      'description': 'A famous clock tower at Houses of Parliament.',
      'isWonder': false,
    },
    {
      'name': 'Sydney Opera House',
      'emoji': '🎭',
      'country': 'Australia',
      'flag': '🇦🇺',
      'city': 'Sydney',
      'type': 'Performance Venue',
      'builtIn': '1973',
      'funFact': 'Its roof has over 1 million tiles!',
      'description': 'A stunning building with sail-shaped roofs.',
      'isWonder': false,
    },
    {
      'name': 'Christ the Redeemer',
      'emoji': '✝️',
      'country': 'Brazil',
      'flag': '🇧🇷',
      'city': 'Rio de Janeiro',
      'type': 'Statue',
      'builtIn': '1931',
      'funFact': 'The statue is 30 meters tall!',
      'description': 'A giant statue overlooking Rio de Janeiro.',
      'isWonder': true,
    },
    {
      'name': 'Petra',
      'emoji': '🏛️',
      'country': 'Jordan',
      'flag': '🇯🇴',
      'city': 'Petra',
      'type': 'Ancient City',
      'builtIn': '312 BC',
      'funFact': 'Carved directly into pink sandstone cliffs!',
      'description': 'An ancient city carved into rose-red cliffs.',
      'isWonder': true,
    },
    {
      'name': 'Chichen Itza',
      'emoji': '🛕',
      'country': 'Mexico',
      'flag': '🇲🇽',
      'city': 'Yucatan',
      'type': 'Pyramid',
      'builtIn': '600 AD',
      'funFact': 'It creates a shadow serpent during equinoxes!',
      'description': 'An ancient Mayan pyramid temple.',
      'isWonder': true,
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
      title: 'Famous Places',
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
                ProgressService.kFamousPlaces,
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
                  ProgressService.kFamousPlaces,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kFamousPlaces,
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
              itemCount: famousPlaces.length,
              itemBuilder: (context, index) {
                final place = famousPlaces[index];
                final gradient = AppColors.getGradientForIndex(index);
                return buildFloatingItem(
                  index: index,
                  child: GradientCard(
                    gradient: gradient,
                    isSelected: false,
                    onTap: () {
                      TtsService.to.speak(place['name']);
                      ProgressService.to.markItemCompleted(
                        ProgressService.kFamousPlaces,
                        index,
                      );
                      Get.to(
                        () => PlaceDetailPage(
                          place: place,
                          speakText: _speakText,
                        ),
                      );
                    },
                    pulseAnimation: pulseAnimation,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                place['emoji'],
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Flexible(
                            child: GradientCardText(
                              text: place['name'],
                              fontSize: 12,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${place['flag']} ${place['country']}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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

class PlaceDetailPage extends StatefulWidget {
  final Map<String, dynamic> place;
  final void Function(String) speakText;

  const PlaceDetailPage({
    super.key,
    required this.place,
    required this.speakText,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage>
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
    final p = widget.place;
    final items = [
      {'emoji': '📖', 'label': 'About', 'value': p['description']},
      {
        'emoji': '📍',
        'label': 'Location',
        'value': '${p['city']}, ${p['country']}',
      },
      {'emoji': '🏷️', 'label': 'Type', 'value': p['type']},
      {'emoji': '📅', 'label': 'Built', 'value': p['builtIn']},
      {'emoji': '💡', 'label': 'Fun Fact', 'value': p['funFact']},
      if (p['isWonder'] == true)
        {'emoji': '⭐', 'label': 'Wonder', 'value': 'New 7 Wonder of the World'},
    ];

    return GradientScaffold(
      title: p['name'],
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
                        fontSize: 11,
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
