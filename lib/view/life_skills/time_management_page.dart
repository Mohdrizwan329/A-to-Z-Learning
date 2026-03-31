import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class TimeManagementPage extends StatefulWidget {
  const TimeManagementPage({super.key});

  @override
  State<TimeManagementPage> createState() => _TimeManagementPageState();
}

class _TimeManagementPageState extends State<TimeManagementPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final ProgressService _progress = ProgressService.to;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Time?',
      'icon': Icons.access_time_filled,
      'desc': 'Understand seconds, minutes & hours',
    },
    {
      'title': 'Reading a Clock',
      'icon': Icons.watch_later,
      'desc': 'Learn to tell time like a pro',
    },
    {
      'title': 'Daily Routine',
      'icon': Icons.calendar_today,
      'desc': 'Morning & evening routines',
    },
    {
      'title': 'Planning Ahead',
      'icon': Icons.event_note,
      'desc': 'Tools & steps for planning',
    },
    {
      'title': 'Being On Time',
      'icon': Icons.timer,
      'desc': 'Why punctuality matters',
    },
    {
      'title': 'Avoiding Procrastination',
      'icon': Icons.rocket_launch,
      'desc': 'Beat delays & get things done',
    },
    {
      'title': 'Making Time for Fun',
      'icon': Icons.celebration,
      'desc': 'Balance work & play',
    },
    {
      'title': 'Weekly Planner',
      'icon': Icons.date_range,
      'desc': 'Plan your week for success',
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
      title: 'Time Management',
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
          onPressed: () {
            _progress.resetProgress(ProgressService.kTimeManagement);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          // Floating bubbles background
          ...List.generate(8, (i) {
            final top = (i * 67.0) % MediaQuery.of(context).size.height;
            final left = (i * 83.0) % MediaQuery.of(context).size.width;
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                final value = _bubbleController.value;
                final offset = 20.0 *
                    ((value * 2 * 3.14159).clamp(0, 6.28) != 0
                        ? (value * 2 * 3.14159).abs() % 1
                        : 0);
                return Positioned(
                  top: top + offset,
                  left: left,
                  child: Container(
                    width: 20 + (i % 3) * 15.0,
                    height: 20 + (i % 3) * 15.0,
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
                    _progress.getProgressPercentage(ProgressService.kTimeManagement) / 100;
                final progressString =
                    _progress.getProgressString(ProgressService.kTimeManagement);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$progressString completed',
                            style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final gradientColors =
                        AppColors.getGradientForIndex(index);
                    return buildFloatingItem(
                      index: index,
                      child: Obx(() {
                        final isCompleted = _progress.isItemCompleted(
                            ProgressService.kTimeManagement, index);
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(() => _TimeManagementDetailPage(
                                  sectionIndex: index,
                                  title: section['title'],
                                ));
                            if (!_progress.isItemCompleted(
                                ProgressService.kTimeManagement, index)) {
                              await _progress.markItemCompleted(
                                  ProgressService.kTimeManagement, index);
                            }
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              if (isCompleted)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(section['icon'],
                                        size: 48, color: Colors.white),
                                    const SizedBox(height: 10),
                                    Text(
                                      section['title'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        section['desc'],
                                        style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
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
      bottomNavigationBar: const AdsScreen(),
    );
  }
}

// ─── Detail Page ───────────────────────────────────────────────────────────────

class _TimeManagementDetailPage extends StatefulWidget {
  final int sectionIndex;
  final String title;

  const _TimeManagementDetailPage({
    required this.sectionIndex,
    required this.title,
  });

  @override
  State<_TimeManagementDetailPage> createState() =>
      _TimeManagementDetailPageState();
}

class _TimeManagementDetailPageState extends State<_TimeManagementDetailPage>
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
          // Floating bubbles
          ...List.generate(8, (i) {
            final top = (i * 67.0) % MediaQuery.of(context).size.height;
            final left = (i * 83.0) % MediaQuery.of(context).size.width;
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                final value = _bubbleController.value;
                final offset = 20.0 *
                    ((value * 2 * 3.14159).clamp(0, 6.28) != 0
                        ? (value * 2 * 3.14159).abs() % 1
                        : 0);
                return Positioned(
                  top: top + offset,
                  left: left,
                  child: Container(
                    width: 20 + (i % 3) * 15.0,
                    height: 20 + (i % 3) * 15.0,
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
            padding: const EdgeInsets.all(16),
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildContent() {
    switch (widget.sectionIndex) {
      case 0:
        return _buildWhatIsTime();
      case 1:
        return _buildReadingClock();
      case 2:
        return _buildDailyRoutine();
      case 3:
        return _buildPlanning();
      case 4:
        return _buildPunctuality();
      case 5:
        return _buildProcrastination();
      case 6:
        return _buildFunTime();
      case 7:
        return _buildWeeklyPlanner();
      default:
        return const SizedBox();
    }
  }

  // ── Section 0: What is Time? ──────────────────────────────────────────────

  Widget _buildWhatIsTime() {
    final concepts = [
      {'unit': 'Seconds', 'icon': Icons.flash_on, 'example': 'Count: 1, 2, 3...'},
      {'unit': 'Minutes', 'icon': Icons.timer, 'example': '60 seconds = 1 minute'},
      {'unit': 'Hours', 'icon': Icons.schedule, 'example': '60 minutes = 1 hour'},
      {'unit': 'Days', 'icon': Icons.today, 'example': '24 hours = 1 day'},
      {'unit': 'Weeks', 'icon': Icons.date_range, 'example': '7 days = 1 week'},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'What is Time?',
          'Time is something we can\'t see, but it\'s always moving forward!',
          Icons.access_time_filled,
          0,
        ),
        const SizedBox(height: 16),
        ...concepts.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(c['icon'] as IconData, color: Colors.white, size: 32),
                title: Text(
                  c['unit'] as String,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  c['example'] as String,
                  style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        _buildTipCard(
          'Fun Fact',
          'Time is the only thing we can\'t get back once it\'s gone!',
          Icons.lightbulb,
          Colors.amber,
        ),
      ],
    );
  }

  // ── Section 1: Reading a Clock ────────────────────────────────────────────

  Widget _buildReadingClock() {
    final parts = [
      {'part': 'Hour Hand', 'icon': Icons.looks_one, 'desc': 'Short hand - shows the hour'},
      {'part': 'Minute Hand', 'icon': Icons.looks_two, 'desc': 'Long hand - shows the minutes'},
      {'part': 'Second Hand', 'icon': Icons.looks_3, 'desc': 'Thin hand - counts seconds'},
    ];

    final practice = [
      {'time': '3:00', 'read': 'Three o\'clock'},
      {'time': '6:30', 'read': 'Half past six'},
      {'time': '9:15', 'read': 'Quarter past nine'},
      {'time': '12:45', 'read': 'Quarter to one'},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Reading a Clock',
          'Learn to tell time like a pro!',
          Icons.watch_later,
          1,
        ),
        const SizedBox(height: 16),
        ...parts.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(p['icon'] as IconData, color: Colors.white, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['part'] as String,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(p['desc'] as String,
                            style: GoogleFonts.nunito(
                                color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        _buildSectionLabel('Practice Reading'),
        const SizedBox(height: 10),
        ...practice.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          final colors = AppColors.getGradientForIndex(i + 3);
          return buildFloatingItem(
            index: i + 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(p['time']!,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                  const Icon(Icons.arrow_forward, color: Colors.white70),
                  Text(p['read']!,
                      style: GoogleFonts.nunito(color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        _buildTipCard(
          'Tip',
          'Practice reading clocks every day!',
          Icons.tips_and_updates,
          Colors.green,
        ),
      ],
    );
  }

  // ── Section 2: Daily Routine ──────────────────────────────────────────────

  Widget _buildDailyRoutine() {
    final morningRoutine = [
      {'time': '7:00 AM', 'task': 'Wake up', 'icon': Icons.wb_sunny},
      {'time': '7:15 AM', 'task': 'Brush teeth & wash face', 'icon': Icons.clean_hands},
      {'time': '7:30 AM', 'task': 'Get dressed', 'icon': Icons.checkroom},
      {'time': '7:45 AM', 'task': 'Eat breakfast', 'icon': Icons.restaurant},
      {'time': '8:00 AM', 'task': 'Leave for school', 'icon': Icons.school},
    ];

    final eveningRoutine = [
      {'time': '4:00 PM', 'task': 'Snack time', 'icon': Icons.apple},
      {'time': '4:30 PM', 'task': 'Homework', 'icon': Icons.menu_book},
      {'time': '5:30 PM', 'task': 'Free play', 'icon': Icons.sports_esports},
      {'time': '7:00 PM', 'task': 'Dinner', 'icon': Icons.dinner_dining},
      {'time': '8:00 PM', 'task': 'Bath & bedtime routine', 'icon': Icons.bathtub},
      {'time': '8:30 PM', 'task': 'Sleep', 'icon': Icons.bedtime},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Daily Routine',
          'A routine helps you know what to do and when!',
          Icons.calendar_today,
          2,
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Morning Routine'),
        const SizedBox(height: 10),
        ...morningRoutine.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(item['time'] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Icon(item['icon'] as IconData, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item['task'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        _buildSectionLabel('Evening Routine'),
        const SizedBox(height: 10),
        ...eveningRoutine.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final colors = AppColors.getGradientForIndex(i + 5);
          return buildFloatingItem(
            index: (i + 5) % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(item['time'] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Icon(item['icon'] as IconData, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item['task'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 3: Planning Ahead ─────────────────────────────────────────────

  Widget _buildPlanning() {
    final tools = [
      {'tool': 'Calendar', 'icon': Icons.calendar_month, 'use': 'Mark important dates'},
      {'tool': 'To-Do List', 'icon': Icons.checklist, 'use': 'Write tasks to complete'},
      {'tool': 'Timer', 'icon': Icons.timer, 'use': 'Track time for tasks'},
      {'tool': 'Reminder', 'icon': Icons.notifications_active, 'use': 'Alert for important things'},
    ];

    final steps = [
      {'step': 'Write down what you need to do', 'icon': Icons.edit},
      {'step': 'Decide when to do each task', 'icon': Icons.access_time},
      {'step': 'Do the most important things first', 'icon': Icons.star},
      {'step': 'Check off completed tasks', 'icon': Icons.check_circle},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Planning Ahead',
          'Planning helps you get things done on time!',
          Icons.event_note,
          3,
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Planning Tools'),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: tools.length,
          itemBuilder: (context, i) {
            final t = tools[i];
            final colors = AppColors.getGradientForIndex(i);
            return buildFloatingItem(
              index: i,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colors[0], colors[1]]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors[0].withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(t['icon'] as IconData, color: Colors.white, size: 36),
                    const SizedBox(height: 8),
                    Text(t['tool'] as String,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                    Text(t['use'] as String,
                        style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildSectionLabel('Planning Steps'),
        const SizedBox(height: 10),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(s['icon'] as IconData, color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(s['step'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 4: Being On Time ──────────────────────────────────────────────

  Widget _buildPunctuality() {
    final reasons = [
      {'reason': 'Shows you care about others', 'icon': Icons.favorite},
      {'reason': 'People can trust you', 'icon': Icons.handshake},
      {'reason': 'Less stress and rushing', 'icon': Icons.spa},
      {'reason': 'You don\'t miss important things', 'icon': Icons.flag},
    ];

    final tips = [
      {'tip': 'Get ready the night before', 'icon': Icons.nightlight},
      {'tip': 'Set an alarm', 'icon': Icons.alarm},
      {'tip': 'Leave extra time', 'icon': Icons.directions_walk},
      {'tip': 'Know how long things take', 'icon': Icons.hourglass_bottom},
      {'tip': 'Don\'t start new tasks before leaving', 'icon': Icons.block},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Being On Time',
          'Being punctual shows respect for others!',
          Icons.timer,
          4,
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Why Be On Time?'),
        const SizedBox(height: 10),
        ...reasons.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(r['icon'] as IconData, color: Colors.white, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(r['reason'] as String,
                        style: GoogleFonts.nunito(
                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        _buildSectionLabel('Tips to Be On Time'),
        const SizedBox(height: 10),
        ...tips.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(t['icon'] as IconData, color: Colors.white, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(t['tip'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 5: Avoiding Procrastination ───────────────────────────────────

  Widget _buildProcrastination() {
    final delays = [
      {'reason': 'Task seems too big', 'icon': Icons.expand},
      {'reason': 'Don\'t know how to start', 'icon': Icons.help_outline},
      {'reason': 'Something else is more fun', 'icon': Icons.sports_esports},
      {'reason': 'Scared of failing', 'icon': Icons.sentiment_dissatisfied},
    ];

    final solutions = [
      {'problem': 'Task too big', 'solution': 'Break it into small steps', 'icon': Icons.build},
      {'problem': 'Don\'t know how', 'solution': 'Ask for help', 'icon': Icons.people},
      {'problem': 'Distracted', 'solution': 'Remove distractions first', 'icon': Icons.phone_disabled},
      {'problem': 'No motivation', 'solution': 'Reward yourself after', 'icon': Icons.card_giftcard},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Avoiding Procrastination',
          'Procrastination means putting things off. Let\'s beat it!',
          Icons.rocket_launch,
          5,
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Why We Delay'),
        const SizedBox(height: 10),
        ...delays.asMap().entries.map((entry) {
          final i = entry.key;
          final d = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(d['icon'] as IconData, color: Colors.white, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(d['reason'] as String,
                        style: GoogleFonts.nunito(
                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        _buildSectionLabel('Solutions'),
        const SizedBox(height: 10),
        ...solutions.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(s['icon'] as IconData, color: Colors.white, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['problem'] as String,
                            style: GoogleFonts.nunito(
                                color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                        Text(s['solution'] as String,
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        _buildTipCard(
          'Golden Rule',
          'If it takes 2 minutes, do it now!',
          Icons.flash_on,
          Colors.orange,
        ),
      ],
    );
  }

  // ── Section 6: Making Time for Fun ────────────────────────────────────────

  Widget _buildFunTime() {
    final activities = [
      {'activity': 'Play outside', 'icon': Icons.sports_soccer, 'benefit': 'Exercise & fresh air'},
      {'activity': 'Read for fun', 'icon': Icons.auto_stories, 'benefit': 'Imagination & learning'},
      {'activity': 'Art & crafts', 'icon': Icons.palette, 'benefit': 'Creativity'},
      {'activity': 'Play with friends', 'icon': Icons.group, 'benefit': 'Social skills'},
      {'activity': 'Family time', 'icon': Icons.family_restroom, 'benefit': 'Bonding'},
      {'activity': 'Rest & relax', 'icon': Icons.self_improvement, 'benefit': 'Recharge energy'},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Making Time for Fun',
          'Balance is key! Work hard, play hard!',
          Icons.celebration,
          6,
        ),
        const SizedBox(height: 16),
        ...activities.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(a['icon'] as IconData, color: Colors.white, size: 34),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['activity'] as String,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                        Text(a['benefit'] as String,
                            style: GoogleFonts.nunito(
                                color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        _buildTipCard(
          'Balance',
          'Finish your responsibilities first, then enjoy your free time guilt-free!',
          Icons.balance,
          Colors.green,
        ),
      ],
    );
  }

  // ── Section 7: Weekly Planner ─────────────────────────────────────────────

  Widget _buildWeeklyPlanner() {
    final days = [
      {'day': 'Monday', 'icon': Icons.circle, 'color': Colors.blue, 'focus': 'Start strong'},
      {'day': 'Tuesday', 'icon': Icons.circle, 'color': Colors.green, 'focus': 'Keep going'},
      {'day': 'Wednesday', 'icon': Icons.circle, 'color': Colors.amber, 'focus': 'Halfway there!'},
      {'day': 'Thursday', 'icon': Icons.circle, 'color': Colors.orange, 'focus': 'Almost weekend'},
      {'day': 'Friday', 'icon': Icons.circle, 'color': Colors.red, 'focus': 'Finish tasks'},
      {'day': 'Saturday', 'icon': Icons.circle, 'color': Colors.purple, 'focus': 'Fun & hobbies'},
      {'day': 'Sunday', 'icon': Icons.circle, 'color': Colors.grey, 'focus': 'Rest & prepare'},
    ];

    final weeklyTips = [
      'Review last week\'s goals',
      'Set 3 main goals for the week',
      'Plan special activities',
      'Leave time for unexpected things',
      'End the week with reflection',
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Weekly Planner',
          'Plan your week for success!',
          Icons.date_range,
          7,
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Days of the Week'),
        const SizedBox(height: 10),
        ...days.asMap().entries.map((entry) {
          final i = entry.key;
          final d = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, color: d['color'] as Color, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(d['day'] as String,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                  ),
                  Text(d['focus'] as String,
                      style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        _buildSectionLabel('Weekly Planning Tips'),
        const SizedBox(height: 10),
        ...weeklyTips.asMap().entries.map((entry) {
          final i = entry.key;
          final tip = entry.value;
          final colors = AppColors.getGradientForIndex(i + 3);
          return buildFloatingItem(
            index: (i + 3) % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(tip,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 14)),
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
      String title, String subtitle, IconData icon, int colorIndex) {
    final colors = AppColors.getGradientForIndex(colorIndex);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colors[0], colors[1]]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 56, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
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

  Widget _buildTipCard(
      String title, String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.8), color],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(text,
                    style: GoogleFonts.nunito(
                        color: Colors.white.withValues(alpha: 0.95), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
