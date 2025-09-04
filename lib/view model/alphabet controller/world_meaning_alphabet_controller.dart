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
    {"letter": "B", "emoji": "🐝", "meaning": "Bee"},
    {"letter": "C", "emoji": "🐱", "meaning": "Cat"},
    {"letter": "D", "emoji": "🐶", "meaning": "Dog"},
    {"letter": "E", "emoji": "🥚", "meaning": "Egg"},
    {"letter": "F", "emoji": "🐟", "meaning": "Fish"},
    {"letter": "G", "emoji": "🦒", "meaning": "Giraffe"},
    {"letter": "H", "emoji": "🏠", "meaning": "House"},
    {"letter": "I", "emoji": "🍦", "meaning": "Ice Cream"},
    {"letter": "J", "emoji": "🤹‍♂️", "meaning": "Juggler"},
    {"letter": "K", "emoji": "🦘", "meaning": "Kangaroo"},
    {"letter": "L", "emoji": "🦁", "meaning": "Lion"},
    {"letter": "M", "emoji": "🐒", "meaning": "Monkey"},
    {"letter": "N", "emoji": "🌙", "meaning": "Night"},
    {"letter": "O", "emoji": "🐙", "meaning": "Octopus"},
    {"letter": "P", "emoji": "🅿️", "meaning": "Parking"},
    {"letter": "Q", "emoji": "👸", "meaning": "Queen"},
    {"letter": "R", "emoji": "🚀", "meaning": "Rocket"},
    {"letter": "S", "emoji": "🐍", "meaning": "Snake"},
    {"letter": "T", "emoji": "🌴", "meaning": "Tree"},
    {"letter": "U", "emoji": "☂️", "meaning": "Umbrella"},
    {"letter": "V", "emoji": "🎻", "meaning": "Violin"},
    {"letter": "W", "emoji": "🌊", "meaning": "Water"},
    {"letter": "X", "emoji": "🎶", "meaning": "Xylophone"},
    {"letter": "Y", "emoji": "🛳️", "meaning": "Yacht"},
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
