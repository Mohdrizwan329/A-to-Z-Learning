import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/view%20model/cor%20controller/ocr_controller.dart';

class OcrScreen extends StatelessWidget {
  final OcrController controller = Get.put(OcrController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: controller.scanQuestion,
              icon: Icon(Icons.camera_alt),
              label: Text("Scan Question"),
            ),
            SizedBox(height: 20),

            Obx(
              () => controller.extractedText.value.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📖 Question:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.extractedText.value,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "✅ Answer:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.answerText.value,
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    )
                  : Text("Scan a question to see the answer"),
            ),
          ],
        ),
      ),
    );
  }
}
