import 'package:apidash/screens/common_widgets/ai/ai_model_selector_button.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AIModelSelectorButton', () {
    testWidgets('displays "Select Model" when aiRequestModel is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AIModelSelectorButton(
              aiRequestModel: null,
            ),
          ),
        ),
      );

      expect(find.text('Select Model'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays "Select Model" when model is empty string',
        (WidgetTester tester) async {
      const aiRequestModel = AIRequestModel(
        model: '',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AIModelSelectorButton(
              aiRequestModel: aiRequestModel,
            ),
          ),
        ),
      );

      expect(find.text('Select Model'), findsOneWidget);
    });

    testWidgets('displays model name when model is provided',
        (WidgetTester tester) async {
      const aiRequestModel = AIRequestModel(
        model: 'gpt-4',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AIModelSelectorButton(
              aiRequestModel: aiRequestModel,
            ),
          ),
        ),
      );

      expect(find.text('gpt-4'), findsOneWidget);
      expect(find.text('Select Model'), findsNothing);
    });

    testWidgets('displays different model names correctly',
        (WidgetTester tester) async {
      const aiRequestModel = AIRequestModel(
        model: 'gemini-pro',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AIModelSelectorButton(
              aiRequestModel: aiRequestModel,
            ),
          ),
        ),
      );

      expect(find.text('gemini-pro'), findsOneWidget);
    });

    testWidgets('button is disabled when readonly is true',
        (WidgetTester tester) async {
      const aiRequestModel = AIRequestModel(
        model: 'gpt-4',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AIModelSelectorButton(
              aiRequestModel: aiRequestModel,
              readonly: true,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('button is enabled when readonly is false',
        (WidgetTester tester) async {
      const aiRequestModel = AIRequestModel(
        model: 'gpt-4',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AIModelSelectorButton(
              aiRequestModel: aiRequestModel,
              readonly: false,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });
  });
}
