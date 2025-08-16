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
    LLMSaveObject? llmso =
        ref.read(settingsProvider.select((e) => e.defaultLLMSaveObject));
    if (llmso == null) {
      throw Exception('NO DEFAULT LLM');
    }
    LLMModel? model = llmso.selectedLLM;
    final ans = await GenAIAgenticService.callAgent(
      agent,
      LLMAccessDetail(model: model, credential: llmso.credential),
      query: input.query,
      variables: input.variables,
    );
    return ans;
  }
}
