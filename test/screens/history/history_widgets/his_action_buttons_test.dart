import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/history/history_widgets/his_action_buttons.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCollectionStateNotifier extends StateNotifier<Map<String, RequestModel>?> implements CollectionStateNotifier {
  MockCollectionStateNotifier([Map<String, RequestModel>? state]) : super(state);

  @override
  void duplicateFromHistory(HistoryRequestModel historyModel) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final historyModel = HistoryRequestModel(
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
    httpResponseModel: HttpResponseModel(
      statusCode: 200,
    ),
  );

  group('HistoryActionButtons Tests', () {
    testWidgets('renders action buttons and handles state properly', (tester) async {
      final mockStateNotifier = MockCollectionStateNotifier({
        'req-1': RequestModel(
          id: 'req-1',
          httpRequestModel: HttpRequestModel(
            url: 'https://example.com',
            method: HTTPVerb.get,
          ),
        ),
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            collectionStateNotifierProvider.overrideWith((ref) => mockStateNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HistoryActionButtons(
                historyRequestModel: historyModel,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FilledButtonGroup), findsOneWidget);
      expect(find.text('Duplicate'), findsOneWidget);
      expect(find.text('Request'), findsOneWidget);

      // Tap duplicate
      await tester.tap(find.text('Duplicate'));
      await tester.pumpAndSettle();

      // Tap Request
      await tester.tap(find.text('Request'));
      await tester.pumpAndSettle();
    });

    testWidgets('renders action buttons with missing request properly', (tester) async {
      final mockStateNotifier = MockCollectionStateNotifier({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            collectionStateNotifierProvider.overrideWith((ref) => mockStateNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HistoryActionButtons(
                historyRequestModel: historyModel,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FilledButtonGroup), findsOneWidget);
      
      // Tap Request (should be disabled)
      await tester.tap(find.text('Request'), warnIfMissed: false);
      await tester.pumpAndSettle();
    });

    testWidgets('renders action buttons with null historyRequestModel properly', (tester) async {
      final mockStateNotifier = MockCollectionStateNotifier({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            collectionStateNotifierProvider.overrideWith((ref) => mockStateNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HistoryActionButtons(
                historyRequestModel: null,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FilledButtonGroup), findsOneWidget);
      
      // Tap Request (should be disabled)
      await tester.tap(find.text('Request'), warnIfMissed: false);
      // Tap Duplicate (should be disabled)
      await tester.tap(find.text('Duplicate'), warnIfMissed: false);
      await tester.pumpAndSettle();
    });
  });
}
