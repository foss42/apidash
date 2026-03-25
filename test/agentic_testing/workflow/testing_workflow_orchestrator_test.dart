import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/agentic_testing/execution/execution_response.dart';
import 'package:apidash/agentic_testing/execution/request_executor.dart';
import 'package:apidash/agentic_testing/memory/memory_repository_interface.dart';
import 'package:apidash/agentic_testing/memory/test_memory.dart';
import 'package:apidash/agentic_testing/models/models.dart';
import 'package:apidash/agentic_testing/workflow/testing_workflow_orchestrator.dart';

// --- Mocks ---

class MockExecutor implements RequestExecutor {
  final ExecutionResponse mockResponse;
  MockExecutor(this.mockResponse);

  @override
  Future<ExecutionResponse> execute(HttpRequestModel request) async {
    return mockResponse;
  }
}

class MockMemoryDB implements MemoryRepository {
  TestMemory? storedMemory;
  
  @override
  Future<void> init() async {}
  
  @override
  Future<TestMemory?> getMemoryForEndpoint(String url) async => storedMemory;
  
  @override
  Future<void> saveMemory(TestMemory memory) async {
    storedMemory = memory;
  }
}

void main() {
  group('TestingWorkflowOrchestrator', () {
    test('runs provided testcases and saves memory', () async {
      final mockExecutor = MockExecutor(const ExecutionResponse(
        statusCode: 401,
        time: Duration(milliseconds: 100),
      ));
      
      final mockMemory = MockMemoryDB();

      final orchestrator = TestingWorkflowOrchestrator(
        executor: mockExecutor,
        memoryRepository: mockMemory,
      );

      const baseHttpRequest = HttpRequestModel(
        url: 'https://api.secure.com/data',
        method: HTTPVerb.get,
        headers: [NameValueModel(name: 'Authorization', value: 'Bearer token123')],
      );

      const baseRequest = RequestModel(
        id: '123',
        httpRequestModel: baseHttpRequest,
      );

      const cases = [
        TestCase(
          id: 'missing_auth',
          name: 'Missing Auth',
          description: 'Request without auth should fail',
          source: TestSource.rule,
          requestPatch: {'removeHeaders': ['Authorization']},
          expectation: TestExpectation(expectedStatus: 401),
        ),
      ];

      final testSuite = await orchestrator.runCases(cases, baseRequest);

      expect(testSuite.testCases.length, 1);
      expect(mockMemory.storedMemory, isNotNull);
      expect(mockMemory.storedMemory!.endpointUrl, 'https://api.secure.com/data');
      expect(mockMemory.storedMemory!.entries.length, 1);
    });
  });
}