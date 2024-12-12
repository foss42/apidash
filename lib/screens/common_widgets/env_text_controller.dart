import 'package:flutter/material.dart';

class VarTextEditingController extends TextEditingController {
  final TextStyle normalStyle;
  final TextStyle highlightStyle;

  VarTextEditingController({
    required this.normalStyle,
    required this.highlightStyle,
    super.text,
  });

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    bool withComposing = false,
  }) {
    // Pattern to match any text between {{ and }}
    final pattern = RegExp(r'(\{\{.*?\}\})');
    final children = <TextSpan>[];
    int start = 0;

    // Find matches and style them
    for (final match in pattern.allMatches(text)) {
      if (match.start > start) {
        children.add(TextSpan(
          text: text.substring(start, match.start),
          style: normalStyle,
        ));
      }
      children.add(TextSpan(
        text: match.group(0),
        style: highlightStyle,
      ));
      start = match.end;
    }

    // Add any remaining text after the last match
    if (start < text.length) {
      children.add(TextSpan(
        text: text.substring(start),
        style: normalStyle,
      ));
    }

    return TextSpan(style: style, children: children);
  }
}
