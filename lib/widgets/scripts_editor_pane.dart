import 'package:apidash/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScriptsEditorPane extends ConsumerStatefulWidget {
  final bool readOnly;
  final CodeController controller;
  const ScriptsEditorPane({
    super.key,
    required this.controller,
    this.readOnly = false,
  });

  @override
  ConsumerState<ScriptsEditorPane> createState() => _ScriptsEditorPaneState();
}

class _ScriptsEditorPaneState extends ConsumerState<ScriptsEditorPane> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: CodeTheme(
        data: CodeThemeData(
          styles: settings.isDark ? monokaiTheme : xcodeTheme,
        ),
        child: SingleChildScrollView(
          child: CodeField(
            readOnly: widget.readOnly,
            smartDashesType: SmartDashesType.enabled,
            smartQuotesType: SmartQuotesType.enabled,
            background: Theme.of(context).colorScheme.surfaceContainerLowest,
            gutterStyle: GutterStyle(
              width: 40, // TODO: Fix numbers size
              margin: 2,
              textAlign: TextAlign.left,
              showFoldingHandles: false,
              showLineNumbers: false,
            ),
            cursorColor: Theme.of(context).colorScheme.primary,
            controller: widget.controller,
            textStyle: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
