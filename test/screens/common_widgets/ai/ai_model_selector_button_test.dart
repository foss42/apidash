import 'package:apidash/screens/common_widgets/ai/ai_model_selector_button.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AIModelSelectorButton shows "Select Model" when model is null',
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
  });

  testWidgets(
      'AIModelSelectorButton shows "Select Model" when model name is empty',
      (WidgetTester tester) async {
    const emptyModel = AIRequestModel(model: '', modelApiProvider: ModelAPIProvider.openai, apiKey: '');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AIModelSelectorButton(
            aiRequestModel: emptyModel,
          ),
        ),
      ),
    );

    expect(find.text('Select Model'), findsOneWidget);
  });

  testWidgets('AIModelSelectorButton shows model name when model is provided',
      (WidgetTester tester) async {
    const validModel = AIRequestModel(model: 'gpt-4', modelApiProvider: ModelAPIProvider.openai, apiKey: '');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AIModelSelectorButton(
            aiRequestModel: validModel,
          ),
        ),
      ),
    );

    expect(find.text('gpt-4'), findsOneWidget);
    expect(find.text('Select Model'), findsNothing);
  });
}
