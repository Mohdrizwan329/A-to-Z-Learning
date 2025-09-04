import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TableController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  static const List<String> hindiMultipliers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];

  final expandedIndexes = <int>{}.obs;
  static const _cacheKey = 'expandedTables';

  DateTime _lastWriteTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const _writeCooldown = Duration(milliseconds: 300);

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
    if (Platform.isAndroid || Platform.isIOS) {
      await flutterTts.setLanguage("hi-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
    }
  }

  void _loadFromCache() {
    final saved = box.read<List>(_cacheKey);
    if (saved != null && saved.isNotEmpty) {
      expandedIndexes.addAll(saved.cast<int>());
    }
  }

  void _saveToCache() {
    final now = DateTime.now();
    if (now.difference(_lastWriteTime) > _writeCooldown) {
      box.write(_cacheKey, expandedIndexes.toList(growable: false));
      _lastWriteTime = now;
    }
  }

  Future<void> speakTable(int number) async {
    final pahada = List.generate(
      10,
      (i) => "$number ${hindiMultipliers[i]} ${number * (i + 1)}",
    ).join(", ");

    try {
      await flutterTts.speak(pahada);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void toggleExpanded(int index, int number) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
      speakTable(number);
    }
    _saveToCache();
  }

  void resetExpanded() {
    if (expandedIndexes.isNotEmpty) {
      expandedIndexes.clear();
      _saveToCache();
    }
  }
}
