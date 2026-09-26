import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/envvar/editor_pane/secrets_pane.dart';
import 'package:apidash/screens/envvar/editor_pane/variables_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await testSetUpTempDirForHive();
  });

  for (final (label, editor, valueFirst) in [
    ('variable', const EditEnvironmentVariables(), false),
    ('secret', const EditEnvironmentSecrets(), true),
  ]) {
    testWidgets('Clear Data empties both $label fields', (tester) async {
      final container = createContainer();
      container.read(environmentsStateNotifierProvider);
      container.read(selectedEnvironmentIdStateProvider.notifier).state =
          kGlobalEnvironmentId;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: Scaffold(body: editor)),
        ),
      );
      await tester.pump();

      final fields = find.byType(EditableText);
      final order = valueFirst ? [1, 0] : [0, 1];
      for (final index in order) {
        await tester.enterText(
          fields.at(index),
          index == 0 ? 'baseUrl' : 'https://example.com',
        );
        await tester.pump();
      }

      expect(
        tester
            .widgetList<EditableText>(fields)
            .map((field) => field.controller.text),
        containsAll(['baseUrl', 'https://example.com']),
      );

      await tester.runAsync(
        () => container
            .read(collectionStateNotifierProvider.notifier)
            .clearData(),
      );
      await tester.pump();

      expect(
        tester
            .widgetList<EditableText>(fields)
            .map((field) => field.controller.text),
        everyElement(isEmpty),
      );
    });
  }
}
