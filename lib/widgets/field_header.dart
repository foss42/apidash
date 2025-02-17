import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/widgets/widgets.dart';

class HeaderField extends StatefulWidget {
  const HeaderField({
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
  State<HeaderField> createState() => _HeaderFieldState();
}

class _HeaderFieldState extends State<HeaderField> {
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

class HeaderSuggestions extends StatefulWidget {
  const HeaderSuggestions({
    super.key,
    required this.suggestionsCallback,
    required this.query,
    required this.onSuggestionTap,
  });
  final Future<List<String>?> Function(String) suggestionsCallback;
  final String query;
  final ValueSetter<String> onSuggestionTap;

  @override
  State<HeaderSuggestions> createState() => _HeaderSuggestionsState();
}

class _HeaderSuggestionsState extends State<HeaderSuggestions> {
  List<String>? suggestions;

  @override
  void initState() {
    super.initState();
    widget.suggestionsCallback(widget.query).then((value) {
      if (mounted) {
        setState(() {
          suggestions = value;
        });
      }
    });
  }

  @override
  void didUpdateWidget(HeaderSuggestions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      widget.suggestionsCallback(widget.query).then((value) {
        if (mounted) {
          setState(() {
            suggestions = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (suggestions == null) {
      return const SizedBox.shrink();
    }
    return suggestions!.isEmpty
        ? const SizedBox.shrink()
        : SuggestionsMenuBox(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions!.length,
              separatorBuilder: (context, index) => const Divider(height: 2),
              itemBuilder: (context, index) {
                final suggestion = suggestions![index];
                return ListTile(
                  dense: true,
                  title: Text(suggestion),
                  onTap: () => widget.onSuggestionTap(suggestion),
                );
              },
            ),
          );
  }
}
