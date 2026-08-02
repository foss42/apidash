import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/screens/home_page/editor_pane/request_editor_top_bar.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'test_utils.dart';

void main() {
  testWidgets('Testing RequestEditorTopBar', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedIdStateProvider.overrideWith((ref) => 'test_id'),
          selectedCollectionIdStateProvider.overrideWith((ref) => null),
          activeCollectionProvider.overrideWith(
            (ref) => MockActiveCollectionNotifier(ref, {
              'test_id': const RequestModel(
                id: 'test_id',
                name: 'Test Request Name',
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
          home: Portal(child: Scaffold(body: RequestEditorTopBar())),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(APITypeDropdown), findsOneWidget);
    expect(find.text('Test Request Name'), findsOneWidget);
    expect(find.byType(EditorTitleActions), findsOneWidget);
    expect(find.byType(EnvironmentDropdown), findsOneWidget);
  });
}
