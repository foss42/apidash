import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'env_regexp_span_builder.dart';
import 'env_trigger_options.dart';
import 'package:apidash_design_system/apidash_design_system.dart';

class EnvironmentTriggerField extends StatefulWidget {
  const EnvironmentTriggerField({
    super.key,
    required this.keyId,
    this.hintText,
    this.initialValue,
    this.decoration,
    this.onChanged,
    this.onFieldSubmitted,
    this.style,
    this.optionsWidthFactor,
    this.isEditor = false, // Determines Field or Editor Mode
  });

  final String keyId;
  final String? hintText;
  final String? initialValue;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? style;
  final double? optionsWidthFactor;
  final bool isEditor;

  @override
  State<EnvironmentTriggerField> createState() => _EnvironmentTriggerFieldState();
}

class _EnvironmentTriggerFieldState extends State<EnvironmentTriggerField> {
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
                      '{${suggestion.variable.key}}',
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
          // decoration: widget.isEditor
          //     ? InputDecoration(
          //   hintText: widget.hintText,
          //   border:OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: Theme.of(context).colorScheme.outlineVariant, // Use theme color
          //     ),
          //     borderRadius: kBorderRadius8,
          //   ),
          // )
          //     : InputDecoration(
          //   hintText: widget.hintText,
          //   hintStyle: kCodeStyle.copyWith(
          //     color: Theme.of(context).colorScheme.outline.withOpacity(
          //       kHintOpacity,
          //     ),
          //   ),
          //   border: InputBorder.none,
          // ),
          decoration: widget.decoration,
          style: widget.style,
          maxLines: widget.isEditor ? null : 1,
          expands: widget.isEditor,
          keyboardType:
          widget.isEditor ? TextInputType.multiline : TextInputType.text,
          textAlignVertical:
          widget.isEditor ? TextAlignVertical.top : null,
          textAlign:TextAlign.left,
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
