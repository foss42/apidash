import 'package:genai/llm_model.dart';

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

class AgentInputs {
  final String? query;
  final Map? variables;
  AgentInputs({this.query, this.variables});
}

class LLMAccessDetail {
  final LLMModel model;
  final String credential;

  LLMAccessDetail({required this.model, this.credential = ''});
}
