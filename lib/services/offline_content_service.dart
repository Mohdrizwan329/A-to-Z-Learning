import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// What one offline category actually costs and whether it is ready.
class OfflineEntry {
  const OfflineEntry({
    required this.id,
    required this.bytes,
    required this.assetCount,
    required this.ready,
  });

  final String id;

  /// Real size on disk, summed from the bundled files this category uses.
  /// Zero for a category whose content is code, not files.
  final int bytes;

  /// How many bundled files this category needs.
  final int assetCount;

  /// True once every one of those files has been read and cached.
  final bool ready;

  /// A category with no files of its own ships inside the app binary, so it
  /// works offline the moment the app is installed -- there is nothing to
  /// fetch and nothing that can be missing.
  bool get isBuiltIn => assetCount == 0;

  Map<String, dynamic> toJson() =>
      {'id': id, 'bytes': bytes, 'assets': assetCount, 'ready': ready};

  static OfflineEntry fromJson(Map<String, dynamic> data) => OfflineEntry(
        id: (data['id'] ?? '').toString(),
        bytes: (data['bytes'] as num?)?.toInt() ?? 0,
        assetCount: (data['assets'] as num?)?.toInt() ?? 0,
        ready: data['ready'] as bool? ?? false,
      );
}

/// Backs the Offline Learning screen with what is really on the device.
///
/// This app's lessons are compiled into it -- number drills, tables, letters
/// and the rest are Dart, not downloads -- so most categories are already
/// usable with no network at all, and this says so rather than playing a
/// progress bar at the user. The categories that do own files (the colouring
/// pages) are really read out of the bundle, byte by byte, and the result is
/// stored so it survives a restart.
class OfflineContentService extends GetxService {
  OfflineContentService({AssetBundle? bundle, GetStorage? box})
      : _bundle = bundle ?? rootBundle,
        _box = box ?? GetStorage();

  final AssetBundle _bundle;
  final GetStorage _box;

  static const String _storageKey = 'offline_ready';

  /// Which bundled folder each category needs. A category missing from here
  /// owns no files: its content is code and ships with the app.
  static const Map<String, String> _assetFolders = {
    'coloring': 'assets/coloring/',
    'drawing_images': 'assets/coloring/',
  };

  /// Everything the service knows, keyed by category id.
  final RxMap<String, OfflineEntry> entries = <String, OfflineEntry>{}.obs;

  /// 0..1 while a category is being read; absent when it is not.
  final RxMap<String, double> progress = <String, double>{}.obs;

  /// Asset paths per folder, read once from the bundle's own manifest.
  final Map<String, List<String>> _folderAssets = {};

  Future<OfflineContentService> init() async {
    try {
      await _loadManifest();
      _loadStored();
    } catch (e) {
      debugPrint('OfflineContentService init error: $e');
    }
    return this;
  }

  // ---------------------------------------------------------------- manifest

  /// The list of files actually bundled with the app.
  Future<void> _loadManifest() async {
    final raw = await _bundle.loadString('AssetManifest.json');
    final manifest = (jsonDecode(raw) as Map<String, dynamic>).keys;

    for (final folder in _assetFolders.values.toSet()) {
      _folderAssets[folder] =
          manifest.where((path) => path.startsWith(folder)).toList()..sort();
    }
  }

  void _loadStored() {
    final raw = _box.read<String>(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      for (final item in (jsonDecode(raw) as List)) {
        if (item is! Map<String, dynamic>) continue;
        final entry = OfflineEntry.fromJson(item);
        if (entry.id.isNotEmpty) entries[entry.id] = entry;
      }
    } catch (e) {
      debugPrint('Stored offline state could not be read: $e');
    }
  }

  Future<void> _save() async {
    await _box.write(
      _storageKey,
      jsonEncode(entries.values.map((e) => e.toJson()).toList()),
    );
  }

  // ------------------------------------------------------------------ lookup

  /// Files this category needs, empty when its content is code.
  List<String> assetsFor(String id) {
    final folder = _assetFolders[id];
    if (folder == null) return const [];
    return _folderAssets[folder] ?? const [];
  }

  bool isReady(String id) => entries[id]?.ready ?? false;

  bool isBuiltIn(String id) => assetsFor(id).isEmpty;

  bool isWorking(String id) => progress.containsKey(id);

  /// What to print under a category: its real size, or that it needs no
  /// download at all.
  String sizeLabel(String id) {
    if (isBuiltIn(id)) return 'Built in';
    final bytes = entries[id]?.bytes ?? 0;
    if (bytes == 0) return '${assetsFor(id).length} files';
    return formatBytes(bytes);
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Total of everything already prepared.
  int get readyBytes => entries.values
      .where((e) => e.ready)
      .fold<int>(0, (sum, e) => sum + e.bytes);

  int get readyCount => entries.values.where((e) => e.ready).length;

  // ----------------------------------------------------------------- prepare

  /// Really reads this category's files out of the bundle and caches them.
  ///
  /// Progress is the share of files read, not a timer. A category whose
  /// content is code is marked ready straight away, because it already is.
  Future<bool> prepare(String id) async {
    if (isWorking(id)) return false;

    final assets = assetsFor(id);
    if (assets.isEmpty) {
      entries[id] = OfflineEntry(id: id, bytes: 0, assetCount: 0, ready: true);
      await _save();
      return true;
    }

    progress[id] = 0;
    var bytes = 0;
    try {
      for (var i = 0; i < assets.length; i++) {
        final data = await _bundle.load(assets[i]);
        bytes += data.lengthInBytes;
        progress[id] = (i + 1) / assets.length;
      }

      entries[id] = OfflineEntry(
        id: id,
        bytes: bytes,
        assetCount: assets.length,
        ready: true,
      );
      await _save();
      return true;
    } catch (e) {
      // A file that will not load means this category is not usable offline,
      // and saying so beats a green tick that lies.
      debugPrint('Could not prepare "$id" for offline use: $e');
      entries[id] = OfflineEntry(
        id: id,
        bytes: bytes,
        assetCount: assets.length,
        ready: false,
      );
      await _save();
      return false;
    } finally {
      progress.remove(id);
    }
  }

  /// Forgets a category, and drops its files from the bundle's cache so the
  /// memory really does come back.
  Future<void> remove(String id) async {
    for (final asset in assetsFor(id)) {
      _bundle.evict(asset);
    }
    entries.remove(id);
    await _save();
  }

  Future<void> removeAll() async {
    for (final id in entries.keys.toList()) {
      for (final asset in assetsFor(id)) {
        _bundle.evict(asset);
      }
    }
    entries.clear();
    await _save();
  }
}
