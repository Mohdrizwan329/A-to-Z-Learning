import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jiyan_learning/utils/responsive.dart';

// The Flutter counter template that used to live here tested a screen this app
// has never had, so it failed on every run. These cover the cross-platform
// wiring instead.

void main() {
  test('scrollables can be dragged with a mouse and trackpad', () {
    // Without this, every carousel and grid is wheel-only on Windows, macOS,
    // Linux, Chrome and Edge.
    const behavior = AppScrollBehavior();
    expect(behavior.dragDevices, contains(PointerDeviceKind.mouse));
    expect(behavior.dragDevices, contains(PointerDeviceKind.trackpad));
    expect(behavior.dragDevices, contains(PointerDeviceKind.touch));
    expect(behavior.dragDevices, contains(PointerDeviceKind.stylus));
  });

  testWidgets('the shell re-measures when the window is resized', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    Widget app() => MaterialApp(
      builder: (context, child) =>
          ResponsiveShell(child: child ?? const SizedBox()),
      home: const SizedBox(),
    );

    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpWidget(app());
    expect(R.device, DeviceType.mobile);
    expect(R.layoutWidth, 375);

    // Dragging a desktop window wider must re-bucket, not keep phone metrics.
    tester.view.physicalSize = const Size(1440, 900);
    await tester.pumpWidget(app());
    await tester.pump();
    expect(R.device, DeviceType.desktop);
    expect(R.layoutWidth, lessThanOrEqualTo(680));
  });

  test('grid columns grow with the available column, within bounds', () {
    R.update(const MediaQueryData(size: Size(375, 812)));
    final phone = R.gridColumns(targetTileWidth: 160);

    R.update(const MediaQueryData(size: Size(1024, 768)));
    final tablet = R.gridColumns(targetTileWidth: 160);

    expect(phone, greaterThanOrEqualTo(2));
    expect(tablet, greaterThanOrEqualTo(phone));
    expect(tablet, lessThanOrEqualTo(6));
  });
}
