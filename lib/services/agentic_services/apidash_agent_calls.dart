import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/services/agentic_services/agents/agents.dart';
import 'package:apidash/templates/tool_templates.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<AgentResult<String>> generateSDUICodeFromResponse({
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

  final saResult = step1Res[0];
  final irResult = step1Res[1];

  // Return the first failure encountered
  if (saResult.isFailure) {
    return AgentFailure((saResult as AgentFailure).exception);
  }
  if (irResult.isFailure) {
    return AgentFailure((irResult as AgentFailure).exception);
  }

  final sa = saResult.valueOrNull?['SEMANTIC_ANALYSIS'];
  final ir = irResult.valueOrNull?['INTERMEDIATE_REPRESENTATION'];

  if (sa == null || ir == null) {
    return AgentFailure(AgentException(
      type: AgentErrorType.validationFailed,
      message: 'Semantic analysis or intermediate representation was empty.',
      agentName: 'SDUICodeGeneration',
    ));
  }

  debugPrint("Semantic Analysis: $sa");
  debugPrint("Intermediate Representation: $ir");

  final sduiResult = await APIDashAgentCaller.instance.call(
    StacGenBot(),
    ref: ref,
    input: AgentInputs(variables: {
      'VAR_RAW_API_RESPONSE': apiResponse,
      'VAR_INTERMEDIATE_REPR': ir,
      'VAR_SEMANTIC_ANALYSIS': sa,
    }),
  );

  if (sduiResult.isFailure) {
    return AgentFailure((sduiResult as AgentFailure).exception);
  }

  final stacCode = sduiResult.valueOrNull?['STAC']?.toString();
  if (stacCode == null) {
    return AgentFailure(AgentException(
      type: AgentErrorType.validationFailed,
      message: 'STAC code generation returned empty output.',
      agentName: 'StacGenBot',
    ));
  }

  return AgentSuccess(stacCode);
}

Future<AgentResult<String>> modifySDUICodeUsingPrompt({
  required WidgetRef ref,
  required String generatedSDUI,
  required String modificationRequest,
}) async {
  final result = await APIDashAgentCaller.instance.call(
    StacModifierBot(),
    ref: ref,
    input: AgentInputs(variables: {
      'VAR_CODE': generatedSDUI,
      'VAR_CLIENT_REQUEST': modificationRequest,
    }),
  );

  if (result.isFailure) {
    return AgentFailure((result as AgentFailure).exception);
  }

  final sdui = result.valueOrNull?['STAC'];
  if (sdui == null) {
    return AgentFailure(AgentException(
      type: AgentErrorType.validationFailed,
      message: 'STAC modification returned empty output.',
      agentName: 'StacModifierBot',
    ));
  }

  return AgentSuccess(sdui);
}

Future<AgentResult<String>> generateAPIToolUsingRequestData({
  required WidgetRef ref,
  required String requestData,
  required String targetLanguage,
  required String selectedAgent,
}) async {
  final toolfuncResult = await APIDashAgentCaller.instance.call(
    APIToolFunctionGenerator(),
    ref: ref,
    input: AgentInputs(variables: {
      'REQDATA': requestData,
      'TARGET_LANGUAGE': targetLanguage,
    }),
  );

  if (toolfuncResult.isFailure) {
    return AgentFailure((toolfuncResult as AgentFailure).exception);
  }

  final toolFunc = toolfuncResult.valueOrNull;
  if (toolFunc == null) {
    return AgentFailure(AgentException(
      type: AgentErrorType.validationFailed,
      message: 'API tool function generation returned empty output.',
      agentName: 'APIToolFunctionGenerator',
    ));
  }

  String toolCode = toolFunc['FUNC'];

  final toolResult = await APIDashAgentCaller.instance.call(
    ApiToolBodyGen(),
    ref: ref,
    input: AgentInputs(variables: {
      'TEMPLATE':
          APIToolGenTemplateSelector.getTemplate(targetLanguage, selectedAgent)
              .substitutePromptVariable('FUNC', toolCode),
    }),
  );

  if (toolResult.isFailure) {
    return AgentFailure((toolResult as AgentFailure).exception);
  }

  final toolBody = toolResult.valueOrNull;
  if (toolBody == null) {
    return AgentFailure(AgentException(
      type: AgentErrorType.validationFailed,
      message: 'API tool body generation returned empty output.',
      agentName: 'ApiToolBodyGen',
    ));
  }

  return AgentSuccess(toolBody['TOOL'] as String);
}
