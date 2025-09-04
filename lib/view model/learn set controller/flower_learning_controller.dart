import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FlowerLearningController extends GetxController {
  static const List<Map<String, String>> flowers = [
    {'name': 'Rose', 'emoji': '🌹'},
    {'name': 'Tulip', 'emoji': '🌷'},
    {'name': 'Sunflower', 'emoji': '🌻'},
    {'name': 'Blossom', 'emoji': '🌸'},
    {'name': 'Hibiscus', 'emoji': '🌺'},
    {'name': 'Lily', 'emoji': '💮'},
    {'name': 'Lotus', 'emoji': '🪷'},
    {'name': 'Daisy', 'emoji': '🌼'},
    {'name': 'Lavender', 'emoji': '💜'},
    {'name': 'Orchid', 'emoji': '🪻'},
    {'name': 'Marigold', 'emoji': '🌼'},
    {'name': 'Jasmine', 'emoji': '🌼'},
    {'name': 'Poppy', 'emoji': '🌺'},
    {'name': 'Peony', 'emoji': '🌸'},
    {'name': 'Daffodil', 'emoji': '🌼'},
    {'name': 'Bluebell', 'emoji': '🔔'},
    {'name': 'Camellia', 'emoji': '🌺'},
    {'name': 'Gardenia', 'emoji': '🌼'},
    {'name': 'Iris', 'emoji': '🌸'},
    {'name': 'Zinnia', 'emoji': '🌺'},
    {'name': 'Petunia', 'emoji': '🌸'},
    {'name': 'Aster', 'emoji': '🌼'},
    {'name': 'Begonia', 'emoji': '🌸'},
    {'name': 'Chrysanthemum', 'emoji': '🌼'},
    {'name': 'Gladiolus', 'emoji': '🌸'},
    {'name': 'Snapdragon', 'emoji': '🌼'},
    {'name': 'Carnation', 'emoji': '🌸'},
    {'name': 'Verbena', 'emoji': '🌺'},
    {'name': 'Cosmos', 'emoji': '🌸'},
    {'name': 'Foxglove', 'emoji': '🔔'},
  ];

  static final FlutterTts _flutterTts = FlutterTts();
  final GetStorage _box = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  @override
  void onInit() {
    super.onInit();
    final savedIndex = _box.read('selectedFlowerIndex');
    if (savedIndex != null) {
      selectedIndex.value = savedIndex;
    }
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-IN");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void selectFlower(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      _box.write('selectedFlowerIndex', index);
      speak(flowers[index]['name']!);
    }
  }

  void resetSelection() {
    if (selectedIndex.value != null) {
      selectedIndex.value = null;
      _box.remove('selectedFlowerIndex');
    }
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
