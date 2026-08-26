import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';

import 'probe_support.dart';

/// Renders every page that can be built without arguments at the smallest
/// screen the app supports, and reports which ones overflow.
///
/// Pages that cannot be constructed headlessly (platform channels, missing
/// controllers) are reported separately rather than failing the run, so the
/// overflow signal stays readable.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('jiyan_probe');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => dir.path,
    );
    await GetStorage.init();

    // Ten pages reach Firebase while they build. `setupFirebaseCoreMocks`
    // answers the pigeon channel with a stub app so they can be probed here;
    // nothing in this run talks to a real project.
    setupFirebaseCoreMocks();
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // Its pages stay in the not-renderable list.
    }

    Get.testMode = true;
  });

  // Tearing down a `GetMaterialApp` clears the GetX registry, so services put
  // once in `setUpAll` only survive the first page. Re-register before every
  // page instead, from a clean registry, so each page is probed in isolation
  // and one page's failure cannot cascade into the next.

  // Re-registered before every page: tearing down a `GetMaterialApp` clears
  // the GetX registry, so services put once in `setUpAll` only survive the
  // first page. A clean registry per page also stops one page's failure from
  // cascading into the next.
  setUp(() {
    Get.reset();
    Get.testMode = true;
    registerProbeServices();
  });

  final overflowed = <String>[];
  final thrown = <String>{};
  final unbuildable = <String, String>{};
  final clean = <String>[];

  for (final device in probeDevices) {
  for (final entry in probePages.entries) {
    testWidgets('${device.label} | ${entry.key}', (tester) async {
      applyDevice(tester, device);
      addTearDown(tester.view.reset);

      final errors = <String>[];
      final buildErrors = <String>[];
      final layoutIssues = <String>[];
      final sourceHints = <String>{};
      final fullAtBuild = <String>[];
      var crashed = false;
      final previous = FlutterError.onError;
      final full = <String>[];
      FlutterError.onError = (details) {
        errors.add(details.exception.toString());
        full.add(details.toString());
      };

      try {
        await tester.pumpWidget(probeApp(device, entry.value()));
        await tester.pump(const Duration(milliseconds: 300));

        // The first frame is laid out before google_fonts resolves and before
        // any `Obx` has emitted, so `FlutterError` reports transient overflows
        // the settled page does not have. Ignore that stream and measure the
        // settled render tree directly instead.
        buildErrors.addAll(errors.where((e) =>
            !e.contains('Failed to load font') &&
            !e.contains('core/no-app') &&
            !e.contains('MissingPluginException')));
        // Flutter reports an overflow once per render object, and names the
        // source file when it does. That first report is the only place a
        // file:line is available, so it is harvested here before the settled
        // tree is measured.
        fullAtBuild.addAll(full);
        for (final match
            in RegExp(r'(lib/[^\s:]+\.dart):(\d+)').allMatches(full.join('\n'))) {
          sourceHints.add('${match.group(1)}:${match.group(2)}');
        }
        errors.clear();
        full.clear();
        for (final view in tester.binding.renderViews) {
          if (hasErrorBox(view)) {
            crashed = true;
          }
          layoutIssues.addAll(scanOverflow(view));
        }
      } catch (e) {
        unbuildable['${device.label} | ${entry.key}'] =
            'THROWN: ' + e.toString().split('\n').take(2).join(' | ');
      } finally {
        FlutterError.onError = previous;
      }

      // Noise from the headless environment, not layout problems: google_fonts
      // tries to fetch over the network, and Firebase is never initialised here.
      errors.removeWhere((e) =>
          e.contains('Failed to load font') ||
          e.contains('core/no-app') ||
          e.contains('MissingPluginException'));

      // Anything the page threw, even if it carried on afterwards. A
      // LateInitializationError or a null check on a field that is filled in
      // later shows up here rather than as a layout finding.
      for (final e in [...errors, ...buildErrors]) {
        if (e.contains('overflowed')) continue;
        // The full report names the widget's source file; the exception string
        // alone does not.
        final loc = RegExp(r'(lib/[^\s:]+\.dart):(\d+)')
            .firstMatch(full.join('\n') + fullAtBuild.join('\n'));
        final where = loc == null ? '' : ' @ ${loc.group(1)}:${loc.group(2)}';
        thrown.add('${entry.key}$where: ${e.split("\n").first}');
      }

      if (crashed) {
        // A widget threw during build, so Flutter swapped in an ErrorWidget.
        // That is a build failure, not a layout one: report it as such rather
        // than as the 100000px "overflow" the error box's own size produces.
        unbuildable['${device.label} | ${entry.key}'] = buildErrors.isEmpty
            ? 'ErrorWidget in tree (exception during build)'
            : buildErrors.first.split('\n').take(3).join(' | ');
      } else if (layoutIssues.isNotEmpty) {
        final where = sourceHints.isEmpty ? '' : '  @ ${sourceHints.join(", ")}';
        overflowed.add('${device.label} | ${entry.key}$where  ->  '
            '${layoutIssues.take(4).join("; ")}');
      } else if (!unbuildable.containsKey('${device.label} | ${entry.key}')) {
        if (errors.isEmpty) {
          clean.add('${device.label} | ${entry.key}');
        } else {
          unbuildable['${device.label} | ${entry.key}'] =
              errors.first.split('\n').take(3).join(' | ');
        }
      }
      // Reporting run: never fail on a page, collect instead.
      while (tester.takeException() != null) {}
    });
  }
  }

  tearDownAll(() {
    debugPrint('\n========== OVERFLOW REPORT (all device buckets) ==========');
    debugPrint('pages rendered clean : ${clean.length}');
    debugPrint('pages OVERFLOWING    : ${overflowed.length}');
    debugPrint('pages not renderable : ${unbuildable.length}');
    debugPrint('\n--- OVERFLOWING ---');
    for (final o in overflowed..sort()) {
      debugPrint('  $o');
    }
    debugPrint('exceptions thrown   : ${thrown.length}');
    if (thrown.isNotEmpty) {
      debugPrint('\n--- EXCEPTIONS ---');
      for (final t in thrown.toList()..sort()) {
        debugPrint('  $t');
      }
    }
    debugPrint('\n--- NOT RENDERABLE (needs services/channels) ---');
    for (final e in unbuildable.entries) {
      debugPrint('  ${e.key}: ${e.value}');
    }
    debugPrint('=======================================================');
  });
}















