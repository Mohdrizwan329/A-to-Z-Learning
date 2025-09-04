import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BirdLearningController extends GetxController {
  late final FlutterTts _flutterTts;
  final GetStorage _storage = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);
  String? _lastSpoken;
  static const String _storageKey = "selectedBirdIndex";

  final List<Map<String, String>> birds = [
    {'name': 'Parrot', 'emoji': '🦜'},
    {'name': 'Peacock', 'emoji': '🦚'},
    {'name': 'Sparrow', 'emoji': '🐦'},
    {'name': 'Crow', 'emoji': '🐦'},
    {'name': 'Eagle', 'emoji': '🦅'},
    {'name': 'Owl', 'emoji': '🦉'},
    {'name': 'Penguin', 'emoji': '🐧'},
    {'name': 'Duck', 'emoji': '🦆'},
    {'name': 'Hen', 'emoji': '🐔'},
    {'name': 'Rooster', 'emoji': '🐓'},
    {'name': 'Pigeon', 'emoji': '🐦'},
    {'name': 'Flamingo', 'emoji': '🦩'},
    {'name': 'Turkey', 'emoji': '🦃'},
    {'name': 'Swan', 'emoji': '🦢'},
    {'name': 'Woodpecker', 'emoji': '🐦'},
    {'name': 'Kingfisher', 'emoji': '🐦'},
    {'name': 'Hawk', 'emoji': '🦅'},
    {'name': 'Canary', 'emoji': '🐦'},
    {'name': 'Crane', 'emoji': '🐦'},
    {'name': 'Stork', 'emoji': '🐦'},
    {'name': 'Hummingbird', 'emoji': '🐦'},
    {'name': 'Quail', 'emoji': '🐦'},
    {'name': 'Magpie', 'emoji': '🐦'},
    {'name': 'Robin', 'emoji': '🐦'},
    {'name': 'Seagull', 'emoji': '🐦'},
    {'name': 'Lark', 'emoji': '🐦'},
    {'name': 'Cuckoo', 'emoji': '🐦'},
    {'name': 'Nightingale', 'emoji': '🐦'},
    {'name': 'Duckling', 'emoji': '🦆'},
    {'name': 'Chick', 'emoji': '🐤'},
  ];

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _loadSelection();
  }

  void _initTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-IN");
    _flutterTts.setPitch(1.0);
  }

  void _loadSelection() {
    final savedIndex = _storage.read<int>(_storageKey);
    if (savedIndex != null && savedIndex < birds.length) {
      selectedIndex.value = savedIndex;
    }
  }

  Future<void> _speak(String text) async {
    if (_lastSpoken == text) return;
    _lastSpoken = text;
    await _flutterTts.speak(text);
  }

  void selectBird(int index) {
    if (index < 0 || index >= birds.length) return;
    selectedIndex.value = index;
    _storage.write(_storageKey, index);
    _speak(birds[index]['name']!);
  }

  void resetSelection() {
    selectedIndex.value = null;
    _storage.remove(_storageKey);
    _lastSpoken = null;
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
