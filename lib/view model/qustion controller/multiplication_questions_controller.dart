import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QuestionModel {
  final int num1;
  final int num2;
  final TextEditingController controller;
  String result;
  bool isAnswered;

  QuestionModel(this.num1, this.num2)
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

  static QuestionModel fromJson(Map<String, dynamic> json) {
    final question = QuestionModel(json['num1'], json['num2']);
    question.result = json['result'] ?? '';
    question.isAnswered = json['isAnswered'] ?? false;
    question.controller.text = json['answerText'] ?? '';
    return question;
  }

  void dispose() {
    controller.dispose();
  }
}

class MultiplicationController extends GetxController {
  final box = GetStorage();
  final questions = <QuestionModel>[].obs;

  final RxInt currentBatch = 0.obs;
  final RxInt correct = 0.obs;
  final RxInt incorrect = 0.obs;

  Timer? _saveTimer;

  int get startIndex => currentBatch.value * 10;
  int get endIndex => min(startIndex + 10, questions.length);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    final savedQuestions = box.read('multiplication_questions');
    final savedBatch = box.read('multiplication_currentBatch');
    final savedCorrect = box.read('multiplication_correct');
    final savedIncorrect = box.read('multiplication_incorrect');

    if (savedQuestions != null) {
      final list = (savedQuestions as List)
          .map((e) => QuestionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      questions.assignAll(list);

      currentBatch.value = savedBatch ?? 0;
      correct.value = savedCorrect ?? 0;
      incorrect.value = savedIncorrect ?? 0;
    } else {
      generateQuestions();
    }
  }

  Future<void> saveData() async {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      final jsonList = questions.map((q) => q.toJson()).toList();
      await box.write('multiplication_questions', jsonList);
      await box.write('multiplication_currentBatch', currentBatch.value);
      await box.write('multiplication_correct', correct.value);
      await box.write('multiplication_incorrect', incorrect.value);
    });
  }

  void generateQuestions() {
    final rand = Random();

    for (var q in questions) {
      q.dispose();
    }

    final newQuestions = List.generate(50, (_) {
      final num1 = rand.nextInt(12) + 1;
      final num2 = rand.nextInt(12) + 1;
      return QuestionModel(num1, num2);
    });

    correct.value = 0;
    incorrect.value = 0;
    currentBatch.value = 0;
    questions.assignAll(newQuestions);
    saveData();
  }

  bool isInCurrentBatch(int index) {
    return index >= startIndex && index < endIndex;
  }

  void checkAnswer(int index, BuildContext context) {
    final question = questions[index];
    final userAnswer = int.tryParse(question.controller.text.trim());
    final correctAnswer = question.num1 * question.num2;

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

      final allAnswered = questions
          .sublist(startIndex, endIndex)
          .every((q) => q.isAnswered);

      if (allAnswered) {
        _showScoreDialog(context);
      }
    }
  }

  void _showScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Batch Completed!"),
        content: Text(
          "Correct: ${correct.value}\nIncorrect: ${incorrect.value}",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              moveToNextBatch();
            },
            child: const Text("Next 10 Questions"),
          ),
        ],
      ),
    );
  }

  void moveToNextBatch() {
    final maxBatch = (questions.length / 10).ceil() - 1;
    if (currentBatch.value < maxBatch) {
      currentBatch.value++;
      saveData();
    }
  }

  void reset() {
    generateQuestions();
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
