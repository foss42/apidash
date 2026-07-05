import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/history/history_widgets/his_request_pane.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final restHistoryModel = HistoryRequestModel(
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
    httpRequestModel: HttpRequestModel(
      url: 'https://example.com',
      method: HTTPVerb.get,
      params: [NameValueModel(name: 'q', value: '1')],
      headers: [NameValueModel(name: 'h', value: '2')],
      body: '{"test": 1}',
      bodyContentType: ContentType.json,
    ),
    httpResponseModel: HttpResponseModel(statusCode: 200),
  );

  final graphqlHistoryModel = HistoryRequestModel(
    historyId: '2',
    metaData: HistoryMetaModel(
      historyId: '2',
      requestId: 'req-2',
      timeStamp: DateTime.now(),
      method: HTTPVerb.post,
      url: 'https://example.com/graphql',
      apiType: APIType.graphql,
      responseStatus: 200,
    ),
    httpRequestModel: HttpRequestModel(
      url: 'https://example.com/graphql',
      method: HTTPVerb.post,
      query: 'query { user { id } }',
    ),
    httpResponseModel: HttpResponseModel(statusCode: 200),
  );

  final aiHistoryModel = HistoryRequestModel(
    historyId: '3',
    metaData: HistoryMetaModel(
      historyId: '3',
      requestId: 'req-3',
      timeStamp: DateTime.now(),
      method: HTTPVerb.post,
      url: 'https://example.com/ai',
      apiType: APIType.ai,
      responseStatus: 200,
    ),
    aiRequestModel: AIRequestModel(systemPrompt: 'system', userPrompt: 'hi'),
    httpResponseModel: HttpResponseModel(statusCode: 200),
  );

  group('HistoryRequestPane Tests', () {
    testWidgets('renders HistoryRequestPane for REST API correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryIdStateProvider.overrideWith((ref) => '1'),
            historyCodePaneVisibleStateProvider.overrideWith((ref) => false),
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => restHistoryModel,
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: HistoryRequestPane())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RequestPane), findsOneWidget);
      expect(find.text(kLabelURLParams), findsOneWidget);
      expect(find.text(kLabelHeaders), findsOneWidget);
      expect(find.text(kLabelBody), findsOneWidget);
    });

    testWidgets('renders HistoryRequestPane for GraphQL API correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryIdStateProvider.overrideWith((ref) => '2'),
            historyCodePaneVisibleStateProvider.overrideWith((ref) => false),
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => graphqlHistoryModel,
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: HistoryRequestPane())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RequestPane), findsOneWidget);
      expect(find.text(kLabelQuery), findsOneWidget);
    });

    testWidgets('renders HistoryRequestPane for AI API correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryIdStateProvider.overrideWith((ref) => '3'),
            historyCodePaneVisibleStateProvider.overrideWith((ref) => false),
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => aiHistoryModel,
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: HistoryRequestPane())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RequestPane), findsOneWidget);
      expect(find.text(kLabelPrompts), findsOneWidget);
    });
  });

  group('HisRequestBody Tests', () {
    testWidgets('renders HisRequestBody for REST (json) correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => restHistoryModel,
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: HisRequestBody())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
      expect(find.byType(JsonTextFieldEditor), findsOneWidget);
    });

    testWidgets('renders HisRequestBody for GraphQL (query) correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => graphqlHistoryModel,
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: HisRequestBody())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextFieldEditor), findsOneWidget);
    });

    testWidgets('renders HisRequestBody for REST (formdata) correctly', (
      tester,
    ) async {
      final formdataModel = HistoryRequestModel(
        historyId: '4',
        metaData: HistoryMetaModel(
          historyId: '4',
          requestId: 'req-4',
          timeStamp: DateTime.now(),
          method: HTTPVerb.post,
          url: 'https://example.com',
          apiType: APIType.rest,
          responseStatus: 200,
        ),
        httpRequestModel: HttpRequestModel(
          url: 'https://example.com',
          method: HTTPVerb.post,
          bodyContentType: ContentType.formdata,
          formData: [
            FormDataModel(name: 'a', value: 'b', type: FormDataType.text),
          ],
        ),
        httpResponseModel: HttpResponseModel(statusCode: 200),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => formdataModel,
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: HisRequestBody())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
      expect(find.byType(RequestFormDataTable), findsOneWidget);
    });
  });
}
