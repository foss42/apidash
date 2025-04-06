import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/services/agentic_services/agent_blueprint.dart';
import 'package:apidash/services/agentic_services/agents/apitool_funcgen.dart';
import 'package:apidash/services/agentic_services/agents/intermediate_rep_gen.dart';
import 'package:apidash/services/agentic_services/agents/semantic_analyser.dart';
import 'package:apidash/services/agentic_services/agents/stac2flutter.dart';
import 'package:apidash/services/agentic_services/agents/stacgen.dart';
import 'package:apidash/services/agentic_services/agents/stacmodifier.dart';
import 'package:apidash/services/agentic_services/apidash_ai_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgentInputs {
  final String? query;
  final Map? variables;
  AgentInputs({
    this.query,
    this.variables,
  });
}

class APIDashAgentCaller {
  static APIDashAgentCaller instance = APIDashAgentCaller();

  Future<dynamic> _callAgent(
    APIDashAIAgent agent, {
    required WidgetRef ref,
    required AgentInputs input,
  }) async {
    final llmProvider = ref.read(llmProviderStateProvider);
    final llmCredProvider = ref.read(llmProviderCredentialsProvider);
    final accessDetail = (llmProvider, llmCredProvider);
    final ans = await APIDashAIService.callAgent(
      agent,
      accessDetail,
      query: input.query,
      variables: input.variables,
    );
    return ans;
  }

  Future<dynamic> semanticAnalyser(
    WidgetRef ref, {
    required AgentInputs input,
  }) async {
    return _callAgent(ResponseSemanticAnalyser(), ref: ref, input: input);
  }

  Future<dynamic> irGenerator(
    WidgetRef ref, {
    required AgentInputs input,
  }) async {
    return _callAgent(IntermediateRepresentationGen(), ref: ref, input: input);
  }

  Future<dynamic> stacGenerator(
    WidgetRef ref, {
    required AgentInputs input,
  }) async {
    return _callAgent(StacGenBot(), ref: ref, input: input);
  }

  Future<dynamic> stacModifer(
    WidgetRef ref, {
    required AgentInputs input,
  }) async {
    return _callAgent(SlacModifierBot(), ref: ref, input: input);
  }

  Future<dynamic> stac2Flutter(
    WidgetRef ref, {
    required AgentInputs input,
  }) async {
    return _callAgent(StacToFlutterBot(), ref: ref, input: input);
  }

  Future<dynamic> apiToolFunctionGenerator(
    WidgetRef ref, {
    required AgentInputs input,
  }) async {
    return _callAgent(APIToolFunctionGenerator(), ref: ref, input: input);
  }
}
