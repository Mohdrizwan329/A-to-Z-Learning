import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Thrown when Gemini could not produce an answer -- bad/missing key, HTTP
/// failure, or a reply that got blocked before any text came back.
class GeminiException implements Exception {
  GeminiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Thin wrapper over the Gemini REST API (`generativelanguage.googleapis.com`).
///
/// Both the MCQ scanner and the math solver ask for a JSON object back, so the
/// single entry point here forces `application/json` responses and hands the
/// caller the raw text to decode.
class GeminiService {
  GeminiService._();

  /// Free-tier friendly default; override with GEMINI_MODEL in .env.
  static const String _defaultModel = 'gemini-2.5-flash';

  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static String get _model =>
      (dotenv.env['GEMINI_MODEL'] ?? '').trim().isEmpty
          ? _defaultModel
          : dotenv.env['GEMINI_MODEL']!.trim();

  static bool get hasApiKey => _apiKey.trim().isNotEmpty;

  /// Sends [prompt] with [systemInstruction] and returns the model's text.
  ///
  /// Pass [imageBytes] to send the photo itself alongside the prompt. The
  /// model then reads the page directly, which is the only way to get at a
  /// handwritten sum, a fraction stacked over a line, or a geometry figure --
  /// none of which survive an OCR pass as usable text.
  ///
  /// [thinkingBudget] defaults to 0: 2.5-flash reasoning tokens come out of
  /// the output budget, so on a short budget they leave an empty candidate
  /// behind. Raise it only together with [maxOutputTokens].
  static Future<String> generateJson({
    required String systemInstruction,
    required String prompt,
    double temperature = 0.3,
    int maxOutputTokens = 1024,
    List<int>? imageBytes,
    String imageMimeType = 'image/jpeg',
    int thinkingBudget = 0,
  }) async {
    if (!hasApiKey) {
      throw GeminiException('GEMINI_API_KEY not found in .env file');
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent',
    );

    final http.Response response;
    try {
      response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': _apiKey,
            },
            body: jsonEncode({
              'system_instruction': {
                'parts': [
                  {'text': systemInstruction},
                ],
              },
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    if (imageBytes != null)
                      {
                        'inline_data': {
                          'mime_type': imageMimeType,
                          'data': base64Encode(imageBytes),
                        },
                      },
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': temperature,
                'maxOutputTokens': maxOutputTokens,
                'responseMimeType': 'application/json',
                'thinkingConfig': {'thinkingBudget': thinkingBudget},
              },
            }),
          )
          .timeout(Duration(seconds: imageBytes == null ? 60 : 120));
    } catch (e) {
      throw GeminiException('Network error: $e');
    }

    if (response.statusCode != 200) {
      throw GeminiException(_errorMessage(response));
    }

    final text = _extractText(response.body);
    if (text == null || text.trim().isEmpty) {
      throw GeminiException('Gemini returned an empty response');
    }
    return text;
  }

  /// Pulls the reply out of `candidates[0].content.parts[*].text`.
  static String? _extractText(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) return null;

      final content = (candidates.first as Map<String, dynamic>)['content'];
      if (content is! Map<String, dynamic>) return null;

      final parts = content['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) return null;

      return parts
          .whereType<Map<String, dynamic>>()
          .map((part) => part['text'])
          .whereType<String>()
          .join();
    } catch (_) {
      return null;
    }
  }

  /// Gemini puts a human-readable reason in `error.message`; fall back to the
  /// status code when the body is not the shape we expect.
  static String _errorMessage(http.Response response) {
    try {
      final error = (jsonDecode(response.body) as Map<String, dynamic>)['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String && message.trim().isNotEmpty) {
          return 'Gemini error ${response.statusCode}: $message';
        }
      }
    } catch (_) {
      // Fall through to the plain status code.
    }
    return 'Gemini error: Status ${response.statusCode}';
  }

  /// Strips ```json fences some models still emit around JSON payloads.
  static String stripCodeFences(String response) {
    var clean = response.trim();
    if (clean.startsWith('```json')) {
      clean = clean.substring(7);
    } else if (clean.startsWith('```')) {
      clean = clean.substring(3);
    }
    if (clean.endsWith('```')) {
      clean = clean.substring(0, clean.length - 3);
    }
    return clean.trim();
  }
}
