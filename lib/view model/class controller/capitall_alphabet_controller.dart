import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CapitallAlphabetController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  final _cacheKey = 'selectedAlphabets';
  var selectedIndexes = <int>{}.obs;

  final List<String> alphabets = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  void _loadFromCache() {
    final saved = box.read<List<dynamic>>(_cacheKey);
    if (saved != null && saved.isNotEmpty) {
      try {
        selectedIndexes.value = saved.cast<int>().toSet();
        print("Loaded selectedIndexes from cache: $selectedIndexes");
      } catch (e) {
        print("Error loading cache: $e, clearing cache");
        clearCache();
        selectedIndexes.clear();
      }
    } else {
      print("No cache found or cache empty");
    }
  }

  Future<void> _saveToCache() async {
    print("Saving selectedIndexes: $selectedIndexes");
    await box.write(_cacheKey, selectedIndexes.toList());
    print("Cache saved");
  }

  Future<void> speak(String text) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.stop();
        await flutterTts.setLanguage("en-IN");
        await flutterTts.setPitch(1.0);
        await flutterTts.speak(text);
      }
    } catch (e) {
      print("TTS Error: $e");
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
