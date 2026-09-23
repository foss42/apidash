import 'package:test/test.dart';
// Added the /agents/ part of the path below
import 'package:apidash/services/agentic_services/agents/intermediate_rep_gen.dart';

void main() {
  group('IntermediateRepresentationGen Tests', () {
    final agent = IntermediateRepresentationGen();

    test('Validator should return true for valid Markdown UI schema', () async {
      const validResponse = '''
      - **[Column]** Root layout
        - **[Card]** User Info
          - **[Text]** Name: John Doe
      ''';
      final isValid = await agent.validator(validResponse);
      expect(isValid, isTrue);
    });

    test('Validator should return false for plain text hallucinations', () async {
      const invalidResponse = "I'm sorry, I cannot process this API response.";
      final isValid = await agent.validator(invalidResponse);
      expect(isValid, isFalse);
    });

    test('OutputFormatter should strip various markdown code blocks', () async {
      const responseWithMarkdown = "```markdown\n- **[Row]**\n```";
      const responseWithYaml = "```yaml\n- **[Row]**\n```";
      
      final formattedMarkdown = await agent.outputFormatter(responseWithMarkdown);
      final formattedYaml = await agent.outputFormatter(responseWithYaml);

      expect(formattedMarkdown['INTERMEDIATE_REPRESENTATION'], equals('- **[Row]**'));
      expect(formattedYaml['INTERMEDIATE_REPRESENTATION'], equals('- **[Row]**'));
    });
  });
}