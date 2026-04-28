import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing URL Field', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'URL Field',
        theme: kThemeDataDark,
        home: const Scaffold(
          body: Column(children: [URLField(selectedId: '2')]),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byKey(const Key("url-2")), findsOneWidget);
    expect(find.byKey(const Key("2")), findsNothing);
    expect(find.text(kHintTextUrlCard), findsOneWidget);
    var txtForm = find.byKey(const Key("url-2"));
    await tester.enterText(txtForm, 'entering 123');
    await tester.pump();
    expect(find.text('entering 123'), findsOneWidget);
  });
  testWidgets('Testing Cell Field', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'CellField',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: Column(
            children: [
              CellField(
                keyId: "4",
                hintText: "Passing some hint text",
                initialValue: '2',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byKey(const Key("4")), findsOneWidget);
    expect(find.text("2"), findsOneWidget);

    var txtField = find.byKey(const Key("4"));
    await tester.enterText(txtField, '');
    await tester.pumpAndSettle();

    expect(find.text("Passing some hint text"), findsOneWidget);
    await tester.enterText(txtField, 'entering 123 for cell field');
    await tester.pumpAndSettle();
    expect(find.text('entering 123 for cell field'), findsOneWidget);
  });

  testWidgets('Cell Field refreshes when initialValue changes', (tester) async {
    // Build widget with initial value "first value"
    await tester.pumpWidget(
      MaterialApp(
        title: 'CellField',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: Column(
            children: [
              CellField(
                keyId: "test-field",
                initialValue: "first value",
              ),
            ],
          ),
        ),
      ),
    );

    // Verify initial value is displayed
    expect(find.text("first value"), findsOneWidget);

    // Rebuild widget with new initialValue "second value"
    await tester.pumpWidget(
      MaterialApp(
        title: 'CellField',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: Column(
            children: [
              CellField(
                keyId: "test-field",
                initialValue: "second value",
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the widget refreshed and displays the new value
    expect(find.text("second value"), findsOneWidget);
    expect(find.text("first value"), findsNothing);
  });

  testWidgets('CellField does not lose focus after first character',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'CellField',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: Column(
            children: [
              CellField(
                keyId: "focus-test",
                initialValue: "",
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text(""), findsOneWidget);

    var fieldFinder = find.byKey(const Key("focus-test"));
    // focus field
    await tester.tap(fieldFinder);
    await tester.pump();

    // type character
    await tester.enterText(fieldFinder, "a");
    await tester.pump();

    // Verify text updated
    expect(find.text("a"), findsOneWidget);

    // Verify field is still focused
    expect(FocusManager.instance.primaryFocus, isNotNull);
  });

  testWidgets(
    'CellField preserves cursor position on initialValue update',
    (tester) async {
      const initialValue = 'hello world';
      const updatedValue = 'hello world!';

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: CellField(
              keyId: 'cursor-test',
              initialValue: initialValue,
            ),
          ),
        ),
      );

      // Get controller
      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      final controller = editableText.controller;

      // Set cursor to offset 5
      controller.selection = const TextSelection.collapsed(offset: 2);

      // updated initialValue
      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: CellField(
              keyId: 'cursor-test',
              initialValue: updatedValue,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify cursor position remains same.
      expect(controller.text, updatedValue);
      expect(controller.selection.baseOffset, 2);
    },
  );

  testWidgets('URL Field sends request on enter keystroke', (tester) async {
    bool wasSubmitCalled = false;

    void testSubmit(String val) {
      wasSubmitCalled = true;
    }

    await tester.pumpWidget(
      MaterialApp(
        title: 'URL Field',
        theme: kThemeDataDark,
        home: Scaffold(
          body: Column(children: [
            URLField(
              selectedId: '2',
              onFieldSubmitted: testSubmit,
            )
          ]),
        ),
      ),
    );

    // ensure URLField is blank
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.textContaining('Enter API endpoint '), findsOneWidget);
    expect(wasSubmitCalled, false);

    // modify value and press enter
    var txtForm = find.byKey(const Key("url-2"));
    await tester.enterText(txtForm, 'entering 123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // check if value was updated
    expect(wasSubmitCalled, true);
  });
}
