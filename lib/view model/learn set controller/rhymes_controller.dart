import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/services/rewards_service.dart';

class RhymesController extends GetxController {
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

  final RxInt currentRhymeIndex = 0.obs;
  final RxBool isSinging = false.obs;
  final RxList<int> completedRhymes = <int>[].obs;

  // Line-by-line highlighting
  final RxInt currentLineIndex = (-1).obs;
  final RxInt currentWordIndex = (-1).obs;
  int _speakingLineIndex = 0;
  bool _isSpeakingLine = false;
  List<String> _currentLines = [];

  Function(int lineIndex)? _onLineChanged;
  Function(int wordIndex)? _onWordChanged;

  final List<Map<String, dynamic>> rhymes = [
    {
      'title': 'Twinkle Twinkle Little Star',
      'emoji': '⭐',
      'lyrics': '''Twinkle, twinkle, little star,
How I wonder what you are!
Up above the world so high,
Like a diamond in the sky.

When the blazing sun is gone,
When he nothing shines upon,
Then you show your little light,
Twinkle, twinkle, all the night.''',
      'color': 0xFFFFE66D,
    },
    {
      'title': 'Johnny Johnny Yes Papa',
      'emoji': '��',
      'lyrics': '''Johnny, Johnny,
Yes, Papa?
Eating sugar?
No, Papa.
Telling lies?
No, Papa.
Open your mouth.
Ha! Ha! Ha!''',
      'color': 0xFFFF6B6B,
    },
    {
      'title': 'Baa Baa Black Sheep',
      'emoji': '🐑',
      'lyrics': '''Baa, baa, black sheep,
Have you any wool?
Yes sir, yes sir,
Three bags full.

One for the master,
One for the dame,
And one for the little boy
Who lives down the lane.''',
      'color': 0xFF45B7D1,
    },
    {
      'title': 'Mary Had a Little Lamb',
      'emoji': '🐑',
      'lyrics': '''Mary had a little lamb,
Little lamb, little lamb,
Mary had a little lamb,
Its fleece was white as snow.

And everywhere that Mary went,
Mary went, Mary went,
Everywhere that Mary went,
The lamb was sure to go.''',
      'color': 0xFFA78BFA,
    },
    {
      'title': 'Humpty Dumpty',
      'emoji': '🥚',
      'lyrics': '''Humpty Dumpty sat on a wall,
Humpty Dumpty had a great fall.
All the king's horses and all the king's men
Couldn't put Humpty together again.''',
      'color': 0xFFFFAA5A,
    },
    {
      'title': 'Jack and Jill',
      'emoji': '🏔️',
      'lyrics': '''Jack and Jill went up the hill
To fetch a pail of water.
Jack fell down and broke his crown,
And Jill came tumbling after.

Up Jack got, and home did trot,
As fast as he could caper,
He went to bed to mend his head,
With vinegar and brown paper.''',
      'color': 0xFF56D97F,
    },
    {
      'title': 'Row Row Row Your Boat',
      'emoji': '⛵',
      'lyrics': '''Row, row, row your boat,
Gently down the stream.
Merrily, merrily, merrily, merrily,
Life is but a dream.

Row, row, row your boat,
Gently down the brook.
If you catch a little fish,
Let it off the hook.''',
      'color': 0xFF4ECDC4,
    },
    {
      'title': 'Old MacDonald Had a Farm',
      'emoji': '🚜',
      'lyrics': '''Old MacDonald had a farm,
E-I-E-I-O!
And on his farm he had a cow,
E-I-E-I-O!
With a moo-moo here,
And a moo-moo there,
Here a moo, there a moo,
Everywhere a moo-moo!
Old MacDonald had a farm,
E-I-E-I-O!''',
      'color': 0xFF5C6BC0,
    },
    {
      'title': 'Itsy Bitsy Spider',
      'emoji': '🕷️',
      'lyrics': '''The itsy bitsy spider
Climbed up the water spout.
Down came the rain
And washed the spider out.

Out came the sun
And dried up all the rain,
And the itsy bitsy spider
Climbed up the spout again.''',
      'color': 0xFFEC407A,
    },
    {
      'title': 'Five Little Monkeys',
      'emoji': '🐒',
      'lyrics': '''Five little monkeys jumping on the bed,
One fell off and bumped his head.
Mama called the doctor and the doctor said,
"No more monkeys jumping on the bed!"

Four little monkeys jumping on the bed,
One fell off and bumped his head.
Mama called the doctor and the doctor said,
"No more monkeys jumping on the bed!"''',
      'color': 0xFFFF6EB4,
    },
    {
      'title': 'Head Shoulders Knees and Toes',
      'emoji': '🧍',
      'lyrics': '''Head, shoulders, knees and toes,
Knees and toes.
Head, shoulders, knees and toes,
Knees and toes.

And eyes and ears and mouth and nose.
Head, shoulders, knees and toes,
Knees and toes!''',
      'color': 0xFF11998E,
    },
    {
      'title': 'Wheels on the Bus',
      'emoji': '🚌',
      'lyrics': '''The wheels on the bus go round and round,
Round and round, round and round.
The wheels on the bus go round and round,
All through the town.

The doors on the bus go open and shut,
Open and shut, open and shut.
The doors on the bus go open and shut,
All through the town.''',
      'color': 0xFFE17055,
    },
    {
      'title': 'If You Are Happy',
      'emoji': '😊',
      'lyrics': '''If you're happy and you know it, clap your hands!
If you're happy and you know it, clap your hands!
If you're happy and you know it,
And you really want to show it,
If you're happy and you know it, clap your hands!

If you're happy and you know it, stomp your feet!
If you're happy and you know it, stomp your feet!''',
      'color': 0xFFFDCB6E,
    },
    {
      'title': 'Rain Rain Go Away',
      'emoji': '🌧️',
      'lyrics': '''Rain, rain, go away,
Come again another day.
Little Johnny wants to play,
Rain, rain, go away.

Rain, rain, go to Spain,
Never show your face again.
Rain, rain, go away,
Come again another day.''',
      'color': 0xFF74B9FF,
    },
    {
      'title': 'Happy Birthday',
      'emoji': '🎂',
      'lyrics': '''Happy birthday to you,
Happy birthday to you,
Happy birthday, dear friend,
Happy birthday to you!

May your wishes come true,
May your dreams all shine through,
Happy birthday, dear friend,
Happy birthday to you!''',
      'color': 0xFFFF9FF3,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _configureTTS();
    _loadCompletedRhymes();
  }

  void _loadCompletedRhymes() {
    for (int i = 0; i < rhymes.length; i++) {
      if (_progressService.isItemCompleted(ProgressService.kRhymes, i)) {
        completedRhymes.add(i);
      }
    }
  }

  Future<void> _configureTTS() async {
    try {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.45);
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

  /// Get lines for a specific rhyme (filters out empty lines)
  List<String> getLinesForRhyme(int index) {
    final lyrics = rhymes[index]['lyrics'] as String;
    return lyrics.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  /// Start speaking with line-by-line highlighting
  void startSpeakingWithHighlight(
    int rhymeIndex, {
    Function(int lineIndex)? onLineChanged,
    Function(int wordIndex)? onWordChanged,
  }) {
    _onLineChanged = onLineChanged;
    _onWordChanged = onWordChanged;

    _currentLines = getLinesForRhyme(rhymeIndex);
    _speakingLineIndex = 0;
    currentLineIndex.value = 0;
    currentWordIndex.value = -1;
    isSinging.value = true;

    _speakLine(_speakingLineIndex);

    // Mark as completed
    _progressService.markItemCompleted(ProgressService.kRhymes, rhymeIndex);
    if (!completedRhymes.contains(rhymeIndex)) {
      completedRhymes.add(rhymeIndex);
    }

    // Award badge for learning rhymes
    if (_progressService.getCompletedCount(ProgressService.kRhymes) >= 5) {
      _rewardsService.awardBadge('singer');
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
      isSinging.value = false;
      if (_onLineChanged != null) _onLineChanged!(-1);
    }
  }

  Future<void> _speakLine(int index) async {
    if (_isSpeakingLine) return;
    _isSpeakingLine = true;
    if (_onLineChanged != null) _onLineChanged!(index);
    await flutterTts.speak(_currentLines[index]);
  }

  Future<void> singRhyme(int index) async {
    try {
      if (isSinging.value) {
        await flutterTts.stop();
        isSinging.value = false;
        currentLineIndex.value = -1;
        currentWordIndex.value = -1;
        _isSpeakingLine = false;
        return;
      }

      isSinging.value = true;
      final rhyme = rhymes[index];
      await flutterTts.speak(rhyme['lyrics']!);

      // Mark as completed
      _progressService.markItemCompleted(ProgressService.kRhymes, index);
      if (!completedRhymes.contains(index)) {
        completedRhymes.add(index);
      }

      // Award badge for learning rhymes
      if (_progressService.getCompletedCount(ProgressService.kRhymes) >= 5) {
        _rewardsService.awardBadge('singer');
      }
    } catch (e) {
      isSinging.value = false;
    }
  }

  Future<void> stopSinging() async {
    await flutterTts.stop();
    isSinging.value = false;
    currentLineIndex.value = -1;
    currentWordIndex.value = -1;
    _isSpeakingLine = false;
  }

  void selectRhyme(int index) {
    currentRhymeIndex.value = index;
  }

  double get progressPercentage =>
      _progressService.getProgressPercentage(ProgressService.kRhymes);

  String get progressString =>
      _progressService.getProgressString(ProgressService.kRhymes);

  bool isRhymeCompleted(int index) => completedRhymes.contains(index);

  void refreshCompletedRhymes() {
    completedRhymes.clear();
    for (int i = 0; i < rhymes.length; i++) {
      if (_progressService.isItemCompleted(ProgressService.kRhymes, i)) {
        completedRhymes.add(i);
      }
    }
  }

  void resetProgress() {
    completedRhymes.clear();
    currentRhymeIndex.value = 0;
    _progressService.resetProgress(ProgressService.kRhymes);
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
