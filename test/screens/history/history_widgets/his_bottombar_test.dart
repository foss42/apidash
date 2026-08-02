import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/history/history_widgets/his_bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../providers/helpers.dart';

class MockHistoryMetaStateNotifier
    extends StateNotifier<Map<String, HistoryMetaModel>?>
    implements HistoryMetaStateNotifier {
  MockHistoryMetaStateNotifier([Map<String, HistoryMetaModel>? state])
    : super(state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final historyMeta = HistoryMetaModel(
    historyId: '1',
    requestId: 'req-1',
    timeStamp: DateTime.now(),
    method: HTTPVerb.get,
    url: 'https://example.com',
    apiType: APIType.rest,
    responseStatus: 200,
  );

  final historyModel = HistoryRequestModel(
    historyId: '1',
    metaData: historyMeta,
    httpResponseModel: HttpResponseModel(statusCode: 200),
  );

  group('HistoryPageBottombar Tests', () {
    testWidgets('renders HistoryPageBottombar properly in large window', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModel,
            ),
            historyMetaStateNotifier.overrideWith(
              (ref) => MockHistoryMetaStateNotifier({'1': historyMeta}),
            ),
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(home: Scaffold(body: HistoryPageBottombar())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistoryPageBottombar), findsOneWidget);
    });

    testWidgets('renders HistoryPageBottombar properly in medium window', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(700, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModel,
            ),
            historyMetaStateNotifier.overrideWith(
              (ref) => MockHistoryMetaStateNotifier({'1': historyMeta}),
            ),
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(home: Scaffold(body: HistoryPageBottombar())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistoryPageBottombar), findsOneWidget);
    });

    testWidgets('renders HistorySheetButton and handles click', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModel,
            ),
            historyMetaStateNotifier.overrideWith(
              (ref) => MockHistoryMetaStateNotifier({'1': historyMeta}),
            ),
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: HistorySheetButton(requestCount: 2)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistorySheetButton), findsOneWidget);
      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Modal bottom sheet should appear
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('renders HistorySheetButton properly when requestCount > 9', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModel,
            ),
            historyMetaStateNotifier.overrideWith(
              (ref) => MockHistoryMetaStateNotifier({'1': historyMeta}),
            ),
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: HistorySheetButton(requestCount: 15)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistorySheetButton), findsOneWidget);
      expect(find.text('9+'), findsOneWidget);
    });

    testWidgets('renders HistorySheetButton in compact window', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryRequestModelProvider.overrideWith(
              (ref) => historyModel,
            ),
            historyMetaStateNotifier.overrideWith(
              (ref) => MockHistoryMetaStateNotifier({'1': historyMeta}),
            ),
            selectedCollectionIdStateProvider.overrideWith((ref) => null),
            activeCollectionProvider.overrideWith(
              (ref) => MockActiveCollectionNotifier(ref, {}),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: HistorySheetButton(requestCount: 2)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HistorySheetButton), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
    });
  });
}
