// Pins that a saved certificate is really findable afterwards: the path is
// remembered, a file that has gone is forgotten rather than offered, and
// asking to open one that was never saved says so instead of failing oddly.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/certificate_vault.dart';

late Directory _dir;

File _write(String name) {
  final file = File('${_dir.path}/$name')..createSync(recursive: true);
  file.writeAsBytesSync([1, 2, 3]);
  return file;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _dir = Directory.systemTemp.createTempSync('certs');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => _dir.path,
    );
    await GetStorage.init();
  });

  setUp(() async => GetStorage().erase());

  test('a saved certificate is remembered after a restart', () async {
    final file = _write('number_master.png');

    final vault = CertificateVault();
    await vault.record('Number Master', file.path);

    // A second instance stands in for the app being reopened.
    final reopened = CertificateVault();
    await reopened.init();

    expect(reopened.hasSaved('Number Master'), isTrue);
    expect(reopened.pathFor('Number Master'), file.path);
  });

  test('one that was never saved is not claimed', () async {
    final vault = CertificateVault();
    await vault.init();

    expect(vault.hasSaved('Alphabet Ace'), isFalse);
    expect(await vault.open('Alphabet Ace'),
        'That certificate has not been saved yet.');
  });

  test('a file deleted behind the app is forgotten, not offered', () async {
    final file = _write('gone.png');
    final vault = CertificateVault();
    await vault.record('Gone Cert', file.path);
    expect(vault.hasSaved('Gone Cert'), isTrue);

    file.deleteSync();

    expect(vault.hasSaved('Gone Cert'), isFalse,
        reason: 'offering to open a missing file would just fail at the user');

    final reopened = CertificateVault();
    await reopened.init();
    expect(reopened.saved.containsKey('Gone Cert'), isFalse,
        reason: 'init prunes what is no longer there');
  });

  test('forgetting a certificate deletes its file too', () async {
    final file = _write('to_remove.png');
    final vault = CertificateVault();
    await vault.record('To Remove', file.path);

    await vault.forget('To Remove');

    expect(vault.hasSaved('To Remove'), isFalse);
    expect(file.existsSync(), isFalse);
  });

  test('re-saving the same certificate replaces the path', () async {
    final first = _write('cert_v1.png');
    final second = _write('cert_v2.png');

    final vault = CertificateVault();
    await vault.record('Maths Star', first.path);
    await vault.record('Maths Star', second.path);

    expect(vault.pathFor('Maths Star'), second.path);
    expect(vault.saved.length, 1, reason: 'one entry per certificate');
  });
}
