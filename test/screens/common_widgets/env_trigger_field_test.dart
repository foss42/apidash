import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';

void main() {
  testWidgets('Testing EnvironmentTriggerField updates the controller text',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'initial';
    const updatedValue = 'updated';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    Finder field = find.byType(ExtendedTextField);
    expect(field, findsOneWidget);
    expect(fieldKey.currentState!.controller.text, initialValue);

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: updatedValue,
            ),
          ),
        ),
      ),
    );

    expect(fieldKey.currentState!.controller.text, updatedValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField with empty initialValue clears the controller text',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'initial';
    const emptyValue = '';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    Finder field = find.byType(ExtendedTextField);
    expect(field, findsOneWidget);
    expect(fieldKey.currentState!.controller.text, initialValue);

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: emptyValue,
            ),
          ),
        ),
      ),
    );

    expect(fieldKey.currentState!.controller.text, emptyValue);
  });
}
