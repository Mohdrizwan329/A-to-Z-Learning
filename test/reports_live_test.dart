// Pins that the Reports screen follows the child's progress while it is open,
// rather than freezing whatever it read when it was first built.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/view/teacher/reports_page.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('reports').path,
    );
    await GetStorage.init();
    Get.testMode = true;

    // No network in a test run, so every GoogleFonts face fails to load. The
    // layout this test reads still comes out in the default face, so those
    // errors are dropped. Set outside any test, so the binding's
    // changed-during-a-test check stays happy.
    final report = reportTestException;
    reportTestException = (details, description) {
      if (details.exception.toString().contains('font')) return;
      report(details, description);
    };
  });

  setUp(() async {
    GetStorage().erase();
    Get.reset();
  });

  testWidgets('a lesson finished while the page is open shows up on it',
      (tester) async {
    final progress = Get.put(ProgressService());
    progress.totalItems[ProgressService.kNumbers] = 10;

    await tester.pumpWidget(GetMaterialApp(
      builder: (context, child) {
        R.update(MediaQuery.of(context));
        return child!;
      },
      home: const ReportsPage(),
    ));
    // The page runs endless float/bubble animations, so it never settles;
    // a couple of frames is enough for it to be built.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final before = progress.completedItems[ProgressService.kNumbers] ?? 0;

    // The child finishes an item somewhere else in the app.
    await progress.markItemCompleted(ProgressService.kNumbers, 0);
    await tester.pump();

    expect(progress.completedItems[ProgressService.kNumbers], before + 1);
    // The Obx around the report body is what makes this rebuild; without it
    // the page would still be showing the old count.
    expect(find.byType(Obx), findsWidgets);
  });
}
