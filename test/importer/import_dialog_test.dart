import 'dart:convert';
import 'dart:typed_data';

import 'package:apidash/consts.dart';
import 'package:apidash/importer/import_dialog.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/drag_and_drop_area.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCollectionStateNotifier
    extends StateNotifier<Map<String, RequestModel>?>
    implements CollectionStateNotifier {
  MockCollectionStateNotifier([super.state]);

  final List<(String?, HttpRequestModel)> addedRequests = [];

  @override
  void addRequestModel(HttpRequestModel httpRequestModel, {String? name}) {
    addedRequests.add((name, httpRequestModel));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockCollectionStateNotifier mockCollection;

  Future<void> pumpHome(
    WidgetTester tester, {
    ImportFormat format = ImportFormat.curl,
  }) async {
    mockCollection = MockCollectionStateNotifier({});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          collectionStateNotifierProvider.overrideWith(
            (ref) => mockCollection,
          ),
          importFormatStateProvider.overrideWith((ref) => format),
        ],
        child: MaterialApp(
          home: Scaffold(
            key: kHomeScaffoldKey,
            body: const Text('home'),
            drawer: Drawer(
              child: Consumer(
                builder: (context, ref, _) => Center(
                  child: ElevatedButton(
                    onPressed: () => importToCollectionPane(
                      context,
                      ref,
                      ScaffoldMessenger.of(context),
                    ),
                    child: const Text('Import'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    tester.state<ScaffoldState>(find.byKey(kHomeScaffoldKey)).openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();
  }

  XFile fileWith(String content, {required String name}) => XFile.fromData(
    Uint8List.fromList(utf8.encode(content)),
    path: name,
  );

  void dropFile(WidgetTester tester, XFile file) {
    tester
        .widget<DragAndDropArea>(find.byType(DragAndDropArea))
        .onFileDropped
        ?.call(file);
  }

  ScaffoldState scaffoldState(WidgetTester tester) =>
      tester.state<ScaffoldState>(find.byKey(kHomeScaffoldKey));

  testWidgets('import error is shown with the dialog and the drawer closed', (
    tester,
  ) async {
    await pumpHome(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(scaffoldState(tester).isDrawerOpen, isTrue);

    dropFile(tester, fileWith('this is not a curl command', name: 'bad.curl'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(scaffoldState(tester).isDrawerOpen, isFalse);
    expect(find.text('Unable to parse bad.curl'), findsOneWidget);
  });

  testWidgets('import success is shown with the dialog and the drawer closed', (
    tester,
  ) async {
    await pumpHome(tester);

    dropFile(tester, fileWith('curl https://example.com', name: 'ok.curl'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(scaffoldState(tester).isDrawerOpen, isFalse);
    expect(find.text('Successfully imported 1 requests'), findsOneWidget);
    expect(mockCollection.addedRequests, hasLength(1));
  });

  testWidgets('an import with no requests is reported with the overlays closed',
      (tester) async {
    await pumpHome(tester, format: ImportFormat.postman);

    dropFile(
      tester,
      fileWith(
        '{"info": {"name": "empty", "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"}, "item": []}',
        name: 'empty.json',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(scaffoldState(tester).isDrawerOpen, isFalse);
    expect(find.text('No requests imported'), findsOneWidget);
    expect(mockCollection.addedRequests, isEmpty);
  });

  testWidgets('a dialog dismissed while the file is parsed keeps the route '
      'below it', (tester) async {
    await pumpHome(tester);

    dropFile(tester, fileWith('this is not a curl command', name: 'bad.curl'));
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    expect(find.byKey(kHomeScaffoldKey), findsOneWidget);
    expect(find.text('Unable to parse bad.curl'), findsOneWidget);
  });
}
