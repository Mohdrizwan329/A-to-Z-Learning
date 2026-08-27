import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:jiyan_learning/services/daily_scan_limit.dart';
import 'package:jiyan_learning/services/gemini_service.dart';
import 'package:jiyan_learning/utils/image_source_picker.dart';

/// One solved question off the scanned page.
class MathSolution {
  MathSolution({
    required this.question,
    required this.answer,
    required this.steps,
  });

  /// The question restated by the model. Empty when the reply carried only a
  /// bare answer, in which case the UI just shows the answer.
  final String question;
  final String answer;
  final String steps;
}

class MathScannerController extends GetxController {
  var extractedText = "".obs;

  /// Every question found on the scanned page, in page order.
  var solutions = <MathSolution>[].obs;

  var isLoading = false.obs;
  var hasResult = false.obs;

  final ImagePicker _picker = ImagePicker();

  /// Five math scans a day. Separate from the MCQ scanner's own budget.
  final DailyScanLimit scanLimit = DailyScanLimit(name: 'math');

  /// Scan Math Question with OCR
  Future<void> scanMathQuestion() async {
    TextRecognizer? textRecognizer;
    try {
      if (!scanLimit.canScan) {
        Get.snackbar("Daily Limit Reached", scanLimit.exhaustedMessage,
            backgroundColor: Colors.orange, colorText: Colors.white,
            duration: const Duration(seconds: 3));
        return;
      }

      final ImageSource? source = await askImageSource(
        title: "Scan a math question",
        cameraSubtitle: "Point at the sum and shoot",
      );
      if (source == null) return;

      // Capped, not full-resolution: the photo is sent to the model as well
      // as read by OCR, and a 12MP original makes that request enormous
      // without reading any better.
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 88,
      );

      if (image == null) {
        Get.snackbar("Cancelled", "No image selected",
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      isLoading.value = true;
      hasResult.value = false;

      final file = File(image.path);
      final bytes = await file.readAsBytes();

      // OCR is the fast path, but it is not the only one: the photo goes to
      // the model too, so a handwritten sum or a figure OCR cannot read is
      // still solved.
      final inputImage = InputImage.fromFile(file);
      textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      extractedText.value = recognizedText.text.trim();

      // The page is going to the model, so this counts against today's budget.
      scanLimit.consume();

      // Solve every question on the page
      await solveMathQuestion(
        extractedText.value,
        imageBytes: bytes,
        imageMimeType: _mimeTypeFor(image.path),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
    } finally {
      // Always close TextRecognizer to prevent memory leak
      await textRecognizer?.close();
    }
  }

  /// Solve every math question on the page using AI.
  ///
  /// [imageBytes] is the photo itself. When it is there the model reads the
  /// page directly and [question] is only the OCR transcript, offered as a
  /// hint -- so anything OCR mangled, or missed entirely, still gets solved.
  Future<void> solveMathQuestion(
    String question, {
    List<int>? imageBytes,
    String imageMimeType = 'image/jpeg',
  }) async {
    try {
      final reply = await GeminiService.generateJson(
        systemInstruction: _systemPrompt,
        prompt: _promptFor(question, hasImage: imageBytes != null),
        imageBytes: imageBytes,
        imageMimeType: imageMimeType,
        temperature: 0.3,
        // A page of word problems with worked steps runs well past the
        // 1024-token default; a short budget comes back truncated and the
        // JSON will not decode.
        maxOutputTokens: 8192,
        // Working a sum out is exactly what the reasoning tokens are for, and
        // the budget above leaves room for both them and the answer.
        thinkingBudget: 2048,
      );

      // Parse response
      parseResponse(reply);
    } on GeminiException catch (e) {
      Get.snackbar("AI Error", e.message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// What the user turn says. With a photo attached the picture is the source
  /// of truth and the OCR text is only a hint, because OCR routinely drops
  /// exponents, fraction bars and division signs.
  static String _promptFor(String ocrText, {required bool hasImage}) {
    if (!hasImage) return ocrText;
    if (ocrText.isEmpty) {
      return "Solve every math question in the attached image.";
    }
    return "Solve every math question in the attached image.\n\n"
        "Read the image itself -- it is the source of truth. A rough OCR "
        "transcript follows, which may have dropped or garbled symbols; use "
        "it only as a hint:\n$ocrText";
  }

  /// Gemini needs the photo's real type; image_picker keeps the extension.
  static String _mimeTypeFor(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) return 'image/heic';
    return 'image/jpeg';
  }

  static const String _systemPrompt =
      """You are an expert math teacher who solves math problems step by step.
You are given a photo of a page, and usually a rough OCR transcript of it too.
The photo is what counts: read it yourself and treat the transcript only as a
hint, because OCR drops exponents, fraction bars, division signs and anything
handwritten. A page usually holds SEVERAL questions. Solve EVERY question on
it, whatever kind it is -- printed or handwritten, a bare sum, a word problem,
a fraction, an equation, a geometry figure, or a table.

Respond ONLY in this exact JSON format (no extra text):
{
  "solutions": [
    {
      "question": "The question restated in one clear line",
      "answer": "The final answer here",
      "steps": "Step 1: ...\\nStep 2: ...\\nStep 3: ..."
    }
  ]
}

Rules:
- One array entry per question, in the order they appear on the page
- Never merge two questions into one, and never silently drop a question
- If the page holds only one question, return an array with one entry
- OCR shuffles lines, so read the whole page before deciding what belongs to
  which question
- Work each answer out yourself; do not copy a printed answer without checking
- If the input is in Hindi, respond in Hindi
- If the input is in English, respond in English
- Show clear step-by-step solution
- Works for: Addition, Subtraction, Multiplication, Division, Algebra, Geometry, etc.
- If it's a simple calculation like 2+2, still show the step
- Never reply "I cannot read this": solve what the page does show, and only if
  one question is genuinely unreadable say so in that entry's "answer"
- If the photo holds no math at all, return an empty "solutions" array""";

  /// Decodes the reply into one entry per question on the page.
  ///
  /// Gemini is asked for `{"solutions": [...]}`, but it sometimes answers with
  /// a bare array, or -- for a single question -- the old flat
  /// `{"answer": ..., "steps": ...}` object, so all three shapes are accepted.
  void parseResponse(String response) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(GeminiService.stripCodeFences(response));
    } catch (_) {
      // Not JSON at all -- show the raw reply rather than nothing.
      solutions.assignAll([
        MathSolution(question: "", answer: response.trim(), steps: ""),
      ]);
      hasResult.value = true;
      return;
    }

    final parsed = _parseSolutions(decoded);
    if (parsed.isEmpty) {
      Get.snackbar("No Questions", "AI found no math question in that scan",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    solutions.assignAll(parsed);
    hasResult.value = true;
  }

  /// Pulls the solution list out of whichever shape the model replied with.
  List<MathSolution> _parseSolutions(dynamic decoded) {
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().map(_toSolution).toList();
    }
    if (decoded is Map<String, dynamic>) {
      final list = decoded["solutions"];
      if (list is List) {
        return list.whereType<Map<String, dynamic>>().map(_toSolution).toList();
      }
      // Older single-question shape: the answer sits at the top level.
      if (decoded.containsKey("answer")) return [_toSolution(decoded)];
    }
    return const [];
  }

  MathSolution _toSolution(Map<String, dynamic> data) => MathSolution(
        question: (data["question"] ?? "").toString().trim(),
        answer: (data["answer"] ?? "No answer found").toString(),
        steps: (data["steps"] ?? "").toString(),
      );

  /// Reset state
  void reset() {
    extractedText.value = "";
    solutions.clear();
    hasResult.value = false;
  }
}
