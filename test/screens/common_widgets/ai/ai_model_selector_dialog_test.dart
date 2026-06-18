import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/ai/ai_model_selector_dialog.dart';
import 'package:apidash/screens/common_widgets/ai/dialog_add_ai_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('addNewModel', () {
    testWidgets('rejects empty model ID', (tester) async {
      Model? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await addNewModel(context);
                  },
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(kLabelAddModel));
      await tester.pump();

      expect(find.text('Model ID is required'), findsOneWidget);
      expect(result, isNull);
    });

    testWidgets('uses model ID as display name when blank', (tester) async {
      Model? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await addNewModel(context);
                  },
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final dialogFields = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(EditableText),
      );

      await tester.enterText(dialogFields.at(0), 'custom-model-1315');
      await tester.tap(find.text(kLabelAddModel));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(result, isNotNull);
      expect(result!.id, 'custom-model-1315');
      expect(result!.name, 'custom-model-1315');
    });
  });

  test('addModelToProviderData appends model to the selected provider', () {
    final data = AvailableModels(
      version: 1.0,
      modelProviders: [
        AIModelProvider(
          providerId: ModelAPIProvider.openai,
          providerName: 'OpenAI',
          sourceUrl: null,
          models: const [
            Model(id: 'gpt-5', name: 'GPT-5'),
          ],
        ),
      ],
    );

    final updated = addModelToProviderData(
      data,
      ModelAPIProvider.openai,
      const Model(id: 'my-test-model-1315', name: 'My Test Model 1315'),
    );

    expect(updated.modelProviders.first.models, hasLength(2));
    expect(
      updated.modelProviders.first.models!.last.id,
      'my-test-model-1315',
    );
    expect(
      updated.modelProviders.first.models!.last.name,
      'My Test Model 1315',
    );
  });

  testWidgets('successful add updates AI model selector UI immediately',
      (tester) async {
    final data = AvailableModels(
      version: 1.0,
      modelProviders: [
        AIModelProvider(
          providerId: ModelAPIProvider.openai,
          providerName: 'OpenAI',
          sourceUrl: null,
          models: const [
            Model(id: 'gpt-5', name: 'GPT-5'),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AIModelSelectorDialog(
              aiRequestModel: const AIRequestModel(
                modelApiProvider: ModelAPIProvider.openai,
                model: 'gpt-5',
              ),
              availableModelsFuture: Future.value(data),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    final dialogFields = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(EditableText),
    );

    await tester.enterText(dialogFields.at(0), 'my-test-model-1315');
    await tester.enterText(dialogFields.at(1), 'My Test Model 1315');

    await tester.tap(find.text(kLabelAddModel));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('My Test Model 1315'), findsOneWidget);
  });
}
