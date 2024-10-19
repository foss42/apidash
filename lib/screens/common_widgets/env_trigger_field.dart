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
    this.onChanged,
    this.onFieldSubmitted,
    this.style,
    this.decoration,
    this.optionsWidthFactor,
  });

  final String keyId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final double? optionsWidthFactor;

  @override
  State<EnvironmentTriggerField> createState() =>
      EnvironmentTriggerFieldState();
}

class EnvironmentTriggerFieldState extends State<EnvironmentTriggerField> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue ?? '';
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentTriggerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.keyId != widget.keyId) ||
        (oldWidget.initialValue != widget.initialValue)) {
      controller.text = widget.initialValue ?? "";
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiTriggerAutocomplete(
      key: Key(widget.keyId),
      textEditingController: controller,
      focusNode: focusNode,
      optionsWidthFactor: widget.optionsWidthFactor,
      autocompleteTriggers: [
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
            focusNode.unfocus();
          },
        );
      },
    );
  }
}
