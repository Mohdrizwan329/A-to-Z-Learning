// Exercises the parsing half of both scanners with the JSON shapes Gemini
// returns for the two pages we scanned (a Vedantu MCQ sheet and a BYJU'S
// word-problem page). No network -- this pins the decode/return path, and in
// particular that EVERY question on a page comes back, not just the first.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:jiyan_learning/view%20model/ocr%20controller/ocr_controller.dart';
import 'package:jiyan_learning/view%20model/math%20scanner%20controller/math_scanner_controller.dart';

/// Snackbars from the controllers need a GetMaterialApp to land in.
Future<void> _host(WidgetTester tester) async {
  await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
}

/// Lets the snackbar's own 2s timer expire so the test ends cleanly.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 5));
}

/// All three MCQs the Vedantu page carries, in the shape the prompt asks for.
const _wholeMcqPage = '''
{
  "questions": [
    {
      "question": "Which is the most suitable unit to measure the distance between two cities?",
      "options": {"A": "Millimetre (mm)", "B": "Centimetre (cm)", "C": "Metre (m)", "D": "Kilometre (km)"},
      "correct": "D",
      "explanation": "City distances are large, so kilometres are used."
    },
    {
      "question": "1 metre (m) is equal to how many centimetres (cm)?",
      "options": {"A": "10 cm", "B": "100 cm", "C": "1,000 cm", "D": "1 cm"},
      "correct": "B",
      "explanation": "1 m = 100 cm."
    },
    {
      "question": "The length of a pencil should be measured in:",
      "options": {"A": "Kilometres", "B": "Metres", "C": "Centimetres", "D": "Millimetres"},
      "correct": "C",
      "explanation": "A pencil is small, so centimetres fit best."
    }
  ]
}''';

/// All three sums the BYJU'S page carries.
const _wholeMathPage = '''
{
  "solutions": [
    {
      "question": "How much money does the group collect each month?",
      "answer": "Rs 500",
      "steps": "Step 1: 20 women save Rs 25 each.\\nStep 2: 20 x 25 = 500."
    },
    {
      "question": "How much money will be collected in ten years?",
      "answer": "Rs 60000",
      "steps": "Step 1: 12 x 500 = 6000 per year.\\nStep 2: 6000 x 10 = 60000."
    },
    {
      "question": "How much money did Gracy pay back to the Bank?",
      "answer": "Rs 4140",
      "steps": "Step 1: Rs 345 per month for 12 months.\\nStep 2: 345 x 12 = 4140."
    }
  ]
}''';

