import 'package:flutter/material.dart';

class ExpandableSection extends StatefulWidget {
  const ExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
    this.forceOpen,
    this.highlightQuery,
  });

  final String title;
  final Widget child;
  final bool initiallyOpen;
  final bool? forceOpen;
  final String? highlightQuery;

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  late bool _open = widget.initiallyOpen;

  @override
  void didUpdateWidget(covariant ExpandableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If forceOpen toggles from null to a value or changes, reflect it
    if (widget.forceOpen != null && widget.forceOpen != oldWidget.forceOpen) {
      _open = widget.forceOpen!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          enableFeedback: false,
          borderRadius: BorderRadius.circular(3),
          onTap: () {
            if (widget.forceOpen == null) {
              setState(() => _open = !_open);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(child: _buildTitle(context)),
                Icon(
                  (widget.forceOpen ?? _open)
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        if (widget.forceOpen ?? _open)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: widget.child,
          ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    final q = widget.highlightQuery?.trim();
    final style = Theme.of(context).textTheme.titleSmall;
    if (q == null || q.isEmpty) {
      return Text(widget.title, style: style);
    }
    final lower = widget.title.toLowerCase();
    final lowerQ = q.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    int idx;
    final hlStyle = style?.copyWith(
      background: Paint()
        ..color = Theme.of(context)
            .colorScheme
            .tertiaryContainer
            .withValues(alpha: 0.8),
      fontWeight: FontWeight.w600,
    );
    while ((idx = lower.indexOf(lowerQ, start)) != -1) {
      if (idx > start)
        spans.add(
            TextSpan(text: widget.title.substring(start, idx), style: style));
      spans.add(TextSpan(
          text: widget.title.substring(idx, idx + lowerQ.length),
          style: hlStyle));
      start = idx + lowerQ.length;
    }
    if (start < widget.title.length) {
      spans.add(TextSpan(text: widget.title.substring(start), style: style));
    }
    return RichText(text: TextSpan(children: spans, style: style));
  }
}
