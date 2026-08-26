import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class CommunityHelpersPage extends StatefulWidget {
  const CommunityHelpersPage({super.key});

  @override
  State<CommunityHelpersPage> createState() => _CommunityHelpersPageState();
}

class _CommunityHelpersPageState extends State<CommunityHelpersPage> {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedHelper;

  final List<Map<String, dynamic>> helpers = [
    {
      'name': 'Doctor',
      'emoji': '👨‍⚕️',
      'color': Color(0xFF4FC3F7),
      'workplace': 'Hospital / Clinic',
      'tools': ['Stethoscope', 'Thermometer', 'Medicine'],
      'howTheyHelp':
          'Doctors help us when we are sick. They check our body and give medicine to make us feel better.',
      'funFact': 'Doctors study for many years to learn how to help people!',
      'whenToCall': 'When you are sick or hurt',
    },
    {
      'name': 'Police Officer',
      'emoji': '👮',
      'color': Color(0xFF5C6BC0),
      'workplace': 'Police Station',
      'tools': ['Uniform', 'Badge', 'Walkie-talkie'],
      'howTheyHelp':
          'Police officers keep us safe. They catch bad people and help when there is trouble.',
      'funFact': 'Police officers help find lost children and pets!',
      'whenToCall': 'When you need help or see something wrong - Call 100',
    },
    {
      'name': 'Firefighter',
      'emoji': '👨‍🚒',
      'color': Color(0xFFEF5350),
      'workplace': 'Fire Station',
      'tools': ['Fire truck', 'Hose', 'Helmet', 'Ladder'],
      'howTheyHelp':
          'Firefighters put out fires and rescue people from dangerous situations.',
      'funFact': 'Firefighters can slide down a pole to get ready quickly!',
      'whenToCall': 'When there is a fire - Call 101',
    },
    {
      'name': 'Teacher',
      'emoji': '👩‍🏫',
      'color': Color(0xFF66BB6A),
      'workplace': 'School',
      'tools': ['Books', 'Chalk', 'Board', 'Computer'],
      'howTheyHelp':
          'Teachers help us learn to read, write, and do math. They teach us new things every day!',
      'funFact': 'Teachers learn new things too, so they can teach better!',
      'whenToCall': 'Every day at school!',
    },
    {
      'name': 'Farmer',
      'emoji': '👨‍🌾',
      'color': Color(0xFF8D6E63),
      'workplace': 'Farm / Fields',
      'tools': ['Tractor', 'Seeds', 'Plow', 'Water'],
      'howTheyHelp':
          'Farmers grow fruits, vegetables, and grains that we eat every day.',
      'funFact': 'Farmers wake up very early before the sun rises!',
      'whenToCall': 'We thank them every time we eat!',
    },
    {
      'name': 'Nurse',
      'emoji': '👩‍⚕️',
      'color': Color(0xFFEC407A),
      'workplace': 'Hospital / Clinic',
      'tools': ['Bandages', 'Syringes', 'Medicine'],
      'howTheyHelp':
          'Nurses take care of sick people. They give medicine and make patients comfortable.',
      'funFact': 'Nurses are often the first people we see at the hospital!',
      'whenToCall': 'When you are at the hospital',
    },
    {
      'name': 'Postman',
      'emoji': '📮',
      'color': Color(0xFFFF7043),
      'workplace': 'Post Office',
      'tools': ['Bag', 'Letters', 'Bicycle/Scooter'],
      'howTheyHelp':
          'Postmen deliver letters and packages to our homes. They connect people far away.',
      'funFact': 'Postmen deliver mail rain or shine!',
      'whenToCall': 'When you send or receive mail',
    },
    {
      'name': 'Chef / Cook',
      'emoji': '👨‍🍳',
      'color': Color(0xFFFFCA28),
      'workplace': 'Restaurant / Kitchen',
      'tools': ['Pots', 'Pans', 'Knives', 'Oven'],
      'howTheyHelp': 'Chefs prepare delicious and healthy food for us to eat.',
      'funFact': 'Chefs can cook hundreds of dishes in one day!',
      'whenToCall': 'When you eat at a restaurant',
    },
    {
      'name': 'Pilot',
      'emoji': '👨‍✈️',
      'color': Color(0xFF42A5F5),
      'workplace': 'Airplane / Airport',
      'tools': ['Airplane', 'Uniform', 'Headset'],
      'howTheyHelp':
          'Pilots fly airplanes to take people and things from one place to another.',
      'funFact': 'Pilots fly above the clouds!',
      'whenToCall': 'When you travel by airplane',
    },
    {
      'name': 'Dentist',
      'emoji': '🦷',
      'color': Color(0xFF26A69A),
      'workplace': 'Dental Clinic',
      'tools': ['Dental chair', 'Mirror', 'Toothbrush'],
      'howTheyHelp':
          'Dentists take care of our teeth. They help keep our smile healthy!',
      'funFact': 'Dentists recommend brushing twice a day!',
      'whenToCall': 'Every 6 months for a checkup',
    },
    {
      'name': 'Soldier',
      'emoji': '🪖',
      'color': Color(0xFF78909C),
      'workplace': 'Army Base / Border',
      'tools': ['Uniform', 'Boots', 'Equipment'],
      'howTheyHelp':
          'Soldiers protect our country and keep us safe from enemies.',
      'funFact': 'Soldiers train very hard to be strong and brave!',
      'whenToCall': 'We thank them every day for protecting us',
    },
    {
      'name': 'Sanitation Worker',
      'emoji': '🧹',
      'color': Color(0xFF9CCC65),
      'workplace': 'Streets / Neighborhoods',
      'tools': ['Broom', 'Cart', 'Gloves'],
      'howTheyHelp':
          'They keep our streets and neighborhoods clean. They collect garbage every day.',
      'funFact': 'They start work very early in the morning!',
      'whenToCall': 'We should thank them and not litter!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Community Helpers',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: selectedHelper == null
                    ? _buildHelpersGrid()
                    : _buildHelperDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpersGrid() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                const Text('🤝', style: TextStyle(fontSize: 40)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'People Who Help Us!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Learn about helpers in our community',
                        style: GoogleFonts.nunito(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12.r,
              crossAxisSpacing: 12.r,
              childAspectRatio: 0.85,
            ),
            itemCount: helpers.length,
            itemBuilder: (context, index) => _buildHelperCard(helpers[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperCard(Map<String, dynamic> helper) {
    return GestureDetector(
      onTap: () {
        TtsService.to.speak(helper['name']);
        _speak(helper['name']);
        setState(() => selectedHelper = helper['name']);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [helper['color'], helper['color'].withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: helper['color'].withValues(alpha: 0.4),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                helper['emoji'],
                style: const TextStyle(fontSize: 36),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                helper['name'],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelperDetail() {
    final helper = helpers.firstWhere((h) => h['name'] == selectedHelper);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: helper['color'].withValues(alpha: 0.4),
                  blurRadius: 20.r,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(helper['emoji'], style: const TextStyle(fontSize: 80)),
                SizedBox(height: 12.h),
                Text(
                  helper['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: helper['color'],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: helper['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '📍 ${helper['workplace']}',
                    style: GoogleFonts.nunito(
                      color: helper['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoCard(
            '🛠️',
            'Tools They Use',
            helper['tools'],
            helper['color'],
          ),
          _buildTextCard(
            '❤️',
            'How They Help',
            helper['howTheyHelp'],
            helper['color'],
          ),
          _buildTextCard(
            '📞',
            'When to Call',
            helper['whenToCall'],
            helper['color'],
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 28)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fun Fact!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      Text(
                        helper['funFact'],
                        style: GoogleFonts.nunito(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String emoji,
    String title,
    List<dynamic> items,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            children: items
                .map<Widget>(
                  (item) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      item,
                      style: GoogleFonts.nunito(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCard(String emoji, String title, String text, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  text,
                  style: GoogleFonts.nunito(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
