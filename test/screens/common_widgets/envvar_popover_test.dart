import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/screens/common_widgets/envvar_indicator.dart';
import 'package:apidash/screens/common_widgets/envvar_popover.dart';

void main() {
  testWidgets('EnvVarPopover displays correct information',
      (WidgetTester tester) async {
    const suggestion = EnvironmentVariableSuggestion(
      isUnknown: false,
      environmentId: 'someId',
      variable: EnvironmentVariableModel(key: 'API_KEY', value: '12345'),
    );
    const scope = 'Global';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvVarPopover(suggestion: suggestion, scope: scope),
        ),
      ),
    );

    expect(find.byType(EnvVarIndicator), findsOneWidget);

    expect(find.text('API_KEY'), findsOneWidget);

    expect(find.text('VALUE'), findsOneWidget);
    expect(find.text('12345'), findsOneWidget);

    expect(find.text('SCOPE'), findsOneWidget);
    expect(find.text('Global'), findsOneWidget);
  });
}
