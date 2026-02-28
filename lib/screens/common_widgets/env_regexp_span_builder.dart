import 'package:flutter/material.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:apidash/consts.dart';
import 'envvar_span.dart';

class EnvRegExpSpanBuilder extends RegExpSpecialTextSpanBuilder {
  @override
  List<RegExpSpecialText> get regExps => <RegExpSpecialText>[
        RegExpEnvText(),
      ];
}

class RegExpEnvText extends RegExpSpecialText {
  @override
  RegExp get regExp => kEnvVarRegEx;
  @override
  InlineSpan finishText(int start, Match match,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    final String value = '${match[0]}';
    return ExtendedWidgetSpan(
      actualText: value,
      start: start,
      alignment: PlaceholderAlignment.middle,
      child: EnvVarSpan(variableKey: value.substring(2, value.length - 2)),
    );
  }
}
