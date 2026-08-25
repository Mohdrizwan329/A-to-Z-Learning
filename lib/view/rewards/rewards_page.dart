import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/rewards_service.dart';

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
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
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
              colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
              stops: [0.0, 0.3, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats Overview Card with float animation
                          _buildFloatingCard(
                            index: 0,
                            child: _buildStatsCard(),
                          ),

                          const SizedBox(height: 20),

                          // Streak Card with float animation
                          _buildFloatingCard(
                            index: 1,
                            child: _buildStreakCard(),
                          ),

                          const SizedBox(height: 24),

                          // Badges Section
                          _buildAnimatedCard(
                            delay: 200,
                            child: _buildSectionTitle("Badges", "🏅"),
                          ),
                          const SizedBox(height: 12),
                          _buildBadgesGrid(),

                          const SizedBox(height: 24),

                          // Trophies Section
                          _buildAnimatedCard(
                            delay: 300,
                            child: _buildSectionTitle("Trophies", "🏆"),
                          ),
                          const SizedBox(height: 12),
                          _buildTrophiesGrid(),

                          const SizedBox(height: 24),

                          // Stickers Section
                          _buildAnimatedCard(
                            delay: 400,
                            child: _buildSectionTitle("Sticker Collection", "🎨"),
                          ),
                          const SizedBox(height: 12),
                          _buildStickersSection(),

                          const SizedBox(height: 32),
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
          final top = startTop - (progress * MediaQuery.of(context).size.height * 0.5);
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
        final offset = index.isEven ? _floatAnimation.value : -_floatAnimation.value;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
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
          boxShadow: [
            BoxShadow(
              color: Color(0x40FF6B6B),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Row(
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
                  blurRadius: 4,
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
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
        ],
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
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
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
                      _buildStatItem(
                        "⭐",
                        "${rewardsService.totalStars.value}",
                        "Stars",
                      ),
                      _buildStatItem(
                        "🏅",
                        "${rewardsService.earnedBadges.length}",
                        "Badges",
                      ),
                      _buildStatItem(
                        "🏆",
                        "${rewardsService.earnedTrophies.length}",
                        "Trophies",
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
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
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        Column(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
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
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: rewardsService.levelProgress,
                            backgroundColor: Colors.transparent,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildStreakCard() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: cardGradients[0], // Coral Red gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: cardGradients[0][0].withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text("🔥", style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
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
        ));
  }

  Widget _buildBadgesGrid() {
    return Obx(() {
      final _ = rewardsService.earnedBadges.length;
      final badgesList = RewardsService.badges.entries.toList();
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
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
              final offset = index.isEven ? _floatAnimation.value * 0.5 : -_floatAnimation.value * 0.5;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isEarned
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isEarned ? null : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
                boxShadow: isEarned
                    ? [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 10,
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
                      top: -10,
                      right: -10,
                      child: Container(
                        width: 30,
                        height: 30,
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
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: isEarned ? 0.3 : 0.1),
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
                      const SizedBox(height: 4),
                      Text(
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
                      if (!isEarned)
                        Icon(
                          Icons.lock_rounded,
                          size: 14,
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
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
              final offset = index.isEven ? _floatAnimation.value * 0.6 : -_floatAnimation.value * 0.6;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isEarned
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isEarned ? null : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(22),
                boxShadow: isEarned
                    ? [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 12,
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
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 50,
                        height: 50,
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: isEarned ? 0.3 : 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            trophy['icon'] as String,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        trophy['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isEarned
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!isEarned)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
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
          final earnedInCategory = stickers.where(
            (s) => earnedStickers.contains(s),
          ).toList();

          final gradient = cardGradients[index % cardGradients.length];
          final progress = stickers.isEmpty ? 0.0 : earnedInCategory.length / stickers.length;

          return AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              final offset = index.isEven ? _floatAnimation.value * 0.4 : -_floatAnimation.value * 0.4;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 70,
                      height: 70,
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
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  stickers.first,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
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
                                      color: Colors.white.withValues(alpha: 0.9),
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
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 5,
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
                        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: stickers.map((sticker) {
                            final isEarned = earnedStickers.contains(sticker);
                            return Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isEarned
                                    ? gradient[0].withValues(alpha: 0.15)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
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
                                        size: 18,
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
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 30)),
          ),
        ),
        const SizedBox(height: 8),
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
