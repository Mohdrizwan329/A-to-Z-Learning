import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WeekDayController extends GetxController {
  static const List<Map<String, String>> days = [
    {'name': 'Sunday', 'emoji': '🌞'},
    {'name': 'Monday', 'emoji': '🌜'},
    {'name': 'Tuesday', 'emoji': '🔥'},
    {'name': 'Wednesday', 'emoji': '🌊'},
    {'name': 'Thursday', 'emoji': '⚡'},
    {'name': 'Friday', 'emoji': '🎉'},
    {'name': 'Saturday', 'emoji': '🌟'},
  ];

  static final FlutterTts _flutterTts = FlutterTts();
  final GetStorage _box = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  @override
  void onInit() {
    super.onInit();
    final savedIndex = _box.read('selectedDayIndex');
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

  void selectDay(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      _box.write('selectedDayIndex', index);
      speak(days[index]['name']!);
    }
  }

  void resetSelection() {
    if (selectedIndex.value != null) {
      selectedIndex.value = null;
      _box.remove('selectedDayIndex');
    }
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
