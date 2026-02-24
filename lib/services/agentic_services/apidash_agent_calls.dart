import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/services/agentic_services/agents/agents.dart';
import 'package:apidash/templates/tool_templates.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
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
  final sa = step1Res[0]?['SEMANTIC_ANALYSIS'];
  final ir = step1Res[1]?['INTERMEDIATE_REPRESENTATION'];

  if (sa == null || ir == null) {
    return null;
  }

  debugPrint("Semantic Analysis: $sa");
  debugPrint("Intermediate Representation: $ir");

  final sduiCode = await APIDashAgentCaller.instance.call(
    StacGenBot(),
    ref: ref,
    input: AgentInputs(variables: {
      'VAR_RAW_API_RESPONSE': apiResponse,
      'VAR_INTERMEDIATE_REPR': ir,
      'VAR_SEMANTIC_ANALYSIS': sa,
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
  final sdui = res?['STAC'];
  return sdui;
}

Future<String?> generateAPIToolUsingRequestData({
  required WidgetRef ref,
  required String requestData,
  required String targetLanguage,
  required String selectedAgent,
}) async {
  final toolfuncRes = await APIDashAgentCaller.instance.call(
    APIToolFunctionGenerator(),
    ref: ref,
    input: AgentInputs(variables: {
      'REQDATA': requestData,
      'TARGET_LANGUAGE': targetLanguage,
    }),
  );
  if (toolfuncRes == null) {
    return null;
  }

  String toolCode = toolfuncRes!['FUNC'];

  final toolres = await APIDashAgentCaller.instance.call(
    ApiToolBodyGen(),
    ref: ref,
    input: AgentInputs(variables: {
      'TEMPLATE':
          APIToolGenTemplateSelector.getTemplate(targetLanguage, selectedAgent)
              .substitutePromptVariable('FUNC', toolCode),
    }),
  );
  if (toolres == null) {
    return null;
  }
  String toolDefinition = toolres!['REQUEST_BODY'];
  return toolDefinition;
}
