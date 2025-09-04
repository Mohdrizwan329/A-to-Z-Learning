import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BodyPartsLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  static const List<Map<String, String>> bodyParts = [
    {'name': 'Head', 'emoji': '🧠'},
    {'name': 'Hair', 'emoji': '💇‍♂️'},
    {'name': 'Forehead', 'emoji': '🤕'},
    {'name': 'Eye', 'emoji': '👁️'},
    {'name': 'Eyebrow', 'emoji': '🤨'},
    {'name': 'Eyelash', 'emoji': '👁️‍🗨️'},
    {'name': 'Ear', 'emoji': '👂'},
    {'name': 'Nose', 'emoji': '👃'},
    {'name': 'Mouth', 'emoji': '👄'},
    {'name': 'Teeth', 'emoji': '🦷'},
    {'name': 'Tongue', 'emoji': '👅'},
    {'name': 'Neck', 'emoji': '🦒'},
    {'name': 'Shoulder', 'emoji': '🤸‍♂️'},
    {'name': 'Chest', 'emoji': '🫀'},
    {'name': 'Back', 'emoji': '🦋'},
    {'name': 'Stomach', 'emoji': '🤰'},
    {'name': 'Arm', 'emoji': '💪'},
    {'name': 'Elbow', 'emoji': '🦾'},
    {'name': 'Forearm', 'emoji': '💪'},
    {'name': 'Wrist', 'emoji': '⌚'},
    {'name': 'Hand', 'emoji': '🖐️'},
    {'name': 'Palm', 'emoji': '🤚'},
    {'name': 'Finger', 'emoji': '☝️'},
    {'name': 'Thumb', 'emoji': '👍'},
    {'name': 'Nail', 'emoji': '💅'},
    {'name': 'Hip', 'emoji': '🦵'},
    {'name': 'Leg', 'emoji': '🦵'},
    {'name': 'Knee', 'emoji': '🦵'},
    {'name': 'Calf', 'emoji': '🦵'},
    {'name': 'Ankle', 'emoji': '🦶'},
    {'name': 'Foot', 'emoji': '🦶'},
    {'name': 'Toe', 'emoji': '🦶'},
    {'name': 'Heart', 'emoji': '❤️'},
    {'name': 'Lung', 'emoji': '🫁'},
    {'name': 'Brain', 'emoji': '🧠'},
    {'name': 'Kidney', 'emoji': '🫀'},
    {'name': 'Liver', 'emoji': '🫀'},
  ];

  @override
  void onInit() {
    super.onInit();

    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1.0);

    int? savedIndex = box.read<int>('selectedBodyPartIndex');
    if (savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < bodyParts.length) {
      selectedIndex.value = savedIndex;
    }
  }

  Future<void> speak(String text) async {
    try {
      await flutterTts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void selectBodyPart(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      box.write('selectedBodyPartIndex', index);
      speak(bodyParts[index]['name']!);
    }
  }

  void resetSelection() {
    if (selectedIndex.value != null) {
      selectedIndex.value = null;
      box.remove('selectedBodyPartIndex');
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
