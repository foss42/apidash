import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin pure-Dart wrapper around Gemini REST API.
/// No Flutter, no dart:ui — works in any Dart environment.
class GeminiClient {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  // gemini-1.5-flash supports JSON prompting reliably without responseMimeType
  static const _model = 'gemini-2.5-flash-lite';

  /// Sends [prompt] to Gemini and returns the text response.
  /// The prompt itself must instruct the model to return JSON only.
  static Future<String> generate({
    required String apiKey,
    required String prompt,
    String? model,
  }) async {
    final targetModel = model ?? _model;
    final uri = Uri.parse('$_baseUrl/$targetModel:generateContent?key=$apiKey');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.2,
          'topP': 0.95,
          'maxOutputTokens': 8192,
          // NOTE: responseMimeType removed — not supported on all models.
          // JSON is enforced via prompt instruction instead.
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List<dynamic>;

    if (candidates.isEmpty) {
      throw Exception('Gemini returned no candidates');
    }

    final rawText = candidates[0]['content']['parts'][0]['text'] as String;

    // Strip markdown code fences if model wraps JSON in ```json ... ```
    return _stripCodeFences(rawText);
  }

  /// Strips ```json ... ``` or ``` ... ``` wrappers from Gemini output.
  static String _stripCodeFences(String text) {
    final trimmed = text.trim();
    if (trimmed.startsWith('```')) {
      final start = trimmed.indexOf('\n') + 1;
      final end = trimmed.lastIndexOf('```');
      if (end > start) return trimmed.substring(start, end).trim();
    }
    return trimmed;
  }
}