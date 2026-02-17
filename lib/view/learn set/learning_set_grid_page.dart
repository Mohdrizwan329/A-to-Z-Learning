import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
// Generic Learning Page - replaces 9 individual learning pages
import 'package:jiyan_learning/view/learn%20set/generic_learning_page.dart';
// Other unique pages
import 'package:jiyan_learning/view/learn%20set/shapes_learning_page.dart';
import 'package:jiyan_learning/view/learn%20set/vehicles_learning_page.dart';
import 'package:jiyan_learning/view/learn%20set/seasons_learning_page.dart';

class LearningSetsGridScreen extends StatefulWidget {
  final List<Color>? gradient;

  const LearningSetsGridScreen({super.key, this.gradient});

  @override
  State<LearningSetsGridScreen> createState() => _LearningSetsGridScreenState();
}

class _LearningSetsGridScreenState extends State<LearningSetsGridScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  final ProgressService _progressService = Get.find<ProgressService>();

  final List<Map<String, dynamic>> learningItems = [
    {
      'label': 'Animals',
      'emoji': '🦁',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      'pageBuilder': () => GenericLearningPage(type: 'animals'),
      'progressKey': ProgressService.kAnimals,
    },
    {
      'label': 'Birds',
      'emoji': '🦅',
      'gradient': [Color(0xFF45B7D1), Color(0xFF74C9DB)],
      'pageBuilder': () => GenericLearningPage(type: 'birds'),
      'progressKey': ProgressService.kBirds,
    },
    {
      'label': 'Flowers',
      'emoji': '🌸',
      'gradient': [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
      'pageBuilder': () => GenericLearningPage(type: 'flowers'),
      'progressKey': ProgressService.kFlowers,
    },
    {
      'label': 'Fruits',
      'emoji': '🍎',
      'gradient': [Color(0xFF56D97F), Color(0xFF81E89E)],
      'pageBuilder': () => GenericLearningPage(type: 'fruits'),
      'progressKey': ProgressService.kFruits,
    },
    {
      'label': 'Vegetables',
      'emoji': '🥕',
      'gradient': [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
      'pageBuilder': () => GenericLearningPage(type: 'vegetables'),
      'progressKey': ProgressService.kVegetables,
    },
    {
      'label': 'Colors',
      'emoji': '🌈',
      'gradient': [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
      'pageBuilder': () => GenericLearningPage(type: 'colors'),
      'progressKey': ProgressService.kColors,
    },
    {
      'label': 'Shapes',
      'emoji': '🔷',
      'gradient': [Color(0xFF3B82F6), Color(0xFF60A5FA)],
      'pageBuilder': () => ShapesLearningPage(),
      'progressKey': ProgressService.kShapes,
    },
    {
      'label': 'Vehicles',
      'emoji': '🚗',
      'gradient': [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      'pageBuilder': () => VehiclesLearningPage(),
      'progressKey': ProgressService.kVehicles,
    },
    {
      'label': 'Seasons',
      'emoji': '🌤️',
      'gradient': [Color(0xFF10B981), Color(0xFF34D399)],
      'pageBuilder': () => SeasonsLearningPage(),
      'progressKey': ProgressService.kSeasons,
    },
    {
      'label': 'Days',
      'emoji': '📅',
      'gradient': [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
      'pageBuilder': () => GenericLearningPage(type: 'weekdays'),
      'progressKey': ProgressService.kWeekDays,
    },
    {
      'label': 'Months',
      'emoji': '🗓️',
      'gradient': [Color(0xFF5C6BC0), Color(0xFF8E99D4)],
      'pageBuilder': () => GenericLearningPage(type: 'months'),
      'progressKey': ProgressService.kMonths,
    },
    {
      'label': 'Body Parts',
      'emoji': '🧍',
      'gradient': [Color(0xFFEC407A), Color(0xFFF06292)],
      'pageBuilder': () => GenericLearningPage(type: 'bodyparts'),
      'progressKey': ProgressService.kBodyParts,
    },
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  // Calculate overall progress for all learning sets
  double get _overallProgress {
    int totalCompleted = 0;
    int totalItems = 0;

    for (var item in learningItems) {
      final key = item['progressKey'] as String;
      totalCompleted += _progressService.getCompletedCount(key);
      totalItems += _progressService.getTotalCount(key);
    }

    if (totalItems == 0) return 0;
    return totalCompleted / totalItems;
  }

  String get _progressString {
    int totalCompleted = 0;
    int totalItems = 0;

    for (var item in learningItems) {
      final key = item['progressKey'] as String;
      totalCompleted += _progressService.getCompletedCount(key);
      totalItems += _progressService.getTotalCount(key);
    }

    return '$totalCompleted/$totalItems';
  }

  bool _hasProgress(String progressKey) {
    return _progressService.getCompletedCount(progressKey) > 0;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return GradientScaffold(
      title: 'Learning Sets',
      body: Column(
        children: [
          // Progress bar with percentage
          Obx(() {
            // Access completedItems to trigger rebuild
            final _ = _progressService.completedItems.length;
            final progress = _overallProgress;
            final progressString = _progressString;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: learningItems.length,
              itemBuilder: (context, index) {
                final item = learningItems[index];

                return AnimatedBuilder(
                  animation: _floatController,
                  builder: (_, child) {
                    final offset = (index % 2 == 0)
                        ? _floatAnimation.value
                        : -_floatAnimation.value;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                  child: Obx(() {
                    // Access completedItems to trigger rebuild
                    final _ = _progressService.completedItems.length;
                    return _buildCard(item, index);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    final List<Color> gradient = item['gradient'];
    final String progressKey = item['progressKey'];
    final bool hasProgress = _hasProgress(progressKey);

    return GestureDetector(
      onTap: () => Get.to(item['pageBuilder']),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            // Content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          item['emoji'],
                          style: TextStyle(fontSize: 42),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item['label'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Checkmark badge when has any progress
            if (hasProgress)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: gradient[0],
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
