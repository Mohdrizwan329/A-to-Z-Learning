import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class CulturalAwarenessPage extends StatefulWidget {
  const CulturalAwarenessPage({super.key});

  @override
  State<CulturalAwarenessPage> createState() => _CulturalAwarenessPageState();
}

class _CulturalAwarenessPageState extends State<CulturalAwarenessPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  final List<Map<String, dynamic>> traditions = [
    {
      'name': 'Namaste',
      'emoji': '🙏',
      'description': 'Greeting with folded hands to show respect',
    },
    {
      'name': 'Touching Feet',
      'emoji': '🦶',
      'description': 'Touching elders feet to get their blessings',
    },
    {
      'name': 'Rangoli',
      'emoji': '🎨',
      'description': 'Colorful patterns made on floor during festivals',
    },
    {
      'name': 'Diya Lighting',
      'emoji': '🪔',
      'description': 'Lighting oil lamps to bring light and positivity',
    },
    {
      'name': 'Mehndi',
      'emoji': '✋',
      'description': 'Beautiful henna designs on hands for celebrations',
    },
    {
      'name': 'Aarti',
      'emoji': '🔥',
      'description': 'Waving lighted lamp in circular motion as prayer',
    },
    {
      'name': 'Tilak',
      'emoji': '🔴',
      'description': 'Red mark on forehead for blessings and welcome',
    },
    {
      'name': 'Garland Welcome',
      'emoji': '💐',
      'description': 'Welcoming guests with flower garlands',
    },
  ];

  final List<Map<String, dynamic>> clothing = [
    {
      'name': 'Saree',
      'emoji': '👗',
      'subtitle': 'All India',
      'description': 'Beautiful draped cloth worn by women',
    },
    {
      'name': 'Kurta Pajama',
      'emoji': '👔',
      'subtitle': 'North India',
      'description': 'Long shirt with loose pants for men',
    },
    {
      'name': 'Lehenga Choli',
      'emoji': '👘',
      'subtitle': 'North India',
      'description': 'Long skirt with short blouse for special occasions',
    },
    {
      'name': 'Dhoti',
      'emoji': '🩱',
      'subtitle': 'All India',
      'description': 'Wrapped cloth worn by men on lower body',
    },
    {
      'name': 'Salwar Kameez',
      'emoji': '👚',
      'subtitle': 'North India',
      'description': 'Long tunic with loose pants for women',
    },
    {
      'name': 'Mundu',
      'emoji': '🧣',
      'subtitle': 'Kerala',
      'description': 'White cloth wrapped around waist',
    },
    {
      'name': 'Turban',
      'emoji': '🎀',
      'subtitle': 'Rajasthan & Punjab',
      'description': 'Colorful headwear showing honor and respect',
    },
    {
      'name': 'Sherwani',
      'emoji': '🥼',
      'subtitle': 'All India',
      'description': 'Long coat worn by groom at weddings',
    },
  ];

  final List<Map<String, dynamic>> foods = [
    {
      'name': 'Roti',
      'emoji': '🫓',
      'subtitle': 'North India',
      'description': 'Flat bread made from wheat flour',
    },
    {
      'name': 'Rice',
      'emoji': '🍚',
      'subtitle': 'South & East India',
      'description': 'Main food in many states',
    },
    {
      'name': 'Dal',
      'emoji': '🥣',
      'subtitle': 'All India',
      'description': 'Lentil soup eaten with rice or roti',
    },
    {
      'name': 'Samosa',
      'emoji': '🥟',
      'subtitle': 'All India',
      'description': 'Triangle snack filled with potatoes',
    },
    {
      'name': 'Dosa',
      'emoji': '🥞',
      'subtitle': 'South India',
      'description': 'Crispy crepe made from rice batter',
    },
    {
      'name': 'Biryani',
      'emoji': '🍲',
      'subtitle': 'Hyderabad',
      'description': 'Spiced rice dish with meat or vegetables',
    },
    {
      'name': 'Laddu',
      'emoji': '🟡',
      'subtitle': 'All India',
      'description': 'Sweet ball shaped dessert',
    },
    {
      'name': 'Chai',
      'emoji': '☕',
      'subtitle': 'All India',
      'description': 'Sweet spiced tea with milk',
    },
  ];

  final List<Map<String, dynamic>> arts = [
    {
      'name': 'Classical Dance',
      'emoji': '💃',
      'description': 'Bharatanatyam, Kathak, Odissi',
    },
    {
      'name': 'Folk Dance',
      'emoji': '🕺',
      'description': 'Bhangra, Garba, Bihu',
    },
    {
      'name': 'Classical Music',
      'emoji': '🎵',
      'description': 'Raag, Carnatic, Hindustani',
    },
    {
      'name': 'Instruments',
      'emoji': '🪘',
      'description': 'Tabla, Sitar, Veena, Flute',
    },
    {
      'name': 'Painting',
      'emoji': '🖼️',
      'description': 'Madhubani, Warli, Tanjore',
    },
    {'name': 'Pottery', 'emoji': '🏺', 'description': 'Clay pots, Terracotta'},
    {
      'name': 'Weaving',
      'emoji': '🧵',
      'description': 'Silk weaving, Carpet making',
    },
    {
      'name': 'Sculpture',
      'emoji': '🗿',
      'description': 'Stone carving, Metal work',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ProgressService.to.markItemCompleted(
          ProgressService.kCulturalAwareness,
          _tabController.index,
        );
      }
    });
    ProgressService.to.markItemCompleted(ProgressService.kCulturalAwareness, 0);
    initGridAnimations(this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    disposeGridAnimations();
    flutterTts.stop();
    super.dispose();
  }

  List<Map<String, dynamic>> _getItemsForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return traditions;
      case 1:
        return clothing;
      case 2:
        return foods;
      case 3:
        return arts;
      default:
        return traditions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Indian Culture',
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
                ProgressService.kCulturalAwareness,
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
        tabAlignment: TabAlignment.center,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
        tabs: const [
          Tab(text: "Traditions"),
          Tab(text: "Clothing"),
          Tab(text: "Food"),
          Tab(text: "Arts"),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kCulturalAwareness,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kCulturalAwareness,
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
              children: List.generate(
                4,
                (tabIndex) => _buildCategoryGrid(tabIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(int tabIndex) {
    final items = _getItemsForTab(tabIndex);
    return GridView.builder(
      padding: EdgeInsets.all(12.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.r,
        crossAxisSpacing: 12.r,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final gradient = AppColors.getGradientForIndex(index);
        final subtitle = item['subtitle'] ?? '';
        return buildFloatingItem(
          index: index,
          child: GradientCard(
            gradient: gradient,
            isSelected: false,
            onTap: () {
              TtsService.to.speak(item['name']);
            },
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
                        item['emoji'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  GradientCardText(text: item['name'], fontSize: 12),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
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
