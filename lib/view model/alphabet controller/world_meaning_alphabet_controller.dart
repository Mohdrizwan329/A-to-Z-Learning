import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WorldMeaningAlphabetController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

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
    {"letter": "N", "emoji": "👃", "meaning": "Nose"},
    {"letter": "O", "emoji": "🍊", "meaning": "Orange"},
    {"letter": "P", "emoji": "🦜", "meaning": "Parrot"},
    {"letter": "Q", "emoji": "👸", "meaning": "Queen"},
    {"letter": "R", "emoji": "🐰", "meaning": "Rabbit"},
    {"letter": "S", "emoji": "☀️", "meaning": "Sun"},
    {"letter": "T", "emoji": "🐯", "meaning": "Tiger"},
    {"letter": "U", "emoji": "☂️", "meaning": "Umbrella"},
    {"letter": "V", "emoji": "🚐", "meaning": "Van"},
    {"letter": "W", "emoji": "⌚", "meaning": "Watch"},
    {"letter": "X", "emoji": "🎄", "meaning": "X-mas Tree"},
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
  }

  Future<void> loadCache() async {
    final saved = box.read<List>('alphabet_selected');
    if (saved != null && saved.isNotEmpty) {
      selectedIndexes.assignAll(saved.cast<int>());
      print("Loaded cached indexes: $selectedIndexes");
    }
  }

  void _saveCacheDebounced() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 400), () {
      box.write('alphabet_selected', selectedIndexes.toList());
      print("Cache saved: $selectedIndexes");
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
      print("TTS Error: $e");
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
    }
  }

  Future<void> clearCache() async {
    selectedIndexes.clear();
    await box.remove('alphabet_selected');
    print("Cache cleared");
  }

  @override
  void onClose() {
    clearCache();
    _saveDebounce?.cancel();
    stopTTS();
    super.onClose();
  }
}
