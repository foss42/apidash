import 'package:apidash/screens/common_widgets/ai/ai_model_selector_dialog.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/genai.dart';

void main() {
  testWidgets('AIModelSelectorDialog Validation Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AIModelSelectorDialog(
              availableModelsFuture: Future.value(kAvailableModels),
              aiRequestModel: const AIRequestModel(
                modelApiProvider: ModelAPIProvider.openai,
                url: 'https://api.openai.com/v1',
                apiKey: '',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final saveButtonFinder = find.text('Save');
    expect(saveButtonFinder, findsOneWidget);

    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('API Key is required'), findsOneWidget);

    final apiKeyTextFieldFinder = find.byType(TextField).first;
    await tester.enterText(apiKeyTextFieldFinder, 'test-api-key');
    await tester.pump();

    expect(find.text('API Key is required'), findsNothing);

    await tester.tap(saveButtonFinder);
    await tester.pump();
  });
}
