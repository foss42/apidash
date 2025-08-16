import 'dart:convert';

import 'package:apidash/services/agentic_services/agents/stacgen.dart';
import 'package:genai/agentic_engine/blueprint.dart';

const String _sysprompt = """
You are an expert agent whose sole JOB is to accept FLutter-SDUI (json-like) representation 
and modify it to match the requests of the client.

SDUI CODE RULES:
$SAMPLE_STAC_RULESET

# Inputs
PREVIOUS_CODE: ```:VAR_CODE:```
CLIENT_REQUEST: ```:VAR_CLIENT_REQUEST:```


# Hard Output Contract
- Output MUST be ONLY the SDUI JSON. No prose, no code fences, no comments. Must start with { and end with }.
- Use only widgets and properties from the Widget Catalog below.
- Prefer minimal, valid trees. Omit null/empty props.
- Numeric where numeric, booleans where booleans, strings for enums/keys.
- Color strings allowed (e.g., "#RRGGBB").
- Keep key order consistent: type, then layout/meta props, then child/children.


# Final Instruction
DO NOT CHANGE ANYTHING UNLESS SPECIFICALLY ASKED TO
use the CLIENT_REQUEST to modify the PREVIOUS_CODE while following the existing FLutter-SDUI (json-like) representation
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
