import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class APIDashAgentCaller {
  static APIDashAgentCaller instance = APIDashAgentCaller();

  Future<AgentResult<dynamic>> call(
    AIAgent agent, {
    required WidgetRef ref,
    required AgentInputs input,
  }) async {
    final defaultAIModel =
        ref.read(settingsProvider.select((e) => e.defaultAIModel));
    if (defaultAIModel == null) {
      return AgentFailure(AgentException(
        type: AgentErrorType.invalidRequest,
        message: 'Please select a default AI model in Settings.',
        agentName: agent.agentName,
      ));
    }
    final baseAIRequestObject = AIRequestModel.fromJson(defaultAIModel);
    return await AIAgentService.callAgent(
      agent,
      baseAIRequestObject,
      query: input.query,
      variables: input.variables,
    );
  }
}
