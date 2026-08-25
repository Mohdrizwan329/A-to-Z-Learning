import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
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
                    _progress.getProgressPercentage(ProgressService.kWorkingMemory) / 100;
                final progressString =
                    _progress.getProgressString(ProgressService.kWorkingMemory);
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
                            ProgressService.kWorkingMemory, index);
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(() => _WorkingMemoryDetailPage(
                                  sectionIndex: index,
                                  title: section['title'],
                                ));
                            if (!_progress.isItemCompleted(
                                ProgressService.kWorkingMemory, index)) {
                              await _progress.markItemCompleted(
                                  ProgressService.kWorkingMemory, index);
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
      {'text': 'Working memory is like a mental sticky note', 'icon': Icons.sticky_note_2},
      {'text': 'It helps you remember things for a short time', 'icon': Icons.timer},
      {'text': 'Like remembering a phone number while dialing', 'icon': Icons.phone},
      {'text': 'It helps you follow instructions and learn', 'icon': Icons.school},
      {'text': 'You can train your memory to be stronger!', 'icon': Icons.fitness_center},
    ];

    return Column(
      children: [
        _buildHeaderCard('What is Working Memory?', 'Your brain\'s mental sticky note!', Icons.psychology, 0),
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

  // ── Section 1: Memory Games ────────────────────────────────────���──────────

  Widget _buildMemoryGames() {
    final games = [
      {'name': 'Simon Says', 'how': 'Remember the color pattern and repeat it', 'icon': Icons.gamepad},
      {'name': 'Memory Cards', 'how': 'Find matching pairs by remembering positions', 'icon': Icons.grid_view},
      {'name': 'Number Chain', 'how': 'Remember and repeat growing number sequences', 'icon': Icons.link},
      {'name': 'Story Recall', 'how': 'Listen to a story and answer questions', 'icon': Icons.auto_stories},
      {'name': 'Shopping List', 'how': 'Remember items without writing them', 'icon': Icons.shopping_cart},
    ];

    return Column(
      children: [
        _buildHeaderCard('Memory Games', 'Fun games to train your memory!', Icons.sports_esports, 1),
        const SizedBox(height: 16),
        ...games.asMap().entries.map((entry) {
          final i = entry.key;
          final g = entry.value;
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
                  Icon(g['icon'] as IconData, color: Colors.white, size: 34),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g['name'] as String,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                        Text(g['how'] as String,
                            style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
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
      {'level': 'Easy', 'items': '🍎 🍌 🍇', 'count': 3, 'icon': Icons.sentiment_satisfied},
      {'level': 'Medium', 'items': '🐶 🐱 🐰 🐻 🦊', 'count': 5, 'icon': Icons.sentiment_neutral},
      {'level': 'Hard', 'items': '⭐ 🌙 ☀️ 🌈 ⚡ 🌺 🍀', 'count': 7, 'icon': Icons.local_fire_department},
    ];

    return Column(
      children: [
        _buildHeaderCard('Remember These!', 'Look, remember & recall!', Icons.visibility, 2),
        const SizedBox(height: 16),
        ...challenges.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(c['level'] as String,
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      Text('${c['count']} items',
                          style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(c['items'] as String,
                      style: const TextStyle(fontSize: 36, letterSpacing: 8)),
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
      {'trick': 'Chunking', 'how': 'Break big info into small groups', 'example': '123-456-7890 is easier than 1234567890', 'icon': Icons.dashboard},
      {'trick': 'Rhyming', 'how': 'Make it into a song or rhyme', 'example': 'In 1492, Columbus sailed the ocean blue', 'icon': Icons.music_note},
      {'trick': 'Pictures', 'how': 'Create mental images', 'example': 'Imagine an apple to remember "A"', 'icon': Icons.image},
      {'trick': 'Stories', 'how': 'Link items in a story', 'example': 'The cat ate the apple on the chair', 'icon': Icons.auto_stories},
      {'trick': 'Repeat', 'how': 'Say it again and again', 'example': 'Repeat the phone number 3 times', 'icon': Icons.replay},
    ];

    return Column(
      children: [
        _buildHeaderCard('Memory Tricks', 'Tips to remember anything better!', Icons.auto_fix_high, 3),
        const SizedBox(height: 16),
        ...tricks.asMap().entries.map((entry) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(t['icon'] as IconData, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Text(t['trick'] as String,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(t['how'] as String,
                      style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('💡 ${t['example']}',
                        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
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
      {'steps': 2, 'example': 'Touch your nose, then clap your hands', 'icon': Icons.looks_two},
      {'steps': 3, 'example': 'Stand up, turn around, sit down', 'icon': Icons.looks_3},
      {'steps': 4, 'example': 'Jump, touch toes, wave, smile', 'icon': Icons.looks_4},
      {'steps': 5, 'example': 'Clap, stomp, spin, jump, bow', 'icon': Icons.looks_5},
    ];

    return Column(
      children: [
        _buildHeaderCard('Follow Instructions', 'Remember and do the steps!', Icons.checklist, 4),
        const SizedBox(height: 16),
        ...instructions.asMap().entries.map((entry) {
          final i = entry.key;
          final inst = entry.value;
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
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${inst['steps']}',
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${inst['steps']} Steps',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                        Text(inst['example'] as String,
                            style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
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
        _buildHeaderCard('Number Memory', 'Remember the number sequences!', Icons.pin, 5),
        const SizedBox(height: 16),
        ...numbers.asMap().entries.map((entry) {
          final i = entry.key;
          final n = entry.value;
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(n['level'] as String,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(n['sequence'] as String,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20, letterSpacing: 2)),
                  ),
                  Text('${n['digits']} digits',
                      style: GoogleFonts.nunito(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
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
      {'activity': 'Memorize your daily schedule', 'icon': Icons.calendar_month},
      {'activity': 'Remember what you had for breakfast', 'icon': Icons.restaurant},
      {'activity': 'Recall 5 things you saw on the way', 'icon': Icons.visibility},
      {'activity': 'Remember names of new people', 'icon': Icons.people},
      {'activity': 'Recite a poem from memory', 'icon': Icons.menu_book},
      {'activity': 'Play memory card games', 'icon': Icons.grid_view},
      {'activity': 'Draw something from memory', 'icon': Icons.palette},
    ];

    return Column(
      children: [
        _buildHeaderCard('Daily Memory Practice', 'Practice every day to get stronger!', Icons.calendar_today, 6),
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
                boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(a['icon'] as IconData, color: Colors.white, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(a['activity'] as String,
                        style: GoogleFonts.nunito(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  const Icon(Icons.check_circle_outline, color: Colors.white54, size: 22),
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
              colors: [const Color(0xFF7E57C2), const Color(0xFF5C6BC0)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: const Color(0xFF7E57C2).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            children: [
              const Icon(Icons.psychology, color: Colors.white, size: 48),
              const SizedBox(height: 10),
              Text('Train Your Brain!',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Text('The more you practice, the stronger your memory gets!',
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
