import 'package:test/test.dart';
import 'package:apidash/services/agentic_services/agents/semantic_analyser.dart';

void main() {
  final agent = ResponseSemanticAnalyser();

  group('ResponseSemanticAnalyser Validator Tests', () {
    test('Should return true for a valid plain-text paragraph', () async {
      const validResponse =
          "This dataset represents a list of user profiles including names and emails. A vertical list of cards would be the ideal UI component to display this information. The user name should be emphasized as the primary title with the email as secondary text. I suggest a clean layout with ample padding between cards.";
      final isValid = await agent.validator(validResponse);
      expect(isValid, isTrue);
    });

    test(
        'Should return false for responses with markdown lists (Slurp Protection)',
        () async {
      const invalidResponse =
          "- This is a list\n- It has bullets\n- This violates the prompt instructions.";
      final isValid = await agent.validator(invalidResponse);
      expect(isValid, isFalse);
    });

    test('Should return false for very short/generic responses', () async {
      const shortResponse = "It is a list of users.";
      final isValid = await agent.validator(shortResponse);
      expect(isValid, isFalse);
    });
  });

  group('ResponseSemanticAnalyser Formatter Tests', () {
    test('Should strip markdown code blocks and keep only the content',
        () async {
      const rawAiResponse =
          "```text\nThis is the actual semantic analysis paragraph.\n```";
      final formatted = await agent.outputFormatter(rawAiResponse);
      expect(formatted['SEMANTIC_ANALYSIS'],
          "This is the actual semantic analysis paragraph.");
    });
  });
}
