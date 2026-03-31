import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class SightWordsController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage();
  late final ProgressService _progressService;

  final currentLevel = 0.obs;

  static const List<String> progressKeys = [
    ProgressService.kSightWordsPreK,
    ProgressService.kSightWordsKindergarten,
    ProgressService.kSightWordsGrade1,
    ProgressService.kSightWordsGrade2,
    ProgressService.kSightWordsGrade3,
    ProgressService.kSightWordsNouns,
  ];

  final List<Map<String, dynamic>> levels = [
    {
      'name': 'Pre-K',
      'words': [
        'a', 'and', 'away', 'big', 'blue', 'can', 'come', 'down',
        'find', 'for', 'funny', 'go', 'help', 'here', 'I', 'in',
        'is', 'it', 'jump', 'little', 'look', 'make', 'me', 'my',
        'not', 'one', 'play', 'red', 'run', 'said', 'see', 'the',
        'three', 'to', 'two', 'up', 'we', 'where', 'yellow', 'you',
      ],
    },
    {
      'name': 'Kindergarten',
      'words': [
        'all', 'am', 'are', 'at', 'ate', 'be', 'black', 'brown',
        'but', 'came', 'did', 'do', 'eat', 'four', 'get', 'good',
        'have', 'he', 'into', 'like', 'must', 'new', 'no', 'now',
        'on', 'our', 'out', 'please', 'pretty', 'ran', 'ride', 'saw',
        'say', 'she', 'so', 'soon', 'that', 'there', 'they', 'this',
        'too', 'under', 'want', 'was', 'well', 'went', 'what', 'white',
        'who', 'will', 'with', 'yes',
      ],
    },
    {
      'name': 'Grade 1',
      'words': [
        'after', 'again', 'an', 'any', 'ask', 'as', 'by', 'could',
        'every', 'fly', 'from', 'give', 'going', 'had', 'has', 'her',
        'him', 'his', 'how', 'just', 'know', 'let', 'live', 'may',
        'of', 'old', 'once', 'open', 'over', 'put', 'round', 'some',
        'stop', 'take', 'thank', 'them', 'then', 'think', 'walk',
        'were', 'when',
      ],
    },
    {
      'name': 'Grade 2',
      'words': [
        'always', 'around', 'because', 'been', 'before', 'best',
        'both', 'buy', 'call', 'cold', 'does', 'fast', 'first',
        'five', 'found', 'gave', 'goes', 'green', 'its', 'made',
        'many', 'off', 'or', 'pull', 'read', 'right', 'sing', 'sit',
        'sleep', 'tell', 'their', 'these', 'those', 'upon', 'us',
        'use', 'very', 'wash', 'which', 'why', 'wish', 'work',
        'would', 'write', 'your',
      ],
    },
    {
      'name': 'Grade 3',
      'words': [
        'about', 'better', 'bring', 'carry', 'clean', 'cut', 'done',
        'draw', 'drink', 'eight', 'fall', 'far', 'full', 'got',
        'grow', 'hold', 'hot', 'hurt', 'if', 'keep', 'kind', 'laugh',
        'light', 'long', 'much', 'myself', 'never', 'only', 'own',
        'pick', 'seven', 'shall', 'show', 'six', 'small', 'start',
        'ten', 'today', 'together', 'try', 'warm',
      ],
    },
    {
      'name': 'Nouns',
      'words': [
        'apple', 'baby', 'back', 'ball', 'bear', 'bed', 'bell',
        'bird', 'birthday', 'boat', 'box', 'boy', 'bread', 'brother',
        'cake', 'car', 'cat', 'chair', 'chicken', 'children', 'coat',
        'corn', 'cow', 'day', 'dog', 'doll', 'door', 'duck', 'egg',
        'eye', 'farm', 'farmer', 'father', 'feet', 'fire', 'fish',
        'floor', 'flower', 'game', 'garden', 'girl', 'goodbye',
        'grass', 'ground', 'hand', 'head', 'hill', 'home', 'horse',
        'house', 'kitty', 'leg', 'letter', 'man', 'men', 'milk',
        'money', 'morning', 'mother', 'name', 'nest', 'night',
        'paper', 'party', 'picture', 'pig', 'rabbit', 'rain', 'ring',
        'robin', 'santa', 'school', 'seed', 'sheep', 'shoe', 'sister',
        'snow', 'song', 'squirrel', 'stick', 'street', 'sun', 'table',
        'thing', 'time', 'top', 'toy', 'tree', 'watch', 'water',
        'way', 'wind', 'window', 'wood',
      ],
    },
  ];

  String get currentProgressKey => progressKeys[currentLevel.value];
  List<String> get currentWords => levels[currentLevel.value]['words'] as List<String>;

  @override
  void onInit() {
    super.onInit();
    _progressService = Get.find<ProgressService>();
    _initTts();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  Future<void> _initTts() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.setLanguage("en-US");
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.4);
        await flutterTts.setVolume(1.0);
        await flutterTts.awaitSpeakCompletion(false);
      }
    } catch (e) {
      debugPrint("SightWords TTS Init Error: $e");
    }
  }

  Future<void> speakWord(String word) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.speak(word);
      }
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  void selectLevel(int index) {
    currentLevel.value = index;
  }

  void markWordLearned(int wordIndex, String word) {
    speakWord(word);
    _progressService.markItemCompleted(currentProgressKey, wordIndex);
  }

  bool isWordLearned(int wordIndex) {
    return _progressService.isItemCompleted(currentProgressKey, wordIndex);
  }

  void resetProgress() {
    for (var key in progressKeys) {
      _progressService.resetProgress(key);
    }
  }
}
