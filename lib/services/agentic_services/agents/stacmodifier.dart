import 'package:genai/agentic_engine/blueprint.dart';

const String _sysprompt = """
You are an expert agent whose sole JOB is to accept FLutter-SDUI (json-like) representation 
and modify it to match the requests of the client.

PREVIOUS_CODE: ```:VAR_CODE:```

CLIENT_REQUEST: ```:VAR_CLIENT_REQUEST:```

use the CLIENT_REQUEST to modify the PREVIOUS_CODE while following the existing FLutter-SDUI (json-like) representation


DO NOT CHANGE ANYTHING UNLESS SPECIFICALLY ASKED TO
ONLY FLutter-SDUI Representation NOTHING ELSE. DO NOT START OR END WITH TEXT, ONLY FLutter-SDUI Representatiin.
""";

class StacModifierBot extends APIDashAIAgent {
  @override
  String get agentName => 'STAC_MODIFIER';

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
