import 'package:apidash/services/agentic_services/agents/apitool_bodygen.dart';
import 'package:test/test.dart';

void main() {
  group('ApiToolBodyGen', () {
    late ApiToolBodyGen agent;

    setUp(() {
      agent = ApiToolBodyGen();
    });

    test('agent name is correct', () {
      expect(agent.agentName, 'APITOOL_BODYGEN');
    });

    group('validator', () {
      test('returns true for any string input', () async {
        const input = 'body content here';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for empty string', () async {
        const input = '';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for code with syntax', () async {
        const input = 'body = {"key": "value"}';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for multiline code', () async {
        const input = '''
        body = {
            "name": "test",
            "data": [1, 2, 3]
        }
        ''';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });
    });

    group('outputFormatter', () {
      test('removes python code blocks', () async {
        const input = '```python\nbody = {"test": "data"}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['TOOL'].trim(), 'body = {"test": "data"}');
      });

      test('removes javascript code blocks', () async {
        const input = '```javascript\nconst body = {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['TOOL'].trim(), 'const body = {}');
      });

      test('handles plain text without code blocks', () async {
        const input = 'simple body generation';
        final result = await agent.outputFormatter(input);
        expect(result['TOOL'], 'simple body generation');
      });

      test('returns map with TOOL key', () async {
        const input = 'tool content';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result.containsKey('TOOL'), isTrue);
      });

      test('removes all code block markers', () async {
        const input = '```python\nsome code\n```javascript\nmore\n```';
        final result = await agent.outputFormatter(input);
        expect(result['TOOL'], isNot(contains('```')));
        expect(result['TOOL'], isNot(contains('python')));
        expect(result['TOOL'], isNot(contains('javascript')));
      });

      test('handles python code with newline marker', () async {
        const input = '```python\ndata = [1, 2, 3]\n```';
        final result = await agent.outputFormatter(input);
        expect(result['TOOL'].trim(), 'data = [1, 2, 3]');
      });

      test('handles javascript code with newline marker', () async {
        const input = '```javascript\nlet data = [];\n```';
        final result = await agent.outputFormatter(input);
        expect(result['TOOL'].trim(), 'let data = [];');
      });

      test('preserves code formatting', () async {
        const input = '''body = {
    "key": "value"
}''';
        final result = await agent.outputFormatter(input);
        expect(result['TOOL'], contains('\n'));
        expect(result['TOOL'], contains('    '));
      });
    });
  });
}
