import 'package:apidash/services/agentic_services/agents/stacmodifier.dart';
import 'package:apidash/templates/templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StacModifierBot', () {
    final agent = StacModifierBot();

    test('agentName is correct', () {
      expect(agent.agentName, 'STAC_MODIFIER');
    });

    test('getSystemPrompt returns the Stac modifier prompt', () {
      expect(agent.getSystemPrompt(), kPromptStacModifier);
      expect(agent.getSystemPrompt(), isNotEmpty);
    });

    test('validator accepts valid JSON', () async {
      expect(await agent.validator('{"type": "text", "data": "Hi"}'), isTrue);
    });

    test('validator accepts JSON wrapped in json code fences', () async {
      const input = '```json\n{"type": "column"}\n```';
      expect(await agent.validator(input), isTrue);
    });

    test('validator rejects invalid JSON', () async {
      expect(await agent.validator('not json'), isFalse);
      expect(await agent.validator('{"type": "text"'), isFalse);
    });

    test('outputFormatter strips json code fences', () async {
      const input = '```json\n{"type": "text"}\n```';
      final result = await agent.outputFormatter(input);
      expect(result, isA<Map>());
      expect(result['STAC'], '\n{"type": "text"}\n');
    });

    test('outputFormatter maps bold font weight to w700', () async {
      final result = await agent.outputFormatter('{"fontWeight": "bold"}');
      expect(result['STAC'], '{"fontWeight": "w700"}');
    });
  });
}
