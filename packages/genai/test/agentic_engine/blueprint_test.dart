import 'package:flutter_test/flutter_test.dart';
import 'package:genai/agentic_engine/blueprint.dart';

class MockAgent extends AIAgent {
  @override
  String get agentName => 'MockAgent';

  @override
  String getSystemPrompt() =>
      'You are a :role: agent. Your task is :task:.';

  @override
  Future<bool> validator(String aiResponse) async =>
      aiResponse.isNotEmpty;

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async =>
      validatedResponse.trim();
}

void main() {
  group('AIAgent', () {
    late MockAgent agent;

    setUp(() {
      agent = MockAgent();
    });

    test('agentName returns correct name', () {
      expect(agent.agentName, 'MockAgent');
    });

    test('getSystemPrompt returns prompt with placeholders', () {
      final prompt = agent.getSystemPrompt();
      expect(prompt, contains(':role:'));
      expect(prompt, contains(':task:'));
    });

    test('validator returns true for non-empty response', () async {
      expect(await agent.validator('some response'), true);
    });

    test('validator returns false for empty response', () async {
      expect(await agent.validator(''), false);
    });

    test('outputFormatter trims whitespace', () async {
      final result = await agent.outputFormatter('  hello world  ');
      expect(result, 'hello world');
    });

    test('outputFormatter handles already trimmed input', () async {
      final result = await agent.outputFormatter('clean');
      expect(result, 'clean');
    });
  });

  group('SystemPromptTemplating', () {
    test('substitutePromptVariable replaces single variable', () {
      const template = 'Hello :name:, welcome!';
      final result = template.substitutePromptVariable('name', 'Alice');
      expect(result, 'Hello Alice, welcome!');
    });

    test('substitutePromptVariable replaces multiple occurrences', () {
      const template = ':greeting: world! :greeting: again!';
      final result = template.substitutePromptVariable('greeting', 'Hello');
      expect(result, 'Hello world! Hello again!');
    });

    test('substitutePromptVariable leaves other variables intact', () {
      const template = ':var1: and :var2:';
      final result = template.substitutePromptVariable('var1', 'replaced');
      expect(result, 'replaced and :var2:');
    });

    test('substitutePromptVariable handles empty value', () {
      const template = 'prefix :var: suffix';
      final result = template.substitutePromptVariable('var', '');
      expect(result, 'prefix  suffix');
    });

    test('substitutePromptVariable returns unchanged if variable not found', () {
      const template = 'no variables here';
      final result = template.substitutePromptVariable('missing', 'value');
      expect(result, 'no variables here');
    });

    test('chained substitutions replace all variables', () {
      const template = 'I am :name:, a :role: agent.';
      final result = template
          .substitutePromptVariable('name', 'TestBot')
          .substitutePromptVariable('role', 'testing');
      expect(result, 'I am TestBot, a testing agent.');
    });
  });

  group('AgentInputs', () {
    test('creates with query only', () {
      final inputs = AgentInputs(query: 'test query');
      expect(inputs.query, 'test query');
      expect(inputs.variables, isNull);
    });

    test('creates with variables only', () {
      final inputs = AgentInputs(variables: {'key': 'value'});
      expect(inputs.query, isNull);
      expect(inputs.variables, {'key': 'value'});
    });

    test('creates with both query and variables', () {
      final inputs = AgentInputs(
        query: 'test',
        variables: {'a': '1', 'b': '2'},
      );
      expect(inputs.query, 'test');
      expect(inputs.variables, hasLength(2));
    });

    test('creates with no arguments', () {
      final inputs = AgentInputs();
      expect(inputs.query, isNull);
      expect(inputs.variables, isNull);
    });
  });
}
