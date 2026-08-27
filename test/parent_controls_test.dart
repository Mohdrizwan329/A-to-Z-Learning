// Pins that the Parent Dashboard's switches change something. They used to be
// plain fields: flipping one moved a bool and nothing else, and it was back to
// its default on the next visit.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/screen_time_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('controls').path,
    );
    await GetStorage.init();
  });

  setUp(() async => GetStorage().erase());

  test('the screen time switch is remembered after a restart', () async {
    final service = ScreenTimeService();
    await service.toggleScreenTimeLimit(true);
    expect(service.isScreenTimeEnabled.value, isTrue);

    // A second instance stands in for the app being reopened.
    final reopened = ScreenTimeService()..onInit();

    expect(reopened.isScreenTimeEnabled.value, isTrue,
        reason: 'a parental control that forgets itself is not a control');
  });

  test('break reminders are remembered too', () async {
    final service = ScreenTimeService();
    await service.toggleBreakReminder(false);

    final reopened = ScreenTimeService()..onInit();

    expect(reopened.isBreakReminderEnabled.value, isFalse);
  });
}
