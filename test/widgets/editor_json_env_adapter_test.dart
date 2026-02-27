import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/widgets/editor_json.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';

import '../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  const envMap = {
    kGlobalEnvironmentId: [
      EnvironmentVariableModel(key: 'API_KEY', value: 'xyz'),
    ],
    'active-env': [
      EnvironmentVariableModel(key: 'TOKEN', value: 'abc'),
    ],
  };

  testWidgets('JsonTextFieldEditor renders env tokens with JSON adapter',
      (tester) async {
    String lastValue = '';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          availableEnvironmentVariablesStateProvider
              .overrideWith((ref) => envMap),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'active-env'),
        ],
        child: Portal(
          child: MaterialApp(
            home: Scaffold(
              body: JsonTextFieldEditor(
                fieldKey: 'json-editor-test',
                initialValue: '{"auth":""}',
                onChanged: (value) => lastValue = value,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(MultiTriggerAutocomplete), findsOneWidget);

    final editableFinder = find.byType(EditableText);
    expect(editableFinder, findsOneWidget);

    await tester.tap(editableFinder);
    await tester.pump();
    tester.testTextInput.enterText('{"auth":"{{TOKEN}}"}');
    await tester.pumpAndSettle();

    expect(find.byType(EnvVarSpan), findsWidgets);
    expect(find.byTooltip('Format JSON'), findsOneWidget);
    expect(lastValue, contains('{{TOKEN}}'));
  });
}
