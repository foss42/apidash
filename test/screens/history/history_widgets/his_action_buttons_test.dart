import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/history/history_widgets/his_action_buttons.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../providers/helpers.dart';

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
    httpResponseModel: HttpResponseModel(statusCode: 200),
  );

  group('HistoryActionButtons Tests', () {
    testWidgets('renders action buttons and handles state properly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {
                'req-1': RequestModel(
                  id: 'req-1',
                  httpRequestModel: HttpRequestModel(
                    url: 'https://example.com',
                    method: HTTPVerb.get,
                  ),
                ),
              }),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HistoryActionButtons(historyRequestModel: historyModel),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FilledButtonGroup), findsOneWidget);
      expect(find.text('Duplicate'), findsOneWidget);
      expect(find.text('Request'), findsOneWidget);

      await tester.tap(find.text('Duplicate'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request'));
      await tester.pumpAndSettle();
    });

    testWidgets('renders action buttons with missing request properly', (
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
            home: Scaffold(
              body: HistoryActionButtons(historyRequestModel: historyModel),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FilledButtonGroup), findsOneWidget);

      await tester.tap(find.text('Request'), warnIfMissed: false);
      await tester.pumpAndSettle();
    });

    testWidgets(
      'renders action buttons with null historyRequestModel properly',
      (tester) async {
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
                body: HistoryActionButtons(historyRequestModel: null),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(FilledButtonGroup), findsOneWidget);

        await tester.tap(find.text('Request'), warnIfMissed: false);
        await tester.tap(find.text('Duplicate'), warnIfMissed: false);
        await tester.pumpAndSettle();
      },
    );
  });
}
