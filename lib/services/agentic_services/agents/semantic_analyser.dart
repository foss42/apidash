import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class ResponseSemanticAnalyser extends AIAgent {
  @override
  String get agentName => 'RESP_SEMANTIC_ANALYSER';

  @override
  String getSystemPrompt() {
    return kPromptSemanticAnalyser;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    //Add any specific validations here as needed
    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    return {
      'SEMANTIC_ANALYSIS': validatedResponse,
    };
  }
}
