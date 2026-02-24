import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class RightsDutiesController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();
  final ProgressService _progressService = Get.find<ProgressService>();

  final expandedIndexes = <int>{}.obs;
  static const _cacheKey = 'expandedRightsDuties';

  final List<Map<String, dynamic>> rights = [
    {
      'title': 'Right to Education',
      'emoji': '📚',
      'description': 'Every child can go to school and learn',
      'example': 'You can go to school for free until age 14',
    },
    {
      'title': 'Right to Play',
      'emoji': '⚽',
      'description': 'Every child has the right to play and have fun',
      'example': 'You can play games, sports, and enjoy your childhood',
    },
    {
      'title': 'Right to Food',
      'emoji': '🍎',
      'description': 'Every child deserves healthy food to eat',
      'example': 'You should get nutritious meals every day',
    },
    {
      'title': 'Right to Safety',
      'emoji': '🛡️',
      'description': 'Every child should be protected from harm',
      'example': 'Adults should keep you safe from danger',
    },
    {
      'title': 'Right to Health',
      'emoji': '🏥',
      'description': 'Every child can see a doctor when sick',
      'example': 'You can get medicine and treatment when needed',
    },
    {
      'title': 'Right to Love',
      'emoji': '❤️',
      'description': 'Every child deserves love and care from family',
      'example': 'Your family should love and take care of you',
    },
    {
      'title': 'Right to Expression',
      'emoji': '🗣️',
      'description': 'Every child can share their thoughts and feelings',
      'example': 'You can tell adults what you think and feel',
    },
    {
      'title': 'Right to Name & Identity',
      'emoji': '📝',
      'description': 'Every child has a name and belongs to a country',
      'example': 'You have your own name and are a citizen',
    },
  ];

  final List<Map<String, dynamic>> duties = [
    {
      'title': 'Study Well',
      'emoji': '📖',
      'description': 'Do your homework and learn new things',
      'howTo': 'Pay attention in class and complete assignments',
    },
    {
      'title': 'Respect Elders',
      'emoji': '🙏',
      'description': 'Listen to and respect parents, teachers, and elders',
      'howTo': 'Say please, thank you, and be polite',
    },
    {
      'title': 'Keep Clean',
      'emoji': '🧹',
      'description': 'Keep yourself and surroundings clean',
      'howTo': 'Wash hands, don\'t litter, organize your things',
    },
    {
      'title': 'Help Others',
      'emoji': '🤝',
      'description': 'Be kind and help people who need it',
      'howTo': 'Share with friends, help classmates, be caring',
    },
    {
      'title': 'Be Honest',
      'emoji': '💎',
      'description': 'Always tell the truth',
      'howTo': 'Don\'t lie, cheat, or steal',
    },
    {
      'title': 'Follow Rules',
      'emoji': '📋',
      'description': 'Obey rules at home, school, and public places',
      'howTo': 'Wait your turn, follow traffic rules, listen to instructions',
    },
    {
      'title': 'Save Resources',
      'emoji': '💧',
      'description': 'Don\'t waste water, electricity, or food',
      'howTo': 'Turn off lights, close taps, finish your food',
    },
    {
      'title': 'Love Nature',
      'emoji': '🌳',
      'description': 'Protect plants, animals, and the environment',
      'howTo': 'Plant trees, don\'t harm animals, don\'t pollute',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _loadFromCache();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  Future<void> _initTts() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.setLanguage("en-IN");
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.setVolume(1.0);
        await flutterTts.awaitSpeakCompletion(false);
      }
    } catch (e) {
      debugPrint("Rights Duties TTS Init Error: $e");
    }
  }

  void _loadFromCache() {
    final saved = box.read<List>(_cacheKey);
    if (saved != null && saved.isNotEmpty) {
      expandedIndexes.addAll(saved.cast<int>());
    }
  }

  void _saveToCache() {
    box.write(_cacheKey, expandedIndexes.toList(growable: false));
  }

  Future<void> speak(String text) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  void markRightRead(int index, String title) {
    if (!expandedIndexes.contains(index)) {
      expandedIndexes.add(index);
      speak(title);
    }
    _progressService.markItemCompleted(ProgressService.kRights, index);
    _saveToCache();
  }

  void markDutyRead(int index, String title) {
    final dutyKey = 100 + index; // offset for cache uniqueness
    if (!expandedIndexes.contains(dutyKey)) {
      expandedIndexes.add(dutyKey);
      speak(title);
    }
    _progressService.markItemCompleted(ProgressService.kDuties, index);
    _saveToCache();
  }

  bool isRightCompleted(int index) =>
      _progressService.isItemCompleted(ProgressService.kRights, index);

  bool isDutyCompleted(int index) =>
      _progressService.isItemCompleted(ProgressService.kDuties, index);

  void resetProgress() {
    expandedIndexes.clear();
    _saveToCache();
    _progressService.resetProgress(ProgressService.kRights);
    _progressService.resetProgress(ProgressService.kDuties);
  }
}
