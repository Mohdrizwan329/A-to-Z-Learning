import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class SocialAwarenessPage extends StatefulWidget {
  const SocialAwarenessPage({super.key});

  @override
  State<SocialAwarenessPage> createState() => _SocialAwarenessPageState();
}

class _SocialAwarenessPageState extends State<SocialAwarenessPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> goodManners = [
    {'title': 'Say Please', 'emoji': '🙏', 'description': 'Always say please when asking for something'},
    {'title': 'Say Thank You', 'emoji': '😊', 'description': 'Thank people when they help you'},
    {'title': 'Say Sorry', 'emoji': '😔', 'description': 'Apologize when you make a mistake'},
    {'title': 'Share with Others', 'emoji': '🤝', 'description': 'Share your toys and food with friends'},
    {'title': 'Wait Your Turn', 'emoji': '⏳', 'description': 'Be patient and wait in line'},
    {'title': 'Listen Carefully', 'emoji': '👂', 'description': 'Pay attention when others speak'},
    {'title': 'Respect Elders', 'emoji': '👴', 'description': 'Be polite to older people'},
    {'title': 'Help Others', 'emoji': '💪', 'description': 'Help people who need it'},
    {'title': 'Be Kind', 'emoji': '❤️', 'description': 'Be nice to everyone'},
    {'title': 'Don\'t Lie', 'emoji': '✅', 'description': 'Always tell the truth'},
  ];

  final List<Map<String, dynamic>> communityHelpers = [
    {'title': 'Doctor', 'emoji': '👨‍⚕️', 'work': 'Takes care of sick people', 'place': 'Hospital'},
    {'title': 'Teacher', 'emoji': '👩‍🏫', 'work': 'Teaches us in school', 'place': 'School'},
    {'title': 'Police', 'emoji': '👮', 'work': 'Keeps us safe', 'place': 'Police Station'},
    {'title': 'Firefighter', 'emoji': '👨‍🚒', 'work': 'Puts out fires', 'place': 'Fire Station'},
    {'title': 'Farmer', 'emoji': '👨‍🌾', 'work': 'Grows our food', 'place': 'Farm'},
    {'title': 'Nurse', 'emoji': '👩‍⚕️', 'work': 'Cares for patients', 'place': 'Hospital'},
    {'title': 'Postman', 'emoji': '📬', 'work': 'Delivers our letters', 'place': 'Post Office'},
    {'title': 'Chef', 'emoji': '👨‍🍳', 'work': 'Cooks delicious food', 'place': 'Restaurant'},
    {'title': 'Pilot', 'emoji': '👨‍✈️', 'work': 'Flies airplanes', 'place': 'Airport'},
    {'title': 'Driver', 'emoji': '🚌', 'work': 'Drives buses and cars', 'place': 'Road'},
  ];

  final List<Map<String, dynamic>> safetyRules = [
    {'title': 'Road Safety', 'emoji': '🚦', 'rules': ['Look both ways before crossing', 'Use zebra crossing', 'Walk on footpath', 'Don\'t play on road']},
    {'title': 'Home Safety', 'emoji': '🏠', 'rules': ['Don\'t touch electric sockets', 'Don\'t play with fire', 'Keep sharp objects away', 'Lock doors properly']},
    {'title': 'Water Safety', 'emoji': '🏊', 'rules': ['Never swim alone', 'Learn to swim', 'Don\'t run near pools', 'Wear life jacket in boats']},
    {'title': 'Stranger Danger', 'emoji': '⚠️', 'rules': ['Don\'t talk to strangers', 'Don\'t take gifts from strangers', 'Stay close to parents', 'Know your address']},
    {'title': 'Internet Safety', 'emoji': '💻', 'rules': ['Don\'t share personal info', 'Tell parents if scared', 'Use internet with adults', 'Be kind online']},
  ];

  final List<Map<String, dynamic>> festivals = [
    {'name': 'Diwali', 'emoji': '🪔', 'about': 'Festival of Lights', 'month': 'October/November'},
    {'name': 'Holi', 'emoji': '🎨', 'about': 'Festival of Colors', 'month': 'March'},
    {'name': 'Eid', 'emoji': '🌙', 'about': 'Festival after Ramadan', 'month': 'Varies'},
    {'name': 'Christmas', 'emoji': '🎄', 'about': 'Birth of Jesus Christ', 'month': 'December'},
    {'name': 'Raksha Bandhan', 'emoji': '🎀', 'about': 'Brother-Sister bond', 'month': 'August'},
    {'name': 'Ganesh Chaturthi', 'emoji': '🐘', 'about': 'Lord Ganesha\'s birthday', 'month': 'August/September'},
  ];

  int selectedSafetyIndex = -1;

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text("Social Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: "Manners", icon: Icon(Icons.favorite, size: 18)),
            Tab(text: "Helpers", icon: Icon(Icons.people, size: 18)),
            Tab(text: "Safety", icon: Icon(Icons.shield, size: 18)),
            Tab(text: "Festivals", icon: Icon(Icons.celebration, size: 18)),
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
            _buildMannersTab(),
            _buildHelpersTab(),
            _buildSafetyTab(),
            _buildFestivalsTab(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildMannersTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: goodManners.length,
      itemBuilder: (context, index) {
        final manner = goodManners[index];
        final colors = [
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
          [Color(0xFF56D97F), Color(0xFF11998E)],
        ];
        final gradient = colors[index % colors.length];

        return GestureDetector(
          onTap: () => _speakText("${manner['title']}. ${manner['description']}"),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(manner['emoji'], style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    manner['title'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    manner['description'],
                    style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.9)),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  const Icon(Icons.volume_up, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpersTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: communityHelpers.length,
      itemBuilder: (context, index) {
        final helper = communityHelpers[index];
        final colors = [
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
          [Color(0xFF56D97F), Color(0xFF11998E)],
        ];
        final gradient = colors[index % colors.length];

        return GestureDetector(
          onTap: () => _speakText("${helper['title']}. ${helper['work']}. Works at ${helper['place']}"),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(helper['emoji'], style: const TextStyle(fontSize: 45)),
                  const SizedBox(height: 8),
                  Text(
                    helper['title'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    helper['work'],
                    style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.9)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "📍 ${helper['place']}",
                      style: const TextStyle(fontSize: 10, color: Colors.white),
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

  Widget _buildSafetyTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: safetyRules.length,
      itemBuilder: (context, index) {
        final safety = safetyRules[index];
        final isExpanded = selectedSafetyIndex == index;
        final colors = [
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
          [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
          [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        ];
        final gradient = colors[index % colors.length];

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSafetyIndex = isExpanded ? -1 : index;
            });
            _speakText(safety['title']);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(safety['emoji'], style: const TextStyle(fontSize: 36)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          safety['title'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                if (isExpanded)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        ...List.generate(
                          (safety['rules'] as List).length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text("✓", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    safety['rules'][i],
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildFestivalsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: festivals.length,
      itemBuilder: (context, index) {
        final festival = festivals[index];
        final colors = [
          [Color(0xFFFFD700), Color(0xFFFFA500)],
          [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
          [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          [Color(0xFF56D97F), Color(0xFF11998E)],
          [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
          [Color(0xFF667EEA), Color(0xFF764BA2)],
        ];
        final gradient = colors[index % colors.length];

        return GestureDetector(
          onTap: () => _speakText("${festival['name']}. ${festival['about']}. Celebrated in ${festival['month']}"),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(festival['emoji'], style: const TextStyle(fontSize: 45)),
                  const SizedBox(height: 8),
                  Text(
                    festival['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    festival['about'],
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "📅 ${festival['month']}",
                      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
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
