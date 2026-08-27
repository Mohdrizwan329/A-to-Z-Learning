// Pins what the two scanner screens show for today's budget: the count a
// screen displays is whatever is on disk at the moment it appears, not
// whatever it read when its controller was first built.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/daily_scan_limit.dart';
import 'package:jiyan_learning/services/study_alarm_service.dart';
import 'package:jiyan_learning/view/main_navigation_screen.dart';
import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/view/math%20scanner/math_scanner_page.dart';
import 'package:jiyan_learning/view%20model/math%20scanner%20controller/math_scanner_controller.dart';
import 'package:jiyan_learning/view/ocr/ocr_page.dart';
import 'package:jiyan_learning/view%20model/ocr%20controller/ocr_controller.dart';

Future<void> _host(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(GetMaterialApp(
    builder: (context, child) {
      R.update(MediaQuery.of(context));
      return child!;
    },
    home: page,
  ));
  await tester.pump();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // GetStorage asks path_provider where to write; in tests nothing answers
    // that channel, so point it at the temp dir the test runner already has.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('scan_badge').path,
    );
    await GetStorage.init();
    Get.testMode = true;

    // Every GoogleFonts face fails to load with no network, and the failure
    // lands as an async error against whichever test is running. The layout
    // these tests read still comes out in the default face, so those errors
    // are dropped. Set here, outside any test, so the binding's
    // changed-during-a-test check stays happy.
    final report = reportTestException;
    reportTestException = (details, description) {
      if (details.exception.toString().contains('font')) return;
      report(details, description);
    };
  });

  setUp(() async => GetStorage().erase());

  testWidgets('math solver shows what is left after a restart', (tester) async {
    // Two scans spent in an earlier run of the app.
    DailyScanLimit(name: 'math')
      ..consume()
      ..consume();

    Get.put(MathScannerController());
    await _host(tester, MathScannerPage());

    expect(find.text('3 of 5 scans left today'), findsOneWidget);

    Get.delete<MathScannerController>();
  });

  testWidgets('math solver picks up a scan spent while it was off screen',
      (tester) async {
    final c = Get.put(MathScannerController());
    expect(c.scanLimit.remaining.value, 5);

    // Spent after this controller was built -- the screen was on another tab.
    DailyScanLimit(name: 'math').consume();

    await _host(tester, MathScannerPage());

    expect(find.text('4 of 5 scans left today'), findsOneWidget);

    Get.delete<MathScannerController>();
  });

  testWidgets('math solver is back to a full budget the next day',
      (tester) async {
    DailyScanLimit(name: 'math')
      ..consume()
      ..consume()
      ..consume();

    // Backdate the stored day, the way coming back tomorrow would.
    GetStorage().write('scan_limit_math_date', '2000-01-01');

    Get.put(MathScannerController());
    await _host(tester, MathScannerPage());

    expect(find.text('5 of 5 scans left today'), findsOneWidget);

    Get.delete<MathScannerController>();
  });

  testWidgets('the scan button goes when the budget is spent', (tester) async {
    final spent = DailyScanLimit(name: 'math');
    for (var i = 0; i < 5; i++) {
      spent.consume();
    }

    Get.put(MathScannerController());
    await _host(tester, MathScannerPage());

    expect(find.text('No scans left today - come back tomorrow'),
        findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing,
        reason: 'a button that can only refuse is worse than no button');

    Get.delete<MathScannerController>();
  });

  testWidgets('the scan button is back the next day', (tester) async {
    final spent = DailyScanLimit(name: 'math');
    for (var i = 0; i < 5; i++) {
      spent.consume();
    }

    // Backdate the stored day, the way coming back tomorrow would.
    GetStorage().write('scan_limit_math_date', '2000-01-01');

    Get.put(MathScannerController());
    await _host(tester, MathScannerPage());

    expect(find.text('5 of 5 scans left today'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsWidgets);

    Get.delete<MathScannerController>();
  });

  testWidgets('the MCQ scan button follows the same rule', (tester) async {
    final spent = DailyScanLimit(name: 'ocr');
    for (var i = 0; i < 5; i++) {
      spent.consume();
    }

    Get.put(OcrController());
    await _host(tester, OcrScreen());

    expect(find.byType(FloatingActionButton), findsNothing);

    Get.delete<OcrController>();
  });

  testWidgets('five nav tabs still fit on a small phone', (tester) async {
    tester.view.physicalSize = const Size(320 * 3, 568 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Get.put(StudyAlarmService());
    await _host(tester, MainNavigationScreen());

    for (final label in ['Home', 'MCQ', 'Math', 'Alarm', 'Profile']) {
      expect(find.text(label), findsOneWidget, reason: '$label tab is missing');
    }
    // Firebase is not wired up in a test run, so an unrelated exception is
    // expected here; a squeezed nav bar is not.
    final error = tester.takeException()?.toString() ?? '';
    expect(error, isNot(contains('overflowed')),
        reason: 'a fifth tab must not burst the bar on a 320pt phone');

    Get.delete<StudyAlarmService>();
  });

  testWidgets('the two screens count separately', (tester) async {
    DailyScanLimit(name: 'math')
      ..consume()
      ..consume();

    Get.put(OcrController());
    await _host(tester, OcrScreen());

    expect(find.text('5 of 5 scans left today'), findsOneWidget,
        reason: "the MCQ budget must not be spent by the math solver");

    Get.delete<OcrController>();
  });
}
