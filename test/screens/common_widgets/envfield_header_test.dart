import 'package:apidash/screens/common_widgets/envfield_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:spot/spot.dart';

void main() {
  group('HeaderField Widget Tests', () {
    testWidgets('HeaderField renders and displays ExtendedTextField',
        (tester) async {
      await tester.pumpWidget(
        const Portal(
          child: MaterialApp(
            home: Scaffold(
              body: EnvHeaderField(
                keyId: "testKey",
                hintText: "Enter header",
              ),
            ),
          ),
        ),
      );

      spot<EnvHeaderField>().spot<ExtendedTextField>().existsOnce();
    });

    testWidgets('HeaderField calls onChanged when text changes',
        (tester) async {
      String? changedText;
      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: EnvHeaderField(
                keyId: "testKey",
                hintText: "Enter header",
                onChanged: (text) => changedText = text,
              ),
            ),
          ),
        ),
      );

      await act.tap(spot<EnvHeaderField>().spot<ExtendedTextField>());
      tester.testTextInput.enterText("new header");
      expect(changedText, "new header");
    });
  });
}
