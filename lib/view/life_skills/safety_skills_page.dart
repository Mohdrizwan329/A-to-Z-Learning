import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class SafetySkillsPage extends StatefulWidget {
  const SafetySkillsPage({super.key});

  @override
  State<SafetySkillsPage> createState() => _SafetySkillsPageState();
}

class _SafetySkillsPageState extends State<SafetySkillsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final ProgressService _progress = ProgressService.to;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Road Safety',
      'icon': Icons.traffic,
      'desc': 'Stay safe when walking near roads',
    },
    {
      'title': 'Stranger Safety',
      'icon': Icons.warning_amber,
      'desc': 'Be careful with unknown people',
    },
    {
      'title': 'Fire Safety',
      'icon': Icons.local_fire_department,
      'desc': 'Know what to do in case of fire',
    },
    {'title': 'Home Safety', 'icon': Icons.home, 'desc': 'Stay safe at home'},
    {
      'title': 'Water Safety',
      'icon': Icons.pool,
      'desc': 'Be careful around water',
    },
    {
      'title': 'Personal Safety',
      'icon': Icons.shield,
      'desc': 'Keep your body safe',
    },
    {
      'title': 'Emergency Numbers',
      'icon': Icons.phone_in_talk,
      'desc': 'Know important numbers',
    },
    {
      'title': 'Safety Quiz',
      'icon': Icons.quiz,
      'desc': 'Test what you learned',
    },
  ];

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
      title: 'Safety Skills',
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
            _progress.resetProgress(ProgressService.kSafetySkills);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          ...List.generate(8, (i) {
            final top = (i * 67.0) % MediaQuery.of(context).size.height;
            final left = (i * 83.0) % MediaQuery.of(context).size.width;
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                final value = _bubbleController.value;
                final offset =
                    20.0 *
                    ((value * 2 * 3.14159).clamp(0, 6.28) != 0
                        ? (value * 2 * 3.14159).abs() % 1
                        : 0);
                return Positioned(
                  top: top + offset,
                  left: left,
                  child: Container(
                    width: 20.w + (i % 3) * 15.0,
                    height: 20.h + (i % 3) * 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          Column(
            children: [
              Obx(() {
                final progress =
                    _progress.getProgressPercentage(
                      ProgressService.kSafetySkills,
                    ) /
                    100;
                final progressString = _progress.getProgressString(
                  ProgressService.kSafetySkills,
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
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 14.r,
                    mainAxisSpacing: 14.r,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final gradientColors = AppColors.getGradientForIndex(index);
                    return buildFloatingItem(
                      index: index,
                      child: Obx(() {
                        final isCompleted = _progress.isItemCompleted(
                          ProgressService.kSafetySkills,
                          index,
                        );
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(
                              () => _SafetySkillsDetailPage(
                                sectionIndex: index,
                                title: section['title'],
                              ),
                            );
                            if (!_progress.isItemCompleted(
                              ProgressService.kSafetySkills,
                              index,
                            )) {
                              await _progress.markItemCompleted(
                                ProgressService.kSafetySkills,
                                index,
                              );
                            }
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              if (isCompleted)
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.r,
                                    ),
                                  ),
                                ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      section['icon'],
                                      size: 48.r,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10.h),
                                    Flexible(
                                      child: Text(
                                        section['title'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: Text(
                                        section['desc'],
                                        style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Detail Page ───────────────────────────────────────────────────────────────

class _SafetySkillsDetailPage extends StatefulWidget {
  final int sectionIndex;
  final String title;

  const _SafetySkillsDetailPage({
    required this.sectionIndex,
    required this.title,
  });

  @override
  State<_SafetySkillsDetailPage> createState() =>
      _SafetySkillsDetailPageState();
}

class _SafetySkillsDetailPageState extends State<_SafetySkillsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
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
      title: widget.title,
      body: Stack(
        children: [
          ...List.generate(8, (i) {
            final top = (i * 67.0) % MediaQuery.of(context).size.height;
            final left = (i * 83.0) % MediaQuery.of(context).size.width;
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                final value = _bubbleController.value;
                final offset =
                    20.0 *
                    ((value * 2 * 3.14159).clamp(0, 6.28) != 0
                        ? (value * 2 * 3.14159).abs() % 1
                        : 0);
                return Positioned(
                  top: top + offset,
                  left: left,
                  child: Container(
                    width: 20.w + (i % 3) * 15.0,
                    height: 20.h + (i % 3) * 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.sectionIndex) {
      case 0:
        return _buildRoadSafety();
      case 1:
        return _buildStrangerSafety();
      case 2:
        return _buildFireSafety();
      case 3:
        return _buildHomeSafety();
      case 4:
        return _buildWaterSafety();
      case 5:
        return _buildPersonalSafety();
      case 6:
        return _buildEmergencyNumbers();
      case 7:
        return _buildQuiz();
      default:
        return const SizedBox();
    }
  }

  // ── Section 0: Road Safety ────────────────────────────────────────────────

  Widget _buildRoadSafety() {
    final rules = [
      {
        'rule': 'Always use crosswalks/zebra crossings',
        'icon': Icons.directions_walk,
      },
      {'rule': 'Look left, right, then left again', 'icon': Icons.visibility},
      {
        'rule': 'Wait for the green light',
        'icon': Icons.circle,
        'color': Colors.green,
      },
      {'rule': 'Never run across the road', 'icon': Icons.do_not_step},
      {'rule': 'Walk on the footpath/sidewalk', 'icon': Icons.directions},
      {'rule': 'Hold an adult\'s hand', 'icon': Icons.people},
      {'rule': 'Don\'t play near roads', 'icon': Icons.sports_soccer},
      {'rule': 'Wear bright colors at night', 'icon': Icons.light_mode},
    ];

    final trafficLights = [
      {'color': 'Red', 'meaning': 'STOP!\nDo not cross', 'bgColor': Colors.red},
      {
        'color': 'Yellow',
        'meaning': 'WAIT!\nGet ready',
        'bgColor': Colors.amber,
      },
      {
        'color': 'Green',
        'meaning': 'GO!\nCross carefully',
        'bgColor': Colors.green,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Road Safety',
          'Stay safe when walking near roads!',
          Icons.traffic,
          0,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Road Rules'),
        SizedBox(height: 10.h),
        ...rules.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(r['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      r['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('Traffic Lights'),
        SizedBox(height: 10.h),
        Row(
          children: trafficLights.map<Widget>((light) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: (light['bgColor'] as Color).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: (light['bgColor'] as Color).withValues(alpha: 0.4),
                      blurRadius: 8.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 36.r),
                    SizedBox(height: 8.h),
                    Text(
                      light['color'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      light['meaning'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Section 1: Stranger Safety ────────────────────────────────────────────

  Widget _buildStrangerSafety() {
    final safeAdults = [
      {'who': 'Police officers in uniform', 'icon': Icons.local_police},
      {'who': 'Teachers at school', 'icon': Icons.school},
      {'who': 'Shop workers in their shop', 'icon': Icons.store},
      {'who': 'Firefighters in uniform', 'icon': Icons.fire_truck},
    ];

    final rules = [
      {'rule': 'Never go anywhere with a stranger', 'icon': Icons.block},
      {
        'rule': 'Don\'t accept gifts from strangers',
        'icon': Icons.card_giftcard,
      },
      {'rule': 'Don\'t get in a stranger\'s car', 'icon': Icons.no_transfer},
      {
        'rule': 'Yell "NO!" and run if grabbed',
        'icon': Icons.record_voice_over,
      },
      {'rule': 'Tell a trusted adult immediately', 'icon': Icons.people},
      {'rule': 'Stay in groups with friends', 'icon': Icons.groups},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Stranger Safety',
          'Not all strangers are bad, but we need to be careful!',
          Icons.warning_amber,
          1,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Safe Adults to Ask for Help'),
        SizedBox(height: 10.h),
        ...safeAdults.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(a['icon'] as IconData, color: Colors.white, size: 30.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      a['who'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('Important Rules'),
        SizedBox(height: 10.h),
        ...rules.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(r['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      r['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 16.h),
        _buildTipCard(
          'Secret Password',
          'Have a secret family password that only trusted people know!',
          Icons.key,
          Colors.amber.shade700,
        ),
      ],
    );
  }

  // ── Section 2: Fire Safety ────────────────────────────────────────────────

  Widget _buildFireSafety() {
    final prevention = [
      {
        'rule': 'Never play with matches or lighters',
        'icon': Icons.do_not_touch,
      },
      {'rule': 'Stay away from candles', 'icon': Icons.nightlight_round},
      {
        'rule': 'Don\'t touch electrical outlets',
        'icon': Icons.electrical_services,
      },
      {'rule': 'Keep things away from heaters', 'icon': Icons.thermostat},
    ];

    final whatToDo = [
      {'action': 'Tell an adult immediately', 'icon': Icons.record_voice_over},
      {'action': 'Get out of the building fast', 'icon': Icons.directions_run},
      {'action': 'Crawl low if there\'s smoke', 'icon': Icons.air},
      {'action': 'Feel doors before opening', 'icon': Icons.door_front_door},
      {'action': 'Never hide in closets', 'icon': Icons.block},
      {'action': 'Meet at the meeting point', 'icon': Icons.location_on},
      {'action': 'Call emergency services', 'icon': Icons.phone},
    ];

    final stopDropRoll = [
      'STOP - Don\'t run!',
      'DROP - Fall to the ground',
      'ROLL - Roll back and forth',
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Fire Safety',
          'Know what to do in case of fire!',
          Icons.local_fire_department,
          2,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Prevention'),
        SizedBox(height: 10.h),
        ...prevention.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(p['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      p['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('If There\'s a Fire'),
        SizedBox(height: 10.h),
        ...whatToDo.asMap().entries.map((entry) {
          final i = entry.key;
          final w = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(w['icon'] as IconData, color: Colors.white, size: 26.r),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      w['action'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('If Clothes Catch Fire'),
        SizedBox(height: 10.h),
        Row(
          children: stopDropRoll.asMap().entries.map<Widget>((entry) {
            final colors = [Colors.red, Colors.orange, Colors.amber];
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: colors[entry.key].withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors[entry.key].withValues(alpha: 0.4),
                      blurRadius: 6.r,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  entry.value,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Section 3: Home Safety ────────────────────────────────────────────────

  Widget _buildHomeSafety() {
    final areas = [
      {
        'area': 'Kitchen',
        'icon': Icons.kitchen,
        'rules': [
          'Don\'t use stove alone',
          'Be careful with hot things',
          'Keep knives away',
        ],
      },
      {
        'area': 'Bathroom',
        'icon': Icons.bathtub,
        'rules': [
          'Don\'t run on wet floors',
          'Keep water in tub',
          'Lock door when using',
        ],
      },
      {
        'area': 'Stairs',
        'icon': Icons.stairs,
        'rules': [
          'Hold the railing',
          'Don\'t run up/down',
          'Keep toys off stairs',
        ],
      },
      {
        'area': 'Outside',
        'icon': Icons.park,
        'rules': [
          'Tell parents where you go',
          'Stay in safe areas',
          'Come home before dark',
        ],
      },
    ];

    final homeAlone = [
      {'rule': 'Don\'t open door for strangers', 'icon': Icons.door_front_door},
      {'rule': 'Know how to call parents', 'icon': Icons.phone},
      {'rule': 'Know emergency numbers', 'icon': Icons.emergency},
      {
        'rule': 'Don\'t tell callers you\'re alone',
        'icon': Icons.phone_disabled,
      },
      {'rule': 'Lock all doors and windows', 'icon': Icons.lock},
    ];

    return Column(
      children: [
        _buildHeaderCard('Home Safety', 'Stay safe at home!', Icons.home, 3),
        SizedBox(height: 16.h),
        ...areas.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        a['icon'] as IconData,
                        color: Colors.white,
                        size: 30.r,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        a['area'] as String,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ...(a['rules'] as List<String>).map((rule) {
                    return Padding(
                      padding: EdgeInsets.only(left: 42.w, bottom: 6.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16.r,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              rule,
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
          );
        }),
        SizedBox(height: 16.h),
        _buildSectionLabel('If Home Alone'),
        SizedBox(height: 10.h),
        ...homeAlone.asMap().entries.map((entry) {
          final i = entry.key;
          final h = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(h['icon'] as IconData, color: Colors.white, size: 26.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      h['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
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

  // ── Section 4: Water Safety ───────────────────────────────────────────────

  Widget _buildWaterSafety() {
    final rules = [
      {'rule': 'Never swim alone', 'icon': Icons.groups},
      {'rule': 'Always have adult supervision', 'icon': Icons.visibility},
      {'rule': 'Learn to swim', 'icon': Icons.pool},
      {'rule': 'Don\'t run near pools', 'icon': Icons.do_not_step},
      {'rule': 'Stay in shallow water first', 'icon': Icons.water},
      {'rule': 'Don\'t push others in water', 'icon': Icons.block},
      {'rule': 'Wear life jacket when boating', 'icon': Icons.sailing},
      {'rule': 'Don\'t dive in unknown water', 'icon': Icons.dangerous},
    ];

    final beachSafety = [
      {'rule': 'Swim where lifeguards are', 'icon': Icons.beach_access},
      {'rule': 'Watch for waves', 'icon': Icons.waves},
      {'rule': 'Stay close to shore', 'icon': Icons.landscape},
      {'rule': 'Know the flag warnings', 'icon': Icons.flag},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Water Safety',
          'Water can be fun but dangerous. Be careful!',
          Icons.pool,
          4,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Pool & Swimming Rules'),
        SizedBox(height: 10.h),
        ...rules.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(r['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      r['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('Beach Safety'),
        SizedBox(height: 10.h),
        ...beachSafety.asMap().entries.map((entry) {
          final i = entry.key;
          final b = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(b['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      b['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
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

  // ── Section 5: Personal Safety ────────────────────────────────────────────

  Widget _buildPersonalSafety() {
    final bodyRules = [
      {'rule': 'Your body belongs to you', 'icon': Icons.person},
      {'rule': 'Private parts are private', 'icon': Icons.lock},
      {
        'rule': 'No one should touch you in ways that feel wrong',
        'icon': Icons.block,
      },
      {'rule': 'It\'s okay to say NO', 'icon': Icons.front_hand},
      {
        'rule': 'Tell a trusted adult if something happens',
        'icon': Icons.record_voice_over,
      },
      {'rule': 'It\'s never your fault', 'icon': Icons.favorite},
    ];

    final trustedAdults = [
      {'who': 'Parents/Guardians', 'icon': Icons.family_restroom},
      {'who': 'Teachers', 'icon': Icons.school},
      {'who': 'School counselor', 'icon': Icons.psychology},
      {'who': 'Grandparents', 'icon': Icons.elderly},
      {'who': 'Police', 'icon': Icons.local_police},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Personal Safety',
          'Keep your body safe!',
          Icons.shield,
          5,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Body Safety Rules'),
        SizedBox(height: 10.h),
        ...bodyRules.asMap().entries.map((entry) {
          final i = entry.key;
          final b = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(b['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      b['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('Trusted Adults You Can Tell'),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.r,
          runSpacing: 10.r,
          children: trustedAdults.asMap().entries.map<Widget>((entry) {
            final i = entry.key;
            final t = entry.value;
            final colors = AppColors.getGradientForIndex(i + 5);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(t['icon'] as IconData, color: Colors.white, size: 20.r),
                  SizedBox(width: 8.w),
                  Text(
                    t['who'] as String,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Section 6: Emergency Numbers ──────────────────────────────────────────

  Widget _buildEmergencyNumbers() {
    final numbers = [
      {
        'service': 'Police',
        'number': '100',
        'icon': Icons.local_police,
        'when': 'Crime, danger, or emergency',
      },
      {
        'service': 'Fire',
        'number': '101',
        'icon': Icons.fire_truck,
        'when': 'Fire emergency',
      },
      {
        'service': 'Ambulance',
        'number': '102',
        'icon': Icons.local_hospital,
        'when': 'Medical emergency',
      },
      {
        'service': 'Women Helpline',
        'number': '1091',
        'icon': Icons.woman,
        'when': 'Women in danger',
      },
      {
        'service': 'Child Helpline',
        'number': '1098',
        'icon': Icons.child_care,
        'when': 'Children in danger',
      },
      {
        'service': 'Emergency',
        'number': '112',
        'icon': Icons.emergency,
        'when': 'Any emergency',
      },
    ];

    final howToCall = [
      {'step': 'Stay calm', 'icon': Icons.spa},
      {'step': 'Tell them what happened', 'icon': Icons.record_voice_over},
      {'step': 'Give your location/address', 'icon': Icons.location_on},
      {'step': 'Give your name and phone number', 'icon': Icons.badge},
      {'step': 'Stay on the line', 'icon': Icons.phone_in_talk},
      {'step': 'Follow their instructions', 'icon': Icons.checklist},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Emergency Numbers',
          'Know these important numbers!',
          Icons.phone_in_talk,
          6,
        ),
        SizedBox(height: 16.h),
        ...numbers.asMap().entries.map((entry) {
          final i = entry.key;
          final n = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(n['icon'] as IconData, color: Colors.white, size: 32.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n['service'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          n['when'] as String,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      n['number'] as String,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('How to Call'),
        SizedBox(height: 10.h),
        ...howToCall.asMap().entries.map((entry) {
          final i = entry.key;
          final h = entry.value;
          final colors = AppColors.getGradientForIndex(i + 6);
          return buildFloatingItem(
            index: (i + 6) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(h['icon'] as IconData, color: Colors.white, size: 24.r),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      h['step'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
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

  // ── Section 7: Safety Quiz ────────────────────────────────────────────────

  Widget _buildQuiz() {
    final questions = [
      {
        'q': 'What do you do at a red light?',
        'a': 'STOP and wait',
        'icon': Icons.traffic,
      },
      {
        'q': 'Should you go with a stranger?',
        'a': 'NEVER',
        'icon': Icons.block,
      },
      {
        'q': 'If clothes catch fire?',
        'a': 'STOP, DROP, ROLL',
        'icon': Icons.local_fire_department,
      },
      {
        'q': 'Can you swim alone?',
        'a': 'NO, always with adult',
        'icon': Icons.pool,
      },
      {
        'q': 'Emergency number in India?',
        'a': '112 or 100',
        'icon': Icons.phone,
      },
      {
        'q': 'Who can you tell secrets to?',
        'a': 'Trusted adults',
        'icon': Icons.people,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Safety Quiz',
          'Test what you learned!',
          Icons.quiz,
          7,
        ),
        SizedBox(height: 16.h),
        ...questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          q['q'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        q['icon'] as IconData,
                        color: Colors.white70,
                        size: 24.r,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 20.r,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          q['a'] as String,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
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
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade600, Colors.amber.shade800],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.4),
                blurRadius: 10.r,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.star, color: Colors.white, size: 44.r),
              SizedBox(height: 8.h),
              Text(
                'I promise to stay safe and follow these rules!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared Helpers ────────────────────────────────────────────────────────

  Widget _buildHeaderCard(
    String title,
    String subtitle,
    IconData icon,
    int colorIndex,
  ) {
    final colors = AppColors.getGradientForIndex(colorIndex);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colors[0], colors[1]]),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.4),
            blurRadius: 16.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 56.r, color: Colors.white),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.8), color]),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  text,
                  style: GoogleFonts.nunito(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
