import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

/// The user's own profile details -- name, email, phone, location and photo --
/// kept on the device.
///
/// Firebase already stores these for a signed-in account, but the profile card
/// has to show something real for a guest too, and Firestore never held the
/// photo at all. This service is the local copy: the edit screen writes here on
/// every save, and the profile card falls back to it whenever the Firebase user
/// model is missing a field.
class UserProfileService extends GetxService {
  final GetStorage _box = GetStorage();

  static const _kName = 'profile_name';
  static const _kEmail = 'profile_email';
  static const _kPhone = 'profile_phone';
  static const _kLocation = 'profile_location';
  static const _kPhotoPath = 'profile_photo_path';

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString location = ''.obs;
  final RxString photoPath = ''.obs;

  Future<UserProfileService> init() async {
    name.value = _box.read<String>(_kName) ?? '';
    email.value = _box.read<String>(_kEmail) ?? '';
    phone.value = _box.read<String>(_kPhone) ?? '';
    location.value = _box.read<String>(_kLocation) ?? '';

    final storedPhoto = _box.read<String>(_kPhotoPath) ?? '';
    // A path can outlive the file it points at -- an app reinstall or an OS
    // cache sweep -- so only keep it while the file is really there.
    photoPath.value =
        storedPhoto.isNotEmpty && File(storedPhoto).existsSync() ? storedPhoto : '';

    return this;
  }

  /// The photo file, or null when the user has not set one.
  File? get photoFile {
    final path = photoPath.value;
    if (path.isEmpty) return null;
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  Future<void> save({
    String? name,
    String? email,
    String? phone,
    String? location,
  }) async {
    if (name != null) {
      this.name.value = name.trim();
      await _box.write(_kName, this.name.value);
    }
    if (email != null) {
      this.email.value = email.trim();
      await _box.write(_kEmail, this.email.value);
    }
    if (phone != null) {
      this.phone.value = phone.trim();
      await _box.write(_kPhone, this.phone.value);
    }
    if (location != null) {
      this.location.value = location.trim();
      await _box.write(_kLocation, this.location.value);
    }
  }

  /// Copies [source] into app storage and remembers it as the profile photo.
  ///
  /// The picker hands back a file in a cache directory the OS is free to clear,
  /// so the image has to be copied somewhere durable before we store its path.
  Future<void> savePhoto(File source) async {
    final lastDot = source.path.lastIndexOf('.');
    final extension = lastDot > source.path.lastIndexOf('/')
        ? source.path.substring(lastDot)
        : '.jpg';
    await savePhotoBytes(await source.readAsBytes(), extension: extension);
  }

  /// Stores [bytes] as the profile photo.
  ///
  /// For a picture that arrives as data rather than as a file -- the signup
  /// photo, which is held as base64 -- so the profile screens can show it
  /// before the account has ever been read back.
  Future<void> savePhotoBytes(Uint8List bytes, {String extension = '.jpg'}) async {
    final dir = await getApplicationDocumentsDirectory();
    final destination = File('${dir.path}/profile_photo$extension');

    // Delete the previous photo when the new one has a different extension,
    // otherwise the old file is simply overwritten by the copy below.
    final previous = photoPath.value;
    if (previous.isNotEmpty && previous != destination.path) {
      final oldFile = File(previous);
      if (oldFile.existsSync()) {
        await oldFile.delete();
      }
    }

    await destination.writeAsBytes(bytes, flush: true);
    photoPath.value = destination.path;
    await _box.write(_kPhotoPath, destination.path);
  }

  Future<void> removePhoto() async {
    final path = photoPath.value;
    if (path.isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    photoPath.value = '';
    await _box.remove(_kPhotoPath);
  }

  /// Picks what the profile card should show for one field.
  ///
  /// The signed-in account wins where it holds a real value; the copy saved on
  /// this device fills in for a guest; [placeholder] is the last resort. The
  /// guest strings the navigation shell passes down are treated as "nothing",
  /// not as a name.
  static String resolveField(
    String fromAccount,
    String saved,
    String placeholder,
  ) {
    const guestValues = {'Guest', 'Guest User'};
    final account = fromAccount.trim();
    if (account.isNotEmpty &&
        !guestValues.contains(account) &&
        account != placeholder) {
      return account;
    }
    final local = saved.trim();
    if (local.isNotEmpty) return local;
    return placeholder;
  }

  Future<void> clear() async {
    await removePhoto();
    name.value = '';
    email.value = '';
    phone.value = '';
    location.value = '';
    await _box.remove(_kName);
    await _box.remove(_kEmail);
    await _box.remove(_kPhone);
    await _box.remove(_kLocation);
  }
}
