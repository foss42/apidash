import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical,
    this.enableTabInsertion = false,
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
  final void Function(String)? onFieldSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final double? optionsWidthFactor;
  final AutocompleteNoTrigger? autocompleteNoTrigger;
  final TextInputType keyboardType;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final bool enableTabInsertion;
  final bool readOnly;
  final bool obscureText;

  @override
  State<EnvironmentTriggerField> createState() =>
      EnvironmentTriggerFieldState();
}

class EnvironmentTriggerFieldState extends State<EnvironmentTriggerField> {
  late TextEditingController controller;
  late FocusNode _focusNode;

  void _insertTab() {
    const space = "  ";
    final selection = controller.selection;
    final baseOffset = selection.baseOffset;
    final extentOffset = selection.extentOffset;
    final start = baseOffset < extentOffset ? baseOffset : extentOffset;
    final end = baseOffset > extentOffset ? baseOffset : extentOffset;
    if (start < 0 || end < 0) {
      return;
    }
    final text = controller.text;
    final newText = text.replaceRange(start, end, space);
    final newOffset = start + space.length;
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
    widget.onChanged?.call(newText);
  }

  @override
  void initState() {
    super.initState();
    final initialText = widget.initialValue ?? '';
    controller = widget.controller ??
        TextEditingController.fromValue(TextEditingValue(
            text: initialText,
            selection: TextSelection.collapsed(offset: initialText.length)));
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentTriggerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyId != widget.keyId) {
      controller = widget.controller ??
          TextEditingController.fromValue(TextEditingValue(
              text: widget.initialValue!,
              selection: TextSelection.collapsed(
                  offset: widget.initialValue!.length)));
    } else if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        controller.text != widget.initialValue) {
      // Update controller text only if it differs from current text
      // This preserves cursor position when typing
      final currentSelection = controller.selection;
      controller.text = widget.initialValue!;
      // Restore the selection if it's still valid
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
        final field = ExtendedTextField(
          controller: textEditingController,
          focusNode: focusnode,
          decoration: widget.decoration,
          style: widget.style,
          onChanged: widget.onChanged,
          onSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          expands: widget.expands,
          textAlignVertical: widget.textAlignVertical,
          specialTextSpanBuilder: EnvRegExpSpanBuilder(),
          onTapOutside: (event) {
            _focusNode.unfocus();
          },
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
        );

        if (!widget.enableTabInsertion) {
          return field;
        }

        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.tab): _insertTab,
          },
          child: field,
        );
      },
    );
  }
}
