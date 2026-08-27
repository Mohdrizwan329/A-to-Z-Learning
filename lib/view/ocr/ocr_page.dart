import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/res/utils/size_config.dart';
import 'package:jiyan_learning/view%20model/ocr%20controller/ocr_controller.dart';

import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/widgets/scan_limit_badge.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(OcrController());

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

  // Gradient colors for question cards
  static const List<List<Color>> _cardGradients = [
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFF45B7D1), Color(0xFF7DD3E8)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
    [Color(0xFF56D97F), Color(0xFF7BE495)],
    [Color(0xFFEC407A), Color(0xFFF48FB1)],
  ];

  List<Color> _getGradient(int index) {
    return _cardGradients[index % _cardGradients.length];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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

              // Main Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingView();
                  }
                  if (controller.mcqQuestions.isNotEmpty) {
                    return _buildQuestionsListView();
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
              'MCQ ',
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
              'Scanner',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFE66D), // Yellow like "Learning"
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
    // With questions on screen the FAB would sit on top of the last card's
    // options, so it steps aside there -- scan and clear live at the end of
    // the list instead, where they cannot cover a question.
    //
    // It also goes away once today's budget is spent: the badge above already
    // says why, and a button that only ever answers "come back tomorrow" is
    // worse than no button. It is back on its own the next day, because the
    // badge re-reads the count whenever the screen returns.
    return Obx(() {
      if (controller.mcqQuestions.isNotEmpty) return const SizedBox.shrink();
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
          heroTag: "scan",
          onPressed: controller.scanQuestion,
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

  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Icon(Icons.delete_rounded, color: Color(0xFFFF6B6B)),
            ),
            SizedBox(width: 12.w),
            Text(
              "Clear All?",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "This will delete all scanned questions.",
          style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFAA5A),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextButton(
              onPressed: () {
                controller.clearAllQuestions();
                Get.back();
              },
              child: Text(
                "Clear",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
            "Creating MCQ...",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "AI is converting your question",
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
          // Main Empty State Card
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
                          child: const Center(
                            child: Text("📷", style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Scan Any Question",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Hindi, English, Science, Math, GK",
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

          // Features List
          ...List.generate(4, (index) {
            final features = [
              {
                'icon': Icons.camera_alt_rounded,
                'text': 'Scan any question from camera',
                'gradient': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
              },
              {
                'icon': Icons.quiz_rounded,
                'text': 'AI converts to MCQ format',
                'gradient': [const Color(0xFFA78BFA), const Color(0xFFC4B5FD)],
              },
              {
                'icon': Icons.add_circle_rounded,
                'text': 'Add multiple questions',
                'gradient': [const Color(0xFF45B7D1), const Color(0xFF7DD3E8)],
              },
              {
                'icon': Icons.picture_as_pdf_rounded,
                'text': 'Download as PDF',
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
                        feature['icon'] as IconData,
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

  Widget _buildFeatureCard(IconData icon, String text, List<Color> gradient) {
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
            child: Icon(icon, color: Colors.white, size: 24.r),
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

  Widget _buildQuestionsListView() {
    return ListView.builder(
      padding: EdgeInsets.all(AppTheme.spacingM),
      itemCount: controller.mcqQuestions.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.mcqQuestions.length) {
          return _buildListFooter();
        }

        final question = controller.mcqQuestions[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: _buildQuestionCard(question, index),
              ),
            );
          },
        );
      },
    );
  }

  /// Scan / clear actions parked at the end of the list, so neither one sits
  /// on top of a question the way the floating buttons used to.
  Widget _buildListFooter() {
    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacingS, bottom: AppTheme.spacingM),
      child: Obx(() => Row(
        children: [
          if (controller.scanLimit.remaining.value > 0) ...[
          Expanded(
            child: GestureDetector(
              onTap: controller.scanQuestion,
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
                        "Scan Another Question",
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
          // Saves the whole set as a PDF. It lives here rather than in the
          // app bar, so it cannot cover a question.
          GestureDetector(
            onTap: controller.isPdfGenerating.value
                ? null
                : controller.generatePdf,
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFFAA5A),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFAA5A).withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: controller.isPdfGenerating.value
                  ? SizedBox(
                      width: 22.w,
                      height: 22.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.r,
                      ),
                    )
                  : Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.white,
                      size: 22.r,
                    ),
            ),
          ),
          SizedBox(width: AppTheme.spacingS),
          // Clearing the list stays available whether or not there are scans
          // left, so a spent budget still leaves a way back.
          GestureDetector(
            onTap: _showClearDialog,
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
                Icons.delete_rounded,
                color: Colors.white,
                size: 22.r,
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildQuestionCard(McqQuestion question, int index) {
    final gradient = _getGradient(index);

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS + 4,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "Q${index + 1}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.deleteQuestion(index),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingS),
                Text(
                  question.question,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Options
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppTheme.spacingM,
              AppTheme.spacingS + 4,
              AppTheme.spacingM,
              0,
            ),
            child: Column(
              children: List.generate(question.options.length, (optIndex) {
                final option = question.options[optIndex];
                return _buildOptionTile(
                  question,
                  index,
                  option,
                  optIndex,
                  gradient,
                );
              }),
            ),
          ),

          // Result banner, shown as soon as an option is picked.
          if (question.showResult)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacingM,
                AppTheme.spacingXS,
                AppTheme.spacingM,
                AppTheme.spacingS + 4,
              ),
              child: _buildResultWidget(question),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    McqQuestion question,
    int qIndex,
    McqOption option,
    int optIndex,
    List<Color> gradient,
  ) {
    Color bgColor = Colors.grey.shade50;
    Color borderColor = Colors.grey.shade300;
    Color textColor = const Color(0xFF333333);
    Color circleColor = Colors.grey.shade200;
    Color circleTextColor = Colors.grey.shade600;

    if (question.showResult) {
      if (option.isCorrect == true) {
        bgColor = const Color(0xFF56D97F).withValues(alpha: 0.15);
        borderColor = const Color(0xFF56D97F);
        textColor = const Color(0xFF00B894);
        circleColor = const Color(0xFF56D97F);
        circleTextColor = Colors.white;
      } else if (option.isSelected && option.isCorrect == false) {
        bgColor = const Color(0xFFFF6B6B).withValues(alpha: 0.15);
        borderColor = const Color(0xFFFF6B6B);
        textColor = const Color(0xFFFF6B6B);
        circleColor = const Color(0xFFFF6B6B);
        circleTextColor = Colors.white;
      }
    } else if (option.isSelected) {
      bgColor = gradient[0].withValues(alpha: 0.1);
      borderColor = gradient[0];
      textColor = gradient[0];
      circleColor = gradient[0];
      circleTextColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => controller.selectOption(qIndex, optIndex),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: AppTheme.spacingS),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM - 2,
          vertical: AppTheme.spacingS - 1,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  option.option,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: circleTextColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: Text(
                option.text,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: textColor,
                  fontWeight: option.isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
            if (question.showResult && option.isCorrect == true)
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF56D97F),
                size: 20.r,
              ),
            if (question.showResult &&
                option.isSelected &&
                option.isCorrect == false)
              Icon(Icons.cancel_rounded, color: Color(0xFFFF6B6B), size: 20.r),
          ],
        ),
      ),
    );
  }

  Widget _buildResultWidget(McqQuestion question) {
    // A scan fills the answer in for the reader, so only a tap of their own
    // earns a "Correct!" -- otherwise the banner just names the answer.
    final isCorrect = question.isAnswerCorrect;
    final gradient = isCorrect
        ? [const Color(0xFF56D97F), const Color(0xFF7BE495)]
        : [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM - 2,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradient[0].withValues(alpha: 0.15),
            gradient[1].withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: gradient[0], width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCorrect ? Icons.check_rounded : Icons.close_rounded,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  !question.answeredByUser
                      ? "Answer: ${question.correctAnswer}"
                      : isCorrect
                          ? "Correct! 🎉"
                          : "Wrong! 😕",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: gradient[0],
                  ),
                ),
                if (question.explanation.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    question.explanation,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
