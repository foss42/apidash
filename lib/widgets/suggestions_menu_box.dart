import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class SuggestionsMenuBox extends StatelessWidget {
  final Widget child;
  const SuggestionsMenuBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: kBorderRadius8,
      child: Material(
        type: MaterialType.card,
        elevation: 8,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxHeight: kSuggestionsMenuMaxHeight),
          child: Ink(
            width: kSuggestionsMenuWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: kBorderRadius8,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
