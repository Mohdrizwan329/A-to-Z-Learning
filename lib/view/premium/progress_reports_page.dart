import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ProgressReportsPage extends StatefulWidget {
  const ProgressReportsPage({super.key});

  @override
  State<ProgressReportsPage> createState() => _ProgressReportsPageState();
}

class _ProgressReportsPageState extends State<ProgressReportsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  bool _isInitialized = false;

  // Card gradients matching home screen style
  final List<List<Color>> cardGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF56D97F), Color(0xFF81E89E)],
    [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
    [Color(0xFFFFE66D), Color(0xFFFFF59D)],
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
  ];

  final categories = [
    {
      'key': ProgressService.kNumbers,
      'title': 'Numbers (1-100)',
      'icon': '🔢',
      'total': 100,
      'colors': [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
    },
    {
      'key': ProgressService.kCapitalLetters,
      'title': 'Capital Letters',
      'icon': '🅰️',
      'total': 26,
      'colors': [const Color(0xFF45B7D1), const Color(0xFF74C9DB)],
    },
    {
      'key': ProgressService.kSmallLetters,
      'title': 'Small Letters',
      'icon': '🔤',
      'total': 26,
      'colors': [const Color(0xFF56D97F), const Color(0xFF81E89E)],
    },
    {
      'key': ProgressService.kHindiLetters,
      'title': 'Hindi Letters',
      'icon': '🇮🇳',
      'total': 46,
      'colors': [const Color(0xFFFFAA5A), const Color(0xFFFFCB80)],
    },
    {
      'key': ProgressService.kAlphabetWords,
      'title': 'A to Z Words',
      'icon': '📖',
      'total': 26,
      'colors': [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)],
    },
    {
      'key': ProgressService.kTables,
      'title': 'Tables (2-40)',
      'icon': '✖️',
      'total': 39,
      'colors': [const Color(0xFFFF6EB4), const Color(0xFFFF9ECE)],
    },
    {
      'key': ProgressService.kAnimals,
      'title': 'Animals',
      'icon': '🦁',
      'total': 30,
      'colors': [const Color(0xFF4ECDC4), const Color(0xFF7EDDD6)],
    },
    {
      'key': ProgressService.kFruits,
      'title': 'Fruits',
      'icon': '🍎',
      'total': 20,
      'colors': [const Color(0xFFFFE66D), const Color(0xFFFFF59D)],
    },
    {
      'key': ProgressService.kColors,
      'title': 'Colors',
      'icon': '🎨',
      'total': 12,
      'colors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFAA5A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
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
              stops: [0.0, 0.3, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final progressService = ProgressService.to;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Stack(
          children: [
            // Floating bubbles
            ..._buildFloatingBubbles(),
            SafeArea(
              child: Obx(() {
                // Calculate overall progress
                int totalCompleted = 0;
                int totalItems = 0;
                for (var cat in categories) {
                  totalCompleted += progressService.getCompletedCount(
                    cat['key'] as String,
                  );
                  totalItems += cat['total'] as int;
                }
                double overallProgress = totalItems > 0
                    ? (totalCompleted / totalItems) * 100
                    : 0;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      // Overall Progress Card with float animation
                      _buildFloatingCard(
                        index: 0,
                        child: _buildAnimatedCard(
                          delay: 0,
                          child: _buildOverallProgressCard(
                            overallProgress,
                            totalCompleted,
                            totalItems,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Stats Row with float animation
                      _buildFloatingCard(
                        index: 1,
                        child: _buildAnimatedCard(
                          delay: 100,
                          child: _buildStatsRow(
                            totalCompleted,
                            totalItems,
                            progressService,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Category Progress Cards with float animation
                      ...List.generate(categories.length, (index) {
                        final cat = categories[index];
                        return _buildFloatingCard(
                          index: index + 2,
                          child: _buildAnimatedCard(
                            delay: 200 + (index * 80),
                            child: _buildCategoryCard(
                              cat,
                              progressService,
                              index,
                            ),
                          ),
                        );
                      }),

                      SizedBox(height: 20.h),

                      // Tips Card with float animation
                      _buildFloatingCard(
                        index: categories.length + 2,
                        child: _buildAnimatedCard(
                          delay: 200 + (categories.length * 80),
                          child: _buildTipsCard(),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Achievement Card with float animation
                      _buildFloatingCard(
                        index: categories.length + 3,
                        child: _buildAnimatedCard(
                          delay: 300 + (categories.length * 80),
                          child: _buildAchievementCard(overallProgress),
                        ),
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index);
      final size = 30.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final startTop = random.nextDouble() * MediaQuery.of(context).size.height;

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + index * 0.15) % 1.0;
          final top =
              startTop - (progress * MediaQuery.of(context).size.height * 0.5);
          final opacity = (1 - progress).clamp(0.0, 0.15);

          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFloatingCard({required int index, required Widget child}) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, _) {
        final offset = index.isEven
            ? _floatAnimation.value * 0.5
            : -_floatAnimation.value * 0.5;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
            Icons.arrow_back_ios_new_rounded,
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
      title: FittedBox(
        // An AppBar title is width-capped by the leading and action slots.
        // This one is a Row of separately styled pieces, so it cannot
        // ellipsize; scaling it down keeps all of it readable on a narrow
        // phone instead of clipping the tail.
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Progress ',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
            Text(
              'Reports',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFE66D),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
    );
  }

  Widget _buildOverallProgressCard(double progress, int completed, int total) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.4),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -30.h,
            right: -30.w,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  // Animated Progress Circle
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress / 100),
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 10.r,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            progress >= 100
                                ? "🏆"
                                : (progress >= 50 ? "⭐" : "📚"),
                            style: const TextStyle(fontSize: 36),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Progress',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return Text(
                              '${value.toStringAsFixed(1)}%',
                              style: GoogleFonts.baloo2(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: progress / 100),
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return FractionallySizedBox(
                                  widthFactor: value,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Color(0xFFFFF8DC),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Three equal shares, so the widest label wraps inside its
                    // own column rather than pushing the row past the card.
                    Expanded(
                      child: _buildStatItem('Completed', '$completed', '✅'),
                    ),
                    Container(
                      width: 1.w,
                      height: 40.h,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Remaining',
                        '${total - completed}',
                        '📝',
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 40.h,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Categories',
                        '${categories.length}',
                        '📂',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    int completed,
    int total,
    ProgressService progressService,
  ) {
    // Count completed categories
    int completedCategories = 0;
    for (var cat in categories) {
      if (progressService.getProgressPercentage(cat['key'] as String) >= 100) {
        completedCategories++;
      }
    }

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardGradients[3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cardGradients[3][0].withValues(alpha: 0.4),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildQuickStat(
                  '🎯',
                  'Categories\nCompleted',
                  '$completedCategories/${categories.length}',
                ),
              ),
              Container(
                width: 1.w,
                height: 60.h,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildQuickStat('📈', 'Items\nLearned', '$completed'),
              ),
              Container(
                width: 1.w,
                height: 60.h,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildQuickStat(
                  '🔥',
                  'Keep\nGoing!',
                  completedCategories > 0 ? 'Great!' : 'Start!',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    Map<String, dynamic> cat,
    ProgressService progressService,
    int index,
  ) {
    final progress = progressService.getProgressPercentage(
      cat['key'] as String,
    );
    final completed = progressService.getCompletedCount(cat['key'] as String);
    final total = cat['total'] as int;
    final colors = cat['colors'] as List<Color>;
    final isComplete = progress >= 100;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.4),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -15.h,
            right: -15.w,
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Icon with background
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      cat['icon'] as String,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Title and progress
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat['title'] as String,
                        style: GoogleFonts.baloo2(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            '$completed',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              ' of $total completed',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Progress bar
                      Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress / 100),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) {
                              return FractionallySizedBox(
                                widthFactor: value,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // Progress percentage
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isComplete) ...[
                      SizedBox(height: 6.h),
                      const Text("🎉", style: TextStyle(fontSize: 20)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    final tips = [
      {"icon": "⏰", "tip": "Practice 15 minutes daily for best results"},
      {"icon": "🎯", "tip": "Complete one category before moving to next"},
      {"icon": "📖", "tip": "Review completed items weekly"},
      {"icon": "🌟", "tip": "Celebrate small wins to stay motivated"},
    ];

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardGradients[3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cardGradients[3][0].withValues(alpha: 0.4),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text("💡", style: TextStyle(fontSize: 26)),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      "Learning Tips",
                      style: GoogleFonts.baloo2(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...tips.map(
                (tip) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          tip['icon']!,
                          style: const TextStyle(fontSize: 22),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            tip['tip']!,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(double progress) {
    String title;
    String subtitle;
    String emoji;
    List<Color> colors;

    if (progress >= 100) {
      title = "Learning Master!";
      subtitle = "You've completed everything! Amazing job!";
      emoji = "🏆";
      colors = [const Color(0xFFFFD700), const Color(0xFFFFA500)];
    } else if (progress >= 75) {
      title = "Almost There!";
      subtitle = "Just a little more to become a master!";
      emoji = "🌟";
      colors = cardGradients[4];
    } else if (progress >= 50) {
      title = "Great Progress!";
      subtitle = "You're halfway there! Keep going!";
      emoji = "🚀";
      colors = cardGradients[2];
    } else if (progress >= 25) {
      title = "Good Start!";
      subtitle = "You're building a strong foundation!";
      emoji = "📚";
      colors = cardGradients[3];
    } else {
      title = "Let's Begin!";
      subtitle = "Start your learning adventure today!";
      emoji = "🎯";
      colors = cardGradients[0];
    }

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.4),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
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
          Row(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 40)),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.baloo2(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
