import 'package:apidash/widgets/editor_json.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/env_trigger_json_editing.dart';

main() {
  const envMap = {
    kGlobalEnvironmentId: [
      EnvironmentVariableModel(key: 'key1', value: 'value1'),
      EnvironmentVariableModel(key: 'key2', value: 'value2'),
    ],
    'activeEnvId': [
      EnvironmentVariableModel(key: 'key2', value: 'value1'),
      EnvironmentVariableModel(key: 'key3', value: 'value2'),
    ],
  };

  const suggestions = [
    EnvironmentVariableSuggestion(
      environmentId: 'activeEnvId',
      variable: EnvironmentVariableModel(key: 'key2', value: 'value1'),
    ),
    EnvironmentVariableSuggestion(
      environmentId: 'activeEnvId',
      variable: EnvironmentVariableModel(key: 'key3', value: 'value2'),
    ),
    EnvironmentVariableSuggestion(
      environmentId: kGlobalEnvironmentId,
      variable: EnvironmentVariableModel(key: 'key1', value: 'value1'),
    ),
    EnvironmentVariableSuggestion(
      environmentId: kGlobalEnvironmentId,
      variable: EnvironmentVariableModel(key: 'key2', value: 'value2'),
    ),
  ];

  testWidgets('EnvironmentTriggerJsonEditor updates controller text',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerJsonEditorState>();
    const initialValue = 'initial';
    const updatedValue = 'updated';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerJsonEditor(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    Finder field = find.byType(JsonTextFieldEditor);
    expect(field, findsOneWidget);
    expect(fieldKey.currentState!.controller.text, initialValue);

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerJsonEditor(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: updatedValue,
            ),
          ),
        ),
      ),
    );

    expect(fieldKey.currentState!.controller.text, updatedValue);
  });

  testWidgets(
      'EnvironmentTriggerJsonEditor shows suggestions when trigger typed',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerJsonEditorState>();
    const textWithSuggestionTrigger = '{"Test" : {{';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          availableEnvironmentVariablesStateProvider
              .overrideWith((ref) => envMap),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'activeEnvId'),
        ],
        child: Portal(
          child: MaterialApp(
            home: Scaffold(
              body: EnvironmentTriggerJsonEditor(
                key: fieldKey,
                keyId: 'testKey',
                initialValue: textWithSuggestionTrigger,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(JsonTextFieldEditor));
    await tester.pumpAndSettle();

    expect(find.byType(ClipRRect), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });
}
