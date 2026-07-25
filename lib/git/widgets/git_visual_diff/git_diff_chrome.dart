import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class GitDiffField extends StatelessWidget {
  const GitDiffField({
    super.key,
    required this.label,
    required this.child,
    this.change,
  });

  final String label;
  final Widget child;
  final GitDiffChangeKind? change;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          GitDiffHighlightBox(change: change, child: child),
        ],
      ),
    );
  }
}

/// Key / value pair with a clear separator between columns.
class GitDiffKvRow extends StatelessWidget {
  const GitDiffKvRow({
    super.key,
    required this.keyText,
    required this.value,
    this.change,
    this.footer,
  });

  final String keyText;
  final Widget value;
  final GitDiffChangeKind? change;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GitDiffHighlightBox(
      change: change,
      margin: const EdgeInsets.only(bottom: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                keyText,
                style: kCodeStyle.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: VerticalDivider(
                width: 1,
                thickness: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.55),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  value,
                  ?footer,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GitDiffHighlightBox extends StatelessWidget {
  const GitDiffHighlightBox({
    super.key,
    required this.child,
    this.change,
    this.margin = EdgeInsets.zero,
    this.minHeight,
  });

  final Widget child;
  final GitDiffChangeKind? change;
  final EdgeInsetsGeometry margin;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    if (change == null) {
      return Padding(
        padding: margin,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight ?? 0),
          child: child,
        ),
      );
    }

    final highlight =
        getGitDiffHighlight(Theme.of(context).brightness, change!);
    return Container(
      margin: margin,
      constraints:
          minHeight == null ? null : BoxConstraints(minHeight: minHeight!),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: highlight.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: highlight.foreground.withValues(alpha: 0.2)),
      ),
      child: child,
    );
  }
}
