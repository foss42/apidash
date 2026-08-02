import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/details_card.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'package:apidash/models/models.dart';
import 'test_utils.dart';

void main() {
  testWidgets('Testing EditorPaneRequestDetailsCard with dashbot not popped', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          dashbotWindowNotifierProvider.overrideWith(
            (ref) => DashbotWindowNotifier()..togglePopped(),
          ),
          chatViewmodelProvider.overrideWith((ref) => DummyChatViewmodel(ref)),
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
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
          home: Portal(child: Scaffold(body: EditorPaneRequestDetailsCard())),
        ),
      ),
    );

    expect(find.byType(EditRequestPane), findsOneWidget);
    expect(find.byType(DashbotTab), findsOneWidget);
  });

  testWidgets('Testing EditorPaneRequestDetailsCard with code pane visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
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
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
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
          home: Portal(child: Scaffold(body: EditorPaneRequestDetailsCard())),
        ),
      ),
    );

    expect(find.byType(EditRequestPane), findsOneWidget);
    expect(find.byType(CodePane), findsOneWidget);
  });

  testWidgets('Testing EditorPaneRequestDetailsCard with response pane', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
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
          codePaneVisibleStateProvider.overrideWith((ref) => false),
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
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
          home: Portal(child: Scaffold(body: EditorPaneRequestDetailsCard())),
        ),
      ),
    );

    expect(find.byType(EditRequestPane), findsOneWidget);
    expect(find.byType(ResponsePane), findsOneWidget);
  });
}
