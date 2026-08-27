import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/services/daily_scan_limit.dart';
import 'package:jiyan_learning/utils/responsive.dart';

/// Shows how many of today's scans are left on a scanner screen.
///
/// Both scanners draw this, so the wording and the spent/left colours stay the
/// same on each. It turns red once the budget is gone, which is the only cue a
/// kid gets for why the scan button has stopped working.
///
/// It re-reads the stored count every time the screen comes back -- a fresh
/// launch, a tab switch, or the phone waking up -- so a count spent earlier
/// today is still there, and a new day is back to a full budget.
class ScanLimitBadge extends StatefulWidget {
  const ScanLimitBadge({super.key, required this.limit});

  final DailyScanLimit limit;

  @override
  State<ScanLimitBadge> createState() => _ScanLimitBadgeState();
}

class _ScanLimitBadgeState extends State<ScanLimitBadge>
    with WidgetsBindingObserver {
  DailyScanLimit get limit => widget.limit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshAfterFrame();
  }

  @override
  void didUpdateWidget(covariant ScanLimitBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refreshAfterFrame();
  }

  /// The count is watched by more than this badge -- the scan button reads it
  /// too -- so writing it from `initState` would mark a widget dirty in the
  /// middle of a build. It waits for the frame to finish instead.
  void _refreshAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) limit.refresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back from the background is the case that matters: the app may
    // have sat there since yesterday.
    if (state == AppLifecycleState.resumed) limit.refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final left = limit.remaining.value;
      final exhausted = left == 0;

      return Container(
        margin: EdgeInsets.only(
          left: AppTheme.spacingM,
          right: AppTheme.spacingM,
          top: AppTheme.spacingS,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: exhausted
              ? const Color(0xFFFF6B6B).withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              exhausted ? Icons.lock_clock_rounded : Icons.bolt_rounded,
              color: Colors.white,
              size: 18.r,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                exhausted
                    ? "No scans left today - come back tomorrow"
                    : "$left of ${limit.maxPerDay} scans left today",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
