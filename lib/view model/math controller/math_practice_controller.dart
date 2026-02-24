import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class MathPracticeController extends GetxController {
  final String operatorSymbol;
  final String? progressKey;

  MathPracticeController({
    required this.operatorSymbol,
    this.progressKey,
  });

  final FlutterTts flutterTts = FlutterTts();
  final Random _random = Random();

  final selectedIndex = (-1).obs;
  final problems = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    generateProblems();
    _initTts();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  Future<void> _initTts() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.awaitSpeakCompletion(false);
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  void generateProblems() {
    problems.value = List.generate(90, (index) {
      int a = _random.nextInt(10) + 1;
      int b = _random.nextInt(10) + 1;

      if (operatorSymbol == '-') {
        if (a < b) {
          int t = a;
          a = b;
          b = t;
        }
      } else if (operatorSymbol == '÷') {
        b = _random.nextInt(9) + 1;
        a = b * (_random.nextInt(10) + 1);
        return "$a ÷ $b = ${a ~/ b}";
      }

      if (operatorSymbol == '×') return "$a × $b = ${a * b}";
      if (operatorSymbol == '+') return "$a + $b = ${a + b}";
      if (operatorSymbol == '-') return "$a - $b = ${a - b}";
      return "$a * $b = ${a * b}";
    });
  }

  Future<void> _speak(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(text
          .replaceAll('×', 'times')
          .replaceAll('÷', 'divided by')
          .replaceAll('+', 'plus')
          .replaceAll('-', 'minus')
          .replaceAll('=', 'equals'));
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  void handleTap(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
      _speak(problems[index]);
      if (progressKey != null) {
        ProgressService.to.markItemCompleted(progressKey!, index);
      }
    }
  }

  bool isItemDone(int index) {
    if (progressKey == null) return false;
    return ProgressService.to.isItemCompleted(progressKey!, index);
  }

  void resetAll() {
    selectedIndex.value = -1;
    generateProblems();
    if (progressKey != null) {
      ProgressService.to.resetProgress(progressKey!);
    }
  }
}
