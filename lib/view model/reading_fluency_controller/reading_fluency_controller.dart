import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class ReadingFluencyController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  late final ProgressService _progressService;

  final currentLevel = 0.obs;
  final currentStoryIndex = 0.obs;
  final currentSentenceIndex = 0.obs;
  final isReading = false.obs;
  final completedSentences = <int>{}.obs;

  static const List<String> progressKeys = [
    ProgressService.kReadingAnimals,
    ProgressService.kReadingFamily,
    ProgressService.kReadingNature,
    ProgressService.kReadingSchool,
    ProgressService.kReadingAdventure,
    ProgressService.kReadingFriendship,
  ];

  final List<Map<String, dynamic>> levels = [
    {
      'name': 'Animals',
      'stories': [
        {
          'title': 'The Happy Cat',
          'emoji': '🐱',
          'sentences': [
            'The cat is happy.',
            'It plays with a ball.',
            'The ball is red.',
            'The cat runs fast.',
            'It jumps up high.',
          ],
        },
        {
          'title': 'My Dog',
          'emoji': '🐕',
          'sentences': [
            'I have a dog.',
            'My dog is brown.',
            'It likes to run.',
            'We play in the park.',
            'I love my dog.',
          ],
        },
        {
          'title': 'The Little Bird',
          'emoji': '🐦',
          'sentences': [
            'A bird sits on a tree.',
            'It has blue wings.',
            'The bird sings a song.',
            'It flies up in the sky.',
            'The bird finds its nest.',
          ],
        },
        {
          'title': 'The Funny Monkey',
          'emoji': '🐒',
          'sentences': [
            'The monkey is funny.',
            'It swings on the trees.',
            'It eats a banana.',
            'The monkey jumps around.',
            'All the kids laugh.',
          ],
        },
        {
          'title': 'The Big Elephant',
          'emoji': '🐘',
          'sentences': [
            'The elephant is very big.',
            'It has a long trunk.',
            'It sprays water with its trunk.',
            'The elephant walks slowly.',
            'It eats lots of leaves.',
          ],
        },
      ],
    },
    {
      'name': 'Family',
      'stories': [
        {
          'title': 'My Mother',
          'emoji': '👩',
          'sentences': [
            'My mother is kind.',
            'She cooks yummy food.',
            'She reads me stories.',
            'She gives me a hug.',
            'I love my mother.',
          ],
        },
        {
          'title': 'My Father',
          'emoji': '👨',
          'sentences': [
            'My father is strong.',
            'He goes to work.',
            'He plays with me.',
            'He teaches me new things.',
            'I love my father.',
          ],
        },
        {
          'title': 'My Baby Sister',
          'emoji': '👶',
          'sentences': [
            'I have a baby sister.',
            'She is very small.',
            'She smiles a lot.',
            'She likes her toys.',
            'I help take care of her.',
          ],
        },
        {
          'title': 'My Grandparents',
          'emoji': '👴',
          'sentences': [
            'I visit my grandparents.',
            'They live in a big house.',
            'Grandma makes me cookies.',
            'Grandpa tells me stories.',
            'I love visiting them.',
          ],
        },
        {
          'title': 'Family Dinner',
          'emoji': '🍽️',
          'sentences': [
            'We eat dinner together.',
            'Mom makes rice and dal.',
            'Dad cuts the salad.',
            'We all sit at the table.',
            'It is the best time of day.',
          ],
        },
      ],
    },
    {
      'name': 'Nature',
      'stories': [
        {
          'title': 'The Sun',
          'emoji': '☀️',
          'sentences': [
            'The sun is bright.',
            'It comes up in the morning.',
            'The sun gives us light.',
            'It makes us warm.',
            'The sun goes down at night.',
          ],
        },
        {
          'title': 'The Garden',
          'emoji': '🌻',
          'sentences': [
            'We have a garden.',
            'Flowers grow in it.',
            'The flowers are pretty.',
            'Bees come to visit.',
            'I water the plants.',
          ],
        },
        {
          'title': 'The Rainbow',
          'emoji': '🌈',
          'sentences': [
            'It rained today.',
            'Now the rain has stopped.',
            'I see a rainbow.',
            'It has many colors.',
            'The rainbow is beautiful.',
          ],
        },
        {
          'title': 'The Big Tree',
          'emoji': '🌳',
          'sentences': [
            'There is a big tree.',
            'It has many green leaves.',
            'Birds sit on its branches.',
            'We play under the tree.',
            'The tree gives us shade.',
          ],
        },
        {
          'title': 'The River',
          'emoji': '🏞️',
          'sentences': [
            'The river flows fast.',
            'The water is clear.',
            'Fish swim in the river.',
            'We sit by the river.',
            'It makes a nice sound.',
          ],
        },
      ],
    },
    {
      'name': 'School',
      'stories': [
        {
          'title': 'My School',
          'emoji': '🏫',
          'sentences': [
            'I go to school.',
            'My school is big.',
            'I learn to read.',
            'I have many friends.',
            'I like my school.',
          ],
        },
        {
          'title': 'My Teacher',
          'emoji': '👩‍🏫',
          'sentences': [
            'My teacher is nice.',
            'She teaches us to read.',
            'She helps us learn.',
            'She draws on the board.',
            'We all love our teacher.',
          ],
        },
        {
          'title': 'The School Bus',
          'emoji': '🚌',
          'sentences': [
            'The school bus is yellow.',
            'It picks me up every day.',
            'I sit with my friend.',
            'We sing songs on the bus.',
            'The bus takes us to school.',
          ],
        },
        {
          'title': 'Art Class',
          'emoji': '🎨',
          'sentences': [
            'I like art class.',
            'We use many colors.',
            'I draw a big sun.',
            'My friend draws a house.',
            'The teacher says good job.',
          ],
        },
        {
          'title': 'The Playground',
          'emoji': '🛝',
          'sentences': [
            'We go to the playground.',
            'I swing on the swing.',
            'My friend goes on the slide.',
            'We run and play tag.',
            'It is so much fun.',
          ],
        },
      ],
    },
    {
      'name': 'Adventure',
      'stories': [
        {
          'title': 'The Magic Box',
          'emoji': '📦',
          'sentences': [
            'I found a magic box.',
            'I opened it slowly.',
            'A light came out.',
            'It showed me a new world.',
            'What a great adventure!',
          ],
        },
        {
          'title': 'The Pirate Ship',
          'emoji': '🏴‍☠️',
          'sentences': [
            'We sailed on a pirate ship.',
            'The sea was very blue.',
            'We found a treasure map.',
            'We dug for the gold.',
            'We found the treasure!',
          ],
        },
        {
          'title': 'Space Trip',
          'emoji': '🚀',
          'sentences': [
            'I went to space.',
            'The rocket flew very fast.',
            'I saw the moon up close.',
            'Stars were all around.',
            'Space is amazing!',
          ],
        },
        {
          'title': 'The Deep Forest',
          'emoji': '🌲',
          'sentences': [
            'We walked into the forest.',
            'The trees were very tall.',
            'We heard birds singing.',
            'We found a little stream.',
            'The forest was magical.',
          ],
        },
        {
          'title': 'The Flying Carpet',
          'emoji': '🧞',
          'sentences': [
            'I had a flying carpet.',
            'It took me over the mountains.',
            'I saw rivers and cities.',
            'I waved at the birds.',
            'What a wonderful ride!',
          ],
        },
      ],
    },
    {
      'name': 'Friendship',
      'stories': [
        {
          'title': 'My Best Friend',
          'emoji': '👫',
          'sentences': [
            'I have a best friend.',
            'We play together every day.',
            'We share our toys.',
            'We laugh a lot.',
            'Friends are the best!',
          ],
        },
        {
          'title': 'The New Kid',
          'emoji': '🧒',
          'sentences': [
            'A new kid came to class.',
            'She was sitting alone.',
            'I went and said hello.',
            'We became good friends.',
            'Now she smiles every day.',
          ],
        },
        {
          'title': 'Sharing is Caring',
          'emoji': '🤝',
          'sentences': [
            'I had two apples.',
            'My friend had none.',
            'I gave one to my friend.',
            'She smiled and said thank you.',
            'Sharing makes us happy.',
          ],
        },
        {
          'title': 'The Team',
          'emoji': '⚽',
          'sentences': [
            'We play on a team.',
            'We practice every day.',
            'We help each other.',
            'We won the big game.',
            'Teamwork makes us strong.',
          ],
        },
        {
          'title': 'A Kind Act',
          'emoji': '💝',
          'sentences': [
            'My friend was sad today.',
            'I sat next to her.',
            'I drew her a picture.',
            'She felt much better.',
            'Being kind feels good.',
          ],
        },
      ],
    },
  ];

  String get currentProgressKey => progressKeys[currentLevel.value];
  List<Map<String, dynamic>> get currentStories =>
      levels[currentLevel.value]['stories'] as List<Map<String, dynamic>>;

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
        await flutterTts.setSpeechRate(0.35);
        await flutterTts.setVolume(1.0);
        await flutterTts.awaitSpeakCompletion(true);
      }
    } catch (e) {
      debugPrint("ReadingFluency TTS Init Error: $e");
    }
  }

  void selectLevel(int index) {
    currentLevel.value = index;
    currentStoryIndex.value = 0;
    currentSentenceIndex.value = 0;
    isReading.value = false;
    completedSentences.clear();
  }

  void selectStory(int index) {
    currentStoryIndex.value = index;
    currentSentenceIndex.value = 0;
    completedSentences.clear();
  }

  void nextStory() {
    if (currentStoryIndex.value < currentStories.length - 1) {
      currentStoryIndex.value++;
    } else {
      currentStoryIndex.value = 0;
    }
    currentSentenceIndex.value = 0;
    completedSentences.clear();
  }

  void previousStory() {
    if (currentStoryIndex.value > 0) {
      currentStoryIndex.value--;
    } else {
      currentStoryIndex.value = currentStories.length - 1;
    }
    currentSentenceIndex.value = 0;
    completedSentences.clear();
  }

  Future<void> readSentence(int index) async {
    final story = currentStories[currentStoryIndex.value];
    final sentences = story['sentences'] as List<String>;
    currentSentenceIndex.value = index;
    isReading.value = true;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await flutterTts.speak(sentences[index]);
      }
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
    isReading.value = false;
    completedSentences.add(index);

    // Mark story as completed if all sentences read
    if (completedSentences.length == sentences.length) {
      _progressService.markItemCompleted(
          currentProgressKey, currentStoryIndex.value);
    }
  }

  Future<void> readFullStory() async {
    final story = currentStories[currentStoryIndex.value];
    final sentences = story['sentences'] as List<String>;
    isReading.value = true;

    for (int i = 0; i < sentences.length; i++) {
      if (!isReading.value) break;
      currentSentenceIndex.value = i;
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          await flutterTts.speak(sentences[i]);
        }
      } catch (e) {
        debugPrint("TTS Error: $e");
      }
      await Future.delayed(const Duration(milliseconds: 500));
      completedSentences.add(i);
    }

    isReading.value = false;

    // Mark story as completed if all sentences read
    if (completedSentences.length == sentences.length) {
      _progressService.markItemCompleted(
          currentProgressKey, currentStoryIndex.value);
    }
  }

  void stopReading() {
    flutterTts.stop();
    isReading.value = false;
  }

  bool isStoryCompleted(int storyIndex) {
    return _progressService.isItemCompleted(currentProgressKey, storyIndex);
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
