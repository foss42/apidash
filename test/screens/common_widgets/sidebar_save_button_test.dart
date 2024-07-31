import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/screens/common_widgets/sidebar_save_button.dart';
import '../../test_consts.dart';

void main() {
  group("Testing Save Button", () {
    testWidgets('Testing for Save button enabled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            saveDataStateProvider.overrideWith((ref) => false),
            hasUnsavedChangesProvider.overrideWith((ref) => true),
          ],
          child: MaterialApp(
            title: 'Save button',
            theme: kThemeDataLight,
            home: const Scaffold(
              body: SaveButton(),
            ),
          ),
        ),
      );
      final icon = find.byIcon(Icons.save);
      expect(icon, findsOneWidget);

      final saveButton = find.ancestor(
          of: icon,
          matching: find.byWidgetPredicate((widget) => widget is TextButton));
      expect(saveButton, findsOneWidget);

      final saveButtonWidget = tester.widget<TextButton>(saveButton);
      expect(saveButtonWidget.enabled, true);
    });

    testWidgets('Testing for Save button disabled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            saveDataStateProvider.overrideWith((ref) => false),
            hasUnsavedChangesProvider.overrideWith((ref) => false),
          ],
          child: MaterialApp(
            title: 'Save button',
            theme: kThemeDataLight,
            home: const Scaffold(
              body: SaveButton(),
            ),
          ),
        ),
      );

      final icon = find.byIcon(Icons.save);
      expect(icon, findsOneWidget);

      final saveButton = find.ancestor(
          of: icon,
          matching: find.byWidgetPredicate((widget) => widget is TextButton));
      expect(saveButton, findsOneWidget);

      final saveButtonWidget = tester.widget<TextButton>(saveButton);
      expect(saveButtonWidget.enabled, false);
    });
  });
}
