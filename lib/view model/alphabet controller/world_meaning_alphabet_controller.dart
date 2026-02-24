import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class WorldMeaningAlphabetController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();
  final ProgressService _progressService = Get.find<ProgressService>();

  final List<Map<String, String>> alphabetData = [
    {"letter": "A", "emoji": "🍎", "meaning": "Apple"},
    {"letter": "B", "emoji": "🍌", "meaning": "Banana"},
    {"letter": "C", "emoji": "🐱", "meaning": "Cat"},
    {"letter": "D", "emoji": "🐶", "meaning": "Dog"},
    {"letter": "E", "emoji": "🐘", "meaning": "Elephant"},
    {"letter": "F", "emoji": "🐸", "meaning": "Frog"},
    {"letter": "G", "emoji": "🍇", "meaning": "Grapes"},
    {"letter": "H", "emoji": "🐴", "meaning": "Horse"},
    {"letter": "I", "emoji": "🍦", "meaning": "Ice Cream"},
    {"letter": "J", "emoji": "🫙", "meaning": "Jar"},
    {"letter": "K", "emoji": "🪁", "meaning": "Kite"},
    {"letter": "L", "emoji": "🦁", "meaning": "Lion"},
    {"letter": "M", "emoji": "🐒", "meaning": "Monkey"},
    {"letter": "N", "emoji": "🔢", "meaning": "Numbers"},
    {"letter": "O", "emoji": "🍊", "meaning": "Orange"},
    {"letter": "P", "emoji": "🦜", "meaning": "Parrot"},
    {"letter": "Q", "emoji": "👸", "meaning": "Queen"},
    {"letter": "R", "emoji": "🐰", "meaning": "Rabbit"},
    {"letter": "S", "emoji": "☀️", "meaning": "Sun"},
    {"letter": "T", "emoji": "🐯", "meaning": "Tiger"},
    {"letter": "U", "emoji": "☂️", "meaning": "Umbrella"},
    {"letter": "V", "emoji": "🎻", "meaning": "Violin"},
    {"letter": "W", "emoji": "🐋", "meaning": "Whale"},
    {"letter": "X", "emoji": "🔬", "meaning": "X-ray"},
    {"letter": "Y", "emoji": "🪀", "meaning": "Yo-Yo"},
    {"letter": "Z", "emoji": "🦓", "meaning": "Zebra"},
  ];

  final RxSet<int> selectedIndexes = <int>{}.obs;
  List<String> letters = [];

  Timer? _saveDebounce;

  @override
  void onInit() {
    super.onInit();
    letters = alphabetData.map((e) => e['letter']!).toList();
    loadCache();
    _initTts(); // Initialize TTS early
  }

  Future<void> _initTts() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.setLanguage("en-IN");
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.setVolume(1.0);
        await flutterTts.awaitSpeakCompletion(false);
      }
    } catch (e) {
      debugPrint("World Meaning TTS Init Error: $e");
    }
  }

  Future<void> loadCache() async {
    final saved = box.read<List>('alphabet_selected');
    if (saved != null && saved.isNotEmpty) {
      selectedIndexes.assignAll(saved.cast<int>());
      debugPrint("Loaded cached indexes: $selectedIndexes");
    }
  }

  void _saveCacheDebounced() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 400), () {
      box.write('alphabet_selected', selectedIndexes.toList());
      debugPrint("Cache saved: $selectedIndexes");
    });
  }

  Future<void> speak(String text) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.setLanguage("en-IN");
        await flutterTts.setPitch(1.0);
        await flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  void stopTTS() => flutterTts.stop();
  void toggleSelection({
    required int index,
    required Function(String) showSnack,
  }) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.clear();
      _saveCacheDebounced();
    } else {
      selectedIndexes
        ..clear()
        ..add(index);
      _saveCacheDebounced();

      final letter = alphabetData[index]['letter']!;
      final meaning = alphabetData[index]['meaning']!;
      speak("$letter for $meaning");

      // Mark this letter as learned/completed
      _progressService.markItemCompleted(ProgressService.kAlphabetWords, index);
    }
  }

  // Get progress percentage
  double get progressPercentage => _progressService.getProgressPercentage(ProgressService.kAlphabetWords);

  // Get progress string
  String get progressString => _progressService.getProgressString(ProgressService.kAlphabetWords);

  // Check if a letter is completed
  bool isLetterCompleted(int index) => _progressService.isItemCompleted(ProgressService.kAlphabetWords, index);

  Future<void> clearCache() async {
    selectedIndexes.clear();
    await box.remove('alphabet_selected');
    await _progressService.resetProgress(ProgressService.kAlphabetWords);
    debugPrint("Cache cleared");
  }

  @override
  void onClose() {
    _saveDebounce?.cancel();
    stopTTS();
    super.onClose();
  }
}
