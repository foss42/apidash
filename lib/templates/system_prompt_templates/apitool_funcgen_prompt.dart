import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';

const String kPromptAPIToolFuncGen = '''
You are an API tool function generator. Generate valid JSON function calls based on the user request.
''';

class APIToolFunctionGenerator extends AIAgent {
  @override
  String get agentName => 'APITOOL_FUNCGEN';

  @override
  String getSystemPrompt() {
    return kPromptAPIToolFuncGen;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    // 🛡️ Defense: Function calls MUST be valid JSON to be executed.
    // We strip backticks first to check the actual payload.
    try {
      final clean =
          aiResponse.replaceAll(RegExp(r'```[a-zA-Z]*\n?|```'), '').trim();
      final decoded = jsonDecode(clean);

      // Ensure it's a Map (JSON object) and not just a string or list
      return decoded is Map && decoded.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> outputFormatter(String validatedResponse) async {
    // 🛡️ Defense: Extract the raw JSON string.
    final cleanFunc =
        validatedResponse.replaceAll(RegExp(r'```[a-zA-Z]*\n?|```'), '').trim();

    return {
      'FUNC': cleanFunc,
    };
  }
}
