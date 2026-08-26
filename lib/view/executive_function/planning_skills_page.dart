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

class PlanningSkillsPage extends StatefulWidget {
  const PlanningSkillsPage({super.key});

  @override
  State<PlanningSkillsPage> createState() => _PlanningSkillsPageState();
}

class _PlanningSkillsPageState extends State<PlanningSkillsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final ProgressService _progress = ProgressService.to;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Planning?',
      'icon': Icons.assignment,
      'desc': 'Think before you do',
    },
    {
      'title': 'Plan Your Morning',
      'icon': Icons.wb_sunny,
      'desc': 'Step-by-step morning routine',
    },
    {
      'title': 'Plan Your Homework',
      'icon': Icons.menu_book,
      'desc': 'Get homework done right',
    },
    {
      'title': 'Plan a Party!',
      'icon': Icons.celebration,
      'desc': 'Organize a fun party',
    },
    {
      'title': 'Think First!',
      'icon': Icons.psychology,
      'desc': 'Questions to ask yourself',
    },
    {
      'title': 'Planning Tools',
      'icon': Icons.construction,
      'desc': 'Tools that help you plan',
    },
    {
      'title': 'Practice Planning',
      'icon': Icons.flag,
      'desc': 'Real activities to try',
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
      title: 'Planning Skills',
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
            _progress.resetProgress(ProgressService.kPlanningSkills);
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
                      ProgressService.kPlanningSkills,
                    ) /
                    100;
                final progressString = _progress.getProgressString(
                  ProgressService.kPlanningSkills,
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
                          ProgressService.kPlanningSkills,
                          index,
                        );
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(
                              () => _PlanningSkillsDetailPage(
                                sectionIndex: index,
                                title: section['title'],
                              ),
                            );
                            if (!_progress.isItemCompleted(
                              ProgressService.kPlanningSkills,
                              index,
                            )) {
                              await _progress.markItemCompleted(
                                ProgressService.kPlanningSkills,
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

class _PlanningSkillsDetailPage extends StatefulWidget {
  final int sectionIndex;
  final String title;

  const _PlanningSkillsDetailPage({
    required this.sectionIndex,
    required this.title,
  });

  @override
  State<_PlanningSkillsDetailPage> createState() =>
      _PlanningSkillsDetailPageState();
}

class _PlanningSkillsDetailPageState extends State<_PlanningSkillsDetailPage>
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
        return _buildWhatIsPlanning();
      case 1:
        return _buildPlanMorning();
      case 2:
        return _buildPlanHomework();
      case 3:
        return _buildPlanParty();
      case 4:
        return _buildThinkFirst();
      case 5:
        return _buildPlanningTools();
      case 6:
        return _buildPracticePlanning();
      default:
        return const SizedBox();
    }
  }

  // ── Section 0: What is Planning? ──────────────────────────────────────────

  Widget _buildWhatIsPlanning() {
    final concepts = [
      {
        'text': 'Planning means thinking before you do something',
        'icon': Icons.lightbulb,
      },
      {
        'text': 'It helps you decide what to do first, second, third...',
        'icon': Icons.format_list_numbered,
      },
      {
        'text': 'Good planning helps you finish tasks easily',
        'icon': Icons.check_circle,
      },
      {'text': 'Everyone can learn to plan better!', 'icon': Icons.star},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'What is Planning?',
          'Learn how to plan like a pro!',
          Icons.assignment,
          0,
        ),
        SizedBox(height: 16.h),
        ...concepts.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
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
                  Icon(c['icon'] as IconData, color: Colors.white, size: 32.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      c['text'] as String,
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
      ],
    );
  }

  // ── Section 1: Plan Your Morning ──────────────────────────────────────────

  Widget _buildPlanMorning() {
    final steps = [
      {'task': 'Wake up when alarm rings', 'icon': Icons.alarm},
      {'task': 'Brush your teeth', 'icon': Icons.clean_hands},
      {'task': 'Take a bath', 'icon': Icons.shower},
      {'task': 'Get dressed', 'icon': Icons.checkroom},
      {'task': 'Eat breakfast', 'icon': Icons.restaurant},
      {'task': 'Pack your bag', 'icon': Icons.backpack},
      {'task': 'Go to school', 'icon': Icons.school},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Plan Your Morning',
          'A step-by-step morning routine!',
          Icons.wb_sunny,
          1,
        ),
        SizedBox(height: 16.h),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
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
                  Container(
                    width: 36.w,
                    height: 36.h,
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
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(s['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      s['task'] as String,
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
      ],
    );
  }

  // ── Section 2: Plan Your Homework ─────────────────────────────────────────

  Widget _buildPlanHomework() {
    final steps = [
      {'task': 'Find a quiet place', 'icon': Icons.volume_off},
      {'task': 'Gather all materials', 'icon': Icons.edit},
      {'task': 'List all homework tasks', 'icon': Icons.list_alt},
      {'task': 'Do the hardest one first', 'icon': Icons.fitness_center},
      {'task': 'Take short breaks', 'icon': Icons.coffee},
      {'task': 'Check your work', 'icon': Icons.check_circle},
      {'task': 'Put homework in bag', 'icon': Icons.backpack},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Plan Your Homework',
          'Get homework done the smart way!',
          Icons.menu_book,
          2,
        ),
        SizedBox(height: 16.h),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
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
                  Container(
                    width: 36.w,
                    height: 36.h,
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
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(s['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      s['task'] as String,
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
      ],
    );
  }

  // ── Section 3: Plan a Party! ──────────────────────────────────────────────

  Widget _buildPlanParty() {
    final planning = [
      {
        'what': 'When?',
        'think': 'Pick a day and time',
        'icon': Icons.calendar_month,
      },
      {'what': 'Where?', 'think': 'At home or a park?', 'icon': Icons.home},
      {'what': 'Who?', 'think': 'Make a guest list', 'icon': Icons.people},
      {'what': 'Food?', 'think': 'Cake, snacks, drinks', 'icon': Icons.cake},
      {
        'what': 'Games?',
        'think': 'Musical chairs, pass the parcel',
        'icon': Icons.sports_esports,
      },
      {
        'what': 'Decorations?',
        'think': 'Balloons, banners',
        'icon': Icons.auto_awesome,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Plan a Party!',
          'Let\'s organize the best party ever!',
          Icons.celebration,
          3,
        ),
        SizedBox(height: 16.h),
        ...planning.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
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
                  Icon(p['icon'] as IconData, color: Colors.white, size: 34.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['what'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          p['think'] as String,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
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

  // ── Section 4: Think First! ───────────────────────────────────────────────

  Widget _buildThinkFirst() {
    final questions = [
      {'q': 'What do I need to do?', 'icon': Icons.help_outline},
      {'q': 'What do I need to use?', 'icon': Icons.build},
      {'q': 'How long will it take?', 'icon': Icons.timer},
      {'q': 'What should I do first?', 'icon': Icons.looks_one},
      {'q': 'What might go wrong?', 'icon': Icons.warning_amber},
      {'q': 'How can I fix problems?', 'icon': Icons.handyman},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Think First!',
          'Ask yourself these questions before starting!',
          Icons.psychology,
          4,
        ),
        SizedBox(height: 16.h),
        ...questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
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
                  Icon(q['icon'] as IconData, color: Colors.white, size: 32.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      q['q'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
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

  // ── Section 5: Planning Tools ─────────────────────────────────────────────

  Widget _buildPlanningTools() {
    final tools = [
      {
        'name': 'To-Do List',
        'icon': Icons.checklist,
        'use': 'Write down all tasks',
      },
      {
        'name': 'Calendar',
        'icon': Icons.calendar_month,
        'use': 'Mark important days',
      },
      {
        'name': 'Checklist',
        'icon': Icons.check_box,
        'use': 'Tick off completed tasks',
      },
      {'name': 'Timer', 'icon': Icons.timer, 'use': 'Set time for each task'},
      {'name': 'Chart', 'icon': Icons.bar_chart, 'use': 'Track your progress'},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Planning Tools',
          'Use these tools to plan better!',
          Icons.construction,
          5,
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 12.r,
            mainAxisSpacing: 12.r,
          ),
          itemCount: tools.length,
          itemBuilder: (context, i) {
            final t = tools[i];
            final colors = AppColors.getGradientForIndex(i);
            return buildFloatingItem(
              index: i % 8,
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      t['icon'] as IconData,
                      color: Colors.white,
                      size: 40.r,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      t['name'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      t['use'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Section 6: Practice Planning ──────────────────────────────────────────

  Widget _buildPracticePlanning() {
    final activities = [
      {'activity': 'Plan tomorrow\'s clothes tonight', 'icon': Icons.checkroom},
      {'activity': 'Make a weekend activity plan', 'icon': Icons.event_note},
      {'activity': 'Plan what to pack for a trip', 'icon': Icons.luggage},
      {'activity': 'Plan steps to build a LEGO set', 'icon': Icons.extension},
      {'activity': 'Plan a drawing before starting', 'icon': Icons.palette},
      {
        'activity': 'Plan your playtime activities',
        'icon': Icons.sports_soccer,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Practice Planning',
          'Try these real activities!',
          Icons.flag,
          6,
        ),
        SizedBox(height: 16.h),
        ...activities.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value;
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
                  Icon(a['icon'] as IconData, color: Colors.white, size: 30.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      a['activity'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 18.r,
                  ),
                ],
              ),
            ),
          );
        }),
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
}
