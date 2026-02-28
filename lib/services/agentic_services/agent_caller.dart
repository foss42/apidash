import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class APIDashAgentCaller {
  static APIDashAgentCaller instance = APIDashAgentCaller();

  Future<dynamic> call(
    AIAgent agent, {
    required WidgetRef ref,
    required AgentInputs input,
  }) async {
    final defaultAIModel =
        ref.read(settingsProvider.select((e) => e.defaultAIModel));
    if (defaultAIModel == null) {
      throw Exception('NO_DEFAULT_LLM');
    }
    final baseAIRequestObject = AIRequestModel.fromJson(defaultAIModel);
    final ans = await AIAgentService.callAgent(
      agent,
      baseAIRequestObject,
      query: input.query,
      variables: input.variables,
    );
    return ans;
  }
}
