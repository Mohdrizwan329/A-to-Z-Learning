import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';

class McqOption {
  final String option;
  final String text;
  bool isSelected;
  bool? isCorrect;

  McqOption({
    required this.option,
    required this.text,
    this.isSelected = false,
    this.isCorrect,
  });
}

class McqQuestion {
  final int id;
  String question;
  List<McqOption> options;
  String correctAnswer;
  String explanation;
  int? selectedOptionIndex;
  bool showResult;

  McqQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.selectedOptionIndex,
    this.showResult = false,
  });

  bool get isAnswerCorrect {
    if (selectedOptionIndex == null) return false;
    return options[selectedOptionIndex!].option == correctAnswer;
  }
}

class OcrController extends GetxController {
  var extractedText = "".obs;
  var answerText = "".obs;
  var isLoading = false.obs;
  var isPdfGenerating = false.obs;

  // Multiple questions list
  var mcqQuestions = <McqQuestion>[].obs;
  var currentQuestionIndex = 0.obs;

  // For current scanning
  var mcqOptions = <McqOption>[].obs;
  var correctAnswer = "".obs;
  var showResult = false.obs;
  var selectedOptionIndex = (-1).obs;

  final ImagePicker _picker = ImagePicker();

  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  // Get current question
  McqQuestion? get currentQuestion {
    if (mcqQuestions.isEmpty) return null;
    if (currentQuestionIndex.value >= mcqQuestions.length) return null;
    return mcqQuestions[currentQuestionIndex.value];
  }

  /// Scan Question with OCR
  Future<void> scanQuestion() async {
    TextRecognizer? textRecognizer;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image == null) {
        Get.snackbar("Cancelled", "No image selected",
          backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      isLoading.value = true;

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

      // Convert to MCQ and add to list
      await convertToMcq(extractedText.value);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
    } finally {
      // Always close TextRecognizer to prevent memory leak
      await textRecognizer?.close();
    }
  }

  /// Reset current MCQ state
  void resetCurrentMcq() {
    mcqOptions.clear();
    correctAnswer.value = "";
    showResult.value = false;
    selectedOptionIndex.value = -1;
    answerText.value = "";
    extractedText.value = "";
  }

  /// Clear all questions
  void clearAllQuestions() {
    mcqQuestions.clear();
    currentQuestionIndex.value = 0;
    resetCurrentMcq();
  }

  /// Select an option for current question
  void selectOption(int questionIndex, int optionIndex) {
    if (questionIndex >= mcqQuestions.length) return;
    if (mcqQuestions[questionIndex].showResult) return;

    mcqQuestions[questionIndex].selectedOptionIndex = optionIndex;
    for (int i = 0; i < mcqQuestions[questionIndex].options.length; i++) {
      mcqQuestions[questionIndex].options[i].isSelected = (i == optionIndex);
    }
    mcqQuestions.refresh();
  }

  /// Check answer for a specific question
  void checkAnswer(int questionIndex) {
    if (questionIndex >= mcqQuestions.length) return;
    if (mcqQuestions[questionIndex].selectedOptionIndex == null) {
      Get.snackbar("Select Option", "Please select an option first!",
        backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    mcqQuestions[questionIndex].showResult = true;

    for (int i = 0; i < mcqQuestions[questionIndex].options.length; i++) {
      mcqQuestions[questionIndex].options[i].isCorrect =
          (mcqQuestions[questionIndex].options[i].option ==
           mcqQuestions[questionIndex].correctAnswer);
    }
    mcqQuestions.refresh();
  }

  /// Delete a question
  void deleteQuestion(int index) {
    if (index < mcqQuestions.length) {
      mcqQuestions.removeAt(index);
      // Update IDs
      for (int i = 0; i < mcqQuestions.length; i++) {
        mcqQuestions[i] = McqQuestion(
          id: i + 1,
          question: mcqQuestions[i].question,
          options: mcqQuestions[i].options,
          correctAnswer: mcqQuestions[i].correctAnswer,
          explanation: mcqQuestions[i].explanation,
          selectedOptionIndex: mcqQuestions[i].selectedOptionIndex,
          showResult: mcqQuestions[i].showResult,
        );
      }
      mcqQuestions.refresh();
    }
  }

  /// Convert any question to MCQ using AI
  Future<void> convertToMcq(String question) async {
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
              "content": """You are an expert teacher who creates MCQ questions.
Convert the given question/topic into a proper MCQ format with 4 options.
Respond ONLY in this exact JSON format (no extra text):
{
  "question": "The clear question text here",
  "options": {
    "A": "First option",
    "B": "Second option",
    "C": "Third option",
    "D": "Fourth option"
  },
  "correct": "A",
  "explanation": "Brief explanation why this is correct"
}

Rules:
- If the input is in Hindi, respond in Hindi
- If the input is in English, respond in English
- Make sure only ONE option is correct
- Options should be plausible and educational
- Works for all subjects: Math, Science, Hindi, English, GK, History, Geography, etc."""
            },
            {"role": "user", "content": question},
          ],
          "max_tokens": 500,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];

