import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'agent_result.dart';
import 'blueprint.dart';

class AIAgentService {
  static Future<String?> _callProvider({
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

    return await _callProvider(
      systemPrompt: sP,
      input: query ?? '',
      baseAIRequestObject: baseAIRequestObject,
    );
  }

  static Future<AgentResult<dynamic>> _governor(
    AIAgent agent,
    AIRequestModel baseAIRequestObject, {
    String? query,
    Map? variables,
  }) async {
    if (baseAIRequestObject.httpRequestModel == null) {
      return AgentFailure(AgentException(
        type: AgentErrorType.invalidRequest,
        message: 'Could not build HTTP request from AI model configuration.',
        agentName: agent.agentName,
      ));
    }

    int retryCount = 0;
    Object? lastError;
    const backoffDelays = [200, 400, 800, 1600, 3200];

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
            final output = await agent.outputFormatter(res);
            return AgentSuccess(output);
          }
        }
      } catch (e) {
        lastError = e;
        debugPrint(
          "AIAgentService::Governor: Exception in ${agent.agentName}: $e",
        );

        final errorType = _classifyError(e);
        // Don't retry auth failures — they won't self-resolve.
        if (errorType == AgentErrorType.authFailure) {
          return AgentFailure(AgentException(
            type: AgentErrorType.authFailure,
            message:
                'Authentication failed. Please check your API key in Settings.',
            agentName: agent.agentName,
            retryAttempts: retryCount,
            cause: e,
          ));
        }
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

    // All retries exhausted
    final errorType =
        lastError != null ? _classifyError(lastError) : AgentErrorType.validationFailed;
    return AgentFailure(AgentException(
      type: errorType,
      message: _messageForErrorType(errorType, agent.agentName),
      agentName: agent.agentName,
      retryAttempts: retryCount,
      cause: lastError,
    ));
  }

  /// Classifies an error into an [AgentErrorType] based on common patterns.
  static AgentErrorType _classifyError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('401') ||
        msg.contains('403') ||
        msg.contains('unauthorized') ||
        msg.contains('forbidden')) {
      return AgentErrorType.authFailure;
    }
    if (msg.contains('429') || msg.contains('rate limit')) {
      return AgentErrorType.rateLimited;
    }
    if (msg.contains('socketexception') ||
        msg.contains('connection') ||
        msg.contains('timeout') ||
        msg.contains('network')) {
      return AgentErrorType.networkError;
    }
    return AgentErrorType.unexpected;
  }

  static String _messageForErrorType(AgentErrorType type, String agentName) {
    return switch (type) {
      AgentErrorType.authFailure =>
        'Authentication failed. Please check your API key in Settings.',
      AgentErrorType.rateLimited =>
        'Rate limit exceeded. Please try again later.',
      AgentErrorType.invalidRequest =>
        'Invalid request configuration for $agentName.',
      AgentErrorType.validationFailed =>
        'Agent $agentName could not produce a valid response after multiple attempts.',
      AgentErrorType.networkError =>
        'Network error. Please check your internet connection.',
      AgentErrorType.unexpected =>
        'An unexpected error occurred in $agentName.',
    };
  }

  static Future<AgentResult<dynamic>> callAgent(
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
