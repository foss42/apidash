import 'package:apidash/services/agentic_services/agents/semantic_analyser.dart';
import 'package:test/test.dart';

void main() {
  group('ResponseSemanticAnalyser', () {
    late ResponseSemanticAnalyser agent;

    setUp(() {
      agent = ResponseSemanticAnalyser();
    });

    test('agent name is correct', () {
      expect(agent.agentName, 'RESP_SEMANTIC_ANALYSER');
    });

    group('validator', () {
      test('returns true for any string input', () async {
        const input = 'Any semantic analysis text';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for empty string', () async {
        const input = '';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for multiline text', () async {
        const input = '''
        This is a semantic analysis
        with multiple lines
        and detailed explanation
        ''';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for special characters', () async {
        const input = 'Analysis: @#\$%^&*() special chars';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });
    });

    group('outputFormatter', () {
      test('returns map with SEMANTIC_ANALYSIS key', () async {
        const input = 'This is the semantic analysis result';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result.containsKey('SEMANTIC_ANALYSIS'), isTrue);
      });

      test('preserves the input text unchanged', () async {
        const input = 'Original analysis text with formatting';
        final result = await agent.outputFormatter(input);
        expect(result['SEMANTIC_ANALYSIS'], input);
      });

      test('handles empty input', () async {
        const input = '';
        final result = await agent.outputFormatter(input);
        expect(result['SEMANTIC_ANALYSIS'], '');
      });

      test('handles multiline input', () async {
        const input = '''Line 1
Line 2
Line 3''';
        final result = await agent.outputFormatter(input);
        expect(result['SEMANTIC_ANALYSIS'], input);
      });

      test('handles unicode characters', () async {
        const input = 'Analysis with émojis 🚀 and ünîcödé';
        final result = await agent.outputFormatter(input);
        expect(result['SEMANTIC_ANALYSIS'], input);
      });
    });
  });
}
