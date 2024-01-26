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
    expect(find.text('Enter content (body)'), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, 'entering 123 for testing content body');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing content body    ');
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
    expect(find.text('Enter content (body)'), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, 'entering 123 for testing content body');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing content body    ');
  });
}
