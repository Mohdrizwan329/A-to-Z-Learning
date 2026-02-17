import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class ShapesLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage box = GetStorage();

  ProgressService get _progressService {
    if (!Get.isRegistered<ProgressService>()) {
      Get.put(ProgressService(), permanent: true);
    }
    return Get.find<ProgressService>();
  }

  final RxnInt selectedIndex = RxnInt(null);

  static const String _cacheKey = 'selectedShapeIndex';

  final List<Map<String, String>> shapes = [
    {'name': 'Circle', 'emoji': '⭕', 'hindi': 'गोला'},
    {'name': 'Square', 'emoji': '⬛', 'hindi': 'वर्ग'},
    {'name': 'Triangle', 'emoji': '🔺', 'hindi': 'त्रिभुज'},
    {'name': 'Rectangle', 'emoji': '▬', 'hindi': 'आयत'},
    {'name': 'Star', 'emoji': '⭐', 'hindi': 'तारा'},
    {'name': 'Heart', 'emoji': '❤️', 'hindi': 'दिल'},
    {'name': 'Diamond', 'emoji': '💎', 'hindi': 'हीरा'},
    {'name': 'Oval', 'emoji': '🥚', 'hindi': 'अंडाकार'},
    {'name': 'Pentagon', 'emoji': '⬠', 'hindi': 'पंचभुज'},
    {'name': 'Hexagon', 'emoji': '⬡', 'hindi': 'षट्भुज'},
    {'name': 'Octagon', 'emoji': '🛑', 'hindi': 'अष्टभुज'},
    {'name': 'Crescent', 'emoji': '🌙', 'hindi': 'अर्धचंद्र'},
    {'name': 'Arrow', 'emoji': '➡️', 'hindi': 'तीर'},
    {'name': 'Cross', 'emoji': '➕', 'hindi': 'क्रॉस'},
    {'name': 'Cube', 'emoji': '🧊', 'hindi': 'घन'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSelectedShape();
    _configureTTS();
  }

  Future<void> _configureTTS() async {
    try {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.awaitSpeakCompletion(false);
    } catch (e) {
      // TTS configuration error
    }
  }

  Future<void> speakShapeName(String name) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(name);
    } catch (e) {
      // TTS error
    }
  }

  void selectShape(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    box.write(_cacheKey, index);
    speakShapeName(shapes[index]['name']!);
    _progressService.markItemCompleted(ProgressService.kShapes, index);
  }

  double get progressPercentage =>
      _progressService.getProgressPercentage(ProgressService.kShapes);

  String get progressString =>
      _progressService.getProgressString(ProgressService.kShapes);

  bool isItemCompleted(int index) =>
      _progressService.isItemCompleted(ProgressService.kShapes, index);

  void resetSelection() {
    selectedIndex.value = null;
    box.remove(_cacheKey);
    // Reset progress as well
    _progressService.resetProgress(ProgressService.kShapes);
  }

  void _loadSelectedShape() {
    final savedIndex = box.read<int>(_cacheKey);
    if (savedIndex != null && savedIndex >= 0 && savedIndex < shapes.length) {
      selectedIndex.value = savedIndex;
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
