import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeEditor extends ConsumerWidget {
  final bool readOnly;
  final CodeController controller;
  const CodeEditor({
    super.key,
    required this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return CodeTheme(
      data: CodeThemeData(
        styles: settings.isDark ? monokaiTheme : xcodeTheme,
      ),
      child: CodeField(
        expands: true,
        decoration: BoxDecoration(
          borderRadius: kBorderRadius8,
          border: BoxBorder.all(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
        readOnly: readOnly,
        smartDashesType: SmartDashesType.enabled,
        smartQuotesType: SmartQuotesType.enabled,
        background: Theme.of(context).colorScheme.surfaceContainerLowest,
        gutterStyle: GutterStyle(
          width: 0, // TODO: Fix numbers size
          margin: 2,
          textAlign: TextAlign.left,
          showFoldingHandles: false,
          showLineNumbers: false,
        ),
        cursorColor: Theme.of(context).colorScheme.primary,
        controller: controller,
        textStyle: kCodeStyle.copyWith(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
        ),
      ),
    );
  }
}
