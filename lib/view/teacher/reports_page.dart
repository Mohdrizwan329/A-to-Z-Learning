import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late Animation<double> _floatAnimation;
  late TabController _tabController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,
    ); // Default to Week
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
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
    _tabController.dispose();
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
                Color(0xFFf093fb),
                Color(0xFFf5576c),
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
              Color(0xFFf093fb),
              Color(0xFFf5576c),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            ..._buildFloatingBubbles(),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 56.h), // Space for AppBar with tabs
                  // Report Content
                  Expanded(
                    // Watches the progress counts, so a lesson finished while
                    // this page is open shows up here without reopening it.
                    child: Obx(() {
                      ProgressService.to.completedItems.length;
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildReportContent(),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      centerTitle: true,
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
              'Learning ',
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
              'Report',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 136, 240, 1),
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
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3.r,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
        tabs: const [
          Tab(text: 'Day'),
          Tab(text: 'Week'),
          Tab(text: 'Month'),
          Tab(text: 'Year'),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    switch (_tabController.index) {
      case 0:
        return _buildDayReport();
      case 1:
        return _buildWeekReport();
      case 2:
        return _buildMonthReport();
      case 3:
        return _buildYearReport();
      default:
        return _buildWeekReport();
    }
  }

  // ==================== DAY REPORT ====================
  Widget _buildDayReport() {
    final progressService = ProgressService.to;
    final random = math.Random(DateTime.now().day);
    final todayMinutes = 15 + random.nextInt(45);
    final lessonsToday = 3 + random.nextInt(5);
    final accuracy = 75 + random.nextInt(20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Summary Card
        _buildSummaryCard(
          title: "Today's Summary",
          emoji: '📅',
          date: _formatDate(DateTime.now()),
          stats: [
            {
              'label': 'Time Spent',
              'value': '$todayMinutes min',
              'emoji': '⏱️',
            },
            {'label': 'Lessons', 'value': '$lessonsToday', 'emoji': '📚'},
            {'label': 'Accuracy', 'value': '$accuracy%', 'emoji': '🎯'},
          ],
          gradient: [
            const Color(0xFFFF6B6B),
            const Color(0xFFFF8E53),
            const Color(0xFFFFAA5A),
          ],
        ),
        SizedBox(height: 20.h),

        // Hourly Activity
        _buildSectionTitle('Hourly Activity', '🕐'),
        SizedBox(height: 12.h),
        _buildHourlyChart(),
        SizedBox(height: 20.h),

        // Today's Subjects
        _buildSectionTitle('Subjects Practiced', '📖'),
        SizedBox(height: 12.h),
        _buildSubjectsList(progressService, isDaily: true),
        SizedBox(height: 20.h),

        // Today's Achievements
        _buildSectionTitle('Today\'s Achievements', '🏆'),
        SizedBox(height: 12.h),
        _buildTodayAchievements(),
        SizedBox(height: 20.h),
      ],
    );
  }

  // ==================== WEEK REPORT ====================
  Widget _buildWeekReport() {
    final progressService = ProgressService.to;
    final random = math.Random(42);
    final weekMinutes = 120 + random.nextInt(180);
    final weekLessons = 15 + random.nextInt(20);
    final weekAccuracy = 78 + random.nextInt(18);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weekly Summary Card
        _buildSummaryCard(
          title: 'Weekly Summary',
          emoji: '📆',
          date: _getWeekRange(),
          stats: [
            {'label': 'Total Time', 'value': '$weekMinutes min', 'emoji': '⏱️'},
            {'label': 'Lessons', 'value': '$weekLessons', 'emoji': '📚'},
            {'label': 'Avg Accuracy', 'value': '$weekAccuracy%', 'emoji': '🎯'},
          ],
          gradient: [
            const Color(0xFF667EEA),
            const Color(0xFF764BA2),
            const Color(0xFFF093FB),
            const Color(0xFFF5576C),
          ],
        ),
        SizedBox(height: 20.h),

        // Weekly Progress Chart
        _buildSectionTitle('Daily Progress', '📊'),
        SizedBox(height: 12.h),
        _buildWeeklyChart(),
        SizedBox(height: 20.h),

        // Subject Progress
        _buildSectionTitle('Subject Progress', '📚'),
        SizedBox(height: 12.h),
        _buildSubjectsList(progressService, isDaily: false),
        SizedBox(height: 20.h),

        // Weekly Streak
        _buildStreakCard(days: 7),
        SizedBox(height: 20.h),
      ],
    );
  }

  // ==================== MONTH REPORT ====================
  Widget _buildMonthReport() {
    final progressService = ProgressService.to;
    final random = math.Random(DateTime.now().month);
    final monthMinutes = 480 + random.nextInt(320);
    final monthLessons = 60 + random.nextInt(40);
    final monthAccuracy = 80 + random.nextInt(15);
    final monthHours = (monthMinutes / 60).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Monthly Summary Card
        _buildSummaryCard(
          title: 'Monthly Summary',
          emoji: '🗓️',
          date: _getMonthName(),
          stats: [
            {'label': 'Total Hours', 'value': '$monthHours hrs', 'emoji': '⏱️'},
            {'label': 'Lessons', 'value': '$monthLessons', 'emoji': '📚'},
            {
              'label': 'Avg Accuracy',
              'value': '$monthAccuracy%',
              'emoji': '🎯',
            },
          ],
          gradient: [
            const Color(0xFF764BA2),
            const Color(0xFFf093fb),
            const Color(0xFFf5576c),
          ],
        ),
        SizedBox(height: 20.h),

        // Monthly Calendar View
        _buildSectionTitle('Monthly Activity', '📊'),
        SizedBox(height: 12.h),
        _buildMonthlyCalendar(),
        SizedBox(height: 20.h),

        // Weekly Comparison
        _buildSectionTitle('Weekly Comparison', '📈'),
        SizedBox(height: 12.h),
        _buildWeeklyComparisonChart(),
        SizedBox(height: 20.h),

        // Subject Performance
        _buildSectionTitle('Subject Performance', '📖'),
        SizedBox(height: 12.h),
        _buildSubjectPerformanceCards(progressService),
        SizedBox(height: 20.h),

        // Monthly Achievements
        _buildMonthlyAchievementsCard(),
        SizedBox(height: 20.h),
      ],
    );
  }

  // ==================== YEAR REPORT ====================
  Widget _buildYearReport() {
    final progressService = ProgressService.to;
    final random = math.Random(DateTime.now().year);
    final yearHours = 50 + random.nextInt(100);
    final yearLessons = 300 + random.nextInt(200);
    final yearAccuracy = 82 + random.nextInt(13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Yearly Summary Card
        _buildSummaryCard(
          title: 'Yearly Summary',
          emoji: '📈',
          date: '${DateTime.now().year}',
          stats: [
            {'label': 'Total Hours', 'value': '$yearHours hrs', 'emoji': '⏱️'},
            {'label': 'Lessons', 'value': '$yearLessons', 'emoji': '📚'},
            {'label': 'Avg Accuracy', 'value': '$yearAccuracy%', 'emoji': '🎯'},
          ],
          gradient: [
            const Color(0xFFf093fb),
            const Color(0xFFf5576c),
            const Color(0xFFFF6B6B),
          ],
        ),
        SizedBox(height: 20.h),

        // Monthly Progress Chart
        _buildSectionTitle('Monthly Progress', '📊'),
        SizedBox(height: 12.h),
        _buildYearlyChart(),
        SizedBox(height: 20.h),

        // Subject Mastery
        _buildSectionTitle('Subject Mastery', '🎓'),
        SizedBox(height: 12.h),
        _buildSubjectMasteryCards(progressService),
        SizedBox(height: 20.h),

        // Yearly Milestones
        _buildSectionTitle('Milestones Achieved', '🏆'),
        SizedBox(height: 12.h),
        _buildYearlyMilestones(),
        SizedBox(height: 20.h),

        // Year in Review Card
        _buildYearInReviewCard(yearHours, yearLessons),
        SizedBox(height: 20.h),
      ],
    );
  }

  // ==================== COMMON WIDGETS ====================

  Widget _buildSummaryCard({
    required String title,
    required String emoji,
    required String date,
    required List<Map<String, String>> stats,
    required List<Color> gradient,
  }) {
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
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.5),
              blurRadius: 20.r,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
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
                      Text(
                        date,
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
            SizedBox(height: 20.h),
            Row(
              children: stats.map((stat) {
                return Expanded(
                  child: _buildStatItem(
                    stat['emoji']!,
                    stat['label']!,
                    stat['value']!,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
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
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String emoji) {
    return Row(
      children: [
        Flexible(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
    );
  }

  Widget _buildHourlyChart() {
    final hours = ['9AM', '10AM', '11AM', '12PM', '2PM', '3PM', '4PM', '5PM'];
    final random = math.Random(DateTime.now().hour);
    final activities = List.generate(8, (i) => random.nextInt(30));

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withValues(alpha: 0.4),
            const Color(0xFF764BA2).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(8, (index) {
                final height = (activities[index] * 3.0).clamp(10.0, 100.0);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24.w,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF8E53),
                            Color(0xFFFFAA5A),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFF6B6B,
                            ).withValues(alpha: 0.4),
                            blurRadius: 6.r,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      hours[index],
                      style: GoogleFonts.nunito(
                        fontSize: 9,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final random = math.Random(42);
    final activities = List.generate(7, (i) => 20 + random.nextInt(60));
    final todayIndex = DateTime.now().weekday - 1;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withValues(alpha: 0.4),
            const Color(0xFF764BA2).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Minutes per day',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Total: ${activities.reduce((a, b) => a + b)} min',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 130.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final isToday = index == todayIndex;
                // The bar is a share of the chart's height, not the raw minute
                // count read as pixels: 77 minutes was 77px tall regardless of
                // the screen, which overflowed the chart on a small phone.
                final peak = activities.reduce(math.max);
                final barFactor = peak == 0
                    ? 0.04
                    : (activities[index] / peak).clamp(0.04, 1.0);
                // Equal share of the chart width: seven day columns are wider
                // than the card once the reader turns their font size up.
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          '${activities[index]}',
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Expanded(
                        child: FractionallySizedBox(
                          alignment: Alignment.bottomCenter,
                          heightFactor: barFactor,
                          child: Container(
                            width: 32.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isToday
                                    ? [
                                        const Color(0xFFFF6B6B),
                                        const Color(0xFFFF8E53),
                                      ]
                                    : [
                                        const Color(0xFF4ECDC4),
                                        const Color(0xFF44A08D),
                                      ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: isToday
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF6B6B,
                                        ).withValues(alpha: 0.4),
                                        blurRadius: 8.r,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Flexible(
                        child: Text(
                          days[index],
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isToday
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCalendar() {
    final random = math.Random(DateTime.now().month);
    final daysInMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
    ).day;
    final today = DateTime.now().day;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF764BA2).withValues(alpha: 0.4),
            const Color(0xFFf093fb).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF764BA2).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 4.r,
              mainAxisSpacing: 4.r,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = index + 1;
              final hasActivity = random.nextBool() && day <= today;
              final isToday = day == today;
              final intensity = hasActivity ? random.nextInt(3) + 1 : 0;

              return Container(
                decoration: BoxDecoration(
                  color: isToday
                      ? const Color(0xFFFF6B6B)
                      : hasActivity
                      ? Color.lerp(
                          Colors.white.withValues(alpha: 0.1),
                          const Color(0xFF4ECDC4),
                          intensity / 3,
                        )
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6.r),
                  border: isToday
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: day > today
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                'No activity',
                Colors.white.withValues(alpha: 0.1),
              ),
              SizedBox(width: 12.w),
              _buildLegendItem(
                'Low',
                const Color(0xFF4ECDC4).withValues(alpha: 0.4),
              ),
              SizedBox(width: 12.w),
              _buildLegendItem('High', const Color(0xFF4ECDC4)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyComparisonChart() {
    final weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    final random = math.Random(DateTime.now().month);
    final minutes = List.generate(4, (i) => 100 + random.nextInt(150));
    final currentWeek = ((DateTime.now().day - 1) / 7).floor();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFf093fb).withValues(alpha: 0.4),
            const Color(0xFFf5576c).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf093fb).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: List.generate(4, (index) {
          final isCurrent = index == currentWeek;
          final percentage = (minutes[index] / 250 * 100).clamp(0, 100);

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      weeks[index],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${minutes[index]} min',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 10.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCurrent
                          ? const Color(0xFFFF6B6B)
                          : const Color(0xFF4ECDC4),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildYearlyChart() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final random = math.Random(DateTime.now().year);
    final currentMonth = DateTime.now().month - 1;
    final hours = List.generate(
      12,
      (i) => i <= currentMonth ? 5 + random.nextInt(15) : 0,
    );

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFf5576c).withValues(alpha: 0.4),
            const Color(0xFFFF6B6B).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf5576c).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hours per month',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Total: ${hours.reduce((a, b) => a + b)} hrs',
                  style: GoogleFonts.nunito(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 140.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final isCurrent = index == currentMonth;
                // A share of the chart height rather than a fixed 100px
                // ceiling, which was taller than the chart on a small phone.
                final peak = hours.reduce(math.max);
                final barFactor = peak == 0
                    ? 0.05
                    : (hours[index] / peak).clamp(0.05, 1.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (hours[index] > 0)
                      Text(
                        '${hours[index]}',
                        style: GoogleFonts.nunito(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: FractionallySizedBox(
                        alignment: Alignment.bottomCenter,
                        heightFactor: barFactor,
                        child: Container(
                          width: 20.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCurrent
                                  ? [
                                      const Color(0xFFFF6B6B),
                                      const Color(0xFFFF8E53),
                                    ]
                                  : index <= currentMonth
                                  ? [
                                      const Color(0xFFA78BFA),
                                      const Color(0xFF8B5CF6),
                                    ]
                                  : [
                                      Colors.white.withValues(alpha: 0.1),
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      months[index].substring(0, 1),
                      style: GoogleFonts.nunito(
                        fontSize: 9,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isCurrent
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList(
    ProgressService progressService, {
    required bool isDaily,
  }) {
    final subjects = [
      {
        'name': 'Numbers',
        'emoji': '🔢',
        'key': ProgressService.kNumbers,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'name': 'Letters',
        'emoji': '🔤',
        'key': ProgressService.kCapitalLetters,
        'color': const Color(0xFF4ECDC4),
      },
      {
        'name': 'Hindi',
        'emoji': '🇮🇳',
        'key': ProgressService.kHindiLetters,
        'color': const Color(0xFFA78BFA),
      },
      {
        'name': 'Tables',
        'emoji': '✖️',
        'key': ProgressService.kTables,
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF764BA2).withValues(alpha: 0.4),
            const Color(0xFFf093fb).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF764BA2).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: subjects.map((subject) {
          final random = math.Random(
            subject['name'].hashCode + (isDaily ? DateTime.now().day : 0),
          );
          final practiced = isDaily ? random.nextInt(10) : random.nextInt(30);
          final minutes = isDaily ? random.nextInt(15) : random.nextInt(45);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: (subject['color'] as Color).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      subject['emoji'] as String,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject['name'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$practiced items • $minutes min',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: (subject['color'] as Color),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    practiced > 5 ? '🔥' : '📖',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectPerformanceCards(ProgressService progressService) {
    final subjects = [
      {
        'name': 'Numbers',
        'emoji': '🔢',
        'key': ProgressService.kNumbers,
        'total': 100,
        'gradient': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      },
      {
        'name': 'Capital Letters',
        'emoji': '🅰️',
        'key': ProgressService.kCapitalLetters,
        'total': 26,
        'gradient': [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      },
      {
        'name': 'Small Letters',
        'emoji': '🔤',
        'key': ProgressService.kSmallLetters,
        'total': 26,
        'gradient': [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
      },
      {
        'name': 'Hindi Letters',
        'emoji': '🇮🇳',
        'key': ProgressService.kHindiLetters,
        'total': 49,
        'gradient': [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
      },
    ];

    return Column(
      children: subjects.map((subject) {
        final completed = progressService.getCompletedCount(
          subject['key'] as String,
        );
        final total = subject['total'] as int;
        final progress = (completed / total * 100).clamp(0, 100);
        final gradient = subject['gradient'] as List<Color>;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradient[0].withValues(alpha: 0.4),
                gradient[1].withValues(alpha: 0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.3),
                blurRadius: 8.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    subject['emoji'] as String,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['name'] as String,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 8.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(gradient[0]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '${progress.toInt()}%',
                style: GoogleFonts.baloo2(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectMasteryCards(ProgressService progressService) {
    final subjects = [
      {
        'name': 'Numbers',
        'emoji': '🔢',
        'key': ProgressService.kNumbers,
        'total': 100,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'name': 'Letters',
        'emoji': '🔤',
        'key': ProgressService.kCapitalLetters,
        'total': 26,
        'color': const Color(0xFF4ECDC4),
      },
      {
        'name': 'Hindi',
        'emoji': '🇮🇳',
        'key': ProgressService.kHindiLetters,
        'total': 49,
        'color': const Color(0xFFA78BFA),
      },
      {
        'name': 'Tables',
        'emoji': '✖️',
        'key': ProgressService.kTables,
        'total': 20,
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Row(
      children: subjects.map((subject) {
        final completed = progressService.getCompletedCount(
          subject['key'] as String,
        );
        final total = subject['total'] as int;
        final progress = (completed / total * 100).clamp(0, 100);
        final color = subject['color'] as Color;

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                Text(
                  subject['emoji'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress / 100,
                        strokeWidth: 5.r,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                      Text(
                        '${progress.toInt()}%',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subject['name'] as String,
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodayAchievements() {
    final achievements = [
      {'emoji': '⭐', 'title': 'First Star!', 'desc': 'Started learning today'},
      {'emoji': '🎯', 'title': 'On Target', 'desc': '5 correct answers'},
    ];

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFf5576c).withValues(alpha: 0.4),
            const Color(0xFFFF6B6B).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf5576c).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: achievements.map((a) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Text(a['emoji']!, style: const TextStyle(fontSize: 24)),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['title']!,
                      style: GoogleFonts.baloo2(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      a['desc']!,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthlyAchievementsCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: const Text('🏆', style: TextStyle(fontSize: 32)),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Achievements',
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '12 badges earned • 3 certificates',
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

  Widget _buildYearlyMilestones() {
    final milestones = [
      {'emoji': '🔢', 'title': 'Number Master', 'achieved': true},
      {'emoji': '🔤', 'title': 'Alphabet Pro', 'achieved': true},
      {'emoji': '🇮🇳', 'title': 'Hindi Expert', 'achieved': false},
      {'emoji': '✖️', 'title': 'Table Champion', 'achieved': false},
    ];

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withValues(alpha: 0.4),
            const Color(0xFF764BA2).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: milestones.map((m) {
          final achieved = m['achieved'] as bool;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: achieved
                        ? const Color(0xFF4ECDC4).withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      m['emoji'] as String,
                      style: TextStyle(
                        fontSize: 20,
                        color: achieved
                            ? null
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    m['title'] as String,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: achieved
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Icon(
                  achieved ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: achieved
                      ? const Color(0xFF4ECDC4)
                      : Colors.white.withValues(alpha: 0.3),
                  size: 24.r,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildYearInReviewCard(int hours, int lessons) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
            Color(0xFFF093FB),
            Color(0xFFF5576C),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.4),
            blurRadius: 16.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 40)),
          SizedBox(height: 12.h),
          Text(
            'Year in Review',
            style: GoogleFonts.baloo2(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You spent $hours hours learning\nand completed $lessons lessons!',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              '⭐ Keep up the great work! ⭐',
              style: GoogleFonts.baloo2(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard({required int days}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf5576c), Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf5576c).withValues(alpha: 0.4),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 36)),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$days Day Streak!',
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Keep learning every day!',
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

  // Helper methods
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getWeekRange() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${startOfWeek.day} - ${endOfWeek.day} ${_getMonthName()}';
  }

  String _getMonthName() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[DateTime.now().month - 1]} ${DateTime.now().year}';
  }

  List<Widget> _buildFloatingBubbles() {
    final random = math.Random(42);
    return List.generate(12, (index) {
      final size = 20.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 180;
          final opacity = (1 - progress) * 0.12;

          return Positioned(
            left: left,
            top: top + yOffset,
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
}
