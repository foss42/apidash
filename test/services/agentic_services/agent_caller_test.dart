import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:apidash/providers/providers.dart';

class MockWidgetRef extends Mock implements WidgetRef {}

class FakeProviderListenable<T> extends Fake
    implements ProviderListenable<T> {}

void main() {
  group('APIDashAgentCaller', () {
    late APIDashAgentCaller agentCaller;
    late MockWidgetRef mockRef;

    setUpAll(() {
      registerFallbackValue(FakeProviderListenable<Object?>());
    });

    setUp(() {
      agentCaller = APIDashAgentCaller.instance;
      mockRef = MockWidgetRef();
    });

    test('throws exception when no default AI model is set', () async {
      // Arrange: Mock ref to return null for defaultAIModel
      when(() => mockRef.read(any())).thenReturn(null);

      // Create a simple agent for testing
      final testAgent = _TestAgent();
      final input = AgentInputs(query: '', variables: {});

      // Act & Assert: Verify exception is thrown
      expect(
        () => agentCaller.call(
          testAgent,
          ref: mockRef,
          input: input,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('NO_DEFAULT_LLM'),
          ),
        ),
      );
    });

    test('instance returns singleton', () {
      // Verify that instance always returns the same object
      final instance1 = APIDashAgentCaller.instance;
      final instance2 = APIDashAgentCaller.instance;
      expect(instance1, same(instance2));
    });
  });
}

// Simple test agent implementation
class _TestAgent extends AIAgent {
  @override
  String get agentName => 'TEST_AGENT';

  @override
  String getSystemPrompt() => 'Test prompt';

  @override
  Future<bool> validator(String aiResponse) async => true;

  @override
  Future outputFormatter(String validatedResponse) async => {};
}
