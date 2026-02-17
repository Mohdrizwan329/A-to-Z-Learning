import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechRecognitionService extends GetxService {
  final SpeechToText _speechToText = SpeechToText();

  final RxBool isListening = false.obs;
  final RxBool isAvailable = false.obs;
  final RxString recognizedText = ''.obs;
  final RxString lastError = ''.obs;
  final RxDouble confidence = 0.0.obs;

  // Callbacks
  Function(String)? onResult;
  Function(String)? onError;

  Future<SpeechRecognitionService> init() async {
    await _requestPermissions();
    await _initializeSpeech();
    return this;
  }

  Future<void> _requestPermissions() async {
    final micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      await Permission.microphone.request();
    }

    final speechStatus = await Permission.speech.status;
    if (!speechStatus.isGranted) {
      await Permission.speech.request();
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      isAvailable.value = await _speechToText.initialize(
        onError: (error) {
          lastError.value = error.errorMsg;
          isListening.value = false;
          onError?.call(error.errorMsg);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
      );
    } catch (e) {
      isAvailable.value = false;
      lastError.value = e.toString();
    }
  }

  Future<void> startListening({
    String locale = 'en_IN',
    Function(String)? onResultCallback,
  }) async {
    // Request permissions if not available
    if (!isAvailable.value) {
      await _requestPermissions();
      await _initializeSpeech();
    }

    if (!isAvailable.value) {
      lastError.value = 'Speech recognition not available';
      return;
    }

    recognizedText.value = '';
    onResult = onResultCallback;

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: locale,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
          listenMode: ListenMode.dictation,
        ),
      );

      isListening.value = true;
    } catch (e) {
      lastError.value = e.toString();
      isListening.value = false;
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    recognizedText.value = result.recognizedWords;
    confidence.value = result.confidence;

    if (result.finalResult) {
      isListening.value = false;
      onResult?.call(result.recognizedWords);
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    isListening.value = false;
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
    isListening.value = false;
    recognizedText.value = '';
  }

  // Check if recognized text matches expected text
  bool checkPronunciation(String expected, {double threshold = 0.7}) {
    final recognized = recognizedText.value.toLowerCase().trim();
    final expectedLower = expected.toLowerCase().trim();

    // Exact match
    if (recognized == expectedLower) return true;

    // Contains match
    if (recognized.contains(expectedLower) || expectedLower.contains(recognized)) {
      return true;
    }

    // Similarity check
    final similarity = _calculateSimilarity(recognized, expectedLower);
    return similarity >= threshold;
  }

  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    if (s1 == s2) return 1.0;

    final longer = s1.length > s2.length ? s1 : s2;
    final shorter = s1.length > s2.length ? s2 : s1;

    final longerLength = longer.length;
    if (longerLength == 0) return 1.0;

    return (longerLength - _editDistance(longer, shorter)) / longerLength;
  }

  int _editDistance(String s1, String s2) {
    final costs = List<int>.generate(s2.length + 1, (i) => i);

    for (var i = 1; i <= s1.length; i++) {
      var lastValue = i;
      for (var j = 1; j <= s2.length; j++) {
        final newValue = s1[i - 1] == s2[j - 1]
            ? costs[j - 1]
            : [costs[j - 1], lastValue, costs[j]].reduce((a, b) => a < b ? a : b) + 1;
        costs[j - 1] = lastValue;
        lastValue = newValue;
      }
      costs[s2.length] = lastValue;
    }

    return costs[s2.length];
  }

  // Get available locales
  Future<List<LocaleName>> getAvailableLocales() async {
    if (!isAvailable.value) return [];
    return await _speechToText.locales();
  }
}
