import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class FolkTalesPage extends StatefulWidget {
  const FolkTalesPage({super.key});

  @override
  State<FolkTalesPage> createState() => _FolkTalesPageState();
}

class _FolkTalesPageState extends State<FolkTalesPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> panchatantraStories = [
    {
      'title': 'The Monkey and the Crocodile',
      'emoji': '🐒🐊',
      'color': Color(0xFF4ECDC4),
      'moral': 'Quick thinking can save you from danger',
      'story': 'A monkey lived on a jamun tree by the river. A crocodile became his friend. The crocodile wife wanted to eat the monkeys heart. The crocodile tried to trick the monkey. But the clever monkey said his heart was on the tree. When the crocodile brought him back, the monkey jumped to safety!',
    },
    {
      'title': 'The Blue Jackal',
      'emoji': '🐺💙',
      'color': Color(0xFF667EEA),
      'moral': 'Never pretend to be someone you are not',
      'story': 'A jackal fell into a pot of blue dye and turned blue. He told other animals he was king of the forest. All animals feared him. One day, jackals howled and he howled back. Everyone knew he was just a jackal. He had to run away in shame!',
    },
    {
      'title': 'The Tortoise and the Geese',
      'emoji': '🐢🪿',
      'color': Color(0xFF56D97F),
      'moral': 'Think before you speak',
      'story': 'A tortoise was friends with two geese. When the pond dried, geese decided to carry tortoise to a new pond. They held a stick and tortoise bit it in middle. Tortoise was told not to open his mouth. But when people laughed, he opened his mouth to reply and fell down!',
    },
    {
      'title': 'The Lion and the Rabbit',
      'emoji': '🦁🐰',
      'color': Color(0xFFFFAA5A),
      'moral': 'Brain is mightier than brawn',
      'story': 'A lion ate one animal every day. A clever rabbit decided to trick him. He took the lion to a well and showed his reflection. The lion thought another lion was there. He jumped into the well to fight and drowned. The clever rabbit saved all the animals!',
    },
    {
      'title': 'The Crow and the Snake',
      'emoji': '🐦‍⬛🐍',
      'color': Color(0xFFA78BFA),
      'moral': 'Intelligence defeats strength',
      'story': 'A snake lived in a tree hole and ate crow babies. The sad crows asked a fox for help. The fox gave them a clever plan. The crow stole a queens necklace and dropped it in the snakes hole. Guards came looking and killed the snake. The crows were saved!',
    },
  ];

  final List<Map<String, dynamic>> jatakaStories = [
    {
      'title': 'The Monkey King',
      'emoji': '🐵👑',
      'color': Color(0xFFFF6B6B),
      'moral': 'A good leader sacrifices for others',
      'story': 'A monkey king ruled many monkeys near a mango tree. A human king wanted the tree. The monkey king made a bridge with his body so all monkeys could escape. He saved everyone but hurt himself. The human king was moved by his sacrifice.',
    },
    {
      'title': 'The Golden Swan',
      'emoji': '🦢✨',
      'color': Color(0xFFFFD93D),
      'moral': 'Greed leads to loss',
      'story': 'A golden swan gave one feather at a time to a poor woman. The feathers turned to gold. The greedy woman caught the swan to take all feathers. But all the feathers became ordinary white. Greed made her lose everything!',
    },
    {
      'title': 'The Wise Deer',
      'emoji': '🦌🌿',
      'color': Color(0xFF56D97F),
      'moral': 'Kindness is rewarded',
      'story': 'A deer saved a man from drowning. The man promised to keep the deers home secret. But the greedy man told the king for money. When soldiers came, the deer spoke to the king about the mans betrayal. The king freed the deer and punished the traitor.',
    },
  ];

  final List<Map<String, dynamic>> folkTales = [
    {
      'title': 'Tenali Raman and the Thieves',
      'emoji': '🧠💡',
      'color': Color(0xFFFF8E53),
      'region': 'South India',
      'moral': 'Wit can defeat any danger',
      'story': 'Thieves came to Tenali Ramans house. He loudly told his wife to drop their treasure in the well. Thieves went into the well to find it. There was no treasure! Tenali had tricked them and caught them all!',
    },
    {
      'title': 'Birbal and the Crows',
      'emoji': '🐦‍⬛🤔',
      'color': Color(0xFF667EEA),
      'region': 'North India',
      'moral': 'Quick thinking solves problems',
      'story': 'Emperor Akbar asked Birbal how many crows in the kingdom. Birbal said a number. When asked what if there are more or less, Birbal said: More means visitors, less means some went to visit relatives! Akbar laughed and praised his wit.',
    },
    {
      'title': 'The Magic Pot',
      'emoji': '🍯✨',
      'color': Color(0xFFA78BFA),
      'region': 'All India',
      'moral': 'Greed destroys everything',
      'story': 'A poor farmer found a magic pot. Whatever he put inside multiplied. He became rich. His greedy wife leaned too far in and fell inside. Many copies of her came out, all fighting. The farmer learned greed brings trouble!',
    },
    {
      'title': 'The Foolish Lion',
      'emoji': '🦁🤡',
      'color': Color(0xFF4ECDC4),
      'region': 'West India',
      'moral': 'Pride comes before a fall',
      'story': 'A lion was proud of his strength. A small mouse said he could help the lion one day. The lion laughed. Later, the lion was trapped in a net. The mouse came and cut the net with his teeth. The proud lion learned that even small friends matter!',
    },
    {
      'title': 'The Brave Boy',
      'emoji': '👦⚔️',
      'color': Color(0xFFFF6B6B),
      'region': 'East India',
      'moral': 'Courage can achieve anything',
      'story': 'A young boy lived in a village troubled by a demon. Adults were scared. The brave boy went to face the demon with just a mirror. The demon saw his own scary face and ran away forever. The village was saved by the brave little boy!',
    },
  ];

  int? selectedStoryIndex;
  String currentTab = 'panchatantra';

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedStoryIndex = null;
          switch (_tabController.index) {
            case 0:
              currentTab = 'panchatantra';
              break;
            case 1:
              currentTab = 'jataka';
              break;
            case 2:
              currentTab = 'folk';
              break;
          }
        });
      }
    });
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _stopSpeaking() {
    flutterTts.stop();
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  List<Map<String, dynamic>> get currentStories {
    switch (currentTab) {
      case 'panchatantra':
        return panchatantraStories;
      case 'jataka':
        return jatakaStories;
      case 'folk':
        return folkTales;
      default:
        return panchatantraStories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            _stopSpeaking();
            Get.back();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text("Folk Tales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Panchatantra", icon: Icon(Icons.auto_stories, size: 18)),
            Tab(text: "Jataka", icon: Icon(Icons.menu_book, size: 18)),
            Tab(text: "Folk Tales", icon: Icon(Icons.local_library, size: 18)),
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
            _buildStoriesList(panchatantraStories, "🐾", "Panchatantra Tales", "Ancient animal stories with wisdom!"),
            _buildStoriesList(jatakaStories, "🪷", "Jataka Tales", "Stories of Buddhas past lives!"),
            _buildStoriesList(folkTales, "🏛️", "Indian Folk Tales", "Stories from across India!"),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildStoriesList(List<Map<String, dynamic>> stories, String headerEmoji, String headerTitle, String subtitle) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Text(headerEmoji, style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              Text(headerTitle, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final story = stories[index - 1];
        return GestureDetector(
          onTap: () => _showStoryDetails(story),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: story['color'].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [story['color'], story['color'].withValues(alpha: 0.7)]),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Text(story['emoji'], style: const TextStyle(fontSize: 35)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(story['title'], style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                            if (story.containsKey('region'))
                              Text(story['region'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Text("💡 ", style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          "Moral: ${story['moral']}",
                          style: TextStyle(fontSize: 13, color: story['color'], fontWeight: FontWeight.w500),
                        ),
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

  void _showStoryDetails(Map<String, dynamic> story) {
    _speakText("${story['title']}. ${story['story']}. The moral is: ${story['moral']}");

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 20),
            Text(story['emoji'], style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            Text(story['title'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: story['color'])),
            if (story.containsKey('region'))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("📍 ${story['region']}", style: TextStyle(color: Colors.grey.shade600)),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: story['color'].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        story['story'],
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade800, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [story['color'], story['color'].withValues(alpha: 0.7)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("💡", style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Moral: ${story['moral']}",
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _speakText(story['story']),
                  icon: const Icon(Icons.replay),
                  label: const Text("Listen Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: story['color'],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _stopSpeaking();
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
