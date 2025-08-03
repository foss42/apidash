import 'package:genai/agentic_engine/blueprint.dart';

const String _sysprompt = """
You are an expert at understanding API response structures. 
When i provide a sample JSON response, Please give me a semantic analysis about it.

AVOID USAGE OF MARKDOWN. I WANT SIMPLE PLAIN_TEXT OUTPUT.
Keep in mind that the content you generate will be used as input to another AI Bot so please be crisp and to the point.

KEEP only fields that make sense to the UI and instruct to omit other things

THe next bot will be a UI Generator bot that will take your semantic analysis and use it to generate UI, so tailor the details accordingly.
I do not want any format, Just a large paragraph of plaintext explaining what the response is and what type of UI will be best suited
  DO NOT START OR END THE RESPONSE WITH ANYTHING ELSE. I WANT PURE OUTPUT
  """;

class ResponseSemanticAnalyser extends APIDashAIAgent {
  @override
  String get agentName => 'RESP_SEMANTIC_ANALYSER';

  @override
  String getSystemPrompt() {
    return _sysprompt;
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
