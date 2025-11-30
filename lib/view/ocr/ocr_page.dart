import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/view%20model/ocr%20controller/ocr_controller.dart';

class OcrScreen extends StatelessWidget {
  final controller = Get.put(OcrController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Question Scanner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            tooltip: "Scan Question",
            onPressed: controller.scanQuestion,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => controller.extractedText.value.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📖 Question:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.extractedText.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "✅ Answer:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.answerText.value,
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "📸 Tap the camera icon to scan a question",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ),
    );
  }
}
