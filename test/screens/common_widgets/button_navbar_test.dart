import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/screens/common_widgets/button_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing NavbarButton shows label when showLabel is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mobileScaffoldKeyStateProvider
              .overrideWith((ref) => GlobalKey<ScaffoldState>())
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: NavbarButton(
              railIdx: 0,
              buttonIdx: 1,
              selectedIcon: Icons.check,
              icon: Icons.add,
              label: 'Test Label',
              showLabel: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Label'), findsOneWidget);
  });

  testWidgets('Testing NavbarButton hides label when showLabel is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mobileScaffoldKeyStateProvider
              .overrideWith((ref) => GlobalKey<ScaffoldState>())
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: NavbarButton(
              railIdx: 0,
              buttonIdx: 1,
              selectedIcon: Icons.check,
              icon: Icons.add,
              label: 'Test Label',
              showLabel: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Label'), findsNothing);
  });

  testWidgets('Testing NavbarButton label style with isSelected',
      (WidgetTester tester) async {
    const testKey = Key('navbar_button');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mobileScaffoldKeyStateProvider
              .overrideWith((ref) => GlobalKey<ScaffoldState>())
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: NavbarButton(
              key: testKey,
              railIdx: 1,
              buttonIdx: 1,
              selectedIcon: Icons.check,
              icon: Icons.check_box_outline_blank,
              label: 'Test Label',
            ),
          ),
        ),
      ),
    );

    Text label = tester.widget(find.text('Test Label'));
    expect(
        label.style?.color,
        equals(Theme.of(tester.element(find.byKey(testKey)))
            .colorScheme
            .onSecondaryContainer));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mobileScaffoldKeyStateProvider
              .overrideWith((ref) => GlobalKey<ScaffoldState>())
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: NavbarButton(
              key: testKey,
              railIdx: 1,
              buttonIdx: 2,
              selectedIcon: Icons.check,
              icon: Icons.check_box_outline_blank,
              label: 'Test Label',
            ),
          ),
        ),
      ),
    );

    label = tester.widget(find.text('Test Label'));
    expect(
        label.style?.color,
        equals(Theme.of(tester.element(find.byKey(testKey)))
            .colorScheme
            .onSurface
            .withOpacity(0.65)));
  });
}
