import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/models.dart';
import 'package:genai/widgets/ai_config_field.dart';

void main() {
  group('AIConfigField', () {
    testWidgets('shows numeric validation error for non-finite values',
        (tester) async {
      final config = ModelConfig(
        id: 'max_tokens',
        name: 'Maximum Tokens',
        description: 'Max output tokens',
        type: ConfigType.numeric,
        value: ConfigNumericValue(value: 1024),
      );

      int updates = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIConfigField(
              numeric: true,
              configuration: config,
              onConfigUpdated: (_) {
                updates++;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '1e309');
      await tester.pump();

      expect(find.text('Invalid numeric value'), findsOneWidget);
      expect(updates, 0);

      await tester.enterText(find.byType(TextFormField), '2048');
      await tester.pump();

      expect(find.text('Invalid numeric value'), findsNothing);
      expect(updates, 1);
      expect(config.value.value, 2048);
    });
  });
}
