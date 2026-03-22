import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class ApiToolBodyGen extends AIAgent {
  @override
  String get agentName => 'APITOOL_BODYGEN';

  @override
  String getSystemPrompt() {
    return kPromptAPIToolBodyGen;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    //Add any specific validations here as needed
    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```python', '')
        .replaceAll('```python\n', '')
        .replaceAll('```javascript', '')
        .replaceAll('```javascript\n', '')
        .replaceAll('```', '');

    return {
      'TOOL': validatedResponse,
    };
  }
}
