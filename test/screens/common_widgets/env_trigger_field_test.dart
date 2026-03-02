import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  testWidgets(
      'Testing EnvironmentTriggerField preserves cursor position on text update',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'hello world';
    const updatedValue = 'hello world!';

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

    // Set cursor to position 5 (middle of text)
    fieldKey.currentState!.controller.selection =
        TextSelection.collapsed(offset: 5);

    // Update the text value
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

    // Verify cursor is still at position 5
    expect(fieldKey.currentState!.controller.selection.baseOffset, 5);
    expect(fieldKey.currentState!.controller.text, updatedValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField preserves text selection on text update',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'hello world';
    const updatedValue = 'hello world!';

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

    // Set text selection from position 0 to 5 (highlighted text)
    fieldKey.currentState!.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: 5);

    // Update the text value
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

    // Verify selection is preserved (both base and extent offsets)
    expect(fieldKey.currentState!.controller.selection.baseOffset, 0);
    expect(fieldKey.currentState!.controller.selection.extentOffset, 5);
    expect(fieldKey.currentState!.controller.text, updatedValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField resets cursor when keyId changes',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'hello world';
    const newValue = 'new request';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey1',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    // Set cursor to position 5
    fieldKey.currentState!.controller.selection =
        TextSelection.collapsed(offset: 5);

    // Change keyId (different request selected)
    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey2',
              initialValue: newValue,
            ),
          ),
        ),
      ),
    );

    // Verify cursor is reset to end of new text (different request)
    expect(fieldKey.currentState!.controller.selection.baseOffset,
        newValue.length);
    expect(fieldKey.currentState!.controller.text, newValue);
  });

  testWidgets('EnvironmentTriggerField supports multiline editor settings',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              keyId: 'multiline-key',
              initialValue: 'line-1\nline-2',
              keyboardType: TextInputType.multiline,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              enableTabInsertion: true,
            ),
          ),
        ),
      ),
    );

    final field = tester.widget<ExtendedTextField>(find.byType(ExtendedTextField));
    expect(field.keyboardType, TextInputType.multiline);
    expect(field.maxLines, isNull);
    expect(field.expands, true);
    expect(field.textAlignVertical, TextAlignVertical.top);
  });

  testWidgets('EnvironmentTriggerField inserts tab spaces when enabled',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'tab-key',
              initialValue: 'abcd',
              keyboardType: TextInputType.multiline,
              maxLines: null,
              expands: true,
              enableTabInsertion: true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ExtendedTextField));
    await tester.pump();
    fieldKey.currentState!.controller.selection =
        const TextSelection.collapsed(offset: 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(fieldKey.currentState!.controller.text, 'a  bcd');
  });
}
