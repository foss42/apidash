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
    //Add any specific validations here as needed
    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```dart', '')
        .replaceAll('```dart\n', '')
        .replaceAll('```', '');

    return {
      'CODE': validatedResponse,
    };
  }
}
