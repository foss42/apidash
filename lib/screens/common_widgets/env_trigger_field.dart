import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
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

  @override
  State<EnvironmentTriggerField> createState() =>
      _EnvironmentTriggerFieldState();
}

class _EnvironmentTriggerFieldState extends State<EnvironmentTriggerField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController.fromValue(TextEditingValue(
            text: widget.initialValue!,
            selection:
                TextSelection.collapsed(offset: widget.initialValue!.length)));
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentTriggerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.keyId != widget.keyId) ||
        (oldWidget.initialValue != widget.initialValue)) {
      _controller = widget.controller ??
          TextEditingController.fromValue(TextEditingValue(
              text: widget.initialValue!,
              selection: TextSelection.collapsed(
                  offset: widget.initialValue!.length)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiTriggerAutocomplete(
      key: Key(widget.keyId),
      textEditingController: _controller,
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
        );
      },
    );
  }
}
