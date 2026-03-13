import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/ai/ai_model_selector_dialog.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fakeModels = AvailableModels(
    version: 1,
    modelProviders: [
      AIModelProvider(
        providerId: ModelAPIProvider.openai,
        providerName: 'OpenAI',
        sourceUrl: 'https://api.openai.com/v1/chat/completions',
        models: [Model(id: 'gpt-4o', name: 'GPT-4o')],
      ),
    ],
  );

  testWidgets('shows a compact empty state on narrow screens', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(390, 844)),
            child: Scaffold(
              body: AIModelSelectorDialog(
                availableModelsFuture: Future<AvailableModels>.value(
                  fakeModels,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text(kLabelSelectModelProvider), findsOneWidget);
    expect(find.text(kLabelSelectAIProvider), findsOneWidget);
    expect(find.text(kLabelSave), findsOneWidget);

    final dropdownFinder = find.byType(ADDropdownButton<ModelAPIProvider>);
    expect(dropdownFinder, findsOneWidget);

    final labelTop = tester.getTopLeft(find.text(kLabelSelectModelProvider)).dy;
    final dropdownTop = tester.getTopLeft(dropdownFinder).dy;

    expect(dropdownTop, greaterThan(labelTop));
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, kLabelSave))
          .onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps save visible on narrow screens with selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(390, 844)),
            child: Scaffold(
              body: AIModelSelectorDialog(
                aiRequestModel: const AIRequestModel(
                  modelApiProvider: ModelAPIProvider.openai,
                ),
                availableModelsFuture: Future<AvailableModels>.value(
                  fakeModels,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text(kLabelSave), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses compact layout on short landscape screens', (tester) async {
    expect(useCompactAiModelSelectorDialogLayout(const Size(844, 390)), isTrue);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(844, 390)),
            child: Scaffold(
              body: AIModelSelectorDialog(
                aiRequestModel: const AIRequestModel(
                  modelApiProvider: ModelAPIProvider.openai,
                ),
                availableModelsFuture: Future<AvailableModels>.value(
                  fakeModels,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    final dropdownFinder = find.byType(ADDropdownButton<ModelAPIProvider>);
    final providerHeading = find.text(kLabelSelectModelProvider);

    expect(providerHeading, findsOneWidget);
    expect(dropdownFinder, findsOneWidget);
    expect(find.text(kLabelSave), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Advanced settings'), findsOneWidget);
    expect(
      tester.getTopLeft(dropdownFinder).dy,
      greaterThan(tester.getTopLeft(providerHeading).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
