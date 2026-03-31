import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class FestivalLearningPage extends StatefulWidget {
  const FestivalLearningPage({super.key});

  @override
  State<FestivalLearningPage> createState() => _FestivalLearningPageState();
}

class _FestivalLearningPageState extends State<FestivalLearningPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<List<Map<String, dynamic>>> festivalsByTab = [
    // Hindu Festivals
    [
      {'name': 'Diwali', 'emoji': '🪔', 'month': 'Oct/Nov', 'description': 'Festival of Lights! We light diyas, burst crackers, eat sweets, and celebrate the victory of light over darkness.', 'activities': ['Light diyas', 'Make rangoli', 'Burst crackers', 'Eat sweets', 'Wear new clothes']},
      {'name': 'Holi', 'emoji': '🎨', 'month': 'March', 'description': 'Festival of Colors! We play with colors, eat gujiya sweets, and celebrate the arrival of spring.', 'activities': ['Play with colors', 'Eat gujiya', 'Dance to music', 'Meet friends', 'Drink thandai']},
      {'name': 'Ganesh Chaturthi', 'emoji': '🐘', 'month': 'Aug/Sep', 'description': 'Birthday of Lord Ganesha! We bring Ganesha idol home, do puja, and later immerse it in water.', 'activities': ['Bring Ganesha idol', 'Do puja', 'Make modak', 'Sing aarti', 'Visarjan']},
      {'name': 'Navratri', 'emoji': '💃', 'month': 'Sep/Oct', 'description': 'Nine nights of dancing! We worship Goddess Durga, do Garba and Dandiya dance for 9 nights.', 'activities': ['Garba dance', 'Dandiya raas', 'Fast for 9 days', 'Worship Durga', 'Wear colorful clothes']},
      {'name': 'Raksha Bandhan', 'emoji': '🧵', 'month': 'August', 'description': 'Bond between brother and sister! Sister ties rakhi on brothers wrist, brother gives gifts.', 'activities': ['Tie rakhi', 'Give gifts', 'Eat sweets', 'Pray together', 'Family gathering']},
      {'name': 'Janmashtami', 'emoji': '🍯', 'month': 'August', 'description': 'Birthday of Lord Krishna! We fast, sing bhajans, break dahi handi, and celebrate at midnight.', 'activities': ['Dahi handi', 'Midnight celebration', 'Fast all day', 'Dress up as Krishna', 'Eat makhan']},
    ],
    // Muslim Festivals
    [
      {'name': 'Eid ul-Fitr', 'emoji': '🌙', 'month': 'After Ramadan', 'description': 'Festival after month of fasting! We wear new clothes, offer prayers, give Eidi, and enjoy food.', 'activities': ['Morning prayers', 'Wear new clothes', 'Give Eidi', 'Meet family', 'Eat seviyan']},
      {'name': 'Eid ul-Adha', 'emoji': '🐑', 'month': 'Dhul Hijjah', 'description': 'Festival of Sacrifice! We offer prayers, share food with poor, and remember sacrifice.', 'activities': ['Morning prayers', 'Sacrifice', 'Share meat', 'Help poor', 'Family feast']},
    ],
    // Christian Festivals
    [
      {'name': 'Christmas', 'emoji': '🎄', 'month': 'December 25', 'description': 'Birthday of Jesus Christ! We decorate tree, exchange gifts, and spread love and joy.', 'activities': ['Decorate tree', 'Exchange gifts', 'Sing carols', 'Midnight mass', 'Santa Claus']},
      {'name': 'Easter', 'emoji': '🐣', 'month': 'March/April', 'description': 'Celebration of Jesus rising! We paint eggs, go on egg hunts, and celebrate new beginnings.', 'activities': ['Paint eggs', 'Egg hunt', 'Church service', 'Easter bunny', 'Family lunch']},
    ],
    // Sikh Festivals
    [
      {'name': 'Baisakhi', 'emoji': '🌾', 'month': 'April 13/14', 'description': 'Harvest festival and Sikh New Year! We visit Gurudwara, do bhangra, and thank God.', 'activities': ['Visit Gurudwara', 'Bhangra dance', 'Langar', 'Nagar Kirtan', 'New clothes']},
      {'name': 'Guru Nanak Jayanti', 'emoji': '🙏', 'month': 'November', 'description': 'Birthday of Guru Nanak! We do early morning prayers, have Langar, and remember his teachings.', 'activities': ['Prabhat pheri', 'Gurudwara visit', 'Langar seva', 'Kirtan', 'Read Guru Granth Sahib']},
    ],
    // National Festivals
    [
      {'name': 'Independence Day', 'emoji': '🇮🇳', 'month': 'August 15', 'description': 'India became free in 1947! We hoist the flag, sing anthem, and remember freedom fighters.', 'activities': ['Flag hoisting', 'Sing Jana Gana Mana', 'Wear tricolor', 'Watch parade', 'Remember freedom fighters']},
      {'name': 'Republic Day', 'emoji': '🏛️', 'month': 'January 26', 'description': 'India got its Constitution in 1950! We watch the grand parade in Delhi.', 'activities': ['Watch parade', 'Flag hoisting', 'Cultural programs', 'Tableaux', 'Patriotic songs']},
      {'name': 'Gandhi Jayanti', 'emoji': '👓', 'month': 'October 2', 'description': 'Birthday of Mahatma Gandhi! We remember his teachings of peace and non-violence.', 'activities': ['Prayer meetings', 'Cleaning drives', 'School programs', 'Remember Bapu', 'Non-violence pledge']},
    ],
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ProgressService.to.markItemCompleted(ProgressService.kFestivalLearning, _tabController.index);
      }
    });
    ProgressService.to.markItemCompleted(ProgressService.kFestivalLearning, 0);
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
      title: 'Festivals',
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () async {
              await ProgressService.to.resetProgress(ProgressService.kFestivalLearning);
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
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20),
        tabs: const [
          Tab(text: "Hindu"),
          Tab(text: "Muslim"),
          Tab(text: "Christian"),
          Tab(text: "Sikh"),
          Tab(text: "National"),
        ],
      ),
      bottomNavigationBar: const AdsScreen(),
      body: Column(
        children: [
          Obx(() {
            final progress = ProgressService.to.getProgressPercentage(ProgressService.kFestivalLearning) / 100;
            final progressString = ProgressService.to.getProgressString(ProgressService.kFestivalLearning);
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
              children: List.generate(5, (tabIndex) => _buildFestivalGrid(tabIndex)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFestivalGrid(int tabIndex) {
    final festivals = festivalsByTab[tabIndex];
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.0,
      ),
      itemCount: festivals.length,
      itemBuilder: (context, index) {
        final festival = festivals[index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () {
              TtsService.to.speak(festival['name']);
              Get.to(() => FestivalDetailPage(festival: festival, speakText: _speakText));
            },
            pulseAnimation: pulseAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 55, height: 55,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                    child: Center(child: Text(festival['emoji'], style: const TextStyle(fontSize: 30))),
                  ),
                  const SizedBox(height: 8),
                  GradientCardText(text: festival['name'], fontSize: 12),
                  Text(festival['month'], style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FestivalDetailPage extends StatefulWidget {
  final Map<String, dynamic> festival;
  final void Function(String) speakText;

  const FestivalDetailPage({super.key, required this.festival, required this.speakText});

  @override
  State<FestivalDetailPage> createState() => _FestivalDetailPageState();
}

class _FestivalDetailPageState extends State<FestivalDetailPage>
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
    final f = widget.festival;
    final activities = f['activities'] as List;
    final items = [
      {'emoji': '📖', 'label': 'About', 'value': f['description']},
      {'emoji': '📅', 'label': 'When', 'value': f['month']},
      ...List.generate(activities.length, (i) => {
        'emoji': '🎯', 'label': 'Activity', 'value': activities[i],
      }),
    ];

    return GradientScaffold(
      title: f['name'],
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
