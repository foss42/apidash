import 'package:genai/agentic_engine/blueprint.dart';
import 'package:genai/genai.dart';
import 'package:genai/llm_model.dart';
import 'package:genai/llm_provider.dart';
import 'package:genai/providers/providers.dart';

class GenAIAgenticService {
  static Future<String?> _call_provider({
    required LLMModel model,
    required String credential,
    required String systemPrompt,
    required String input,
  }) async {
    final provider = model.provider;
    ModelController mC = provider.modelController;
    final iP = mC.inputPayload;
    iP.credential = credential;
    iP.systemPrompt = systemPrompt;
    iP.userPrompt = input;
    final aiReq = mC.createRequest(model, iP);
    return await GenerativeAI.executeGenAIRequest(model, aiReq);
  }

  static Future<String?> _orchestrator(
    APIDashAIAgent agent,
    LLMAccessDetail accessDetail, {
    String? query,
    Map? variables,
  }) async {
    String sP = agent.getSystemPrompt();

    //Perform Templating
    if (variables != null) {
      for (final v in variables.keys) {
        sP = sP.substitutePromptVariable(v, variables[v]);
      }
    }

    return await _call_provider(
      systemPrompt: sP,
      input: query ?? '',
      model: accessDetail.model,
      credential: accessDetail.credential,
    );
  }

  static Future<dynamic> _governor(
    APIDashAIAgent agent,
    LLMAccessDetail accessDetail, {
    String? query,
    Map? variables,
  }) async {
    int RETRY_COUNT = 0;
    List<int> backoffDelays = [200, 400, 800, 1600, 3200];
    do {
      try {
        final res = await _orchestrator(
          agent,
          accessDetail,
          query: query,
          variables: variables,
        );
        if (res != null) {
          if (await agent.validator(res)) {
            return agent.outputFormatter(res);
          }
        }
      } catch (e) {
        "APIDashAIService::Governor: Exception Occured: $e";
      }
      // Exponential Backoff
      if (RETRY_COUNT < backoffDelays.length) {
        await Future.delayed(
          Duration(milliseconds: backoffDelays[RETRY_COUNT]),
        );
      }
      RETRY_COUNT += 1;
      print(
        "Retrying AgentCall for (${agent.agentName}): ATTEMPT: $RETRY_COUNT",
      );
    } while (RETRY_COUNT < 5);
    return null;
  }

  static Future<dynamic> callAgent(
    APIDashAIAgent agent,
    LLMAccessDetail accessDetail, {
    String? query,
    Map? variables,
  }) async {
    return await _governor(
      agent,
      accessDetail,
      query: query,
      variables: variables,
    );
  }
}
