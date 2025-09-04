import 'package:flutter/material.dart';

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
    question.result = json['result'];
    question.isAnswered = json['isAnswered'];
    question.controller.text = json['answerText'];
    return question;
  }
}
