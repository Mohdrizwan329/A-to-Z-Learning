import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/leaderboard_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  bool _isInitialized = false;

  final LeaderboardService _leaderboardService = Get.find<LeaderboardService>();
  final TextEditingController _friendCodeController = TextEditingController();

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
    _tabController = TabController(length: 3, vsync: this);
    _leaderboardService.refreshLeaderboards();
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
    _tabController.dispose();
    _friendCodeController.dispose();
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
              child: Column(
                children: [
                  // User's current rank card with float animation
                  _buildFloatingCard(index: 0, child: _buildUserRankCard()),

                  // Leaderboard tabs
                  Expanded(
                    child: Obx(() {
                      if (_leaderboardService.isLoading.value) {
                        return Center(
                          // In landscape this sits in a 60pt-tall slot, so the
                          // spinner and its caption shrink to fit rather than
                          // overflowing.
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              SizedBox(height: 16.h),
                              Flexible(
                                child: Text(
                                  'Loading leaderboard...',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLeaderboardList(
                            _leaderboardService.globalLeaderboard,
                            false,
                          ),
                          _buildLeaderboardList(
                            _leaderboardService.weeklyLeaderboard,
                            true,
                          ),
                          _buildFriendsLeaderboard(),
                        ],
                      );
                    }),
                  ),
                ],
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
            Text(
              'Leader',
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
              'board',
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
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.refresh_rounded, color: Colors.white, size: 20.r),
          ),
          onPressed: () => _leaderboardService.refreshLeaderboards(),
        ),
        SizedBox(width: 8.w),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3.r,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
        labelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
        tabs: const [
          Tab(text: 'Global'),
          Tab(text: 'Weekly'),
          Tab(text: 'Friends'),
        ],
      ),
    );
  }

  Widget _buildUserRankCard() {
    return Obx(() {
      final userEntry = _leaderboardService.currentUserEntry.value;
      final userRank = _leaderboardService.userRank.value;
      final tier = userEntry != null
          ? _leaderboardService.getUserTier(userEntry.totalPoints)
          : UserTier.starter;
      final tierInfo = LeaderboardService.tierInfo[tier]!;

      return Container(
        margin: EdgeInsets.all(16.r),
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
            Row(
              children: [
                // Rank badge
                Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: userRank > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '#$userRank',
                                style: GoogleFonts.baloo2(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            '?',
                            style: GoogleFonts.baloo2(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userEntry?.displayName ?? 'Not logged in',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tierInfo.emoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                tierInfo.name,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${userEntry?.totalPoints ?? 0}',
                        style: GoogleFonts.baloo2(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'points',
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
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

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries, bool isWeekly) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text("📊", style: TextStyle(fontSize: 50)),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No entries yet',
              style: GoogleFonts.baloo2(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Complete lessons to earn points!',
              style: GoogleFonts.nunito(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            final offset = index.isEven
                ? _floatAnimation.value * 0.4
                : -_floatAnimation.value * 0.4;
            return Transform.translate(offset: Offset(0, offset), child: child);
          },
          child: _buildLeaderboardItem(entry, isWeekly, index),
        );
      },
    );
  }

  Widget _buildLeaderboardItem(
    LeaderboardEntry entry,
    bool isWeekly,
    int index,
  ) {
    final tier = _leaderboardService.getUserTier(entry.totalPoints);
    final tierInfo = LeaderboardService.tierInfo[tier]!;
    final points = entry.getDisplayPoints(isWeekly);

    final isTop3 = entry.rank <= 3;
    final topGradients = [
      [const Color(0xFFFFD700), const Color(0xFFFFA500)], // Gold
      [const Color(0xFFC0C0C0), const Color(0xFF9E9E9E)], // Silver
      [const Color(0xFFCD7F32), const Color(0xFFB87333)], // Bronze
    ];

    // Use home-style gradients for non-top-3
    final gradient = isTop3
        ? topGradients[entry.rank - 1]
        : cardGradients[index % cardGradients.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                // Rank
                SizedBox(width: 45.w, child: _buildRankBadge(entry.rank)),
                SizedBox(width: 12.w),
                // Avatar
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      tierInfo.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Name and tier
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.displayName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          tierInfo.name,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Points
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$points',
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        isWeekly ? 'this week' : 'total',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Center(child: Text("🥇", style: TextStyle(fontSize: 28))),
      );
    } else if (rank == 2) {
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Center(child: Text("🥈", style: TextStyle(fontSize: 28))),
      );
    } else if (rank == 3) {
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Center(child: Text("🥉", style: TextStyle(fontSize: 28))),
      );
    } else {
      return Container(
        width: 38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$rank',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildFriendsLeaderboard() {
    final friends = _leaderboardService.friendsLeaderboard;

    if (friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text("👥", style: TextStyle(fontSize: 50)),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No friends yet',
              style: GoogleFonts.baloo2(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add friends to compete!',
              style: GoogleFonts.nunito(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 28.h),
            _buildFloatingCard(
              index: 1,
              child: _buildActionButton(
                icon: Icons.person_add_rounded,
                label: 'Add Friend',
                gradient: cardGradients[2], // Green gradient
                onTap: _showAddFriendDialog,
              ),
            ),
            SizedBox(height: 12.h),
            _buildFloatingCard(
              index: 2,
              child: _buildActionButton(
                icon: Icons.share_rounded,
                label: 'Share My Code',
                gradient: cardGradients[6], // Yellow gradient
                onTap: _showShareCodeDialog,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Row(
            children: [
              Expanded(
                child: _buildSmallActionButton(
                  icon: Icons.person_add_rounded,
                  gradient: cardGradients[2], // Green
                  label: 'Add',
                  onTap: _showAddFriendDialog,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSmallActionButton(
                  icon: Icons.share_rounded,
                  gradient: cardGradients[6], // Yellow
                  label: 'Share',
                  onTap: _showShareCodeDialog,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: friends.length,
            itemBuilder: (context, index) {
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
                child: _buildLeaderboardItem(friends[index], false, index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22.r),
            SizedBox(width: 10.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.r),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendDialog() {
    _friendCodeController.clear();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: cardGradients[2]),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Center(
                child: Text("👥", style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Add Friend',
              style: GoogleFonts.baloo2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your friend\'s code to add them:',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _friendCodeController,
              decoration: InputDecoration(
                hintText: 'Friend Code',
                hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.tag_rounded, color: cardGradients[2][0]),
              ),
              textCapitalization: TextCapitalization.characters,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = _friendCodeController.text.trim();
              if (code.isEmpty) return;

              final result = await _leaderboardService.addFriend(code);
              Get.back();
              Get.snackbar(
                result.success ? 'Success!' : 'Error',
                result.message,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: result.success
                    ? cardGradients[2][0]
                    : Colors.red,
                colorText: Colors.white,
                margin: EdgeInsets.all(16.r),
                borderRadius: 14.r,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cardGradients[2][0],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareCodeDialog() async {
    final code = await _leaderboardService.generateFriendCode();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: cardGradients[6]),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Center(
                child: Text("🎫", style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Your Friend Code',
              style: GoogleFonts.baloo2(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share this code with friends:',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cardGradients[6][0].withValues(alpha: 0.2),
                    cardGradients[6][1].withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: cardGradients[6][0], width: 2),
              ),
              child: Center(
                child: Text(
                  code ?? 'Error',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    color: cardGradients[1][0],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: cardGradients[6][0],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
