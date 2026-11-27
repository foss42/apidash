import 'package:apidash/widgets/field_search.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing SearchField renders default hint and search icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: const Scaffold(
          body: SearchField(),
        ),
      ),
    );

    expect(find.byType(SearchField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(ADRawTextField), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('Testing SearchField with custom hintText and custom height',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataDark,
        home: const Scaffold(
          body: SearchField(
            hintText: 'Filter requests...',
            height: 48,
          ),
        ),
      ),
    );

    expect(find.byType(SearchField), findsOneWidget);
    expect(find.text('Filter requests...'), findsOneWidget);

    final container = tester.widget<Container>(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.constraints?.maxHeight == 48,
      ),
    );
    expect(container, isNotNull);
  });

  testWidgets('Testing SearchField triggers onChanged callback',
      (WidgetTester tester) async {
    String? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: SearchField(
            onChanged: (val) {
              changedValue = val;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'auth');
    await tester.pumpAndSettle();

    expect(changedValue, equals('auth'));
  });

  testWidgets('Testing SearchField with TextEditingController',
      (WidgetTester tester) async {
    final controller = TextEditingController(text: 'initial search');

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: SearchField(
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.text('initial search'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'updated query');
    await tester.pumpAndSettle();

    expect(controller.text, equals('updated query'));
  });
}

