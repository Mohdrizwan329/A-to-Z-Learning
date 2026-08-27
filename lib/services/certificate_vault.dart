import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';

/// Remembers the certificates the child has actually saved to the device.
///
/// A download that lands in a folder no one can reach is not a download, so
/// every saved file is recorded here: the screen can then offer to open the
/// one it already made instead of silently writing another copy.
class CertificateVault extends GetxService {
  CertificateVault({GetStorage? box}) : _box = box ?? GetStorage();

  final GetStorage _box;

  static const String _storageKey = 'saved_certificates';

  /// Certificate title -> the file it was saved as.
  final RxMap<String, String> saved = <String, String>{}.obs;

  Future<CertificateVault> init() async {
    _load();
    await pruneMissing();
    return this;
  }

  void _load() {
    final raw = _box.read<String>(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      saved.assignAll(data.map((k, v) => MapEntry(k, v.toString())));
    } catch (e) {
      debugPrint('Saved certificates could not be read: $e');
    }
  }

  Future<void> _save() => _box.write(_storageKey, jsonEncode(saved));

  /// Drops entries whose file is gone -- cleared app data, a manual delete --
  /// so the screen never offers to open something that is not there.
  Future<void> pruneMissing() async {
    var changed = false;
    for (final entry in saved.entries.toList()) {
      if (!File(entry.value).existsSync()) {
        saved.remove(entry.key);
        changed = true;
      }
    }
    if (changed) await _save();
  }

  bool hasSaved(String title) {
    final path = saved[title];
    return path != null && File(path).existsSync();
  }

  String? pathFor(String title) => saved[title];

  Future<void> record(String title, String path) async {
    saved[title] = path;
    await _save();
  }

  /// Puts the certificate in the phone's own gallery, where a parent can
  /// actually find it -- the app's documents folder is private and shows up
  /// in no gallery and no file manager.
  ///
  /// Returns null when it landed, or a message to show the user. The app's
  /// own copy is kept either way, so the in-app "View" still works even if
  /// the gallery refuses.
  Future<String?> saveToGallery(String filePath, {String? album}) async {
    try {
      if (!await Gal.hasAccess(toAlbum: album != null)) {
        final granted = await Gal.requestAccess(toAlbum: album != null);
        if (!granted) {
          return 'Photo permission was declined, so the certificate stayed '
              'inside the app. You can still open it from here.';
        }
      }

      await Gal.putImage(filePath, album: album);
      return null;
    } on GalException catch (e) {
      debugPrint('Could not save to the gallery: ${e.type}');
      return 'Could not save to your gallery (${e.type.message}). The '
          'certificate is still saved inside the app.';
    } catch (e) {
      debugPrint('Could not save to the gallery: $e');
      return 'Could not save to your gallery. The certificate is still '
          'saved inside the app.';
    }
  }

  Future<void> forget(String title) async {
    final path = saved.remove(title);
    if (path != null) {
      try {
        final file = File(path);
        if (file.existsSync()) await file.delete();
      } catch (e) {
        debugPrint('Could not delete the saved certificate: $e');
      }
    }
    await _save();
  }

  /// Opens a saved certificate in whatever the device uses for images.
  /// Returns null on success, or a message to show the user.
  Future<String?> open(String title) async {
    final path = saved[title];
    if (path == null) return 'That certificate has not been saved yet.';
    if (!File(path).existsSync()) {
      saved.remove(title);
      await _save();
      return 'The saved file is no longer on this device.';
    }

    try {
      final result = await OpenFile.open(path);
      if (result.type == ResultType.done) return null;
      return result.message.isEmpty
          ? 'No app on this device can open the certificate.'
          : result.message;
    } catch (e) {
      debugPrint('Could not open the certificate: $e');
      return 'Could not open the certificate.';
    }
  }
}
