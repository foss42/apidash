import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'blueprint.dart';

/// Default timeout duration for individual LLM calls.
const Duration kDefaultAgentCallTimeout = Duration(seconds: 30);

/// Default timeout duration for the entire agent execution
/// (including all retries).
const Duration kDefaultAgentTotalTimeout = Duration(seconds: 120);

class AIAgentService {
  static Future<String?> _call_provider({
    required AIRequestModel baseAIRequestObject,
    required String systemPrompt,
    required String input,
    Duration timeout = kDefaultAgentCallTimeout,
  }) async {
    final aiRequest = baseAIRequestObject.copyWith(
      systemPrompt: systemPrompt,
      userPrompt: input,
    );
    return await executeGenAIRequest(aiRequest).timeout(
      timeout,
      onTimeout: () {
        throw TimeoutException(
          'LLM call timed out after ${timeout.inSeconds}s',
          timeout,
        );
      },
    );
  }

  static Future<String?> _orchestrator(
    AIAgent agent,
    AIRequestModel baseAIRequestObject, {
    String? query,
    Map? variables,
    Duration perCallTimeout = kDefaultAgentCallTimeout,
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
      timeout: perCallTimeout,
    );
  }

  static Future<dynamic> _governor(
    AIAgent agent,
    AIRequestModel baseAIRequestObject, {
    String? query,
    Map? variables,
    Duration perCallTimeout = kDefaultAgentCallTimeout,
    Duration totalTimeout = kDefaultAgentTotalTimeout,
  }) async {
    final deadline = DateTime.now().add(totalTimeout);
    int retryCount = 0;
    List<int> backoffDelays = [200, 400, 800, 1600, 3200];
    do {
      // Check if total timeout has been exceeded
      if (DateTime.now().isAfter(deadline)) {
        debugPrint(
          "AIAgentService::Governor: Total timeout of "
          "${totalTimeout.inSeconds}s exceeded for ${agent.agentName}",
        );
        return null;
      }
      try {
        final res = await _orchestrator(
          agent,
          baseAIRequestObject,
          query: query,
          variables: variables,
          perCallTimeout: perCallTimeout,
        );
        if (res != null) {
          if (await agent.validator(res)) {
            return agent.outputFormatter(res);
          }
        }
      } on TimeoutException catch (e) {
        debugPrint(
          "AIAgentService::Governor: Timeout for "
          "${agent.agentName}: $e",
        );
      } catch (e) {
        debugPrint(
          "AIAgentService::Governor: Exception Occurred: $e",
        );
      }
      // Exponential Backoff
      if (retryCount < backoffDelays.length) {
        await Future.delayed(
          Duration(milliseconds: backoffDelays[retryCount]),
        );
      }
      retryCount += 1;
      debugPrint(
        "Retrying AgentCall for (${agent.agentName}): ATTEMPT: $retryCount",
      );
    } while (retryCount < 5);
    return null;
  }

  /// Executes an agent call with configurable timeout protection.
  ///
  /// [perCallTimeout] limits each individual LLM call (default: 30s).
  /// [totalTimeout] limits the entire execution including retries (default: 120s).
  static Future<dynamic> callAgent(
    AIAgent agent,
    AIRequestModel baseAIRequestObject, {
    String? query,
    Map? variables,
    Duration perCallTimeout = kDefaultAgentCallTimeout,
    Duration totalTimeout = kDefaultAgentTotalTimeout,
  }) async {
    return await _governor(
      agent,
      baseAIRequestObject,
      query: query,
      variables: variables,
      perCallTimeout: perCallTimeout,
      totalTimeout: totalTimeout,
    );
  }
}
