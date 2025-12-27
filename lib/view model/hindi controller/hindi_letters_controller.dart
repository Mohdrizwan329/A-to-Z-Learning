import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HindiLettersController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage storage = GetStorage();

  final RxList<int> selectedIndexes = <int>[].obs;
  var isTtsReady = false.obs;

  final List<Map<String, String>> letters = [
    {'letter': 'अ', 'emoji': '🍎', 'meaning': 'अनार'},
    {'letter': 'आ', 'emoji': '🥭', 'meaning': 'आम'},
    {'letter': 'इ', 'emoji': '🌿', 'meaning': 'इमली'},
    {'letter': 'ई', 'emoji': '🧱', 'meaning': 'ईंट'},
    {'letter': 'उ', 'emoji': '🦉', 'meaning': 'उल्लू'},
    {'letter': 'ऊ', 'emoji': '🐪', 'meaning': 'ऊँट'},
    {'letter': 'ऋ', 'emoji': '🧘', 'meaning': 'ऋषि'},
    {'letter': 'ए', 'emoji': '🦔', 'meaning': 'एड़ी'},
    {'letter': 'ऐ', 'emoji': '👓', 'meaning': 'ऐनक'},
    {'letter': 'ओ', 'emoji': '🫗', 'meaning': 'ओखली'},
    {'letter': 'औ', 'emoji': '💊', 'meaning': 'औषधि'},

    {'letter': 'क', 'emoji': '🕊️', 'meaning': 'कबूतर'},
    {'letter': 'ख', 'emoji': '🍈', 'meaning': 'खरबूजा'},
    {'letter': 'ग', 'emoji': '🐄', 'meaning': 'गाय'},
    {'letter': 'घ', 'emoji': '🏠', 'meaning': 'घर'},
    {'letter': 'ङ', 'emoji': '🔔', 'meaning': 'अंगूठी'},
    {'letter': 'च', 'emoji': '🥄', 'meaning': 'चम्मच'},
    {'letter': 'छ', 'emoji': '☂️', 'meaning': 'छाता'},
    {'letter': 'ज', 'emoji': '💧', 'meaning': 'जल'},
    {'letter': 'झ', 'emoji': '🛖', 'meaning': 'झोपड़ी'},
    {'letter': 'ञ', 'emoji': '🎒', 'meaning': 'पंजा'},
    {'letter': 'ट', 'emoji': '🍅', 'meaning': 'टमाटर'},
    {'letter': 'ठ', 'emoji': '🥶', 'meaning': 'ठंड'},
    {'letter': 'ड', 'emoji': '🪣', 'meaning': 'डोल'},
    {'letter': 'ढ', 'emoji': '🪘', 'meaning': 'ढोल'},
    {'letter': 'ण', 'emoji': '📿', 'meaning': 'कण'},
    {'letter': 'त', 'emoji': '⚔️', 'meaning': 'तलवार'},
    {'letter': 'थ', 'emoji': '🍽️', 'meaning': 'थाली'},
    {'letter': 'द', 'emoji': '🚪', 'meaning': 'दरवाज़ा'},
    {'letter': 'ध', 'emoji': '🏹', 'meaning': 'धनुष'},
    {'letter': 'न', 'emoji': '🥥', 'meaning': 'नारियल'},
    {'letter': 'प', 'emoji': '🪭', 'meaning': 'पंखा'},
    {'letter': 'फ', 'emoji': '🍇', 'meaning': 'फल'},
    {'letter': 'ब', 'emoji': '💡', 'meaning': 'बल्ब'},
    {'letter': 'भ', 'emoji': '🐻', 'meaning': 'भालू'},
    {'letter': 'म', 'emoji': '🐟', 'meaning': 'मछली'},
    {'letter': 'य', 'emoji': '🚂', 'meaning': 'यात्रा'},
    {'letter': 'र', 'emoji': '🎨', 'meaning': 'रंग'},
    {'letter': 'ल', 'emoji': '🍬', 'meaning': 'लड्डू'},
    {'letter': 'व', 'emoji': '🌲', 'meaning': 'वन'},
    {'letter': 'श', 'emoji': '🦁', 'meaning': 'शेर'},
    {'letter': 'ष', 'emoji': '🔯', 'meaning': 'षट्कोण'},
    {'letter': 'स', 'emoji': '☀️', 'meaning': 'सूरज'},
    {'letter': 'ह', 'emoji': '🐘', 'meaning': 'हाथी'},
    {'letter': 'क्ष', 'emoji': '⚔️', 'meaning': 'क्षत्रिय'},
    {'letter': 'त्र', 'emoji': '🔱', 'meaning': 'त्रिशूल'},
    {'letter': 'ज्ञ', 'emoji': '📚', 'meaning': 'ज्ञान'},
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initTTS();
  }

  Future<void> _initTTS() async {
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
      await flutterTts.setLanguage("hi-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.awaitSpeakCompletion(true);
      isTtsReady.value = true;
      debugPrint("Hindi TTS initialized");
    } catch (e) {
      debugPrint("Hindi TTS Init Error: $e");
    }
  }

  Future<void> toggleSelection({required int index, Function(String)? showSnack}) async {
    if (selectedIndexes.contains(index)) return;

    selectedIndexes.clear();
    selectedIndexes.add(index);

    final letter = letters[index]['letter']!;
    debugPrint("Speaking Hindi letter: $letter, TTS Ready: ${isTtsReady.value}");
    await flutterTts.stop();
    await flutterTts.speak(letter);

    if (showSnack != null) {
      showSnack('${letters[index]['letter']} : ${letters[index]['meaning']}');
    }
  }

  void clearCache() {
    selectedIndexes.clear();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
