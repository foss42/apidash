import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class IntermediateRepresentationGen extends AIAgent {
  @override
  String get agentName => 'INTERMEDIATE_REP_GEN';

  @override
  String getSystemPrompt() {
    return kPromptIntermediateRepGen;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    //Add any specific validations here as needed
    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```yaml', '')
        .replaceAll('```yaml\n', '')
        .replaceAll('```', '');
    return {
      'INTERMEDIATE_REPRESENTATION': validatedResponse,
    };
  }
}
