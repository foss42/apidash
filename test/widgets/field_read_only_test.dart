import 'package:apidash/widgets/field_read_only.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing ReadOnlyTextField displays initial value and decoration',
      (WidgetTester tester) async {
    const testInitialValue = 'Test Value';
    const testDecoration = InputDecoration(
      hintText: 'Test Hint',
      isDense: true,
      border: InputBorder.none,
      contentPadding: kPv8,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ReadOnlyTextField(
            initialValue: testInitialValue,
            decoration: testDecoration,
          ),
        ),
      ),
    );

    expect(find.text(testInitialValue), findsOneWidget);

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.decoration?.hintText, testDecoration.hintText);
    expect(textField.decoration?.isDense, testDecoration.isDense);
    expect(textField.decoration?.border, testDecoration.border);
    expect(textField.decoration?.contentPadding, testDecoration.contentPadding);
  });
}
