import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/popup_menu_env.dart';

void main() {
  testWidgets('EnvironmentPopupMenu displays initial value',
      (WidgetTester tester) async {
    const environment = EnvironmentModel(name: 'Production', id: 'prod');

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            value: environment,
            items: [environment],
          ),
        ),
      ),
    );

    expect(find.text('Production'), findsOneWidget);
  });

  testWidgets('EnvironmentPopupMenu displays "None" when no value is provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            items: [],
          ),
        ),
      ),
    );

    expect(find.text('None'), findsOneWidget);
  });

  testWidgets('EnvironmentPopupMenu displays popup menu items',
      (WidgetTester tester) async {
    const environment1 = EnvironmentModel(name: 'Production', id: 'prod');
    const environment2 = EnvironmentModel(name: 'Development', id: 'dev');

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            items: [environment1, environment2],
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    expect(find.text('None'), findsExactly(2));
    expect(find.text('Production'), findsOneWidget);
    expect(find.text('Development'), findsOneWidget);
  });

  testWidgets('EnvironmentPopupMenu calls onChanged when an item is selected',
      (WidgetTester tester) async {
    const environment1 = EnvironmentModel(name: 'Production', id: 'prod');
    const environment2 = EnvironmentModel(name: 'Development', id: 'dev');
    EnvironmentModel? selectedEnvironment;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            items: const [environment1, environment2],
            onChanged: (value) {
              selectedEnvironment = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Development').last);
    await tester.pumpAndSettle();

    expect(selectedEnvironment, environment2);
  });

  testWidgets(
      'EnvironmentPopupMenu calls onChanged with null when "None" is selected',
      (WidgetTester tester) async {
    const environment = EnvironmentModel(name: 'Production', id: 'prod');
    EnvironmentModel? selectedEnvironment = environment;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            items: const [environment],
            onChanged: (value) {
              selectedEnvironment = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    await tester.tap(find.text('None').last);
    await tester.pumpAndSettle();

    expect(selectedEnvironment, isNull);
  });
}
