import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Enum for math operation types
enum MathOperationType { addition, subtraction, multiplication, division }

/// Question model for math problems
class MathQuestionModel {
  final int num1;
  final int num2;
  final TextEditingController controller;
  String result;
  bool isAnswered;

  MathQuestionModel(this.num1, this.num2)
      : controller = TextEditingController(),
        result = '',
        isAnswered = false;

  Map<String, dynamic> toJson() => {
        'num1': num1,
        'num2': num2,
        'result': result,
        'isAnswered': isAnswered,
        'answerText': controller.text,
      };

  static MathQuestionModel fromJson(Map<String, dynamic> json) {
    final question = MathQuestionModel(json['num1'], json['num2']);
    question.result = json['result'] ?? '';
    question.isAnswered = json['isAnswered'] ?? false;
    question.controller.text = json['answerText'] ?? '';
    return question;
  }

  void dispose() {
    controller.dispose();
  }
}

/// Configuration for each operation type
class MathOperationConfig {
  final String title;
  final String emoji;
  final String symbol;
  final String storageKeyPrefix;
  final int Function(int, int) calculate;
  final List<int> Function(Random) generateNumbers;

  const MathOperationConfig({
    required this.title,
    required this.emoji,
    required this.symbol,
    required this.storageKeyPrefix,
    required this.calculate,
    required this.generateNumbers,
  });
}

/// Generic Math Questions Controller that handles all operation types
class GenericMathQuestionsController extends GetxController {
  final box = GetStorage();
  final questions = <MathQuestionModel>[].obs;
  final RxInt currentBatch = 0.obs;
  final RxInt correct = 0.obs;
  final RxInt incorrect = 0.obs;

  Timer? _saveTimer;

  final MathOperationType operationType;
  late final MathOperationConfig config;

  GenericMathQuestionsController({required this.operationType}) {
    config = _getConfig(operationType);
  }

  MathOperationConfig _getConfig(MathOperationType type) {
    switch (type) {
      case MathOperationType.addition:
        return MathOperationConfig(
          title: 'Addition',
          emoji: '➕',
          symbol: '+',
          storageKeyPrefix: 'addition',
          calculate: (a, b) => a + b,
          generateNumbers: (rand) {
            int a = rand.nextInt(999) + 1;
            int b = rand.nextInt(999) + 1;
            return [a, b];
          },
        );
      case MathOperationType.subtraction:
        return MathOperationConfig(
          title: 'Subtraction',
          emoji: '➖',
          symbol: '-',
          storageKeyPrefix: 'subtraction',
          calculate: (a, b) => a - b,
          generateNumbers: (rand) {
            int a = rand.nextInt(999) + 1;
            int b = rand.nextInt(a) + 1; // Ensure a >= b for positive result
            return [a, b];
          },
        );
      case MathOperationType.multiplication:
        return MathOperationConfig(
          title: 'Multiplication',
          emoji: '✖️',
          symbol: '×',
          storageKeyPrefix: 'multiplication',
          calculate: (a, b) => a * b,
          generateNumbers: (rand) {
            int a = rand.nextInt(20) + 1; // 1-20
            int b = rand.nextInt(20) + 1; // 1-20
            return [a, b];
          },
        );
      case MathOperationType.division:
        return MathOperationConfig(
          title: 'Division',
          emoji: '➗',
          symbol: '÷',
          storageKeyPrefix: 'division',
          calculate: (a, b) => a ~/ b,
          generateNumbers: (rand) {
            int b = rand.nextInt(12) + 1; // Divisor 1-12
            int quotient = rand.nextInt(20) + 1; // Quotient 1-20
            int a = b * quotient; // Ensure clean division
            return [a, b];
          },
        );
    }
  }

  String get title => config.title;
  String get emoji => config.emoji;
  String get symbol => config.symbol;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    final prefix = config.storageKeyPrefix;
    final savedData = box.read('${prefix}_questions');
    final savedBatch = box.read('${prefix}_currentBatch');
    final savedCorrect = box.read('${prefix}_correct');
    final savedIncorrect = box.read('${prefix}_incorrect');

    if (savedData != null && savedBatch != null) {
      currentBatch.value = savedBatch;
      correct.value = savedCorrect ?? 0;
      incorrect.value = savedIncorrect ?? 0;

      final list = (savedData as List)
          .map((e) => MathQuestionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      questions.assignAll(list);
    } else {
      generateNewQuestions();
    }
  }

  void generateNewQuestions() {
    final rand = Random();
    final newQuestions = List.generate(50, (_) {
      final numbers = config.generateNumbers(rand);
      return MathQuestionModel(numbers[0], numbers[1]);
    });

    for (var q in newQuestions) {
      q.controller.clear();
      q.isAnswered = false;
      q.result = '';
    }

    correct.value = 0;
    incorrect.value = 0;
    currentBatch.value = 0;
    questions.assignAll(newQuestions);
    saveData();
  }

  Future<void> saveData() async {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      final prefix = config.storageKeyPrefix;
      final jsonList = questions.map((q) => q.toJson()).toList();
      await box.write('${prefix}_questions', jsonList);
      await box.write('${prefix}_currentBatch', currentBatch.value);
      await box.write('${prefix}_correct', correct.value);
      await box.write('${prefix}_incorrect', incorrect.value);
    });
  }

  void checkAnswer(int index) {
    final question = questions[index];
    final userAnswer = int.tryParse(question.controller.text.trim());
    final correctAnswer = config.calculate(question.num1, question.num2);

    if (userAnswer != null && !question.isAnswered) {
      if (userAnswer == correctAnswer) {
        correct.value++;
      } else {
        incorrect.value++;
      }

      question.result =
          "Your Answer: $userAnswer\nCorrect Answer: $correctAnswer";
      question.isAnswered = true;

      questions.refresh();
      saveData();
    }
  }

  void moveToNextBatch() {
    if (currentBatch.value < (questions.length / 10).ceil() - 1) {
      currentBatch.value++;
      saveData();
    }
  }

  int get startIndex => currentBatch.value * 10;
  int get endIndex => (startIndex + 10).clamp(0, questions.length);

  bool isInCurrentBatch(int index) {
    return index >= startIndex && index < endIndex;
  }

  bool get allAnsweredInBatch {
    return questions.sublist(startIndex, endIndex).every((q) => q.isAnswered);
  }

  void resetAll() {
    generateNewQuestions();
  }

  @override
  void onClose() {
    for (var q in questions) {
      q.dispose();
    }
    _saveTimer?.cancel();
    super.onClose();
  }
}
