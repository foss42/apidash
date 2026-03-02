import 'package:apidash/services/agentic_services/agents/intermediate_rep_gen.dart';
import 'package:test/test.dart';

void main() {
  group('IntermediateRepresentationGen', () {
    late IntermediateRepresentationGen agent;

    setUp(() {
      agent = IntermediateRepresentationGen();
    });

    test('agent name is correct', () {
      expect(agent.agentName, 'INTERMEDIATE_REP_GEN');
    });

    group('validator', () {
      test('returns true for any string input', () async {
        const input = 'intermediate representation data';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for empty string', () async {
        const input = '';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for yaml content', () async {
        const input = '''
        key: value
        nested:
          item: data
        ''';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for structured data', () async {
        const input = 'representation: {type: object, data: [1,2,3]}';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });
    });

    group('outputFormatter', () {
      test('removes yaml code blocks', () async {
        const input = '```yaml\nkey: value\n```';
        final result = await agent.outputFormatter(input);
        expect(result['INTERMEDIATE_REPRESENTATION'].trim(), 'key: value');
      });

      test('removes yaml code blocks with newline in marker', () async {
        const input = '```yaml\ndata:\n  nested: true\n```';
        final result = await agent.outputFormatter(input);
        expect(result['INTERMEDIATE_REPRESENTATION'].trim(), 'data:\n  nested: true');
        expect(result['INTERMEDIATE_REPRESENTATION'], isNot(contains('yaml')));
      });

      test('handles input without code blocks', () async {
        const input = 'plain intermediate representation';
        final result = await agent.outputFormatter(input);
        expect(
            result['INTERMEDIATE_REPRESENTATION'], 'plain intermediate representation');
      });

      test('returns map with INTERMEDIATE_REPRESENTATION key', () async {
        const input = 'some representation';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result.containsKey('INTERMEDIATE_REPRESENTATION'), isTrue);
      });

      test('removes all code block markers', () async {
        const input = '```yaml\ncontent\n```\nmore```';
        final result = await agent.outputFormatter(input);
        expect(result['INTERMEDIATE_REPRESENTATION'], isNot(contains('```')));
      });

      test('preserves indentation and formatting', () async {
        const input = '''structure:
  level1:
    level2: value''';
        final result = await agent.outputFormatter(input);
        expect(result['INTERMEDIATE_REPRESENTATION'], contains('  '));
        expect(result['INTERMEDIATE_REPRESENTATION'], contains('\n'));
      });
    });
  });
}
