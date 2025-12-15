import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'env_regexp_span_builder.dart';
import 'env_trigger_options.dart';

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
  final Future<String?> Function(String)? onCurlDetected;

  @override
  State<EnvironmentTriggerField> createState() =>
      EnvironmentTriggerFieldState();
}

class EnvironmentTriggerFieldState extends State<EnvironmentTriggerField> {
  late TextEditingController controller;
  late FocusNode _focusNode;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    final initialText = widget.initialValue ?? '';
    controller = widget.controller ??
        TextEditingController.fromValue(TextEditingValue(
            text: initialText,
            selection:
                TextSelection.collapsed(offset: initialText.length)));
    _previousText = initialText;
    _focusNode = widget.focusNode ?? FocusNode();
    controller.addListener(_onTextChanged);
  }

  void _onTextChanged() async {
    final currentText = controller.text;
    final trimmedCurrent = currentText.trim();
    final lengthDiff = currentText.length - _previousText.length;
    if (trimmedCurrent.toLowerCase().startsWith('curl ') && 
        trimmedCurrent.length > 20 &&
        lengthDiff > 15) { 
      final replacementUrl = await widget.onCurlDetected?.call(currentText);
      if (replacementUrl != null && mounted) {
        controller.value = TextEditingValue(
          text: replacementUrl,
          selection: TextSelection.collapsed(offset: replacementUrl.length),
        );
        widget.onChanged?.call(replacementUrl);
        _previousText = replacementUrl;
        return;
      }
    }
    _previousText = currentText;
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentTriggerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.keyId != widget.keyId) ||
        (oldWidget.initialValue != widget.initialValue)) {
      controller.removeListener(_onTextChanged);
      final initialText = widget.initialValue ?? '';
      controller = widget.controller ??
          TextEditingController.fromValue(TextEditingValue(
              text: initialText,
              selection: TextSelection.collapsed(
                  offset: initialText.length)));
      _previousText = initialText;
      controller.addListener(_onTextChanged);
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
                  });
            }),
        AutocompleteTrigger(
            trigger: '{{',
            triggerEnd: "}}",
            triggerOnlyAfterSpace: false,
            optionsViewBuilder: (context, autocompleteQuery, controller) {
              return EnvironmentTriggerOptions(
                  query: autocompleteQuery.query,
                  onSuggestionTap: (suggestion) {
                    final autocomplete = MultiTriggerAutocomplete.of(context);
                    autocomplete.acceptAutocompleteOption(
                      suggestion.variable.key,
                    );
                    widget.onChanged?.call(controller.text);
                  });
            }),
      ],
      fieldViewBuilder: (context, textEditingController, focusnode) {
        return ExtendedTextField(
          controller: textEditingController,
          focusNode: focusnode,
          decoration: widget.decoration,
          style: widget.style,
          onChanged: widget.onChanged,
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
