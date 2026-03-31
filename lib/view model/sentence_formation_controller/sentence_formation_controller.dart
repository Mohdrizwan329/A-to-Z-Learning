import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class SentenceFormationController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  late final ProgressService _progressService;

  final currentLevel = 0.obs;
  final currentSentenceIndex = 0.obs;
  final selectedWords = <String>[].obs;
  final score = 0.obs;
  final showResult = false.obs;
  final isCorrect = false.obs;

  static const List<String> progressKeys = [
    ProgressService.kSentenceAnimals,
    ProgressService.kSentenceFamily,
    ProgressService.kSentenceNature,
    ProgressService.kSentenceSchool,
    ProgressService.kSentenceFood,
    ProgressService.kSentenceActions,
  ];

  final List<Map<String, dynamic>> levels = [
    {
      'name': 'Animals',
      'sentences': [
        {'sentence': 'The cat is sleeping', 'emoji': '🐱😴', 'words': ['The', 'cat', 'is', 'sleeping', 'dog', 'running']},
        {'sentence': 'Birds can fly', 'emoji': '🐦✈️', 'words': ['Birds', 'can', 'fly', 'swim', 'fish', 'run']},
        {'sentence': 'Dogs like bones', 'emoji': '🐕🦴', 'words': ['Dogs', 'like', 'bones', 'cats', 'hate', 'fish']},
        {'sentence': 'The fish swims fast', 'emoji': '🐟💨', 'words': ['The', 'fish', 'swims', 'fast', 'bird', 'slow']},
        {'sentence': 'The rabbit hops', 'emoji': '🐰🦘', 'words': ['The', 'rabbit', 'hops', 'runs', 'cat', 'walks']},
        {'sentence': 'Frogs live in water', 'emoji': '🐸💧', 'words': ['Frogs', 'live', 'in', 'water', 'fire', 'birds']},
        {'sentence': 'The lion is strong', 'emoji': '🦁💪', 'words': ['The', 'lion', 'is', 'strong', 'weak', 'mouse']},
        {'sentence': 'Ducks swim in ponds', 'emoji': '🦆🏊', 'words': ['Ducks', 'swim', 'in', 'ponds', 'fly', 'trees']},
        {'sentence': 'The elephant is big', 'emoji': '🐘🏔️', 'words': ['The', 'elephant', 'is', 'big', 'small', 'ant']},
        {'sentence': 'Monkeys eat bananas', 'emoji': '🐒🍌', 'words': ['Monkeys', 'eat', 'bananas', 'Dogs', 'drink', 'apples']},
      ],
    },
    {
      'name': 'Family',
      'sentences': [
        {'sentence': 'I love my mom', 'emoji': '❤️👩', 'words': ['I', 'love', 'my', 'mom', 'hate', 'dad']},
        {'sentence': 'Dad reads a book', 'emoji': '👨📖', 'words': ['Dad', 'reads', 'a', 'book', 'Mom', 'writes']},
        {'sentence': 'Mom cooks food', 'emoji': '👩‍🍳🍲', 'words': ['Mom', 'cooks', 'food', 'Dad', 'eats', 'water']},
        {'sentence': 'My sister is kind', 'emoji': '👧💕', 'words': ['My', 'sister', 'is', 'kind', 'brother', 'mean']},
        {'sentence': 'We eat together', 'emoji': '👨‍👩‍👧🍽️', 'words': ['We', 'eat', 'together', 'They', 'sleep', 'alone']},
        {'sentence': 'Baby is smiling', 'emoji': '👶😊', 'words': ['Baby', 'is', 'smiling', 'crying', 'Dog', 'running']},
        {'sentence': 'Grandma tells stories', 'emoji': '👵📚', 'words': ['Grandma', 'tells', 'stories', 'Grandpa', 'sings', 'songs']},
        {'sentence': 'Dad plays with me', 'emoji': '👨🎮', 'words': ['Dad', 'plays', 'with', 'me', 'Mom', 'them']},
        {'sentence': 'I help my mom', 'emoji': '🤝👩', 'words': ['I', 'help', 'my', 'mom', 'They', 'dad']},
        {'sentence': 'We are happy', 'emoji': '👨‍👩‍👧😊', 'words': ['We', 'are', 'happy', 'They', 'is', 'sad']},
      ],
    },
    {
      'name': 'Nature',
      'sentences': [
        {'sentence': 'The sun is hot', 'emoji': '☀️🔥', 'words': ['The', 'sun', 'is', 'hot', 'cold', 'moon']},
        {'sentence': 'The sky is blue', 'emoji': '🌤️💙', 'words': ['The', 'sky', 'is', 'blue', 'green', 'ground']},
        {'sentence': 'Rain falls from clouds', 'emoji': '🌧️☁️', 'words': ['Rain', 'falls', 'from', 'clouds', 'sun', 'rises']},
        {'sentence': 'Flowers are beautiful', 'emoji': '🌸✨', 'words': ['Flowers', 'are', 'beautiful', 'Trees', 'is', 'ugly']},
        {'sentence': 'Trees give us shade', 'emoji': '🌳🌤️', 'words': ['Trees', 'give', 'us', 'shade', 'Rocks', 'them']},
        {'sentence': 'Stars shine at night', 'emoji': '⭐🌙', 'words': ['Stars', 'shine', 'at', 'night', 'day', 'hide']},
        {'sentence': 'Wind blows the leaves', 'emoji': '💨🍃', 'words': ['Wind', 'blows', 'the', 'leaves', 'Rain', 'rocks']},
        {'sentence': 'Snow is white', 'emoji': '❄️⬜', 'words': ['Snow', 'is', 'white', 'Rain', 'blue', 'black']},
        {'sentence': 'The river flows fast', 'emoji': '🏞️💨', 'words': ['The', 'river', 'flows', 'fast', 'mountain', 'slow']},
        {'sentence': 'The moon is bright', 'emoji': '🌙✨', 'words': ['The', 'moon', 'is', 'bright', 'sun', 'dark']},
      ],
    },
    {
      'name': 'School',
      'sentences': [
        {'sentence': 'I go to school', 'emoji': '🎒🏫', 'words': ['I', 'go', 'to', 'school', 'home', 'play']},
        {'sentence': 'I can read books', 'emoji': '📚👦', 'words': ['I', 'can', 'read', 'books', 'write', 'sing']},
        {'sentence': 'Teacher helps us learn', 'emoji': '👩‍🏫📝', 'words': ['Teacher', 'helps', 'us', 'learn', 'Students', 'play']},
        {'sentence': 'We write on paper', 'emoji': '✏️📄', 'words': ['We', 'write', 'on', 'paper', 'They', 'wall']},
        {'sentence': 'I draw a picture', 'emoji': '🎨🖼️', 'words': ['I', 'draw', 'a', 'picture', 'We', 'song']},
        {'sentence': 'The bell rings loudly', 'emoji': '🔔📢', 'words': ['The', 'bell', 'rings', 'loudly', 'drum', 'softly']},
        {'sentence': 'Students sit in class', 'emoji': '🧑‍🎓🪑', 'words': ['Students', 'sit', 'in', 'class', 'Teachers', 'garden']},
        {'sentence': 'I count the numbers', 'emoji': '🔢✋', 'words': ['I', 'count', 'the', 'numbers', 'We', 'letters']},
        {'sentence': 'We sing a song', 'emoji': '🎵🎤', 'words': ['We', 'sing', 'a', 'song', 'They', 'book']},
        {'sentence': 'I like my school', 'emoji': '🏫❤️', 'words': ['I', 'like', 'my', 'school', 'We', 'home']},
      ],
    },
    {
      'name': 'Food',
      'sentences': [
        {'sentence': 'The apple is red', 'emoji': '🍎', 'words': ['The', 'apple', 'is', 'red', 'blue', 'banana']},
        {'sentence': 'I drink warm milk', 'emoji': '🥛🔥', 'words': ['I', 'drink', 'warm', 'milk', 'eat', 'cold']},
        {'sentence': 'Bananas are yellow', 'emoji': '🍌💛', 'words': ['Bananas', 'are', 'yellow', 'Apples', 'is', 'blue']},
        {'sentence': 'I eat rice daily', 'emoji': '🍚☀️', 'words': ['I', 'eat', 'rice', 'daily', 'We', 'bread']},
        {'sentence': 'Cake is very sweet', 'emoji': '🎂🍬', 'words': ['Cake', 'is', 'very', 'sweet', 'Bread', 'sour']},
        {'sentence': 'Water keeps us healthy', 'emoji': '💧💪', 'words': ['Water', 'keeps', 'us', 'healthy', 'Juice', 'them']},
        {'sentence': 'Ice cream is cold', 'emoji': '🍦❄️', 'words': ['Ice', 'cream', 'is', 'cold', 'hot', 'soup']},
        {'sentence': 'We eat fresh fruits', 'emoji': '🍇🍊', 'words': ['We', 'eat', 'fresh', 'fruits', 'They', 'old']},
        {'sentence': 'Pizza has cheese', 'emoji': '🍕🧀', 'words': ['Pizza', 'has', 'cheese', 'Bread', 'no', 'water']},
        {'sentence': 'Mangoes are juicy', 'emoji': '🥭💦', 'words': ['Mangoes', 'are', 'juicy', 'Oranges', 'is', 'dry']},
      ],
    },
    {
      'name': 'Actions',
      'sentences': [
        {'sentence': 'We play games', 'emoji': '🎮👫', 'words': ['We', 'play', 'games', 'They', 'work', 'sleep']},
        {'sentence': 'I run very fast', 'emoji': '🏃💨', 'words': ['I', 'run', 'very', 'fast', 'walk', 'slow']},
        {'sentence': 'She sings a song', 'emoji': '👧🎵', 'words': ['She', 'sings', 'a', 'song', 'He', 'book']},
        {'sentence': 'He kicks the ball', 'emoji': '👦⚽', 'words': ['He', 'kicks', 'the', 'ball', 'She', 'box']},
        {'sentence': 'I jump up high', 'emoji': '🤸⬆️', 'words': ['I', 'jump', 'up', 'high', 'sit', 'down']},
        {'sentence': 'We dance and laugh', 'emoji': '💃😂', 'words': ['We', 'dance', 'and', 'laugh', 'They', 'cry']},
        {'sentence': 'I ride my bike', 'emoji': '🚲👦', 'words': ['I', 'ride', 'my', 'bike', 'drive', 'car']},
        {'sentence': 'She paints a flower', 'emoji': '🎨🌸', 'words': ['She', 'paints', 'a', 'flower', 'He', 'tree']},
        {'sentence': 'We clap our hands', 'emoji': '👏✋', 'words': ['We', 'clap', 'our', 'hands', 'They', 'feet']},
        {'sentence': 'I swim in water', 'emoji': '🏊💧', 'words': ['I', 'swim', 'in', 'water', 'run', 'sand']},
      ],
    },
  ];

  String get currentProgressKey => progressKeys[currentLevel.value];
  List<Map<String, dynamic>> get currentSentences =>
      levels[currentLevel.value]['sentences'] as List<Map<String, dynamic>>;

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
      debugPrint("SentenceFormation TTS Init Error: $e");
    }
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

  void selectLevel(int index) {
    currentLevel.value = index;
    currentSentenceIndex.value = 0;
    selectedWords.clear();
    score.value = 0;
    showResult.value = false;
    isCorrect.value = false;
    _shuffleCurrentWords();
  }

  void _shuffleCurrentWords() {
    final data = currentSentences[currentSentenceIndex.value];
    (data['words'] as List<String>).shuffle();
  }

  void selectWord(String word) {
    if (showResult.value) return;
    selectedWords.add(word);
  }

  void removeWord(int index) {
    if (showResult.value) return;
    selectedWords.removeAt(index);
  }

  void checkSentence() {
    final correctSentence =
        currentSentences[currentSentenceIndex.value]['sentence'] as String;
    final userSentence = selectedWords.join(' ');
    isCorrect.value = userSentence == correctSentence;

    if (isCorrect.value) {
      score.value += 15;
      speak("Excellent! $correctSentence");
      _progressService.markItemCompleted(
          currentProgressKey, currentSentenceIndex.value);
    } else {
      speak("Try again!");
    }
    showResult.value = true;
  }

  void nextSentence() {
    if (currentSentenceIndex.value < currentSentences.length - 1) {
      currentSentenceIndex.value++;
    } else {
      currentSentenceIndex.value = 0;
    }
    selectedWords.clear();
    showResult.value = false;
    isCorrect.value = false;
    _shuffleCurrentWords();
  }

  void previousSentence() {
    if (currentSentenceIndex.value > 0) {
      currentSentenceIndex.value--;
    } else {
      currentSentenceIndex.value = currentSentences.length - 1;
    }
    selectedWords.clear();
    showResult.value = false;
    isCorrect.value = false;
    _shuffleCurrentWords();
  }

  void resetCurrent() {
    selectedWords.clear();
    showResult.value = false;
    isCorrect.value = false;
  }

  void speakHint() {
    speak(currentSentences[currentSentenceIndex.value]['sentence'] as String);
  }

  bool isSentenceCompleted(int sentenceIndex) {
    return _progressService.isItemCompleted(currentProgressKey, sentenceIndex);
  }

  void resetProgress() {
    for (var key in progressKeys) {
      _progressService.resetProgress(key);
    }
  }

  Future<void> resetLevelProgress(int levelIndex) async {
    await _progressService.resetProgress(progressKeys[levelIndex]);
  }
}
