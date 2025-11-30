import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class Poem {
  final String title;
  final String content;
  final String audioPath;

  Poem({required this.title, required this.content, required this.audioPath});
}

class PoemController extends GetxController {
  final Poem poem;
  final FlutterTts flutterTts = FlutterTts();

  int currentLineIndex = 0;
  late List<String> lines;
  bool _isSpeaking = false;

  var currentWordIndex = (-1).obs;
  var currentLine = (-1).obs;

  Function(int lineIndex)? _onLineChanged;
  Function(int wordIndex)? _onWordChanged;

  PoemController(this.poem);

  @override
  void onInit() {
    super.onInit();
    lines = poem.content.split('\n');
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("hi-IN");

    await flutterTts.setPitch(1.0);

    await flutterTts.setSpeechRate(0.50);

    flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _speakNextLine();
    });

    flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      _speakNextLine();
    });

    flutterTts.setProgressHandler((
      String text,
      int start,
      int end,
      String word,
    ) {
      if (currentLineIndex >= lines.length) return;

      final lineWords = lines[currentLineIndex].split(" ");
      final index = lineWords.indexWhere(
        (w) =>
            w.replaceAll(RegExp(r'[^\w]'), '').toLowerCase() ==
            word.replaceAll(RegExp(r'[^\w]'), '').toLowerCase(),
      );

      if (index != -1) {
        currentWordIndex.value = index;
        currentLine.value = currentLineIndex;
      }
    });
  }

  void startSpeakingLines({
    Function(int lineIndex)? onLineChanged,
    Function(int wordIndex)? onWordChanged,
  }) {
    _onLineChanged = onLineChanged;
    _onWordChanged = onWordChanged;

    currentLineIndex = 0;
    currentWordIndex.value = -1;
    currentLine.value = 0;

    _speakLine(currentLineIndex);

    ever(currentWordIndex, (int wIndex) {
      if (_onWordChanged != null) _onWordChanged!(wIndex);
    });
  }

  void _speakNextLine() {
    if (currentLineIndex < lines.length - 1) {
      currentLineIndex++;
      currentWordIndex.value = -1;
      _speakLine(currentLineIndex);
    } else {
      currentLineIndex = -1;
      currentWordIndex.value = -1;
      currentLine.value = -1;
      if (_onLineChanged != null) _onLineChanged!(-1);
    }
  }

  void _speakLine(int index) async {
    if (_isSpeaking) return;
    _isSpeaking = true;
    if (_onLineChanged != null) _onLineChanged!(index);
    await flutterTts.speak(lines[index]);
    _isSpeaking = false;
  }

  void stop() {
    flutterTts.stop();
    currentLineIndex = -1;
    currentWordIndex.value = -1;
    currentLine.value = -1;
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
