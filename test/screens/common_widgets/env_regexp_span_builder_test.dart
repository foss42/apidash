import 'package:apidash/screens/common_widgets/env_regexp_span_builder.dart';
import 'package:apidash/screens/common_widgets/envvar_span.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/widgets.dart';

void main() {
  test('Testing RegExpSpanBuilder returns correct ExtendedWidgetSpan', () {
    final regExpEnvText = RegExpEnvText();
    final match = RegExp(r'\{\{.*?\}\}').firstMatch('{{variable}}')!;
    const start = 0;

    final span = regExpEnvText.finishText(start, match);

    expect(span, isA<ExtendedWidgetSpan>());
    final extendedWidgetSpan = span as ExtendedWidgetSpan;
    expect(extendedWidgetSpan.actualText, '{{variable}}');
    expect(extendedWidgetSpan.start, start);
    expect(extendedWidgetSpan.alignment, PlaceholderAlignment.middle);
    expect(extendedWidgetSpan.child, isA<EnvVarSpan>());

    final envVarSpan = extendedWidgetSpan.child as EnvVarSpan;
    expect(envVarSpan.variableKey, 'variable');
  });
}
