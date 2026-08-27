import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Caps how many scans one screen may run in a single calendar day.
///
/// Each screen owns its own counter -- the MCQ scanner and the math solver get
/// five each -- so spending one screen's budget never eats the other's. The
/// count is stored, so it survives an app restart, and rolls back to full when
/// the device's date changes.
class DailyScanLimit {
  DailyScanLimit({required this.name, this.maxPerDay = 5}) {
    _refreshForToday();
  }

  /// Storage prefix; must be unique per screen.
  final String name;
  final int maxPerDay;

  /// Scans still available today. The screens watch this to draw the counter.
  final RxInt remaining = 0.obs;

  final GetStorage _box = GetStorage();

  String get _countKey => 'scan_limit_${name}_count';
  String get _dateKey => 'scan_limit_${name}_date';

  /// True while the user still has a scan left today. Re-checks the date, so a
  /// session left open past midnight picks up the new day's budget.
  bool get canScan {
    _refreshForToday();
    return remaining.value > 0;
  }

  /// How many of today's scans have been spent.
  int get used => maxPerDay - remaining.value;

  /// Re-reads the stored count for today.
  ///
  /// The screens call this whenever they come back into view -- reopening the
  /// app, switching back to the tab, or waking the phone -- so the badge shows
  /// what is actually left rather than whatever it read when it was first
  /// built. Crossing midnight with the app open rolls the budget over here.
  void refresh() => _refreshForToday();

  /// Records one scan. Call this only once a scan is actually going ahead, so
  /// a cancelled picker or an unreadable photo does not cost the user a turn.
  void consume() {
    _refreshForToday();
    if (remaining.value <= 0) return;
    _box.write(_countKey, used + 1);
    _box.write(_dateKey, _today());
    remaining.value -= 1;
  }

  /// Message shown when the budget is gone. Kept here so both screens word it
  /// the same way.
  String get exhaustedMessage =>
      "You have used all $maxPerDay scans for today. Come back tomorrow!";

  /// Rolls the counter over when the calendar day has changed, otherwise
  /// reloads today's count from storage.
  void _refreshForToday() {
    final today = _today();
    if (_box.read(_dateKey) != today) {
      _box.write(_dateKey, today);
      _box.write(_countKey, 0);
      remaining.value = maxPerDay;
      return;
    }
    final spent = (_box.read(_countKey) as int?) ?? 0;
    remaining.value = (maxPerDay - spent).clamp(0, maxPerDay);
  }

  /// Date only -- the clock time must not matter.
  static String _today() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }
}
