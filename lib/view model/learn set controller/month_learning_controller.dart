import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MonthLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();

  final RxnInt selectedIndex = RxnInt(null);

  static const List<Map<String, String>> months = [
    {'name': 'January', 'emoji': '❄️'},
    {'name': 'February', 'emoji': '❤️'},
    {'name': 'March', 'emoji': '🌸'},
    {'name': 'April', 'emoji': '🌧️'},
    {'name': 'May', 'emoji': '🌼'},
    {'name': 'June', 'emoji': '☀️'},
    {'name': 'July', 'emoji': '🎆'},
    {'name': 'August', 'emoji': '🌻'},
    {'name': 'September', 'emoji': '🍁'},
    {'name': 'October', 'emoji': '🎃'},
    {'name': 'November', 'emoji': '🍂'},
    {'name': 'December', 'emoji': '🎄'},
  ];

  @override
  void onInit() {
    super.onInit();

    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1.0);

    int? savedIndex = box.read<int>('selectedMonthIndex');
    if (savedIndex != null && savedIndex >= 0 && savedIndex < months.length) {
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

  void selectMonth(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      box.write('selectedMonthIndex', index);
      speak(months[index]['name']!);
    }
  }

  void resetSelection() {
    if (selectedIndex.value != null) {
      selectedIndex.value = null;
      box.remove('selectedMonthIndex');
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
