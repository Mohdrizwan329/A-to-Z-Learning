import 'dart:async';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MathGridController extends GetxController {
  final String operator;
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  MathGridController(this.operator);

  final problems = <String>[].obs;
  final selectedIndices = <int>{}.obs;

  final Random _random = Random();

  Timer? _saveDebounceTimer;

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _loadSavedData();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
  }

  void _loadSavedData() {
    final savedProblems = box.read<List>('math_problems_$operator');
    final savedSelected = box.read<List>('math_selected_$operator');

    if (savedProblems != null && savedProblems.isNotEmpty) {
      problems.value = savedProblems.cast<String>();
    } else {
      generateProblems();
    }

    if (savedSelected != null) {
      selectedIndices.value = savedSelected.cast<int>().toSet();
    }
  }

  void generateProblems() {
    final List<String> newProblems = List.generate(90, (_) {
      int a = _random.nextInt(10) + 1;
      int b = _random.nextInt(10) + 1;

      if (operator == '-') {
        if (a < b) {
          int temp = a;
          a = b;
          b = temp;
        }
      } else if (operator == '÷') {
        b = _random.nextInt(9) + 1;
        a = b * (_random.nextInt(10) + 1);
        return "$a ÷ $b = ${a ~/ b}";
      }

      if (operator == '×') {
        return "$a × $b = ${a * b}";
      } else if (operator == '+') {
        return "$a + $b = ${a + b}";
      } else if (operator == '-') {
        return "$a - $b = ${a - b}";
      } else {
        return "$a * $b = ${a * b}";
      }
    });

    problems.value = newProblems;
    _saveProblems();
  }

  void toggleSelection(int index) async {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else {
      selectedIndices.add(index);
      await _speak(problems[index]);
    }
    selectedIndices.refresh();
    _debouncedSave();
  }

  Future<void> _speak(String text) async {
    final speakText = text
        .replaceAll('×', ' times ')
        .replaceAll('÷', ' divided by ');
    await flutterTts.speak(speakText);
  }

  void resetSelection() {
    selectedIndices.clear();
    _debouncedSave();
  }

  void _debouncedSave() {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(const Duration(seconds: 1), () async {
      await _saveData();
    });
  }

  Future<void> _saveData() async {
    await box.write('math_selected_$operator', selectedIndices.toList());
  }

  Future<void> _saveProblems() async {
    await box.write('math_problems_$operator', problems.toList());
  }

  @override
  void onClose() {
    flutterTts.stop();
    _saveDebounceTimer?.cancel();
    super.onClose();
  }
}
