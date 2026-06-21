import 'package:apidash/screens/home_page/editor_pane/editor_default.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apidash/models/models.dart';
import 'test_utils.dart';

void main() {
  testWidgets('Testing RequestEditorDefault', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          collectionStateNotifierProvider.overrideWith(
              (ref) => MockCollectionStateNotifier({})),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: RequestEditorDefault(),
          ),
        ),
      ),
    );

    expect(find.text('Get Started with API Dash'), findsOneWidget);
    expect(find.text('Create your first API request to begin testing'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Quick Tips'), findsOneWidget);

    // Tap + New
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
  });
}
