import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LowercaseAlphabetController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  final _cacheKey = 'selectedLowerAlphabets';
  var selectedIndexes = <int>{}.obs;
  var isTtsReady = false.obs;

  final List<String> alphabets = List.generate(
    26,
    (index) => String.fromCharCode(97 + index),
  );

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
        var engines = await flutterTts.getEngines;
        if (engines != null && engines.isNotEmpty) {
          await flutterTts.setEngine(engines.first.toString());
        }
      }
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.awaitSpeakCompletion(true);
      isTtsReady.value = true;
      debugPrint("Small Alphabet TTS initialized");
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  void _loadFromCache() {
    final saved = box.read<List<dynamic>>(_cacheKey);
    if (saved != null && saved.isNotEmpty) {
      try {
        selectedIndexes.clear();
        selectedIndexes.addAll(saved.cast<int>().toSet());
        debugPrint("Loaded selectedIndexes from cache: $selectedIndexes");
      } catch (e) {
        debugPrint("Error loading cache: $e, clearing cache");
        clearCache();
        selectedIndexes.clear();
      }
    } else {
      debugPrint("No cache found or cache empty");
    }
  }

  Future<void> _saveToCache() async {
    print("Saving selectedIndexes: $selectedIndexes");
    await box.write(_cacheKey, selectedIndexes.toList());
    print("Cache saved");
  }

  Future<void> speak(String text) async {
    debugPrint("Speaking: $text, TTS Ready: ${isTtsReady.value}");
    try {
      await flutterTts.stop();
      var result = await flutterTts.speak(text);
      debugPrint("Speak result: $result");
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  Future<void> handleTap(int index) async {
    final isSelected = selectedIndexes.contains(index);

    if (isSelected) {
      selectedIndexes.clear();
      await _saveToCache();
    } else {
      selectedIndexes
        ..clear()
        ..add(index);
      await _saveToCache();
      await speak(alphabets[index]);
    }
  }

  Future<void> resetSelection() async {
    if (selectedIndexes.isNotEmpty) {
      selectedIndexes.clear();
      await clearCache();
    }
  }

  Future<void> clearCache() async {
    await box.remove(_cacheKey);
  }
}
