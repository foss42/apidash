import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/button_form_data_file.dart';

void main() {
  testWidgets('Testing FormDataFileButton for default label',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FormDataFileButton(),
        ),
      ),
    );

    final icon = find.byIcon(Icons.snippet_folder_rounded);
    Finder button = find.ancestor(
        of: icon,
        matching: find.byWidgetPredicate((widget) => widget is ElevatedButton));

    expect(button, findsOneWidget);
    expect(find.text(kLabelSelectFile), findsOneWidget);
  });

  testWidgets('Testing FormDataFileButton with provided label',
      (WidgetTester tester) async {
    const testValue = 'test_file.txt';
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FormDataFileButton(initialValue: testValue),
        ),
      ),
    );

    final icon = find.byIcon(Icons.snippet_folder_rounded);
    Finder button = find.ancestor(
        of: icon,
        matching: find.byWidgetPredicate((widget) => widget is ElevatedButton));

    expect(button, findsOneWidget);
    expect(find.text(testValue), findsOneWidget);
  });

  testWidgets('Testing FormDataFileButton triggers onPressed callback',
      (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormDataFileButton(
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    final icon = find.byIcon(Icons.snippet_folder_rounded);
    Finder button = find.ancestor(
        of: icon,
        matching: find.byWidgetPredicate((widget) => widget is ElevatedButton));

    await tester.tap(button);
    await tester.pump();

    expect(pressed, isTrue);
  });
}
