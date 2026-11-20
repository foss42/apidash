import 'package:apidash/widgets/field_cell.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing CellField renders with initialValue and hintText',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: const Scaffold(
          body: CellField(
            keyId: 'test_cell',
            initialValue: 'Hello API Dash',
            hintText: 'Enter value',
          ),
        ),
      ),
    );

    expect(find.byType(CellField), findsOneWidget);
    expect(find.byType(ADOutlinedTextField), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Hello API Dash'), findsOneWidget);
  });

  testWidgets('Testing CellField with custom hintText and null initialValue',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataDark,
        home: const Scaffold(
          body: CellField(
            keyId: 'test_cell_hint',
            hintText: 'Custom Hint',
          ),
        ),
      ),
    );

    expect(find.byType(CellField), findsOneWidget);
    expect(find.text('Custom Hint'), findsOneWidget);
  });

  testWidgets('Testing CellField triggers onChanged callback on text input',
      (WidgetTester tester) async {
    String? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: CellField(
            keyId: 'test_cell_input',
            initialValue: '',
            hintText: 'Type query',
            onChanged: (val) {
              changedValue = val;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'application/json');
    await tester.pumpAndSettle();

    expect(changedValue, equals('application/json'));
  });

  testWidgets('Testing CellField with custom colorScheme',
      (WidgetTester tester) async {
    const customScheme = ColorScheme.light(
      primary: Colors.red,
      surface: Colors.white,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CellField(
            keyId: 'test_cell_color',
            initialValue: 'Styled Cell',
            colorScheme: customScheme,
          ),
        ),
      ),
    );

    expect(find.byType(CellField), findsOneWidget);
    expect(find.text('Styled Cell'), findsOneWidget);
  });
}

