import 'dart:math' as math;
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_text_field/json_text_field.dart';
import 'dart:convert';
import 'dart:async';

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
  bool isValidJson = true; // To keep track of JSON validity
  String errorMessage = ''; // To store error message
  Timer? _debounce; // Timer for debouncing validation
  final String validJsonMessage =
      "Valid JSON"; // Success message when JSON is valid

  // Method to check if JSON is valid
  bool isJsonValid(String input) {
    try {
      jsonDecode(input); // Try decoding the JSON string
      return true;
    } catch (e) {
      errorMessage = e.toString(); // Capture error message
      return false;
    }
  }

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
    _debounce?.cancel();
    editorFocusNode.dispose();
    super.dispose();
  }

  void handleInputChange(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = null;

    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        isValidJson =
            isJsonValid(value); // Validate JSON after the debounce time
      });
      widget.onChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CallbackShortcuts(
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
            isFormatting: true,
            key: Key(widget.fieldKey),
            controller: controller,
            focusNode: editorFocusNode,
            keyboardType: TextInputType.multiline,
            expands: true,
            maxLines: null,
            style: kCodeStyle,
            textAlignVertical: TextAlignVertical.top,
            onChanged: handleInputChange,
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
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
        if (!isValidJson)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: kBorderRadius8,
              ),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
