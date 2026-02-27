import 'package:apidash/consts.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

import 'envvar_span.dart';

class JsonEnvHighlight extends SpecialTextSpanBuilder {
  JsonEnvHighlight({
    this.keyHighlightStyle,
    this.stringHighlightStyle,
    this.numberHighlightStyle,
    this.boolHighlightStyle,
    this.nullHighlightStyle,
    this.specialCharHighlightStyle,
    this.commonTextStyle,
    required this.isFormatting,
  });

  final TextStyle? keyHighlightStyle;
  final TextStyle? stringHighlightStyle;
  final TextStyle? numberHighlightStyle;
  final TextStyle? boolHighlightStyle;
  final TextStyle? nullHighlightStyle;
  final TextStyle? specialCharHighlightStyle;
  final TextStyle? commonTextStyle;
  final bool isFormatting;

  @override
  TextSpan build(
    String data, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    final spans = <InlineSpan>[];
    int offset = 0;

    data.splitMapJoin(
      RegExp(
        r'\".*?\"\s*:|\".*?\"|\s*\b(\d+(\.\d+)?)\b|\b(true|false|null)\b|[{}\[\],]',
      ),
      onMatch: (m) {
        final word = m.group(0)!;
        if (isFormatting) {
          final style = _styleForToken(word);
          spans.addAll(_buildWithEnv(word, style, offset));
        } else {
          spans.addAll(_buildWithEnv(word, commonTextStyle, offset));
        }
        offset += word.length;
        return '';
      },
      onNonMatch: (n) {
        spans.addAll(_buildWithEnv(n, commonTextStyle, offset));
        offset += n.length;
        return '';
      },
    );

    return TextSpan(children: spans);
  }

  TextStyle? _styleForToken(String token) {
    if (RegExp(r'\".*?\"\s*:').hasMatch(token)) {
      return keyHighlightStyle;
    }
    if (RegExp(r'\".*?\"').hasMatch(token)) {
      return stringHighlightStyle;
    }
    if (RegExp(r'\s*\b(\d+(\.\d+)?)\b').hasMatch(token)) {
      return numberHighlightStyle;
    }
    if (RegExp(r'\b(true|false)\b').hasMatch(token)) {
      return boolHighlightStyle;
    }
    if (RegExp(r'\bnull\b').hasMatch(token)) {
      return nullHighlightStyle;
    }
    if (RegExp(r'[{}\[\],:]').hasMatch(token)) {
      return specialCharHighlightStyle;
    }
    return commonTextStyle;
  }

  List<InlineSpan> _buildWithEnv(String text, TextStyle? style, int baseOffset) {
    if (text.isEmpty) {
      return const [];
    }

    final spans = <InlineSpan>[];
    int last = 0;
    for (final match in kEnvVarRegEx.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start), style: style));
      }

      final token = match.group(0)!;
      final key = token.substring(2, token.length - 2);
      spans.add(
        ExtendedWidgetSpan(
          actualText: token,
          start: baseOffset + match.start,
          alignment: PlaceholderAlignment.middle,
          child: EnvVarSpan(variableKey: key),
        ),
      );
      last = match.end;
    }

    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: style));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text, style: style));
    }

    return spans;
  }

  @override
  SpecialText? createSpecialText(
    String flag, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
    required int index,
  }) {
    return null;
  }
}
