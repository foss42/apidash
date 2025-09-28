import 'package:flutter/material.dart';

/// Widget to highlight occurrences of [query] inside [text].
/// Case-insensitive; all matches highlighted.
class HighlightedSelectableText extends StatelessWidget {
  const HighlightedSelectableText({
    super.key,
    required this.text,
    this.query,
    this.style,
  });
  final String text;
  final String? query;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final q = query?.trim();
    if (q == null || q.isEmpty) {
      return SelectableText(text, style: style);
    }
    final lower = text.toLowerCase();
    final lowerQ = q.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    int idx;
    final base = style ?? DefaultTextStyle.of(context).style;
    final bgColor = Theme.of(context).colorScheme.secondaryContainer;
    final highlightStyle = base.copyWith(
      fontWeight: FontWeight.w600,
      background: Paint()
        ..color = bgColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill,
      color: base.color,
    );
    while ((idx = lower.indexOf(lowerQ, start)) != -1) {
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx), style: base));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + lowerQ.length),
        style: highlightStyle,
      ));
      start = idx + lowerQ.length;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: base));
    }
    return SelectableText.rich(TextSpan(children: spans));
  }
}

/// Helper to produce highlighted spans for inline RichText content.
List<InlineSpan> buildHighlightedSpans(
  String text,
  BuildContext context,
  String? query, {
  TextStyle? baseStyle,
}) {
  final q = query?.trim();
  if (q == null || q.isEmpty) {
    return [TextSpan(text: text, style: baseStyle)];
  }
  final lower = text.toLowerCase();
  final lowerQ = q.toLowerCase();
  final spans = <InlineSpan>[];
  int start = 0;
  int idx;
  final base = baseStyle ?? DefaultTextStyle.of(context).style;
  final highlightStyle = base.copyWith(
    fontWeight: FontWeight.w600,
    background: Paint()
      ..color = Theme.of(context)
          .colorScheme
          .secondaryContainer
          .withValues(alpha: 0.85)
      ..style = PaintingStyle.fill,
  );
  while ((idx = lower.indexOf(lowerQ, start)) != -1) {
    if (idx > start) {
      spans.add(TextSpan(text: text.substring(start, idx), style: base));
    }
    spans.add(TextSpan(
      text: text.substring(idx, idx + lowerQ.length),
      style: highlightStyle,
    ));
    start = idx + lowerQ.length;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: base));
  }
  return spans;
}
