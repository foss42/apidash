import 'dart:math' as math;
import 'package:apidash/screens/common_widgets/env_regexp_span_builder.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_field_editor/json_field_editor.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:apidash/consts.dart';

class EnvJsonTextFieldEditor extends StatefulWidget {
  const EnvJsonTextFieldEditor({
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
  State<EnvJsonTextFieldEditor> createState() => _EnvJsonTextFieldEditorState();
}

class _EnvJsonTextFieldEditorState extends State<EnvJsonTextFieldEditor> {
  late TextEditingController controller;
  late final FocusNode editorFocusNode;
  late final JsonTextFieldController jsonController;
  bool _useEnvMode = false;

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

  String? _tryFormatJson() {
    try {
      final tempController = JsonTextFieldController();
      tempController.text = controller.text;
      tempController.formatJson(sortJson: false);
      return tempController.text;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue ?? '');
    jsonController = JsonTextFieldController();
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");

    if (widget.initialValue?.contains('{{') ?? false) {
      _useEnvMode = true;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    jsonController.dispose();
    editorFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvJsonTextFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != controller.text) {
      controller.text = widget.initialValue ?? "";
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
    if (!_useEnvMode) {
      jsonController.text = controller.text;
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
        // FIX 1: Use Positioned.fill to constrain the editors strictly within the Stack
        if (_useEnvMode)
          Positioned.fill(child: _buildEnvEnabledEditor(context))
        else
          Positioned.fill(
            child: CallbackShortcuts(
              bindings: <ShortcutActivator, VoidCallback>{
                const SingleActivator(LogicalKeyboardKey.tab): () {
                  insertTab();
                },
              },
              child: _buildStandardJsonEditor(context),
            ),
          ),
        
        // Buttons stay on top
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ADIconButton(
                icon: _useEnvMode ? Icons.code : Icons.integration_instructions,
                tooltip: _useEnvMode
                    ? "Switch to JSON Format Mode"
                    : "Enable Environment Variables",
                onPressed: () {
                  setState(() {
                    _useEnvMode = !_useEnvMode;
                  });
                },
              ),
              const SizedBox(width: 4),
              ADIconButton(
                icon: Icons.format_align_left,
                tooltip: "Format JSON",
                onPressed: () {
                  final formatted = _tryFormatJson();
                  if (formatted != null) {
                    controller.text = formatted;
                    jsonController.text = formatted;
                    widget.onChanged?.call(controller.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid JSON format'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStandardJsonEditor(BuildContext context) {
    if (jsonController.text != controller.text) {
      jsonController.text = controller.text;
    }

    return JsonField(
      key: ValueKey("${widget.fieldKey}-json-fld"),
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
      controller: jsonController,
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
        controller.text = value;
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
    );
  }

  Widget _buildEnvEnabledEditor(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.tab): () {
          insertTab();
        },
      },
      child: ExtendedTextField(
        controller: controller,
        focusNode: editorFocusNode,
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        readOnly: widget.readOnly,
        // FIX 2: Force the painter to clip content that overflows bounds
        clipBehavior: Clip.hardEdge, 
        style: kCodeStyle.copyWith(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
        ),
        textAlignVertical: TextAlignVertical.top,
        specialTextSpanBuilder: EnvRegExpSpanBuilder(),
        onChanged: (value) {
          if (value.contains("{{") && !_useEnvMode) {
            setState(() => _useEnvMode = true);
          }
          widget.onChanged?.call(value);
        },
        onTapOutside: (event) {
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