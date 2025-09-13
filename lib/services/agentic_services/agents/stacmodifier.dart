import 'dart:convert';
import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class StacModifierBot extends AIAgent {
  @override
  String get agentName => 'STAC_MODIFIER';

  @override
  String getSystemPrompt() {
    return kPromptStacModifier;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    aiResponse = aiResponse.replaceAll('```json', '').replaceAll('```', '');
    //JSON CHECK
    try {
      jsonDecode(aiResponse);
    } catch (e) {
      print("JSON PARSE ERROR: ${e}");
      return false;
    }
    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```json', '')
        .replaceAll('```json\n', '')
        .replaceAll('```', '');

    //Stac Specific Changes
    validatedResponse = validatedResponse.replaceAll('bold', 'w700');

    return {
      'STAC': validatedResponse,
    };
  }
}
