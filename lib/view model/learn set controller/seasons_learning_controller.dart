import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class SeasonsLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage box = GetStorage();

  ProgressService get _progressService {
    if (!Get.isRegistered<ProgressService>()) {
      Get.put(ProgressService(), permanent: true);
    }
    return Get.find<ProgressService>();
  }

  final RxnInt selectedIndex = RxnInt(null);

  static const String _cacheKey = 'selectedSeasonIndex';

  final List<Map<String, dynamic>> seasons = [
    {
      'name': 'Spring',
      'emoji': '🌸',
      'hindi': 'वसंत',
      'months': 'March - May',
      'description': 'Flowers bloom, weather is pleasant',
      'color': 0xFFFF9ECE,
    },
    {
      'name': 'Summer',
      'emoji': '☀️',
      'hindi': 'गर्मी',
      'months': 'June - August',
      'description': 'Hot weather, vacation time',
      'color': 0xFFFFAA5A,
    },
    {
      'name': 'Monsoon',
      'emoji': '🌧️',
      'hindi': 'बारिश',
      'months': 'July - September',
      'description': 'Rainy season, green everywhere',
      'color': 0xFF45B7D1,
    },
    {
      'name': 'Autumn',
      'emoji': '🍂',
      'hindi': 'पतझड़',
      'months': 'September - November',
      'description': 'Leaves fall, cool weather',
      'color': 0xFFE17055,
    },
    {
      'name': 'Winter',
      'emoji': '❄️',
      'hindi': 'सर्दी',
      'months': 'December - February',
      'description': 'Cold weather, warm clothes',
      'color': 0xFF74B9FF,
    },
    {
      'name': 'Pre-Monsoon',
      'emoji': '🌤️',
      'hindi': 'ग्रीष्म',
      'months': 'April - June',
      'description': 'Hot and humid weather',
      'color': 0xFFFFE66D,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSelectedSeason();
    _configureTTS();
  }

  Future<void> _configureTTS() async {
    try {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
    } catch (e) {
      // TTS configuration error
    }
  }

  Future<void> speakSeasonInfo(int index) async {
    try {
      await flutterTts.stop();
      final season = seasons[index];
      await flutterTts.speak('${season['name']}. ${season['description']}');
    } catch (e) {
      // TTS error
    }
  }

  void selectSeason(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    box.write(_cacheKey, index);
    speakSeasonInfo(index);
    _progressService.markItemCompleted(ProgressService.kSeasons, index);
  }

  double get progressPercentage =>
      _progressService.getProgressPercentage(ProgressService.kSeasons);

  String get progressString =>
      _progressService.getProgressString(ProgressService.kSeasons);

  bool isItemCompleted(int index) =>
      _progressService.isItemCompleted(ProgressService.kSeasons, index);

  void resetSelection() {
    selectedIndex.value = null;
    box.remove(_cacheKey);
    // Reset progress as well
    _progressService.resetProgress(ProgressService.kSeasons);
  }

  void _loadSelectedSeason() {
    final savedIndex = box.read<int>(_cacheKey);
    if (savedIndex != null && savedIndex >= 0 && savedIndex < seasons.length) {
      selectedIndex.value = savedIndex;
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
