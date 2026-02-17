import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/rewards_service.dart';

class StoriesController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage box = GetStorage();

  ProgressService get _progressService {
    if (!Get.isRegistered<ProgressService>()) {
      Get.put(ProgressService(), permanent: true);
    }
    return Get.find<ProgressService>();
  }

  RewardsService get _rewardsService {
    if (!Get.isRegistered<RewardsService>()) {
      Get.put(RewardsService(), permanent: true);
    }
    return Get.find<RewardsService>();
  }

  final RxInt currentStoryIndex = 0.obs;
  final RxBool isReading = false.obs;
  final RxList<int> completedStories = <int>[].obs;

  // Line-by-line highlighting
  final RxInt currentLineIndex = (-1).obs;
  final RxInt currentWordIndex = (-1).obs;
  int _speakingLineIndex = 0;
  bool _isSpeakingLine = false;
  List<String> _currentLines = [];

  Function(int lineIndex)? _onLineChanged;
  Function(int wordIndex)? _onWordChanged;

  final List<Map<String, dynamic>> stories = [
    {
      'title': 'The Thirsty Crow',
      'emoji': '🐦',
      'moral': 'Where there is a will, there is a way.',
      'story': '''Once upon a time, a thirsty crow was flying in search of water. He flew and flew but could not find any water.

Finally, he saw a pot with some water at the bottom. But his beak could not reach the water. The crow thought and thought.

Then he had an idea! He picked up small pebbles and dropped them into the pot one by one. The water level rose higher and higher.

Soon the water came up to the top of the pot. The clever crow drank the water and flew away happily.''',
      'color': 0xFF45B7D1,
    },
    {
      'title': 'The Lion and The Mouse',
      'emoji': '🦁',
      'moral': 'A friend in need is a friend indeed. Even the small can help the mighty.',
      'story': '''One day, a mighty lion was sleeping in the jungle. A little mouse ran across his nose and woke him up.

The lion caught the mouse in his paw. "How dare you wake me up! I will eat you!" roared the lion.

"Please let me go," begged the mouse. "One day I will help you." The lion laughed but let the mouse go.

A few days later, the lion was caught in a hunter's net. The little mouse heard his roar and came running. She chewed through the ropes and set the lion free.

The lion thanked the mouse and they became best friends.''',
      'color': 0xFFFF6B6B,
    },
    {
      'title': 'The Tortoise and The Hare',
      'emoji': '🐢',
      'moral': 'Slow and steady wins the race.',
      'story': '''A hare and a tortoise decided to have a race. The hare was very fast and the tortoise was very slow.

The race began. The hare ran very fast and was soon far ahead. He looked back and saw the tortoise far behind.

"I have plenty of time," thought the hare. "I will take a nap." And he fell asleep under a tree.

The tortoise kept walking slowly but steadily. He passed the sleeping hare and reached the finish line first!

When the hare woke up, he ran as fast as he could, but it was too late. The tortoise had won the race!''',
      'color': 0xFF56D97F,
    },
    {
      'title': 'The Boy Who Cried Wolf',
      'emoji': '🐺',
      'moral': 'Nobody believes a liar, even when he speaks the truth.',
      'story': '''A shepherd boy lived in a village. Every day, he took his sheep to the hill to graze.

One day, he felt bored and shouted, "Wolf! Wolf! Help!" The villagers ran to help him but found no wolf. The boy laughed at them.

The next day, he did the same thing. Again the villagers came running and found no wolf. They were very angry.

A few days later, a real wolf came. The boy shouted, "Wolf! Wolf!" But no one came to help him because they thought he was lying again.

The wolf ate many of his sheep. The boy learned his lesson about telling lies.''',
      'color': 0xFFA78BFA,
    },
    {
      'title': 'The Fox and The Grapes',
      'emoji': '🦊',
      'moral': 'It is easy to hate what you cannot have.',
      'story': '''One hot summer day, a fox was walking through a forest. He was very hungry and thirsty.

He saw a bunch of beautiful grapes hanging from a vine high above. "Those grapes look so juicy and delicious!" thought the fox.

The fox jumped and jumped but could not reach the grapes. He tried again and again but failed.

Finally, the tired fox walked away saying, "Those grapes are probably sour anyway. I don't want them."

But the truth was, he could not get them, so he pretended he did not want them.''',
      'color': 0xFFFFAA5A,
    },
    {
      'title': 'The Golden Egg',
      'emoji': '🥚',
      'moral': 'Greed often leads to loss. Be happy with what you have.',
      'story': '''A farmer had a wonderful goose. Every day, the goose laid a golden egg. The farmer and his wife became very rich.

But the farmer was greedy. He wanted to get all the golden eggs at once. "If I cut open the goose, I can get all the eggs inside!" he thought.

So the foolish farmer cut open the goose. But there were no golden eggs inside. The goose was just like any other goose inside.

Now the farmer had no goose and no more golden eggs. He lost everything because of his greed.''',
      'color': 0xFFFFE66D,
    },
    {
      'title': 'The Ant and The Grasshopper',
      'emoji': '🐜',
      'moral': 'Work hard today for a better tomorrow.',
      'story': '''In summer, an ant worked hard every day collecting food. A grasshopper played and sang all day long.

"Why do you work so hard?" asked the grasshopper. "Come and play with me!"

"I am saving food for winter," said the ant. "You should do the same."

But the grasshopper just laughed and continued playing.

When winter came, the grasshopper had no food. He was cold and hungry. The ant had plenty of food because he had worked hard all summer.

The grasshopper learned that it is important to work hard and save for the future.''',
      'color': 0xFF4ECDC4,
    },
    {
      'title': 'The Ugly Duckling',
      'emoji': '🦆',
      'moral': 'Never judge anyone by their appearance. Everyone is beautiful in their own way.',
      'story': '''A mother duck had many ducklings. One of them looked different from the others. He was big and grey.

The other ducklings teased him. "You are so ugly!" they said. The sad duckling ran away from home.

He wandered for many months. Everyone thought he was ugly. He was very sad and lonely.

One day, he saw beautiful white swans swimming in a lake. When he looked at his reflection in the water, he was surprised!

He had grown into a beautiful swan! He was not an ugly duckling at all. The swans welcomed him, and he lived happily ever after.''',
      'color': 0xFFEC407A,
    },
    {
      'title': 'The Three Little Pigs',
      'emoji': '🐷',
      'moral': 'Hard work pays off. Build things well and they will last.',
      'story': '''Three little pigs built their own houses. The first pig built his house of straw. It was quick and easy.

The second pig built his house of sticks. It was also quick to build.

The third pig worked hard and built his house of bricks. It took a long time.

One day, a big bad wolf came. He blew down the straw house easily! The first pig ran to his brother's stick house.

The wolf blew that down too! Both pigs ran to the brick house.

The wolf blew and blew but could not blow down the brick house. He gave up and ran away. The three pigs were safe!''',
      'color': 0xFFFF6EB4,
    },
    {
      'title': 'The Kind Prince',
      'emoji': '🤴',
      'moral': 'Kindness always comes back to you.',
      'story': '''Once there was a kind prince who always helped everyone. One day, he helped an old woman cross a river.

"Thank you, kind prince," said the old woman. "One day, your kindness will be rewarded."

Years later, the prince was lost in a dark forest. He was hungry and tired. A bird came and showed him the way out.

At the edge of the forest, a deer brought him food. Near his castle, a fish helped him cross a stream.

The prince realized these were all animals he had helped before. His kindness had come back to help him.''',
      'color': 0xFF5C6BC0,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _configureTTS();
    _loadCompletedStories();
  }

  void _loadCompletedStories() {
    // Load completed stories from progress service
    for (int i = 0; i < stories.length; i++) {
      if (_progressService.isItemCompleted(ProgressService.kStories, i)) {
        completedStories.add(i);
      }
    }
  }

  Future<void> _configureTTS() async {
    try {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.4); // Slower for stories
      await flutterTts.setVolume(1.0);

      flutterTts.setCompletionHandler(() {
        _isSpeakingLine = false;
        _speakNextLine();
      });

      flutterTts.setErrorHandler((msg) {
        _isSpeakingLine = false;
        _speakNextLine();
      });

      // Word progress handler for word-by-word highlighting
      flutterTts.setProgressHandler((
        String text,
        int start,
        int end,
        String word,
      ) {
        if (_speakingLineIndex >= _currentLines.length) return;

        final lineWords = _currentLines[_speakingLineIndex].split(" ");
        final index = lineWords.indexWhere(
          (w) =>
              w.replaceAll(RegExp(r'[^\w]'), '').toLowerCase() ==
              word.replaceAll(RegExp(r'[^\w]'), '').toLowerCase(),
        );

        if (index != -1) {
          currentWordIndex.value = index;
          if (_onWordChanged != null) _onWordChanged!(index);
        }
      });
    } catch (e) {
      // TTS configuration error
    }
  }

  /// Get lines for a specific story (filters out empty lines)
  List<String> getLinesForStory(int index) {
    final story = stories[index]['story'] as String;
    return story.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  /// Start speaking with line-by-line highlighting
  void startSpeakingWithHighlight(
    int storyIndex, {
    Function(int lineIndex)? onLineChanged,
    Function(int wordIndex)? onWordChanged,
  }) {
    _onLineChanged = onLineChanged;
    _onWordChanged = onWordChanged;

    _currentLines = getLinesForStory(storyIndex);
    _speakingLineIndex = 0;
    currentLineIndex.value = 0;
    currentWordIndex.value = -1;
    isReading.value = true;

    _speakLine(_speakingLineIndex);

    // Mark as completed
    _progressService.markItemCompleted(ProgressService.kStories, storyIndex);
    if (!completedStories.contains(storyIndex)) {
      completedStories.add(storyIndex);
    }

    // Award badge for reading stories
    if (_progressService.getCompletedCount(ProgressService.kStories) >= 5) {
      _rewardsService.awardBadge('reader');
    }
  }

  void _speakNextLine() {
    if (_speakingLineIndex < _currentLines.length - 1) {
      _speakingLineIndex++;
      currentWordIndex.value = -1;
      currentLineIndex.value = _speakingLineIndex;
      _speakLine(_speakingLineIndex);
    } else {
      // Finished speaking
      _speakingLineIndex = -1;
      currentLineIndex.value = -1;
      currentWordIndex.value = -1;
      isReading.value = false;
      if (_onLineChanged != null) _onLineChanged!(-1);
    }
  }

  Future<void> _speakLine(int index) async {
    if (_isSpeakingLine) return;
    _isSpeakingLine = true;
    if (_onLineChanged != null) _onLineChanged!(index);
    await flutterTts.speak(_currentLines[index]);
  }

  Future<void> readStory(int index) async {
    try {
      if (isReading.value) {
        await flutterTts.stop();
        isReading.value = false;
        return;
      }

      isReading.value = true;
      final story = stories[index];
      await flutterTts.speak('${story['title']}. ${story['story']}. Moral of the story: ${story['moral']}');

      // Mark as completed
      _progressService.markItemCompleted(ProgressService.kStories, index);
      if (!completedStories.contains(index)) {
        completedStories.add(index);
      }

      // Award badge for reading stories
      if (_progressService.getCompletedCount(ProgressService.kStories) >= 5) {
        _rewardsService.awardBadge('reader');
      }
    } catch (e) {
      isReading.value = false;
    }
  }

  Future<void> stopReading() async {
    await flutterTts.stop();
    isReading.value = false;
    currentLineIndex.value = -1;
    currentWordIndex.value = -1;
    _isSpeakingLine = false;
  }

  void selectStory(int index) {
    currentStoryIndex.value = index;
  }

  double get progressPercentage =>
      _progressService.getProgressPercentage(ProgressService.kStories);

  String get progressString =>
      _progressService.getProgressString(ProgressService.kStories);

  bool isStoryCompleted(int index) => completedStories.contains(index);

  void resetProgress() {
    completedStories.clear();
    currentStoryIndex.value = 0;
    _progressService.resetProgress(ProgressService.kStories);
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
