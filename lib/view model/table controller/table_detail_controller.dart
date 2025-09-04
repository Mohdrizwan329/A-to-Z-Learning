import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TableDetailController extends GetxController {
  final int number;
  TableDetailController(this.number);

  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  var currentStep = 0.obs;

  var selectedIndex = (-1).obs;

  static final Map<int, int> _stepCache = {};

  final String _storageKeyPrefix = 'table_step_';

  @override
  void onInit() {
    super.onInit();
    _initTts();

    _clearSavedStep();

    _loadSavedStep();
  }

  Future<void> _initTts() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.setLanguage("en-IN");
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.5);
      }
    } catch (e) {
      print("TTS init error: $e");
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  void _clearSavedStep() {
    _stepCache.remove(number);
    try {
      box.remove('$_storageKeyPrefix$number');
    } catch (_) {}
  }

  void _loadSavedStep() {
    if (_stepCache.containsKey(number)) {
      currentStep.value = _stepCache[number]!;
    } else {
      try {
        int? savedStep = box.read<int>('$_storageKeyPrefix$number');
        currentStep.value = savedStep ?? 0;
        _stepCache[number] = currentStep.value;
      } catch (e) {
        currentStep.value = 0;
      }
    }
  }

  void _saveStep() {
    _stepCache[number] = currentStep.value;
    try {
      box.write('$_storageKeyPrefix$number', currentStep.value);
    } catch (e) {
      print("Failed to write step to storage: $e");
    }
  }

  Future<void> _speakRhythmic(int number, int multiplier) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        String part1 = "$number one ja $multiplier";
        int product = number * multiplier;
        String part2 = "$number to ja $product";

        await flutterTts.speak(part1);
        await Future.delayed(const Duration(milliseconds: 1200));
        await flutterTts.speak(part2);
      }
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void onBoxTap(int index) {
    selectedIndex.value = index;

    final multiplier = index + 1;
    _speakRhythmic(number, multiplier);

    if (currentStep.value < index + 1) {
      currentStep.value = index + 1;
      _saveStep();
    }
  }

  void resetStep() {
    currentStep.value = 0;
    selectedIndex.value = -1;
    _saveStep();
  }
}
