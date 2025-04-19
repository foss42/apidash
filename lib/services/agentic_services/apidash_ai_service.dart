import 'package:apidash/consts.dart';
import 'package:apidash/services/agentic_services/agent_blueprint.dart';
import 'package:apidash/services/agentic_services/llm_services.dart';

typedef LLMAccessDetail = (LLMProvider provider, String credential);

class APIDashAIService {
  static Future<String?> _call_ollama({
    required String systemPrompt,
    required String input,
  }) async {
    return await APIDashOllamaService.ollama(systemPrompt, input);
  }

  static Future<String?> _call_provider({
    required LLMProvider provider,
    required String apiKey,
    required String systemPrompt,
    required String input,
  }) async {
    switch (provider) {
      case LLMProvider.gemini:
        return await APIDashCustomLLMService.gemini(
            systemPrompt, input, apiKey);
      case LLMProvider.chatgpt:
        return await APIDashCustomLLMService.chatgpt(
            systemPrompt, input, apiKey);
      case LLMProvider.claude:
        return await APIDashCustomLLMService.claude(
            systemPrompt, input, apiKey);
      case LLMProvider.azureOpenAI:
        return await APIDashCustomLLMService.openai_azure(
          systemPrompt,
          input,
          apiKey,
        );
      default:
        print('PROVIDER_UNIMPLEMENTED');
        return null;
    }
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

    //Implement any Rate limiting logic as needed
    if (accessDetail.$1 == LLMProvider.ollama) {
      //Use local ollama implementation
      return await _call_ollama(systemPrompt: sP, input: query ?? '');
    } else {
      //Use LLMProvider implementation
      return await _call_provider(
        provider: accessDetail.$1,
        apiKey: accessDetail.$2,
        systemPrompt: sP,
        input: query ?? '',
      );
    }
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
        if (res == null) {
          RETRY_COUNT += 1;
        } else {
          if (await agent.validator(res)) {
            return agent.outputFormatter(res);
          } else {
            RETRY_COUNT += 1;
          }
        }
      } catch (e) {
        print(e);
      }
      // Exponential Backoff
      if (RETRY_COUNT < backoffDelays.length) {
        await Future.delayed(Duration(
          milliseconds: backoffDelays[RETRY_COUNT],
        ));
      }
      RETRY_COUNT += 1;
    } while (RETRY_COUNT < 5);
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
