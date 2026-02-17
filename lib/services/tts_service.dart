import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

/// Centralized Text-To-Speech service for the entire app
/// Handles TTS initialization, language settings, and speech
class TtsService extends GetxService {
  static TtsService get to => Get.find<TtsService>();

  final FlutterTts _flutterTts = FlutterTts();
  final RxBool isReady = false.obs;
  final RxBool isSpeaking = false.obs;
  final Rx<TtsLanguage> currentLanguage = TtsLanguage.english.obs;

  FlutterTts get tts => _flutterTts;

  /// Initialize the TTS service
  Future<TtsService> init() async {
    await _initTts();
    return this;
  }

  Future<void> _initTts() async {
    try {
      if (Platform.isIOS) {
        await _flutterTts.setSharedInstance(true);
        await _flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      } else if (Platform.isAndroid) {
        var engines = await _flutterTts.getEngines;
        if (engines != null && engines.isNotEmpty) {
          await _flutterTts.setEngine(engines.first.toString());
        }
      }

      await _setDefaultSettings();

      _flutterTts.setStartHandler(() {
        isSpeaking.value = true;
      });

      _flutterTts.setCompletionHandler(() {
        isSpeaking.value = false;
      });

      _flutterTts.setCancelHandler(() {
        isSpeaking.value = false;
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint("TTS Error: $msg");
        isSpeaking.value = false;
      });

      isReady.value = true;
      debugPrint("TTS Service initialized successfully");
    } catch (e) {
      debugPrint("TTS Init Error: $e");
      isReady.value = false;
    }
  }

  Future<void> _setDefaultSettings() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(false);
  }

  /// Speak text in current language
  Future<void> speak(String text) async {
    if (!isReady.value) {
      debugPrint("TTS not ready, cannot speak: $text");
      return;
    }

    try {
      await stop();
      await _flutterTts.speak(text);
      debugPrint("Speaking: $text");
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  /// Speak text in English
  Future<void> speakEnglish(String text) async {
    await setLanguage(TtsLanguage.english);
    await speak(text);
  }

  /// Speak text in Hindi
  Future<void> speakHindi(String text) async {
    await setLanguage(TtsLanguage.hindi);
    await speak(text);
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      isSpeaking.value = false;
    } catch (e) {
      debugPrint("TTS Stop Error: $e");
    }
  }

  /// Set TTS language
  Future<void> setLanguage(TtsLanguage language) async {
    if (currentLanguage.value == language) return;

    try {
      String languageCode;
      switch (language) {
        case TtsLanguage.english:
          languageCode = "en-US";
          break;
        case TtsLanguage.englishIndia:
          languageCode = "en-IN";
          break;
        case TtsLanguage.hindi:
          languageCode = "hi-IN";
          break;
      }
      await _flutterTts.setLanguage(languageCode);
      currentLanguage.value = language;
      debugPrint("TTS Language set to: $languageCode");
    } catch (e) {
      debugPrint("TTS Set Language Error: $e");
    }
  }

  /// Set speech rate (0.0 to 1.0, default 0.5)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate.clamp(0.0, 1.0));
    } catch (e) {
      debugPrint("TTS Set Rate Error: $e");
    }
  }

  /// Set pitch (0.5 to 2.0, default 1.0)
  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch.clamp(0.5, 2.0));
    } catch (e) {
      debugPrint("TTS Set Pitch Error: $e");
    }
  }

  /// Set volume (0.0 to 1.0, default 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      debugPrint("TTS Set Volume Error: $e");
    }
  }

  /// Configure for child-friendly speech (slower, higher pitch)
  Future<void> setChildFriendlySettings() async {
    await setSpeechRate(0.4);
    await setPitch(1.2);
  }

  /// Reset to default settings
  Future<void> resetSettings() async {
    await _setDefaultSettings();
    currentLanguage.value = TtsLanguage.english;
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}

enum TtsLanguage {
  english,
  englishIndia,
  hindi,
}

/// Mixin for controllers that need TTS functionality
/// Use this when you don't want to directly depend on TtsService
mixin TtsMixin {
  TtsService get ttsService => TtsService.to;

  bool get isTtsReady => ttsService.isReady.value;
  bool get isTtsSpeaking => ttsService.isSpeaking.value;

  Future<void> speak(String text) => ttsService.speak(text);
  Future<void> speakEnglish(String text) => ttsService.speakEnglish(text);
  Future<void> speakHindi(String text) => ttsService.speakHindi(text);
  Future<void> stopSpeaking() => ttsService.stop();
}
