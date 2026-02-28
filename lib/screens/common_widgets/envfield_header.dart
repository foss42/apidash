import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:apidash/utils/utils.dart';
import 'envfield_cell.dart';

class EnvHeaderField extends StatefulWidget {
  const EnvHeaderField({
    super.key,
    required this.keyId,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.colorScheme,
  });
  final String keyId;
  final String? hintText;
  final String? initialValue;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  State<EnvHeaderField> createState() => _EnvHeaderFieldState();
}

class _EnvHeaderFieldState extends State<EnvHeaderField> {
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return EnvCellField(
      keyId: widget.keyId,
      hintText: widget.hintText,
      initialValue: widget.initialValue ?? "",
      focusNode: focusNode,
      onChanged: widget.onChanged,
      colorScheme: colorScheme,
      autocompleteNoTrigger: AutocompleteNoTrigger(
          optionsViewBuilder: (context, autocompleteQuery, controller) {
        return HeaderSuggestions(
            suggestionsCallback: headerSuggestionCallback,
            query: autocompleteQuery.query,
            onSuggestionTap: (suggestion) {
              controller.text = suggestion;
              widget.onChanged?.call(controller.text);
              focusNode.unfocus();
            });
      }),
    );
  }

  Future<List<String>?> headerSuggestionCallback(String pattern) async {
    if (pattern.isEmpty) {
      return null;
    }
    return getHeaderSuggestions(pattern)
        .where(
            (suggestion) => suggestion.toLowerCase() != pattern.toLowerCase())
        .toList();
  }
}
