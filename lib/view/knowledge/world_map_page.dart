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

class WorldMapPage extends StatefulWidget {
  const WorldMapPage({super.key});

  @override
  State<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> continents = [
    {
      'name': 'Asia',
      'emoji': '🌏',
      'countries': 48,
      'population': '4.7 Billion',
      'largestCountry': 'Russia/China',
      'funFact': 'Asia is the largest continent and home to Mount Everest!',
      'famousFor': ['Great Wall of China', 'Taj Mahal', 'Mount Fuji'],
    },
    {
      'name': 'Africa',
      'emoji': '🌍',
      'countries': 54,
      'population': '1.4 Billion',
      'largestCountry': 'Algeria',
      'funFact': 'Africa has the longest river - the Nile!',
      'famousFor': ['Pyramids of Giza', 'Safari', 'Victoria Falls'],
    },
    {
      'name': 'North America',
      'emoji': '🌎',
      'countries': 23,
      'population': '580 Million',
      'largestCountry': 'Canada',
      'funFact': 'North America has the Grand Canyon!',
      'famousFor': ['Statue of Liberty', 'Niagara Falls', 'Hollywood'],
    },
    {
      'name': 'South America',
      'emoji': '🌎',
      'countries': 12,
      'population': '430 Million',
      'largestCountry': 'Brazil',
      'funFact': 'South America has the Amazon Rainforest!',
      'famousFor': ['Amazon River', 'Machu Picchu', 'Christ the Redeemer'],
    },
    {
      'name': 'Europe',
      'emoji': '🌍',
      'countries': 44,
      'population': '750 Million',
      'largestCountry': 'Ukraine',
      'funFact': 'Europe has the most countries in a small area!',
      'famousFor': ['Eiffel Tower', 'Colosseum', 'Big Ben'],
    },
    {
      'name': 'Australia',
      'emoji': '🌏',
      'countries': 1,
      'population': '25 Million',
      'largestCountry': 'Australia',
      'funFact': 'Australia is both a country and a continent!',
      'famousFor': ['Sydney Opera House', 'Great Barrier Reef', 'Kangaroos'],
    },
    {
      'name': 'Antarctica',
      'emoji': '🧊',
      'countries': 0,
      'population': '~5,000 researchers',
      'largestCountry': 'No countries',
      'funFact': 'Antarctica is the coldest place on Earth!',
      'famousFor': ['Penguins', 'Icebergs', 'Research Stations'],
    },
  ];

  final List<Map<String, dynamic>> oceans = [
    {'name': 'Pacific Ocean', 'emoji': '🌊', 'size': 'Largest'},
    {'name': 'Atlantic Ocean', 'emoji': '🌊', 'size': '2nd Largest'},
    {'name': 'Indian Ocean', 'emoji': '🌊', 'size': '3rd Largest'},
    {'name': 'Arctic Ocean', 'emoji': '❄️', 'size': 'Smallest'},
    {'name': 'Southern Ocean', 'emoji': '🐧', 'size': 'Around Antarctica'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 2, vsync: this);
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
      title: 'World Map',
      actions: [
        Container(
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(ProgressService.kWorldMap);
              setState(() {});
            },
            icon: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3.r,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelPadding: EdgeInsets.symmetric(horizontal: 30.w),
        tabs: const [
          Tab(text: "Continents"),
          Tab(text: "Oceans"),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kWorldMap,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kWorldMap,
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
            child: TabBarView(
              controller: _tabController,
              children: [_buildContinentsGrid(), _buildOceansGrid()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinentsGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(12.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.r,
        crossAxisSpacing: 16.r,
        childAspectRatio: 1.0,
      ),
      itemCount: continents.length,
      itemBuilder: (context, index) {
        final continent = continents[index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () {
              TtsService.to.speak(continent['name']);
              ProgressService.to.markItemCompleted(
                ProgressService.kWorldMap,
                index,
              );
              Get.to(
                () => ContinentDetailPage(
                  continent: continent,
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
                        continent['emoji'],
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Flexible(
                    child: GradientCardText(
                      text: continent['name'],
                      fontSize: 13,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${continent['countries']} countries',
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
    );
  }

  Widget _buildOceansGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(12.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.r,
        crossAxisSpacing: 16.r,
        childAspectRatio: 1.0,
      ),
      itemCount: oceans.length,
      itemBuilder: (context, index) {
        final ocean = oceans[index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () => _speakText("${ocean['name']}. ${ocean['size']}"),
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
                        ocean['emoji'],
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GradientCardText(text: ocean['name'], fontSize: 13),
                  Text(
                    ocean['size'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ContinentDetailPage extends StatefulWidget {
  final Map<String, dynamic> continent;
  final void Function(String) speakText;

  const ContinentDetailPage({
    super.key,
    required this.continent,
    required this.speakText,
  });

  @override
  State<ContinentDetailPage> createState() => _ContinentDetailPageState();
}

class _ContinentDetailPageState extends State<ContinentDetailPage>
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
    final c = widget.continent;
    final items = [
      {'emoji': '🏳️', 'label': 'Countries', 'value': '${c['countries']}'},
      {'emoji': '👥', 'label': 'Population', 'value': c['population']},
      {'emoji': '📏', 'label': 'Largest', 'value': c['largestCountry']},
      {'emoji': '💡', 'label': 'Fun Fact', 'value': c['funFact']},
      ...List.generate(
        (c['famousFor'] as List).length,
        (i) => {'emoji': '🏛️', 'label': 'Famous', 'value': c['famousFor'][i]},
      ),
    ];

    return GradientScaffold(
      title: c['name'],
      body: GridView.builder(
        padding: EdgeInsets.all(12.r),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.r,
          crossAxisSpacing: 12.r,
          childAspectRatio: items.length > 6 ? 1.0 : 0.95,
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
