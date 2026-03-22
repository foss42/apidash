import 'package:apidash/dashbot/widgets/openapi_operation_picker_dialog.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _emptySpecJson = '''
{
  "openapi": "3.0.0",
  "info": {"title": "Empty", "version": "1.0.0"},
  "paths": {}
}
''';

const _sampleSpecJson = '''
{
  "openapi": "3.0.0",
  "info": {"title": "Sample", "version": "1.0.0"},
  "paths": {
    "/users": {
      "get": {"responses": {"200": {"description": "ok"}}},
      "post": {"responses": {"201": {"description": "created"}}}
    }
  }
}
''';

void main() {
  OpenApi _parse(String json) => OpenApi.fromString(source: json, format: null);

  testWidgets('returns empty selection when spec has no operations',
      (tester) async {
    final spec = _parse(_emptySpecJson);

    List<OpenApiOperationItem>? resolved;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            showOpenApiOperationPickerDialog(
              context: context,
              spec: spec,
              sourceName: 'Empty spec',
            ).then((value) => resolved = value);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await tester.pump();

    expect(resolved, isNotNull);
    expect(resolved, isEmpty);
  });

  testWidgets('allows toggling select-all and individual operations',
      (tester) async {
    final spec = _parse(_sampleSpecJson);

    late Future<List<OpenApiOperationItem>?> dialogFuture;

    final binding = tester.binding;
    await binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    dialogFuture = showOpenApiOperationPickerDialog(
                      context: context,
                      spec: spec,
                      sourceName: 'Sample spec',
                    );
                  },
                  child: const Text('Launch dialog'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Launch dialog'));
    await tester.pumpAndSettle();

    final selectAllFinder = find.widgetWithText(CheckboxListTile, 'Select all');
    final importFinder = find.widgetWithText(FilledButton, 'Import');

    // Initial state: everything selected → import enabled
    expect(
      tester.widget<FilledButton>(importFinder).onPressed,
      isNotNull,
    );

    // Toggle "Select all" off → deselect everything & disable import
    await tester.tap(selectAllFinder);
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(importFinder).onPressed,
      isNull,
    );

    // Toggle "Select all" back on → reselect all and enable import
    await tester.tap(selectAllFinder);
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(importFinder).onPressed,
      isNotNull,
    );

    final usersOpFinder = find.text('GET /users');
    expect(usersOpFinder, findsOneWidget);

    // Uncheck a single operation → coverage for removal branch
    await tester.tap(usersOpFinder);
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(importFinder).onPressed,
      isNotNull,
    );

    // Check it again → coverage for addition branch
    await tester.tap(usersOpFinder);
    await tester.pumpAndSettle();

    await tester.tap(importFinder);
    await tester.pumpAndSettle();

    final result = await dialogFuture;
    expect(result, isNotNull);
    expect(result, hasLength(2));
    expect(result!.map((item) => item.method), containsAll(['GET', 'POST']));
  });

  testWidgets('returns null when cancelled', (tester) async {
    final spec = _parse(_sampleSpecJson);

    late Future<List<OpenApiOperationItem>?> dialogFuture;

    final binding = tester.binding;
    await binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    dialogFuture = showOpenApiOperationPickerDialog(
                      context: context,
                      spec: spec,
                      sourceName: 'Sample spec',
                    );
                  },
                  child: const Text('Launch dialog'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Launch dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    final result = await dialogFuture;
    expect(result, isNull);
  });
}
