import 'package:apidash/services/agentic_services/agents/apitool_bodygen.dart';
import 'package:apidash/templates/templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiToolBodyGen', () {
    final agent = ApiToolBodyGen();

    test('agentName is correct', () {
      expect(agent.agentName, 'APITOOL_BODYGEN');
    });

    test('getSystemPrompt returns the API tool body prompt', () {
      expect(agent.getSystemPrompt(), kPromptAPIToolBodyGen);
      expect(agent.getSystemPrompt(), isNotEmpty);
    });

    test('validator always returns true', () async {
      expect(await agent.validator('any response'), isTrue);
      expect(await agent.validator(''), isTrue);
    });

    test('outputFormatter strips python code fences', () async {
      final result = await agent.outputFormatter('```python\nprint(1)\n```');
      expect(result, isA<Map>());
      expect(result['TOOL'], '\nprint(1)\n');
    });

    test('outputFormatter strips javascript code fences', () async {
      const input = '```javascript\nconst a = 1;\n```';
      final result = await agent.outputFormatter(input);
      expect(result['TOOL'], '\nconst a = 1;\n');
    });

    test('outputFormatter keeps unfenced text unchanged', () async {
      final result = await agent.outputFormatter('def tool(): pass');
      expect(result['TOOL'], 'def tool(): pass');
    });
  });
}
