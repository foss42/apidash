import 'dart:convert';
import 'dart:math' as math;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_field_editor/json_field_editor.dart';
import 'package:apidash/consts.dart';

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
  bool _isValidJson = true;
  String? _jsonError;


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

  /// Pure validation routine that doesn't call setState. Returns a map
  /// containing "isValid", "error" and "parsed" keys.
  Map<String, dynamic> _validateJsonSync(String value) {
    if (value.trim().isEmpty) {
      return {'isValid': true, 'error': null, 'parsed': null};
    }
    try {
      final parsed = json.decode(value);
      return {'isValid': true, 'error': null, 'parsed': parsed};
    } catch (e) {
      return {'isValid': false, 'error': e.toString(), 'parsed': null};
    }
  }

  void _validateJson(String value) {
    final result = _validateJsonSync(value);
    setState(() {
      _isValidJson = result['isValid'] as bool;
      _jsonError = result['error'] as String?;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
      final result = _validateJsonSync(widget.initialValue!);
      _isValidJson = result['isValid'] as bool;
      _jsonError = result['error'] as String?;
    }
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
  }

  @override
  void dispose() {
    controller.dispose();
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
      _validateJson(controller.text);
    }
    if ((oldWidget.fieldKey != widget.fieldKey) ||
        (oldWidget.isDark != widget.isDark)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
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
                  errorContainerDecoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.08),
                    borderRadius: kBorderRadius8,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error,
                      width: 1.5,
                    ),
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
                  onChanged: (value) {
                    _validateJson(value);
                    widget.onChanged?.call(value);
                  },
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
                        color: _isValidJson
                            ? Theme.of(context).colorScheme.outlineVariant
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: kBorderRadius8,
                      borderSide: BorderSide(
                        color: _isValidJson
                            ? Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                            : Theme.of(context)
                                .colorScheme
                                .error
                                .withValues(alpha: 0.5),
                      ),
                    ),
                    filled: true,
                    hoverColor: kColorTransparent,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerLowest,
                  ),
                ),
              ),
              // Format JSON button (top right)
              if (!widget.readOnly)
                Align(
                  alignment: Alignment.topRight,
                  child: ADIconButton(
                    icon: Icons.format_align_left,
                    tooltip: "Format JSON",
                    onPressed: () {
                      controller.formatJson(sortJson: false);
                      _validateJson(controller.text);
                      widget.onChanged?.call(controller.text);
                    },
                  ),
                ),
            ],
          ),
        ),
        // JSON validation status bar (bottom)
        if (!widget.readOnly)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _isValidJson ? 0 : 28,
            child: _isValidJson
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 14,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _jsonError ?? "Invalid JSON",
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
      ],
    );
  }
}
