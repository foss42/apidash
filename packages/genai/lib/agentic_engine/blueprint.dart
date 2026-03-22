abstract class AIAgent {
  String get agentName;
  String getSystemPrompt();
  Future<bool> validator(String aiResponse);
  Future<dynamic> outputFormatter(String validatedResponse);
}

extension SystemPromptTemplating on String {
  String substitutePromptVariable(String variable, String value) {
    return replaceAll(":$variable:", value);
  }
}

class AgentInputs {
  final String? query;
  final Map? variables;
  AgentInputs({this.query, this.variables});
}
