import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class VehiclesLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage box = GetStorage();

  ProgressService get _progressService {
    if (!Get.isRegistered<ProgressService>()) {
      Get.put(ProgressService(), permanent: true);
    }
    return Get.find<ProgressService>();
  }

  final RxnInt selectedIndex = RxnInt(null);

  static const String _cacheKey = 'selectedVehicleIndex';

  final List<Map<String, String>> vehicles = [
    {'name': 'Car', 'emoji': '🚗', 'hindi': 'कार'},
    {'name': 'Bus', 'emoji': '🚌', 'hindi': 'बस'},
    {'name': 'Truck', 'emoji': '🚚', 'hindi': 'ट्रक'},
    {'name': 'Motorcycle', 'emoji': '🏍️', 'hindi': 'मोटरसाइकिल'},
    {'name': 'Bicycle', 'emoji': '🚲', 'hindi': 'साइकिल'},
    {'name': 'Train', 'emoji': '🚂', 'hindi': 'रेलगाड़ी'},
    {'name': 'Airplane', 'emoji': '✈️', 'hindi': 'हवाई जहाज'},
    {'name': 'Helicopter', 'emoji': '🚁', 'hindi': 'हेलीकॉप्टर'},
    {'name': 'Ship', 'emoji': '🚢', 'hindi': 'जहाज'},
    {'name': 'Boat', 'emoji': '⛵', 'hindi': 'नाव'},
    {'name': 'Rocket', 'emoji': '🚀', 'hindi': 'रॉकेट'},
    {'name': 'Ambulance', 'emoji': '🚑', 'hindi': 'एम्बुलेंस'},
    {'name': 'Fire Truck', 'emoji': '🚒', 'hindi': 'दमकल'},
    {'name': 'Police Car', 'emoji': '🚓', 'hindi': 'पुलिस कार'},
    {'name': 'Taxi', 'emoji': '🚕', 'hindi': 'टैक्सी'},
    {'name': 'Auto', 'emoji': '🛺', 'hindi': 'ऑटो'},
    {'name': 'Scooter', 'emoji': '🛵', 'hindi': 'स्कूटर'},
    {'name': 'Tractor', 'emoji': '🚜', 'hindi': 'ट्रैक्टर'},
    {'name': 'Bulldozer', 'emoji': '🚧', 'hindi': 'बुलडोजर'},
    {'name': 'Submarine', 'emoji': '🚇', 'hindi': 'पनडुब्बी'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSelectedVehicle();
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

  Future<void> speakVehicleName(String name) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(name);
    } catch (e) {
      // TTS error
    }
  }

  void selectVehicle(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    box.write(_cacheKey, index);
    speakVehicleName(vehicles[index]['name']!);
    _progressService.markItemCompleted(ProgressService.kVehicles, index);
  }

  double get progressPercentage =>
      _progressService.getProgressPercentage(ProgressService.kVehicles);

  String get progressString =>
      _progressService.getProgressString(ProgressService.kVehicles);

  bool isItemCompleted(int index) =>
      _progressService.isItemCompleted(ProgressService.kVehicles, index);

  void resetSelection() {
    selectedIndex.value = null;
    box.remove(_cacheKey);
    // Reset progress as well
    _progressService.resetProgress(ProgressService.kVehicles);
  }

  void _loadSelectedVehicle() {
    final savedIndex = box.read<int>(_cacheKey);
    if (savedIndex != null && savedIndex >= 0 && savedIndex < vehicles.length) {
      selectedIndex.value = savedIndex;
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
