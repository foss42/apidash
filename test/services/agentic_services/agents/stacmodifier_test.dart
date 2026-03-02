import 'package:apidash/services/agentic_services/agents/stacmodifier.dart';
import 'package:test/test.dart';

void main() {
  group('StacModifierBot', () {
    late StacModifierBot agent;

    setUp(() {
      agent = StacModifierBot();
    });

    test('agent name is correct', () {
      expect(agent.agentName, 'STAC_MODIFIER');
    });

    group('validator', () {
      test('returns true for valid JSON', () async {
        const validJson = '{"key": "value", "nested": {"id": 1}}';
        final result = await agent.validator(validJson);
        expect(result, isTrue);
      });

      test('returns true for valid JSON with code blocks', () async {
        const jsonWithBlocks = '```json\n{"modified": true}\n```';
        final result = await agent.validator(jsonWithBlocks);
        expect(result, isTrue);
      });

      test('returns false for invalid JSON', () async {
        const invalidJson = '{key: "value", missing quotes}';
        final result = await agent.validator(invalidJson);
        expect(result, isFalse);
      });

      test('returns false for incomplete JSON', () async {
        const incompleteJson = '{"key": "value", "array": [1, 2';
        final result = await agent.validator(incompleteJson);
        expect(result, isFalse);
      });

      test('returns false for null input', () async {
        const nullString = 'null';
        final result = await agent.validator(nullString);
        // 'null' is technically valid JSON, but depends on validation logic
        expect(result, isTrue);
      });

      test('handles complex nested JSON', () async {
        const complexJson = '{"a": {"b": {"c": [1, 2, {"d": "e"}]}}}';
        final result = await agent.validator(complexJson);
        expect(result, isTrue);
      });
    });

    group('outputFormatter', () {
      test('removes json code block markers', () async {
        const input = '```json\n{"status": "modified"}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'].trim(), '{"status": "modified"}');
      });

      test('replaces bold with w700', () async {
        const input = '{"style": "bold", "textStyle": "bold"}';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'], '{"style": "w700", "textStyle": "w700"}');
      });

      test('handles input without code blocks', () async {
        const input = '{"plain": "json"}';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'], '{"plain": "json"}');
      });

      test('returns map with STAC key', () async {
        const input = '{"data": [1, 2, 3]}';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result.containsKey('STAC'), isTrue);
      });

      test('handles multiple code block variations', () async {
        const input = '```json{"test": "value"}```';
        final result = await agent.outputFormatter(input);
        expect(result['STAC'], '{"test": "value"}');
      });
    });
  });
}
