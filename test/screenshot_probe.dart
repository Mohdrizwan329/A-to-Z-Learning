// Renders the pages whose spacing changed and writes a PNG for each, so the
// layout can actually be looked at rather than inferred from measurements.
//
// Run: flutter test test/screenshot_probe.dart
// Output: build/screenshots/*.png

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'probe_support.dart';

/// The pages where a `Spacer` became a fixed gap, or a list went from
/// `Expanded` to a share of the viewport.
const List<String> _changed = [
  'PuzzleGamePage',
  'ColorMatchPage',
  'NumberQuizPage',
  'LogicGamePage',
  'WordBuildingPage',
  'ListeningSkillsPage',
  'FlashcardsPage',
  'StrokeOrderPage',
  'HandwritingPracticePage',
  'AdvancedMathGamesPage',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initProbeBinding);
  setUp(() {
    Get.reset();
    Get.testMode = true;
    registerProbeServices();
  });

  final dir = Directory('build/screenshots');
  final saved = <String>[];

  for (final name in _changed) {
    final build = probePages[name];
    if (build == null) continue;
    testWidgets('shot $name', (tester) async {
      applyDevice(tester, probeDevices[2]); // 375x812, the design canvas
      addTearDown(tester.view.reset);
      final key = GlobalKey();
      final previous = FlutterError.onError;
      FlutterError.onError = (_) {};
      try {
        await tester.pumpWidget(
          RepaintBoundary(key: key, child: probeApp(probeDevices[2], build())),
        );
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 400));

        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          if (bytes == null) return;
          dir.createSync(recursive: true);
          final f = File('${dir.path}/$name.png');
          f.writeAsBytesSync(bytes.buffer.asUint8List());
          saved.add(f.path);
        });
      } catch (e) {
        saved.add('$name FAILED: $e');
      } finally {
        FlutterError.onError = previous;
      }
      while (tester.takeException() != null) {}
    });
  }

  tearDownAll(() {
    debugPrint('\n=========== SCREENSHOTS ===========');
    for (final s in saved) {
      debugPrint('  $s');
    }
    debugPrint('===================================');
  });
}
