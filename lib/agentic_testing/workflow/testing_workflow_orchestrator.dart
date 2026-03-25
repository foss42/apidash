import 'package:uuid/uuid.dart';

import '../../models/request_model.dart';
import '../engine/rules_evaluator.dart';
import '../execution/request_executor.dart';
import '../execution/request_patch_applier.dart';
import '../memory/memory_entry.dart';
import '../memory/memory_repository_interface.dart';
import '../memory/test_memory.dart';
import '../models/models.dart';
import '../models/test_result.dart';
import '../models/test_status.dart';
import '../models/test_suite.dart';

class TestingWorkflowOrchestrator {
  final RequestExecutor executor;
  final MemoryRepository memoryRepository;
  final _uuid = const Uuid();

  TestingWorkflowOrchestrator({
    required this.executor,
    required this.memoryRepository,
  });

  /// Runs a pre-built list of test cases against [baseRequest].
  /// Only the provided [testCases] are executed (respects user's selection).
  Future<TestSuite> runCases(
    List<TestCase> testCases,
    RequestModel baseRequest,
  ) async {
    await memoryRepository.init();

    final httpReq = baseRequest.httpRequestModel!;
    final baseUrl = httpReq.url.split('?').first;

    TestMemory memory =
        await memoryRepository.getMemoryForEndpoint(baseUrl) ??
            TestMemory(endpointUrl: baseUrl);

    final List<TestResult> results = [];

    for (final test in testCases) {
      if (!test.enabled) continue;

      final patchedRequest =
          RequestPatchApplier.apply(httpReq, test.requestPatch);
      final response = await executor.execute(patchedRequest);
      final bool passed =
          RulesEvaluator.evaluate(response, [test.expectation]);

      results.add(
        TestResult(
          testCaseId: test.id,
          status: passed ? TestStatus.pass : TestStatus.fail,
          executedAt: DateTime.now().toUtc(),
          durationMs: response.time?.inMilliseconds,
          actualStatus: response.statusCode,
          error: response.error,
        ),
      );

      final entry = MemoryEntry(
        id: test.id,
        ruleType: test.name,
        note: passed
            ? 'Endpoint handles ${test.name} constraint perfectly.'
            : 'Endpoint FAILED ${test.name} constraint.',
        createdAt: DateTime.now().toUtc(),
        isVerified: passed,
      );

      memory = memory.addOrUpdateEntry(entry);
    }

    await memoryRepository.saveMemory(memory);

    return TestSuite(
      id: _uuid.v4(),
      endpointHash: baseUrl,
      method: httpReq.method.name,
      url: httpReq.url,
      testCases: testCases,
      results: results,
      createdAt: DateTime.now().toUtc(),
    );
  }
}