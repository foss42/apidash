import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:json_field_editor/src/json_highlight/highlight_strategy.dart';

class JsonHighlight extends SpecialTextSpanBuilder {
  final TextStyle? keyHighlightStyle;
  final TextStyle? stringHighlightStyle;
  final TextStyle? numberHighlightStyle;
  final TextStyle? boolHighlightStyle;
  final TextStyle? nullHighlightStyle;
  final TextStyle? specialCharHighlightStyle;
  final TextStyle? commonTextStyle;
  final bool isFormating;

  JsonHighlight({
    this.keyHighlightStyle,
    this.stringHighlightStyle,
    this.numberHighlightStyle,
    this.boolHighlightStyle,
    this.nullHighlightStyle,
    this.specialCharHighlightStyle,
    this.commonTextStyle,
    required this.isFormating,
  });

  @override
  TextSpan build(
    String data, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    List<HighlightStrategy> strategies = [
      KeyHighlightStrategy(textStyle: keyHighlightStyle),
      StringHighlightStrategy(textStyle: stringHighlightStyle),
      NumberHighlightStrategy(textStyle: numberHighlightStyle),
      BoolHighlightStrategy(textStyle: boolHighlightStyle),
      NullHighlightStrategy(textStyle: nullHighlightStyle),
      SpecialCharHighlightStrategy(textStyle: specialCharHighlightStyle),
    ];

    List<TextSpan> spans = [];

    data.splitMapJoin(
      RegExp(
        r'\".*?\"\s*:|\".*?\"|\s*\b(\d+(\.\d+)?)\b|\b(true|false|null)\b|[{}\[\],]',
      ),
      onMatch: (m) {
        String word = m.group(0)!;
        if (isFormating) {
          spans.add(
            strategies
                .firstWhere((element) => element.match(word))
                .textSpan(word),
          );

          return '';
        }
        spans.add(TextSpan(text: word, style: commonTextStyle));
        return '';
      },
      onNonMatch: (n) {
        spans.add(TextSpan(text: n, style: commonTextStyle));
        return '';
      },
    );

    return TextSpan(children: spans);
  }

  @override
  SpecialText? createSpecialText(
    String flag, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
    required int index,
  }) {
    throw UnimplementedError();
  }
}
