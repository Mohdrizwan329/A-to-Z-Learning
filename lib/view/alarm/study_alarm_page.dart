import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jiyan_learning/app/theme/app_theme.dart';
import 'package:jiyan_learning/services/study_alarm_service.dart';
import 'package:jiyan_learning/utils/responsive.dart';

/// Study alarms: set a time, pick the days, and the phone rings even with the
/// app closed. Drawn in the same palette as the home and scanner screens.
class StudyAlarmPage extends StatefulWidget {
  const StudyAlarmPage({super.key});

  @override
  State<StudyAlarmPage> createState() => _StudyAlarmPageState();
}

class _StudyAlarmPageState extends State<StudyAlarmPage>
    with SingleTickerProviderStateMixin {
  final StudyAlarmService service = Get.isRegistered<StudyAlarmService>()
      ? Get.find<StudyAlarmService>()
      : Get.put(StudyAlarmService());

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

  /// One gradient per card, cycled, so a list of alarms reads as colourfully
  /// as the home grid does.
  static const List<List<Color>> _gradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF45B7D1), Color(0xFF7DD3E8)],
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    [Color(0xFF56D97F), Color(0xFF7BE495)],
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
  ];

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
          child: Obx(() {
            final alarms = service.alarms;
            return ListView(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacingM,
                AppTheme.spacingS,
                AppTheme.spacingM,
                80.h,
              ),
              children: [
                if (!service.permissionGranted.value) _buildPermissionCard(),
                _buildHeaderCard(alarms.length),
                SizedBox(height: AppTheme.spacingS),
                if (alarms.isEmpty)
                  _buildEmptyState()
                else
                  ...alarms.asMap().entries.map(
                        (entry) => _float(
                          entry.key,
                          _buildAlarmCard(
                            context,
                            entry.value,
                            _gradients[entry.key % _gradients.length],
                          ),
                        ),
                      ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: Container(
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
          heroTag: 'add_study_alarm',
          onPressed: () => _openEditor(context),
          backgroundColor: const Color(0xFF45B7D1),
          icon: const Icon(Icons.alarm_add_rounded, color: Colors.white),
          label: Text(
            "Add Alarm",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
          gradient: const LinearGradient(
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
              color: const Color(0x40FF6B6B),
              blurRadius: 15.r,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Study ',
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
              'Alarms',
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

  /// Shown only when the OS refused: an alarm that cannot ring is worth
  /// saying out loud rather than leaving as a silent row in the list.
  Widget _buildPermissionCard() {
    return GestureDetector(
      onTap: service.requestPermissions,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: AppTheme.spacingS),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS + 2,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(Icons.notifications_off_rounded,
                color: Colors.white, size: 22.r),
            SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: Text(
                "Alarms are blocked. Tap to allow notifications and exact alarms.",
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(int count) {
    return Container(
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
            child: Icon(Icons.alarm_rounded, color: Colors.white, size: 24.r),
          ),
          SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count == 0
                      ? "No study alarms yet"
                      : count == 1
                          ? "1 study alarm set"
                          : "$count study alarms set",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Rings even when the app is closed",
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

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 60.h),
      child: Column(
        children: [
          Container(
            width: 96.w,
            height: 96.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Icon(Icons.alarm_add_rounded,
                color: Colors.white, size: 44.r),
          ),
          SizedBox(height: AppTheme.spacingM),
          Text(
            "Set your first study alarm",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Pick a time and the days it should ring",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard(
    BuildContext context,
    StudyAlarm alarm,
    List<Color> gradient,
  ) {
    final on = alarm.enabled;

    return GestureDetector(
      onTap: () => _openEditor(context, existing: alarm),
      child: Container(
        margin: EdgeInsets.only(bottom: AppTheme.spacingS),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: on
                ? gradient
                // A switched-off alarm is greyed out rather than hidden, so
                // it is obvious it will not ring.
                : [
                    gradient[0].withValues(alpha: 0.35),
                    gradient[1].withValues(alpha: 0.35),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (on)
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.3),
                blurRadius: 8.r,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alarm.time.format(context),
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${alarm.label}  •  ${StudyAlarmService.daysLabel(alarm)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: on,
              onChanged: (value) => service.toggle(alarm, value),
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.white.withValues(alpha: 0.45),
              inactiveThumbColor: Colors.white.withValues(alpha: 0.7),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
            ),
            GestureDetector(
              onTap: () => _confirmDelete(context, alarm),
              child: Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 22.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ editor

  Future<void> _openEditor(BuildContext context, {StudyAlarm? existing}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: existing?.time ?? const TimeOfDay(hour: 17, minute: 0),
      helpText: existing == null ? 'Study alarm time' : 'Change alarm time',
    );
    if (picked == null) return;
    if (!context.mounted) return;

    final result = await showModalBottomSheet<_AlarmDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AlarmDetailsSheet(
        time: picked,
        label: existing?.label ?? '',
        days: existing?.days ?? const {},
      ),
    );
    if (result == null) return;

    // Asked only when an alarm is actually being set, rather than on a cold
    // start where the request has no context.
    await service.requestPermissions();

    if (existing == null) {
      await service.add(
        time: result.time,
        label: result.label,
        days: result.days,
      );
    } else {
      await service.update(existing.copyWith(
        hour: result.time.hour,
        minute: result.time.minute,
        label: result.label.trim().isEmpty ? existing.label : result.label,
        days: result.days,
        enabled: true,
      ));
    }
  }

  Future<void> _confirmDelete(BuildContext context, StudyAlarm alarm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          "Delete this alarm?",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "${alarm.label} at ${alarm.time.format(dialogContext)} will stop ringing.",
          style: GoogleFonts.nunito(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text("Keep", style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              "Delete",
              style: GoogleFonts.poppins(color: const Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await service.remove(alarm);
  }
}

/// What the details sheet hands back.
class _AlarmDraft {
  const _AlarmDraft({
    required this.time,
    required this.label,
    required this.days,
  });

  final TimeOfDay time;
  final String label;
  final Set<int> days;
}

/// Label and repeat days, asked for after the time picker.
class _AlarmDetailsSheet extends StatefulWidget {
  const _AlarmDetailsSheet({
    required this.time,
    required this.label,
    required this.days,
  });

  final TimeOfDay time;
  final String label;
  final Set<int> days;

  @override
  State<_AlarmDetailsSheet> createState() => _AlarmDetailsSheetState();
}

class _AlarmDetailsSheetState extends State<_AlarmDetailsSheet> {
  late final TextEditingController _label =
      TextEditingController(text: widget.label);
  late final Set<int> _days = {...widget.days};

  static const List<({int day, String short})> _week = [
    (day: DateTime.monday, short: 'M'),
    (day: DateTime.tuesday, short: 'T'),
    (day: DateTime.wednesday, short: 'W'),
    (day: DateTime.thursday, short: 'T'),
    (day: DateTime.friday, short: 'F'),
    (day: DateTime.saturday, short: 'S'),
    (day: DateTime.sunday, short: 'S'),
  ];

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: AppTheme.spacingM),
            Text(
              widget.time.format(context),
              style: GoogleFonts.poppins(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            SizedBox(height: AppTheme.spacingS),
            TextField(
              controller: _label,
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 15),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "What is this alarm for? (e.g. Maths practice)",
                hintStyle: GoogleFonts.nunito(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS + 2,
                ),
              ),
            ),
            SizedBox(height: AppTheme.spacingM),
            Text(
              _days.isEmpty ? "Repeats every day" : "Repeats on the days picked",
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            SizedBox(height: AppTheme.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _week.map((entry) {
                final on = _days.contains(entry.day);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (on) {
                      _days.remove(entry.day);
                    } else {
                      _days.add(entry.day);
                    }
                  }),
                  child: Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: on
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        entry.short,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: on
                              ? const Color(0xFF764BA2)
                              : Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppTheme.spacingM),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(
                  _AlarmDraft(
                    time: widget.time,
                    label: _label.text,
                    days: _days,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF56D97F), Color(0xFF7BE495)],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 22.r),
                      SizedBox(width: 8.w),
                      Text(
                        "Save Alarm",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: AppTheme.spacingS),
          ],
        ),
      ),
    );
  }
}
