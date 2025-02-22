import 'package:apidash/widgets/widgets.dart';
import 'dart:math' as math;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'dart:convert';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_text_field/json_text_field.dart';

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
    controller.formatJson(sortJson: false);
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.format_align_left),
            onPressed: () {
              controller.formatJson(sortJson: false);
            },
          ),
        ),
        Expanded(
          child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.tab): () {
                insertTab();
              },
            },
            child: JsonTextField(
              stringHighlightStyle: kCodeStyle.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kDarkCodeTheme['string']?.color
                    : kLightCodeTheme['string']?.color,
              ),

              keyHighlightStyle: kCodeStyle.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kDarkCodeTheme['attr']?.color
                    : kLightCodeTheme['attr']?.color,
                fontWeight: FontWeight.bold,
              ),
              errorContainerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(
                      kForegroundOpacity,
                    ),
                borderRadius: kBorderRadius8,
              ),
              showErrorMessage: true,
              isFormatting: true,
              key: Key(widget.fieldKey),
              controller: controller,
              focusNode: editorFocusNode,
              keyboardType: TextInputType.multiline,
              expands: true,
              maxLines: null,
              style: kCodeStyle,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: kHintJson,
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
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
          ),
        ),
      ],
    );
  }
}
