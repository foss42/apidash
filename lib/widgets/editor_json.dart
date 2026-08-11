import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_field_editor/json_field_editor.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/json_utils.dart';

class JsonTextFieldEditor extends StatefulWidget {
  const JsonTextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.hintText,
    this.readOnly = false,
    this.isDark = false,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? hintText;
  final bool readOnly;
  final bool isDark;

  @override
  State<JsonTextFieldEditor> createState() => _JsonTextFieldEditorState();
}

class _JsonTextFieldEditorState extends State<JsonTextFieldEditor> {
  final JsonTextFieldController controller = JsonTextFieldController();
  late final FocusNode editorFocusNode;
  
  String? validationError;
  int? errorOffset;
  int? errorLength;
  Timer? _debounce;

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
    _onChanged(text);
  }

  void _validateJson(String text) {
     if (text.isEmpty) {
      if (validationError != null) {
        setState(() {
          validationError = null;
          errorOffset = null;
        });
      }
      return;
    }
    try {
      json.decode(text);
      // Syntax valid. Check logical errors (Duplicates).
      var (dupeError, offset, length) = JsonUtils.findDuplicateKeys(text);
      if (dupeError != null) {
        setState(() {
          validationError = "Error: $dupeError";
          errorOffset = offset;
          errorLength = length;
        });
        return;
      }

      // No errors
      if (validationError != null) {
        setState(() {
          validationError = null;
          errorOffset = null;
          errorLength = null;
        });
      }
    } on FormatException catch (e) {
      int offset = e.offset ?? -1;
      var (line, col) = JsonUtils.getLineCol(text, offset);
      setState(() {
        validationError = "Error at Line $line, Col $col: ${e.message}";
        errorOffset = offset;
        // Check if we can determine length. E.g. unexpected character?
        // Default to 1 for basic highlighting (cursor or single char).
        errorLength = 1;
      });
    } catch (e) {
       setState(() {
        validationError = "Invalid JSON: $e";
        errorOffset = null;
        errorLength = null;
      });
    }
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _validateJson(value);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
       // Re-validate on update
      _validateJson(controller.text);
    }
    if ((oldWidget.fieldKey != widget.fieldKey) ||
        (oldWidget.isDark != widget.isDark)) {
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
          child: JsonField(
            key: ValueKey("${widget.fieldKey}-fld"),
            fieldKey: widget.fieldKey,
            commonTextStyle: kCodeStyle.copyWith(
              color: widget.isDark
                  ? kDarkCodeTheme['root']?.color
                  : kLightCodeTheme['root']?.color,
            ),
            specialCharHighlightStyle: kCodeStyle.copyWith(
              color: widget.isDark
                  ? kDarkCodeTheme['root']?.color
                  : kLightCodeTheme['root']?.color,
            ),
            stringHighlightStyle: kCodeStyle.copyWith(
              color: widget.isDark
                  ? kDarkCodeTheme['string']?.color
                  : kLightCodeTheme['string']?.color,
            ),
            numberHighlightStyle: kCodeStyle.copyWith(
              color: widget.isDark
                  ? kDarkCodeTheme['number']?.color
                  : kLightCodeTheme['number']?.color,
            ),
            boolHighlightStyle: kCodeStyle.copyWith(
              color: widget.isDark
                  ? kDarkCodeTheme['literal']?.color
                  : kLightCodeTheme['literal']?.color,
            ),
            nullHighlightStyle: kCodeStyle.copyWith(
              color: widget.isDark
                  ? kDarkCodeTheme['variable']?.color
                  : kLightCodeTheme['variable']?.color,
            ),
            keyHighlightStyle: kCodeStyle.copyWith(
              color: widget.isDark
                  ? kDarkCodeTheme['attr']?.color
                  : kLightCodeTheme['attr']?.color,
              fontWeight: FontWeight.bold,
            ),
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
            onChanged: _onChanged,
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
        if (validationError != null)
          Align(
            alignment: Alignment.bottomLeft,
            child: Tooltip(
              message: validationError!,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontSize: 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: InkWell(
                onTap: () {
                   // Highlight error
                   if (errorOffset != null && errorOffset! >= 0 && errorOffset! <= controller.text.length) {
                     editorFocusNode.requestFocus();
                     // Default length 1 if not provided (e.g. syntax error at end)
                     int length = errorLength ?? 1;
                     if (errorOffset! + length > controller.text.length) {
                       length = controller.text.length - errorOffset!;
                     }
                     controller.selection = TextSelection(
                       baseOffset: errorOffset!,
                       extentOffset: errorOffset! + length,
                     );
                   }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Invalid JSON (Hover for details, Tap to locate)",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
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
              _onChanged(controller.text);
            },
          ),
        ),
      ],
    );
  }
}
