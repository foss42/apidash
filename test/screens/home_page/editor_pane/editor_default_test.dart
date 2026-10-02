import 'package:apidash/screens/home_page/editor_pane/editor_default.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpWorkspaceStorage();
  });

  testWidgets('Testing RequestEditorDefault', (tester) async {
    final container = createContainer();
    await ensureCollectionReady(container, tester);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: RequestEditorDefault())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Get Started with API Dash'), findsOneWidget);
    expect(
      find.text('Create your first API request to begin testing'),
      findsOneWidget,
    );
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Quick Tips'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
  });
}
