import 'dart:async';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NumbersController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  static const _cacheKey = 'selectedIndex';
  static const _cacheExpiryKey = 'selectedIndex_expiry';
  static const _cacheLifetime = Duration(days: 7);

  final selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _loadFromCache();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  Future<void> _initTts() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
    }
  }

  void _loadFromCache() {
    final expiry = box.read<int>(_cacheExpiryKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (expiry != null && expiry < now) {
      box.remove(_cacheKey);
      box.remove(_cacheExpiryKey);
      return;
    }

    final saved = box.read<int>(_cacheKey);
    if (saved != null && saved >= 0) {
      selectedIndex.value = saved;
    }
  }

  Future<void> _saveToCache() async {
    await box.write(_cacheKey, selectedIndex.value);
    await box.write(
      _cacheExpiryKey,
      DateTime.now().add(_cacheLifetime).millisecondsSinceEpoch,
    );
  }

  Future<void> speak(String text) async {
    try {
      await flutterTts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void handleTap(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
      speak((index + 1).toString());
    }
    _saveToCache();
  }

  void resetSelection() {
    selectedIndex.value = -1;
    _saveToCache();
  }
}