        // Parse MCQ response and add to list
        parseMcqResponse(reply);
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

  /// Parse MCQ JSON response
  void parseMcqResponse(String response) {
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

      final mcqData = jsonDecode(cleanResponse);

      // Parse options
      final options = mcqData["options"] as Map<String, dynamic>;
      List<McqOption> optionsList = [];

      options.forEach((key, value) {
        optionsList.add(McqOption(
          option: key,
          text: value.toString(),
        ));
      });

      // Create new MCQ question and add to list
      final newQuestion = McqQuestion(
        id: mcqQuestions.length + 1,
        question: mcqData["question"] ?? extractedText.value,
        options: optionsList,
        correctAnswer: mcqData["correct"] ?? "A",
        explanation: mcqData["explanation"] ?? "",
      );

      mcqQuestions.add(newQuestion);

      Get.snackbar(
        "Question Added! 🎉",
        "Total: ${mcqQuestions.length} questions",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      Get.snackbar("Parse Error", e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Generate PDF with all MCQ questions
  Future<void> generatePdf() async {
    if (mcqQuestions.isEmpty) {
      Get.snackbar("No Questions", "Please scan some questions first!",
        backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isPdfGenerating.value = true;

      final pdf = pw.Document();

      // Title Page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'MCQ Question Paper',
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Total Questions: ${mcqQuestions.length}',
                    style: const pw.TextStyle(fontSize: 18),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Generated by: Learning For Kids App',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Questions Pages
      for (int i = 0; i < mcqQuestions.length; i++) {
        final q = mcqQuestions[i];

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Question number and text
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.blue, width: 2),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Question ${i + 1}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          q.question,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Options
                  ...q.options.map((opt) {
                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 10),
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 30,
                            height: 30,
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              border: pw.Border.all(color: PdfColors.blue),
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                opt.option,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.blue,
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 15),
                          pw.Expanded(
                            child: pw.Text(
                              opt.text,
                              style: const pw.TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      }

      // Answer Key Page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ANSWER KEY',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),
                ...mcqQuestions.asMap().entries.map((entry) {
                  final i = entry.key;
                  final q = entry.value;
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 15),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green50,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'Q${i + 1}: ',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'Answer: ${q.correctAnswer}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green,
                              ),
                            ),
                          ],
                        ),
                        if (q.explanation.isNotEmpty) ...[
                          pw.SizedBox(height: 5),
                          pw.Text(
                            q.explanation,
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      );

      // Save PDF
      final output = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File("${output.path}/MCQ_Questions_$timestamp.pdf");
      await file.writeAsBytes(await pdf.save());

      isPdfGenerating.value = false;

      // Show options dialog
      Get.dialog(
        AlertDialog(
          title: const Text("PDF Generated! 🎉"),
          content: const Text("What would you like to do?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                OpenFile.open(file.path);
              },
              child: const Text("Open PDF"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Share.shareXFiles([XFile(file.path)], text: 'MCQ Questions PDF');
              },
              child: const Text("Share PDF"),
            ),
          ],
        ),
      );

    } catch (e) {
      isPdfGenerating.value = false;
      Get.snackbar("PDF Error", e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
