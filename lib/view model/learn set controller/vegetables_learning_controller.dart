import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VegetablesLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  static const List<Map<String, String>> vegetables = [
    {'name': 'Carrot', 'emoji': '🥕'},
    {'name': 'Broccoli', 'emoji': '🥦'},
    {'name': 'Cabbage', 'emoji': '🥬'},
    {'name': 'Cauliflower', 'emoji': '🥦'},
    {'name': 'Spinach', 'emoji': '🥬'},
    {'name': 'Potato', 'emoji': '🥔'},
    {'name': 'Tomato', 'emoji': '🍅'},
    {'name': 'Onion', 'emoji': '🧅'},
    {'name': 'Garlic', 'emoji': '🧄'},
    {'name': 'Cucumber', 'emoji': '🥒'},
    {'name': 'Pumpkin', 'emoji': '🎃'},
    {'name': 'Peas', 'emoji': '🟢'},
    {'name': 'Corn', 'emoji': '🌽'},
    {'name': 'Bell Pepper', 'emoji': '🫑'},
    {'name': 'Lettuce', 'emoji': '🥬'},
    {'name': 'Mushroom', 'emoji': '🍄'},
    {'name': 'Celery', 'emoji': '🥬'},
    {'name': 'Zucchini', 'emoji': '🥒'},
    {'name': 'Green Beans', 'emoji': '🟢'},
    {'name': 'Asparagus', 'emoji': '🥦'},
    {'name': 'Eggplant', 'emoji': '🍆'},
    {'name': 'Sweet Potato', 'emoji': '🥔'},
    {'name': 'Kale', 'emoji': '🥬'},
    {'name': 'Brussels Sprouts', 'emoji': '🥦'},
    {'name': 'Leek', 'emoji': '🧅'},
    {'name': 'Chili Pepper', 'emoji': '🌶️'},
    {'name': 'Okra', 'emoji': '🥒'},
    {'name': 'Corn Salad', 'emoji': '🥬'},
    {'name': 'Artichoke', 'emoji': '🥦'},
  ];

  @override
  void onInit() {
    super.onInit();

    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1.0);

    int? savedIndex = box.read<int>('selectedVegetableIndex');
    if (savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < vegetables.length) {
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

  void selectVegetable(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      box.write('selectedVegetableIndex', index);
      speak(vegetables[index]['name']!);
    }
  }

  void resetSelection() {
    if (selectedIndex.value != null) {
      selectedIndex.value = null;
      box.remove('selectedVegetableIndex');
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
