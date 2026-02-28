import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
            options: [environment],
          ),
        ),
      ),
    );

    expect(find.text('Production'), findsOneWidget);
  });

  testWidgets('EnvironmentPopupMenu displays "None" when no value is provided',
      (WidgetTester tester) async {
    const environment = EnvironmentModel(
      name: 'Global',
      id: kGlobalEnvironmentId,
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            value: environment,
            options: [environment],
          ),
        ),
      ),
    );

    expect(find.text('Global'), findsOneWidget);
  });

  testWidgets('EnvironmentPopupMenu displays popup menu items',
      (WidgetTester tester) async {
    const environment = EnvironmentModel(
      name: 'Global',
      id: kGlobalEnvironmentId,
    );
    const environment1 = EnvironmentModel(
      name: 'Production',
      id: 'prod',
    );
    const environment2 = EnvironmentModel(
      name: 'Development',
      id: 'dev',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            value: environment,
            options: [environment, environment1, environment2],
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    expect(find.text('Global'), findsExactly(2));
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
            options: const [environment1, environment2],
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
    const environment = EnvironmentModel(
      name: 'Global',
      id: kGlobalEnvironmentId,
    );
    const environment1 = EnvironmentModel(
      name: 'Production',
      id: 'prod',
    );
    EnvironmentModel? selectedEnvironment = environment1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvironmentPopupMenu(
            value: environment1,
            options: const [environment, environment1],
            onChanged: (value) {
              selectedEnvironment = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Global').last);
    await tester.pumpAndSettle();

    expect(selectedEnvironment, environment);
  });
}
