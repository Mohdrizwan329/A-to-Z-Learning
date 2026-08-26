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

class WorkingMemoryPage extends StatefulWidget {
  const WorkingMemoryPage({super.key});

  @override
  State<WorkingMemoryPage> createState() => _WorkingMemoryPageState();
}

class _WorkingMemoryPageState extends State<WorkingMemoryPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final ProgressService _progress = ProgressService.to;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Working Memory?',
      'icon': Icons.psychology,
      'desc': 'Your mental sticky note',
    },
    {
      'title': 'Memory Games',
      'icon': Icons.sports_esports,
      'desc': 'Fun games to train memory',
    },
    {
      'title': 'Remember These!',
      'icon': Icons.visibility,
      'desc': 'Look, remember & recall',
    },
    {
      'title': 'Memory Tricks',
      'icon': Icons.auto_fix_high,
      'desc': 'Tips to remember better',
    },
    {
      'title': 'Follow Instructions',
      'icon': Icons.checklist,
      'desc': 'Remember & do the steps',
    },
    {
      'title': 'Number Memory',
      'icon': Icons.pin,
      'desc': 'Remember number sequences',
    },
    {
      'title': 'Daily Practice',
      'icon': Icons.calendar_today,
      'desc': 'Practice every day',
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
      title: 'Working Memory',
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
            _progress.resetProgress(ProgressService.kWorkingMemory);
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
                      ProgressService.kWorkingMemory,
                    ) /
                    100;
                final progressString = _progress.getProgressString(
                  ProgressService.kWorkingMemory,
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
                          ProgressService.kWorkingMemory,
                          index,
                        );
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(
                              () => _WorkingMemoryDetailPage(
                                sectionIndex: index,
                                title: section['title'],
                              ),
                            );
                            if (!_progress.isItemCompleted(
                              ProgressService.kWorkingMemory,
                              index,
                            )) {
                              await _progress.markItemCompleted(
                                ProgressService.kWorkingMemory,
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

class _WorkingMemoryDetailPage extends StatefulWidget {
  final int sectionIndex;
  final String title;

  const _WorkingMemoryDetailPage({
    required this.sectionIndex,
    required this.title,
  });

  @override
  State<_WorkingMemoryDetailPage> createState() =>
      _WorkingMemoryDetailPageState();
}

class _WorkingMemoryDetailPageState extends State<_WorkingMemoryDetailPage>
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
        return _buildWhatIsWorkingMemory();
      case 1:
        return _buildMemoryGames();
      case 2:
        return _buildRememberThese();
      case 3:
        return _buildMemoryTricks();
      case 4:
        return _buildFollowInstructions();
      case 5:
        return _buildNumberMemory();
      case 6:
        return _buildDailyPractice();
      default:
        return const SizedBox();
    }
  }

  // ── Section 0: What is Working Memory? ────────────────────────────────────

  Widget _buildWhatIsWorkingMemory() {
    final concepts = [
      {
        'text': 'Working memory is like a mental sticky note',
        'icon': Icons.sticky_note_2,
      },
      {
        'text': 'It helps you remember things for a short time',
        'icon': Icons.timer,
      },
      {
        'text': 'Like remembering a phone number while dialing',
        'icon': Icons.phone,
      },
      {
        'text': 'It helps you follow instructions and learn',
        'icon': Icons.school,
      },
      {
        'text': 'You can train your memory to be stronger!',
        'icon': Icons.fitness_center,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'What is Working Memory?',
          'Your brain\'s mental sticky note!',
          Icons.psychology,
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

  // ── Section 1: Memory Games ────────────────────────────────────���──────────

  Widget _buildMemoryGames() {
    final games = [
      {
        'name': 'Simon Says',
        'how': 'Remember the color pattern and repeat it',
        'icon': Icons.gamepad,
      },
      {
        'name': 'Memory Cards',
        'how': 'Find matching pairs by remembering positions',
        'icon': Icons.grid_view,
      },
      {
        'name': 'Number Chain',
        'how': 'Remember and repeat growing number sequences',
        'icon': Icons.link,
      },
      {
        'name': 'Story Recall',
        'how': 'Listen to a story and answer questions',
        'icon': Icons.auto_stories,
      },
      {
        'name': 'Shopping List',
        'how': 'Remember items without writing them',
        'icon': Icons.shopping_cart,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Memory Games',
          'Fun games to train your memory!',
          Icons.sports_esports,
          1,
        ),
        SizedBox(height: 16.h),
        ...games.asMap().entries.map((entry) {
          final i = entry.key;
          final g = entry.value;
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
                  Icon(g['icon'] as IconData, color: Colors.white, size: 34.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g['name'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          g['how'] as String,
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

  // ── Section 2: Remember These! ────────────────────────────────────────────

  Widget _buildRememberThese() {
    final challenges = [
      {
        'level': 'Easy',
        'items': '🍎 🍌 🍇',
        'count': 3,
        'icon': Icons.sentiment_satisfied,
      },
      {
        'level': 'Medium',
        'items': '🐶 🐱 🐰 🐻 🦊',
        'count': 5,
        'icon': Icons.sentiment_neutral,
      },
      {
        'level': 'Hard',
        'items': '⭐ 🌙 ☀️ 🌈 ⚡ 🌺 🍀',
        'count': 7,
        'icon': Icons.local_fire_department,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Remember These!',
          'Look, remember & recall!',
          Icons.visibility,
          2,
        ),
        SizedBox(height: 16.h),
        ...challenges.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(20.r),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          c['level'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '${c['count']} items',
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    c['items'] as String,
                    style: const TextStyle(fontSize: 36, letterSpacing: 8),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 3: Memory Tricks ──────────────────────────────────────────────

  Widget _buildMemoryTricks() {
    final tricks = [
      {
        'trick': 'Chunking',
        'how': 'Break big info into small groups',
        'example': '123-456-7890 is easier than 1234567890',
        'icon': Icons.dashboard,
      },
      {
        'trick': 'Rhyming',
        'how': 'Make it into a song or rhyme',
        'example': 'In 1492, Columbus sailed the ocean blue',
        'icon': Icons.music_note,
      },
      {
        'trick': 'Pictures',
        'how': 'Create mental images',
        'example': 'Imagine an apple to remember "A"',
        'icon': Icons.image,
      },
      {
        'trick': 'Stories',
        'how': 'Link items in a story',
        'example': 'The cat ate the apple on the chair',
        'icon': Icons.auto_stories,
      },
      {
        'trick': 'Repeat',
        'how': 'Say it again and again',
        'example': 'Repeat the phone number 3 times',
        'icon': Icons.replay,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Memory Tricks',
          'Tips to remember anything better!',
          Icons.auto_fix_high,
          3,
        ),
        SizedBox(height: 16.h),
        ...tricks.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;
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
                        t['icon'] as IconData,
                        color: Colors.white,
                        size: 28.r,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        t['trick'] as String,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    t['how'] as String,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '💡 ${t['example']}',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  // ── Section 4: Follow Instructions ────────────────────────────────────────

  Widget _buildFollowInstructions() {
    final instructions = [
      {
        'steps': 2,
        'example': 'Touch your nose, then clap your hands',
        'icon': Icons.looks_two,
      },
      {
        'steps': 3,
        'example': 'Stand up, turn around, sit down',
        'icon': Icons.looks_3,
      },
      {
        'steps': 4,
        'example': 'Jump, touch toes, wave, smile',
        'icon': Icons.looks_4,
      },
      {
        'steps': 5,
        'example': 'Clap, stomp, spin, jump, bow',
        'icon': Icons.looks_5,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Follow Instructions',
          'Remember and do the steps!',
          Icons.checklist,
          4,
        ),
        SizedBox(height: 16.h),
        ...instructions.asMap().entries.map((entry) {
          final i = entry.key;
          final inst = entry.value;
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
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${inst['steps']}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${inst['steps']} Steps',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          inst['example'] as String,
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

  // ── Section 5: Number Memory ──────────────────────────────────────────────

  Widget _buildNumberMemory() {
    final numbers = [
      {'sequence': '3 - 7', 'digits': 2, 'level': 'Beginner'},
      {'sequence': '5 - 2 - 9', 'digits': 3, 'level': 'Easy'},
      {'sequence': '4 - 8 - 1 - 6', 'digits': 4, 'level': 'Medium'},
      {'sequence': '7 - 3 - 9 - 2 - 5', 'digits': 5, 'level': 'Hard'},
      {'sequence': '1 - 4 - 7 - 2 - 8 - 5', 'digits': 6, 'level': 'Expert'},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Number Memory',
          'Remember the number sequences!',
          Icons.pin,
          5,
        ),
        SizedBox(height: 16.h),
        ...numbers.asMap().entries.map((entry) {
          final i = entry.key;
          final n = entry.value;
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      n['level'] as String,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      n['sequence'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Text(
                    '${n['digits']} digits',
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
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

  // ── Section 6: Daily Memory Practice ──────────────────────────────────────

  Widget _buildDailyPractice() {
    final activities = [
      {
        'activity': 'Memorize your daily schedule',
        'icon': Icons.calendar_month,
      },
      {
        'activity': 'Remember what you had for breakfast',
        'icon': Icons.restaurant,
      },
      {
        'activity': 'Recall 5 things you saw on the way',
        'icon': Icons.visibility,
      },
      {'activity': 'Remember names of new people', 'icon': Icons.people},
      {'activity': 'Recite a poem from memory', 'icon': Icons.menu_book},
      {'activity': 'Play memory card games', 'icon': Icons.grid_view},
      {'activity': 'Draw something from memory', 'icon': Icons.palette},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Daily Memory Practice',
          'Practice every day to get stronger!',
          Icons.calendar_today,
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
                    Icons.check_circle_outline,
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
              Icon(Icons.psychology, color: Colors.white, size: 48.r),
              SizedBox(height: 10.h),
              Text(
                'Train Your Brain!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'The more you practice, the stronger your memory gets!',
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
