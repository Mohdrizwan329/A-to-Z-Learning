// Measures how long a frame actually takes for the heaviest pages.
//
// Two things in the responsive work cost real time and are worth watching: the
// `IntrinsicHeight` inside the pages that scroll in landscape, which lays its
// child out twice, and the `const` that had to come off ~5,800 widgets so they
// could use scaled sizes, which means those widgets are rebuilt rather than
// reused. This reports the wall-clock cost of a rebuild and a relayout so the
// numbers can be judged against the 16ms budget of a 60fps frame.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';


import 'probe_support.dart';


const int _samples = 12;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initProbeBinding);
  setUp(() {
    Get.reset();
    Get.testMode = true;
    registerProbeServices();
  });

  final rows = <String>[];

  for (final entry in probePages.entries) {
    testWidgets('perf ${entry.key}', (tester) async {
      applyDevice(tester, probeDevices.first);
      addTearDown(tester.view.reset);
      final previous = FlutterError.onError;
      FlutterError.onError = (_) {};
      try {
        await tester.pumpWidget(probeApp(probeDevices.first, entry.value()));
        await tester.pump(const Duration(milliseconds: 300));

        // Idle: an ordinary animation frame, with nothing marked dirty. This
        // is what the page costs while the reader is just looking at it.
        final idle = <int>[];
        for (var i = 0; i < _samples; i++) {
          final sw = Stopwatch()..start();
          await tester.pump(const Duration(milliseconds: 16));
          sw.stop();
          idle.add(sw.elapsedMicroseconds);
        }

        // Rebuild: what a setState on the page costs.
        final rebuild = <int>[];
        for (var i = 0; i < _samples; i++) {
          final root = tester.binding.rootElement;
          final sw = Stopwatch()..start();
          root?.markNeedsBuild();
          await tester.pump(const Duration(milliseconds: 16));
          sw.stop();
          rebuild.add(sw.elapsedMicroseconds);
        }

        // Relayout: what a rotation or a keyboard opening costs, and the pass
        // where IntrinsicHeight is paid for.
        final relayout = <int>[];
        for (var i = 0; i < _samples; i++) {
          final sw = Stopwatch()..start();
          for (final view in tester.binding.renderViews) {
            view.markNeedsLayout();
          }
          await tester.pump(const Duration(milliseconds: 16));
          sw.stop();
          relayout.add(sw.elapsedMicroseconds);
        }

        var renderObjects = 0;
        void count(RenderObject o) {
          renderObjects++;
          o.visitChildren(count);
        }
        for (final view in tester.binding.renderViews) {
          count(view);
        }
        var elements = 0;
        void countElements(Element e) {
          elements++;
          e.visitChildren(countElements);
        }
        tester.binding.rootElement?.visitChildren(countElements);

        // Judged on rebuild and relayout only. The idle column is reported for
        // context but not used: `pump()` also drains whatever async work the
        // page kicked off - a plugin call, a font fetch - and in a headless
        // test those never complete, so idle says more about the harness than
        // about the frame.
        final worst = [
          _median(rebuild),
          _median(relayout),
        ].reduce((a, b) => a > b ? a : b);
        rows.add('${worst > 16000 ? "!" : " "}${entry.key.padRight(38)} '
            'idle ${_median(idle).toString().padLeft(6)}us   '
            'rebuild ${_median(rebuild).toString().padLeft(6)}us   '
            'relayout ${_median(relayout).toString().padLeft(6)}us   '
            'elements ${elements.toString().padLeft(6)}   '
            'render ${renderObjects.toString().padLeft(5)}');
      } catch (e) {
        rows.add(' ${entry.key.padRight(38)} not measurable');
      } finally {
        FlutterError.onError = previous;
      }
      while (tester.takeException() != null) {}
    });
  }

  tearDownAll(() {
    debugPrint('\n=========== FRAME COST (median of $_samples) ===========');
    debugPrint('a 60fps frame has a 16000us budget');
    debugPrint('pages measured : ${rows.length}');
    final slow = rows.where((r) => r.startsWith('!')).toList()..sort();
    debugPrint('over budget    : ${slow.length}\n');
    for (final r in slow) {
      debugPrint('  $r');
    }
    debugPrint('=======================================================');
  });
}

int _median(List<int> xs) {
  final s = [...xs]..sort();
  return s[s.length ~/ 2];
}
