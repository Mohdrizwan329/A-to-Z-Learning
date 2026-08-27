// Pins the rule that neither scanner floats a button over its own output:
// once there is something to read, the scan/reset actions belong at the end
// of the scrolled content instead. No network -- state is set directly.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:jiyan_learning/view/math%20scanner/math_scanner_page.dart';
import 'package:jiyan_learning/view%20model/math%20scanner%20controller/math_scanner_controller.dart';
import 'package:jiyan_learning/utils/responsive.dart';
import 'package:jiyan_learning/view/ocr/ocr_page.dart';
import 'package:jiyan_learning/view%20model/ocr%20controller/ocr_controller.dart';

void main() {
  testWidgets('math scanner FAB disappears once a solution is on screen',
      (tester) async {
    Get.testMode = true;
    final c = Get.put(MathScannerController());

    await tester.pumpWidget(GetMaterialApp(
      builder: (context, child) {
        R.update(MediaQuery.of(context));
        return child!;
      },
      home: MathScannerPage(),
    ));
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsWidgets,
        reason: 'empty state should still float the scan button');

    c.extractedText.value = '2 + 2';
    c.solutions.assignAll([MathSolution(question: '2 + 2', answer: '4', steps: 'Step 1: add')]);
    c.hasResult.value = true;
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(FloatingActionButton), findsNothing,
        reason: 'result state must not float anything over the answer');

    Get.delete<MathScannerController>();
  });

  testWidgets('ocr FAB disappears once questions are on screen',
      (tester) async {
    Get.testMode = true;
    final c = Get.put(OcrController());

    await tester.pumpWidget(GetMaterialApp(
      builder: (context, child) {
        R.update(MediaQuery.of(context));
        return child!;
      },
      home: OcrScreen(),
    ));
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsWidgets,
        reason: 'empty state should still float the scan button');

    c.mcqQuestions.add(McqQuestion(
      id: 1,
      question: '2 + 2 = ?',
      options: [
        McqOption(option: 'A', text: '3'),
        McqOption(option: 'B', text: '4'),
      ],
      correctAnswer: 'B',
      explanation: 'two and two',
    ));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(FloatingActionButton), findsNothing,
        reason: 'question list must not float anything over a question');

    Get.delete<OcrController>();
  });
}
