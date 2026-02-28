import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_field_editor/src/error_message_container.dart';

void main() {
  testWidgets('ErrorMessageContainer shows correct error message', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ErrorMessageContainer(
            jsonError: 'Test error message',
            errorTextStyle: TextStyle(),
          ),
        ),
      ),
    );

    // Verify that our widget shows the correct error message.
    expect(find.text('Test error message'), findsOneWidget);
  });

  testWidgets(
    'ErrorMessageContainer does not show error message when jsonError is null',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorMessageContainer(
              jsonError: null,
              errorTextStyle: TextStyle(),
            ),
          ),
        ),
      );

      // Verify that our widget does not show an error message.
      expect(find.byType(Text), findsNothing);
    },
  );
}
