// Pins the per-screen daily scan budget: five a day, each screen counting
// separately, spent counts surviving a restart, and the whole thing rolling
// over when the date changes.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/daily_scan_limit.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // GetStorage asks path_provider where to write; in tests nothing answers
    // that channel, so point it at the temp dir the test runner already has.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('scan_limit').path,
    );
    await GetStorage.init();
  });

  setUp(() async => GetStorage().erase());

  test('a fresh day starts with the full budget', () {
    final limit = DailyScanLimit(name: 'ocr');
    expect(limit.remaining.value, 5);
    expect(limit.used, 0);
    expect(limit.canScan, isTrue);
  });

  test('five scans use it up and the sixth is refused', () {
    final limit = DailyScanLimit(name: 'ocr');
    for (var i = 0; i < 5; i++) {
      expect(limit.canScan, isTrue, reason: 'scan ${i + 1} should be allowed');
      limit.consume();
    }
    expect(limit.remaining.value, 0);
    expect(limit.used, 5);
    expect(limit.canScan, isFalse);

    // A refused scan must not push the counter negative.
    limit.consume();
    expect(limit.remaining.value, 0);
    expect(limit.used, 5);
  });

  test('the two screens keep separate budgets', () {
    final ocr = DailyScanLimit(name: 'ocr');
    final math = DailyScanLimit(name: 'math');

    ocr.consume();
    ocr.consume();

    expect(ocr.remaining.value, 3);
    expect(math.remaining.value, 5, reason: 'math budget must be untouched');

    math.consume();
    expect(math.remaining.value, 4);
    expect(ocr.remaining.value, 3);
  });

  test('a restart picks the spent count back up', () {
    DailyScanLimit(name: 'ocr')
      ..consume()
      ..consume();

    // A second instance stands in for the app being reopened.
    expect(DailyScanLimit(name: 'ocr').remaining.value, 3);
  });

  test('returning to the screen re-reads what is left', () {
    final onScreen = DailyScanLimit(name: 'ocr');

    // Something else spent two scans -- another instance of the same screen,
    // or this one before it was rebuilt.
    DailyScanLimit(name: 'ocr')
      ..consume()
      ..consume();

    // The badge still holds the value it was built with...
    expect(onScreen.remaining.value, 5);
    // ...until the screen comes back and asks again.
    onScreen.refresh();
    expect(onScreen.remaining.value, 3);
  });

  test('an app left open past midnight refreshes to a full budget', () {
    final limit = DailyScanLimit(name: 'ocr');
    limit.consume();
    expect(limit.remaining.value, 4);

    // Backdate the stored day, the way sleeping past midnight would.
    GetStorage().write('scan_limit_ocr_date', '2000-01-01');

    limit.refresh();
    expect(limit.remaining.value, 5);
    expect(limit.used, 0);
  });

  test('the budget rolls over when the date changes', () {
    final limit = DailyScanLimit(name: 'ocr');
    limit.consume();
    limit.consume();
    expect(limit.remaining.value, 3);

    // Backdate the stored day, the way sleeping past midnight would.
    GetStorage().write('scan_limit_ocr_date', '2000-01-01');

    expect(limit.canScan, isTrue);
    expect(limit.remaining.value, 5);
  });
}
