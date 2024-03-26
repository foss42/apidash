import 'package:apidash/widgets/editor_json.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing JSON Editor', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'JSON Editor',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Column(children: [
            Expanded(
              child: JsonTextFieldEditor(
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

    expect(find.byType(CodeField), findsOneWidget);
    expect(find.byKey(const Key("2")), findsOneWidget);
    expect(find.text('Enter content (json)'), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, r'''[
  {
    "title": "apples",
    "count": [12000, 20000],
    "description": {"text": "...", "sensitive": false}
  },
  {
    "title": "oranges",
    "count": [17500, null],
    "description": {"text": "...", "sensitive": false}
  }
]''');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, r'''[
  {
    "title": "apples",
    "count": [12000, 20000],
    "description": {"text": "...", "sensitive": false}
  },
  {
    "title": "oranges",
    "count": [17500, null],
    "description": {"text": "...", "sensitive": false}
  }
]''');
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
              child: JsonTextFieldEditor(
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
    expect(find.text('initial'), findsAtLeast(1));
    expect(find.byType(CodeField), findsOneWidget);
    expect(find.byKey(const Key("2")), findsOneWidget);
    expect(find.text('Enter content (json)'), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, r'''[
  {
    "title": "apples",
    "count": [12000, 20000],
    "description": {"text": "...", "sensitive": false}
  },
  {
    "title": "oranges",
    "count": [17500, null],
    "description": {"text": "...", "sensitive": false}
  }
]''');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, r'''[
  {
    "title": "apples",
    "count": [12000, 20000],
    "description": {"text": "...", "sensitive": false}
  },
  {
    "title": "oranges",
    "count": [17500, null],
    "description": {"text": "...", "sensitive": false}
  }
]''');
  });
}
