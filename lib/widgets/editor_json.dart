import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/json.dart';
import 'package:apidash/consts.dart';
import 'dart:convert' as convert;

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
  late final FocusNode editorFocusNode;
  late bool _focused = false;
  CodeController? _codeController;
  late String? _jsonError;

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

    // iniialize errors
    if (_codeController!.text.isEmpty) {
      _jsonError = null;
    } else {
      _jsonError = getJsonParsingError(_codeController!.text);
    }
  }

  @override
  void dispose() {
    editorFocusNode.dispose();
    _codeController?.dispose();
    super.dispose();
  }

  void _setJsonError(String? error) => setState(() => _jsonError = error);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: CodeTheme(
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
            onChanged: (value) {
              widget.onChanged?.call(value);
              validateJson(value);
            },
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
              borderRadius: _jsonError == null
                  ? kBorderRadius8
                  : const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
            ),
          ),
        )),
        _jsonError == null
            ? const SizedBox.shrink()
            : Container(
                padding: kP8,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Center(
                  child: Text(
                    _jsonError ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        Padding(
          padding: kP8,
          child: ElevatedButton(
            onPressed: _jsonError != null
                ? null
                : () {
                    if (_codeController!.text.isNotEmpty) {
                      formatJson();
                    }
                  },
            child: const Text(
              'Format JSON',
              style: kTextStyleButton,
            ),
          ),
        ),
      ],
    );
  }

  bool isValidJson(String jsonString) {
    if (jsonString.isEmpty) return false;
    try {
      convert.json.decode(jsonString);
      return true;
    } catch (_) {
      return false;
    }
  }

  String? getJsonParsingError(String? jsonString) {
    if (jsonString == null) return null;

    try {
      convert.json.decode(jsonString);
      return null;
    } on FormatException catch (e) {
      return e.toString().replaceAll("FormatException: ", "");
    }
  }

  void validateJson(String jsonString) {
    if (jsonString.isEmpty) {
      _setJsonError(null);
      return;
    }
    if (isValidJson(jsonString)) {
      _setJsonError(null);
      return;
    }
    _setJsonError(getJsonParsingError(jsonString));
  }

  void formatJson() {
    if (!isValidJson(_codeController!.text)) return;
    final oldText = _codeController!.text;
    var jsonObject = convert.json.decode(oldText);
    _codeController!.text = kEncoder.convert(jsonObject);
  }
}
