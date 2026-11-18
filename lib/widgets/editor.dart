import 'dart:math' as math;
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldEditor extends StatefulWidget {
  const TextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.readOnly = false,
    this.hintText,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  final bool readOnly;
  final String? hintText;
  @override
  State<TextFieldEditor> createState() => _TextFieldEditorState();
}

class _TextFieldEditorState extends State<TextFieldEditor> {
  late TextEditingController controller;
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
    final initialText = widget.initialValue ?? '';
    controller = TextEditingController.fromValue(TextEditingValue(
        text: initialText,
        selection: TextSelection.collapsed(offset: initialText.length)));
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
  }

  @override
  void dispose() {
    controller.dispose();
    editorFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fieldKey != widget.fieldKey) {
      controller = TextEditingController.fromValue(TextEditingValue(
          text: widget.initialValue!,
          selection: TextSelection.collapsed(
              offset: widget.initialValue!.length)));
    } else if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        controller.text != widget.initialValue) {
      // Update controller text only if it differs from current text
      // This preserves cursor position when typing
      final currentSelection = controller.selection;
      controller.text = widget.initialValue!;
      // Restore the selection if it's still valid
      if (currentSelection.baseOffset <= controller.text.length) {
        controller.selection = currentSelection;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.tab): () {
          insertTab();
        },
      },
      child: TextFormField(
        key: Key(widget.fieldKey),
        controller: controller,
        focusNode: editorFocusNode,
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        readOnly: widget.readOnly,
        style: kCodeStyle.copyWith(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
        ),
        textAlignVertical: TextAlignVertical.top,
        onChanged: widget.onChanged,
        onTapOutside: (PointerDownEvent event) {
          editorFocusNode.unfocus();
        },
        decoration: InputDecoration(
          hintText: widget.hintText ?? kHintContent,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: kBorderRadius8,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: kBorderRadius8,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          filled: true,
          hoverColor: kColorTransparent,
          fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
      ),
    );
  }
}
