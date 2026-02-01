import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:apidash/consts.dart';
import 'env_trigger_field.dart';
import 'url_suggestions.dart';

class EnvURLField extends StatefulWidget {
  const EnvURLField({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.onMethodChanged,
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onMethodChanged;
  final FocusNode? focusNode;

  @override
  State<EnvURLField> createState() => _EnvURLFieldState();
}

class _EnvURLFieldState extends State<EnvURLField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant EnvURLField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        _controller.text != widget.initialValue) {
      final currentSelection = _controller.selection;
      _controller.text = widget.initialValue!;
      if (currentSelection.baseOffset <= _controller.text.length) {
        _controller.selection = currentSelection;
      }
    }
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {
      // do nothing
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnvironmentTriggerField(
      keyId: "url-${widget.selectedId}",
      controller: _controller,
      focusNode: widget.focusNode,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        border: InputBorder.none,
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      optionsWidthFactor: 1,
      autocompleteNoTrigger: AutocompleteNoTrigger(
        minimumRequiredCharacters: 0,
        optionsViewBuilder: (context, autocompleteQuery, controller) {
          return URLSuggestions(
            query: autocompleteQuery.query,
            onSuggestionTap: (url, method) {
              final autocomplete = MultiTriggerAutocomplete.of(context);
              autocomplete.replaceFieldWithAutocompleteOption(
                url,
                onOptionSelected: widget.onChanged,
              );
              // Notify parent about method change
              widget.onMethodChanged?.call(method);
            },
          );
        },
      ),
    );
  }
}
