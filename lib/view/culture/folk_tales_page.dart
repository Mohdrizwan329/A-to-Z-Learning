import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/services/tts_service.dart';

class FolkTalesPage extends StatefulWidget {
  const FolkTalesPage({super.key});

  @override
  State<FolkTalesPage> createState() => _FolkTalesPageState();
}

class _FolkTalesPageState extends State<FolkTalesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<List<Map<String, dynamic>>> storiesByTab = [
    // Panchatantra
    [
      {'title': 'The Monkey and the Crocodile', 'emoji': '🐒', 'moral': 'Quick thinking can save you from danger', 'story': 'A monkey lived on a jamun tree by the river. A crocodile became his friend. The crocodile wife wanted to eat the monkeys heart. The crocodile tried to trick the monkey. But the clever monkey said his heart was on the tree. When the crocodile brought him back, the monkey jumped to safety!'},
      {'title': 'The Blue Jackal', 'emoji': '🐺', 'moral': 'Never pretend to be someone you are not', 'story': 'A jackal fell into a pot of blue dye and turned blue. He told other animals he was king of the forest. All animals feared him. One day, jackals howled and he howled back. Everyone knew he was just a jackal. He had to run away in shame!'},
      {'title': 'The Tortoise and the Geese', 'emoji': '🐢', 'moral': 'Think before you speak', 'story': 'A tortoise was friends with two geese. When the pond dried, geese decided to carry tortoise to a new pond. They held a stick and tortoise bit it in middle. Tortoise was told not to open his mouth. But when people laughed, he opened his mouth to reply and fell down!'},
      {'title': 'The Lion and the Rabbit', 'emoji': '🦁', 'moral': 'Brain is mightier than brawn', 'story': 'A lion ate one animal every day. A clever rabbit decided to trick him. He took the lion to a well and showed his reflection. The lion thought another lion was there. He jumped into the well to fight and drowned. The clever rabbit saved all the animals!'},
      {'title': 'The Crow and the Snake', 'emoji': '🐦‍⬛', 'moral': 'Intelligence defeats strength', 'story': 'A snake lived in a tree hole and ate crow babies. The sad crows asked a fox for help. The fox gave them a clever plan. The crow stole a queens necklace and dropped it in the snakes hole. Guards came looking and killed the snake. The crows were saved!'},
    ],
    // Jataka
    [
      {'title': 'The Monkey King', 'emoji': '🐵', 'moral': 'A good leader sacrifices for others', 'story': 'A monkey king ruled many monkeys near a mango tree. A human king wanted the tree. The monkey king made a bridge with his body so all monkeys could escape. He saved everyone but hurt himself. The human king was moved by his sacrifice.'},
      {'title': 'The Golden Swan', 'emoji': '🦢', 'moral': 'Greed leads to loss', 'story': 'A golden swan gave one feather at a time to a poor woman. The feathers turned to gold. The greedy woman caught the swan to take all feathers. But all the feathers became ordinary white. Greed made her lose everything!'},
      {'title': 'The Wise Deer', 'emoji': '🦌', 'moral': 'Kindness is rewarded', 'story': 'A deer saved a man from drowning. The man promised to keep the deers home secret. But the greedy man told the king for money. When soldiers came, the deer spoke to the king about the mans betrayal. The king freed the deer and punished the traitor.'},
    ],
    // Folk Tales
    [
      {'title': 'Tenali Raman and Thieves', 'emoji': '🧠', 'moral': 'Wit can defeat any danger', 'story': 'Thieves came to Tenali Ramans house. He loudly told his wife to drop their treasure in the well. Thieves went into the well to find it. There was no treasure! Tenali had tricked them and caught them all!', 'region': 'South India'},
      {'title': 'Birbal and the Crows', 'emoji': '🤔', 'moral': 'Quick thinking solves problems', 'story': 'Emperor Akbar asked Birbal how many crows in the kingdom. Birbal said a number. When asked what if there are more or less, Birbal said: More means visitors, less means some went to visit relatives! Akbar laughed and praised his wit.', 'region': 'North India'},
      {'title': 'The Magic Pot', 'emoji': '🍯', 'moral': 'Greed destroys everything', 'story': 'A poor farmer found a magic pot. Whatever he put inside multiplied. He became rich. His greedy wife leaned too far in and fell inside. Many copies of her came out, all fighting. The farmer learned greed brings trouble!', 'region': 'All India'},
      {'title': 'The Foolish Lion', 'emoji': '🦁', 'moral': 'Pride comes before a fall', 'story': 'A lion was proud of his strength. A small mouse said he could help the lion one day. The lion laughed. Later, the lion was trapped in a net. The mouse came and cut the net with his teeth. The proud lion learned that even small friends matter!', 'region': 'West India'},
      {'title': 'The Brave Boy', 'emoji': '👦', 'moral': 'Courage can achieve anything', 'story': 'A young boy lived in a village troubled by a demon. Adults were scared. The brave boy went to face the demon with just a mirror. The demon saw his own scary face and ran away forever. The village was saved!', 'region': 'East India'},
    ],
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ProgressService.to.markItemCompleted(ProgressService.kFolkTales, _tabController.index);
      }
    });
    ProgressService.to.markItemCompleted(ProgressService.kFolkTales, 0);
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
      title: 'Folk Tales',
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(ProgressService.kFolkTales);
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
          Tab(text: "Panchatantra"),
          Tab(text: "Jataka"),
          Tab(text: "Folk Tales"),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            final progress = ProgressService.to.getProgressPercentage(ProgressService.kFolkTales) / 100;
            final progressString = ProgressService.to.getProgressString(ProgressService.kFolkTales);
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
              children: List.generate(3, (tabIndex) => _buildStoryGrid(tabIndex)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryGrid(int tabIndex) {
    final stories = storiesByTab[tabIndex];
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.0,
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () {
              TtsService.to.speak(story['title']);
              Get.to(() => StoryDetailPage(story: story, speakText: _speakText));
            },
            pulseAnimation: pulseAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 55, height: 55,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                    child: Center(child: Text(story['emoji'], style: const TextStyle(fontSize: 30))),
                  ),
                  const SizedBox(height: 8),
                  GradientCardText(text: story['title'], fontSize: 11),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class StoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> story;
  final void Function(String) speakText;

  const StoryDetailPage({super.key, required this.story, required this.speakText});

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage>
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
    final s = widget.story;
    final items = [
      {'emoji': '📖', 'label': 'Story', 'value': s['story']},
      {'emoji': '💡', 'label': 'Moral', 'value': s['moral']},
      if (s.containsKey('region'))
        {'emoji': '📍', 'label': 'Region', 'value': s['region']},
    ];

    return GradientScaffold(
      title: s['title'],
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
