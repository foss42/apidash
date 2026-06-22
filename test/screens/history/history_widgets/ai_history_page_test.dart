import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/history/history_widgets/ai_history_page.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final historyModelNullAI = HistoryRequestModel(
    historyId: '1',
    metaData: HistoryMetaModel(
      historyId: '1',
      requestId: 'req-1',
      timeStamp: DateTime.now(),
      method: HTTPVerb.get,
      url: 'https://example.com',
      apiType: APIType.rest,
      responseStatus: 200,
    ),
    httpResponseModel: HttpResponseModel(statusCode: 200),
    aiRequestModel: null,
  );

  final historyModelWithAI = HistoryRequestModel(
    historyId: '2',
    metaData: HistoryMetaModel(
      historyId: '2',
      requestId: 'req-2',
      timeStamp: DateTime.now(),
      method: HTTPVerb.post,
      url: 'https://example.com/ai',
      apiType: APIType.ai,
      responseStatus: 200,
    ),
    httpResponseModel: HttpResponseModel(statusCode: 200),
    aiRequestModel: AIRequestModel(
      apiKey: 'test-api-key',
      systemPrompt: 'You are a helpful assistant.',
      userPrompt: 'Hello!',
      modelConfigs: [
        ModelConfig(
          id: 'temperature',
          name: 'Temperature',
          description: 'Controls randomness',
          type: ConfigType.slider,
          value: ConfigSliderValue(value: (0.0, 0.7, 1.0)),
        ),
        ModelConfig(
          id: 'max_tokens',
          name: 'Max Tokens',
          description: 'Max tokens to generate',
          type: ConfigType.numeric,
          value: ConfigNumericValue(value: 100),
        ),
        ModelConfig(
          id: 'stream',
          name: 'Stream',
          description: 'Stream response',
          type: ConfigType.boolean,
          value: ConfigBooleanValue(value: true),
        ),
        ModelConfig(
          id: 'custom',
          name: 'Custom String',
          description: 'Custom string parameter',
          type: ConfigType.text,
          value: ConfigTextValue(value: 'test'),
        ),
      ],
    ),
  );

  group('HisAIRequestPromptSection Tests', () {
    testWidgets('renders empty when aiRequestModel is null', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModelNullAI,
            ),
          ],
          child: MaterialApp(home: Scaffold(body: HisAIRequestPromptSection())),
        ),
      );

      expect(find.byType(TextFieldEditor), findsNothing);
    });

    testWidgets('renders properly with aiRequestModel', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModelWithAI,
            ),
          ],
          child: MaterialApp(home: Scaffold(body: HisAIRequestPromptSection())),
        ),
      );

      expect(find.byType(TextFieldEditor), findsNWidgets(2));
      expect(find.text('System Prompt'), findsOneWidget);
      expect(find.text('User Prompt / Input'), findsOneWidget);
    });
  });

  group('HisAIRequestAuthorizationSection Tests', () {
    testWidgets('renders empty when aiRequestModel is null', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModelNullAI,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: HisAIRequestAuthorizationSection()),
          ),
        ),
      );

      expect(find.byType(TextFieldEditor), findsNothing);
    });

    testWidgets('renders properly with aiRequestModel', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModelWithAI,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: HisAIRequestAuthorizationSection()),
          ),
        ),
      );

      expect(find.byType(TextFieldEditor), findsOneWidget);
    });
  });

  group('HisAIRequestConfigSection Tests', () {
    testWidgets('renders empty when aiRequestModel is null', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModelNullAI,
            ),
          ],
          child: MaterialApp(home: Scaffold(body: HisAIRequestConfigSection())),
        ),
      );

      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('renders properly with aiRequestModel', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModelWithAI,
            ),
          ],
          child: MaterialApp(home: Scaffold(body: HisAIRequestConfigSection())),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(4));
      expect(find.text('Temperature'), findsOneWidget);
      expect(find.text('Max Tokens'), findsOneWidget);
      expect(find.text('Stream'), findsOneWidget);
      expect(find.text('Custom String'), findsOneWidget);
    });
  });
}
