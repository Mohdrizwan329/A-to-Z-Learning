import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MathScannerController extends GetxController {
  var extractedText = "".obs;
  var answerText = "".obs;
  var solutionSteps = "".obs;
  var isLoading = false.obs;
  var hasResult = false.obs;

  final ImagePicker _picker = ImagePicker();

  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  /// Scan Math Question with OCR
  Future<void> scanMathQuestion() async {
    TextRecognizer? textRecognizer;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image == null) {
        Get.snackbar("Cancelled", "No image selected",
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      isLoading.value = true;
      hasResult.value = false;

      final inputImage = InputImage.fromFile(File(image.path));
      textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      if (recognizedText.text.trim().isEmpty) {
        Get.snackbar("Error", "No text found in image",
            backgroundColor: Colors.red, colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      extractedText.value = recognizedText.text.trim();

      // Solve the math question
      await solveMathQuestion(extractedText.value);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
    } finally {
      // Always close TextRecognizer to prevent memory leak
      await textRecognizer?.close();
    }
  }

  /// Solve Math Question using AI
  Future<void> solveMathQuestion(String question) async {
    try {
      if (_apiKey.isEmpty) {
        Get.snackbar("Error", "API Key not found in .env file",
            backgroundColor: Colors.red, colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      final url = Uri.parse("https://api.openai.com/v1/chat/completions");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": """You are an expert math teacher who solves math problems step by step.
Solve the given math question and provide:
1. The final answer
2. Step-by-step solution

Respond ONLY in this exact JSON format (no extra text):
{
  "answer": "The final answer here",
  "steps": "Step 1: ...\\nStep 2: ...\\nStep 3: ..."
}

Rules:
- If the input is in Hindi, respond in Hindi
- If the input is in English, respond in English
- Show clear step-by-step solution
- Works for: Addition, Subtraction, Multiplication, Division, Algebra, Geometry, etc.
- If it's a simple calculation like 2+2, still show the step"""
            },
            {"role": "user", "content": question},
          ],
          "max_tokens": 500,
          "temperature": 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];

        // Parse response
        parseResponse(reply);
      } else {
        Get.snackbar("API Error", "Status: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse AI Response
  void parseResponse(String response) {
    try {
      // Clean response - remove markdown code blocks if present
      String cleanResponse = response.trim();
      if (cleanResponse.startsWith("```json")) {
        cleanResponse = cleanResponse.substring(7);
      }
      if (cleanResponse.startsWith("```")) {
        cleanResponse = cleanResponse.substring(3);
      }
      if (cleanResponse.endsWith("```")) {
        cleanResponse = cleanResponse.substring(0, cleanResponse.length - 3);
      }
      cleanResponse = cleanResponse.trim();

      final data = jsonDecode(cleanResponse);

      answerText.value = data["answer"] ?? "No answer found";
      solutionSteps.value = data["steps"] ?? "";
      hasResult.value = true;
    } catch (e) {
      // If JSON parsing fails, try to extract answer directly
      answerText.value = response;
      solutionSteps.value = "";
      hasResult.value = true;
    }
  }

  /// Reset state
  void reset() {
    extractedText.value = "";
    answerText.value = "";
    solutionSteps.value = "";
    hasResult.value = false;
  }
}