void main() {
  group('MCQ scanner', () {
    testWidgets('a whole page yields every question, not just the first',
        (tester) async {
      await _host(tester);
      final c = OcrController();
      c.parseMcqResponse(_wholeMcqPage);
      await _settle(tester);

      expect(c.mcqQuestions.length, 3);
      expect(c.mcqQuestions.map((q) => q.id), [1, 2, 3]);
      expect(c.mcqQuestions.map((q) => q.correctAnswer), ['D', 'B', 'C']);
      expect(c.mcqQuestions.first.question, contains('two cities'));
      expect(c.mcqQuestions.last.question, contains('pencil'));
      for (final q in c.mcqQuestions) {
        expect(q.options.length, 4);
        expect(q.options.map((o) => o.option), ['A', 'B', 'C', 'D']);
      }
    });

    testWidgets('a second scan appends instead of replacing', (tester) async {
      await _host(tester);
      final c = OcrController();
      c.parseMcqResponse(_wholeMcqPage);
      c.parseMcqResponse(_wholeMcqPage);
      await _settle(tester);

      expect(c.mcqQuestions.length, 6);
      expect(c.mcqQuestions.map((q) => q.id), [1, 2, 3, 4, 5, 6]);
    });

    testWidgets('a scan lands with each answer already marked', (tester) async {
      await _host(tester);
      final c = OcrController();
      c.parseMcqResponse(_wholeMcqPage);
      await _settle(tester);

      // Q2's answer is B, and it is graded against its own key, not Q1's.
      final q2 = c.mcqQuestions[1];
      expect(q2.correctAnswer, 'B');
      expect(q2.showResult, isTrue);
      expect(q2.selectedOptionIndex, 1);
      expect(q2.options[1].isSelected, isTrue);
      expect(q2.options[1].isCorrect, isTrue);
      expect(q2.options[0].isCorrect, isFalse);
      // Pre-filled, so the banner must not read as the user's own answer.
      expect(q2.answeredByUser, isFalse);

      // An already-revealed question ignores taps.
      c.selectOption(1, 0);
      expect(c.mcqQuestions[1].selectedOptionIndex, 1);
    });

    testWidgets('a tapped option grades on the spot', (tester) async {
      await _host(tester);
      final c = OcrController();
      c.parseMcqResponse(_wholeMcqPage);
      await _settle(tester);

      // Hide the pre-filled answer, the way a quiz mode would.
      c.mcqQuestions[1].showResult = false;

      c.selectOption(1, 0);
      expect(c.mcqQuestions[1].showResult, isTrue);
      expect(c.mcqQuestions[1].answeredByUser, isTrue);
      expect(c.mcqQuestions[1].isAnswerCorrect, isFalse);
      // The right one stays marked, so the card shows which it was.
      expect(c.mcqQuestions[1].options[1].isCorrect, isTrue);
    });

    testWidgets('a bare array is accepted too', (tester) async {
      await _host(tester);
      final c = OcrController();
      c.parseMcqResponse('''[
        {"question": "One", "options": {"A": "1", "B": "2", "C": "3", "D": "4"}, "correct": "A", "explanation": ""},
        {"question": "Two", "options": {"A": "1", "B": "2", "C": "3", "D": "4"}, "correct": "B", "explanation": ""}
      ]''');
      await _settle(tester);
      expect(c.mcqQuestions.length, 2);
      expect(c.mcqQuestions.last.correctAnswer, 'B');
    });

    testWidgets('the old single-object shape still parses', (tester) async {
      await _host(tester);
      final c = OcrController();
      c.parseMcqResponse('''```json
{
  "question": "Fenced legacy reply",
  "options": {"A": "1", "B": "2", "C": "3", "D": "4"},
  "correct": "A",
  "explanation": "ok"
}
```''');
      await _settle(tester);
      expect(c.mcqQuestions.length, 1);
      expect(c.mcqQuestions.first.question, 'Fenced legacy reply');
    });

    testWidgets('an entry with no options is skipped, not crashed on',
        (tester) async {
      await _host(tester);
      final c = OcrController();
      c.parseMcqResponse('''
{"questions": [
  {"question": "Broken", "correct": "A"},
  {"question": "Good", "options": {"A": "1", "B": "2", "C": "3", "D": "4"}, "correct": "C", "explanation": ""}
]}''');
      await _settle(tester);
      expect(c.mcqQuestions.length, 1);
      expect(c.mcqQuestions.first.question, 'Good');
      expect(c.mcqQuestions.first.id, 1);
    });
  });

  group('math scanner', () {
    testWidgets('a whole page yields every sum, not just the last',
        (tester) async {
      await _host(tester);
      final c = MathScannerController();
      c.parseResponse(_wholeMathPage);
      await _settle(tester);

      expect(c.hasResult.value, isTrue);
      expect(c.solutions.length, 3);
      expect(c.solutions[0].answer, contains('500'));
      expect(c.solutions[1].answer, contains('60000'));
      expect(c.solutions[2].answer, contains('4140'));
      expect(c.solutions[2].question, contains('Gracy'));
      for (final s in c.solutions) {
        expect(s.steps, contains('Step 1'));
      }
    });

    testWidgets('a rescan replaces the previous page', (tester) async {
      await _host(tester);
      final c = MathScannerController();
      c.parseResponse(_wholeMathPage);
      c.parseResponse(
          '{"solutions": [{"question": "2+2", "answer": "4", "steps": "Step 1: 2+2 = 4."}]}');
      await _settle(tester);

      expect(c.solutions.length, 1);
      expect(c.solutions.single.answer, '4');

      c.reset();
      expect(c.hasResult.value, isFalse);
      expect(c.solutions, isEmpty);
    });

    testWidgets('the old single-object shape still parses', (tester) async {
      await _host(tester);
      final c = MathScannerController();
      c.parseResponse(
          '{"answer": "Rs 4140", "steps": "Step 1: 345 x 12 = 4140."}');
      await _settle(tester);
      expect(c.solutions.length, 1);
      expect(c.solutions.single.answer, 'Rs 4140');
      expect(c.solutions.single.question, isEmpty);
    });

    testWidgets('non-JSON falls back to the raw reply', (tester) async {
      await _host(tester);
      final c = MathScannerController();
      c.parseResponse('The answer is 500 rupees.');
      await _settle(tester);
      expect(c.hasResult.value, isTrue);
      expect(c.solutions.single.answer, 'The answer is 500 rupees.');
      expect(c.solutions.single.steps, isEmpty);
    });

    testWidgets('an empty solutions list leaves the screen alone',
        (tester) async {
      await _host(tester);
      final c = MathScannerController();
      c.parseResponse('{"solutions": []}');
      await _settle(tester);
      expect(c.hasResult.value, isFalse);
      expect(c.solutions, isEmpty);
    });
  });
}
