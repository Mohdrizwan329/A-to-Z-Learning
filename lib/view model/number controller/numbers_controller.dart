import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
  var isTtsReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
  }

  @override
  void onReady() {
    super.onReady();
    _initTts();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  Future<void> _initTts() async {
    try {
      // Set handlers first
      flutterTts.setStartHandler(() {
        debugPrint("TTS Started");
      });

      flutterTts.setCompletionHandler(() {
        debugPrint("TTS Completed");
      });

      flutterTts.setErrorHandler((msg) {
        debugPrint("TTS Error: $msg");
      });

      // Get available languages
      var languages = await flutterTts.getLanguages;
      debugPrint("Available languages: $languages");

      // Platform specific settings
      if (Platform.isIOS) {
        await flutterTts.setSharedInstance(true);
        await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      } else if (Platform.isAndroid) {
        // Android specific - ensure we use default engine
        var engines = await flutterTts.getEngines;
        if (engines != null && engines.isNotEmpty) {
          await flutterTts.setEngine(engines.first.toString());
        }
      }

      // Set common properties
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.awaitSpeakCompletion(true);

      // Check if engine is available
      var engines = await flutterTts.getEngines;
      debugPrint("Available engines: $engines");

      isTtsReady.value = true;
      debugPrint("TTS initialized successfully");
    } catch (e) {
      debugPrint("TTS Init Error: $e");
      isTtsReady.value = false;
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
    debugPrint("Trying to speak: $text, TTS Ready: ${isTtsReady.value}");
    try {
      // Stop any ongoing speech first
      await flutterTts.stop();
      var result = await flutterTts.speak(text);
      debugPrint("Speak result: $result");
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
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
