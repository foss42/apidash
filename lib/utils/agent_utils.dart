import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/services/agentic_services/agents/agents.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String?> generateSDUICodeFromResponse({
  required WidgetRef ref,
  required String apiResponse,
}) async {
  final step1Res = await Future.wait([
    APIDashAgentCaller.instance.call(
      ResponseSemanticAnalyser(),
      ref: ref,
      input: AgentInputs(query: apiResponse),
    ),
    APIDashAgentCaller.instance.call(
      IntermediateRepresentationGen(),
      ref: ref,
      input: AgentInputs(variables: {
        'VAR_API_RESPONSE': apiResponse,
      }),
    ),
  ]);
  final SA = step1Res[0]?['SEMANTIC_ANALYSIS'];
  final IR = step1Res[1]?['INTERMEDIATE_REPRESENTATION'];

  if (SA == null || IR == null) {
    return null;
  }

  print("Semantic Analysis: $SA");
  print("Intermediate Representation: $IR");

  final sduiCode = await APIDashAgentCaller.instance.call(
    StacGenBot(),
    ref: ref,
    input: AgentInputs(variables: {
      'VAR_RAW_API_RESPONSE': apiResponse,
      'VAR_INTERMEDIATE_REPR': IR,
      'VAR_SEMANTIC_ANALYSIS': SA,
    }),
  );
  final stacCode = sduiCode?['STAC']?.toString();
  if (stacCode == null) {
    return null;
  }

  return sduiCode['STAC'].toString();
}

Future<String?> modifySDUICodeUsingPrompt({
  required WidgetRef ref,
  required String generatedSDUI,
  required String modificationRequest,
}) async {
  final res = await APIDashAgentCaller.instance.call(
    StacModifierBot(),
    ref: ref,
    input: AgentInputs(variables: {
      'VAR_CODE': generatedSDUI,
      'VAR_CLIENT_REQUEST': modificationRequest,
    }),
  );
  final SDUI = res?['STAC'];
  return SDUI;
}
