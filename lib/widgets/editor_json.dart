import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/json.dart';
import 'package:apidash/consts.dart';

class JsonTextFieldEditor extends StatefulWidget {
  const JsonTextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  @override
  State<JsonTextFieldEditor> createState() => _JsonTextFieldEditorState();
}

class _JsonTextFieldEditorState extends State<JsonTextFieldEditor> {
  final TextEditingController controller = TextEditingController();
  late final FocusNode editorFocusNode;
  CodeController? _codeController;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
    _codeController = CodeController(
      text: widget.initialValue,
      language: json,
    );
    // listener for changing border color on focus change
    editorFocusNode.addListener(() {
      setState(() {
        _focused = editorFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    editorFocusNode.dispose();
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    return CodeTheme(
      data: CodeThemeData(
          styles: Theme.of(context).brightness == Brightness.dark
              ? kDarkCodeTheme
              : kLightCodeTheme),
      child: CodeField(
        key: Key(widget.fieldKey),
        controller: _codeController!,
        focusNode: editorFocusNode,
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        textStyle: kCodeStyle,
        lineNumbers: false,
        hintText: "Enter content (json)",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.outline.withOpacity(
                kHintOpacity,
              ),
        ),
        onChanged: widget.onChanged,
        decoration: BoxDecoration(
          color: Color.alphaBlend(
              (Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.primaryContainer)
                  .withOpacity(kForegroundOpacity),
              Theme.of(context).colorScheme.surface),
          border: Border.fromBorderSide(BorderSide(
              color: _focused
                  ? Theme.of(context).colorScheme.primary.withOpacity(
                        kHintOpacity,
                      )
                  : Theme.of(context).colorScheme.surfaceVariant)),
          borderRadius: kBorderRadius8,
        ),
      ),
    );
  }
}
