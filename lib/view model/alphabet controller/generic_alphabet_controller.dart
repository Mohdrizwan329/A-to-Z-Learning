import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

/// Enum for alphabet types
enum AlphabetType { capital, small }

/// Configuration for alphabet types
class AlphabetConfig {
  final String title;
  final String emoji;
  final String progressKey;
  final String cacheKey;
  final int startCharCode; // 65 for A, 97 for a

  const AlphabetConfig({
    required this.title,
    required this.emoji,
    required this.progressKey,
    required this.cacheKey,
    required this.startCharCode,
  });
}

/// Generic Alphabet Controller that handles both capital and small letters
class GenericAlphabetController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();
  final ProgressService _progressService = Get.find<ProgressService>();

  final AlphabetType type;
  late final AlphabetConfig config;

  var selectedIndexes = <int>{}.obs;
  var isTtsReady = false.obs;

  late final List<String> alphabets;

  GenericAlphabetController({required this.type}) {
    config = _getConfig(type);
    alphabets = List.generate(
      26,
      (index) => String.fromCharCode(config.startCharCode + index),
    );
  }

  AlphabetConfig _getConfig(AlphabetType type) {
    switch (type) {
      case AlphabetType.capital:
        return AlphabetConfig(
          title: 'Capital Letters',
          emoji: '🔠',
          progressKey: ProgressService.kCapitalLetters,
          cacheKey: 'selectedAlphabets',
          startCharCode: 65, // 'A'
        );
      case AlphabetType.small:
        return AlphabetConfig(
          title: 'Small Letters',
          emoji: '🔡',
          progressKey: ProgressService.kSmallLetters,
          cacheKey: 'selectedLowerAlphabets',
          startCharCode: 97, // 'a'
        );
    }
  }

  String get title => config.title;
  String get emoji => config.emoji;

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
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
      await flutterTts.awaitSpeakCompletion(false);
      isTtsReady.value = true;
      debugPrint("${config.title} TTS initialized");
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  void _loadFromCache() {
    final saved = box.read<List<dynamic>>(config.cacheKey);
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
    debugPrint("Saving selectedIndexes: $selectedIndexes");
    await box.write(config.cacheKey, selectedIndexes.toList());
    debugPrint("Cache saved");
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
      // Mark this letter as learned/completed
      _progressService.markItemCompleted(config.progressKey, index);
    }
  }

  // Get progress percentage
  double get progressPercentage =>
      _progressService.getProgressPercentage(config.progressKey);

  // Get progress string
  String get progressString =>
      _progressService.getProgressString(config.progressKey);

  // Check if a letter is completed
  bool isLetterCompleted(int index) =>
      _progressService.isItemCompleted(config.progressKey, index);

  Future<void> resetSelection() async {
    selectedIndexes.clear();
    await clearCache();
    // Reset progress as well
    _progressService.resetProgress(config.progressKey);
  }

  Future<void> clearCache() async {
    await box.remove(config.cacheKey);
  }
}
