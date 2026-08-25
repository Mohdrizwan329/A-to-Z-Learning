import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({super.key});

  @override
  State<GoalSettingPage> createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends State<GoalSettingPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final ProgressService _progress = ProgressService.to;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is a Goal?',
      'icon': Icons.flag,
      'desc': 'Learn what goals are',
    },
    {
      'title': 'Types of Goals',
      'icon': Icons.category,
      'desc': 'Daily, weekly & big dreams',
    },
    {
      'title': 'SMART Goals',
      'icon': Icons.psychology,
      'desc': 'Make goals the smart way',
    },
    {
      'title': 'Setting Your Goals',
      'icon': Icons.edit_note,
      'desc': 'Steps to set your goals',
    },
    {
      'title': 'Goal Examples',
      'icon': Icons.auto_stories,
      'desc': 'Examples from real life',
    },
    {
      'title': 'Staying Motivated',
      'icon': Icons.local_fire_department,
      'desc': 'Tips to keep going',
    },
    {
      'title': 'Goal Tracker',
      'icon': Icons.track_changes,
      'desc': 'Track your progress',
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
      title: 'Goal Setting',
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
            _progress.resetProgress(ProgressService.kGoalSetting);
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
                    _progress.getProgressPercentage(ProgressService.kGoalSetting) / 100;
                final progressString =
                    _progress.getProgressString(ProgressService.kGoalSetting);
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
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final gradientColors = AppColors.getGradientForIndex(index);
                    return buildFloatingItem(
                      index: index,
                      child: Obx(() {
                        final isCompleted = _progress.isItemCompleted(
                            ProgressService.kGoalSetting, index);
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(() => _GoalSettingDetailPage(
                                  sectionIndex: index,
                                  title: section['title'],
                                ));
                            if (!_progress.isItemCompleted(
                                ProgressService.kGoalSetting, index)) {
                              await _progress.markItemCompleted(
                                  ProgressService.kGoalSetting, index);
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        section['desc'],
                                        style: GoogleFonts.nunito(
                                          fontSize: 11,
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

class _GoalSettingDetailPage extends StatefulWidget {
  final int sectionIndex;
  final String title;

  const _GoalSettingDetailPage({
    required this.sectionIndex,
    required this.title,
  });

  @override
  State<_GoalSettingDetailPage> createState() =>
      _GoalSettingDetailPageState();
}

class _GoalSettingDetailPageState extends State<_GoalSettingDetailPage>
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
    );
  }

  Widget _buildContent() {
    switch (widget.sectionIndex) {
      case 0:
        return _buildWhatIsGoal();
      case 1:
        return _buildTypesOfGoals();
      case 2:
        return _buildSmartGoals();
      case 3:
        return _buildSettingYourGoals();
      case 4:
        return _buildGoalExamples();
      case 5:
        return _buildStayingMotivated();
      case 6:
        return _buildGoalTracker();
      default:
        return const SizedBox();
    }
  }

  // ── Section 0: What is a Goal? ────────────────────────────────────────────

  Widget _buildWhatIsGoal() {
    final concepts = [
      {'text': 'A goal is something you want to achieve', 'icon': Icons.flag},
      {'text': 'It gives you something to work towards', 'icon': Icons.trending_up},
      {'text': 'Goals help you grow and improve', 'icon': Icons.auto_graph},
      {'text': 'Anyone can set and reach goals!', 'icon': Icons.star},
    ];

    return Column(
      children: [
        _buildHeaderCard('What is a Goal?', 'Learn what goals are and why they matter!', Icons.flag, 0),
        const SizedBox(height: 16),
        ...concepts.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(c['icon'] as IconData, color: Colors.white, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(c['text'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 1: Types of Goals ─────────────────────────────────────────────

  Widget _buildTypesOfGoals() {
    final types = [
      {'type': 'Daily Goals', 'example': 'Finish homework today', 'time': 'Today', 'icon': Icons.today},
      {'type': 'Weekly Goals', 'example': 'Read 2 books this week', 'time': '7 days', 'icon': Icons.date_range},
      {'type': 'Monthly Goals', 'example': 'Learn 10 new words', 'time': '30 days', 'icon': Icons.calendar_month},
      {'type': 'Big Dreams', 'example': 'Become a scientist', 'time': 'Future', 'icon': Icons.auto_awesome},
    ];

    return Column(
      children: [
        _buildHeaderCard('Types of Goals', 'Goals can be short or long term!', Icons.category, 1),
        const SizedBox(height: 16),
        ...types.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(t['icon'] as IconData, color: Colors.white, size: 34),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t['type'] as String,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                        Text(t['example'] as String,
                            style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      t['time'] as String,
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
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

  // ── Section 2: SMART Goals ────────────────────────────────────────────────

  Widget _buildSmartGoals() {
    final smart = [
      {'letter': 'S', 'word': 'Specific', 'meaning': 'Be clear about what you want', 'example': 'I want to read 1 book'},
      {'letter': 'M', 'word': 'Measurable', 'meaning': 'Know how to track it', 'example': 'Read 20 pages each day'},
      {'letter': 'A', 'word': 'Achievable', 'meaning': 'Make it possible', 'example': 'A book I can understand'},
      {'letter': 'R', 'word': 'Relevant', 'meaning': 'It matters to you', 'example': 'A topic I like'},
      {'letter': 'T', 'word': 'Time-bound', 'meaning': 'Set a deadline', 'example': 'Finish in 2 weeks'},
    ];

    return Column(
      children: [
        _buildHeaderCard('SMART Goals', 'Make your goals SMART!', Icons.psychology, 2),
        const SizedBox(height: 16),
        ...smart.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        s['letter'] as String,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['word'] as String,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                        Text(s['meaning'] as String,
                            style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '💡 ${s['example']}',
                            style: GoogleFonts.nunito(fontSize: 12, color: Colors.white),
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

  // ── Section 3: Setting Your Goals ─────────────────────────────────────────

  Widget _buildSettingYourGoals() {
    final steps = [
      {'step': 1, 'action': 'Dream big! What do you want?', 'icon': Icons.cloud},
      {'step': 2, 'action': 'Write your goal down', 'icon': Icons.edit},
      {'step': 3, 'action': 'Break it into small steps', 'icon': Icons.stairs},
      {'step': 4, 'action': 'Set a deadline', 'icon': Icons.alarm},
      {'step': 5, 'action': 'Start working on it!', 'icon': Icons.rocket_launch},
      {'step': 6, 'action': 'Track your progress', 'icon': Icons.bar_chart},
    ];

    return Column(
      children: [
        _buildHeaderCard('Setting Your Goals', '6 steps to set amazing goals!', Icons.edit_note, 3),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 3))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${s['step']}',
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(s['icon'] as IconData, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(s['action'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 4: Goal Examples ──────────────────────────────────────────────

  Widget _buildGoalExamples() {
    final examples = [
      {'area': 'School', 'goals': ['Get better grades', 'Finish homework on time', 'Learn a new subject'], 'icon': Icons.school},
      {'area': 'Health', 'goals': ['Eat fruits daily', 'Exercise 30 minutes', 'Sleep on time'], 'icon': Icons.favorite},
      {'area': 'Skills', 'goals': ['Learn to draw', 'Play an instrument', 'Learn to swim'], 'icon': Icons.brush},
      {'area': 'Behavior', 'goals': ['Be more patient', 'Help others more', 'Listen better'], 'icon': Icons.volunteer_activism},
    ];

    return Column(
      children: [
        _buildHeaderCard('Goal Examples', 'Ideas for goals you can set!', Icons.auto_stories, 4),
        const SizedBox(height: 16),
        ...examples.asMap().entries.map((entry) {
          final i = entry.key;
          final e = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(e['icon'] as IconData, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Text(e['area'] as String,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (e['goals'] as List).map<Widget>((goal) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🎯 $goal',
                          style: GoogleFonts.nunito(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 12),
                        ),
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

  // ── Section 5: Staying Motivated ──────────────────────────────────────────

  Widget _buildStayingMotivated() {
    final tips = [
      {'tip': 'Remember WHY you started', 'icon': Icons.lightbulb},
      {'tip': 'Celebrate small wins', 'icon': Icons.celebration},
      {'tip': 'Don\'t give up when it\'s hard', 'icon': Icons.fitness_center},
      {'tip': 'Ask for help when needed', 'icon': Icons.people},
      {'tip': 'Picture yourself achieving it', 'icon': Icons.visibility},
      {'tip': 'Reward yourself for progress', 'icon': Icons.emoji_events},
    ];

    return Column(
      children: [
        _buildHeaderCard('Staying Motivated', 'Tips to keep you going!', Icons.local_fire_department, 5),
        const SizedBox(height: 16),
        ...tips.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(t['icon'] as IconData, color: Colors.white, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(t['tip'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 6: Goal Tracker ───────────────────────────────────────────────

  Widget _buildGoalTracker() {
    final tracker = [
      {'status': 'Not Started', 'color': Colors.grey, 'icon': Icons.circle_outlined},
      {'status': 'Just Started', 'color': Colors.blue, 'icon': Icons.play_circle_outline},
      {'status': 'Working On It', 'color': Colors.amber, 'icon': Icons.pending},
      {'status': 'Almost There', 'color': Colors.orange, 'icon': Icons.timelapse},
      {'status': 'Done!', 'color': Colors.green, 'icon': Icons.check_circle},
    ];

    return Column(
      children: [
        _buildHeaderCard('Goal Tracker', 'Track your goals from start to finish!', Icons.track_changes, 6),
        const SizedBox(height: 16),
        ...tracker.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(t['icon'] as IconData, color: Colors.white, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(t['status'] as String,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16)),
                  ),
                  Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (i + 1) / tracker.length,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF66BB6A), const Color(0xFF43A047)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: const Color(0xFF66BB6A).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 48),
              const SizedBox(height: 10),
              Text('Keep Going!',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Text('Every goal you set brings you closer to your dreams!',
                  style: GoogleFonts.nunito(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared Helpers ────────────────────────────────────────────────────────

  Widget _buildHeaderCard(String title, String subtitle, IconData icon, int colorIndex) {
    final colors = AppColors.getGradientForIndex(colorIndex);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colors[0], colors[1]]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Icon(icon, size: 56, color: Colors.white),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(subtitle, style: GoogleFonts.nunito(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
