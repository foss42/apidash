import 'package:apidash/templates/templates.dart';
import 'package:apidash_core/apidash_core.dart';

class StacToFlutterBot extends AIAgent {
  @override
  String get agentName => 'STAC_TO_FLUTTER';

  @override
  String getSystemPrompt() {
    return kPromptStacToFlutter;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    final trimmed = aiResponse.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    String code = trimmed;

    // Handle markdown code blocks
    if (code.contains('```')) {
      final firstFence = code.indexOf('```');
      final lastFence = code.lastIndexOf('```');
      if (firstFence == lastFence) {
        // Unclosed code block
        return false;
      }

      // Expected output format is only code representation without explanatory prose
      final prefix = code.substring(0, firstFence).trim();
      final suffix = code.substring(lastFence + 3).trim();
      if (prefix.isNotEmpty || suffix.isNotEmpty) {
        return false;
      }

      var inside = code.substring(firstFence, lastFence + 3);
      inside = inside
          .replaceAll(RegExp(r'^```[a-zA-Z0-9_-]*\n?'), '')
          .replaceAll(RegExp(r'\n?```$'), '');
      code = inside.trim();
      if (code.isEmpty) {
        return false;
      }
    }

    // Check for common natural-language refusal or conversational preamble patterns
    final refusalPattern = RegExp(
      r'^(i\s+(cannot|can\x27?t|am\s+unable|am\s+not\s+able|am\s+sorry|apologize|won\x27?t|do\s+not)|sorry|as\s+an?\s+ai|here\s+(is|are)\s+the|certainly|unfortunately|please\s+provide|there\s+is\s+an?\s+error)',
      caseSensitive: false,
    );
    if (refusalPattern.hasMatch(code)) {
      return false;
    }

    // Strip comments and string literals to inspect underlying code structure
    // and prevent false positives from text inside strings (e.g. Text("Sorry, unable to load"))
    final stripped = _stripCommentsAndStrings(code);
    final strippedTrimmed = stripped.trim();
    if (strippedTrimmed.isEmpty) {
      return false;
    }

    if (refusalPattern.hasMatch(strippedTrimmed)) {
      return false;
    }

    // Check for realistic Dart/Flutter code indicators:
    // 1. Declarations: class, mixin, enum, extension, typedef, import, export
    final hasDeclaration = RegExp(
      r'\b(class|mixin|enum|extension|typedef)\s+[A-Za-z0-9_]+|\b(import|export)\s+[\x27\x22]',
    ).hasMatch(stripped);

    // 2. Flutter/Dart keywords and constructs
    final hasDartConstructs = RegExp(
      r'\b(Widget|BuildContext|StatelessWidget|StatefulWidget|State|override)\b',
    ).hasMatch(stripped);

    // 3. Arrow function or statements with code tokens
    final hasCodeTokens = RegExp(
      r'(=>|\b(return|final|const|void|var|late)\b)',
    ).hasMatch(stripped);

    // 4. Widget constructor invocation with named parameters or common Flutter widgets
    final hasWidgetInvocation = RegExp(
          r'\b[A-Z][a-zA-Z0-9_]*\s*\([^)]*\b(child|children|builder|style|color|width|height|padding|margin|onPressed):',
        ).hasMatch(code) ||
        RegExp(
          r'\b(Text|Container|Column|Row|Scaffold|SizedBox|Center|Padding|Card|Expanded|ListView|Stack|MaterialApp|AppBar|ElevatedButton|Icon)\s*\(',
        ).hasMatch(stripped);

    // Code must have basic syntax structure (braces, semicolons, arrow, or paired parentheses)
    final hasSyntaxStructure = stripped.contains('{') ||
        stripped.contains(';') ||
        stripped.contains('=>') ||
        (stripped.contains('(') && stripped.contains(')'));

    if (!hasSyntaxStructure) {
      return false;
    }

    return hasDeclaration ||
        hasDartConstructs ||
        hasCodeTokens ||
        hasWidgetInvocation;
  }

  String _stripCommentsAndStrings(String input) {
    var s = input.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ');
    s = s.replaceAll(RegExp(r'//.*'), ' ');
    s = s.replaceAll(RegExp(r"'''[\s\S]*?'''"), '""');
    s = s.replaceAll(RegExp(r'"""[\s\S]*?"""'), '""');
    s = s.replaceAll(RegExp(r"r'[^']*'"), '""');
    s = s.replaceAll(RegExp(r'r"[^"]*"'), '""');
    s = s.replaceAll(RegExp(r"'([^'\\]|\\.)*'"), '""');
    s = s.replaceAll(RegExp(r'"([^"\\]|\\.)*"'), '""');
    return s;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```dart', '')
        .replaceAll('```dart\n', '')
        .replaceAll('```', '');

    return {
      'CODE': validatedResponse,
    };
  }
}
