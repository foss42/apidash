import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';

const String kPromptApiToolBodyGen =
    'Generate a valid API request body based on the provided schema and requirements.';

class ApiToolBodyGen extends AIAgent {
  @override
  String get agentName => 'APITOOL_BODYGEN';

  @override
  String getSystemPrompt() => kPromptApiToolBodyGen;

  @override
  Future<bool> validator(String aiResponse) async {
    // 🛡️ Defense: Most API bodies are JSON.
    // We attempt to parse it to ensure the AI didn't return garbage.
    try {
      final clean = aiResponse.replaceAll(RegExp(r'```json\n?|```'), '').trim();
      jsonDecode(clean);
      return true;
    } catch (e) {
      // If it's not JSON, we check if it's at least valid plain text/form-data
      return aiResponse.trim().isNotEmpty && aiResponse.length > 2;
    }
  }

  @override
  Future<Map<String, dynamic>> outputFormatter(String validatedResponse) async {
    // 🛡️ Defense: Stripping markdown is critical here.
    // Sending "```json ..." to a server will cause a 400 Bad Request.
    final cleanBody =
        validatedResponse.replaceAll(RegExp(r'```[a-zA-Z]*\n?|```'), '').trim();

    return {
      'REQUEST_BODY': cleanBody,
    };
  }
}
