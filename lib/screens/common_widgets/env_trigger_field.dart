import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'env_regexp_span_builder.dart';
import 'env_trigger_options.dart';

const int kCurlPasteMinLength = 20;
const int kCurlPasteMinDelta = 15;
class EnvironmentTriggerField extends StatefulWidget {
  const EnvironmentTriggerField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.style,
    this.decoration,
    this.optionsWidthFactor,
    this.autocompleteNoTrigger,
    this.readOnly = false,
    this.obscureText = false,
    this.onCurlDetected,
  }) : assert(
         !(controller != null && initialValue != null),
         'controller and initialValue cannot be simultaneously defined.',
       );

  final String keyId;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final double? optionsWidthFactor;
  final AutocompleteNoTrigger? autocompleteNoTrigger;
  final bool readOnly;
  final bool obscureText;

  final Future<String?> Function(String curlText)? onCurlDetected;

  @override
  State<EnvironmentTriggerField> createState() =>
      EnvironmentTriggerFieldState();
}

class EnvironmentTriggerFieldState extends State<EnvironmentTriggerField> {
  late TextEditingController controller;
  late FocusNode _focusNode;
  String _previousText = '';
  bool _applyingCurl = false;
  bool get _curlDetectionEnabled => widget.onCurlDetected != null;

  @override
  void initState() {
    super.initState();
    final initialText = widget.initialValue ?? '';
    controller =
        widget.controller ??
        TextEditingController.fromValue(
          TextEditingValue(
            text: initialText,
            selection: TextSelection.collapsed(offset: initialText.length),
          ),
        );
    _previousText = initialText;
    _focusNode = widget.focusNode ?? FocusNode();
    if (_curlDetectionEnabled) {
      controller.addListener(_onTextChanged);
    }
  }

  bool _looksLikeCurlPaste(String text) {
    final trimmed = text.trim();
    if (!trimmed.startsWith('curl ') ||
        trimmed.length < kCurlPasteMinLength) {
      return false;
    }
    final lengthDiff = text.length - _previousText.length;
    final previousTrimmed = _previousText.trim();
    final becameCurl =
        !previousTrimmed.startsWith('curl ') && trimmed.startsWith('curl ');
    return lengthDiff >= kCurlPasteMinDelta || becameCurl;
  }

  void _onTextChanged() async {
    if (!_curlDetectionEnabled || _applyingCurl) {
      _previousText = controller.text;
      return;
    }

    final currentText = controller.text;
    if (!_looksLikeCurlPaste(currentText)) {
      _previousText = currentText;
      return;
    }

    final replacementUrl = await widget.onCurlDetected!(currentText);
    if (!mounted) return;

    _applyingCurl = true;
    final nextText = replacementUrl ?? _previousText;
    controller.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );
    _previousText = nextText;
    _applyingCurl = false;
  }

  @override
  void dispose() {
    if (_curlDetectionEnabled) {
      controller.removeListener(_onTextChanged);
    }
    if (widget.controller == null) controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentTriggerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyId != widget.keyId) {
      if (_curlDetectionEnabled) {
        controller.removeListener(_onTextChanged);
      }
      controller =
          widget.controller ??
          TextEditingController.fromValue(
            TextEditingValue(
              text: widget.initialValue!,
              selection: TextSelection.collapsed(
                offset: widget.initialValue!.length,
              ),
            ),
          );
      _previousText = widget.initialValue ?? '';
      if (_curlDetectionEnabled) {
        controller.addListener(_onTextChanged);
      }
    } else if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        controller.text != widget.initialValue) {
      final currentSelection = controller.selection;
      controller.text = widget.initialValue!;
      _previousText = widget.initialValue!;
      if (currentSelection.baseOffset <= controller.text.length) {
        controller.selection = currentSelection;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiTriggerAutocomplete(
      key: Key(widget.keyId),
      textEditingController: controller,
      focusNode: _focusNode,
      optionsWidthFactor: widget.optionsWidthFactor ?? 1,
      autocompleteTriggers: [
        if (widget.autocompleteNoTrigger != null) widget.autocompleteNoTrigger!,
        AutocompleteTrigger(
          trigger: '{',
          triggerEnd: "}}",
          triggerOnlyAfterSpace: false,
          optionsViewBuilder: (context, autocompleteQuery, controller) {
            return EnvironmentTriggerOptions(
              query: autocompleteQuery.query,
              onSuggestionTap: (suggestion) {
                final autocomplete = MultiTriggerAutocomplete.of(context);
                autocomplete.acceptAutocompleteOption(
                  '{${suggestion.variable.key}',
                );
                widget.onChanged?.call(controller.text);
              },
            );
          },
        ),
        AutocompleteTrigger(
          trigger: '{{',
          triggerEnd: "}}",
          triggerOnlyAfterSpace: false,
          optionsViewBuilder: (context, autocompleteQuery, controller) {
            return EnvironmentTriggerOptions(
              query: autocompleteQuery.query,
              onSuggestionTap: (suggestion) {
                final autocomplete = MultiTriggerAutocomplete.of(context);
                autocomplete.acceptAutocompleteOption(suggestion.variable.key);
                widget.onChanged?.call(controller.text);
              },
            );
          },
        ),
      ],
      fieldViewBuilder: (context, textEditingController, focusnode) {
        return ExtendedTextField(
          controller: textEditingController,
          focusNode: focusnode,
          decoration: widget.decoration,
          style: widget.style,
          onChanged: (value) {
            if (_curlDetectionEnabled && _looksLikeCurlPaste(value)) {
              return;
            }
            widget.onChanged?.call(value);
          },
          onSubmitted: widget.onFieldSubmitted,
          specialTextSpanBuilder: EnvRegExpSpanBuilder(),
          onTapOutside: (event) {
            _focusNode.unfocus();
          },
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
        );
      },
    );
  }
}
