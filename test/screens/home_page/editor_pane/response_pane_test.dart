import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('Testing ResponsePane with null HttpResponseModel', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          collectionStateNotifierProvider.overrideWith(
              (ref) => MockCollectionStateNotifier({
                'test_id': const RequestModel(id: 'test_id')
              })),
          environmentsStateNotifierProvider.overrideWith((ref) => MockEnvironmentsStateNotifier({
            'global': const EnvironmentModel(id: 'global', name: 'Global', values: [])
          })),
          environmentSequenceProvider.overrideWith((ref) => ['global']),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'global'),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ResponsePane(),
          ),
        ),
      ),
    );

    expect(find.byType(NotSentWidget), findsOneWidget);
  });

  testWidgets('Testing ResponsePane with working state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          collectionStateNotifierProvider.overrideWith(
              (ref) => MockCollectionStateNotifier({
                'test_id': const RequestModel(
                  id: 'test_id',
                  isWorking: true,
                )
              })),
          environmentsStateNotifierProvider.overrideWith((ref) => MockEnvironmentsStateNotifier({
            'global': const EnvironmentModel(id: 'global', name: 'Global', values: [])
          })),
          environmentSequenceProvider.overrideWith((ref) => ['global']),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'global'),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ResponsePane(),
          ),
        ),
      ),
    );

    expect(find.byType(SendingWidget), findsOneWidget);
  });

  testWidgets('Testing ResponsePane with error state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          collectionStateNotifierProvider.overrideWith(
              (ref) => MockCollectionStateNotifier({
                'test_id': const RequestModel(id: 'test_id', responseStatus: -1, message: 'Error')
              })),
          environmentsStateNotifierProvider.overrideWith((ref) => MockEnvironmentsStateNotifier({
            'global': const EnvironmentModel(id: 'global', name: 'Global', values: [])
          })),
          environmentSequenceProvider.overrideWith((ref) => ['global']),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'global'),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ResponsePane(),
          ),
        ),
      ),
    );

    expect(find.byType(ErrorMessage), findsOneWidget);
  });

  testWidgets('Testing ResponsePane with success state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          collectionStateNotifierProvider.overrideWith(
              (ref) => MockCollectionStateNotifier({
                'test_id': RequestModel(
                  id: 'test_id',
                  responseStatus: 200,
                  httpResponseModel: HttpResponseModel(
                    statusCode: 200,
                    body: 'Test body',
                    bodyBytes: Uint8List.fromList([84, 101, 115, 116, 32, 98, 111, 100, 121]),
                    headers: const {'test': 'header'},
                    requestHeaders: const {'req': 'header'},
                    time: const Duration(milliseconds: 100),
                  ),
                )
              })),
          environmentsStateNotifierProvider.overrideWith((ref) => MockEnvironmentsStateNotifier({
            'global': const EnvironmentModel(id: 'global', name: 'Global', values: [])
          })),
          environmentSequenceProvider.overrideWith((ref) => ['global']),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'global'),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ResponsePane(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ResponseDetails), findsOneWidget);
    expect(find.byType(ResponsePaneHeader), findsOneWidget);
    expect(find.byType(ResponseTabs), findsOneWidget);
  });
}
