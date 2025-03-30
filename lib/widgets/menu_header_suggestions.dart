import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';

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
