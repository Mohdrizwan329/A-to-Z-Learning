import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  TextToSpeechService() {
    _initTts();
  }

  void _initTts() async {
    try {
      await _flutterTts.setLanguage("hi-IN"); // Hindi - India
      await _flutterTts.setPitch(1.0); // Normal pitch
      await _flutterTts.setSpeechRate(0.5); // Slower speech for clarity
      await _flutterTts.setVolume(1.0); // Max volume
    } catch (e) {
      print("TTS Initialization Error: $e");
    }
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print(" TTS Speak Error: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print(" TTS Stop Error: $e");
    }
  }

  void dispose() {
    stop();
  }
}
