import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/screens/common_widgets/envvar_indicator.dart';

void main() {
  testWidgets(
      'EnvVarIndicator displays correct icon and color for unknown suggestion',
      (WidgetTester tester) async {
    const suggestion = EnvironmentVariableSuggestion(
        isUnknown: true,
        environmentId: 'someId',
        variable: EnvironmentVariableModel(key: 'key', value: 'value'));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvVarIndicator(suggestion: suggestion),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final icon = tester.widget<Icon>(find.byType(Icon));

    expect(container.decoration, isA<BoxDecoration>());
    final decoration = container.decoration as BoxDecoration;
    expect(
        decoration.color,
        Theme.of(tester.element(find.byType(Container)))
            .colorScheme
            .errorContainer);
    expect(icon.icon, Icons.block);
  });

  testWidgets(
      'EnvVarIndicator displays correct icon and color for global suggestion',
      (WidgetTester tester) async {
    const suggestion = EnvironmentVariableSuggestion(
        isUnknown: false,
        environmentId: kGlobalEnvironmentId,
        variable: EnvironmentVariableModel(key: 'key', value: 'value'));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvVarIndicator(suggestion: suggestion),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final icon = tester.widget<Icon>(find.byType(Icon));

    expect(container.decoration, isA<BoxDecoration>());
    final decoration = container.decoration as BoxDecoration;
    expect(
        decoration.color,
        Theme.of(tester.element(find.byType(Container)))
            .colorScheme
            .secondaryContainer);
    expect(icon.icon, Icons.public);
  });

  testWidgets(
      'EnvVarIndicator displays correct icon and color for non-global suggestion',
      (WidgetTester tester) async {
    const suggestion = EnvironmentVariableSuggestion(
        isUnknown: false,
        environmentId: 'someOtherId',
        variable: EnvironmentVariableModel(key: 'key', value: 'value'));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EnvVarIndicator(suggestion: suggestion),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final icon = tester.widget<Icon>(find.byType(Icon));

    expect(container.decoration, isA<BoxDecoration>());
    final decoration = container.decoration as BoxDecoration;
    expect(
        decoration.color,
        Theme.of(tester.element(find.byType(Container)))
            .colorScheme
            .primaryContainer);
    expect(icon.icon, Icons.computer);
  });
}
