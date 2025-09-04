import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrController extends GetxController {
  var extractedText = ''.obs;
  var answerText = ''.obs;

  final ImagePicker _picker = ImagePicker();

  /// Function to pick image and extract text
  Future<void> scanQuestion() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final inputImage = InputImage.fromFile(File(image.path));
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      extractedText.value = recognizedText.text;
      await textRecognizer.close();

      /// Get answer (dummy logic for now)
      fetchAnswer(extractedText.value);
    } else {
      extractedText.value = "No image selected!";
      answerText.value = "";
    }
  }

  /// Dummy logic: In real case, call API or AI model
  void fetchAnswer(String question) {
    if (question.toLowerCase().contains("capital of india")) {
      answerText.value = "The capital of India is New Delhi.";
    } else if (question.toLowerCase().contains("2+2")) {
      answerText.value = "2 + 2 = 4";
    } else {
      answerText.value = "Sorry, I don’t know the answer yet.";
    }
  }
}
