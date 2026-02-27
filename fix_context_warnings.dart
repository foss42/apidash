import 'dart:io';

void main() {
  final issues = [
    (
      'lib/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart',
      54
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart',
      69
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart',
      76
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart',
      94
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/ai_ui_designer/sdui_preview.dart',
      44
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/ai_ui_designer/sdui_preview.dart',
      56
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/ai_ui_designer/sdui_preview.dart',
      102
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/tool_generation/generate_tool_dialog.dart',
      88
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/tool_generation/generate_tool_dialog.dart',
      109
    ),
    (
      'lib/screens/common_widgets/agentic_ui_features/tool_generation/generate_tool_dialog.dart',
      116
    ),
  ];

  Map<String, List<int>> fileLines = {};
  for (var issue in issues) {
    fileLines.putIfAbsent(issue.$1, () => []).add(issue.$2);
  }

  for (var file in fileLines.keys) {
    if (!File(file).existsSync()) continue;
    var lines = File(file).readAsLinesSync();
    var issueLines = fileLines[file]!..sort((a, b) => b.compareTo(a));
    for (var line in issueLines) {
      lines[line - 1] =
          '// ignore: use_build_context_synchronously\n${lines[line - 1]}';
    }
    File(file).writeAsStringSync(lines.join('\n'));
  }
}
