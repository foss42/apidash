import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class StacToFlutterBot extends AIAgent {
  @override
  String get agentName => 'STAC_TO_FLUTTER';

  @override
  String getSystemPrompt() {
    return kPromptStacToFlutter;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    final response = aiResponse.replaceAll(RegExp(r'```(?:dart)?'), '').trim();

    if (response.isEmpty) {
      return false;
    }

    final lowerCaseResponse = response.toLowerCase();
    const refusalPhrases = [
      'i cannot',
      "i can't",
      'i am unable',
      "i'm unable",
      'cannot provide',
      'can\'t provide',
      'unable to provide',
    ];

    if (refusalPhrases.any(lowerCaseResponse.startsWith)) {
      return false;
    }

    final hasDartCode = RegExp(
      r'\b(?:class|import|export)\s+[A-Za-z_]|'
      r'\b(?:final|const|void)\s+[A-Za-z_]|'
      r'\bWidget\s+[A-Za-z_]|'
      r'\bbuild\s*\([^)]*\)|'
      r'=>|'
      r'\b[A-Z][A-Za-z0-9_]*\(',
    ).hasMatch(response);

    return hasDartCode;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```dart', '')
        .replaceAll('```dart\n', '')
        .replaceAll('```', '');

    return {'CODE': validatedResponse};
  }
}
