import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ollama_dart/ollama_dart.dart';

class APIDashOllamaService {
  static Future<String?> ollama(
    String systemPrompt,
    String input, [
    String model = 'llama3',
  ]) async {
    //check Ollama Avaiability
    final result =
        await Process.run('curl', ['http://localhost:11434/api/tags']);
    if (result.exitCode != 0) {
      print('OLLAMA_NOT_ACTIVE');
      return null;
    }

    final inpS = input == '' ? '' : '\nProvided Inputs:$input';
    final client = OllamaClient();
    final generated = await client.generateCompletion(
      request: GenerateCompletionRequest(
        model: model,
        prompt: "$systemPrompt$inpS",
      ),
    );
    return generated.response;
  }
  //Future ollama enhancements can go here
}

class APIDashCustomLLMService {
  static Future<String?> gemini(
    String systemPrompt,
    String input,
    String apiKey,
  ) async {
    final inpS = input == '' ? '' : '\nProvided Inputs:$input';
    String combinedInput = "$systemPrompt$inpS";

    // throw Exception(); //TO SIMULATE EXCEPTION

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            "parts": [
              {"text": combinedInput}
            ]
          }
        ]
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'];
    } else {
      throw Exception(
        'GEMINI_EXCEPTION: ${response.statusCode}\n${response.body}',
      );
    }
  }

  static Future<String?> claude(
    String systemPrompt,
    String input,
    String apiKey,
  ) async {
    //IMPL PENDING
    return null;
  }

  static Future<String?> chatgpt(
    String systemPrompt,
    String input,
    String apiKey,
  ) async {
    //IMPL PENDING
    return null;
  }

  static Future<String?> openai_azure(
    String systemPrompt,
    String input,
    String credential,
  ) async {
    //KEY_FORMAT: domain|modelname|apiv|key

    final credParts = credential.split('|');
    final domain = credParts[0];
    final modelname = credParts[1];
    final apiversion = credParts[2];
    final apiKey = credParts[3];

    final String apiUrl =
        "https://$domain.openai.azure.com/openai/deployments/$modelname/chat/completions?api-version=$apiversion";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "api-key": apiKey,
        },
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": systemPrompt},
            if (input.isNotEmpty)
              {"role": "user", "content": input}
            else
              {"role": "user", "content": "Generate"}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["choices"]?[0]["message"]?["content"]?.trim();
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  //Other Custom LLM Solutions
}
