abstract class APIDashAIAgent {
  String get agentName;
  String getSystemPrompt();
  Future<bool> validator(String aiResponse);
  Future<dynamic> outputFormatter(String validatedResponse);
}

extension SystemPromptTemplating on String {
  String substitutePromptVariable(String variable, String value) {
    return this.replaceAll(":$variable:", value);
  }
}
