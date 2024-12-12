import 'package:apidash_design_system/widgets/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing for Checkbox', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Checkbox Widget',
        home: Scaffold(
          body: ADCheckBox(
            keyId: "1",
            value: false,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      ),
    );

    expect(find.byKey(const Key("1")), findsOneWidget);
    var box = find.byKey(const Key("1"));
    await tester.tap(box);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, true);
  });
}
