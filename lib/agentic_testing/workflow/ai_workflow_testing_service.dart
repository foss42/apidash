import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash_core/apidash_core.dart';
import '../models/test_expectation.dart';
import 'models/workflow_definition.dart';
import 'models/workflow_test_case.dart';
import 'workflow_provider.dart';
import 'ai_workflow_testing_agent.dart';

class AIWorkflowTestingService {
  const AIWorkflowTestingService();

  Future<List<WorkflowTestCase>> generate({
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
      
      var summary = 'Step ${idx + 1} (ID: ${step.stepId}): $method $url - Name: ${step.name}';
      if (step.extract.isNotEmpty) {
        summary += '\n    EXTRACTS: ${step.extract.entries.map((e) => "${e.key} ← ${e.value}").join(", ")}';
      }
      if (step.inject.isNotEmpty) {
        summary += '\n    INJECTS: ${step.inject.entries.map((e) => "${e.key} ← ${e.value}").join(", ")}';
      }
      return summary;
    }).join('\n');

    // 2. Summarize existing scenarios (Memory)
    final existingScenarios = workflow.steps.isEmpty ? 'none' : 
        ref.read(workflowProvider).generatedCases.map((c) => '- ${c.name}: ${c.description}').join('\n');

    final agent = AIWorkflowTestingAgent();
    final result = await APIDashAgentCaller.instance.call(
      agent,
      ref: ref,
      input: AgentInputs(
        variables: {
          'steps_summary': stepsSummary.isEmpty ? 'none' : stepsSummary,
          'user_instructions': userInstructions.trim().isEmpty ? 'none' : userInstructions.trim(),
          'existing_scenarios': existingScenarios.isEmpty ? 'none' : existingScenarios,
        },
      ),
    );

    if (result == null) {
      throw Exception('AI returned no response.');
    }

    final rawList = result as List<dynamic>;
    return rawList.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      
      final expectations = <String, TestExpectation>{};
      if (map['stepExpectations'] != null) {
        final expMap = map['stepExpectations'] as Map;
        for (final entry in expMap.entries) {
          expectations[entry.key as String] = TestExpectation(
            expectedStatus: entry.value['expectedStatus'] as int?,
          );
        }
      }

      final name = map['name'] ?? 'Unnamed Scenario';
      final description = map['description'] ?? '';
      final contentHash = (name.hashCode ^ description.hashCode).toString();

      return WorkflowTestCase(
        id: 'tc_$contentHash',
        name: name,
        description: description,
        initialVariables: Map<String, String>.from(map['initialVariables'] ?? {}),
        stepExpectations: expectations,
      );
    }).toList();
  }
}
