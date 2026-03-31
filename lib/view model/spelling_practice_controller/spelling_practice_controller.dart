import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class SpellingPracticeController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  late final ProgressService _progressService;

  final currentLevel = 0.obs;
  final currentWordIndex = 0.obs;
  final score = 0.obs;
  final showResult = false.obs;
  final isCorrect = false.obs;

  static const List<String> progressKeys = [
    ProgressService.kSpellingEasy,
    ProgressService.kSpellingMedium,
    ProgressService.kSpellingHard,
    ProgressService.kSpellingAnimals,
    ProgressService.kSpellingFood,
    ProgressService.kSpellingNature,
  ];

  final List<Map<String, dynamic>> levels = [
    {
      'name': 'Easy',
      'words': [
        {'word': 'CAT', 'hint': 'A pet that meows', 'emoji': '🐱'},
        {'word': 'DOG', 'hint': 'A pet that barks', 'emoji': '🐕'},
        {'word': 'SUN', 'hint': 'Shines in the sky', 'emoji': '☀️'},
        {'word': 'CUP', 'hint': 'Drink from it', 'emoji': '🥤'},
        {'word': 'HAT', 'hint': 'Wear on head', 'emoji': '🎩'},
        {'word': 'BED', 'hint': 'Sleep on it', 'emoji': '🛏️'},
        {'word': 'PEN', 'hint': 'Write with it', 'emoji': '🖊️'},
        {'word': 'BOX', 'hint': 'Put things inside', 'emoji': '📦'},
        {'word': 'BUS', 'hint': 'Big vehicle', 'emoji': '🚌'},
        {'word': 'FAN', 'hint': 'Keeps you cool', 'emoji': '🌀'},
        {'word': 'MAP', 'hint': 'Shows directions', 'emoji': '🗺️'},
        {'word': 'JAR', 'hint': 'Store food in it', 'emoji': '🫙'},
        {'word': 'NET', 'hint': 'Catch fish with it', 'emoji': '🥅'},
        {'word': 'PIG', 'hint': 'Pink farm animal', 'emoji': '🐷'},
        {'word': 'RUN', 'hint': 'Move fast', 'emoji': '🏃'},
      ],
    },
    {
      'name': 'Medium',
      'words': [
        {'word': 'APPLE', 'hint': 'A red fruit', 'emoji': '🍎'},
        {'word': 'HAPPY', 'hint': 'Feeling of joy', 'emoji': '😊'},
        {'word': 'HOUSE', 'hint': 'Place to live', 'emoji': '🏠'},
        {'word': 'WATER', 'hint': 'We drink it', 'emoji': '💧'},
        {'word': 'TABLE', 'hint': 'Eat food on it', 'emoji': '🪑'},
        {'word': 'CHAIR', 'hint': 'Sit on it', 'emoji': '💺'},
        {'word': 'GREEN', 'hint': 'Color of grass', 'emoji': '💚'},
        {'word': 'LIGHT', 'hint': 'Makes things bright', 'emoji': '💡'},
        {'word': 'PLANT', 'hint': 'Grows from seed', 'emoji': '🌱'},
        {'word': 'CLOUD', 'hint': 'White in the sky', 'emoji': '☁️'},
        {'word': 'BEACH', 'hint': 'Sand and waves', 'emoji': '🏖️'},
        {'word': 'SMILE', 'hint': 'Happy face', 'emoji': '😄'},
        {'word': 'DANCE', 'hint': 'Move to music', 'emoji': '💃'},
        {'word': 'TRAIN', 'hint': 'Runs on tracks', 'emoji': '🚂'},
        {'word': 'BREAD', 'hint': 'Baked food', 'emoji': '🍞'},
      ],
    },
    {
      'name': 'Hard',
      'words': [
        {'word': 'ELEPHANT', 'hint': 'Big animal with trunk', 'emoji': '🐘'},
        {'word': 'BIRTHDAY', 'hint': 'Special day each year', 'emoji': '🎂'},
        {'word': 'RAINBOW', 'hint': 'Colors in the sky', 'emoji': '🌈'},
        {'word': 'BUTTERFLY', 'hint': 'Colorful flying insect', 'emoji': '🦋'},
        {'word': 'DINOSAUR', 'hint': 'Extinct giant reptile', 'emoji': '🦕'},
        {'word': 'UMBRELLA', 'hint': 'Use in rain', 'emoji': '☂️'},
        {'word': 'SANDWICH', 'hint': 'Bread with filling', 'emoji': '🥪'},
        {'word': 'MOUNTAIN', 'hint': 'Very tall land', 'emoji': '🏔️'},
        {'word': 'PRINCESS', 'hint': 'Royal daughter', 'emoji': '👸'},
        {'word': 'TREASURE', 'hint': 'Hidden gold', 'emoji': '💎'},
        {'word': 'ALPHABET', 'hint': 'A to Z letters', 'emoji': '🔤'},
        {'word': 'COMPUTER', 'hint': 'Electronic device', 'emoji': '💻'},
        {'word': 'CHILDREN', 'hint': 'Young people', 'emoji': '👧'},
        {'word': 'HOSPITAL', 'hint': 'Doctors work here', 'emoji': '🏥'},
        {'word': 'FOOTBALL', 'hint': 'Popular sport', 'emoji': '⚽'},
      ],
    },
    {
      'name': 'Animals',
      'words': [
        {'word': 'LION', 'hint': 'King of jungle', 'emoji': '🦁'},
        {'word': 'BEAR', 'hint': 'Big furry animal', 'emoji': '🐻'},
        {'word': 'DUCK', 'hint': 'Swims and quacks', 'emoji': '🦆'},
        {'word': 'FROG', 'hint': 'Jumps and croaks', 'emoji': '🐸'},
        {'word': 'DEER', 'hint': 'Has antlers', 'emoji': '🦌'},
        {'word': 'GOAT', 'hint': 'Gives us milk', 'emoji': '🐐'},
        {'word': 'BIRD', 'hint': 'Flies in the sky', 'emoji': '🐦'},
        {'word': 'FISH', 'hint': 'Lives in water', 'emoji': '🐟'},
        {'word': 'HORSE', 'hint': 'People ride it', 'emoji': '🐴'},
        {'word': 'MONKEY', 'hint': 'Climbs trees', 'emoji': '🐒'},
        {'word': 'RABBIT', 'hint': 'Has long ears', 'emoji': '🐰'},
        {'word': 'TURTLE', 'hint': 'Has a shell', 'emoji': '🐢'},
        {'word': 'PARROT', 'hint': 'Colorful talking bird', 'emoji': '🦜'},
        {'word': 'WHALE', 'hint': 'Biggest sea animal', 'emoji': '🐋'},
        {'word': 'TIGER', 'hint': 'Striped big cat', 'emoji': '🐯'},
      ],
    },
    {
      'name': 'Food & Fruits',
      'words': [
        {'word': 'BANANA', 'hint': 'A yellow fruit', 'emoji': '🍌'},
        {'word': 'MANGO', 'hint': 'King of fruits', 'emoji': '🥭'},
        {'word': 'GRAPE', 'hint': 'Small round fruit', 'emoji': '🍇'},
        {'word': 'PIZZA', 'hint': 'Italian flat bread', 'emoji': '🍕'},
        {'word': 'JUICE', 'hint': 'Fruit drink', 'emoji': '🧃'},
        {'word': 'RICE', 'hint': 'White grain food', 'emoji': '🍚'},
        {'word': 'CAKE', 'hint': 'Birthday treat', 'emoji': '🎂'},
        {'word': 'MILK', 'hint': 'White drink from cow', 'emoji': '🥛'},
        {'word': 'CORN', 'hint': 'Yellow vegetable', 'emoji': '🌽'},
        {'word': 'PLUM', 'hint': 'Small purple fruit', 'emoji': '🫐'},
        {'word': 'PEAR', 'hint': 'Green bell fruit', 'emoji': '🍐'},
        {'word': 'CANDY', 'hint': 'Sweet treat', 'emoji': '🍬'},
        {'word': 'LEMON', 'hint': 'Sour yellow fruit', 'emoji': '🍋'},
        {'word': 'CHERRY', 'hint': 'Small red fruit', 'emoji': '🍒'},
        {'word': 'COOKIE', 'hint': 'Sweet baked snack', 'emoji': '🍪'},
      ],
    },
    {
      'name': 'Nature',
      'words': [
        {'word': 'MOON', 'hint': 'Shines at night', 'emoji': '🌙'},
        {'word': 'STAR', 'hint': 'Twinkles in sky', 'emoji': '⭐'},
        {'word': 'TREE', 'hint': 'Has leaves and trunk', 'emoji': '🌳'},
        {'word': 'RAIN', 'hint': 'Water from clouds', 'emoji': '🌧️'},
        {'word': 'WIND', 'hint': 'Moving air', 'emoji': '💨'},
        {'word': 'SNOW', 'hint': 'White and cold', 'emoji': '❄️'},
        {'word': 'LEAF', 'hint': 'Grows on trees', 'emoji': '🍃'},
        {'word': 'ROSE', 'hint': 'Beautiful flower', 'emoji': '🌹'},
        {'word': 'LAKE', 'hint': 'Body of water', 'emoji': '🏞️'},
        {'word': 'HILL', 'hint': 'Small mountain', 'emoji': '⛰️'},
        {'word': 'RIVER', 'hint': 'Flowing water', 'emoji': '🏞️'},
        {'word': 'OCEAN', 'hint': 'Very big water', 'emoji': '🌊'},
        {'word': 'FLOWER', 'hint': 'Colorful plant', 'emoji': '🌸'},
        {'word': 'FOREST', 'hint': 'Many trees together', 'emoji': '🌲'},
        {'word': 'GARDEN', 'hint': 'Grow plants here', 'emoji': '🏡'},
      ],
    },
  ];

  String get currentProgressKey => progressKeys[currentLevel.value];
  List<Map<String, dynamic>> get currentWords =>
      levels[currentLevel.value]['words'] as List<Map<String, dynamic>>;

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
      debugPrint("Spelling TTS Init Error: $e");
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
    currentWordIndex.value = 0;
    score.value = 0;
    showResult.value = false;
    isCorrect.value = false;
  }

  void checkSpelling(String userInput) {
    final correctWord = currentWords[currentWordIndex.value]['word'] as String;
    isCorrect.value = userInput.toUpperCase().trim() == correctWord;
    if (isCorrect.value) {
      score.value += 10;
      speakWord("Correct! Well done!");
      _progressService.markItemCompleted(
          currentProgressKey, currentWordIndex.value);
    } else {
      speakWord("Try again! The word is $correctWord");
    }
    showResult.value = true;
  }

  void nextWord() {
    if (currentWordIndex.value < currentWords.length - 1) {
      currentWordIndex.value++;
    } else {
      currentWordIndex.value = 0;
    }
    showResult.value = false;
    isCorrect.value = false;
  }

  void resetCurrent() {
    showResult.value = false;
    isCorrect.value = false;
  }

  bool isWordCompleted(int wordIndex) {
    return _progressService.isItemCompleted(currentProgressKey, wordIndex);
  }

  void resetProgress() {
    for (var key in progressKeys) {
      _progressService.resetProgress(key);
    }
  }

  void resetLevelProgress(int levelIndex) {
    _progressService.resetProgress(progressKeys[levelIndex]);
  }
}
