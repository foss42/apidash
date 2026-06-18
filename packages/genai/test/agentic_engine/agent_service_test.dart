import 'package:flutter_test/flutter_test.dart';
import 'package:genai/agentic_engine/agent_result.dart';
import 'package:genai/agentic_engine/agent_service.dart';
import 'package:genai/agentic_engine/blueprint.dart';
import 'package:genai/models/models.dart';

/// An agent that always validates and returns a formatted result.
class SuccessAgent extends AIAgent {
  @override
  String get agentName => 'SuccessAgent';

  @override
  String getSystemPrompt() => 'You are a test agent.';

  @override
  Future<bool> validator(String aiResponse) async => true;

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async =>
      {'RESULT': validatedResponse};
}

/// An agent whose validator always rejects the LLM output.
class AlwaysFailsValidationAgent extends AIAgent {
  @override
  String get agentName => 'AlwaysFailsValidation';

  @override
  String getSystemPrompt() => 'You are a test agent.';

  @override
  Future<bool> validator(String aiResponse) async => false;

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async =>
      validatedResponse;
}

/// An agent whose validator throws an exception.
class ThrowingValidatorAgent extends AIAgent {
  final Object errorToThrow;
  ThrowingValidatorAgent(this.errorToThrow);

  @override
  String get agentName => 'ThrowingValidator';

  @override
  String getSystemPrompt() => 'You are a test agent.';

  @override
  Future<bool> validator(String aiResponse) async => throw errorToThrow;

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async =>
      validatedResponse;
}

/// An agent with prompt variables.
class TemplatedAgent extends AIAgent {
  @override
  String get agentName => 'TemplatedAgent';

  @override
  String getSystemPrompt() => 'Process :DATA: now.';

  @override
  Future<bool> validator(String aiResponse) async => aiResponse.isNotEmpty;

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async =>
      {'OUTPUT': validatedResponse};
}

void main() {
  group('AIAgentService.callAgent', () {
    test('returns AgentFailure with invalidRequest when httpRequestModel is null', () async {
      // An AIRequestModel with no modelApiProvider produces null httpRequestModel
      const aiRequest = AIRequestModel();
      final agent = SuccessAgent();

      final result = await AIAgentService.callAgent(agent, aiRequest);

      expect(result, isA<AgentFailure>());
      expect(result.isFailure, isTrue);
      final failure = result as AgentFailure;
      expect(failure.exception.type, AgentErrorType.invalidRequest);
      expect(failure.exception.agentName, 'SuccessAgent');
    });

    test('returns AgentResult type from callAgent', () async {
      const aiRequest = AIRequestModel();
      final agent = SuccessAgent();

      final result = await AIAgentService.callAgent(agent, aiRequest);

      expect(result, isA<AgentResult>());
    });

    test('AgentFailure exception contains agent name', () async {
      const aiRequest = AIRequestModel();
      final agent = AlwaysFailsValidationAgent();

      final result = await AIAgentService.callAgent(agent, aiRequest);

      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull?.agentName, 'AlwaysFailsValidation');
    });

    test('callAgent passes query parameter', () async {
      const aiRequest = AIRequestModel();
      final agent = SuccessAgent();

      final result = await AIAgentService.callAgent(
        agent,
        aiRequest,
        query: 'test query',
      );

      // With null httpRequestModel, it returns invalidRequest failure
      expect(result.isFailure, isTrue);
    });

    test('callAgent passes variables parameter', () async {
      const aiRequest = AIRequestModel();
      final agent = TemplatedAgent();

      final result = await AIAgentService.callAgent(
        agent,
        aiRequest,
        variables: {'DATA': 'test_value'},
      );

      // With null httpRequestModel, it returns invalidRequest failure
      expect(result.isFailure, isTrue);
    });
  });

  group('AgentResult integration', () {
    test('AgentFailure from callAgent can be pattern matched', () async {
      const aiRequest = AIRequestModel();
      final agent = SuccessAgent();

      final result = await AIAgentService.callAgent(agent, aiRequest);

      final message = switch (result) {
        AgentSuccess(:final value) => 'Got: $value',
        AgentFailure(:final exception) => exception.message,
      };

      expect(message, contains('Could not build HTTP request'));
    });

    test('AgentFailure from callAgent works with when()', () async {
      const aiRequest = AIRequestModel();
      final agent = SuccessAgent();

      final result = await AIAgentService.callAgent(agent, aiRequest);

      final handled = result.when(
        success: (value) => 'success',
        failure: (exception) => 'failure: ${exception.type.name}',
      );

      expect(handled, 'failure: invalidRequest');
    });

    test('valueOrNull returns null for failure', () async {
      const aiRequest = AIRequestModel();
      final agent = SuccessAgent();

      final result = await AIAgentService.callAgent(agent, aiRequest);

      expect(result.valueOrNull, isNull);
    });

    test('exceptionOrNull returns exception for failure', () async {
      const aiRequest = AIRequestModel();
      final agent = SuccessAgent();

      final result = await AIAgentService.callAgent(agent, aiRequest);

      expect(result.exceptionOrNull, isNotNull);
      expect(result.exceptionOrNull!.type, AgentErrorType.invalidRequest);
    });
  });
}
