import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class SuggestionsMenuBox extends StatelessWidget {
  const SuggestionsMenuBox({
    super.key,
    required this.child,
    this.width,
    this.maxHeight,
  });

  final Widget child;
  final double? width;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return ClipRRect(
      borderRadius: kBorderRadius8,
      child: Material(
        type: MaterialType.card,
        elevation: 8,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight ?? 200.0*ds.scaleFactor),
          child: Ink(
            width: width != null ? width!*ds.scaleFactor : 300.0*ds.scaleFactor,
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
