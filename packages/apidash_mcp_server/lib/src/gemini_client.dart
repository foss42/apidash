import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin pure-Dart wrapper around Gemini REST API.
/// No Flutter, no dart:ui — works in any Dart environment.
class GeminiClient {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const _model = 'gemini-2.5-flash-lite';

  /// Sends [prompt] to Gemini and returns the text response.
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
          'temperature': 0.3,       // lower = more deterministic JSON
          'topP': 0.95,
          'maxOutputTokens': 8192,
          'responseMimeType': 'application/json', // forces JSON output
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Gemini API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List<dynamic>;

    if (candidates.isEmpty) {
      throw Exception('Gemini returned no candidates');
    }

    return candidates[0]['content']['parts'][0]['text'] as String;
  }
}