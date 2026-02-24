import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

/// [ResponseSemanticAnalyser] interprets raw JSON data into a plain-text
/// semantic paragraph to guide downstream UI generation agents.
class ResponseSemanticAnalyser extends AIAgent {
  @override
  String get agentName => 'RESP_SEMANTIC_ANALYSER';

  @override
  String getSystemPrompt() => kPromptSemanticAnalyser;

  @override
  Future<bool> validator(String aiResponse) async {
    final trimmed = aiResponse.trim();

    // 🛡️ Defense 1: Ensure the response isn't an empty 'slurp'.
    if (trimmed.length < 30) return false;

    // 🛡️ Defense 2: Strict "No Markdown/List" Check.
    // The prompt explicitly forbids lists and markdown. If we see bullet
    // points or headers, the model failed the instruction.
    final hasIllegalFormatting =
        RegExp(r'(^\s*[\-\*\u2022])|(\n[\-\*\u2022])|(###|\[|\])')
            .hasMatch(trimmed);
    if (hasIllegalFormatting) return false;

    // 🛡️ Defense 3: Single Paragraph Check.
    // If there are multiple double-newlines, it's not a "single well-structured paragraph".
    if (trimmed.contains('\n\n')) return false;

    return true;
  }

  @override
  Future<Map<String, dynamic>> outputFormatter(String validatedResponse) async {
    // 🛡️ Defense 4: Final Sanitization.
    // Even with a validator, we strip any accidental backticks or weird
    // model boilerplate (e.g., "Here is the analysis:") just in case.
    final cleanResponse = validatedResponse
        .replaceAll(RegExp(r'```[a-zA-Z]*\n?|```'), '')
        .replaceAll(
            RegExp(r'^(Here is|This is) the analysis:?', caseSensitive: false),
            '')
        .trim();

    return {
      'SEMANTIC_ANALYSIS': cleanResponse,
    };
  }
}
