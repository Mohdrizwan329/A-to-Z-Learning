// Pins that the offline screen tells the truth: a category is "ready" only
// once its files have really been read out of the bundle, a category whose
// lessons are code says so instead of inventing a download, and what was
// prepared is still prepared after a restart.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/offline_content_service.dart';

/// A bundle holding a couple of fake colouring files, so the test does not
/// depend on how many real ones happen to ship.
class _FakeBundle extends CachingAssetBundle {
  _FakeBundle({this.failing = const {}});

  /// Paths that throw when loaded, standing in for a file that is not there.
  final Set<String> failing;

  final List<String> evicted = [];

  static const Map<String, int> _files = {
    'assets/coloring/apple.svg': 300,
    'assets/coloring/apple_filled.svg': 500,
    'assets/coloring/bear.svg': 200,
    'assets/app_logo.png': 900,
  };

  @override
  Future<ByteData> load(String key) async {
    if (failing.contains(key)) {
      throw FlutterError('Unable to load asset: $key');
    }
    final size = _files[key];
    if (size == null) throw FlutterError('Unable to load asset: $key');
    return ByteData(size);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'AssetManifest.json') {
      return jsonEncode({for (final path in _files.keys) path: <String>[]});
    }
    throw FlutterError('Unable to load asset: $key');
  }

  @override
  void evict(String key) {
    evicted.add(key);
    super.evict(key);
  }
}

Future<OfflineContentService> _service({Set<String> failing = const {}}) async {
  final service = OfflineContentService(bundle: _FakeBundle(failing: failing));
  await service.init();
  return service;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('offline').path,
    );
    await GetStorage.init();
  });

  setUp(() async => GetStorage().erase());

  test('a category with files is only ready once they are read', () async {
    final service = await _service();

    expect(service.isBuiltIn('coloring'), isFalse);
    expect(service.isReady('coloring'), isFalse);

    expect(await service.prepare('coloring'), isTrue);

    expect(service.isReady('coloring'), isTrue);
    // 300 + 500 + 200, the real bytes of the files it read.
    expect(service.entries['coloring']!.bytes, 1000);
    expect(service.entries['coloring']!.assetCount, 3);
  });

  test('a category whose lessons are code says so, and needs no download',
      () async {
    final service = await _service();

    expect(service.isBuiltIn('numbers'), isTrue);
    expect(service.sizeLabel('numbers'), 'Built in');

    expect(await service.prepare('numbers'), isTrue);
    expect(service.isReady('numbers'), isTrue);
    // Nothing was fetched, so nothing is claimed.
    expect(service.entries['numbers']!.bytes, 0);
  });

  test('a missing file leaves the category not ready', () async {
    final service = await _service(failing: {'assets/coloring/bear.svg'});

    expect(await service.prepare('coloring'), isFalse);
    expect(service.isReady('coloring'), isFalse,
        reason: 'a green tick over a broken category would be a lie');
    expect(service.isWorking('coloring'), isFalse,
        reason: 'the progress entry must be cleared even on failure');
  });

  test('what was prepared is still prepared after a restart', () async {
    final first = await _service();
    await first.prepare('coloring');

    // A second instance stands in for the app being reopened.
    final reopened = await _service();

    expect(reopened.isReady('coloring'), isTrue);
    expect(reopened.entries['coloring']!.bytes, 1000);
    expect(reopened.readyBytes, 1000);
    expect(reopened.readyCount, 1);
  });

  test('removing a category really drops its files from the cache', () async {
    final bundle = _FakeBundle();
    final service = OfflineContentService(bundle: bundle);
    await service.init();
    await service.prepare('coloring');

    await service.remove('coloring');

    expect(service.isReady('coloring'), isFalse);
    expect(bundle.evicted, contains('assets/coloring/apple.svg'));
    expect(bundle.evicted.length, 3);

    // And it stays removed.
    final reopened = await _service();
    expect(reopened.isReady('coloring'), isFalse);
  });

  test('sizes are reported in units a parent can read', () {
    expect(OfflineContentService.formatBytes(512), '512 B');
    expect(OfflineContentService.formatBytes(2048), '2 KB');
    expect(OfflineContentService.formatBytes(3 * 1024 * 1024), '3.0 MB');
  });
}
