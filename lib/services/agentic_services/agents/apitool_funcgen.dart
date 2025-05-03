import 'package:apidash/services/agentic_services/agent_blueprint.dart';

const String kAPIToolFuncGenSystemPrompt = """
You are an expert LANGUAGE SPECIFIC API CALL METHOD Creator.
You will be provided a complete API Details Text named (REQDATA) which consists of the method, endpoint, params, headers, body
and so on.
You are also provided with a Target Language named (TARGET_LANGUAGE).

Using this data, Create a method EXPLICITLY named `func`.
The method `func` should accept any variables if present (refer REQDATA for all details) and include it as part of the arguments

Use the Industry standard best practices while calling the API provided by REQDATA.
If REQDATA contains any Authorization (Eg: bearer key), embed that into the function itself and dont expect it to be passed in the function
same goes for any header details.

REQDATA: :REQDATA:

TARGET_LANGUAGE: :TARGET_LANGUAGE:

if REQDATA.BODY_TYPE is TEXT => use it as-is
if REQDATA.BODY_TYPE is JSON or FORM-DATA => use the types provided to create variables passed from the function arguments

ALWAYS return the output as code only and do not start or begin with any introduction or conclusion. ONLY THE CODE.
""";

class APIToolFunctionGenerator extends APIDashAIAgent {
  @override
  String get agentName => 'APITOOL_FUNCGEN';

  @override
  String getSystemPrompt() {
    return kAPIToolFuncGenSystemPrompt;
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
      'FUNC': validatedResponse,
    };
  }
}
