import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/services/tts_service.dart';

class EnvironmentalStudiesPage extends StatefulWidget {
  const EnvironmentalStudiesPage({super.key});

  @override
  State<EnvironmentalStudiesPage> createState() =>
      _EnvironmentalStudiesPageState();
}

class _EnvironmentalStudiesPageState extends State<EnvironmentalStudiesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Save Water',
      'emoji': '💧',
      'color': Color(0xFF4ECDC4),
      'facts': [
        'Turn off tap while brushing teeth',
        'Take shorter showers',
        'Fix leaking taps',
        'Use a bucket instead of hose',
        'Collect rainwater for plants',
      ],
      'tip': 'Every drop counts! Save water for the future.',
    },
    {
      'title': 'Save Trees',
      'emoji': '🌳',
      'color': Color(0xFF56D97F),
      'facts': [
        'Trees give us oxygen to breathe',
        'Trees are home to many animals',
        'Plant more trees on Earth Day',
        'Use both sides of paper',
        'Trees help cool the earth',
      ],
      'tip': 'Trees are our best friends. Plant one today!',
    },
    {
      'title': 'Reduce Pollution',
      'emoji': '🏭',
      'color': Color(0xFF667EEA),
      'facts': [
        'Walk or cycle for short distances',
        'Use public transport',
        'Don\'t burn garbage',
        'Use electric vehicles',
        'Keep your surroundings clean',
      ],
      'tip': 'Clean air is healthy air!',
    },
    {
      'title': 'Recycling',
      'emoji': '♻️',
      'color': Color(0xFFFFAA5A),
      'facts': [
        'Separate wet and dry waste',
        'Recycle paper, plastic, and glass',
        'Make compost from food waste',
        'Reuse old items creatively',
        'Say no to single-use plastic',
      ],
      'tip': 'Reduce, Reuse, Recycle!',
    },
    {
      'title': 'Save Energy',
      'emoji': '💡',
      'color': Color(0xFFFF6B6B),
      'facts': [
        'Turn off lights when not needed',
        'Use LED bulbs',
        'Unplug chargers when done',
        'Use sunlight during the day',
        'Close doors to keep rooms cool/warm',
      ],
      'tip': 'Save energy, save money!',
    },
    {
      'title': 'Protect Animals',
      'emoji': '🦁',
      'color': Color(0xFFA78BFA),
      'facts': [
        'Don\'t litter in forests',
        'Never harm wild animals',
        'Support wildlife conservation',
        'Keep pets safe and healthy',
        'Don\'t buy products from endangered animals',
      ],
      'tip': 'Animals are our friends, not enemies!',
    },
  ];

  final List<Map<String, dynamic>> ecosystems = [
    {
      'name': 'Forest',
      'emoji': '🌲',
      'description': 'Home to trees and animals',
      'color': Color(0xFF228B22),
    },
    {
      'name': 'Ocean',
      'emoji': '🌊',
      'description': 'Full of fish and corals',
      'color': Color(0xFF1E90FF),
    },
    {
      'name': 'Desert',
      'emoji': '🏜️',
      'description': 'Hot and sandy with cacti',
      'color': Color(0xFFDEB887),
    },
    {
      'name': 'Arctic',
      'emoji': '🧊',
      'description': 'Cold with polar bears',
      'color': Color(0xFFADD8E6),
    },
    {
      'name': 'Grassland',
      'emoji': '🌾',
      'description': 'Open fields with zebras',
      'color': Color(0xFF9ACD32),
    },
    {
      'name': 'Rainforest',
      'emoji': '🌴',
      'description': 'Wet with many species',
      'color': Color(0xFF006400),
    },
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
      title: 'Environment',
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to
                  .resetProgress(ProgressService.kEnvironmentTopics);
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
          Tab(text: "Learn"),
          Tab(text: "Ecosystems"),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Obx(() {
            final progress = ProgressService.to.getProgressPercentage(
                    ProgressService.kEnvironmentTopics) /
                100;
            final progressString = ProgressService.to
                .getProgressString(ProgressService.kEnvironmentTopics);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$progressString completed',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50)),
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
                _buildLearnTab(),
                _buildEcosystemsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        final gradient = AppColors.getGradientForIndex(index);

        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () {
              TtsService.to.speak(topic['name']);
              ProgressService.to.markItemCompleted(
                  ProgressService.kEnvironmentTopics, index);
              Get.to(() => EnvironmentTopicDetailPage(
                    title: topic['title'],
                    facts: List<String>.from(topic['facts']),
                    tip: topic['tip'],
                    color: topic['color'],
                    emoji: topic['emoji'],
                    speakText: _speakText,
                  ));
            },
            pulseAnimation: pulseAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(topic['emoji'],
                          style: const TextStyle(fontSize: 42)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GradientCardText(text: topic['title'], fontSize: 13),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEcosystemsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: ecosystems.length,
      itemBuilder: (context, index) {
        final ecosystem = ecosystems[index];
        final gradient = AppColors.getGradientForIndex(index);

        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () => _speakText(
                "${ecosystem['name']}. ${ecosystem['description']}"),
            pulseAnimation: pulseAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(ecosystem['emoji'],
                          style: const TextStyle(fontSize: 42)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GradientCardText(text: ecosystem['name'], fontSize: 14),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      ecosystem['description'],
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.9)),
                      textAlign: TextAlign.center,
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

}

// Detail page for an environment topic
class EnvironmentTopicDetailPage extends StatefulWidget {
  final String title;
  final List<String> facts;
  final String tip;
  final Color color;
  final String emoji;
  final void Function(String) speakText;

  const EnvironmentTopicDetailPage({
    super.key,
    required this.title,
    required this.facts,
    required this.tip,
    required this.color,
    required this.emoji,
    required this.speakText,
  });

  @override
  State<EnvironmentTopicDetailPage> createState() =>
      _EnvironmentTopicDetailPageState();
}

class _EnvironmentTopicDetailPageState extends State<EnvironmentTopicDetailPage>
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
    // Combine facts + tip into items for grid display
    final items = [
      ...widget.facts.map((f) => {'text': f, 'type': 'fact'}),
      {'text': widget.tip, 'type': 'tip'},
    ];

    return GradientScaffold(
      title: widget.title,
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isTip = item['type'] == 'tip';
          final gradient = AppColors.getGradientForIndex(index);

          return buildFloatingItem(
            index: index,
            child: GradientCard(
              gradient: gradient,
              isSelected: false,
              onTap: () => widget.speakText(item['text']!),
              pulseAnimation: pulseAnimation,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          isTip ? '💡' : '✓',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GradientCardText(
                      text: item['text']!,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 6),
                    const Icon(Icons.volume_up, color: Colors.white, size: 18),
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
