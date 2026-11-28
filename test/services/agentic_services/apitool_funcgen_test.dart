import 'package:apidash/services/agentic_services/agents/apitool_funcgen.dart';
import 'package:apidash/templates/templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('APIToolFunctionGenerator', () {
    final agent = APIToolFunctionGenerator();

    test('agentName is correct', () {
      expect(agent.agentName, 'APITOOL_FUNCGEN');
    });

    test('getSystemPrompt returns the API tool function prompt', () {
      expect(agent.getSystemPrompt(), kPromptAPIToolFuncGen);
      expect(agent.getSystemPrompt(), isNotEmpty);
    });

    test('validator always returns true', () async {
      expect(await agent.validator('any response'), isTrue);
      expect(await agent.validator(''), isTrue);
    });

    test('outputFormatter strips python code fences', () async {
      const input = '```python\ndef f():\n    pass\n```';
      final result = await agent.outputFormatter(input);
      expect(result, isA<Map>());
      expect(result['FUNC'], '\ndef f():\n    pass\n');
    });

    test('outputFormatter strips javascript code fences', () async {
      const input = '```javascript\nfunction f() {}\n```';
      final result = await agent.outputFormatter(input);
      expect(result['FUNC'], '\nfunction f() {}\n');
    });

    test('outputFormatter keeps unfenced text unchanged', () async {
      final result = await agent.outputFormatter('function f() {}');
      expect(result['FUNC'], 'function f() {}');
    });
  });
}
