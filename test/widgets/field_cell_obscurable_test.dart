import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/field_cell_obscurable.dart';

void main() {
  testWidgets(
    'Testing ObscurableCellField toggles obscure text on icon button press',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ObscurableCellField(
              keyId: 'testKey',
              initialValue: 'password',
              hintText: 'Enter password',
            ),
          ),
        ),
      );

      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      Icon icon = tester.widget<Icon>(
          find.descendant(of: iconButton, matching: find.byType(Icon)));
      expect(icon.icon, Icons.visibility);

      await tester.tap(iconButton);
      await tester.pump();

      icon = tester.widget<Icon>(
          find.descendant(of: iconButton, matching: find.byType(Icon)));
      expect(icon.icon, Icons.visibility_off);
    },
  );

  testWidgets('ObscurableCellField calls onChanged when text is changed',
      (WidgetTester tester) async {
    String? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ObscurableCellField(
            keyId: 'testKey',
            initialValue: 'password',
            hintText: 'Enter password',
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      ),
    );

    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'newpassword');
    await tester.pump();

    expect(changedValue, 'newpassword');
  });
}
