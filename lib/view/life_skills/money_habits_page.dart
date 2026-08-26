import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_card.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class MoneyHabitsPage extends StatefulWidget {
  const MoneyHabitsPage({super.key});

  @override
  State<MoneyHabitsPage> createState() => _MoneyHabitsPageState();
}

class _MoneyHabitsPageState extends State<MoneyHabitsPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  final ProgressService _progress = ProgressService.to;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Money?',
      'icon': Icons.payments,
      'desc': 'Coins, notes & digital money',
    },
    {
      'title': 'Needs vs Wants',
      'icon': Icons.compare_arrows,
      'desc': 'Must-haves vs nice-to-haves',
    },
    {
      'title': 'Saving Money',
      'icon': Icons.savings,
      'desc': 'Why & how to save',
    },
    {
      'title': 'Earning Money',
      'icon': Icons.work,
      'desc': 'How money is earned',
    },
    {
      'title': 'Spending Wisely',
      'icon': Icons.shopping_cart,
      'desc': 'Think before you buy',
    },
    {
      'title': 'Making a Budget',
      'icon': Icons.pie_chart,
      'desc': 'Plan for your money',
    },
    {
      'title': 'Sharing & Giving',
      'icon': Icons.volunteer_activism,
      'desc': 'Help others with money',
    },
    {
      'title': 'Money Safety',
      'icon': Icons.lock,
      'desc': 'Keep your money safe',
    },
  ];

  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Money Habits',
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
            _progress.resetProgress(ProgressService.kMoneyHabits);
            setState(() {});
          },
        ),
      ],
      body: Stack(
        children: [
          ...List.generate(8, (i) {
            final top = (i * 67.0) % MediaQuery.of(context).size.height;
            final left = (i * 83.0) % MediaQuery.of(context).size.width;
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                final value = _bubbleController.value;
                final offset =
                    20.0 *
                    ((value * 2 * 3.14159).clamp(0, 6.28) != 0
                        ? (value * 2 * 3.14159).abs() % 1
                        : 0);
                return Positioned(
                  top: top + offset,
                  left: left,
                  child: Container(
                    width: 20.w + (i % 3) * 15.0,
                    height: 20.h + (i % 3) * 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          Column(
            children: [
              Obx(() {
                final progress =
                    _progress.getProgressPercentage(
                      ProgressService.kMoneyHabits,
                    ) /
                    100;
                final progressString = _progress.getProgressString(
                  ProgressService.kMoneyHabits,
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
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 14.r,
                    mainAxisSpacing: 14.r,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final gradientColors = AppColors.getGradientForIndex(index);
                    return buildFloatingItem(
                      index: index,
                      child: Obx(() {
                        final isCompleted = _progress.isItemCompleted(
                          ProgressService.kMoneyHabits,
                          index,
                        );
                        return GradientCard(
                          gradient: gradientColors,
                          onTap: () async {
                            TtsService.to.speak(section['title']);
                            await Get.to(
                              () => _MoneyHabitsDetailPage(
                                sectionIndex: index,
                                title: section['title'],
                              ),
                            );
                            if (!_progress.isItemCompleted(
                              ProgressService.kMoneyHabits,
                              index,
                            )) {
                              await _progress.markItemCompleted(
                                ProgressService.kMoneyHabits,
                                index,
                              );
                            }
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              if (isCompleted)
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.r,
                                    ),
                                  ),
                                ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      section['icon'],
                                      size: 48.r,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      section['title'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 4.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: Text(
                                        section['desc'],
                                        style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Detail Page ───────────────────────────────────────────────────────────────

class _MoneyHabitsDetailPage extends StatefulWidget {
  final int sectionIndex;
  final String title;

  const _MoneyHabitsDetailPage({
    required this.sectionIndex,
    required this.title,
  });

  @override
  State<_MoneyHabitsDetailPage> createState() => _MoneyHabitsDetailPageState();
}

class _MoneyHabitsDetailPageState extends State<_MoneyHabitsDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.title,
      body: Stack(
        children: [
          ...List.generate(8, (i) {
            final top = (i * 67.0) % MediaQuery.of(context).size.height;
            final left = (i * 83.0) % MediaQuery.of(context).size.width;
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                final value = _bubbleController.value;
                final offset =
                    20.0 *
                    ((value * 2 * 3.14159).clamp(0, 6.28) != 0
                        ? (value * 2 * 3.14159).abs() % 1
                        : 0);
                return Positioned(
                  top: top + offset,
                  left: left,
                  child: Container(
                    width: 20.w + (i % 3) * 15.0,
                    height: 20.h + (i % 3) * 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.sectionIndex) {
      case 0:
        return _buildWhatIsMoney();
      case 1:
        return _buildNeedsVsWants();
      case 2:
        return _buildSaving();
      case 3:
        return _buildEarning();
      case 4:
        return _buildSpending();
      case 5:
        return _buildBudget();
      case 6:
        return _buildSharing();
      case 7:
        return _buildMoneySafety();
      default:
        return const SizedBox();
    }
  }

  // ── Section 0: What is Money? ─────────────────────────────────────────────

  Widget _buildWhatIsMoney() {
    final types = [
      {
        'type': 'Coins',
        'icon': Icons.monetization_on,
        'examples': '1, 2, 5, 10',
      },
      {
        'type': 'Notes',
        'icon': Icons.money,
        'examples': '10, 20, 50, 100, 500',
      },
      {
        'type': 'Digital Money',
        'icon': Icons.phone_android,
        'examples': 'UPI, Cards',
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'What is Money?',
          'Money is what we use to buy things we need and want!',
          Icons.payments,
          0,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Types of Money'),
        SizedBox(height: 10.h),
        ...types.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(t['icon'] as IconData, color: Colors.white, size: 36.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t['type'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Examples: ${t['examples']}',
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 16.h),
        _buildTipCard(
          'Fun Fact',
          'Long ago, people traded things like shells, beads, and animals instead of money!',
          Icons.lightbulb,
          Colors.amber.shade700,
        ),
      ],
    );
  }

  // ── Section 1: Needs vs Wants ─────────────────────────────────────────────

  Widget _buildNeedsVsWants() {
    final needs = [
      {
        'item': 'Food',
        'icon': Icons.restaurant,
        'why': 'We need food to stay alive and healthy',
      },
      {
        'item': 'Clothes',
        'icon': Icons.checkroom,
        'why': 'We need clothes to stay warm',
      },
      {'item': 'Home', 'icon': Icons.home, 'why': 'We need shelter to be safe'},
      {
        'item': 'School',
        'icon': Icons.school,
        'why': 'We need education to learn',
      },
      {
        'item': 'Medicine',
        'icon': Icons.local_pharmacy,
        'why': 'We need medicine when sick',
      },
    ];

    final wants = [
      {
        'item': 'Toys',
        'icon': Icons.smart_toy,
        'why': 'Nice to have, but not essential',
      },
      {
        'item': 'Video Games',
        'icon': Icons.sports_esports,
        'why': 'Fun, but we can live without',
      },
      {'item': 'Candy', 'icon': Icons.cake, 'why': 'Tasty, but not necessary'},
      {
        'item': 'Latest Phone',
        'icon': Icons.phone_iphone,
        'why': 'Older phone works too',
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Needs vs Wants',
          'Understanding the difference helps you spend wisely!',
          Icons.compare_arrows,
          1,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('NEEDS (Must Have)'),
        SizedBox(height: 10.h),
        ...needs.asMap().entries.map((entry) {
          final i = entry.key;
          final n = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(n['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n['item'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          n['why'] as String,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('WANTS (Nice to Have)'),
        SizedBox(height: 10.h),
        ...wants.asMap().entries.map((entry) {
          final i = entry.key;
          final w = entry.value;
          final colors = AppColors.getGradientForIndex(i + 5);
          return buildFloatingItem(
            index: (i + 5) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(w['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w['item'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          w['why'] as String,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 16.h),
        _buildTipCard(
          'Remember',
          'Always make sure needs are met before buying wants!',
          Icons.tips_and_updates,
          Colors.blue,
        ),
      ],
    );
  }

  // ── Section 2: Saving Money ───────────────────────────────────────────────

  Widget _buildSaving() {
    final whySave = [
      {'reason': 'For something special you want', 'icon': Icons.star},
      {'reason': 'For emergencies', 'icon': Icons.emergency},
      {'reason': 'To help others', 'icon': Icons.handshake},
      {'reason': 'For your future', 'icon': Icons.auto_awesome},
    ];

    final howToSave = [
      {'tip': 'Use a piggy bank', 'icon': Icons.savings},
      {'tip': 'Save a little from pocket money', 'icon': Icons.money},
      {'tip': 'Set a savings goal', 'icon': Icons.flag},
      {'tip': 'Don\'t buy things you don\'t need', 'icon': Icons.block},
      {'tip': 'Count your savings weekly', 'icon': Icons.calculate},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Saving Money',
          'Saving helps you buy bigger things later!',
          Icons.savings,
          2,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Why Save?'),
        SizedBox(height: 10.h),
        ...whySave.asMap().entries.map((entry) {
          final i = entry.key;
          final w = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(w['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      w['reason'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('How to Save'),
        SizedBox(height: 10.h),
        ...howToSave.asMap().entries.map((entry) {
          final i = entry.key;
          final h = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(h['icon'] as IconData, color: Colors.white, size: 26.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      h['tip'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 16.h),
        _buildTipCard(
          'Savings Goal',
          'Want a 500 toy? Save 50 per week = 10 weeks!',
          Icons.calendar_month,
          Colors.pink,
        ),
      ],
    );
  }

  // ── Section 3: Earning Money ──────────────────────────────────────────────

  Widget _buildEarning() {
    final howParentsEarn = [
      {'job': 'Go to work', 'icon': Icons.business_center},
      {'job': 'Run a business', 'icon': Icons.store},
      {'job': 'Provide services', 'icon': Icons.build},
      {'job': 'Sell things', 'icon': Icons.shopping_bag},
    ];

    final howKidsCanEarn = [
      {'task': 'Do extra chores', 'icon': Icons.cleaning_services},
      {'task': 'Help with garden work', 'icon': Icons.yard},
      {'task': 'Wash the car', 'icon': Icons.local_car_wash},
      {'task': 'Walk neighbor\'s dog', 'icon': Icons.pets},
      {'task': 'Sell lemonade', 'icon': Icons.local_drink},
      {'task': 'Help with small tasks', 'icon': Icons.pan_tool},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Earning Money',
          'Money doesn\'t grow on trees! Here\'s how it\'s earned:',
          Icons.work,
          3,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('How Parents Earn'),
        SizedBox(height: 10.h),
        ...howParentsEarn.asMap().entries.map((entry) {
          final i = entry.key;
          final j = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(j['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      j['job'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('How Kids Can Earn'),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 12.r,
            mainAxisSpacing: 12.r,
          ),
          itemCount: howKidsCanEarn.length,
          itemBuilder: (context, i) {
            final t = howKidsCanEarn[i];
            final colors = AppColors.getGradientForIndex(i + 4);
            return buildFloatingItem(
              index: (i + 4) % 8,
              child: Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colors[0], colors[1]]),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors[0].withValues(alpha: 0.3),
                      blurRadius: 6.r,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      t['icon'] as IconData,
                      color: Colors.white,
                      size: 30.r,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      t['task'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16.h),
        _buildTipCard(
          'Remember',
          'Working hard and being responsible earns money!',
          Icons.emoji_events,
          Colors.orange,
        ),
      ],
    );
  }

  // ── Section 4: Spending Wisely ────────────────────────────────────────────

  Widget _buildSpending() {
    final questions = [
      {'q': 'Do I really need this?', 'icon': Icons.help_outline},
      {'q': 'Can I afford it?', 'icon': Icons.account_balance_wallet},
      {'q': 'Is it worth the price?', 'icon': Icons.balance},
      {'q': 'Will I use it often?', 'icon': Icons.bar_chart},
      {'q': 'Can I wait and save?', 'icon': Icons.hourglass_bottom},
    ];

    final smartShopping = [
      {'tip': 'Compare prices', 'icon': Icons.search},
      {'tip': 'Look for sales', 'icon': Icons.local_offer},
      {'tip': 'Don\'t buy just because friends have it', 'icon': Icons.groups},
      {'tip': 'Make a shopping list', 'icon': Icons.list_alt},
      {'tip': 'Stick to your budget', 'icon': Icons.thumb_up},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Spending Wisely',
          'Think before you buy!',
          Icons.shopping_cart,
          4,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Ask Yourself'),
        SizedBox(height: 10.h),
        ...questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(q['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      q['q'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('Smart Shopping Tips'),
        SizedBox(height: 10.h),
        ...smartShopping.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final colors = AppColors.getGradientForIndex(i + 5);
          return buildFloatingItem(
            index: (i + 5) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(s['icon'] as IconData, color: Colors.white, size: 26.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      s['tip'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 5: Making a Budget ────────────────────────────────────────────

  Widget _buildBudget() {
    final parts = [
      {
        'part': 'Money In',
        'icon': Icons.arrow_downward,
        'desc': 'How much you get',
        'color': Colors.green,
      },
      {
        'part': 'Money Out',
        'icon': Icons.arrow_upward,
        'desc': 'How much you spend',
        'color': Colors.orange,
      },
      {
        'part': 'Savings',
        'icon': Icons.savings,
        'desc': 'What\'s left to save',
        'color': Colors.pink,
      },
    ];

    final spendItems = [
      {'item': 'Snacks', 'amount': '30'},
      {'item': 'School supplies', 'amount': '20'},
      {'item': 'Fun', 'amount': '20'},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Making a Budget',
          'A budget is a plan for your money!',
          Icons.pie_chart,
          5,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Parts of a Budget'),
        SizedBox(height: 10.h),
        Row(
          children: parts.map<Widget>((p) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: (p['color'] as Color).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: (p['color'] as Color).withValues(alpha: 0.4),
                      blurRadius: 6.r,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      p['icon'] as IconData,
                      color: Colors.white,
                      size: 30.r,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      p['part'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      p['desc'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20.h),
        _buildSectionLabel('Weekly Pocket Money Budget'),
        SizedBox(height: 10.h),
        buildFloatingItem(
          index: 0,
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getGradientForIndex(5),
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getGradientForIndex(
                    5,
                  )[0].withValues(alpha: 0.3),
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                        size: 22.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Income: 100 pocket money',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                ...spendItems.map((item) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 6.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['item']!,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                        Text(
                          item['amount']!,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.savings, color: Colors.white, size: 22.r),
                      SizedBox(width: 8.w),
                      Text(
                        'Save: 30 in piggy bank',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _buildTipCard(
          'Golden Rule',
          'The 50-30-20 Rule: 50% needs, 30% wants, 20% savings!',
          Icons.star,
          Colors.amber.shade700,
        ),
      ],
    );
  }

  // ── Section 6: Sharing & Giving ───────────────────────────────────────────

  Widget _buildSharing() {
    final ways = [
      {
        'way': 'Donate to charity',
        'icon': Icons.card_giftcard,
        'example': 'Help people in need',
      },
      {
        'way': 'Buy gifts for family',
        'icon': Icons.cake,
        'example': 'Birthday presents',
      },
      {
        'way': 'Help a friend',
        'icon': Icons.people,
        'example': 'Share school supplies',
      },
      {
        'way': 'Support a cause',
        'icon': Icons.public,
        'example': 'Plant trees, save animals',
      },
    ];

    final benefits = [
      {
        'benefit': 'Makes you feel happy',
        'icon': Icons.sentiment_very_satisfied,
      },
      {'benefit': 'Helps people who need it', 'icon': Icons.favorite},
      {'benefit': 'Creates kindness', 'icon': Icons.diversity_1},
      {'benefit': 'Teaches gratitude', 'icon': Icons.volunteer_activism},
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Sharing & Giving',
          'Using money to help others is wonderful!',
          Icons.volunteer_activism,
          6,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Ways to Give'),
        SizedBox(height: 10.h),
        ...ways.asMap().entries.map((entry) {
          final i = entry.key;
          final w = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(w['icon'] as IconData, color: Colors.white, size: 32.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w['way'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          w['example'] as String,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('Benefits of Giving'),
        SizedBox(height: 10.h),
        ...benefits.asMap().entries.map((entry) {
          final i = entry.key;
          final b = entry.value;
          final colors = AppColors.getGradientForIndex(i + 4);
          return buildFloatingItem(
            index: (i + 4) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(b['icon'] as IconData, color: Colors.white, size: 26.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      b['benefit'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 7: Money Safety ───────────────────────────────────────────────

  Widget _buildMoneySafety() {
    final rules = [
      {'rule': 'Keep money in a safe place', 'icon': Icons.account_balance},
      {'rule': 'Don\'t show money in public', 'icon': Icons.visibility_off},
      {'rule': 'Count your change', 'icon': Icons.calculate},
      {'rule': 'Tell parents if you find money', 'icon': Icons.family_restroom},
      {'rule': 'Never share bank passwords', 'icon': Icons.lock},
      {'rule': 'Beware of scams', 'icon': Icons.warning},
    ];

    final scamWarnings = [
      {'warning': 'Nobody gives free money', 'icon': Icons.money_off},
      {
        'warning': 'Don\'t share personal info online',
        'icon': Icons.privacy_tip,
      },
      {
        'warning': 'If it sounds too good, it probably is',
        'icon': Icons.report_problem,
      },
    ];

    return Column(
      children: [
        _buildHeaderCard(
          'Money Safety',
          'Keep your money safe!',
          Icons.lock,
          7,
        ),
        SizedBox(height: 16.h),
        _buildSectionLabel('Safety Rules'),
        SizedBox(height: 10.h),
        ...rules.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          final colors = AppColors.getGradientForIndex(i);
          return buildFloatingItem(
            index: i % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(r['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      r['rule'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        _buildSectionLabel('Scam Warnings'),
        SizedBox(height: 10.h),
        ...scamWarnings.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          return buildFloatingItem(
            index: (i + 6) % 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade700],
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(s['icon'] as IconData, color: Colors.white, size: 28.r),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      s['warning'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Shared Helpers ────────────────────────────────────────────────────────

  Widget _buildHeaderCard(
    String title,
    String subtitle,
    IconData icon,
    int colorIndex,
  ) {
    final colors = AppColors.getGradientForIndex(colorIndex);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colors[0], colors[1]]),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.4),
            blurRadius: 16.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 56.r, color: Colors.white),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.8), color]),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  text,
                  style: GoogleFonts.nunito(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
