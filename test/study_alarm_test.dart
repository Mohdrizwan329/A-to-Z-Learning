// Pins the study alarm list: what is stored, what comes back after a restart,
// and the ids each alarm hands the OS. Scheduling itself goes over a platform
// channel that a test run has no implementation for, so those calls fail
// harmlessly and the state around them is what is checked here.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/study_alarm_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('alarms').path,
    );
    await GetStorage.init();
  });

  setUp(() async => GetStorage().erase());

  test('an added alarm is kept, in time order', () async {
    final service = StudyAlarmService();
    await service.add(
      time: const TimeOfDay(hour: 19, minute: 30),
      label: 'Revision',
    );
    await service.add(
      time: const TimeOfDay(hour: 7, minute: 0),
      label: 'Morning maths',
    );

    expect(service.alarms.map((a) => a.label), ['Morning maths', 'Revision']);
  });

  test('a restart brings the alarms back', () async {
    final first = StudyAlarmService();
    await first.add(
      time: const TimeOfDay(hour: 17, minute: 15),
      label: 'Homework',
      days: {DateTime.monday, DateTime.wednesday},
    );

    // A second instance stands in for the app being reopened.
    final reopened = StudyAlarmService();
    await reopened.init();

    expect(reopened.alarms.length, 1);
    final alarm = reopened.alarms.first;
    expect(alarm.hour, 17);
    expect(alarm.minute, 15);
    expect(alarm.label, 'Homework');
    expect(alarm.days, {DateTime.monday, DateTime.wednesday});
    expect(alarm.enabled, isTrue);
  });

  test('an empty label falls back rather than showing a blank card', () async {
    final service = StudyAlarmService();
    final alarm = await service.add(
      time: const TimeOfDay(hour: 6, minute: 0),
      label: '   ',
    );
    expect(alarm.label, 'Study time');
  });

  test('switching an alarm off is remembered', () async {
    final service = StudyAlarmService();
    final alarm = await service.add(
      time: const TimeOfDay(hour: 20, minute: 0),
      label: 'Reading',
    );

    await service.toggle(alarm, false);
    expect(service.alarms.single.enabled, isFalse);

    final reopened = StudyAlarmService();
    await reopened.init();
    expect(reopened.alarms.single.enabled, isFalse);
  });

  test('deleting one alarm leaves the others alone', () async {
    final service = StudyAlarmService();
    final morning = await service.add(
      time: const TimeOfDay(hour: 7, minute: 0),
      label: 'Morning',
    );
    await service.add(
      time: const TimeOfDay(hour: 19, minute: 0),
      label: 'Evening',
    );

    await service.remove(morning);

    expect(service.alarms.map((a) => a.label), ['Evening']);

    final reopened = StudyAlarmService();
    await reopened.init();
    expect(reopened.alarms.map((a) => a.label), ['Evening']);
  });

  test('a deleted id is free again, but never while it is in use', () async {
    final service = StudyAlarmService();
    final a = await service.add(
      time: const TimeOfDay(hour: 7, minute: 0),
      label: 'A',
    );
    final b = await service.add(
      time: const TimeOfDay(hour: 8, minute: 0),
      label: 'B',
    );
    expect(a.id == b.id, isFalse, reason: 'a live id must not be reused');

    await service.remove(a);
    final c = await service.add(
      time: const TimeOfDay(hour: 9, minute: 0),
      label: 'C',
    );
    expect(c.id, a.id, reason: 'the freed id is fine to hand out again');
  });

  test('no days picked means every day', () {
    final daily = StudyAlarm(
      id: 1,
      hour: 8,
      minute: 0,
      label: 'Study',
      days: const {},
    );
    expect(daily.isDaily, isTrue);
    expect(StudyAlarmService.daysLabel(daily), 'Every day');

    final all = StudyAlarm(
      id: 2,
      hour: 8,
      minute: 0,
      label: 'Study',
      days: const {1, 2, 3, 4, 5, 6, 7},
    );
    expect(all.isDaily, isTrue);
    expect(StudyAlarmService.daysLabel(all), 'Every day');
  });

  test('picked days are listed in week order', () {
    final alarm = StudyAlarm(
      id: 1,
      hour: 8,
      minute: 0,
      label: 'Study',
      days: const {DateTime.friday, DateTime.monday, DateTime.wednesday},
    );
    expect(StudyAlarmService.daysLabel(alarm), 'Mon, Wed, Fri');
  });

  test('a stored alarm with junk days is not trusted blindly', () {
    final alarm = StudyAlarm.fromJson({
      'id': 3,
      'hour': 9,
      'minute': 5,
      'label': 'Science',
      'days': [0, 3, 9, 7],
      'enabled': true,
    });
    expect(alarm.days, {DateTime.wednesday, DateTime.sunday});
  });
}
