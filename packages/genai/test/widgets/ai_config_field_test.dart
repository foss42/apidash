import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/models.dart';
import 'package:genai/widgets/widgets.dart';

void main() {
  ModelConfig buildNumericConfig([num? value = 100]) {
    return ModelConfig(
      id: 'max_tokens',
      name: 'Max Tokens',
      description: 'Maximum output tokens',
      type: ConfigType.numeric,
      value: ConfigNumericValue(value: value),
    );
  }

  Widget buildTestApp({
    required ModelConfig configuration,
    required void Function(ModelConfig) onConfigUpdated,
    bool readonly = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AIConfigField(
          numeric: true,
          configuration: configuration,
          onConfigUpdated: onConfigUpdated,
          readonly: readonly,
        ),
      ),
    );
  }

  testWidgets('shows validation error for non-finite numeric input', (
    WidgetTester tester,
  ) async {
    final config = buildNumericConfig();
    var updates = 0;

    await tester.pumpWidget(
      buildTestApp(
        configuration: config,
        onConfigUpdated: (_) {
          updates++;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField), '1e309');
    await tester.pump();

    expect(find.text('Please enter a valid number'), findsOneWidget);
    expect(updates, 0);
    expect(config.value.value, 100);
  });

  testWidgets('clears error and updates model on valid numeric input', (
    WidgetTester tester,
  ) async {
    final config = buildNumericConfig();
    var updates = 0;

    await tester.pumpWidget(
      buildTestApp(
        configuration: config,
        onConfigUpdated: (_) {
          updates++;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'NaN');
    await tester.pump();
    expect(find.text('Please enter a valid number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '256');
    await tester.pump();

    expect(find.text('Please enter a valid number'), findsNothing);
    expect(updates, 1);
    expect(config.value.value, 256);
  });

  testWidgets('readonly numeric field does not update', (
    WidgetTester tester,
  ) async {
    final config = buildNumericConfig();
    var updates = 0;

    await tester.pumpWidget(
      buildTestApp(
        configuration: config,
        readonly: true,
        onConfigUpdated: (_) {
          updates++;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField), '333');
    await tester.pump();

    expect(updates, 0);
    expect(config.value.value, 100);
  });
}
