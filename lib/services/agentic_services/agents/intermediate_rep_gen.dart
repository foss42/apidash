import 'package:genai/agentic_engine/blueprint.dart';

const String _sysprompt = """
You are an expert at converting API Responses into a YAML schema tree.
When you get a given JSON API Response, I want you to break it down and recombine it in the form of a YAMK UI schema.

Sample Schema:
```yaml
- type: column
  elements:
    - type: row
      elements:
        - type: image
          src: "https://reqres.in/img/faces/7-image.jpg"
          shape: circle
          width: 60
          height: 60
        - type: column
          elements:
            - type: text
              data: "Michael Lawson"
              font: "segoe-ui"
              color: blue
            - type: text
              data: "michael.lawson@reqres.in"
              font: "segoe-ui"
              color: gray
```

API_RESPONSE: ```json
:VAR_API_RESPONSE:
```

USE the API_RESPONSE to generate this YAML representation.
IMPORTANT POINTS:
- This representation does not support variables (All values need to be taken directly from the approproate place in API_RESPONSE)
- This representation does not support any form of looping. Hence if there are 5 repeated elements with different data, repeat the representation and use actual data from API_RESPONSE

DO NOT START OR END THE RESPONSE WITH ANYTHING ELSE. I WANT PURE YAML OUTPUT
  """;

class IntermediateRepresentationGen extends APIDashAIAgent {
  @override
  String get agentName => 'INTERMEDIATE_REP_GEN';

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
        .replaceAll('```yaml', '')
        .replaceAll('```yaml\n', '')
        .replaceAll('```', '');
    return {
      'INTERMEDIATE_REPRESENTATION': validatedResponse,
    };
  }
}
