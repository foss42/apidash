import 'package:genai/agentic_engine/blueprint.dart';

const String kIntermediateRepGenSystemPrompt = """
You are an expert agent whose sole JOB is to accept FLutter-SDUI (json-like) representation 
and convert it into actual working FLutter component.

This is fairly easy to do as FLutter-SDUI is literally a one-one representation of Flutter Code

SDUI_CODE: ```:VAR_CODE:```

use the Above SDUI_CODE and convert it into Flutter Code that is effectively same as what the SDUI_CODE represents

DO NOT CHANGE CONTENT, just convert everything one-by-one 
Output ONLY Code Representation NOTHING ELSE. DO NOT START OR END WITH TEXT, ONLY Code

DO NOT WRITE CODE TO PARSE SDUI, ACTUALLY CONVERT IT TO REAL DART CODE
""";

class StacToFlutterBot extends APIDashAIAgent {
  @override
  String get agentName => 'STAC_2_FLUTTER';

  @override
  String getSystemPrompt() {
    return kIntermediateRepGenSystemPrompt;
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
