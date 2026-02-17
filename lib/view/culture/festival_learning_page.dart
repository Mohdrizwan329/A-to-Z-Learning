import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class FestivalLearningPage extends StatefulWidget {
  const FestivalLearningPage({super.key});

  @override
  State<FestivalLearningPage> createState() => _FestivalLearningPageState();
}

class _FestivalLearningPageState extends State<FestivalLearningPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> hinduFestivals = [
    {
      'name': 'Diwali',
      'emoji': '🪔',
      'month': 'October/November',
      'description': 'Festival of Lights! We light diyas, burst crackers, eat sweets, and celebrate the victory of light over darkness.',
      'activities': ['Light diyas', 'Make rangoli', 'Burst crackers', 'Eat sweets', 'Wear new clothes'],
      'color': Color(0xFFFFD93D),
    },
    {
      'name': 'Holi',
      'emoji': '🎨',
      'month': 'March',
      'description': 'Festival of Colors! We play with colors, eat gujiya sweets, and celebrate the arrival of spring.',
      'activities': ['Play with colors', 'Eat gujiya', 'Dance to music', 'Meet friends', 'Drink thandai'],
      'color': Color(0xFFFF6B6B),
    },
    {
      'name': 'Ganesh Chaturthi',
      'emoji': '🐘',
      'month': 'August/September',
      'description': 'Birthday of Lord Ganesha! We bring Ganesha idol home, do puja, and later immerse it in water.',
      'activities': ['Bring Ganesha idol', 'Do puja', 'Make modak', 'Sing aarti', 'Visarjan'],
      'color': Color(0xFFFF8E53),
    },
    {
      'name': 'Navratri',
      'emoji': '💃',
      'month': 'September/October',
      'description': 'Nine nights of dancing! We worship Goddess Durga, do Garba and Dandiya dance for 9 nights.',
      'activities': ['Garba dance', 'Dandiya raas', 'Fast for 9 days', 'Worship Durga', 'Wear colorful clothes'],
      'color': Color(0xFFA78BFA),
    },
    {
      'name': 'Raksha Bandhan',
      'emoji': '🧵',
      'month': 'August',
      'description': 'Bond between brother and sister! Sister ties rakhi on brothers wrist, brother gives gifts and promises to protect.',
      'activities': ['Tie rakhi', 'Give gifts', 'Eat sweets', 'Pray together', 'Family gathering'],
      'color': Color(0xFF667EEA),
    },
    {
      'name': 'Janmashtami',
      'emoji': '🍯',
      'month': 'August',
      'description': 'Birthday of Lord Krishna! We fast, sing bhajans, break dahi handi, and celebrate at midnight.',
      'activities': ['Dahi handi', 'Midnight celebration', 'Fast all day', 'Dress up as Krishna', 'Eat makhan'],
      'color': Color(0xFF4ECDC4),
    },
  ];

  final List<Map<String, dynamic>> muslimFestivals = [
    {
      'name': 'Eid ul-Fitr',
      'emoji': '🌙',
      'month': 'After Ramadan',
      'description': 'Festival after month of fasting! We wear new clothes, offer prayers, give Eidi, and enjoy delicious food.',
      'activities': ['Morning prayers', 'Wear new clothes', 'Give Eidi', 'Meet family', 'Eat seviyan'],
      'color': Color(0xFF56D97F),
    },
    {
      'name': 'Eid ul-Adha',
      'emoji': '🐑',
      'month': 'Dhul Hijjah',
      'description': 'Festival of Sacrifice! We offer prayers, share food with poor, and remember Prophet Ibrahims sacrifice.',
      'activities': ['Morning prayers', 'Sacrifice', 'Share meat', 'Help poor', 'Family feast'],
      'color': Color(0xFFFFAA5A),
    },
  ];

  final List<Map<String, dynamic>> christianFestivals = [
    {
      'name': 'Christmas',
      'emoji': '🎄',
      'month': 'December 25',
      'description': 'Birthday of Jesus Christ! We decorate Christmas tree, exchange gifts, and spread love and joy.',
      'activities': ['Decorate tree', 'Exchange gifts', 'Sing carols', 'Midnight mass', 'Santa Claus'],
      'color': Color(0xFFFF6B6B),
    },
    {
      'name': 'Easter',
      'emoji': '🐣',
      'month': 'March/April',
      'description': 'Celebration of Jesus rising! We paint eggs, go on egg hunts, and celebrate new beginnings.',
      'activities': ['Paint eggs', 'Egg hunt', 'Church service', 'Easter bunny', 'Family lunch'],
      'color': Color(0xFFA78BFA),
    },
  ];

  final List<Map<String, dynamic>> sikhFestivals = [
    {
      'name': 'Baisakhi',
      'emoji': '🌾',
      'month': 'April 13/14',
      'description': 'Harvest festival and Sikh New Year! We visit Gurudwara, do bhangra, and thank God for good harvest.',
      'activities': ['Visit Gurudwara', 'Bhangra dance', 'Langar', 'Nagar Kirtan', 'New clothes'],
      'color': Color(0xFFFFD93D),
    },
    {
      'name': 'Guru Nanak Jayanti',
      'emoji': '🙏',
      'month': 'November',
      'description': 'Birthday of Guru Nanak! We do early morning prayers, have Langar, and remember his teachings.',
      'activities': ['Prabhat pheri', 'Gurudwara visit', 'Langar seva', 'Kirtan', 'Read Guru Granth Sahib'],
      'color': Color(0xFF4ECDC4),
    },
  ];

  final List<Map<String, dynamic>> nationalFestivals = [
    {
      'name': 'Independence Day',
      'emoji': '🇮🇳',
      'month': 'August 15',
      'description': 'India became free in 1947! We hoist the flag, sing national anthem, and remember our freedom fighters.',
      'activities': ['Flag hoisting', 'Sing Jana Gana Mana', 'Wear tricolor', 'Watch parade', 'Remember freedom fighters'],
      'color': Color(0xFF56D97F),
    },
    {
      'name': 'Republic Day',
      'emoji': '🏛️',
      'month': 'January 26',
      'description': 'India got its Constitution in 1950! We watch the grand parade in Delhi and celebrate our republic.',
      'activities': ['Watch parade', 'Flag hoisting', 'Cultural programs', 'Tableaux', 'Patriotic songs'],
      'color': Color(0xFFFF8E53),
    },
    {
      'name': 'Gandhi Jayanti',
      'emoji': '👓',
      'month': 'October 2',
      'description': 'Birthday of Mahatma Gandhi, Father of the Nation! We remember his teachings of peace and non-violence.',
      'activities': ['Prayer meetings', 'Cleaning drives', 'School programs', 'Remember Bapu', 'Non-violence pledge'],
      'color': Color(0xFF667EEA),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 5, vsync: this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
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
        title: const Text("Festivals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: "Hindu", icon: Icon(Icons.temple_hindu, size: 18)),
            Tab(text: "Muslim", icon: Icon(Icons.mosque, size: 18)),
            Tab(text: "Christian", icon: Icon(Icons.church, size: 18)),
            Tab(text: "Sikh", icon: Icon(Icons.auto_awesome, size: 18)),
            Tab(text: "National", icon: Icon(Icons.flag, size: 18)),
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
            _buildFestivalList(hinduFestivals, "🕉️", "Hindu Festivals"),
            _buildFestivalList(muslimFestivals, "☪️", "Islamic Festivals"),
            _buildFestivalList(christianFestivals, "✝️", "Christian Festivals"),
            _buildFestivalList(sikhFestivals, "🙏", "Sikh Festivals"),
            _buildFestivalList(nationalFestivals, "🇮🇳", "National Festivals"),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildFestivalList(List<Map<String, dynamic>> festivals, String headerEmoji, String headerTitle) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: festivals.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Text(headerEmoji, style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              Text(headerTitle, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Learn about our celebrations!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              const SizedBox(height: 20),
            ],
          );
        }

        final festival = festivals[index - 1];
        return GestureDetector(
          onTap: () => _showFestivalDetails(festival),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: festival['color'].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [festival['color'], festival['color'].withValues(alpha: 0.7)]),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Text(festival['emoji'], style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(festival['name'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(festival['month'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.white),
                        onPressed: () => _speakText("${festival['name']}. ${festival['description']}"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(festival['description'], style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (festival['activities'] as List<String>).map((activity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: festival['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(activity, style: TextStyle(fontSize: 12, color: festival['color'], fontWeight: FontWeight.w500)),
                          );
                        }).toList(),
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

  void _showFestivalDetails(Map<String, dynamic> festival) {
    _speakText(festival['description']);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 20),
            Text(festival['emoji'], style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text(festival['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: festival['color'])),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: festival['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("📅 ${festival['month']}", style: TextStyle(color: festival['color'])),
            ),
            const SizedBox(height: 16),
            Text(festival['description'], style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const Text("🎯 Activities", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: (festival['activities'] as List<String>).map((activity) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [festival['color'], festival['color'].withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(activity, style: const TextStyle(color: Colors.white, fontSize: 13)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
