import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<ExtendedWidgetSpan> collectExtendedWidgetSpans(List<InlineSpan> spans) {
    final result = <ExtendedWidgetSpan>[];
    for (final span in spans) {
      if (span is ExtendedWidgetSpan) {
        result.add(span);
      } else if (span is TextSpan && span.children != null) {
        result.addAll(collectExtendedWidgetSpans(span.children!));
      }
    }
    return result;
  }

  test('JsonEnvHighlight renders env tokens as EnvVarSpan widgets', () {
    final highlight = JsonEnvHighlight(
      isFormatting: true,
      commonTextStyle: const TextStyle(),
      keyHighlightStyle: const TextStyle(),
      stringHighlightStyle: const TextStyle(),
      numberHighlightStyle: const TextStyle(),
      boolHighlightStyle: const TextStyle(),
      nullHighlightStyle: const TextStyle(),
      specialCharHighlightStyle: const TextStyle(),
    );

    final span = highlight.build('{"token":"{{API_KEY}}"}');
    final children = span.children ?? const <InlineSpan>[];
    final envSpans = collectExtendedWidgetSpans(children);

    expect(envSpans, isNotEmpty);
    final envSpan = envSpans.first;
    expect(envSpan.actualText, '{{API_KEY}}');
    expect(envSpan.child, isA<EnvVarSpan>());
  });
}
