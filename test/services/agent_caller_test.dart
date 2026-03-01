import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockWidgetRef extends Mock implements WidgetRef {}
class MockAIAgent extends Mock implements AIAgent {}

// Fake class for ProviderListenable
class FakeProviderListenable extends Fake implements ProviderListenable<Object?> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProviderListenable());
  });

  group('APIDashAgentCaller Tests', () {
    late APIDashAgentCaller agentCaller;
    late MockWidgetRef mockRef;
    late MockAIAgent mockAgent;

    setUp(() {
      agentCaller = APIDashAgentCaller.instance;
      mockRef = MockWidgetRef();
      mockAgent = MockAIAgent();
    });

    test('should throw exception when no default AI model is set', () async {
      // Arrange
      when(() => mockRef.read(any())).thenReturn(null);
      
      final input = AgentInputs(
        query: 'test query',
        variables: {},
      );

      // Act & Assert
      expect(
        () => agentCaller.call(mockAgent, ref: mockRef, input: input),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('NO_DEFAULT_LLM'),
        )),
      );
    });

    test('should successfully call agent when default AI model exists', () async {
      // This test requires mocking AIAgentService.callAgent
      // which may need additional setup depending on the implementation
      // For now, we're testing the exception case which is critical
    });
  });
}
