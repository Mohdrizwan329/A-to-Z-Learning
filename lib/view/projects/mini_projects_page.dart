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

class MiniProjectsPage extends StatefulWidget {
  const MiniProjectsPage({super.key});

  @override
  State<MiniProjectsPage> createState() => _MiniProjectsPageState();
}

class _MiniProjectsPageState extends State<MiniProjectsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  String? selectedProject;
  int selectedIndex = -1;

  final List<Map<String, dynamic>> projects = [
    {
      'name': 'Rainbow in a Jar',
      'emoji': '🌈',
      'difficulty': 'Easy',
      'time': '15 mins',
      'category': 'Science',
      'description': 'Create beautiful rainbow layers using water and sugar!',
      'materials': ['Glass jar', 'Water', 'Sugar', 'Food coloring', 'Spoon'],
      'steps': [
        'Mix different amounts of sugar with water for each color',
        'Add food coloring to each mixture',
        'Carefully pour heaviest (most sugar) layer first',
        'Slowly add lighter layers on top',
        'Watch the rainbow appear!',
      ],
      'learning': 'Density - heavier liquids sink, lighter ones float!',
    },
    {
      'name': 'Paper Airplane Contest',
      'emoji': '✈️',
      'difficulty': 'Easy',
      'time': '20 mins',
      'category': 'Engineering',
      'description': 'Design and test different paper airplane designs!',
      'materials': [
        'Paper sheets',
        'Ruler',
        'Tape (optional)',
        'Measuring tape',
      ],
      'steps': [
        'Fold 3 different airplane designs',
        'Name each airplane',
        'Test each one and measure how far it flies',
        'Record your results',
        'Which design won? Why?',
      ],
      'learning': 'Aerodynamics - how shapes affect flight!',
    },
    {
      'name': 'Mini Garden',
      'emoji': '🌱',
      'difficulty': 'Medium',
      'time': '30 mins + waiting',
      'category': 'Nature',
      'description': 'Grow your own plants from seeds in small containers!',
      'materials': [
        'Small pots or cups',
        'Soil',
        'Seeds',
        'Water',
        'Sunny spot',
      ],
      'steps': [
        'Fill containers with soil',
        'Make small holes for seeds',
        'Place seeds and cover lightly',
        'Water gently',
        'Put in sunny place and water daily',
      ],
      'learning': 'Plant life cycle - seeds need water, soil, and sunlight!',
    },
    {
      'name': 'Homemade Volcano',
      'emoji': '🌋',
      'difficulty': 'Easy',
      'time': '20 mins',
      'category': 'Science',
      'description': 'Make an erupting volcano with kitchen ingredients!',
      'materials': [
        'Baking soda',
        'Vinegar',
        'Food coloring',
        'Container',
        'Tray',
      ],
      'steps': [
        'Place container on tray',
        'Add 2 tablespoons baking soda',
        'Add red food coloring',
        'Pour vinegar and watch it erupt!',
        'Try different amounts to see what happens',
      ],
      'learning': 'Chemical reaction - acid and base create gas bubbles!',
    },
    {
      'name': 'Weather Station',
      'emoji': '☁️',
      'difficulty': 'Medium',
      'time': '1 week project',
      'category': 'Science',
      'description': 'Track weather for a week and make predictions!',
      'materials': ['Paper', 'Crayons', 'Thermometer', 'Rain gauge (cup)'],
      'steps': [
        'Create a weather chart for 7 days',
        'Check weather at same time each day',
        'Draw the weather symbols',
        'Record temperature if you can',
        'Try to predict tomorrow\'s weather!',
      ],
      'learning': 'Weather patterns - observe and predict nature!',
    },
    {
      'name': 'Recycled Robot',
      'emoji': '🤖',
      'difficulty': 'Medium',
      'time': '45 mins',
      'category': 'Art & Recycling',
      'description': 'Build a robot friend from items you would throw away!',
      'materials': [
        'Cardboard boxes',
        'Bottle caps',
        'Toilet paper rolls',
        'Glue',
        'Paint',
      ],
      'steps': [
        'Collect recyclable items',
        'Plan your robot design',
        'Glue pieces together',
        'Add details like eyes and buttons',
        'Paint and decorate!',
      ],
      'learning': 'Recycling creativity - old items become new creations!',
    },
    {
      'name': 'Shadow Puppets',
      'emoji': '🎭',
      'difficulty': 'Easy',
      'time': '30 mins',
      'category': 'Art',
      'description': 'Create puppet characters and put on a shadow show!',
      'materials': [
        'Cardboard',
        'Sticks',
        'Scissors',
        'Flashlight',
        'White sheet',
      ],
      'steps': [
        'Draw character shapes on cardboard',
        'Cut out the shapes carefully',
        'Attach sticks to hold them',
        'Set up flashlight and white sheet',
        'Create your shadow show!',
      ],
      'learning': 'Light and shadows - how light creates shadows!',
    },
    {
      'name': 'Counting Books',
      'emoji': '📖',
      'difficulty': 'Easy',
      'time': '40 mins',
      'category': 'Math & Art',
      'description': 'Make your own counting book from 1 to 10!',
      'materials': ['Paper', 'Crayons', 'Stapler', 'Stickers (optional)'],
      'steps': [
        'Fold papers to make a book',
        'Write numbers 1-10, one per page',
        'Draw that many objects on each page',
        'Decorate your cover',
        'Read your book to someone!',
      ],
      'learning': 'Counting practice - connect numbers to quantities!',
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
    return GradientScaffold(
      title: 'Mini Projects',
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
            ProgressService.to.resetProgress(ProgressService.kMiniProjects);
            setState(() {});
          },
        ),
      ],
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            final progress =
                ProgressService.to.getProgressPercentage(
                  ProgressService.kMiniProjects,
                ) /
                100;
            final progressString = ProgressService.to.getProgressString(
              ProgressService.kMiniProjects,
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
            child: selectedProject == null
                ? _buildProjectsList()
                : _buildProjectDetail(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          // Intro
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                const Text('🎨', style: TextStyle(fontSize: 40)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learn By Doing!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Pick a project and create something amazing',
                        style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Projects Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.r,
              crossAxisSpacing: 12.r,
              childAspectRatio: 0.85,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              final gradient = AppColors.getGradientForIndex(index);

              return Obx(() {
                final isSelected = selectedIndex == index;
                final isCompleted = ProgressService.to.isItemCompleted(
                  ProgressService.kMiniProjects,
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
                      TtsService.to.speak(project['name']);
                      setState(() {
                        selectedIndex = index;
                        selectedProject = project['name'];
                      });
                    },
                    pulseAnimation: pulseAnimation,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              project['emoji'],
                              style: const TextStyle(fontSize: 36),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              project['name'],
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
                            _buildTag(project['difficulty'], Colors.white),
                          ],
                        ),
                        // Show checkmark if completed
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
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProjectDetail() {
    final projectIndex = projects.indexWhere(
      (p) => p['name'] == selectedProject,
    );
    final project = projects[projectIndex];
    final gradient = AppColors.getGradientForIndex(projectIndex);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          // Back to list button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedProject = null;
                  selectedIndex = -1;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 16.r),
                    SizedBox(width: 4.w),
                    Text(
                      'All Projects',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Header Card
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 20.r,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(project['emoji'], style: const TextStyle(fontSize: 70)),
                SizedBox(height: 12.h),
                Text(
                  project['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: gradient[0],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  project['description'],
                  style: GoogleFonts.nunito(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDetailTag('⏱️ ${project['time']}', gradient[0]),
                    SizedBox(width: 8.w),
                    _buildDetailTag('📊 ${project['difficulty']}', gradient[0]),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Materials
          _buildSection(
            '🛠️',
            'What You Need',
            project['materials'],
            gradient[0],
            isList: true,
          ),
          // Steps
          _buildStepsSection(project, gradient[0]),
          // Learning
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              children: [
                const Text('🧠', style: TextStyle(fontSize: 28)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What You\'ll Learn:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      Text(
                        project['learning'],
                        style: GoogleFonts.nunito(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Mark project as completed
                ProgressService.to.markItemCompleted(
                  ProgressService.kMiniProjects,
                  projectIndex,
                );
                Get.snackbar(
                  '🎉 Let\'s Go!',
                  'Gather your materials and start your ${project['name']}!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gradient[0],
                  colorText: Colors.white,
                  margin: EdgeInsets.all(16.r),
                  borderRadius: 12.r,
                );
              },
              icon: const Text('🚀', style: TextStyle(fontSize: 20)),
              label: Text(
                'Start Project!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: gradient[0],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSection(
    String emoji,
    String title,
    List<dynamic> items,
    Color color, {
    bool isList = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            children: items.map<Widget>((item) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.nunito(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection(Map<String, dynamic> project, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8.w),
              Text(
                'Steps',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...List.generate((project['steps'] as List).length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      project['steps'][index],
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
