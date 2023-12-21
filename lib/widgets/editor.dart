import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';
import 'package:json_text_field/json_text_field.dart';

class TextFieldEditor extends StatefulWidget {
  const TextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.contentType,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  final ContentType? contentType;
  @override
  State<TextFieldEditor> createState() => _TextFieldEditorState();
}

class _TextFieldEditorState extends State<TextFieldEditor> {
  final JsonTextFieldController controller = JsonTextFieldController();
  late final FocusNode editorFocusNode;

  void insertTab() {
    String sp = "  ";
    int offset = math.min(
        controller.selection.baseOffset, controller.selection.extentOffset);
    String text = controller.text.substring(0, offset) +
        sp +
        controller.text.substring(offset);
    controller.value = TextEditingValue(
      text: text,
      selection: controller.selection.copyWith(
        baseOffset: controller.selection.baseOffset + sp.length,
        extentOffset: controller.selection.extentOffset + sp.length,
      ),
    );
    widget.onChanged?.call(text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.contentType == ContentType.json) {
      controller.formatJson(sortJson: false);
    }
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
  }

  @override
  void dispose() {
    editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.tab): () {
          insertTab();
        },
      },
      child: JsonTextField(
        stringHighlightStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
        keyHighlightStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        errorContainerDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withOpacity(
                kForegroundOpacity,
              ),
          borderRadius: kBorderRadius8,
        ),
        showErrorMessage: true,
        isFormatting: widget.contentType == ContentType.json,
        key: Key(widget.fieldKey),
        controller: controller,
        focusNode: editorFocusNode,
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        style: kCodeStyle,
        textAlignVertical: TextAlignVertical.top,
        onChanged: (value) {
          widget.onChanged?.call(value);
          if (widget.contentType == ContentType.json) {
            controller.formatJson(sortJson: false);
          }
        },
        decoration: InputDecoration(
          hintText: "Enter content (body)",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline.withOpacity(
                  kHintOpacity,
                ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: kBorderRadius8,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(
                    kHintOpacity,
                  ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: kBorderRadius8,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
          filled: true,
          hoverColor: kColorTransparent,
          fillColor: Color.alphaBlend(
              (Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.primaryContainer)
                  .withOpacity(kForegroundOpacity),
              Theme.of(context).colorScheme.surface),
        ),
      ),
    );
  }
}
