import 'package:apidash/services/agentic_services/agents/semantic_analyser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponseSemanticAnalyser', () {
    final agent = ResponseSemanticAnalyser();

    test('agentName is correct', () {
      expect(agent.agentName, 'RESP_SEMANTIC_ANALYSER');
    });

    test('getSystemPrompt returns non-empty string', () {
      expect(agent.getSystemPrompt(), isNotEmpty);
    });

    test('validator always returns true', () async {
      expect(await agent.validator('test'), isTrue);
    });

    test('outputFormatter wraps in map correctly', () async {
      final result = await agent.outputFormatter('test_response');
      expect(result, isA<Map>());
      expect(result['SEMANTIC_ANALYSIS'], 'test_response');
    });
  });
}
