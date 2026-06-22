import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_default.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_request.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_portal/flutter_portal.dart';

import 'package:apidash/models/models.dart';
import 'test_utils.dart';

void main() {
  testWidgets('Testing RequestEditorPane with no selectedId', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => null),
          environmentsStateNotifierProvider.overrideWith(
            (ref) => MockEnvironmentsStateNotifier({
              'global': const EnvironmentModel(
                id: 'global',
                name: 'Global',
                values: [],
              ),
            }),
          ),
          environmentSequenceProvider.overrideWith((ref) => ['global']),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'global'),
        ],
        child: const MaterialApp(
          home: Portal(child: Scaffold(body: RequestEditorPane())),
        ),
      ),
    );

    expect(find.byType(RequestEditorDefault), findsOneWidget);
  });

  testWidgets('Testing RequestEditorPane with selectedId', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          collectionStateNotifierProvider.overrideWith(
            (ref) => MockCollectionStateNotifier({
              'test_id': const RequestModel(
                id: 'test_id',
                httpRequestModel: HttpRequestModel(),
              ),
            }),
          ),
          environmentsStateNotifierProvider.overrideWith(
            (ref) => MockEnvironmentsStateNotifier({
              'global': const EnvironmentModel(
                id: 'global',
                name: 'Global',
                values: [],
              ),
            }),
          ),
          environmentSequenceProvider.overrideWith((ref) => ['global']),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'global'),
        ],
        child: const MaterialApp(
          home: Portal(child: Scaffold(body: RequestEditorPane())),
        ),
      ),
    );

    expect(find.byType(RequestEditor), findsOneWidget);
  });
}
