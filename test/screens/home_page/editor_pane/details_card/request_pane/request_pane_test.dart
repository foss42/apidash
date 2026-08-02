import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane_rest.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane_graphql.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request/request_pane_ai.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../test_utils.dart';
import 'package:apidash/models/models.dart';

void main() {
  testWidgets('Testing EditRequestPane with Dashbot popped and REST API', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          dashbotWindowNotifierProvider.overrideWith(
            (ref) => DashbotWindowNotifier(),
          ),
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
              'test_id': const RequestModel(
                id: 'test_id',
                apiType: APIType.rest,
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
          home: Portal(child: Scaffold(body: EditRequestPane())),
        ),
      ),
    );

    expect(find.byType(EditRestRequestPane), findsOneWidget);
  });

  testWidgets('Testing EditRequestPane with Dashbot popped and GraphQL API', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          dashbotWindowNotifierProvider.overrideWith(
            (ref) => DashbotWindowNotifier(),
          ),
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
              'test_id': const RequestModel(
                id: 'test_id',
                apiType: APIType.graphql,
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
          home: Portal(child: Scaffold(body: EditRequestPane())),
        ),
      ),
    );

    expect(find.byType(EditGraphQLRequestPane), findsOneWidget);
  });

  testWidgets('Testing EditRequestPane with Dashbot popped and AI API', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          dashbotWindowNotifierProvider.overrideWith(
            (ref) => DashbotWindowNotifier(),
          ),
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
              'test_id': const RequestModel(id: 'test_id', apiType: APIType.ai),
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
          home: Portal(child: Scaffold(body: EditRequestPane())),
        ),
      ),
    );

    expect(find.byType(EditAIRequestPane), findsOneWidget);
  });

  testWidgets('Testing EditRequestPane with Dashbot NOT popped', (
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
            (ref) => DashbotWindowNotifier()..togglePopped(),
          ),
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
              'test_id': const RequestModel(
                id: 'test_id',
                apiType: APIType.rest,
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
          home: Portal(child: Scaffold(body: EditRequestPane())),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(EditRestRequestPane), findsOneWidget);

    // Tap Response
    await tester.tap(find.text('Response'));
    await tester.pumpAndSettle();
    expect(find.byType(ResponsePane), findsOneWidget);

    // Tap Code
    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();
    expect(find.byType(CodePane), findsOneWidget);
  });
}
