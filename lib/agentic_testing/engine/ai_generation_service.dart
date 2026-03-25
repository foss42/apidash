import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash_core/apidash_core.dart';
import '../models/models.dart';
import 'ai_test_generation_agent.dart';

class AIGenerationService {
  const AIGenerationService();

  Future<List<TestCase>> generate({
    required RequestModel requestModel,
    required List<TestCase> existingCases,
    required String userInstructions,
    required WidgetRef ref,
    Map<String, dynamic>? workflowContext,
    Map<String, dynamic>? workflowMemory,
    Map<String, dynamic>? latestWorkflowRun,
  }) async {
    final http = requestModel.httpRequestModel ?? const HttpRequestModel();

    // Build sanitized headers summary (no actual values for auth headers)
    final headersRaw = http.headers ?? [];
    final enabled = http.isHeaderEnabledList ?? [];
    final headersSummary = headersRaw.asMap().entries
        .where((e) => e.key < enabled.length ? enabled[e.key] : true)
        .where((e) => e.value.name.trim().isNotEmpty)
        .map((e) {
          final key = e.value.name.trim();
          final isAuth =
              key.toLowerCase() == 'authorization' || key.toLowerCase() == 'cookie';
          return '$key: ${isAuth ? '<present>' : e.value.value.trim()}';
        })
        .join(', ');

    // Body schema — truncate to 500 chars max
    final body = (http.body ?? '').trim();
    final bodySchema = body.isEmpty
        ? 'none'
        : (body.length > 500 ? '${body.substring(0, 500)}...' : body);

    // Auth type
    final authType = http.authModel?.type;
    final authSummary = authType != null && authType != APIAuthType.none
        ? '${authType.name} auth configured'
        : 'no auth';

    // Existing test names for deduplication
    final existingNames = existingCases.map((c) => c.name).join(', ');

    final agent = AITestGenerationAgent();

    final workflowContextJson = workflowContext == null
      ? 'none'
      : jsonEncode(workflowContext);
    final workflowMemoryJson = workflowMemory == null
      ? 'none'
      : jsonEncode(workflowMemory);
    final latestWorkflowRunJson = latestWorkflowRun == null
      ? 'none'
      : jsonEncode(latestWorkflowRun);

    final result = await APIDashAgentCaller.instance.call(
      agent,
      ref: ref,
      input: AgentInputs(
        variables: {
          'method': http.method.name.toUpperCase(),
          'url': http.url,
          'headers_summary': headersSummary.isEmpty
              ? '$authSummary, no explicit headers'
              : '$headersSummary ($authSummary)',
          'body_schema': bodySchema,
          'existing_tests': existingNames.isEmpty ? 'none' : existingNames,
          'user_instructions':
              userInstructions.trim().isEmpty ? 'none' : userInstructions.trim(),
          'workflow_context': workflowContextJson,
          'workflow_memory': workflowMemoryJson,
          'latest_workflow_run': latestWorkflowRunJson,
        },
      ),
    );

    if (result == null) {
      throw Exception('AI returned no response. Check your LLM configuration in Settings.');
    }

    final rawList = result as List<dynamic>;
    final url = http.url;
    final method = http.method.name.toUpperCase();

    return rawList.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final name = map['name'] as String? ?? 'AI Test';
      final idSuffix = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
      final urlHash = url.hashCode.abs();

      return TestCase(
        id: 'ai_${method}_${urlHash}_$idSuffix',
        name: name,
        description: map['description'] as String? ?? '',
        source: TestSource.ai,
        expectation: TestExpectation(
          expectedStatus: (map['expectedStatus'] as num?)?.toInt() ?? 400,
        ),
        requestPatch: Map<String, dynamic>.from(
          map['requestPatch'] as Map? ?? {},
        ),
      );
    }).toList();
  }
}
