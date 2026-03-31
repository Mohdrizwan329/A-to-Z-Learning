import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class SimpleExperimentsPage extends StatefulWidget {
  const SimpleExperimentsPage({super.key});

  @override
  State<SimpleExperimentsPage> createState() => _SimpleExperimentsPageState();
}

class _SimpleExperimentsPageState extends State<SimpleExperimentsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  int selectedExperiment = -1;

  final List<Map<String, dynamic>> experiments = [
    {
      'name': 'Volcano Eruption',
      'emoji': '🌋',
      'difficulty': 'Easy',
      'time': '10 min',
      'materials': [
        'Baking soda',
        'Vinegar',
        'Dish soap',
        'Food coloring',
        'Bottle'
      ],
      'steps': [
        'Put the bottle in a tray',
        'Add 2 spoons of baking soda',
        'Add a few drops of food coloring',
        'Add a drop of dish soap',
        'Slowly pour vinegar and watch!',
      ],
      'science':
          'Vinegar (acid) reacts with baking soda (base) to make carbon dioxide gas!',
    },
    {
      'name': 'Rainbow Milk',
      'emoji': '🌈',
      'difficulty': 'Easy',
      'time': '5 min',
      'materials': [
        'Milk',
        'Food coloring',
        'Dish soap',
        'Plate',
        'Cotton swab'
      ],
      'steps': [
        'Pour milk into the plate',
        'Add drops of different colors',
        'Dip cotton swab in dish soap',
        'Touch the milk with the swab',
        'Watch colors dance and swirl!',
      ],
      'science':
          'Soap breaks the surface tension of milk, making colors move!',
    },
    {
      'name': 'Floating Egg',
      'emoji': '🥚',
      'difficulty': 'Easy',
      'time': '5 min',
      'materials': ['2 glasses', 'Water', 'Salt', '2 eggs'],
      'steps': [
        'Fill both glasses with water',
        'Add lots of salt to one glass and stir',
        'Put an egg in plain water - it sinks!',
        'Put an egg in salty water - it floats!',
      ],
      'science':
          'Salt water is denser than plain water, so objects float more easily!',
    },
    {
      'name': 'Walking Water',
      'emoji': '💧',
      'difficulty': 'Medium',
      'time': '1 hour',
      'materials': [
        '3 glasses',
        'Paper towels',
        'Food coloring',
        'Water'
      ],
      'steps': [
        'Place 3 glasses in a row',
        'Fill glass 1 with red water, glass 3 with blue',
        'Leave glass 2 empty',
        'Fold paper towels and connect glasses',
        'Wait and watch water walk!',
      ],
      'science':
          'Water travels up the paper towel through capillary action!',
    },
    {
      'name': 'Dancing Raisins',
      'emoji': '🍇',
      'difficulty': 'Easy',
      'time': '5 min',
      'materials': ['Clear soda', 'Glass', 'Raisins'],
      'steps': [
        'Pour soda into a tall glass',
        'Drop in a few raisins',
        'Watch them sink... then rise!',
        'They dance up and down!',
      ],
      'science':
          'Gas bubbles stick to raisins and lift them up. At the top, bubbles pop and raisins sink again!',
    },
    {
      'name': 'Invisible Ink',
      'emoji': '📝',
      'difficulty': 'Medium',
      'time': '15 min',
      'materials': [
        'Lemon juice',
        'White paper',
        'Cotton swab',
        'Lamp or iron'
      ],
      'steps': [
        'Dip cotton swab in lemon juice',
        'Write a secret message',
        'Let it dry completely',
        'Hold paper near a warm lamp',
        'Watch your message appear!',
      ],
      'science':
          'Heat oxidizes the lemon juice, turning it brown and revealing the message!',
    },
    {
      'name': 'Balloon Rocket',
      'emoji': '🎈',
      'difficulty': 'Easy',
      'time': '10 min',
      'materials': ['Balloon', 'String', 'Straw', 'Tape'],
      'steps': [
        'Thread string through straw',
        'Tie string across the room',
        'Blow up balloon (don\'t tie it)',
        'Tape balloon to straw',
        'Let go and watch it zoom!',
      ],
      'science':
          'Air rushing out pushes the balloon forward - this is Newton\'s Third Law!',
    },
    {
      'name': 'Crystal Garden',
      'emoji': '💎',
      'difficulty': 'Hard',
      'time': '1-3 days',
      'materials': [
        'Salt',
        'Hot water',
        'String',
        'Pencil',
        'Glass jar'
      ],
      'steps': [
        'Dissolve lots of salt in hot water',
        'Tie string to pencil',
        'Hang string in the jar',
        'Wait 1-3 days',
        'Watch crystals grow on the string!',
      ],
      'science':
          'As water evaporates, salt molecules arrange into beautiful crystal shapes!',
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedExperiment == -1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          setState(() => selectedExperiment = -1);
        }
      },
      child: GradientScaffold(
      title: selectedExperiment == -1
          ? 'Science Experiments'
          : experiments[selectedExperiment]['name'],
      onBackPressed: () {
        if (selectedExperiment != -1) {
          setState(() => selectedExperiment = -1);
        } else {
          Get.back();
        }
      },
      actions: selectedExperiment == -1
          ? [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.refresh, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  ProgressService.to
                      .resetProgress(ProgressService.kScienceExperiments);
                  setState(() {});
                },
              ),
            ]
          : null,
      body: Column(
        children: [
          // Progress bar - only on grid screen
          if (selectedExperiment == -1)
            Obx(() {
              final progress =
                  ProgressService.to.getProgressPercentage(
                        ProgressService.kScienceExperiments,
                      ) /
                      100;
              final progressString = ProgressService.to.getProgressString(
                ProgressService.kScienceExperiments,
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
          Expanded(
            child: selectedExperiment == -1
                ? _buildExperimentGrid()
                : _buildExperimentDetail(experiments[selectedExperiment]),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildExperimentGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: experiments.length,
      itemBuilder: (context, index) {
        final exp = experiments[index];
        final gradient = AppColors.getGradientForIndex(index);

        return Obx(() {
          final isSelected = selectedExperiment == index;
          final isCompleted = ProgressService.to.isItemCompleted(
            ProgressService.kScienceExperiments,
            index,
          );

          return buildAnimatedGridItem(
            index: index,
            isSelected: isSelected,
            child: GradientCard(
              gradient: gradient,
              isSelected: isSelected,
              showDecorations: true,
              onTap: () {
                TtsService.to.speak(exp['name']);
                setState(() => selectedExperiment = index);
                ProgressService.to.markItemCompleted(
                  ProgressService.kScienceExperiments,
                  index,
                );
              },
              pulseAnimation: pulseAnimation,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          exp['emoji'],
                          style: const TextStyle(fontSize: 36),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exp['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTag(exp['difficulty']),
                            const SizedBox(width: 6),
                            _buildTag(exp['time']),
                          ],
                        ),
                      ],
                    ),
                  ),
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
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGradientItem({required int index, required Widget child}) {
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildExperimentDetail(Map<String, dynamic> exp) {
    final materials = exp['materials'] as List? ?? [];
    final steps = exp['steps'] as List? ?? [];
    int itemIndex = 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header emoji + tags
          Text(exp['emoji'], style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exp['difficulty'],
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⏱️ ${exp['time']}',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Materials card
          _buildGradientItem(
            index: itemIndex++,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🧪', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Materials You Need',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: materials.map<Widget>((m) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        m,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Steps - each as a gradient card
          ...List.generate(steps.length, (index) {
            return _buildGradientItem(
              index: itemIndex++,
              child: Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Science card
          _buildGradientItem(
            index: itemIndex,
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🧠', style: TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Science',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        exp['science'],
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
