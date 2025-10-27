import 'package:apidash/widgets/editor_json.dart';
import 'package:flutter/material.dart';
import 'package:json_field_editor/json_field_editor.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'env_trigger_options.dart';

class EnvironmentTriggerTextEditor extends StatefulWidget {
  const EnvironmentTriggerTextEditor({
    super.key,
    required this.keyId,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onTextSubmitted,
    this.style,
    this.decoration,
    this.optionsWidthFactor,
    this.autocompleteNoTrigger,
    this.readOnly = false,
    this.obscureText = false,
  }) : assert(
          !(controller != null && initialValue != null),
          'controller and initialValue cannot be simultaneously defined.',
        );

  final String keyId;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onTextSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final double? optionsWidthFactor;
  final AutocompleteNoTrigger? autocompleteNoTrigger;
  final bool readOnly;
  final bool obscureText;

  @override
  State<EnvironmentTriggerTextEditor> createState() =>
      EnvironmentTriggerTextEditorState();
}

class EnvironmentTriggerTextEditorState
    extends State<EnvironmentTriggerTextEditor> {
  late JsonTextFieldController controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    controller = JsonTextFieldController();
    _focusNode = widget.focusNode ??
        FocusNode(debugLabel: "env Trigger Editor Focus Node");
  }

  @override
  void dispose() {
    controller.dispose();
    // _focusNode.dispose(); // the Json TextFieldEditor will dispose this if created here
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentTriggerTextEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.keyId != widget.keyId) ||
        (oldWidget.initialValue != widget.initialValue)) {
      controller = JsonTextFieldController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiTriggerAutocomplete(
      key: Key(widget.keyId),
      textEditingController: controller,
      focusNode: _focusNode,
      optionsWidthFactor: widget.optionsWidthFactor ?? 1,
      optionsAlignment: OptionsAlignment.topStart,
      autocompleteTriggers: [
        if (widget.autocompleteNoTrigger != null) widget.autocompleteNoTrigger!,
        AutocompleteTrigger(
          trigger: '${controller.text}{',
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
          trigger: '${controller.text}{{',
          triggerEnd: "}}",
          triggerOnlyAfterSpace: true,
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
      ],
      fieldViewBuilder: (context, textEditingController, focusNode) {
        return JsonTextFieldEditor(
          key: Key("${widget.keyId}-json-body"),
          fieldKey: "${widget.keyId}-json-body-editor",
          isDark: Theme.of(context).brightness == Brightness.dark,
          initialValue: widget.initialValue,
          onChanged: (String value) {
            widget.onChanged?.call(value);
          },
          readOnly: widget.readOnly,
          jsonTextFieldController:
              textEditingController as JsonTextFieldController,
          focusNode: focusNode,
        );
      },
    );
  }
}
