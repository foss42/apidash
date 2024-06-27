import 'package:flutter/material.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:apidash/consts.dart';

class SuggestionsMenu extends StatelessWidget {
  const SuggestionsMenu({
    super.key,
    required this.mentionController,
    required this.suggestions,
    required this.suggestionBuilder,
    this.menuWidth = kSuggestionsMenuWidth,
    this.menuMaxHeight = kSuggestionsMenuMaxHeight,
  });

  final MentionTagTextEditingController mentionController;
  final List? suggestions;
  final double menuWidth;
  final double menuMaxHeight;
  final Widget? Function(BuildContext, int) suggestionBuilder;

  @override
  Widget build(BuildContext context) {
    return suggestions == null || suggestions!.isEmpty
        ? const SizedBox.shrink()
        : ClipRRect(
            borderRadius: kBorderRadius8,
            child: Material(
              type: MaterialType.card,
              elevation: 8,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: menuMaxHeight),
                child: Ink(
                  width: menuWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: kBorderRadius8,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: suggestions?.length ?? 0,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 2),
                    itemBuilder: suggestionBuilder,
                  ),
                ),
              ),
            ),
          );
  }
}
