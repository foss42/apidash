import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class IntermediateRepresentationGen extends AIAgent {
  @override
  String get agentName => 'INTERMEDIATE_REP_GEN';

  @override
  String getSystemPrompt() {
    return kPromptIntermediateRepGen;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    // 1. Check if the response contains the required UI element markers [ ]
    // This is the core structure defined in the system prompt.
    if (!aiResponse.contains('[') || !aiResponse.contains(']')) {
      return false;
    }

    // 2. Validate against the 'Allowed UI elements' list from the prompt.
    // As an AI/ML engineer, we want to ensure the model stayed within its constraints.
    const allowedElements = [
      'Text', 'Row', 'Column', 'GridView', 'SingleChildScrollView', 
      'Expanded', 'Image', 'ElevatedButton', 'Icon', 'Padding', 
      'SizedBox', 'Card', 'Container', 'Spacer', 'ListTile', 'Table'
    ];

    // Ensure at least one valid Flutter-based UI element is present.
    bool hasValidElement = allowedElements.any(
      (element) => aiResponse.contains('[$element]')
    );

    return hasValidElement;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    // The prompt asks for Markdown, but LLMs often wrap it in code blocks.
    // We use a RegExp to strip backticks (like ```markdown or ```yaml) 
    // to ensure the downstream parser gets clean text.
    validatedResponse = validatedResponse
        .replaceAll(RegExp(r'```[a-z]*\n?'), '')
        .replaceAll('```', '')
        .trim();

    return {
      'INTERMEDIATE_REPRESENTATION': validatedResponse,
    };
  }
}
