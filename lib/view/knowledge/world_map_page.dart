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
    {'name': 'Asia', 'emoji': '🌏', 'countries': 48, 'population': '4.7 Billion', 'largestCountry': 'Russia/China', 'funFact': 'Asia is the largest continent and home to Mount Everest!', 'famousFor': ['Great Wall of China', 'Taj Mahal', 'Mount Fuji']},
    {'name': 'Africa', 'emoji': '🌍', 'countries': 54, 'population': '1.4 Billion', 'largestCountry': 'Algeria', 'funFact': 'Africa has the longest river - the Nile!', 'famousFor': ['Pyramids of Giza', 'Safari', 'Victoria Falls']},
    {'name': 'North America', 'emoji': '🌎', 'countries': 23, 'population': '580 Million', 'largestCountry': 'Canada', 'funFact': 'North America has the Grand Canyon!', 'famousFor': ['Statue of Liberty', 'Niagara Falls', 'Hollywood']},
    {'name': 'South America', 'emoji': '🌎', 'countries': 12, 'population': '430 Million', 'largestCountry': 'Brazil', 'funFact': 'South America has the Amazon Rainforest!', 'famousFor': ['Amazon River', 'Machu Picchu', 'Christ the Redeemer']},
    {'name': 'Europe', 'emoji': '🌍', 'countries': 44, 'population': '750 Million', 'largestCountry': 'Ukraine', 'funFact': 'Europe has the most countries in a small area!', 'famousFor': ['Eiffel Tower', 'Colosseum', 'Big Ben']},
    {'name': 'Australia', 'emoji': '🌏', 'countries': 1, 'population': '25 Million', 'largestCountry': 'Australia', 'funFact': 'Australia is both a country and a continent!', 'famousFor': ['Sydney Opera House', 'Great Barrier Reef', 'Kangaroos']},
    {'name': 'Antarctica', 'emoji': '🧊', 'countries': 0, 'population': '~5,000 researchers', 'largestCountry': 'No countries', 'funFact': 'Antarctica is the coldest place on Earth!', 'famousFor': ['Penguins', 'Icebergs', 'Research Stations']},
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
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(ProgressService.kWorldMap);
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
        labelPadding: const EdgeInsets.symmetric(horizontal: 30),
        tabs: const [
          Tab(text: "Continents"),
          Tab(text: "Oceans"),
        ],
      ),
      bottomNavigationBar: const AdsScreen(),
      body: Column(
        children: [
          Obx(() {
            final progress = ProgressService.to.getProgressPercentage(ProgressService.kWorldMap) / 100;
            final progressString = ProgressService.to.getProgressString(ProgressService.kWorldMap);
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
                _buildContinentsGrid(),
                _buildOceansGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinentsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.0,
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
              ProgressService.to.markItemCompleted(ProgressService.kWorldMap, index);
              Get.to(() => ContinentDetailPage(continent: continent, speakText: _speakText));
            },
            pulseAnimation: pulseAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 65, height: 65,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                    child: Center(child: Text(continent['emoji'], style: const TextStyle(fontSize: 36))),
                  ),
                  const SizedBox(height: 8),
                  GradientCardText(text: continent['name'], fontSize: 13),
                  Text('${continent['countries']} countries', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8))),
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
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.0,
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
                    width: 65, height: 65,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                    child: Center(child: Text(ocean['emoji'], style: const TextStyle(fontSize: 36))),
                  ),
                  const SizedBox(height: 8),
                  GradientCardText(text: ocean['name'], fontSize: 13),
                  Text(ocean['size'], style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8))),
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

  const ContinentDetailPage({super.key, required this.continent, required this.speakText});

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
      ...List.generate((c['famousFor'] as List).length, (i) => {
        'emoji': '🏛️', 'label': 'Famous', 'value': c['famousFor'][i],
      }),
    ];

    return GradientScaffold(
      title: c['name'],
      bottomNavigationBar: const AdsScreen(),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
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
                    GradientCardText(text: item['value']!, fontSize: 12),
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
