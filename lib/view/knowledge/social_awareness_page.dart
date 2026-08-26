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

class SocialAwarenessPage extends StatefulWidget {
  const SocialAwarenessPage({super.key});

  @override
  State<SocialAwarenessPage> createState() => _SocialAwarenessPageState();
}

class _SocialAwarenessPageState extends State<SocialAwarenessPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Manners',
      'emoji': '🙏',
      'items': [
        {
          'title': 'Say Please',
          'emoji': '🙏',
          'description': 'Always say please when asking for something',
        },
        {
          'title': 'Say Thank You',
          'emoji': '😊',
          'description': 'Thank people when they help you',
        },
        {
          'title': 'Say Sorry',
          'emoji': '😔',
          'description': 'Apologize when you make a mistake',
        },
        {
          'title': 'Share with Others',
          'emoji': '🤝',
          'description': 'Share your toys and food with friends',
        },
        {
          'title': 'Wait Your Turn',
          'emoji': '⏳',
          'description': 'Be patient and wait in line',
        },
        {
          'title': 'Listen Carefully',
          'emoji': '👂',
          'description': 'Pay attention when others speak',
        },
        {
          'title': 'Respect Elders',
          'emoji': '👴',
          'description': 'Be polite to older people',
        },
        {
          'title': 'Help Others',
          'emoji': '💪',
          'description': 'Help people who need it',
        },
        {
          'title': 'Be Kind',
          'emoji': '❤️',
          'description': 'Be nice to everyone',
        },
        {
          'title': 'Don\'t Lie',
          'emoji': '✅',
          'description': 'Always tell the truth',
        },
      ],
    },
    {
      'title': 'Helpers',
      'emoji': '👨‍⚕️',
      'items': [
        {
          'title': 'Doctor',
          'emoji': '👨‍⚕️',
          'description': 'Takes care of sick people',
          'place': 'Hospital',
        },
        {
          'title': 'Teacher',
          'emoji': '👩‍🏫',
          'description': 'Teaches us in school',
          'place': 'School',
        },
        {
          'title': 'Police',
          'emoji': '👮',
          'description': 'Keeps us safe',
          'place': 'Police Station',
        },
        {
          'title': 'Firefighter',
          'emoji': '👨‍🚒',
          'description': 'Puts out fires',
          'place': 'Fire Station',
        },
        {
          'title': 'Farmer',
          'emoji': '👨‍🌾',
          'description': 'Grows our food',
          'place': 'Farm',
        },
        {
          'title': 'Nurse',
          'emoji': '👩‍⚕️',
          'description': 'Cares for patients',
          'place': 'Hospital',
        },
        {
          'title': 'Postman',
          'emoji': '📬',
          'description': 'Delivers our letters',
          'place': 'Post Office',
        },
        {
          'title': 'Chef',
          'emoji': '👨‍🍳',
          'description': 'Cooks delicious food',
          'place': 'Restaurant',
        },
        {
          'title': 'Pilot',
          'emoji': '👨‍✈️',
          'description': 'Flies airplanes',
          'place': 'Airport',
        },
        {
          'title': 'Driver',
          'emoji': '🚌',
          'description': 'Drives buses and cars',
          'place': 'Road',
        },
      ],
    },
    {
      'title': 'Safety',
      'emoji': '🛡️',
      'items': [
        {
          'title': 'Road Safety',
          'emoji': '🚦',
          'description': 'Look both ways, use zebra crossing, walk on footpath',
        },
        {
          'title': 'Home Safety',
          'emoji': '🏠',
          'description': 'Don\'t touch sockets, don\'t play with fire',
        },
        {
          'title': 'Water Safety',
          'emoji': '🏊',
          'description': 'Never swim alone, wear life jacket',
        },
        {
          'title': 'Stranger Danger',
          'emoji': '⚠️',
          'description': 'Don\'t talk to strangers, stay close to parents',
        },
        {
          'title': 'Internet Safety',
          'emoji': '💻',
          'description': 'Don\'t share personal info, use internet with adults',
        },
      ],
    },
    {
      'title': 'Festivals',
      'emoji': '🎉',
      'items': [
        {
          'title': 'Diwali',
          'emoji': '🪔',
          'description': 'Festival of Lights',
          'month': 'October/November',
        },
        {
          'title': 'Holi',
          'emoji': '🎨',
          'description': 'Festival of Colors',
          'month': 'March',
        },
        {
          'title': 'Eid',
          'emoji': '🌙',
          'description': 'Festival after Ramadan',
          'month': 'Varies',
        },
        {
          'title': 'Christmas',
          'emoji': '🎄',
          'description': 'Birth of Jesus Christ',
          'month': 'December',
        },
        {
          'title': 'Raksha Bandhan',
          'emoji': '🎀',
          'description': 'Brother-Sister bond',
          'month': 'August',
        },
        {
          'title': 'Ganesh Chaturthi',
          'emoji': '🐘',
          'description': 'Lord Ganesha\'s birthday',
          'month': 'August/September',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);
    initGridAnimations(this);
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
    disposeGridAnimations();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Social Skills',
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
                ProgressService.kSocialSkills,
              );
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
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.symmetric(horizontal: 28.w),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Manners"),
          Tab(text: "Helpers"),
          Tab(text: "Safety"),
          Tab(text: "Festivals"),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kSocialSkills,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kSocialSkills,
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
              children: List.generate(categories.length, (tabIndex) {
                return _buildCategoryGrid(tabIndex);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(int tabIndex) {
    final category = categories[tabIndex];
    final items = category['items'] as List<Map<String, dynamic>>;

    return GridView.builder(
      padding: EdgeInsets.all(12.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.r,
        crossAxisSpacing: 16.r,
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
            onTap: () {
              TtsService.to.speak(item['title']);
              ProgressService.to.markItemCompleted(
                ProgressService.kSocialSkills,
                tabIndex,
              );
              _speakText("${item['title']}. ${item['description']}");
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
                        item['emoji'],
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Flexible(
                    child: GradientCardText(text: item['title'], fontSize: 13),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      item['description'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
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
