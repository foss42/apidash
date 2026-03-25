import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash_core/apidash_core.dart';
import 'models/workflow_definition.dart';
import 'models/workflow_step.dart';
import 'ai_workflow_generation_agent.dart';

class AIWorkflowGenerationService {
  const AIWorkflowGenerationService();

  Future<List<Map<String, dynamic>>> generate({
    required WorkflowDefinition workflow,
    required Map<String, RequestModel> collection,
    required String userInstructions,
    required WidgetRef ref,
  }) async {
    // 1. Summarize steps for the AI
    final stepsSummary = workflow.steps.asMap().entries.map((entry) {
      final idx = entry.key;
      final step = entry.value;
      final request = collection[step.requestId];
      final http = request?.httpRequestModel;

      final method = http?.method.name.toUpperCase() ?? 'GET';
      final url = http?.url ?? 'no-url';
      
      return 'Step ${idx + 1} (ID: ${step.stepId}): $method $url - Name: ${step.name}';
    }).join('\n');

    // 2. Summarize current rules
    final currentRulesSummary = workflow.steps.map((step) {
      return 'Step ${step.stepId}: Extract: ${step.extract}, Inject: ${step.inject}';
    }).join('\n');

    final agent = AIWorkflowGenerationAgent();
    final result = await APIDashAgentCaller.instance.call(
      agent,
      ref: ref,
      input: AgentInputs(
        variables: {
          'steps_summary': stepsSummary.isEmpty ? 'none' : stepsSummary,
          'current_rules': currentRulesSummary.isEmpty ? 'none' : currentRulesSummary,
          'user_instructions': userInstructions.trim().isEmpty ? 'none' : userInstructions.trim(),
        },
      ),
    );

    if (result == null) {
      throw Exception('AI returned no response. Check your LLM configuration in Settings.');
    }

    final rawList = result as List<dynamic>;
    return rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }
}
