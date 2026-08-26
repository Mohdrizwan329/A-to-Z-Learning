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

class HygieneHabitsPage extends StatefulWidget {
  const HygieneHabitsPage({super.key});

  @override
  State<HygieneHabitsPage> createState() => _HygieneHabitsPageState();
}

class _HygieneHabitsPageState extends State<HygieneHabitsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int selectedIndex = -1;
  late AnimationController _bubbleController;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Why Hygiene Matters',
      'emoji': '✨',
      'subtitle': 'Stay Healthy',
      'color': Color(0xFF4CAF50),
      'intro': 'Good hygiene keeps you healthy and happy!',
      'reasons': [
        {
          'reason': 'Prevents sickness',
          'emoji': '🦠',
          'detail': 'Germs can\'t make you sick',
        },
        {
          'reason': 'Keeps you fresh',
          'emoji': '🌸',
          'detail': 'You smell and feel clean',
        },
        {
          'reason': 'Healthy teeth',
          'emoji': '😁',
          'detail': 'No cavities or toothaches',
        },
        {
          'reason': 'Makes friends happy',
          'emoji': '👫',
          'detail': 'Everyone likes clean friends',
        },
        {
          'reason': 'Builds good habits',
          'emoji': '⭐',
          'detail': 'Habits last a lifetime',
        },
      ],
    },
    {
      'title': 'Washing Hands',
      'emoji': '🧼',
      'subtitle': 'Stop Germs',
      'color': Color(0xFF2196F3),
      'intro': 'Washing hands is the #1 way to stop germs!',
      'steps': [
        {'step': 'Wet hands with water', 'emoji': '💧'},
        {'step': 'Add soap', 'emoji': '🧴'},
        {'step': 'Rub hands together - make bubbles!', 'emoji': '🫧'},
        {'step': 'Scrub between fingers', 'emoji': '🤞'},
        {'step': 'Clean under fingernails', 'emoji': '💅'},
        {
          'step': 'Wash for 20 seconds (sing Happy Birthday twice!)',
          'emoji': '🎵',
        },
        {'step': 'Rinse with water', 'emoji': '💦'},
        {'step': 'Dry with clean towel', 'emoji': '🧻'},
      ],
      'whenToWash': [
        'Before eating',
        'After using bathroom',
        'After playing outside',
        'After touching pets',
        'After sneezing or coughing',
        'After touching garbage',
      ],
    },
    {
      'title': 'Brushing Teeth',
      'emoji': '🦷',
      'subtitle': 'Healthy Smile',
      'color': Color(0xFF00BCD4),
      'intro': 'Brush twice a day for a healthy smile!',
      'steps': [
        {'step': 'Put pea-sized toothpaste on brush', 'emoji': '🫛'},
        {'step': 'Brush front teeth up and down', 'emoji': '⬆️⬇️'},
        {'step': 'Brush back teeth in circles', 'emoji': '🔄'},
        {'step': 'Brush the chewing surfaces', 'emoji': '😮'},
        {'step': 'Don\'t forget your tongue!', 'emoji': '👅'},
        {'step': 'Brush for 2 minutes', 'emoji': '⏰'},
        {'step': 'Spit out toothpaste', 'emoji': '💦'},
        {'step': 'Rinse your mouth', 'emoji': '🥤'},
      ],
      'tips': [
        'Replace toothbrush every 3 months',
        'Brush morning and night',
        'Visit dentist twice a year',
        'Avoid too many sweets',
      ],
    },
    {
      'title': 'Taking a Bath',
      'emoji': '🛁',
      'subtitle': 'Body Clean',
      'color': Color(0xFF9C27B0),
      'intro': 'Baths and showers keep your body clean!',
      'bodyParts': [
        {'part': 'Hair', 'emoji': '💆', 'how': 'Shampoo and scrub scalp'},
        {'part': 'Face', 'emoji': '😊', 'how': 'Wash gently with water'},
        {'part': 'Ears', 'emoji': '👂', 'how': 'Clean behind and around ears'},
        {'part': 'Neck', 'emoji': '🦒', 'how': 'Wash all around'},
        {
          'part': 'Arms & Underarms',
          'emoji': '💪',
          'how': 'Don\'t forget underarms!',
        },
        {'part': 'Body', 'emoji': '🧍', 'how': 'Soap up everywhere'},
        {'part': 'Legs & Feet', 'emoji': '🦶', 'how': 'Scrub between toes'},
      ],
      'afterBath': [
        'Dry off completely',
        'Put on clean clothes',
        'Comb your hair',
        'Apply lotion if needed',
      ],
    },
    {
      'title': 'Nail Care',
      'emoji': '💅',
      'subtitle': 'Clean Nails',
      'color': Color(0xFFE91E63),
      'intro': 'Clean, trimmed nails look great and stay healthy!',
      'tips': [
        {
          'tip': 'Trim nails regularly',
          'emoji': '✂️',
          'why': 'Prevents dirt buildup',
        },
        {
          'tip': 'Keep nails clean',
          'emoji': '🧼',
          'why': 'Germs hide under dirty nails',
        },
        {
          'tip': 'Don\'t bite nails',
          'emoji': '🚫',
          'why': 'Germs go in your mouth',
        },
        {
          'tip': 'Cut straight across',
          'emoji': '➡️',
          'why': 'Prevents ingrown nails',
        },
        {
          'tip': 'Clean under nails',
          'emoji': '🪥',
          'why': 'Removes hidden dirt',
        },
      ],
    },
    {
      'title': 'Hair Care',
      'emoji': '💇',
      'subtitle': 'Healthy Hair',
      'color': Color(0xFFFF9800),
      'intro': 'Healthy hair starts with good care!',
      'routine': [
        {
          'task': 'Wash hair regularly',
          'emoji': '🚿',
          'how': '2-3 times a week',
        },
        {'task': 'Use shampoo', 'emoji': '🧴', 'how': 'Rub into scalp gently'},
        {'task': 'Rinse well', 'emoji': '💧', 'how': 'No shampoo left behind'},
        {'task': 'Comb gently', 'emoji': '🪮', 'how': 'Start from ends'},
        {
          'task': 'Get regular haircuts',
          'emoji': '✂️',
          'how': 'Every few months',
        },
      ],
      'problems': [
        {'problem': 'Tangles', 'solution': 'Use conditioner, comb gently'},
        {'problem': 'Dandruff', 'solution': 'Special shampoo, tell parents'},
        {'problem': 'Lice', 'solution': 'Tell an adult immediately!'},
      ],
    },
    {
      'title': 'Coughs & Sneezes',
      'emoji': '🤧',
      'subtitle': 'Cover Up',
      'color': Color(0xFF795548),
      'intro': 'Stop germs from spreading to others!',
      'rightWay': [
        {
          'do': 'Cover mouth and nose with elbow',
          'emoji': '💪',
          'why': 'Germs stay on your arm',
        },
        {'do': 'Use a tissue', 'emoji': '🧻', 'why': 'Catches the germs'},
        {
          'do': 'Throw tissue away',
          'emoji': '🗑️',
          'why': 'Don\'t keep germy tissues',
        },
        {'do': 'Wash hands after', 'emoji': '🧼', 'why': 'Removes any germs'},
      ],
      'wrongWay': [
        {
          'dont': 'Sneeze into hands',
          'emoji': '✋❌',
          'why': 'Spreads germs when you touch things',
        },
        {
          'dont': 'Sneeze into the air',
          'emoji': '💨❌',
          'why': 'Germs fly everywhere',
        },
        {
          'dont': 'Wipe nose on sleeve',
          'emoji': '👕❌',
          'why': 'Makes clothes germy',
        },
      ],
    },
    {
      'title': 'Daily Checklist',
      'emoji': '📋',
      'subtitle': 'Good Routine',
      'color': Color(0xFF673AB7),
      'intro': 'Follow this checklist every day!',
      'morning': [
        {'task': 'Wash face', 'emoji': '🧼'},
        {'task': 'Brush teeth', 'emoji': '🦷'},
        {'task': 'Comb hair', 'emoji': '🪮'},
        {'task': 'Put on clean clothes', 'emoji': '👕'},
        {'task': 'Put on deodorant (if needed)', 'emoji': '🌸'},
      ],
      'afterMeals': [
        {'task': 'Wash hands', 'emoji': '🧼'},
        {'task': 'Wipe mouth', 'emoji': '🧻'},
        {'task': 'Check teeth for food', 'emoji': '😁'},
      ],
      'evening': [
        {'task': 'Take a bath/shower', 'emoji': '🛁'},
        {'task': 'Brush teeth', 'emoji': '🦷'},
        {'task': 'Wash hands', 'emoji': '🧼'},
        {'task': 'Put on clean pajamas', 'emoji': '🛏️'},
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
      title: 'Hygiene Habits',
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
            ProgressService.to.resetProgress(ProgressService.kHygieneHabits);
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
                      ProgressService.kHygieneHabits,
                    ) /
                    100;
                final progressString = ProgressService.to.getProgressString(
                  ProgressService.kHygieneHabits,
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
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final gradient = AppColors.getGradientForIndex(index);

                    return Obx(() {
                      final isSelected = selectedIndex == index;
                      final isCompleted = ProgressService.to.isItemCompleted(
                        ProgressService.kHygieneHabits,
                        index,
                      );

                      return buildFloatingItem(
                        index: index,
                        child: GradientCard(
                          gradient: gradient,
                          isSelected: isSelected,
                          showDecorations: true,
                          onTap: () {
                            TtsService.to.speak(section['title']);
                            setState(() => selectedIndex = index);
                            ProgressService.to.markItemCompleted(
                              ProgressService.kHygieneHabits,
                              index,
                            );
                            Get.to(
                              () => _HygieneDetailPage(
                                section: section,
                                sectionIndex: index,
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
                                          section['emoji'],
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Flexible(
                                      child: Text(
                                        section['title'],
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
                                        section['subtitle'],
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

/// Detail page for each Hygiene Habits section
class _HygieneDetailPage extends StatefulWidget {
  final Map<String, dynamic> section;
  final int sectionIndex;

  const _HygieneDetailPage({required this.section, required this.sectionIndex});

  @override
  State<_HygieneDetailPage> createState() => _HygieneDetailPageState();
}

class _HygieneDetailPageState extends State<_HygieneDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  Map<String, dynamic> get section => widget.section;
  int get sectionIndex => widget.sectionIndex;
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
      title: section['title'],
      body: Stack(
        children: [
          ..._buildFloatingBubbles(),
          SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
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
                        section['emoji'],
                        style: const TextStyle(fontSize: 50),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        section['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: section['color'],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        section['intro'],
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
                _buildContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (sectionIndex) {
      case 0:
        return _buildWhyMatters();
      case 1:
        return _buildHandWashing();
      case 2:
        return _buildTeethBrushing();
      case 3:
        return _buildBathing();
      case 4:
        return _buildNailCare();
      case 5:
        return _buildHairCare();
      case 6:
        return _buildCoughsCovering();
      case 7:
        return _buildDailyChecklist();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWhyMatters() {
    return Column(
      children: List.generate((section['reasons'] as List).length, (index) {
        final reason = section['reasons'][index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      reason['emoji'],
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reason['reason'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        reason['detail'],
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
          ),
        );
      }),
    );
  }

  Widget _buildHandWashing() {
    int cardIndex = 0;
    return Column(
      children: [
        ...List.generate((section['steps'] as List).length, (index) {
          final step = section['steps'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(step['emoji'], style: const TextStyle(fontSize: 20)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      step['step'],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 8.h),
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(8),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(
                    8,
                  )[0].withValues(alpha: 0.4),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🕐 When to Wash:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.r,
                  runSpacing: 8.r,
                  children: (section['whenToWash'] as List).map<Widget>((when) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        when,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeethBrushing() {
    int cardIndex = 0;
    return Column(
      children: [
        ...List.generate((section['steps'] as List).length, (index) {
          final step = section['steps'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(step['emoji'], style: const TextStyle(fontSize: 20)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      step['step'],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 8.h),
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(8),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(
                    8,
                  )[0].withValues(alpha: 0.4),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Tips:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                ...(section['tips'] as List).map((tip) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.white70, size: 18.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            tip,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white,
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
        ),
      ],
    );
  }

  Widget _buildBathing() {
    int cardIndex = 0;
    return Column(
      children: [
        ...List.generate((section['bodyParts'] as List).length, (index) {
          final part = section['bodyParts'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(part['emoji'], style: const TextStyle(fontSize: 24)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          part['part'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          part['how'],
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
            ),
          );
        }),
        SizedBox(height: 8.h),
        buildFloatingItem(
          index: cardIndex++,
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(7),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(
                    7,
                  )[0].withValues(alpha: 0.4),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✨ After Bath:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                ...(section['afterBath'] as List).map((task) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white70,
                          size: 18.r,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          task,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNailCare() {
    return Column(
      children: List.generate((section['tips'] as List).length, (index) {
        final tip = section['tips'][index];
        final gradient = AppColors.getGradientForIndex(index);
        return buildFloatingItem(
          index: index,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      tip['emoji'],
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['tip'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        tip['why'],
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
          ),
        );
      }),
    );
  }

  Widget _buildHairCare() {
    int cardIndex = 0;
    return Column(
      children: [
        ...List.generate((section['routine'] as List).length, (index) {
          final task = section['routine'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(task['emoji'], style: const TextStyle(fontSize: 24)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['task'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          task['how'],
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
            ),
          );
        }),
        SizedBox(height: 8.h),
        // Problems
        ...List.generate((section['problems'] as List).length, (index) {
          final prob = section['problems'][index];
          final gradient = AppColors.getGradientForIndex(index + 5);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      prob['problem'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      prob['solution'],
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCoughsCovering() {
    int cardIndex = 0;
    return Column(
      children: [
        // Right way
        ...List.generate((section['rightWay'] as List).length, (index) {
          final item = section['rightWay'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(item['emoji'], style: const TextStyle(fontSize: 24)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✅ ${item['do']}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          item['why'],
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 8.h),
        // Wrong way
        ...List.generate((section['wrongWay'] as List).length, (index) {
          final item = section['wrongWay'][index];
          final gradient = AppColors.getGradientForIndex(index + 4);
          return buildFloatingItem(
            index: cardIndex++,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(item['emoji'], style: const TextStyle(fontSize: 24)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '❌ ${item['dont']}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          item['why'],
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDailyChecklist() {
    int cardIndex = 0;
    return Column(
      children: [
        _buildChecklistCard(
          '🌅 Morning',
          section['morning'] as List,
          cardIndex,
          0,
        ),
        SizedBox(height: 12.h),
        _buildChecklistCard(
          '🍽️ After Meals',
          section['afterMeals'] as List,
          cardIndex + 1,
          1,
        ),
        SizedBox(height: 12.h),
        _buildChecklistCard(
          '🌙 Evening',
          section['evening'] as List,
          cardIndex + 2,
          2,
        ),
      ],
    );
  }

  Widget _buildChecklistCard(
    String title,
    List tasks,
    int floatIndex,
    int gradientIndex,
  ) {
    final gradient = AppColors.getGradientForIndex(gradientIndex);
    return buildFloatingItem(
      index: floatIndex,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            ...tasks.map((task) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70, width: 2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.r,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(task['emoji'], style: const TextStyle(fontSize: 18)),
                    SizedBox(width: 8.w),
                    Text(
                      task['task'],
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
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
