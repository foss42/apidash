import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/history/history_widgets/his_url_card.dart';

import '../../../models/history_models.dart';
import '../../../providers/helpers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

void main() {
  group('Testing HistoryURLCard', () {
    final historyRequestModel = historyRequestModel1;

    testWidgets('Testing with given HistoryRequestModel', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryURLCard(historyRequestModel: historyRequestModel),
          ),
        ),
      );

      expect(find.byType(HistoryURLCard), findsOneWidget);
    });

    testWidgets('Testing if displays correct request method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryURLCard(historyRequestModel: historyRequestModel),
          ),
        ),
      );

      expect(
        find.text(
          historyRequestModel.httpRequestModel!.method.name.toUpperCase(),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Testing if displays correct URL', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryURLCard(historyRequestModel: historyRequestModel),
          ),
        ),
      );

      expect(
        find.text(historyRequestModel.httpRequestModel!.url),
        findsOneWidget,
      );
    });

    testWidgets('Testing HistoryURLCard for AI API correctly', (tester) async {
      final aiHistoryModel = HistoryRequestModel(
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
        aiRequestModel: AIRequestModel(
          systemPrompt: 'system',
          userPrompt: 'hi',
        ),
        httpResponseModel: HttpResponseModel(statusCode: 200),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HistoryURLCard(historyRequestModel: aiHistoryModel),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AIModelSelector), findsOneWidget);
    });

    testWidgets('Testing HistoryURLCard in compact mode correctly', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(300, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HistoryURLCard(historyRequestModel: historyRequestModel),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistoryURLCard), findsOneWidget);
    });

    testWidgets('Testing HistoryURLCard with null historyRequestModel', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: HistoryURLCard(historyRequestModel: null)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistoryURLCard), findsOneWidget);
    });

    testWidgets('Testing HistoryURLCard in expanded mode', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HistoryURLCard(historyRequestModel: historyRequestModel),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistoryURLCard), findsOneWidget);
    });
  });
}
