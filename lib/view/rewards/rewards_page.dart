import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/rewards_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  bool _isInitialized = false;

  RewardsService get rewardsService {
    if (!Get.isRegistered<RewardsService>()) {
      Get.put(RewardsService(), permanent: true);
    }
    return Get.find<RewardsService>();
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
            Column(
              children: [
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats Overview Card with float animation
                          _buildFloatingCard(
                            index: 0,
                            child: _buildStatsCard(),
                          ),

                          SizedBox(height: 20.h),

                          // Streak Card with float animation
                          _buildFloatingCard(
                            index: 1,
                            child: _buildStreakCard(),
                          ),

                          SizedBox(height: 24.h),

                          // Badges Section
                          _buildAnimatedCard(
                            delay: 200,
                            child: _buildSectionTitle("Badges", "🏅"),
                          ),
                          SizedBox(height: 12.h),
                          _buildBadgesGrid(),

                          SizedBox(height: 24.h),

                          // Trophies Section
                          _buildAnimatedCard(
                            delay: 300,
                            child: _buildSectionTitle("Trophies", "🏆"),
                          ),
                          SizedBox(height: 12.h),
                          _buildTrophiesGrid(),

                          SizedBox(height: 24.h),

                          // Stickers Section
                          _buildAnimatedCard(
                            delay: 400,
                            child: _buildSectionTitle(
                              "Sticker Collection",
                              "🎨",
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildStickersSection(),

                          SizedBox(height: 32.h),
                        ],
                      ),
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
            Text(
              'My ',
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
              'Rewards',
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
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.4),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: _buildStatItem(
                        "⭐",
                        "${rewardsService.totalStars.value}",
                        "Stars",
                      ),
                    ),
                    Flexible(
                      child: _buildStatItem(
                        "🏅",
                        "${rewardsService.earnedBadges.length}",
                        "Badges",
                      ),
                    ),
                    Flexible(
                      child: _buildStatItem(
                        "🏆",
                        "${rewardsService.earnedTrophies.length}",
                        "Trophies",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Each half takes an equal share, so the longer label
                      // wraps inside its own column instead of pushing the
                      // row past the card.
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Level ${rewardsService.currentLevel.value}",
                              style: GoogleFonts.baloo2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _getLevelName(rewardsService.currentLevel.value),
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1.w,
                        height: 40.h,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "${rewardsService.totalXP.value} XP",
                              style: GoogleFonts.baloo2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Total Experience",
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                // Level Progress
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Next Level",
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${(rewardsService.levelProgress * 100).toInt()}%",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: LinearProgressIndicator(
                          value: rewardsService.levelProgress,
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
                        "Daily Streak",
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${rewardsService.dailyStreak.value} Days",
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
                        "XP Needed",
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${rewardsService.xpToNextLevel}",
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

  Widget _buildBadgesGrid() {
    return Obx(() {
      final _ = rewardsService.earnedBadges.length;
      final badgesList = RewardsService.badges.entries.toList();
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12.r,
          crossAxisSpacing: 12.r,
          childAspectRatio: 0.85,
        ),
        itemCount: badgesList.length,
        itemBuilder: (context, index) {
          final badgeEntry = badgesList[index];
          final badgeId = badgeEntry.key;
          final badge = badgeEntry.value;
          final isEarned = rewardsService.hasBadge(badgeId);
          final gradient = cardGradients[index % cardGradients.length];

          return AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              final offset = index.isEven
                  ? _floatAnimation.value * 0.5
                  : -_floatAnimation.value * 0.5;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: isEarned
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isEarned ? null : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: isEarned
                    ? [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 10.r,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Decorative circle for earned badges
                  if (isEarned)
                    Positioned(
                      top: -10.h,
                      right: -10.w,
                      child: Container(
                        width: 30.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: isEarned ? 0.3 : 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            badge['icon'] as String,
                            style: TextStyle(
                              fontSize: 28,
                              color: isEarned ? null : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Flexible(
                        child: Text(
                          badge['name'] as String,
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isEarned
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isEarned)
                        Icon(
                          Icons.lock_rounded,
                          size: 14.r,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildTrophiesGrid() {
    return Obx(() {
      final _ = rewardsService.earnedTrophies.length;
      final trophiesList = RewardsService.trophies.entries.toList();
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.r,
          crossAxisSpacing: 12.r,
          childAspectRatio: 1.2,
        ),
        itemCount: trophiesList.length,
        itemBuilder: (context, index) {
          final trophyEntry = trophiesList[index];
          final trophyId = trophyEntry.key;
          final trophy = trophyEntry.value;
          final isEarned = rewardsService.hasTrophy(trophyId);
          final gradient = cardGradients[index % cardGradients.length];

          return AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              final offset = index.isEven
                  ? _floatAnimation.value * 0.6
                  : -_floatAnimation.value * 0.6;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: isEarned
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isEarned ? null : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: isEarned
                    ? [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 12.r,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  if (isEarned)
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: isEarned ? 0.3 : 0.15,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            trophy['icon'] as String,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Capped so a two-word trophy name does not push the
                      // locked-XP row out of the tile.
                      Flexible(
                        child: Text(
                          trophy['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isEarned
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isEarned)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_rounded,
                              size: 14.r,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${trophy['xpReward']} XP",
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildStickersSection() {
    return Obx(() {
      final earnedStickers = rewardsService.earnedStickers.toList();
      final categories = RewardsService.stickerCategories.entries.toList();

      return Column(
        children: List.generate(categories.length, (index) {
          final entry = categories[index];
          final categoryName = entry.key;
          final stickers = entry.value;
          final earnedInCategory = stickers
              .where((s) => earnedStickers.contains(s))
              .toList();

          final gradient = cardGradients[index % cardGradients.length];
          final progress = stickers.isEmpty
              ? 0.0
              : earnedInCategory.length / stickers.length;

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
                    children: [
                      // Header
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Center(
                                child: Text(
                                  stickers.first,
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
                                    categoryName[0].toUpperCase() +
                                        categoryName.substring(1),
                                    style: GoogleFonts.baloo2(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${earnedInCategory.length} / ${stickers.length} collected",
                                    style: GoogleFonts.nunito(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Progress Circle
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 48.w,
                                  height: 48.h,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    strokeWidth: 5.r,
                                  ),
                                ),
                                Text(
                                  "${(progress * 100).toInt()}%",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Stickers Grid
                      Container(
                        margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Wrap(
                          spacing: 8.r,
                          runSpacing: 8.r,
                          children: stickers.map((sticker) {
                            final isEarned = earnedStickers.contains(sticker);
                            return Container(
                              width: 42.w,
                              height: 42.h,
                              decoration: BoxDecoration(
                                color: isEarned
                                    ? gradient[0].withValues(alpha: 0.15)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10.r),
                                border: isEarned
                                    ? Border.all(color: gradient[0], width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: isEarned
                                    ? Text(
                                        sticker,
                                        style: const TextStyle(fontSize: 22),
                                      )
                                    : Icon(
                                        Icons.lock_rounded,
                                        size: 18.r,
                                        color: Colors.grey.shade400,
                                      ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  String _getLevelName(int level) {
    const levelNames = [
      'Beginner',
      'Learner',
      'Student',
      'Scholar',
      'Expert',
      'Master',
      'Champion',
      'Legend',
      'Genius',
      'Prodigy',
      'Virtuoso',
      'Maestro',
      'Sage',
      'Wizard',
      'Grand Master',
      'Supreme',
      'Ultimate',
      'Mythic',
      'Divine',
      'Transcendent',
    ];
    if (level < 1) return levelNames[0];
    if (level > levelNames.length) return levelNames.last;
    return levelNames[level - 1];
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 30)),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
        Expanded(
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
