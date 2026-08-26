import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class EarlyLearningHubPage extends StatefulWidget {
  const EarlyLearningHubPage({super.key});

  @override
  State<EarlyLearningHubPage> createState() => _EarlyLearningHubPageState();
}

class _EarlyLearningHubPageState extends State<EarlyLearningHubPage>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final ProgressService _progressService = Get.find<ProgressService>();

  final List<LearningType> _learningTypes = [];

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.2);
  }

  void _openLearningType(LearningType type) {
    HapticFeedback.mediumImpact();
    _tts.speak(type.name);
    // Mark as visited/completed
    _progressService.markItemCompleted(type.progressKey, 0);
    Get.to(() => type.page);
  }

  // Calculate overall progress for Early Learning
  double get _overallProgress {
    int totalCompleted = 0;
    for (var type in _learningTypes) {
      if (_progressService.getCompletedCount(type.progressKey) > 0) {
        totalCompleted++;
      }
    }
    // _learningTypes is currently never populated, so this divided 0 by 0 and
    // handed LinearProgressIndicator a NaN, which blew the layout out by ~99k
    // pixels. Guard the division regardless of what the list holds.
    if (_learningTypes.isEmpty) return 0;
    return totalCompleted / _learningTypes.length;
  }

  String get _progressString {
    int totalCompleted = 0;
    for (var type in _learningTypes) {
      if (_progressService.getCompletedCount(type.progressKey) > 0) {
        totalCompleted++;
      }
    }
    return '$totalCompleted/${_learningTypes.length}';
  }

  bool _hasProgress(String progressKey) {
    return _progressService.getCompletedCount(progressKey) > 0;
  }

  void _resetProgress() {
    // Reset progress for all Early Learning categories
    for (var type in _learningTypes) {
      _progressService.resetProgress(type.progressKey);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 8,
        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40FF6B6B),
                blurRadius: 15.r,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
        title: const Text(
          'Early Learning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
            onPressed: _resetProgress,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress bar with percentage
              Obx(() {
                // Access completedItems to trigger rebuild
                final _ = _progressService.completedItems.length;
                final progress = _overallProgress;
                final progressString = _progressString;
                return Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: const Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                              maxLines: 1,
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
              // Learning types grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(12.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _learningTypes.length,
                  itemBuilder: (context, index) {
                    final type = _learningTypes[index];
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
                        final hasProgress = _hasProgress(type.progressKey);
                        return _LearningTypeCard(
                          type: type,
                          onTap: () => _openLearningType(type),
                          index: index,
                          hasProgress: hasProgress,
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningTypeCard extends StatelessWidget {
  final LearningType type;
  final VoidCallback onTap;
  final int index;
  final bool hasProgress;

  const _LearningTypeCard({
    required this.type,
    required this.onTap,
    required this.index,
    this.hasProgress = false,
  });

  // Get gradient colors based on index for variety
  List<Color> _getGradient() {
    final gradients = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)], // Coral
      [const Color(0xFF45B7D1), const Color(0xFF74C9DB)], // Blue
      [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)], // Purple
      [const Color(0xFF56D97F), const Color(0xFF81E89E)], // Green
      [const Color(0xFFFF6EB4), const Color(0xFFFF9ECE)], // Pink
      [const Color(0xFF4ECDC4), const Color(0xFF7EDDD6)], // Teal
      [const Color(0xFFFFAA5A), const Color(0xFFFFCB80)], // Orange
      [const Color(0xFF5C6BC0), const Color(0xFF8E99D4)], // Indigo
      [const Color(0xFFEC407A), const Color(0xFFF06292)], // Pink Red
      [const Color(0xFF26C6DA), const Color(0xFF4DD0E1)], // Cyan
    ];
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles (same as Learning Sets)
            Positioned(
              top: -20.h,
              right: -20.w,
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            // Content - emoji with text
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 75.w,
                        height: 75.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            type.emoji,
                            style: const TextStyle(fontSize: 42),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        type.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Checkmark badge when visited
            if (hasProgress)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: gradient[0], size: 16.r),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LearningType {
  final String name;
  final String emoji;
  final String description;
  final Color color;
  final Widget page;
  final String progressKey;

  LearningType({
    required this.name,
    required this.emoji,
    required this.description,
    required this.color,
    required this.page,
    required this.progressKey,
  });
}
