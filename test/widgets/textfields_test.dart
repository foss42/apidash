import 'package:apidash/consts.dart';
import 'package:apidash/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    expect(find.text(kHintTextHTTPUrlCard), findsOneWidget);
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
}
