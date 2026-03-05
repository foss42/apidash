import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/collection_pane.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../providers/helpers.dart';

const _restRequest = RequestModel(
  id: 'rest_id_1',
  name: 'My REST Request',
  apiType: APIType.rest,
  httpRequestModel: HttpRequestModel(
    method: HTTPVerb.get,
    url: 'https://api.github.com',
  ),
);

const _aiRequest = RequestModel(
  id: 'ai_id_1',
  name: 'My AI Request',
  apiType: APIType.ai,
  httpRequestModel: null,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  Widget buildWithOverrides({
    required Map<String, RequestModel> collection,
    required List<String> sequence,
    String filterQuery = '',
  }) {
    return ProviderScope(
      overrides: [
        collectionStateNotifierProvider.overrideWith(
          (ref) =>
              CollectionStateNotifier(ref, hiveHandler)..state = collection,
        ),
        requestSequenceProvider.overrideWith((ref) => sequence),
        collectionSearchQueryProvider.overrideWith((ref) => filterQuery),
      ],
      child: const MaterialApp(home: Scaffold(body: RequestList())),
    );
  }

  testWidgets('does not crash when searching with AI request in collection',
      (tester) async {
    await tester.pumpWidget(buildWithOverrides(
      collection: {
        'rest_id_1': _restRequest,
        'ai_id_1': _aiRequest,
      },
      sequence: ['rest_id_1', 'ai_id_1'],
      filterQuery: 'test',
    ));
    await tester.pump();

    expect(find.byType(RequestItem), findsNothing);
  });

  testWidgets('filters AI requests by name when httpRequestModel is null',
      (tester) async {
    await tester.pumpWidget(buildWithOverrides(
      collection: {'ai_id_1': _aiRequest},
      sequence: ['ai_id_1'],
      filterQuery: 'ai request',
    ));
    await tester.pump();

    expect(find.byType(RequestItem), findsOneWidget);
  });

  testWidgets('filters HTTP requests by URL', (tester) async {
    await tester.pumpWidget(buildWithOverrides(
      collection: {'rest_id_1': _restRequest},
      sequence: ['rest_id_1'],
      filterQuery: 'github',
    ));
    await tester.pump();

    expect(find.byType(RequestItem), findsOneWidget);
  });
}
