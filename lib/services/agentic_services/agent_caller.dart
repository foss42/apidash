import 'package:apidash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genai/agentic_engine/agent_service.dart';
import 'package:genai/agentic_engine/blueprint.dart';
import 'package:genai/genai.dart';

class APIDashAgentCaller {
  static APIDashAgentCaller instance = APIDashAgentCaller();

  Future<dynamic> call(
    APIDashAIAgent agent, {
    required WidgetRef ref,
    required AgentInputs input,
  }) async {
    final defaultAIModel =
        ref.read(settingsProvider.select((e) => e.defaultAIModel));
    if (defaultAIModel == null) {
      throw Exception('NO_DEFAULT_LLM');
    }
    final baseAIRequestObject = AIRequestModel.fromJson(defaultAIModel);
    final ans = await GenAIAgenticService.callAgent(
      agent,
      baseAIRequestObject,
      query: input.query,
      variables: input.variables,
    );
    return ans;
  }
}
