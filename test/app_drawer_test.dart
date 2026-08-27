// Pins the drawer's width: it opens over half the window, not the whole
// phone, and its contents still lay out at that size.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/view/home/widgets/app_drawer.dart';

Future<GlobalKey<ScaffoldState>> _openDrawer(
    WidgetTester tester, Size size) async {
  tester.view.physicalSize = Size(size.width * 3, size.height * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final key = GlobalKey<ScaffoldState>();
  await tester.pumpWidget(GetMaterialApp(
    builder: (context, child) {
      R.update(MediaQuery.of(context));
      return child!;
    },
    home: Scaffold(key: key, drawer: const AppDrawer(), body: const SizedBox()),
  ));

  key.currentState!.openDrawer();
  await tester.pumpAndSettle();

  return key;
}

Future<double> _openDrawerWidth(WidgetTester tester, Size size) async {
  await _openDrawer(tester, size);
  return tester.getSize(find.byType(Drawer)).width;
}

void main() {
  setUpAll(() => Get.testMode = true);

  testWidgets('a phone drawer leaves the page behind visible', (tester) async {
    const width = 390.0;
    final drawerWidth = await _openDrawerWidth(tester, const Size(width, 844));

    expect(drawerWidth, closeTo(width * 0.72, 1),
        reason: 'the default 304pt drawer is most of a phone');
    expect(tester.takeException()?.toString() ?? '', isNot(contains('overflowed')));
  });

  testWidgets('a small phone keeps a usable minimum', (tester) async {
    final drawerWidth = await _openDrawerWidth(tester, const Size(320, 568));

    // 72% of 320 lands under the floor, so the floor is what it gets.
    expect(drawerWidth, 270);
    expect(tester.takeException()?.toString() ?? '', isNot(contains('overflowed')));
  });

  testWidgets('the close button in the corner shuts the drawer',
      (tester) async {
    final key = await _openDrawer(tester, const Size(390, 844));
    expect(key.currentState!.isDrawerOpen, isTrue);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(key.currentState!.isDrawerOpen, isFalse);
    expect(tester.takeException()?.toString() ?? '', isNot(contains('overflowed')));
  });

  testWidgets('a tablet gets a panel, not half a page', (tester) async {
    final drawerWidth = await _openDrawerWidth(tester, const Size(1024, 768));

    expect(drawerWidth, 420, reason: 'capped so it stays a side panel');
    expect(tester.takeException()?.toString() ?? '', isNot(contains('overflowed')));
  });
}
