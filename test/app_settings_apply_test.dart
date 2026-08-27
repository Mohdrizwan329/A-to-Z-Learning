// Pins that the settings switches reach the app. They all used to be stored
// and then read by nobody: flipping Dark Mode or Reduce Animations changed a
// value in storage and nothing on screen.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/app_settings_service.dart';
import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/widgets/app_tint_shell.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('settings').path,
    );
    await GetStorage.init();
    Get.testMode = true;
  });

  setUp(() async {
    GetStorage().erase();
    Get.reset();
  });

  testWidgets('dark mode tints the whole app, not just dialogs',
      (tester) async {
    final settings = Get.put(AppSettingsService());

    await tester.pumpWidget(GetMaterialApp(
      home: const AppTintShell(child: SizedBox()),
    ));
    await tester.pump();

    expect(find.byType(ColorFiltered), findsNothing,
        reason: 'nothing to tint while the switch is off');

    await settings.setDarkMode(true);
    await tester.pump();

    // Every screen paints its own gradient, so a filter over the finished
    // frame is what actually darkens them.
    expect(find.byType(ColorFiltered), findsOneWidget);
  });

  testWidgets('eye-friendly mode tints too, and the two are exclusive',
      (tester) async {
    final settings = Get.put(AppSettingsService());

    await tester.pumpWidget(GetMaterialApp(
      home: const AppTintShell(child: SizedBox()),
    ));
    await settings.setEyeFriendlyMode(true);
    await tester.pump();

    expect(find.byType(ColorFiltered), findsOneWidget);
    expect(settings.isDarkMode.value, isFalse);

    await settings.setDarkMode(true);
    await tester.pump();
    expect(settings.isEyeFriendlyMode.value, isFalse);
  });

  test('the theme mode at startup follows the stored switch', () async {
    expect(AppSettingsService.startupThemeMode(), ThemeMode.light);

    await GetStorage().write(AppSettingsService.kDarkMode, true);
    expect(AppSettingsService.startupThemeMode(), ThemeMode.dark);
  });

  test('reduce animations is read back and caps the image cache', () async {
    await GetStorage().write('reducedAnimations', true);
    await GetStorage().write('lowQualityImages', true);

    DeviceTuning.load(GetStorage());

    expect(DeviceTuning.reducedAnimations.value, isTrue);
    expect(PaintingBinding.instance.imageCache.maximumSizeBytes, 20 << 20,
        reason: 'the low-quality switch really shrinks the cache');

    await GetStorage().write('lowQualityImages', false);
    DeviceTuning.load(GetStorage());
    expect(PaintingBinding.instance.imageCache.maximumSizeBytes, 100 << 20);
  });

  test('the UI scale preference reaches every sized box', () async {
    await GetStorage().write('uiScale', 1.1);
    await GetStorage().write('largeUI', false);
    DeviceTuning.load(GetStorage());

    R.update(const MediaQueryData(size: Size(375, 812)));
    final scaled = R.scale;

    await GetStorage().write('uiScale', 1.0);
    DeviceTuning.load(GetStorage());
    R.update(const MediaQueryData(size: Size(375, 812)));

    expect(scaled, greaterThan(R.scale),
        reason: 'the slider used to be stored and read by nobody');
  });

  test('the UI scale is clamped so the layout cannot burst', () async {
    await GetStorage().write('uiScale', 5.0);
    await GetStorage().write('largeUI', true);
    DeviceTuning.load(GetStorage());

    // Every fixed-height card in the app rides on this number.
    expect(DeviceTuning.uiScale.value, lessThanOrEqualTo(1.15));
    expect(DeviceTuning.uiScale.value, greaterThanOrEqualTo(0.9));
  });

  test('landscape support is read back off storage', () async {
    await GetStorage().write('landscapeSupport', false);
    DeviceTuning.load(GetStorage());
    expect(DeviceTuning.landscapeAllowed.value, isFalse);

    await GetStorage().write('landscapeSupport', true);
    DeviceTuning.load(GetStorage());
    expect(DeviceTuning.landscapeAllowed.value, isTrue);
  });

  testWidgets('reduce animations reaches the widget tree', (tester) async {
    await GetStorage().write('reducedAnimations', true);
    DeviceTuning.load(GetStorage());

    late BuildContext inner;
    await tester.pumpWidget(GetMaterialApp(
      home: ResponsiveShell(
        child: Builder(builder: (context) {
          inner = context;
          return const SizedBox();
        }),
      ),
    ));
    await tester.pump();

    expect(MediaQuery.of(inner).disableAnimations, isTrue);
  });
}
