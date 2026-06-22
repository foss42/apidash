import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_request.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/request_editor_top_bar.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/details_card.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_portal/flutter_portal.dart';

import 'test_utils.dart';
import 'package:apidash/models/models.dart';

void main() {
  testWidgets('Testing RequestEditor medium window', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

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
          home: Portal(child: Scaffold(body: RequestEditor())),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(EditRequestPane), findsOneWidget);
  });

  testWidgets('Testing RequestEditor large window', (tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          dashbotWindowNotifierProvider.overrideWith(
            (ref) => DashbotWindowNotifier(),
          ),
          chatViewmodelProvider.overrideWith((ref) => DummyChatViewmodel(ref)),
          codePaneVisibleStateProvider.overrideWith((ref) => true),
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
          home: Portal(child: Scaffold(body: RequestEditor())),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(RequestEditorTopBar), findsOneWidget);
    expect(find.byType(EditorPaneRequestURLCard), findsOneWidget);
    expect(find.byType(EditorPaneRequestDetailsCard), findsOneWidget);
  });
}
