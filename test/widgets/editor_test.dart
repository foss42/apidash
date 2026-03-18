import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/editor.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Editor', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Editor',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: '2',
                onChanged: (value) {
                  changedValue = value;
                },
              ),
            ),
          ]),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byKey(const Key("2")), findsOneWidget);
    expect(find.text(kHintContent), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, 'entering 123 for testing content body');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing content body  ');
  });
  testWidgets('Testing Editor Dark theme', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Editor Dark',
        theme: kThemeDataDark,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: '2',
                onChanged: (value) {
                  changedValue = value;
                },
                initialValue: 'initial',
              ),
            ),
          ]),
        ),
      ),
    );
    expect(find.text('initial'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byKey(const Key("2")), findsOneWidget);
    expect(find.text(kHintContent), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, 'entering 123 for testing content body');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing content body  ');
  });

  testWidgets(
      'Testing TextFieldEditor preserves cursor position on text update',
      (tester) async {
    const initialValue = 'hello world';
    const updatedValue = 'hello world!';

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: 'testKey',
                initialValue: initialValue,
              ),
            ),
          ]),
        ),
      ),
    );

    // Get the controller via EditableText
    final editableText =
        tester.widget<EditableText>(find.byType(EditableText));
    final controller = editableText.controller;

    // Set cursor to position 5 (middle of text)
    controller.selection = TextSelection.collapsed(offset: 5);

    // Update the text value (same fieldKey)
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: 'testKey',
                initialValue: updatedValue,
              ),
            ),
          ]),
        ),
      ),
    );

    // Verify cursor is still at position 5
    expect(controller.selection.baseOffset, 5);
    expect(controller.text, updatedValue);
  });

  testWidgets(
      'Testing TextFieldEditor preserves text selection on text update',
      (tester) async {
    const initialValue = 'hello world';
    const updatedValue = 'hello world!';

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: 'testKey',
                initialValue: initialValue,
              ),
            ),
          ]),
        ),
      ),
    );

    final editableText =
        tester.widget<EditableText>(find.byType(EditableText));
    final controller = editableText.controller;

    // Set text selection from position 0 to 5 (highlighted text)
    controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);

    // Update the text value
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: 'testKey',
                initialValue: updatedValue,
              ),
            ),
          ]),
        ),
      ),
    );

    // Verify selection is preserved (both base and extent offsets)
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 5);
    expect(controller.text, updatedValue);
  });

  testWidgets(
      'Testing TextFieldEditor resets cursor when fieldKey changes',
      (tester) async {
    const initialValue = 'hello world';
    const newValue = 'new request';

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: 'testKey1',
                initialValue: initialValue,
              ),
            ),
          ]),
        ),
      ),
    );

    var editableText =
        tester.widget<EditableText>(find.byType(EditableText));
    var controller = editableText.controller;

    // Set cursor to position 5
    controller.selection = TextSelection.collapsed(offset: 5);

    // Change fieldKey (different requst selected)
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: TextFieldEditor(
                fieldKey: 'testKey2',
                initialValue: newValue,
              ),
            ),
          ]),
        ),
      ),
    );

    // Re-fetch controller after rebuild
    editableText =
        tester.widget<EditableText>(find.byType(EditableText));
    controller = editableText.controller;

    // Verify cursor is reset to end of new text (different request)
    expect(controller.selection.baseOffset, newValue.length);
    expect(controller.text, newValue);
  });
}
