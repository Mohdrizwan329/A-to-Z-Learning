import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FruitLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  static const List<Map<String, String>> fruits = [
    {'name': 'Apple', 'emoji': '🍎'},
    {'name': 'Banana', 'emoji': '🍌'},
    {'name': 'Grapes', 'emoji': '🍇'},
    {'name': 'Watermelon', 'emoji': '🍉'},
    {'name': 'Cherry', 'emoji': '🍒'},
    {'name': 'Peach', 'emoji': '🍑'},
    {'name': 'Pineapple', 'emoji': '🍍'},
    {'name': 'Mango', 'emoji': '🥭'},
    {'name': 'Orange', 'emoji': '🍊'},
    {'name': 'Lemon', 'emoji': '🍋'},
    {'name': 'Pear', 'emoji': '🍐'},
    {'name': 'Kiwi', 'emoji': '🥝'},
    {'name': 'Melon', 'emoji': '🍈'},
    {'name': 'Green Apple', 'emoji': '🍏'},
    {'name': 'Coconut', 'emoji': '🥥'},
    {'name': 'Strawberry', 'emoji': '🍓'},
    {'name': 'Blueberry', 'emoji': '🫐'},
    {'name': 'Avocado', 'emoji': '🥑'},
    {'name': 'Papaya', 'emoji': '🥭'},
    {'name': 'Fig', 'emoji': '🍈'},
    {'name': 'Guava', 'emoji': '🍏'},
    {'name': 'Lychee', 'emoji': '🍒'},
    {'name': 'Plum', 'emoji': '🍑'},
    {'name': 'Jackfruit', 'emoji': '🍈'},
    {'name': 'Tamarind', 'emoji': '🥥'},
    {'name': 'Pomegranate', 'emoji': '🍎'},
    {'name': 'Date', 'emoji': '🥥'},
    {'name': 'Mulberry', 'emoji': '🫐'},
    {'name': 'Raspberry', 'emoji': '🍓'},
    {'name': 'Starfruit', 'emoji': '⭐'},
  ];

  @override
  void onInit() {
    super.onInit();

    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1.0);

    int? savedIndex = box.read<int>('selectedFruitIndex');
    if (savedIndex != null && savedIndex >= 0 && savedIndex < fruits.length) {
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

  void selectFruit(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      box.write('selectedFruitIndex', index);
      speak(fruits[index]['name']!);
    }
  }

  void resetSelection() {
    if (selectedIndex.value != null) {
      selectedIndex.value = null;
      box.remove('selectedFruitIndex');
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
