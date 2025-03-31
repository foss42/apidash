import 'dart:math' as math;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_text_field/json_text_field.dart';
import 'package:apidash/consts.dart';

class JsonTextFieldEditor extends StatefulWidget {
  const JsonTextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.hintText,
    this.readOnly = false,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? hintText;
  final bool readOnly;
  @override
  State<JsonTextFieldEditor> createState() => _JsonTextFieldEditorState();
}

class _JsonTextFieldEditorState extends State<JsonTextFieldEditor> {
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
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    controller.formatJson(sortJson: false);
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
  }

  @override
  void dispose() {
    editorFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(JsonTextFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      controller.text = widget.initialValue ?? "";
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
    if (oldWidget.fieldKey != widget.fieldKey) {
      // TODO: JsonTextField uses ExtendedTextField which does
      // not rebuild because no key is provided
      // so light mode to dark mode switching leads to incorrect color.
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.tab): () {
              insertTab();
            },
          },
          child: JsonTextField(
            key: Key(widget.fieldKey),
            commonTextStyle: kCodeStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkCodeTheme['root']?.color
                  : kLightCodeTheme['root']?.color,
            ),
            specialCharHighlightStyle: kCodeStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkCodeTheme['root']?.color
                  : kLightCodeTheme['root']?.color,
            ),
            stringHighlightStyle: kCodeStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkCodeTheme['string']?.color
                  : kLightCodeTheme['string']?.color,
            ),
            numberHighlightStyle: kCodeStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkCodeTheme['number']?.color
                  : kLightCodeTheme['number']?.color,
            ),
            boolHighlightStyle: kCodeStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkCodeTheme['literal']?.color
                  : kLightCodeTheme['literal']?.color,
            ),
            nullHighlightStyle: kCodeStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkCodeTheme['variable']?.color
                  : kLightCodeTheme['variable']?.color,
            ),
            keyHighlightStyle: kCodeStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkCodeTheme['attr']?.color
                  : kLightCodeTheme['attr']?.color,
              fontWeight: FontWeight.bold,
            ),
            // errorContainerDecoration: BoxDecoration(
            //   color: Theme.of(context).colorScheme.error.withOpacity(
            //         kForegroundOpacity,
            //       ),
            //   borderRadius: kBorderRadius8,
            // ),
            // TODO: Show error message in Global Status bar
            // showErrorMessage: true,
            isFormatting: true,
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
        ),
        Align(
          alignment: Alignment.topRight,
          child: ADIconButton(
            icon: Icons.format_align_left,
            tooltip: "Format JSON",
            onPressed: () {
              controller.formatJson(sortJson: false);
              widget.onChanged?.call(controller.text);
            },
          ),
        ),
      ],
    );
  }
}
