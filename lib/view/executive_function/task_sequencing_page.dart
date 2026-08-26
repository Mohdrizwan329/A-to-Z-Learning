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

class TaskSequencingPage extends StatefulWidget {
  const TaskSequencingPage({super.key});

  @override
  State<TaskSequencingPage> createState() => _TaskSequencingPageState();
}

class _TaskSequencingPageState extends State<TaskSequencingPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final ProgressService _progress = ProgressService.to;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Sequencing?',
      'icon': Icons.format_list_numbered,
      'desc': 'Putting things in order',
    },
    {
      'title': 'Making a Sandwich',
      'icon': Icons.lunch_dining,
      'desc': 'Step-by-step sandwich',
    },
    {
      'title': 'Planting a Seed',
      'icon': Icons.eco,
      'desc': 'Grow a plant step by step',
    },
    {
      'title': 'Story Sequence',
      'icon': Icons.auto_stories,
      'desc': 'Beginning, middle & end',
    },
    {
      'title': 'Daily Routines',
      'icon': Icons.schedule,
      'desc': 'Order your daily tasks',
    },
    {
      'title': 'Sequence Words',
      'icon': Icons.abc,
      'desc': 'Words that show order',
    },
    {
      'title': 'Practice Time!',
      'icon': Icons.quiz,
      'desc': 'Test your sequencing skills',
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
      title: 'Task Sequencing',
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
            _progress.resetProgress(ProgressService.kTaskSequencing);
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
                      ProgressService.kTaskSequencing,
                    ) /
                    100;
                final progressString = _progress.getProgressString(
                  ProgressService.kTaskSequencing,
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
                          ProgressService.kTaskSequencing,
                          index,
                        );
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(
                              () => _TaskSequencingDetailPage(
                                sectionIndex: index,
                                title: section['title'],
                              ),
                            );
                            if (!_progress.isItemCompleted(
                              ProgressService.kTaskSequencing,
                              index,
                            )) {
                              await _progress.markItemCompleted(
                                ProgressService.kTaskSequencing,
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

class _TaskSequencingDetailPage extends StatefulWidget {
  final int sectionIndex;
  final String title;

  const _TaskSequencingDetailPage({
    required this.sectionIndex,
    required this.title,
  });

  @override
  State<_TaskSequencingDetailPage> createState() =>
      _TaskSequencingDetailPageState();
}

class _TaskSequencingDetailPageState extends State<_TaskSequencingDetailPage>
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
        return _buildWhatIsSequencing();
      case 1:
        return _buildMakingSandwich();
      case 2:
        return _buildPlantingSeed();
      case 3:
        return _buildStorySequence();
      case 4:
        return _buildDailyRoutines();
      case 5:
        return _buildSequenceWords();
      case 6:
        return _buildPracticeTime();
      default:
        return const SizedBox();
    }
  }

  // ── Section 0: What is Sequencing? ────────────────────────────────────────

  Widget _buildWhatIsSequencing() {
    final concepts = [
      {
        'text': 'Sequencing means putting things in the right order',
        'icon': Icons.format_list_numbered,
      },
      {
        'text': 'First, Then, Next, Last - that\'s a sequence!',
        'icon': Icons.swap_vert,
      },
      {'text': 'It helps us do tasks step by step', 'icon': Icons.checklist},
      {'text': 'Everything has a sequence - even stories!', 'icon': Icons.star},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'What is Sequencing?',
          'Learn about the order of things!',
          Icons.format_list_numbered,
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

  // ── Section 1: Making a Sandwich ──────────────────────────────────────────

  Widget _buildMakingSandwich() {
    final steps = [
      {
        'order': 'First',
        'action': 'Get bread, butter, and filling',
        'icon': Icons.shopping_basket,
      },
      {
        'order': 'Then',
        'action': 'Put two slices of bread on plate',
        'icon': Icons.dinner_dining,
      },
      {
        'order': 'Next',
        'action': 'Spread butter on bread',
        'icon': Icons.palette_outlined,
      },
      {
        'order': 'After that',
        'action': 'Add the filling you like',
        'icon': Icons.add_circle_outline,
      },
      {
        'order': 'Finally',
        'action': 'Put the other bread on top',
        'icon': Icons.lunch_dining,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Making a Sandwich',
          'Follow the steps to make a yummy sandwich!',
          Icons.lunch_dining,
          1,
        ),
        SizedBox(height: 16.h),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          final isLast = i == steps.length - 1;
          return Column(
            children: [
              buildFloatingItem(
                index: i % 8,
                child: Container(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          s['order'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        s['icon'] as IconData,
                        color: Colors.white,
                        size: 28.r,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          s['action'] as String,
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
              ),
              if (!isLast)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.white54,
                    size: 22.r,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  // ── Section 2: Planting a Seed ────────────────────────────────────────────

  Widget _buildPlantingSeed() {
    final steps = [
      {'order': 'First', 'action': 'Get a pot and soil', 'icon': Icons.yard},
      {
        'order': 'Then',
        'action': 'Fill the pot with soil',
        'icon': Icons.landscape,
      },
      {
        'order': 'Next',
        'action': 'Make a small hole',
        'icon': Icons.circle_outlined,
      },
      {
        'order': 'After that',
        'action': 'Put the seed in the hole',
        'icon': Icons.grain,
      },
      {'order': 'Then', 'action': 'Cover with soil', 'icon': Icons.layers},
      {
        'order': 'Finally',
        'action': 'Water the plant',
        'icon': Icons.water_drop,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Planting a Seed',
          'Grow a plant step by step!',
          Icons.eco,
          2,
        ),
        SizedBox(height: 16.h),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          final isLast = i == steps.length - 1;
          return Column(
            children: [
              buildFloatingItem(
                index: i % 8,
                child: Container(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          s['order'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        s['icon'] as IconData,
                        color: Colors.white,
                        size: 28.r,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          s['action'] as String,
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
              ),
              if (!isLast)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.white54,
                    size: 22.r,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  // ── Section 3: Story Sequence ─────────────────────────────────────────────

  Widget _buildStorySequence() {
    final parts = [
      {
        'part': 'Beginning',
        'what': 'Who? Where? When?',
        'example': 'Once upon a time, a little girl lived in a village...',
        'icon': Icons.wb_sunny,
      },
      {
        'part': 'Middle',
        'what': 'What happened?',
        'example': 'One day, she found a magic lamp...',
        'icon': Icons.auto_awesome,
      },
      {
        'part': 'Problem',
        'what': 'What went wrong?',
        'example': 'But a giant came and took it away...',
        'icon': Icons.warning_amber,
      },
      {
        'part': 'Solution',
        'what': 'How was it fixed?',
        'example': 'She was brave and tricked the giant...',
        'icon': Icons.lightbulb,
      },
      {
        'part': 'End',
        'what': 'How did it finish?',
        'example': 'And she lived happily ever after!',
        'icon': Icons.celebration,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Story Sequence',
          'Every story has a beginning, middle & end!',
          Icons.auto_stories,
          3,
        ),
        SizedBox(height: 16.h),
        ...parts.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        p['icon'] as IconData,
                        color: Colors.white,
                        size: 28.r,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        p['part'] as String,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    p['what'] as String,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      p['example'] as String,
                      style: GoogleFonts.nunito(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontSize: 13,
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

  // ── Section 4: Daily Routines ─────────────────────────────────────────────

  Widget _buildDailyRoutines() {
    final routines = [
      {
        'name': 'Getting Ready for Bed',
        'icon': Icons.bedtime,
        'steps': [
          'Finish dinner',
          'Brush teeth',
          'Put on pajamas',
          'Read a story',
          'Say goodnight',
          'Sleep',
        ],
      },
      {
        'name': 'Going to School',
        'icon': Icons.school,
        'steps': [
          'Wake up',
          'Get ready',
          'Eat breakfast',
          'Take bag',
          'Leave home',
          'Reach school',
        ],
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Daily Routines',
          'Order your daily tasks!',
          Icons.schedule,
          4,
        ),
        SizedBox(height: 16.h),
        ...routines.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(20.r),
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
                        r['icon'] as IconData,
                        color: Colors.white,
                        size: 28.r,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          r['name'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.r,
                    runSpacing: 8.r,
                    children: (r['steps'] as List).asMap().entries.map<Widget>((
                      stepEntry,
                    ) {
                      final idx = stepEntry.key;
                      final step = stepEntry.value;
                      final isLastStep = idx == (r['steps'] as List).length - 1;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${idx + 1}. $step',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          if (!isLastStep)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 16.r,
                                color: Colors.white54,
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 5: Sequence Words ─────────────────────────────────────────────

  Widget _buildSequenceWords() {
    final words = [
      {
        'word': 'First',
        'meaning': 'The very beginning',
        'icon': Icons.looks_one,
      },
      {'word': 'Then', 'meaning': 'After that', 'icon': Icons.looks_two},
      {'word': 'Next', 'meaning': 'What comes after', 'icon': Icons.looks_3},
      {
        'word': 'After that',
        'meaning': 'Following the last step',
        'icon': Icons.looks_4,
      },
      {
        'word': 'Finally',
        'meaning': 'The very last thing',
        'icon': Icons.looks_5,
      },
      {'word': 'Last', 'meaning': 'At the end', 'icon': Icons.last_page},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Sequence Words',
          'Words that show the order of things!',
          Icons.abc,
          5,
        ),
        SizedBox(height: 16.h),
        ...words.asMap().entries.map((entry) {
          final i = entry.key;
          final w = entry.value;
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
                  Icon(w['icon'] as IconData, color: Colors.white, size: 32.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w['word'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          w['meaning'] as String,
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

  // ── Section 6: Practice Time! ─────────────────────────────────────────────

  Widget _buildPracticeTime() {
    final challenges = [
      {
        'challenge': 'Put these in order: eat → cook → buy groceries',
        'icon': Icons.shopping_cart,
      },
      {
        'challenge': 'What comes first: dress → shower → dry?',
        'icon': Icons.shower,
      },
      {
        'challenge': 'Order the day: lunch → breakfast → dinner',
        'icon': Icons.restaurant,
      },
      {
        'challenge': 'Arrange: teenager → baby → adult → child',
        'icon': Icons.people,
      },
      {
        'challenge': 'Sequence: caterpillar → egg → butterfly → cocoon',
        'icon': Icons.flutter_dash,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Practice Time!',
          'Test your sequencing skills!',
          Icons.quiz,
          6,
        ),
        SizedBox(height: 16.h),
        ...challenges.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
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
                  Icon(c['icon'] as IconData, color: Colors.white, size: 30.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      c['challenge'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white54,
                    size: 22.r,
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
              colors: [const Color(0xFF7E57C2), const Color(0xFF5C6BC0)],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7E57C2).withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.tips_and_updates, color: Colors.white, size: 40.r),
              SizedBox(height: 10.h),
              Text(
                'Great Job!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Sequencing helps you organize tasks and tell better stories!',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
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
}
