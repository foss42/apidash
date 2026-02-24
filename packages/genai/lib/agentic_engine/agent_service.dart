import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'blueprint.dart';

class AIAgentService {
  static Future<String?> _call_provider({
    required AIRequestModel baseAIRequestObject,
    required String systemPrompt,
    required String input,
  }) async {
    final aiRequest = baseAIRequestObject.copyWith(
      systemPrompt: systemPrompt,
      userPrompt: input,
    );
    return await executeGenAIRequest(aiRequest);
  }

  static Future<String?> _orchestrator(
    AIAgent agent,
    AIRequestModel baseAIRequestObject, {
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
      baseAIRequestObject: baseAIRequestObject,
    );
  }

  static Future<dynamic> _governor(
    AIAgent agent,
    AIRequestModel baseAIRequestObject, {
    String? query,
    Map? variables,
  }) async {
    int retryCount = 0;
    List<int> backoffDelays = [200, 400, 800, 1600, 3200];
    do {
      try {
        final res = await _orchestrator(
          agent,
          baseAIRequestObject,
          query: query,
          variables: variables,
        );
        if (res != null) {
          if (await agent.validator(res)) {
            return agent.outputFormatter(res);
          }
        }
      } catch (e) {
        "AIAgentService::Governor: Exception Occured: $e";
      }
      // Exponential Backoff
      if (retryCount < backoffDelays.length) {
        await Future.delayed(Duration(milliseconds: backoffDelays[retryCount]));
      }
      retryCount += 1;
      debugPrint(
        "Retrying AgentCall for (${agent.agentName}): ATTEMPT: $retryCount",
      );
    } while (retryCount < 5);
    return null;
  }

  static Future<dynamic> callAgent(
    AIAgent agent,
    AIRequestModel baseAIRequestObject, {
    String? query,
    Map? variables,
  }) async {
    return await _governor(
      agent,
      baseAIRequestObject,
      query: query,
      variables: variables,
    );
  }
}
