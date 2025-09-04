import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ColorsLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage storage = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  final List<Map<String, String>> colors = [
    {'name': 'Red', 'emoji': '🔴'},
    {'name': 'Blue', 'emoji': '🔵'},
    {'name': 'Green', 'emoji': '🟢'},
    {'name': 'Yellow', 'emoji': '🟡'},
    {'name': 'Orange', 'emoji': '🟠'},
    {'name': 'Purple', 'emoji': '🟣'},
    {'name': 'Black', 'emoji': '⚫'},
    {'name': 'White', 'emoji': '⚪'},
    {'name': 'Brown', 'emoji': '🟤'},
    {'name': 'Pink', 'emoji': '🌸'},
    {'name': 'Gray', 'emoji': '🌫️'},
    {'name': 'Cyan', 'emoji': '💧'},
    {'name': 'Magenta', 'emoji': '🎀'},
    {'name': 'Gold', 'emoji': '🥇'},
    {'name': 'Silver', 'emoji': '🥈'},
    {'name': 'Indigo', 'emoji': '🔮'},
    {'name': 'Violet', 'emoji': '🪻'},
    {'name': 'Turquoise', 'emoji': '🐬'},
    {'name': 'Lime', 'emoji': '🥒'},
    {'name': 'Navy Blue', 'emoji': '🛳️'},
  ];

  final Map<String, bool> _spokenCache = {};

  @override
  void onInit() {
    super.onInit();
    _initTTS();

    final savedIndex = storage.read('selectedColorIndex');
    if (savedIndex != null) {
      selectedIndex.value = savedIndex;
    }
  }

  Future<void> _initTTS() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    if (_spokenCache[text] == true) {
      await flutterTts.speak(text);
    } else {
      await flutterTts.speak(text);
      _spokenCache[text] = true;
    }
  }

  void selectColor(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    storage.write('selectedColorIndex', index);
    speak(colors[index]['name']!);
  }

  void resetSelection() {
    selectedIndex.value = null;
    storage.remove('selectedColorIndex');
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
