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

class SubtractionQuestionsController extends GetxController {
  final box = GetStorage();
  final questions = <QuestionModel>[].obs;
  final RxInt currentBatch = 0.obs;
  final RxInt correct = 0.obs;
  final RxInt incorrect = 0.obs;

  Timer? _saveTimer;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    final savedData = box.read('subtraction_questions');
    final savedBatch = box.read('subtraction_currentBatch');
    final savedCorrect = box.read('subtraction_correct');
    final savedIncorrect = box.read('subtraction_incorrect');

    if (savedData != null && savedBatch != null) {
      currentBatch.value = savedBatch;
      correct.value = savedCorrect ?? 0;
      incorrect.value = savedIncorrect ?? 0;

      final list = (savedData as List)
          .map((e) => QuestionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      questions.assignAll(list);
    } else {
      generateNewQuestions();
    }
  }

  void generateNewQuestions() {
    final rand = Random();
    final newQuestions = List.generate(50, (_) {
      int a = rand.nextInt(90) + 10;
      int b = rand.nextInt(a - 9) + 10;
      return QuestionModel(a, b);
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
      final jsonList = questions.map((q) => q.toJson()).toList();
      await box.write('subtraction_questions', jsonList);
      await box.write('subtraction_currentBatch', currentBatch.value);
      await box.write('subtraction_correct', correct.value);
      await box.write('subtraction_incorrect', incorrect.value);
    });
  }

  void checkAnswer(int index) {
    final question = questions[index];
    final userAnswer = int.tryParse(question.controller.text.trim());
    final correctAnswer = question.num1 - question.num2;

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
