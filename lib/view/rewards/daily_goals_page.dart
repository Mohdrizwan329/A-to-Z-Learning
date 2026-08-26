import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/daily_goals_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class DailyGoalsPage extends StatefulWidget {
  const DailyGoalsPage({super.key});

  @override
  State<DailyGoalsPage> createState() => _DailyGoalsPageState();
}

class _DailyGoalsPageState extends State<DailyGoalsPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  bool _isInitialized = false;

  DailyGoalsService get goalsService {
    if (!Get.isRegistered<DailyGoalsService>()) {
      Get.put(DailyGoalsService(), permanent: true);
    }
    return Get.find<DailyGoalsService>();
  }

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

  @override
  void initState() {
    super.initState();
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Progress Card with float animation
                    _buildFloatingCard(index: 0, child: _buildProgressCard()),

                    SizedBox(height: 20.h),

                    // Streak Card with float animation
                    _buildFloatingCard(index: 1, child: _buildStreakCard()),

                    SizedBox(height: 24.h),

                    // Daily Goals List Title
                    _buildAnimatedCard(
                      delay: 200,
                      child: _buildSectionTitle("Today's Goals", "🎯"),
                    ),
                    SizedBox(height: 12.h),

                    // Goals List
                    _buildGoalsList(),

                    SizedBox(height: 24.h),

                    // Completion Bonus with float animation
                    _buildFloatingCard(index: 2, child: _buildBonusCard()),

                    SizedBox(height: 20.h),

                    // Tips Card with float animation
                    _buildFloatingCard(index: 3, child: _buildTipsCard()),

                    SizedBox(height: 20.h),

                    // Motivation Card with float animation
                    _buildFloatingCard(index: 4, child: _buildMotivationCard()),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
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
            ? _floatAnimation.value
            : -_floatAnimation.value;
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
            Flexible(
              child: Text(
                'Daily ',
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Flexible(
              child: Text(
                'Goals',
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
    );
  }

  Widget _buildProgressCard() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: goalsService.allGoalsCompleted.value
              ? const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: cardGradients[2], // Green gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: goalsService.allGoalsCompleted.value
                  ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                  : cardGradients[2][0].withValues(alpha: 0.4),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
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
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goalsService.allGoalsCompleted.value
                                ? "All Goals Complete! 🎉"
                                : "Today's Progress",
                            style: GoogleFonts.baloo2(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "${goalsService.completedGoalIds.length} of ${goalsService.dailyGoals.length} completed",
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60.w,
                            height: 60.h,
                            child: CircularProgressIndicator(
                              value: goalsService.overallDailyProgress / 100,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 6.r,
                            ),
                          ),
                          Text(
                            "${goalsService.overallDailyProgress.toInt()}%",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: goalsService.overallDailyProgress / 100,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      minHeight: 12.h,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: cardGradients[0], // Coral Red gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cardGradients[0][0].withValues(alpha: 0.4),
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
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: const Center(
                    child: Text("🔥", style: TextStyle(fontSize: 40)),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Goal Streak",
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${goalsService.goalStreak.value} Days",
                        style: GoogleFonts.baloo2(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${goalsService.totalGoalsCompleted.value}",
                        style: GoogleFonts.baloo2(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Text(
            title,
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
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: goalsService.dailyGoals.length,
        itemBuilder: (context, index) {
          final goal = goalsService.dailyGoals[index];
          final goalId = goal['id'] as String;
          final isCompleted = goalsService.isGoalCompleted(goalId);
          final progress = goalsService.getGoalProgressPercentage(goalId);
          final currentProgress = goalsService.goalProgress[goalId] ?? 0;
          final target = goal['target'] as int;

          final colorPair = cardGradients[index % cardGradients.length];

          return AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              final offset = index.isEven
                  ? _floatAnimation.value * 0.4
                  : -_floatAnimation.value * 0.4;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                gradient: isCompleted
                    ? LinearGradient(
                        colors:
                            cardGradients[2], // Green gradient for completed
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: colorPair,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: (isCompleted ? cardGradients[2][0] : colorPair[0])
                        .withValues(alpha: 0.4),
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
                  Column(
                    children: [
                      // Goal Header
                      Container(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          children: [
                            Container(
                              width: 54.w,
                              height: 54.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Center(
                                child: isCompleted
                                    ? Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 30.r,
                                      )
                                    : Text(
                                        goal['icon'] as String,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal['title'] as String,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    goal['description'] as String,
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                "$currentProgress/$target",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Progress Section
                      Container(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: LinearProgressIndicator(
                                    value: progress / 100,
                                    backgroundColor: Colors.transparent,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    minHeight: 10.h,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    "⭐",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "${goal['starReward']}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "+${goal['xpReward']} XP",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
        },
      ),
    );
  }

  Widget _buildBonusCard() {
    return Obx(() {
      if (!goalsService.allGoalsCompleted.value) {
        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: const Center(
                  child: Text("🎁", style: TextStyle(fontSize: 32)),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daily Bonus",
                      style: GoogleFonts.baloo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Complete all goals to earn:\n⭐ 10 Stars  +50 XP  🏅 Badge",
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.4),
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
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: const Center(
                    child: Text("🎉", style: TextStyle(fontSize: 32)),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bonus Claimed!",
                        style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "You earned: ⭐ 10 Stars  +50 XP  🏅 Badge",
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white,
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
    });
  }

  Widget _buildTipsCard() {
    final tips = [
      {"icon": "📚", "tip": "Learn 3 new alphabets daily"},
      {"icon": "🔢", "tip": "Practice numbers every morning"},
      {"icon": "🎨", "tip": "Try coloring for creativity"},
      {"icon": "🎵", "tip": "Listen to rhymes while learning"},
    ];

    final randomTip = tips[DateTime.now().day % tips.length];
    final gradient = cardGradients[3]; // Blue gradient

    return Container(
      padding: EdgeInsets.all(20.r),
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
          // Decorative circle
          Positioned(
            top: -20.h,
            right: -20.w,
            child: Container(
              width: 70.w,
              height: 70.h,
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
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text("💡", style: TextStyle(fontSize: 26)),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Flexible(
                    child: Text(
                      "Today's Tip",
                      style: GoogleFonts.baloo2(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Text(
                      randomTip['icon']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        randomTip['tip']!,
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildMotivationCard() {
    final motivations = [
      {"emoji": "🌟", "text": "You're doing amazing! Keep learning!"},
      {"emoji": "🚀", "text": "Every day is a new adventure!"},
      {"emoji": "💪", "text": "Practice makes perfect!"},
      {"emoji": "🎯", "text": "Small steps lead to big success!"},
      {"emoji": "🌈", "text": "Learning is fun, keep exploring!"},
    ];

    final randomMotivation =
        motivations[DateTime.now().hour % motivations.length];
    final gradient = cardGradients[4]; // Purple gradient

    return Container(
      padding: EdgeInsets.all(20.r),
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
          // Decorative circle
          Positioned(
            top: -15.h,
            right: -15.w,
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
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    randomMotivation['emoji']!,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keep Going!",
                      style: GoogleFonts.baloo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      randomMotivation['text']!,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 24.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
