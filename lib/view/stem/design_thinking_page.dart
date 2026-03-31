import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class DesignThinkingPage extends StatefulWidget {
  const DesignThinkingPage({super.key});

  @override
  State<DesignThinkingPage> createState() => _DesignThinkingPageState();
}

class _DesignThinkingPageState extends State<DesignThinkingPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int selectedIndex = -1;
  late AnimationController _bubbleController;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Design Thinking?',
      'emoji': '💡',
      'subtitle': 'Introduction',
      'color': Color(0xFF9C27B0),
      'description':
          'Design Thinking is a special way to solve problems by thinking like a designer! It helps us create amazing things that people really need and love.',
      'keyPoints': [
        {'icon': '🎯', 'text': 'Understand the problem first'},
        {'icon': '💭', 'text': 'Think of many ideas'},
        {'icon': '🔨', 'text': 'Build something to try'},
        {'icon': '🔄', 'text': 'Test and make it better'},
      ],
    },
    {
      'title': 'Step 1: Empathize',
      'emoji': '❤️',
      'subtitle': 'Understand Feelings',
      'color': Color(0xFFE91E63),
      'description':
          'Empathize means to understand how others feel. We ask questions and listen to learn what people need!',
      'activities': [
        {
          'title': 'Ask Questions',
          'emoji': '❓',
          'example': 'What makes you happy? What is hard for you?'
        },
        {
          'title': 'Watch Carefully',
          'emoji': '👀',
          'example': 'See how people do things'
        },
        {
          'title': 'Listen Well',
          'emoji': '👂',
          'example': 'Hear what people say they need'
        },
        {
          'title': 'Feel Their Feelings',
          'emoji': '🤗',
          'example': 'Imagine being in their shoes'
        },
      ],
      'challenge':
          'Interview a family member about something that is hard for them to do!',
    },
    {
      'title': 'Step 2: Define',
      'emoji': '🎯',
      'subtitle': 'Define Problem',
      'color': Color(0xFFFF5722),
      'description':
          'Define the problem clearly! After listening, we decide exactly what problem we want to solve.',
      'problemStatements': [
        {
          'who': '👵 Grandma',
          'needs': 'needs a way to',
          'problem': 'remember to take medicine',
          'because': 'because she sometimes forgets'
        },
        {
          'who': '🐕 Dogs',
          'needs': 'need a way to',
          'problem': 'stay cool in summer',
          'because': 'because they have fur coats'
        },
        {
          'who': '📚 Students',
          'needs': 'need a way to',
          'problem': 'carry heavy books easily',
          'because': 'because backpacks hurt'
        },
      ],
      'formula': '"[Who] needs a way to [what] because [why]"',
    },
    {
      'title': 'Step 3: Ideate',
      'emoji': '💭',
      'subtitle': 'Think of Ideas',
      'color': Color(0xFF4CAF50),
      'description':
          'Ideate means to think of LOTS of ideas! No idea is too silly or too wild. The more ideas, the better!',
      'rules': [
        {'icon': '🚀', 'rule': 'Dream Big', 'tip': 'Wild ideas are welcome!'},
        {'icon': '📝', 'rule': 'Many Ideas', 'tip': 'Try for 10+ ideas'},
        {
          'icon': '🤝',
          'rule': 'Build on Others',
          'tip': 'Add to friends\' ideas'
        },
        {'icon': '⏳', 'rule': 'Go Fast', 'tip': 'Don\'t judge, just write'},
      ],
      'techniques': [
        {
          'name': 'Mind Map',
          'emoji': '🧠',
          'desc': 'Branch out ideas like a tree'
        },
        {
          'name': 'Brainstorm',
          'emoji': '🌧️',
          'desc': 'Let ideas rain down'
        },
        {
          'name': 'Sketch',
          'emoji': '✏️',
          'desc': 'Draw your ideas quickly'
        },
        {
          'name': 'What If?',
          'emoji': '❓',
          'desc': 'Ask "What if..." questions'
        },
      ],
    },
    {
      'title': 'Step 4: Prototype',
      'emoji': '🔨',
      'subtitle': 'Build & Create',
      'color': Color(0xFF2196F3),
      'description':
          'A prototype is a simple version of your idea that you can touch and try! It doesn\'t have to be perfect.',
      'materials': [
        {'item': 'Paper & Cardboard', 'emoji': '📦'},
        {'item': 'Tape & Glue', 'emoji': '📎'},
        {'item': 'Lego & Blocks', 'emoji': '🧱'},
        {'item': 'Clay & Play-Doh', 'emoji': '🎨'},
        {'item': 'Straws & Sticks', 'emoji': '🥢'},
        {'item': 'Recycled Items', 'emoji': '♻️'},
      ],
      'tips': [
        'Start small and simple',
        'Use what you have at home',
        'It\'s okay if it\'s not pretty',
        'Build fast, improve later',
      ],
    },
    {
      'title': 'Step 5: Test',
      'emoji': '🧪',
      'subtitle': 'Try & Improve',
      'color': Color(0xFF00BCD4),
      'description':
          'Testing means trying your prototype with real people! Watch what works and what doesn\'t.',
      'testingSteps': [
        {
          'step': '1',
          'title': 'Show Your Prototype',
          'desc': 'Let someone try it',
          'emoji': '🎁'
        },
        {
          'step': '2',
          'title': 'Watch Quietly',
          'desc': 'See how they use it',
          'emoji': '👀'
        },
        {
          'step': '3',
          'title': 'Ask Questions',
          'desc': 'What worked? What didn\'t?',
          'emoji': '❓'
        },
        {
          'step': '4',
          'title': 'Take Notes',
          'desc': 'Write down feedback',
          'emoji': '📝'
        },
      ],
      'remember': 'Feedback helps us improve! Even "bad" feedback is good!',
    },
    {
      'title': 'The Design Cycle',
      'emoji': '🔄',
      'subtitle': 'Repeat & Improve',
      'color': Color(0xFF673AB7),
      'description':
          'Design Thinking is a cycle! After testing, we go back and make things better. Repeat until it\'s great!',
      'cycleSteps': [
        {'step': 'Empathize', 'emoji': '❤️', 'color': Color(0xFFE91E63)},
        {'step': 'Define', 'emoji': '🎯', 'color': Color(0xFFFF5722)},
        {'step': 'Ideate', 'emoji': '💭', 'color': Color(0xFF4CAF50)},
        {'step': 'Prototype', 'emoji': '🔨', 'color': Color(0xFF2196F3)},
        {'step': 'Test', 'emoji': '🧪', 'color': Color(0xFF00BCD4)},
      ],
      'motto': '"Fail Fast, Learn Fast, Improve Fast!"',
    },
    {
      'title': 'Design Challenge!',
      'emoji': '🏆',
      'subtitle': 'Try It Out!',
      'color': Color(0xFFFF9800),
      'challenges': [
        {
          'title': 'Pet Toy Designer',
          'emoji': '🐱',
          'problem': 'Design a toy that keeps pets entertained',
          'difficulty': 'Easy'
        },
        {
          'title': 'Lunch Box Inventor',
          'emoji': '🍱',
          'problem': 'Design a lunch box that keeps food fresh and organized',
          'difficulty': 'Medium'
        },
        {
          'title': 'Playground Creator',
          'emoji': '🛝',
          'problem': 'Design a playground that kids of all abilities can enjoy',
          'difficulty': 'Hard'
        },
        {
          'title': 'Future School',
          'emoji': '🏫',
          'problem': 'Design the school of the future',
          'difficulty': 'Super Hard'
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
      title: 'Design Thinking',
      bottomNavigationBar: const AdsScreen(),
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
            ProgressService.to.resetProgress(ProgressService.kDesignThinking);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          // Animated floating bubbles background
          ..._buildFloatingBubbles(),
          // Main content
          Column(
            children: [
              // Progress bar
              Obx(() {
                final progress =
                    ProgressService.to.getProgressPercentage(
                          ProgressService.kDesignThinking,
                        ) /
                        100;
                final progressString = ProgressService.to.getProgressString(
                  ProgressService.kDesignThinking,
                );
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$progressString completed',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
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
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final gradient = AppColors.getGradientForIndex(index);

                    return Obx(() {
                      final isSelected = selectedIndex == index;
                      final isCompleted = ProgressService.to.isItemCompleted(
                        ProgressService.kDesignThinking,
                        index,
                      );

                      return buildFloatingItem(
                        index: index,
                        child: GradientCard(
                          gradient: gradient,
                          isSelected: isSelected,
                          showDecorations: true,
                          onTap: () {
                            TtsService.to.speak(sections[index]['title']);
                            setState(() {
                              selectedIndex = index;
                            });
                            // Mark as completed
                            ProgressService.to.markItemCompleted(
                              ProgressService.kDesignThinking,
                              index,
                            );
                            // Navigate to detail page
                            Get.to(() => _DesignThinkingDetailPage(
                                  section: section,
                                  sectionIndex: index,
                                ));
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          section['emoji'],
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
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
                                    const SizedBox(height: 2),
                                    Text(
                                      section['subtitle'],
                                      style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              // Checkmark if completed
                              if (isCompleted)
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
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

/// Detail page for each Design Thinking section
class _DesignThinkingDetailPage extends StatefulWidget {
  final Map<String, dynamic> section;
  final int sectionIndex;

  const _DesignThinkingDetailPage({
    required this.section,
    required this.sectionIndex,
  });

  @override
  State<_DesignThinkingDetailPage> createState() =>
      _DesignThinkingDetailPageState();
}

class _DesignThinkingDetailPageState extends State<_DesignThinkingDetailPage>
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
      bottomNavigationBar: const AdsScreen(),
      body: Stack(
        children: [
          // Animated floating bubbles background
          ..._buildFloatingBubbles(),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _buildContent(),
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

  Widget _buildContent() {
    switch (sectionIndex) {
      case 0:
        return _buildIntroSection();
      case 1:
        return _buildEmpathizeSection();
      case 2:
        return _buildDefineSection();
      case 3:
        return _buildIdeateSection();
      case 4:
        return _buildPrototypeSection();
      case 5:
        return _buildTestSection();
      case 6:
        return _buildCycleSection();
      case 7:
        return _buildChallengeSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIntroSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['keyPoints'].length, (index) {
          final point = section['keyPoints'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(point['icon'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      point['text'],
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
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

  Widget _buildEmpathizeSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['activities'].length, (index) {
          final activity = section['activities'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Text(activity['emoji'], style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          activity['example'],
                          style: GoogleFonts.nunito(
                            fontSize: 14,
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
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('🌟', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      section['challenge'],
                      style: GoogleFonts.nunito(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefineSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['formula'],
            style: GoogleFonts.sourceCodePro(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: section['color'],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Examples:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(section['problemStatements'].length, (index) {
          final statement = section['problemStatements'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(statement['who'], style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: statement['needs'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: statement['problem'],
                        style: TextStyle(
                          color: Colors.yellow[200],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: statement['because']),
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

  Widget _buildIdeateSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Rules for Ideation:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: List.generate(section['rules'].length, (index) {
            final rule = section['rules'][index];
            final gradient = AppColors.getGradientForIndex(index);
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(rule['icon'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    rule['rule'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    rule['tip'],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Text(
          'Techniques:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(section['techniques'].length, (index) {
          final technique = section['techniques'][index];
          final gradient = AppColors.getGradientForIndex(index + 4);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(technique['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          technique['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          technique['desc'],
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
      ],
    );
  }

  Widget _buildPrototypeSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Materials You Can Use:',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(section['materials'].length, (index) {
            final material = section['materials'][index];
            final gradient = AppColors.getGradientForIndex(index);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(material['emoji'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      material['item'],
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Tips for Prototyping:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(section['tips'].length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: section['color'], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          section['tips'][index],
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['testingSteps'].length, (index) {
          final step = section['testingSteps'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        step['step'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          step['desc'],
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(step['emoji'], style: const TextStyle(fontSize: 28)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['remember'],
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCycleSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['description'],
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              ...List.generate(section['cycleSteps'].length, (index) {
                final step = section['cycleSteps'][index];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: step['color'],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(step['emoji'], style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 8),
                          Text(
                            step['step'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < section['cycleSteps'].length - 1)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Icon(
                          Icons.arrow_downward,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              Icon(
                Icons.refresh,
                color: section['color'],
                size: 40,
              ),
              Text(
                'Repeat!',
                style: GoogleFonts.poppins(
                  color: section['color'],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            section['motto'],
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeSection() {
    return Column(
      children: [
        Text(section['emoji'], style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(
          'Try these design challenges!',
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(section['challenges'].length, (index) {
          final challenge = section['challenges'][index];
          final gradient = AppColors.getGradientForIndex(index);
          return buildFloatingItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(challenge['emoji'], style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challenge['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                challenge['difficulty'],
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            challenge['problem'],
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.white,
                            ),
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
}
