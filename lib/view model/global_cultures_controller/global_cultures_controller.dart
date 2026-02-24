import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class GlobalCulturesController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();
  final ProgressService _progressService = Get.find<ProgressService>();

  final expandedIndexes = <int>{}.obs;
  static const _cacheKey = 'expandedGlobalCultures';

  final List<Map<String, dynamic>> sections = [
    {'title': 'World Cultures', 'emoji': '🌍'},
    {'title': 'Asian Cultures', 'emoji': '🌏'},
    {'title': 'European Cultures', 'emoji': '🏰'},
    {'title': 'African Cultures', 'emoji': '🦁'},
    {'title': 'American Cultures', 'emoji': '🗽'},
    {'title': 'World Greetings', 'emoji': '👋'},
    {'title': 'World Foods', 'emoji': '🍜'},
    {'title': 'World Celebrations', 'emoji': '🎉'},
    {'title': 'Be a World Citizen!', 'emoji': '🌟'},
  ];

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
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.setLanguage("en-IN");
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.setVolume(1.0);
        await flutterTts.awaitSpeakCompletion(false);
      }
    } catch (e) {
      debugPrint("GlobalCultures TTS Init Error: $e");
    }
  }

  void _loadFromCache() {
    final saved = box.read<List>(_cacheKey);
    if (saved != null && saved.isNotEmpty) {
      expandedIndexes.addAll(saved.cast<int>());
    }
  }

  void _saveToCache() {
    box.write(_cacheKey, expandedIndexes.toList(growable: false));
  }

  Future<void> speak(String text) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  void toggleExpanded(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
      _progressService.markItemUncompleted(
        ProgressService.kGlobalCultures,
        index,
      );
    } else {
      expandedIndexes.add(index);
      speak(sections[index]['title']);
      _progressService.markItemCompleted(
        ProgressService.kGlobalCultures,
        index,
      );
    }
    _saveToCache();
  }

  bool isSectionCompleted(int index) =>
      _progressService.isItemCompleted(ProgressService.kGlobalCultures, index);

  void resetExpanded() {
    expandedIndexes.clear();
    _saveToCache();
    _progressService.resetProgress(ProgressService.kGlobalCultures);
  }
}
