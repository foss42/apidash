import 'package:apidash/services/agentic_services/agents/stacgen.dart';
import 'package:test/test.dart';

void main() {
  group('StacGenBot', () {
    late StacGenBot agent;

    setUp(() {
      agent = StacGenBot();
    });

    test('agent name is correct', () {
      expect(agent.agentName, 'STAC_GEN');
    });

    group('validator', () {
      test('returns true for valid JSON', () async {
        const validJson = '{"key": "value", "number": 123}';
        final result = await agent.validator(validJson);
        expect(result, isTrue);
      });

      test('returns true for valid JSON with code blocks', () async {
        const jsonWithBlocks = '```json\n{"key": "value"}\n```';
        final result = await agent.validator(jsonWithBlocks);
        expect(result, isTrue);
      });

      test('returns false for invalid JSON', () async {
        const invalidJson = '{key: value, invalid}';
        final result = await agent.validator(invalidJson);
        expect(result, isFalse);
      });

      test('returns false for malformed JSON', () async {
        const malformedJson = '{"key": "value"';
        final result = await agent.validator(malformedJson);
        expect(result, isFalse);
      });

      test('returns false for empty string', () async {
        const emptyString = '';
        final result = await agent.validator(emptyString);
        expect(result, isFalse);
      });

      test('returns false for non-JSON string', () async {
        const nonJson = 'This is just plain text';
        final result = await agent.validator(nonJson);
        expect(result, isFalse);
      });
    });

    group('outputFormatter', () {
      test('removes json code blocks', () async {
        const input = '```json\n{"key": "value"}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'].trim(), '{"key": "value"}');
      });

      test('replaces bold with w700', () async {
        const input = '{"fontWeight": "bold"}';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'], contains('w700'));
        expect(result['STAC'], isNot(contains('bold')));
      });

      test('handles multiple replacements', () async {
        const input = '```json\n{"font": "bold", "weight": "bold"}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'].trim(), '{"font": "w700", "weight": "w700"}');
      });

      test('returns map with STAC key', () async {
        const input = '{"test": "data"}';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result.containsKey('STAC'), isTrue);
      });

      test('handles empty JSON object', () async {
        const input = '{}';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'], '{}');
      });
    });
  });
}
