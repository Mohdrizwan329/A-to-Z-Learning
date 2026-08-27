// Pins the device-local profile copy: what the edit screen saves is what the
// profile card reads back, across a restart, with or without a signed-in
// account.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/user_profile_service.dart';

void main() {
  late Directory docs;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    docs = Directory.systemTemp.createTempSync('user_profile');
    // GetStorage and the photo copy both ask path_provider where to write; in
    // tests nothing answers that channel, so point it at a temp dir.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => docs.path,
    );
    await GetStorage.init();
  });

  setUp(() async => GetStorage().erase());

  test('a fresh device has nothing to show', () async {
    final profile = await UserProfileService().init();
    expect(profile.name.value, '');
    expect(profile.email.value, '');
    expect(profile.phone.value, '');
    expect(profile.location.value, '');
    expect(profile.photoFile, isNull);
  });

  test('saved details come back after a restart', () async {
    await (await UserProfileService().init()).save(
      name: '  Aarav  ',
      email: 'parent@example.com',
      phone: '9876543210',
      location: 'Pune, Maharashtra',
    );

    final reopened = await UserProfileService().init();
    expect(reopened.name.value, 'Aarav');
    expect(reopened.email.value, 'parent@example.com');
    expect(reopened.phone.value, '9876543210');
    expect(reopened.location.value, 'Pune, Maharashtra');
  });

  test('saving one field leaves the others alone', () async {
    final profile = await UserProfileService().init();
    await profile.save(name: 'Aarav', location: 'Pune, Maharashtra');
    await profile.save(location: 'Nashik, Maharashtra');

    expect(profile.name.value, 'Aarav');
    expect(profile.location.value, 'Nashik, Maharashtra');
  });

  test('the photo is copied out of the picker cache and survives a restart',
      () async {
    final cache = Directory.systemTemp.createTempSync('picker_cache');
    final picked = File('${cache.path}/scratch.jpg')
      ..writeAsBytesSync([1, 2, 3]);

    final profile = await UserProfileService().init();
    await profile.savePhoto(picked);

    // The picker's file is free to disappear once it has been copied.
    picked.deleteSync();

    final reopened = await UserProfileService().init();
    expect(reopened.photoFile, isNotNull);
    expect(reopened.photoFile!.readAsBytesSync(), [1, 2, 3]);
  });

  test('a photo that arrives as bytes is stored the same way', () async {
    final profile = await UserProfileService().init();
    await profile.savePhotoBytes(Uint8List.fromList([4, 5, 6]));

    final reopened = await UserProfileService().init();
    expect(reopened.photoFile, isNotNull);
    expect(reopened.photoFile!.readAsBytesSync(), [4, 5, 6]);
  });

  test('removing the photo deletes the file and forgets the path', () async {
    final source = File('${docs.path}/source.jpg')..writeAsBytesSync([9]);
    final profile = await UserProfileService().init();
    await profile.savePhoto(source);
    final stored = File(profile.photoPath.value);

    await profile.removePhoto();

    expect(stored.existsSync(), isFalse);
    expect(profile.photoPath.value, '');
    expect((await UserProfileService().init()).photoFile, isNull);
  });

  test('a path left over from an uninstalled photo is not trusted', () async {
    await GetStorage().write('profile_photo_path', '${docs.path}/gone.jpg');
    final profile = await UserProfileService().init();
    expect(profile.photoPath.value, '');
    expect(profile.photoFile, isNull);
  });

  test('clear wipes everything, including the photo', () async {
    final source = File('${docs.path}/clear_me.jpg')..writeAsBytesSync([7]);
    final profile = await UserProfileService().init();
    await profile.save(name: 'Aarav', email: 'parent@example.com');
    await profile.savePhoto(source);

    await profile.clear();

    final reopened = await UserProfileService().init();
    expect(reopened.name.value, '');
    expect(reopened.email.value, '');
    expect(reopened.photoFile, isNull);
  });

  group('resolveField decides what the profile card shows', () {
    test('a signed-in account beats the device-local copy', () {
      expect(
        UserProfileService.resolveField(
          'Account Name',
          'Saved Name',
          'Guest User',
        ),
        'Account Name',
      );
    });

    test('the device-local copy fills in for a guest', () {
      expect(
        UserProfileService.resolveField('Guest User', 'Aarav', 'Guest User'),
        'Aarav',
      );
      expect(
        UserProfileService.resolveField(
          'Guest',
          'parent@example.com',
          'Guest',
        ),
        'parent@example.com',
      );
      expect(
        UserProfileService.resolveField('', 'Mumbai', 'Location not set'),
        'Mumbai',
      );
    });

    test('the placeholder is the last resort', () {
      expect(
        UserProfileService.resolveField('Guest User', '', 'Guest User'),
        'Guest User',
      );
      expect(
        UserProfileService.resolveField('', '   ', 'Location not set'),
        'Location not set',
      );
    });

    test('a placeholder coming back down is not mistaken for real data', () {
      expect(
        UserProfileService.resolveField(
          'Location not set',
          'Delhi',
          'Location not set',
        ),
        'Delhi',
      );
    });
  });
}
