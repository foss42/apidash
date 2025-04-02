import 'dart:convert';
import 'package:http/http.dart' as http;
import 'schema_parser.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class LLMService {
  final String apiKey;

  LLMService(this.apiKey);

  Future<List<FieldSchema>> getWidgetSuggestions(Schema schema) async {
    final prompt = _buildPrompt(schema);

    debugPrint('[DEBUG] ===== LLM API Request Started =====');
    debugPrint('[DEBUG] Prompt:\n$prompt');

    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You are a UI assistant that recommends Flutter widget types based on field name and data type."
            },
            {
              "role": "user",
              "content": prompt,
            }
          ],
          "temperature": 0.2,
        }),
      );

      debugPrint('[DEBUG] Status code: ${response.statusCode}');
      debugPrint('[DEBUG] Response body:\n${response.body}');

      if (response.statusCode == 200) {
        final content = jsonDecode(response.body);
        final message = content['choices'][0]['message']['content'];
        debugPrint('[DEBUG] Message content:\n$message');

        final cleaned = _extractJson(message);
        final decoded = jsonDecode(cleaned);

        if (decoded['fields'] == null || decoded['fields'] is! List) {
          throw Exception('Missing or invalid "fields" in GPT response');
        }

        List<FieldSchema> updated = [];
        for (var f in decoded['fields']) {
          updated.add(FieldSchema(
            key: f['key'],
            type: f['type'],
            suggestedWidget: f['suggestedWidget'],
            label: f['label'],             
            hintText: f['hintText'],       
            icon: f['icon'],                
          ));
        }

        return updated;
      } else {
        throw Exception('Failed to fetch GPT suggestion: ${response.body}');
      }
    } catch (e) {
      debugPrint('[WARN] LLM failed, fallback: $e');
      rethrow;
    }
  }

  String _extractJson(String raw) {
    final start = raw.indexOf('{');
    final end = raw.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return raw.substring(start, end + 1);
    }
    throw Exception('Could not extract valid JSON from GPT response');
  }

  String _buildPrompt(Schema schema) {
    return '''
You are an expert Flutter UI designer. Given a field schema, your task is to:
- Suggest a widget that best represents the field
- Add field-level customization (label, hintText, icon if applicable)
- Group related fields into sections if relevant
- Format response as valid JSON that includes these details.

Schema:
${jsonEncode(schema.toJson())}

Please return in this format (only return in this format):
{
  "fields": [
    {
      "key": "email",
      "type": "string",
      "suggestedWidget": "TextField",
      "label": "Email Address",
      "hintText": "user@example.com",
      "icon": "email"
    }
  ]
}
''';
  }
}
