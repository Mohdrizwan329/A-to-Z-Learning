import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/view%20model/auth%20controller/auth_controller.dart';
import 'package:jiyan_learning/services/firebase_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ParentDashboardPage extends StatefulWidget {
  const ParentDashboardPage({super.key});

  @override
  State<ParentDashboardPage> createState() => _ParentDashboardPageState();
}

class _ParentDashboardPageState extends State<ParentDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;

  // Toggle states for parental controls
  bool _screenTimeEnabled = true;
  bool _contentFilterEnabled = true;
  bool _progressNotificationsEnabled = true;
  bool _learningGoalsEnabled = false;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressService = ProgressService.to;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Kid-friendly rainbow gradient background (same as home)
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA), // Soft Purple
              Color(0xFF764BA2), // Deep Purple
              Color(0xFFf093fb), // Pink
              Color(0xFFf5576c), // Coral
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating bubbles background
            ..._buildFloatingBubbles(),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Child Profile Card
                    _buildChildProfileCard(),
                    SizedBox(height: 20.h),
                    // Quick Stats
                    _buildQuickStats(progressService),
                    SizedBox(height: 24.h),
                    // Learning Activity
                    _buildSectionTitle('Learning Activity', '📈'),
                    SizedBox(height: 12.h),
                    _buildActivityChart(progressService),
                    SizedBox(height: 24.h),
                    // Strengths & Areas to Improve
                    _buildSectionTitle('Strengths', '💪'),
                    SizedBox(height: 12.h),
                    _buildStrengthsCard(progressService),
                    SizedBox(height: 24.h),
                    // Recommendations
                    _buildSectionTitle('Recommendations', '💡'),
                    SizedBox(height: 12.h),
                    _buildRecommendationsCard(progressService),
                    SizedBox(height: 24.h),
                    // Weekly Summary
                    _buildSectionTitle('Weekly Summary', '📅'),
                    SizedBox(height: 12.h),
                    _buildWeeklySummaryCard(),
                    SizedBox(height: 24.h),
                    // Settings
                    _buildSectionTitle('Parental Controls', '⚙️'),
                    SizedBox(height: 12.h),
                    _buildParentalControlsCard(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18.r,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          // Vibrant kid-friendly gradient - Coral to Pink to Orange (same as home)
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B6B), // Coral Red
              Color(0xFFFF8E53), // Orange
              Color(0xFFFFAA5A), // Light Orange
            ],
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
              'Parent ',
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
              'Dashboard',
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
    );
  }

  // Floating bubbles for playful effect (same as home)
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

  Widget _buildChildProfileCard() {
    return Obx(() {
      String childName = 'Your Child';
      int? childAge;

      if (FirebaseService.isAvailable) {
        AuthController authController;
        if (Get.isRegistered<AuthController>()) {
          authController = Get.find<AuthController>();
        } else {
          authController = Get.put(AuthController(), permanent: true);
        }
        if (authController.userModel != null) {
          childName = authController.userModel?.childName ?? 'Your Child';
          childAge = authController.userModel?.childAge;
        }
      }

      return AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value * 0.3),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20.r,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar with decorative ring and floating animation
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFFFFAA5A),
                          Color(0xFF4ECDC4),
                        ],
                      ),
                    ),
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text("👶", style: TextStyle(fontSize: 36)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          childName,
                          style: GoogleFonts.baloo2(
                            fontSize: 22,
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
                        if (childAge != null)
                          Text(
                            '$childAge years old',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF56D97F), Color(0xFF44A08D)],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF56D97F,
                                ).withValues(alpha: 0.4),
                                blurRadius: 8.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Active Learner',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildQuickStats(ProgressService progressService) {
    return Obx(() {
      final overallProgress = progressService.getOverallProgress();
      final numbersProgress = progressService.getProgressPercentage(
        ProgressService.kNumbers,
      );
      final lettersProgress =
          (progressService.getProgressPercentage(
                ProgressService.kCapitalLetters,
              ) +
              progressService.getProgressPercentage(
                ProgressService.kSmallLetters,
              )) /
          2;

      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Overall',
              '${overallProgress.toStringAsFixed(0)}%',
              '📊',
              const [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              0,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Numbers',
              '${numbersProgress.toStringAsFixed(0)}%',
              '🔢',
              const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              1,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Letters',
              '${lettersProgress.toStringAsFixed(0)}%',
              '🔤',
              const [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
              2,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    String label,
    String value,
    String emoji,
    List<Color> gradient,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final offset = (index % 2 == 0)
            ? _floatAnimation.value * 0.5
            : -_floatAnimation.value * 0.5;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: Container(
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
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circle (top-right)
            Positioned(
              top: -15.h,
              right: -15.w,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Decorative circle (bottom-left)
            Positioned(
              bottom: -20.h,
              left: -20.w,
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Small sparkle dots
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              bottom: 12.h,
              right: 12.w,
              child: Container(
                width: 4.w,
                height: 4.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
            Column(
              children: [
                // Emoji container with glow effect
                Container(
                  width: 55.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 10.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 26)),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  value,
                  style: GoogleFonts.baloo2(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4.r,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 2.r,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String emoji) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(ProgressService progressService) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 0.4),
          child: child,
        );
      },
      child: Obx(() {
        final categories = [
          {
            'key': ProgressService.kNumbers,
            'label': 'Numbers',
            'emoji': '🔢',
            'gradient': const [
              Color(0xFFFF6B6B),
              Color(0xFFFF8E53),
              Color(0xFFFFAA5A),
            ],
          },
          {
            'key': ProgressService.kCapitalLetters,
            'label': 'Capital',
            'emoji': '🅰️',
            'gradient': const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          },
          {
            'key': ProgressService.kSmallLetters,
            'label': 'Small',
            'emoji': '🔤',
            'gradient': const [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
          },
          {
            'key': ProgressService.kHindiLetters,
            'label': 'Hindi',
            'emoji': '🇮🇳',
            'gradient': const [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
          },
          {
            'key': ProgressService.kTables,
            'label': 'Tables',
            'emoji': '✖️',
            'gradient': const [Color(0xFF56D97F), Color(0xFF44A08D)],
          },
        ];

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                blurRadius: 15.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -20.h,
                right: -20.w,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30.h,
                left: -30.w,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Sparkle dots
              Positioned(
                top: 15.h,
                left: 20.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h,
                right: 30.w,
                child: Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: categories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cat = entry.value;
                      final progress = progressService.getProgressPercentage(
                        cat['key'] as String,
                      );
                      final gradient = cat['gradient'] as List<Color>;
                      const maxHeight = 100.0;

                      // Equal shares: five subject bars together are wider
                      // than the card on a small phone.
                      return Expanded(
                        child: AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            final offset = (index % 2 == 0)
                                ? _floatAnimation.value * 0.3
                                : -_floatAnimation.value * 0.3;
                            return Transform.translate(
                              offset: Offset(0, offset),
                              child: child,
                            );
                          },
                          child: Column(
                            children: [
                              // Emoji icon
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    cat['emoji'] as String,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // Percentage label
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: gradient),
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gradient[0].withValues(alpha: 0.4),
                                      blurRadius: 4.r,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${progress.toStringAsFixed(0)}%',
                                  style: GoogleFonts.baloo2(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Bar with inner glow
                              Container(
                                width: 48.w,
                                height:
                                    maxHeight *
                                    (progress / 100).clamp(0.08, 1.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradient,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gradient[0].withValues(alpha: 0.5),
                                      blurRadius: 10.r,
                                      offset: const Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 5.r,
                                      spreadRadius: -2.r,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                cat['label'] as String,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 2.r,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStrengthsCard(ProgressService progressService) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_floatAnimation.value * 0.4),
          child: child,
        );
      },
      child: Obx(() {
        final categories = {
          'Numbers': progressService.getProgressPercentage(
            ProgressService.kNumbers,
          ),
          'Capital Letters': progressService.getProgressPercentage(
            ProgressService.kCapitalLetters,
          ),
          'Small Letters': progressService.getProgressPercentage(
            ProgressService.kSmallLetters,
          ),
          'Hindi Letters': progressService.getProgressPercentage(
            ProgressService.kHindiLetters,
          ),
          'Tables': progressService.getProgressPercentage(
            ProgressService.kTables,
          ),
        };

        final sorted = categories.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final strengths = sorted.take(2).toList();
        final needsWork = sorted.reversed.take(2).toList();

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF56D97F), Color(0xFF44A08D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF56D97F).withValues(alpha: 0.4),
                blurRadius: 15.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -25.h,
                right: -25.w,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30.h,
                left: -30.w,
                child: Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Sparkle dots
              Positioned(
                top: 12.h,
                left: 15.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Column(
                children: [
                  ...strengths.map(
                    (e) => _buildProgressItem(e.key, e.value, const [
                      Color(0xFF4ECDC4),
                      Color(0xFF44A08D),
                    ], '💪'),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    height: 2.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFAA5A).withValues(alpha: 0.4),
                          blurRadius: 8.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: const Text(
                            '📚',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            'Areas to Improve',
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...needsWork.map(
                    (e) => _buildProgressItem(e.key, e.value, const [
                      Color(0xFFFF6B6B),
                      Color(0xFFFF8E53),
                      Color(0xFFFFAA5A),
                    ], '📖'),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProgressItem(
    String label,
    double progress,
    List<Color> gradient,
    String emoji,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (progress / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradient),
                        borderRadius: BorderRadius.circular(5.r),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withValues(alpha: 0.4),
                            blurRadius: 4.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '${progress.toStringAsFixed(0)}%',
              style: GoogleFonts.baloo2(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(ProgressService progressService) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 0.5),
          child: child,
        );
      },
      child: Obx(() {
        final recommendations = <Map<String, dynamic>>[];

        if (progressService.getProgressPercentage(ProgressService.kNumbers) <
            50) {
          recommendations.add({
            'text': 'Practice counting numbers daily',
            'icon': '🔢',
            'gradient': const [
              Color(0xFFFF6B6B),
              Color(0xFFFF8E53),
              Color(0xFFFFAA5A),
            ],
          });
        }
        if (progressService.getProgressPercentage(
              ProgressService.kCapitalLetters,
            ) <
            50) {
          recommendations.add({
            'text': 'Focus on learning capital letters',
            'icon': '🅰️',
            'gradient': const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          });
        }
        if (progressService.getProgressPercentage(ProgressService.kTables) <
            30) {
          recommendations.add({
            'text': 'Start with basic multiplication tables',
            'icon': '✖️',
            'gradient': const [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
          });
        }
        if (recommendations.isEmpty) {
          recommendations.add({
            'text': 'Great progress! Keep up the good work!',
            'icon': '🌟',
            'gradient': const [Color(0xFF56D97F), Color(0xFF44A08D)],
          });
          recommendations.add({
            'text': 'Try advanced math games for more challenge',
            'icon': '🎮',
            'gradient': const [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
          });
        }

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFA78BFA).withValues(alpha: 0.4),
                blurRadius: 15.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -25.h,
                right: -25.w,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -35.h,
                left: -35.w,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Sparkle dots
              Positioned(
                top: 10.h,
                left: 15.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Column(
                children: recommendations
                    .map(
                      (r) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            // Emoji container with glow
                            Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: r['gradient'] as List<Color>,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (r['gradient'] as List<Color>)[0]
                                        .withValues(alpha: 0.4),
                                    blurRadius: 8.r,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  r['icon'] as String,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Text(
                                r['text'] as String,
                                style: GoogleFonts.nunito(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 2.r,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16.r,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWeeklySummaryCard() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_floatAnimation.value * 0.5),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              top: -30.h,
              right: -30.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -40.h,
              left: -40.w,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Sparkle dots
            Positioned(
              top: 15.h,
              left: 20.w,
              child: Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              top: 50.h,
              right: 40.w,
              child: Container(
                width: 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Equal shares so the widest label wraps in its own column.
                    Expanded(
                      child: _buildSummaryItem(
                        'Time Spent',
                        '2h 30m',
                        '⏱️',
                        const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                      ),
                    ),
                    Expanded(
                      child: _buildSummaryItem('Lessons', '12', '📖', const [
                        Color(0xFFA78BFA),
                        Color(0xFF8B5CF6),
                      ]),
                    ),
                    Expanded(
                      child: _buildSummaryItem('Streak', '5 days', '🔥', const [
                        Color(0xFFFFE66D),
                        Color(0xFFFFCA28),
                      ]),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Weekly chart with enhanced styling
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .asMap()
                        .entries
                        .map((entry) {
                          final isToday =
                              entry.key == DateTime.now().weekday - 1;
                          final heights = [0.4, 0.6, 0.8, 0.5, 0.9, 0.3, 0.0];
                          // Seven day columns are wider than the card on a
                          // small phone; equal shares keep them inside it.
                          return Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 32.w,
                                  height:
                                      70.h * heights[entry.key].clamp(0.1, 1.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isToday
                                          ? const [
                                              Color(0xFFFFE66D),
                                              Color(0xFFFFCA28),
                                            ]
                                          : const [
                                              Color(0xFF4ECDC4),
                                              Color(0xFF44A08D),
                                            ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (isToday
                                                    ? const Color(0xFFFFE66D)
                                                    : const Color(0xFF4ECDC4))
                                                .withValues(alpha: 0.5),
                                        blurRadius: 6.r,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    entry.value,
                                    style: GoogleFonts.nunito(
                                      fontSize: 11,
                                      fontWeight: isToday
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    String emoji,
    List<Color> gradient,
  ) {
    return Column(
      children: [
        // Emoji container with glow effect
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.5),
                blurRadius: 12.r,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 5.r,
                spreadRadius: -2.r,
              ),
            ],
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 3.r,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 2.r,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParentalControlsCard() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 0.4),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              top: -30.h,
              right: -30.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -40.h,
              left: -40.w,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Sparkle dots
            Positioned(
              top: 15.h,
              left: 20.w,
              child: Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              bottom: 30.h,
              right: 25.w,
              child: Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
            Column(
              children: [
                _buildControlItem(
                  'Screen Time Limit',
                  'Set daily usage limits',
                  Icons.timer_outlined,
                  const [
                    Color(0xFFFF6B6B),
                    Color(0xFFFF8E53),
                    Color(0xFFFFAA5A),
                  ],
                  _screenTimeEnabled,
                  (v) => setState(() => _screenTimeEnabled = v),
                ),
                _buildDivider(),
                _buildControlItem(
                  'Content Filter',
                  'Age-appropriate content only',
                  Icons.shield_outlined,
                  const [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                  _contentFilterEnabled,
                  (v) => setState(() => _contentFilterEnabled = v),
                ),
                _buildDivider(),
                _buildControlItem(
                  'Progress Notifications',
                  'Get weekly reports',
                  Icons.notifications_outlined,
                  const [Color(0xFFFFAA5A), Color(0xFFFF8E53)],
                  _progressNotificationsEnabled,
                  (v) => setState(() => _progressNotificationsEnabled = v),
                ),
                _buildDivider(),
                _buildControlItem(
                  'Learning Goals',
                  'Set daily learning targets',
                  Icons.flag_outlined,
                  const [Color(0xFF56D97F), Color(0xFF44A08D)],
                  _learningGoalsEnabled,
                  (v) => setState(() => _learningGoalsEnabled = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      height: 1.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildControlItem(
    String title,
    String subtitle,
    IconData icon,
    List<Color> gradient,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container with glow effect and floating animation
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.5),
                  blurRadius: 12.r,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 6.r,
                  spreadRadius: -2.r,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Inner glow
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                        center: const Alignment(-0.3, -0.3),
                        radius: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Icon(icon, color: Colors.white, size: 28.r),
                ),
              ],
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
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 3.r,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          // Custom styled switch container
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 60.w,
              height: 34.h,
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: value
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: value ? null : Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: value
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 10.r,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: value
                      ? Icon(
                          Icons.check_rounded,
                          size: 16.r,
                          color: gradient[0],
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
