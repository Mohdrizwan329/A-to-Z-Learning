import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class DiyLearningPage extends StatefulWidget {
  const DiyLearningPage({super.key});

  @override
  State<DiyLearningPage> createState() => _DiyLearningPageState();
}

class _DiyLearningPageState extends State<DiyLearningPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int selectedIndex = -1;
  late AnimationController _bubbleController;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Math Tools',
      'emoji': '🔢',
      'subtitle': 'Count & Learn',
      'color': Color(0xFF6366F1),
      'description': 'Make your own math learning tools',
      'items': [
        {
          'name': 'Number Line Bracelet',
          'emoji': '📏',
          'materials': ['Beads', 'String', 'Number stickers'],
          'steps': [
            'String beads 0-10 on bracelet',
            'Add number stickers to each bead',
            'Wear it to practice counting!',
          ],
          'learning': 'Practice counting and number order',
        },
        {
          'name': 'Dice Math Game',
          'emoji': '🎲',
          'materials': ['Paper', 'Scissors', 'Markers'],
          'steps': [
            'Draw dice template on paper',
            'Cut out and fold into cube',
            'Write numbers or dots on each side',
            'Roll and add numbers together!',
          ],
          'learning': 'Practice addition with fun dice rolls',
        },
        {
          'name': 'Shape Sorter Box',
          'emoji': '🔷',
          'materials': ['Cardboard box', 'Scissors', 'Colored paper'],
          'steps': [
            'Cut different shapes in box lid',
            'Make matching cardboard shapes',
            'Decorate with colors',
            'Sort shapes into the box!',
          ],
          'learning': 'Learn shapes and matching',
        },
      ],
    },
    {
      'name': 'Reading Helpers',
      'emoji': '📚',
      'subtitle': 'Read & Create',
      'color': Color(0xFFEC4899),
      'description': 'Create tools to help you read',
      'items': [
        {
          'name': 'Word Family Wheel',
          'emoji': '🎡',
          'materials': ['2 paper plates', 'Brass fastener', 'Markers'],
          'steps': [
            'Cut window in top plate',
            'Write word endings on bottom plate',
            'Write beginning letters around window',
            'Connect with fastener and spin!',
          ],
          'learning': 'Practice word families like -at, -an, -op',
        },
        {
          'name': 'Sight Word Flashcards',
          'emoji': '🃏',
          'materials': ['Index cards', 'Markers', 'Ring clip'],
          'steps': [
            'Write sight words on cards',
            'Add fun drawings',
            'Punch hole and connect with ring',
            'Practice anywhere!',
          ],
          'learning': 'Learn common words by sight',
        },
        {
          'name': 'Story Stones',
          'emoji': '🪨',
          'materials': ['Smooth stones', 'Paint', 'Clear sealant'],
          'steps': [
            'Collect smooth stones',
            'Paint pictures: characters, places, objects',
            'Let dry and seal',
            'Pick stones to make stories!',
          ],
          'learning': 'Creative storytelling practice',
        },
      ],
    },
    {
      'name': 'Science Kits',
      'emoji': '🔬',
      'subtitle': 'Explore & Discover',
      'color': Color(0xFF10B981),
      'description': 'Build science exploration tools',
      'items': [
        {
          'name': 'Bug Viewer Box',
          'emoji': '🐛',
          'materials': ['Plastic container', 'Magnifying glass', 'Mesh fabric'],
          'steps': [
            'Cut hole in lid',
            'Glue mesh over hole for air',
            'Add magnifying glass to side',
            'Collect and observe bugs safely!',
          ],
          'learning': 'Observe insects up close',
        },
        {
          'name': 'Rain Gauge',
          'emoji': '🌧️',
          'materials': ['Plastic bottle', 'Ruler', 'Permanent marker'],
          'steps': [
            'Cut top off bottle',
            'Mark measurements on side',
            'Place outside when it rains',
            'Measure rainfall each day!',
          ],
          'learning': 'Track weather and measurements',
        },
        {
          'name': 'Magnet Discovery Kit',
          'emoji': '🧲',
          'materials': ['Magnet', 'Small box', 'Various objects'],
          'steps': [
            'Collect small objects (clips, coins, toys)',
            'Test each with your magnet',
            'Sort into "magnetic" and "not magnetic"',
            'Record your findings!',
          ],
          'learning': 'Discover magnetic properties',
        },
      ],
    },
    {
      'name': 'Art Materials',
      'emoji': '🎨',
      'subtitle': 'Make & Play',
      'color': Color(0xFFF59E0B),
      'description': 'Make your own art supplies',
      'items': [
        {
          'name': 'Homemade Playdough',
          'emoji': '🟡',
          'materials': ['Flour', 'Salt', 'Water', 'Food coloring', 'Oil'],
          'steps': [
            'Mix 1 cup flour + 1/2 cup salt',
            'Add 1/2 cup water + 1 tbsp oil',
            'Add food coloring',
            'Knead until smooth!',
          ],
          'learning': 'Create and mold shapes',
        },
        {
          'name': 'Nature Paintbrushes',
          'emoji': '🌿',
          'materials': ['Sticks', 'Leaves', 'Flowers', 'String'],
          'steps': [
            'Collect interesting plants',
            'Tie leaves/flowers to sticks',
            'Dip in paint',
            'Create unique textures!',
          ],
          'learning': 'Explore textures and patterns',
        },
        {
          'name': 'Recycled Stamps',
          'emoji': '♻️',
          'materials': ['Bottle caps', 'Foam', 'Cardboard tubes'],
          'steps': [
            'Cut shapes from foam',
            'Glue to caps or tubes',
            'Dip in paint',
            'Stamp patterns and designs!',
          ],
          'learning': 'Patterns and recycling creativity',
        },
      ],
    },
    {
      'name': 'Music Makers',
      'emoji': '🎵',
      'subtitle': 'Sound & Rhythm',
      'color': Color(0xFF8B5CF6),
      'description': 'Create musical instruments',
      'items': [
        {
          'name': 'Shaker Eggs',
          'emoji': '🥚',
          'materials': ['Plastic eggs', 'Rice/beans', 'Tape'],
          'steps': [
            'Fill eggs with rice or beans',
            'Tape closed securely',
            'Decorate if you want',
            'Shake along to music!',
          ],
          'learning': 'Rhythm and beat patterns',
        },
        {
          'name': 'Rubber Band Guitar',
          'emoji': '🎸',
          'materials': ['Tissue box', 'Rubber bands', 'Cardboard tube'],
          'steps': [
            'Stretch rubber bands over box opening',
            'Attach tube as neck',
            'Pluck different bands',
            'Each makes a different sound!',
          ],
          'learning': 'Sound vibrations and pitch',
        },
        {
          'name': 'Rain Stick',
          'emoji': '🌧️',
          'materials': ['Paper towel tube', 'Toothpicks', 'Rice', 'Tape'],
          'steps': [
            'Poke toothpicks through tube in spiral',
            'Cover one end with paper',
            'Add rice inside',
            'Cover other end and decorate!',
          ],
          'learning': 'Sound effects and rhythm',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 2.0, pulseMax: 1.0);
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'DIY Learning',
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
          ),
          onPressed: () {
            ProgressService.to.resetProgress(ProgressService.kDiyLearning);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          Column(
            children: [
              Obx(() {
                final progress =
                    ProgressService.to.getProgressPercentage(
                      ProgressService.kDiyLearning,
                    ) /
                    100;
                final progressString = ProgressService.to.getProgressString(
                  ProgressService.kDiyLearning,
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
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final gradient = AppColors.getGradientForIndex(index);

                    return Obx(() {
                      final isSelected = selectedIndex == index;
                      final isCompleted = ProgressService.to.isItemCompleted(
                        ProgressService.kDiyLearning,
                        index,
                      );

                      return buildFloatingItem(
                        index: index,
                        child: GradientCard(
                          gradient: gradient,
                          isSelected: isSelected,
                          showDecorations: true,
                          onTap: () {
                            TtsService.to.speak(category['name']);
                            setState(() {
                              selectedIndex = index;
                            });
                            ProgressService.to.markItemCompleted(
                              ProgressService.kDiyLearning,
                              index,
                            );
                            Get.to(
                              () => _DiyLearningDetailPage(
                                category: category,
                                categoryIndex: index,
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 65.w,
                                      height: 65.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.25,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          category['emoji'],
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Flexible(
                                      child: Text(
                                        category['name'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Flexible(
                                      child: Text(
                                        category['subtitle'],
                                        style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isCompleted)
                                Positioned(
                                  bottom: 4.h,
                                  right: 4.w,
                                  child: Container(
                                    padding: EdgeInsets.all(2.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12.r,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

/// Detail page for each DIY Learning category
class _DiyLearningDetailPage extends StatefulWidget {
  final Map<String, dynamic> category;
  final int categoryIndex;

  const _DiyLearningDetailPage({
    required this.category,
    required this.categoryIndex,
  });

  @override
  State<_DiyLearningDetailPage> createState() => _DiyLearningDetailPageState();
}

class _DiyLearningDetailPageState extends State<_DiyLearningDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  Map<String, dynamic> get category => widget.category;
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: category['name'],
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                // Header card
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20.r,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        category['emoji'],
                        style: const TextStyle(fontSize: 50),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        category['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: category['color'],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        category['description'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Items
                ...List.generate((category['items'] as List).length, (index) {
                  final item = category['items'][index];
                  return _buildItemCard(item, index);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, int index) {
    final gradient = AppColors.getGradientForIndex(index);
    return buildFloatingItem(
      index: index,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item header
              Row(
                children: [
                  Container(
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        item['emoji'],
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          item['learning'],
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Materials
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🛠️ Materials:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 8.r,
                      runSpacing: 6.r,
                      children: (item['materials'] as List).map<Widget>((mat) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            mat,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              // Steps
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 Steps:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    ...List.generate((item['steps'] as List).length, (
                      stepIndex,
                    ) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${stepIndex + 1}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                item['steps'][stepIndex],
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              // Learning badge
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item['learning'],
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final size = 20.0 + random.nextDouble() * 60;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
