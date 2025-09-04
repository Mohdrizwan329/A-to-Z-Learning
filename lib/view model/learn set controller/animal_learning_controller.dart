import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AnimalLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage box = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  static const String _cacheKey = 'selectedAnimalIndex';

  final List<Map<String, String>> animals = [
    {'name': 'Dog', 'emoji': '🐶'},
    {'name': 'Cat', 'emoji': '🐱'},
    {'name': 'Lion', 'emoji': '🦁'},
    {'name': 'Tiger', 'emoji': '🐯'},
    {'name': 'Elephant', 'emoji': '🐘'},
    {'name': 'Monkey', 'emoji': '🐵'},
    {'name': 'Cow', 'emoji': '🐄'},
    {'name': 'Horse', 'emoji': '🐴'},
    {'name': 'Goat', 'emoji': '🐐'},
    {'name': 'Sheep', 'emoji': '🐑'},
    {'name': 'Pig', 'emoji': '🐷'},
    {'name': 'Rabbit', 'emoji': '🐰'},
    {'name': 'Bear', 'emoji': '🐻'},
    {'name': 'Fox', 'emoji': '🦊'},
    {'name': 'Wolf', 'emoji': '🐺'},
    {'name': 'Kangaroo', 'emoji': '🦘'},
    {'name': 'Zebra', 'emoji': '🦓'},
    {'name': 'Giraffe', 'emoji': '🦒'},
    {'name': 'Panda', 'emoji': '🐼'},
    {'name': 'Camel', 'emoji': '🐫'},
    {'name': 'Deer', 'emoji': '🦌'},
    {'name': 'Crocodile', 'emoji': '🐊'},
    {'name': 'Hippopotamus', 'emoji': '🦛'},
    {'name': 'Rhinoceros', 'emoji': '🦏'},
    {'name': 'Bat', 'emoji': '🦇'},
    {'name': 'Squirrel', 'emoji': '🐿️'},
    {'name': 'Otter', 'emoji': '🦦'},
    {'name': 'Mouse', 'emoji': '🐭'},
    {'name': 'Frog', 'emoji': '🐸'},
    {'name': 'Duck', 'emoji': '🦆'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSelectedAnimal();
    _configureTTS();
  }

  void _configureTTS() {
    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1.0);
  }

  Future<void> speakAnimalName(String name) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(name);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void selectAnimal(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    box.write(_cacheKey, index);
    speakAnimalName(animals[index]['name']!);
  }

  void resetSelection() {
    selectedIndex.value = null;
    box.remove(_cacheKey);
  }

  void _loadSelectedAnimal() {
    final savedIndex = box.read<int>(_cacheKey);
    if (savedIndex != null && savedIndex >= 0 && savedIndex < animals.length) {
      selectedIndex.value = savedIndex;
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
