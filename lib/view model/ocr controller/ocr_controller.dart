import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:math_expressions/math_expressions.dart' as math_exp;

class OcrController extends GetxController {
  var extractedText = "".obs;
  var answerText = "".obs;

  final ImagePicker _picker = ImagePicker();

  /// 🔑 Direct API Key (testing only - production में मत hardcode करना)
  final String _apiKey = "sk-abcdefghijklmnop123";

  /// Scan Question with OCR
  Future<void> scanQuestion() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image == null) {
        answerText.value = "❌ No image selected";
        return;
      }

      final inputImage = InputImage.fromFile(File(image.path));
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      await textRecognizer.close();

      if (recognizedText.text.trim().isEmpty) {
        answerText.value = "❌ No text found in image";
        return;
      }

      extractedText.value = recognizedText.text.trim();

      // Math OR English check
      if (_isMathQuestion(extractedText.value)) {
        solveMath(extractedText.value);
      } else {
        await getAnswerFromAI(extractedText.value);
      }
    } catch (e) {
      answerText.value = "⚠️ Error: ${e.toString()}";
    }
  }

  /// Detect if it's a math expression
  bool _isMathQuestion(String text) {
    final mathRegex = RegExp(r'^[0-9\+\-\*\/\(\)\.\s=]+$');
    return mathRegex.hasMatch(text.trim());
  }

  /// Solve math expression
  void solveMath(String question) {
    try {
      final cleanQuestion = question.replaceAll("=", "").trim();
      math_exp.Parser p = math_exp.Parser();
      math_exp.Expression exp = p.parse(cleanQuestion);
      math_exp.ContextModel cm = math_exp.ContextModel();
      double eval = exp.evaluate(math_exp.EvaluationType.REAL, cm);

      answerText.value = eval.toString();
    } catch (e) {
      answerText.value = "❌ Invalid math expression";
    }
  }

  /// Get AI Answer (OpenAI)
  Future<void> getAnswerFromAI(String question) async {
    try {
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
            {"role": "system", "content": "You are a helpful teacher."},
            {"role": "user", "content": question},
          ],
          "max_tokens": 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];
        answerText.value = reply.trim();
      } else {
        answerText.value =
            "❌ API Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      answerText.value = "⚠️ AI Error: ${e.toString()}";
    }
  }
}
