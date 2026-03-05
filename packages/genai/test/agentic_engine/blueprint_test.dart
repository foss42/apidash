import 'package:flutter_test/flutter_test.dart';
import 'package:genai/agentic_engine/blueprint.dart';

// Mock implementation of AIAgent for testing
class MockAIAgent implements AIAgent {
  final String _name;
  final String _systemPrompt;

  MockAIAgent({
    required String name,
    required String systemPrompt,
  })  : _name = name,
        _systemPrompt = systemPrompt;

  @override
  String get agentName => _name;

  @override
  String getSystemPrompt() => _systemPrompt;

  @override
  Future<bool> validator(String aiResponse) async {
    // Simple validation: non-empty response
    return aiResponse.isNotEmpty;
  }

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async {
    // Simple formatting: return uppercase
    return validatedResponse.toUpperCase();
  }
}

void main() {
  group('AIAgent', () {
    test('should return agent name correctly', () {
      final agent = MockAIAgent(
        name: 'TestAgent',
        systemPrompt: 'You are a test agent',
      );

      expect(agent.agentName, equals('TestAgent'));
    });

    test('should return system prompt correctly', () {
      final agent = MockAIAgent(
        name: 'TestAgent',
        systemPrompt: 'You are a helpful assistant',
      );

      expect(agent.getSystemPrompt(), equals('You are a helpful assistant'));
    });

    test('validator method can be invoked and returns bool', () async {
      final agent = MockAIAgent(
        name: 'TestAgent',
        systemPrompt: 'Test',
      );

      final result = await agent.validator('valid response');
      expect(result, isA<bool>());
      expect(result, isTrue);
    });

    test('validator returns false for empty response', () async {
      final agent = MockAIAgent(
        name: 'TestAgent',
        systemPrompt: 'Test',
      );

      final result = await agent.validator('');
      expect(result, isFalse);
    });

    test('outputFormatter method can be invoked', () async {
      final agent = MockAIAgent(
        name: 'TestAgent',
        systemPrompt: 'Test',
      );

      final result = await agent.outputFormatter('hello');
      expect(result, equals('HELLO'));
    });

    test('outputFormatter returns dynamic type', () async {
      final agent = MockAIAgent(
        name: 'TestAgent',
        systemPrompt: 'Test',
      );

      final result = await agent.outputFormatter('test output');
      expect(result, isNotNull);
      expect(result, isA<String>());
    });
  });

  group('SystemPromptTemplating Extension', () {
    test('should substitute single variable placeholder', () {
      const template = 'Hello :name:!';
      final result = template.substitutePromptVariable('name', 'John');

      expect(result, equals('Hello John!'));
    });

    test('should substitute variable in middle of text', () {
      const template = 'The :language: programming language';
      final result = template.substitutePromptVariable('language', 'Dart');

      expect(result, equals('The Dart programming language'));
    });

    test('should substitute multiple occurrences of same variable', () {
      const template = ':name: said hello to :name:';
      final result = template.substitutePromptVariable('name', 'Alice');

      expect(result, equals('Alice said hello to Alice'));
    });

    test('should handle numeric values', () {
      const template = 'The answer is :number:';
      final result = template.substitutePromptVariable('number', '42');

      expect(result, equals('The answer is 42'));
    });

    test('should substitute with empty string', () {
      const template = 'Hello :name:!';
      final result = template.substitutePromptVariable('name', '');

      expect(result, equals('Hello !'));
    });

    test('should not modify text without matching placeholder', () {
      const template = 'Hello :name:!';
      final result = template.substitutePromptVariable('age', '30');

      expect(result, equals('Hello :name:!'));
    });

    test('should handle multiple different placeholders sequentially', () {
      const template = ':a: plus :b: equals :c:';
      var result = template.substitutePromptVariable('a', '1');
      result = result.substitutePromptVariable('b', '2');
      result = result.substitutePromptVariable('c', '3');

      expect(result, equals('1 plus 2 equals 3'));
    });

    test('should preserve text with no placeholders', () {
      const template = 'No placeholders here';
      final result = template.substitutePromptVariable('variable', 'value');

      expect(result, equals('No placeholders here'));
    });

    test('should handle variable names with special characters in values', () {
      const template = 'Message: :msg:';
      final result = template.substitutePromptVariable('msg', 'Hello! @#\$%');

      expect(result, equals('Message: Hello! @#\$%'));
    });

    test('should handle colon in value without affecting placeholders', () {
      const template = 'URL is :url:';
      final result =
          template.substitutePromptVariable('url', 'https://example.com');

      expect(result, equals('URL is https://example.com'));
    });

    test('should not substitute partial matches', () {
      const template = 'Value is :value: and :value2:';
      final result = template.substitutePromptVariable('value', 'X');

      expect(result, equals('Value is X and :value2:'));
    });

    test('should handle newlines in template', () {
      const template = 'Line 1: :var:\nLine 2: :var:';
      final result = template.substitutePromptVariable('var', 'test');

      expect(result, equals('Line 1: test\nLine 2: test'));
    });
  });

  group('AgentInputs', () {
    test('should store query correctly', () {
      final inputs = AgentInputs(query: 'What is AI?');

      expect(inputs.query, equals('What is AI?'));
    });

    test('should store variables map correctly', () {
      final variables = {'name': 'Alice', 'age': '30'};
      final inputs = AgentInputs(variables: variables);

      expect(inputs.variables, equals(variables));
      expect(inputs.variables?['name'], equals('Alice'));
      expect(inputs.variables?['age'], equals('30'));
    });

    test('should handle both query and variables', () {
      final variables = {'context': 'testing'};
      final inputs = AgentInputs(
        query: 'Test query',
        variables: variables,
      );

      expect(inputs.query, equals('Test query'));
      expect(inputs.variables, equals(variables));
    });

    test('should handle null query', () {
      final inputs = AgentInputs(variables: {'key': 'value'});

      expect(inputs.query, isNull);
      expect(inputs.variables, isNotNull);
    });

    test('should handle null variables', () {
      final inputs = AgentInputs(query: 'Query only');

      expect(inputs.query, equals('Query only'));
      expect(inputs.variables, isNull);
    });

    test('should handle empty variables map', () {
      final inputs = AgentInputs(
        query: 'Test',
        variables: {},
      );

      expect(inputs.variables, isEmpty);
      expect(inputs.query, equals('Test'));
    });

    test('should handle null for both query and variables', () {
      final inputs = AgentInputs();

      expect(inputs.query, isNull);
      expect(inputs.variables, isNull);
    });

    test('should handle complex variable values', () {
      final variables = {
        'simple': 'value',
        'number': 42,
        'list': [1, 2, 3],
        'nested': {'key': 'value'},
      };
      final inputs = AgentInputs(variables: variables);

      expect(inputs.variables?['simple'], equals('value'));
      expect(inputs.variables?['number'], equals(42));
      expect(inputs.variables?['list'], equals([1, 2, 3]));
      expect(inputs.variables?['nested'], equals({'key': 'value'}));
    });
  });
}
