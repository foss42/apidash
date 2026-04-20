import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/ai/ai_model_selector_button.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AIModelSelectorButton Tests', () {
    testWidgets('shows kLabelSelectModel when model is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AIModelSelectorButton(aiRequestModel: null),
        ),
      ));
      expect(find.text(kLabelSelectModel), findsOneWidget);
    });

    testWidgets('shows kLabelSelectModel when model is empty string',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AIModelSelectorButton(
              aiRequestModel: AIRequestModel(model: '')),
        ),
      ));
      expect(find.text(kLabelSelectModel), findsOneWidget);
    });

    testWidgets('shows model name when model is not empty',
        (WidgetTester tester) async {
      const testModelName = 'gpt-4o';
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AIModelSelectorButton(
              aiRequestModel: AIRequestModel(model: testModelName)),
        ),
      ));
      expect(find.text(testModelName), findsOneWidget);
    });
  });
}
