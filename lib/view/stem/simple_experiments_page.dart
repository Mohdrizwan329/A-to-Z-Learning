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
        'Bottle',
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
        'Cotton swab',
      ],
      'steps': [
        'Pour milk into the plate',
        'Add drops of different colors',
        'Dip cotton swab in dish soap',
        'Touch the milk with the swab',
        'Watch colors dance and swirl!',
      ],
      'science': 'Soap breaks the surface tension of milk, making colors move!',
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
      'materials': ['3 glasses', 'Paper towels', 'Food coloring', 'Water'],
      'steps': [
        'Place 3 glasses in a row',
        'Fill glass 1 with red water, glass 3 with blue',
        'Leave glass 2 empty',
        'Fold paper towels and connect glasses',
        'Wait and watch water walk!',
      ],
      'science': 'Water travels up the paper towel through capillary action!',
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
        'Lamp or iron',
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
      'materials': ['Salt', 'Hot water', 'String', 'Pencil', 'Glass jar'],
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
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.refresh, color: Colors.white, size: 20.r),
                  ),
                  onPressed: () {
                    ProgressService.to.resetProgress(
                      ProgressService.kScienceExperiments,
                    );
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
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.r,
        crossAxisSpacing: 12.r,
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
                        SizedBox(height: 8.h),
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
                        SizedBox(height: 4.h),
                        // Two tags side by side are wider than the tile on a
                        // small phone, so each is allowed to shrink.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(child: _buildTag(exp['difficulty'])),
                            SizedBox(width: 6.w),
                            Flexible(child: _buildTag(exp['time'])),
                          ],
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
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildGradientItem({required int index, required Widget child}) {
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
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10.h,
              right: -10.w,
              child: Container(
                width: 40.w,
                height: 40.h,
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
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          // Header emoji + tags
          Text(exp['emoji'], style: const TextStyle(fontSize: 80)),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
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
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
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
          SizedBox(height: 20.h),

          // Materials card
          _buildGradientItem(
            index: itemIndex++,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🧪', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    SizedBox(width: 12.w),
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
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.r,
                  runSpacing: 8.r,
                  children: materials.map<Widget>((m) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20.r),
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
                    width: 35.w,
                    height: 35.h,
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
                  SizedBox(width: 12.w),
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
                  width: 55.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🧠', style: TextStyle(fontSize: 28)),
                  ),
                ),
                SizedBox(width: 16.w),
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
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
