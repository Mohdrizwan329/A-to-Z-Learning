import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/view%20model/math%20scanner%20controller/math_scanner_controller.dart';

import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/widgets/scan_limit_badge.dart';

class MathScannerPage extends StatefulWidget {
  const MathScannerPage({super.key});

  @override
  State<MathScannerPage> createState() => _MathScannerPageState();
}

class _MathScannerPageState extends State<MathScannerPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(MathScannerController());

  /// The same drift the home grid runs: one 3-second controller shared by
  /// every card, so they rise and fall together rather than each drifting on
  /// its own clock.
  late final AnimationController _floatController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<double> _floatAnimation = Tween<double>(
    begin: -6,
    end: 6,
  ).animate(
    CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  /// Alternating, so neighbouring cards move against each other -- the same
  /// half-amplitude the home grid uses.
  Widget _float(int index, Widget child) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, inner) {
        final offset = index.isEven
            ? _floatAnimation.value * 0.5
            : -_floatAnimation.value * 0.5;
        return Transform.translate(offset: Offset(0, offset), child: inner);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          child: Column(
            children: [
              // Today's remaining scans
              ScanLimitBadge(limit: controller.scanLimit),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingView();
                  }
                  if (controller.hasResult.value) {
                    return _buildResultView();
                  }
                  return _buildEmptyView();
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 8,
      shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
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
              'Math ',
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
              'Solver',
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

  Widget _buildFloatingButtons() {
    // With a solution on screen the FAB would sit on top of the answer and the
    // steps, so it steps aside there -- scan and reset live at the end of the
    // result view instead, where they cannot cover the question.
    //
    // It also goes away once today's budget is spent: the badge above already
    // says why, and a button that only ever answers "come back tomorrow" is
    // worse than no button. It is back on its own the next day, because the
    // badge re-reads the count whenever the screen returns.
    return Obx(() {
      if (controller.hasResult.value) return const SizedBox.shrink();
      if (controller.scanLimit.remaining.value == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF45B7D1).withValues(alpha: 0.4),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          heroTag: "math_scan",
          onPressed: controller.scanMathQuestion,
          backgroundColor: const Color(0xFF45B7D1),
          icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
          label: Text(
            "Scan Question",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 20.r,
                          spreadRadius: 5.r,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3.r,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Text(
            "Solving...",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "AI is solving your math question",
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: Column(
        children: [
          // Main Header Card
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                          blurRadius: 8.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42.w,
                          height: 42.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.calculate_rounded,
                            color: Colors.white,
                            size: 24.r,
                          ),
                        ),
                        SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Math Question Solver",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Scan & get instant solution!",
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
                  ),
                ),
              );
            },
          ),

          SizedBox(height: AppTheme.spacingS),

          // Feature Cards
          ...List.generate(4, (index) {
            final features = [
              {
                'icon': Icons.add_rounded,
                'text': 'Addition',
                'gradient': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
              },
              {
                'icon': Icons.close_rounded,
                'text': 'Multiplication',
                'gradient': [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)],
              },
              {
                'icon': Icons.remove_rounded,
                'text': 'Subtraction',
                'gradient': [const Color(0xFF45B7D1), const Color(0xFF7DD3E8)],
              },
              {
                // No divide glyph in Material Icons, so the card draws a '\u00f7'.
                'glyph': '\u00f7',
                'text': 'Division',
                'gradient': [const Color(0xFF56D97F), const Color(0xFF7BE495)],
              },
            ];
            final feature = features[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 600 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: _float(
                      index,
                      _buildFeatureCard(
                        feature['icon'] as IconData?,
                        feature['glyph'] as String?,
                        feature['text'] as String,
                        feature['gradient'] as List<Color>,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          SizedBox(height: 72.h),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData? icon,
    String? glyph,
    String text,
    List<Color> gradient,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacingS),
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
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
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: icon != null
                ? Icon(icon, color: Colors.white, size: 24.r)
                : Center(
                    child: Text(
                      glyph!,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final solutions = controller.solutions;
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScannedTextCard(solutions.length),
          SizedBox(height: AppTheme.spacingM),

          // One block per question found on the page.
          ...solutions.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(bottom: AppTheme.spacingM),
                  child: _buildSolutionCard(
                    entry.key,
                    entry.value,
                    solutions.length,
                  ),
                ),
              ),

          _buildScanAgainButton(),
          // Nothing floats over this view any more, so no FAB clearance here.
          SizedBox(height: AppTheme.spacingM),
        ],
      ),
    );
  }

  /// The raw OCR text, plus a count chip once the page held more than one
  /// question so it is obvious every one of them was solved.
  Widget _buildScannedTextCard(int total) {
    return _fadeInUp(
      delayMs: 400,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.4),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    total > 1 ? "Scanned Page" : "Question",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (total > 1)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "$total questions",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppTheme.spacingM),
            Text(
              controller.extractedText.value,
              style: GoogleFonts.nunito(
                fontSize: 18,
                color: Colors.white,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Answer + steps for a single question. [index] is zero-based; [total] is
  /// only used to decide whether the "Q1 of 3" header is worth showing.
  Widget _buildSolutionCard(int index, MathSolution solution, int total) {
    return _fadeInUp(
      delayMs: 500 + (index * 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (total > 1) ...[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Q${index + 1} of $total",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF764BA2),
                    ),
                  ),
                ),
                if (solution.question.isNotEmpty) ...[
                  SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      solution.question,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: AppTheme.spacingS),
          ],

          // Answer Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF56D97F), Color(0xFF7BE495)],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF56D97F).withValues(alpha: 0.4),
                  blurRadius: 15.r,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingS),
                    Text(
                      "Answer",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  solution.answer,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Solution Steps Card
          if (solution.steps.isNotEmpty) ...[
            SizedBox(height: AppTheme.spacingM),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFAA5A).withValues(alpha: 0.4),
                    blurRadius: 15.r,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.format_list_numbered_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      Text(
                        "Solution Steps",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacingM),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      solution.steps,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScanAgainButton() {
    return _fadeInUp(
      delayMs: 700,
      offsetY: 20,
      child: Obx(() => Row(
        children: [
          if (controller.scanLimit.remaining.value > 0) ...[
          Expanded(
            child: GestureDetector(
              onTap: controller.scanMathQuestion,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF45B7D1), Color(0xFF7DD3E8)],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF45B7D1).withValues(alpha: 0.4),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 22.r,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        "Scan Another Page",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacingS),
          ],
          // Clears the result without opening the camera -- the job the small
          // reset FAB used to do. This one stays whether or not there are
          // scans left, so a spent budget still leaves a way back.
          GestureDetector(
            onTap: controller.reset,
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 22.r,
              ),
            ),
          ),
        ],
      )),
    );
  }

  /// The slide-up-and-fade the result cards share. Pulled out so the per-card
  /// builders stay readable now that there is one set of them per question.
  Widget _fadeInUp({
    required int delayMs,
    required Widget child,
    double offsetY = 30,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: delayMs),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, offsetY * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
    );
  }
}
