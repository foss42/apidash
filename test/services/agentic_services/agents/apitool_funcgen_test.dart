import 'package:apidash/services/agentic_services/agents/apitool_funcgen.dart';
import 'package:test/test.dart';

void main() {
  group('APIToolFunctionGenerator', () {
    late APIToolFunctionGenerator agent;

    setUp(() {
      agent = APIToolFunctionGenerator();
    });

    test('agent name is correct', () {
      expect(agent.agentName, 'APITOOL_FUNCGEN');
    });

    group('validator', () {
      test('returns true for any string input', () async {
        const input = 'def some_function(): pass';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for empty string', () async {
        const input = '';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for Python code', () async {
        const input = '''
        def api_call():
            return requests.get("https://api.example.com")
        ''';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for JavaScript code', () async {
        const input = 'function apiCall() { return fetch("url"); }';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });
    });

    group('outputFormatter', () {
      test('removes python code blocks', () async {
        const input = '```python\ndef test():\n    pass\n```';
        final result = await agent.outputFormatter(input);
        expect(result['FUNC'].trim(), 'def test():\n    pass');
      });

      test('removes javascript code blocks', () async {
        const input = '```javascript\nfunction test() {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['FUNC'].trim(), 'function test() {}');
      });

      test('handles input without code blocks', () async {
        const input = 'plain function code';
        final result = await agent.outputFormatter(input);
        expect(result['FUNC'], 'plain function code');
      });

      test('returns map with FUNC key', () async {
        const input = 'some code';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result.containsKey('FUNC'), isTrue);
      });

      test('removes multiple code block markers', () async {
        const input = '```python\ncode\n```\n```javascript\nmore\n```';
        final result = await agent.outputFormatter(input);
        expect(result['FUNC'], isNot(contains('```')));
      });

      test('handles python code with newline in marker', () async {
        const input = '```python\ndef func():\n    return True\n```';
        final result = await agent.outputFormatter(input);
        expect(result['FUNC'].trim(), 'def func():\n    return True');
        expect(result['FUNC'], isNot(contains('python')));
      });

      test('handles javascript code with newline in marker', () async {
        const input = '```javascript\nconst x = () => {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['FUNC'].trim(), 'const x = () => {}');
        expect(result['FUNC'], isNot(contains('javascript')));
      });
    });
  });
}
