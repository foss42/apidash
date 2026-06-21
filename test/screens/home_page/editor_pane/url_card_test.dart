import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_portal/flutter_portal.dart';

import 'package:apidash/models/models.dart';
import 'test_utils.dart';

void main() {
  testWidgets('Testing EditorPaneRequestURLCard', (tester) async {
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
          collectionStateNotifierProvider.overrideWith(
              (ref) => MockCollectionStateNotifier({
                'test_id': const RequestModel(id: 'test_id', httpRequestModel: HttpRequestModel(url: 'https://api.apidash.dev'))
              })),
          environmentsStateNotifierProvider.overrideWith((ref) => MockEnvironmentsStateNotifier({
            'global': const EnvironmentModel(id: 'global', name: 'Global', values: [])
          })),
          environmentSequenceProvider.overrideWith((ref) => ['global']),
          activeEnvironmentIdStateProvider.overrideWith((ref) => 'global'),
        ],
        child: const MaterialApp(
          home: Portal(
            child: Scaffold(
              body: EditorPaneRequestURLCard(),
            ),
          ),
        ),
      ),
    );

    // Give time to render
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(URLTextField), findsOneWidget);
    expect(find.byType(DropdownButtonHTTPMethod), findsOneWidget);
    expect(find.byType(SendRequestButton), findsWidgets);
  });
}
