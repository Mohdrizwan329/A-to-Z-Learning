import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jiyan_learning/utils/responsive.dart';

/// Screens the app has to survive, from the smallest Android phone still in
/// use up to a maximised desktop window.
const _devices = <String, Size>{
  'small phone (iPhone SE)': Size(320, 568),
  'design canvas': Size(375, 812),
  'large phone (Pixel 8 Pro)': Size(430, 932),
  'phone landscape': Size(812, 375),
  'tablet portrait (iPad)': Size(768, 1024),
  'tablet landscape': Size(1024, 768),
  'desktop window': Size(1440, 900),
  'maximised 4K': Size(2560, 1440),
};

Future<void> _pumpAt(WidgetTester tester, Size size, Widget child) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, c) => ResponsiveShell(child: c ?? const SizedBox()),
      home: child,
    ),
  );
}

void main() {
  group('device bucketing', () {
    test('buckets are chosen from the shortest side', () {
      R.update(const MediaQueryData(size: Size(375, 812)));
      expect(R.device, DeviceType.mobile);

      // A phone in landscape is still a phone.
      R.update(const MediaQueryData(size: Size(812, 375)));
      expect(R.device, DeviceType.mobile);

      R.update(const MediaQueryData(size: Size(768, 1024)));
      expect(R.device, DeviceType.tablet);

      // A tablet stays a tablet when rotated.
      R.update(const MediaQueryData(size: Size(1024, 768)));
      expect(R.device, DeviceType.tablet);

      R.update(const MediaQueryData(size: Size(1440, 1080)));
      expect(R.device, DeviceType.desktop);
    });
  });

  group('scaling stays bounded', () {
    test('never runs away on a wide window', () {
      for (final size in _devices.values) {
        R.update(MediaQueryData(size: size));
        expect(R.scale, inInclusiveRange(0.82, 1.45),
            reason: 'scale exploded at $size');
        // Floor matches the layout floor: text that shrank less than the box
        // around it overflowed tight rows and tiles on a small phone.
        expect(R.textScale, inInclusiveRange(0.82, 1.22),
            reason: 'text scale exploded at $size');
        expect(R.textScale, lessThanOrEqualTo(R.scale),
            reason: 'text outgrew its layout at $size');
      }
    });

    test('small phones scale down, tablets scale up', () {
      R.update(const MediaQueryData(size: Size(320, 568)));
      final small = R.textScale;

      R.update(const MediaQueryData(size: Size(375, 812)));
      final base = R.textScale;

      R.update(const MediaQueryData(size: Size(768, 1024)));
      final tablet = R.textScale;

      expect(small, lessThan(base));
      expect(tablet, greaterThan(base));
      expect(base, closeTo(1.0, 0.001));
    });

    test('the old SizeConfig blow-up is gone', () {
      // Previously getProportionateScreenWidth(100) on a 1920pt window returned
      // 512. It must now stay near the design value.
      R.update(const MediaQueryData(size: Size(1920, 1080)));
      expect(R.w(100), lessThan(150));
    });
  });

  group('content column', () {
    test('caps on tablet and desktop, free on phones', () {
      R.update(const MediaQueryData(size: Size(375, 812)));
      expect(R.maxContentWidth, double.infinity);
      expect(R.layoutWidth, 375);

      R.update(const MediaQueryData(size: Size(1024, 768)));
      expect(R.layoutWidth, lessThanOrEqualTo(600));

      R.update(const MediaQueryData(size: Size(2560, 1440)));
      expect(R.layoutWidth, lessThanOrEqualTo(680));
    });

    testWidgets('MediaQuery inside the shell reports the column, not the window',
        (tester) async {
      late double reportedWidth;
      await _pumpAt(
        tester,
        const Size(1440, 900),
        Builder(
          builder: (context) {
            reportedWidth = MediaQuery.of(context).size.width;
            return const SizedBox();
          },
        ),
      );
      // A page asking for the screen width must get the column it is laid out
      // in, otherwise everything it sizes from that number overflows.
      expect(reportedWidth, lessThanOrEqualTo(680));
    });

    testWidgets('the app is not stretched across a wide window',
        (tester) async {
      await _pumpAt(
        tester,
        const Size(1440, 900),
        const Scaffold(body: Text('hello')),
      );
      final scaffoldWidth = tester.getSize(find.byType(Scaffold)).width;
      expect(scaffoldWidth, lessThanOrEqualTo(680));
    });
  });

  group('no overflow across every device', () {
    // A row of fixed-size cards is the shape this app repeats everywhere, and
    // the shape that overflowed on small screens.
    Widget sampleScreen() => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const Text(
                  'Select your Age Group',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 8,
                    itemBuilder: (_, i) => Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 32),
                          Text('Item $i',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

    for (final entry in _devices.entries) {
      testWidgets('lays out on ${entry.key}', (tester) async {
        await _pumpAt(tester, entry.value, sampleScreen());
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull,
            reason: 'overflowed on ${entry.key} (${entry.value})');
      });
    }
  });

  group('system font size cannot burst the layout', () {
    testWidgets('an extreme accessibility setting is clamped', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      late double effective;
      await tester.pumpWidget(
        MediaQuery(
          // A user asking for 3x text.
          data: const MediaQueryData(
            size: Size(375, 812),
            textScaler: TextScaler.linear(3.0),
          ),
          child: MaterialApp(
            builder: (context, c) =>
                ResponsiveShell(child: c ?? const SizedBox()),
            home: Builder(
              builder: (context) {
                effective = MediaQuery.of(context).textScaler.scale(1);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(effective, lessThanOrEqualTo(1.30 * 1.22));
      expect(effective, greaterThan(1.0),
          reason: 'the preference should still be honoured, just bounded');
    });
  });
}
