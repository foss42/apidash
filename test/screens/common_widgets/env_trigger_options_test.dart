import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/env_trigger_options.dart';

void main() {
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
  testWidgets(
      'EnvironmentTriggerOptions shows no suggestions when suggestions are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          availableEnvironmentVariablesStateProvider.overrideWith((ref) => {}),
          activeEnvironmentIdStateProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerOptions(
              query: 'test',
              onSuggestionTap: (suggestion) {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.byType(ClipRRect), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('EnvironmentTriggerOptions shows suggestions when available',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          availableEnvironmentVariablesStateProvider
              .overrideWith((ref) => envMap),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'activeEnvId'),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerOptions(
              query: 'key',
              onSuggestionTap: (suggestion) {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ClipRRect), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets(
      'EnvironmentTriggerOptions calls onSuggestionTap when a suggestion is tapped',
      (WidgetTester tester) async {
    EnvironmentVariableSuggestion? tappedSuggestion;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          availableEnvironmentVariablesStateProvider
              .overrideWith((ref) => envMap),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'activeEnvId'),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerOptions(
              query: 'key',
              onSuggestionTap: (suggestion) {
                tappedSuggestion = suggestion;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ListTile).first);
    await tester.pump();

    expect(tappedSuggestion, isNotNull);
    expect(tappedSuggestion, equals(suggestions.first));
  });
}
