import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class StacToFlutterBot extends AIAgent {
  @override
  String get agentName => 'STAC_TO_FLUTTER';

  @override
  String getSystemPrompt() {
    return kPromptStacToFlutter;
  }

  static final RegExp _stringLiteralRegex = RegExp(
    r'r?("""[\s\S]*?"""|'
    "'''[\\s\\S]*?'''|"
    r'"(?:\\.|[^"\\])*"|'
    r"'(?:\\.|[^'\\])*')",
  );
  static final RegExp _singleLineCommentRegex = RegExp(
    r'//.*$',
    multiLine: true,
  );
  static final RegExp _multiLineCommentRegex = RegExp(r'/\*[\s\S]*?\*/');
  static final RegExp _flutterConstructRegex = RegExp(
    r'\b[A-Z][a-zA-Z0-9]*[a-z][a-zA-Z0-9]*(\.[a-zA-Z0-9_]+)?\s*\(|\bclass\s+[A-Z]\w*|\bWidget\s+build\s*\(|import\s+[\x27\x22]package:flutter/',
  );
  static final RegExp _codeFenceRegex = RegExp(
    r'```(?:dart|flutter)?',
    caseSensitive: false,
  );

  static const List<String> _refusalPrefixes = [
    "i'm sorry",
    'i am sorry',
    'sorry',
    'i apologize',
    'apologies',
    'i cannot',
    "i can't",
    'i am unable',
    "i'm unable",
    'i am not able',
    "i'm not able",
    'as an ai',
    'as a language model',
    'unfortunately',
  ];

  static const List<String> _refusalPhrases = [
    'cannot convert',
    'unable to convert',
    'cannot generate',
    'unable to generate',
    'cannot fulfill',
    'cannot assist',
    'unable to assist',
    'as an ai',
    'as a language model',
    'i cannot',
    "i can't",
    'i am unable',
    "i'm unable",
    'i apologize',
  ];

  @override
  Future<bool> validator(String aiResponse) async {
    final cleaned = aiResponse.replaceAll(_codeFenceRegex, '').trim();
    if (cleaned.isEmpty) {
      return false;
    }

    final withoutComments = cleaned
        .replaceAll(_singleLineCommentRegex, '')
        .replaceAll(_multiLineCommentRegex, '')
        .trim();
    if (withoutComments.isEmpty) {
      return false;
    }

    final lowerWithoutComments = withoutComments.toLowerCase();
    for (final prefix in _refusalPrefixes) {
      if (lowerWithoutComments.startsWith(prefix)) {
        return false;
      }
    }

    final codeWithoutStrings = withoutComments.replaceAll(
      _stringLiteralRegex,
      '""',
    );
    final lowerCodeWithoutStrings = codeWithoutStrings.toLowerCase();
    for (final phrase in _refusalPhrases) {
      if (lowerCodeWithoutStrings.contains(phrase)) {
        return false;
      }
    }

    if (!codeWithoutStrings.contains('(') ||
        !codeWithoutStrings.contains(')')) {
      return false;
    }

    if (!_flutterConstructRegex.hasMatch(codeWithoutStrings)) {
      return false;
    }

    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```dart', '')
        .replaceAll('```dart\n', '')
        .replaceAll('```', '');

    return {'CODE': validatedResponse};
  }
}
