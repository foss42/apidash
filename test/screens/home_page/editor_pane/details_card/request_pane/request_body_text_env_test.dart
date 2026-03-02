import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_body.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  testWidgets('EditRequestBody uses EnvironmentTriggerField for text body',
      (WidgetTester tester) async {
    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);
    final id = notifier.state!.entries.first.key;

    notifier.update(id: id, bodyContentType: ContentType.text);

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: const Portal(
          child: MaterialApp(
            home: Scaffold(
              body: EditRequestBody(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(EnvironmentTriggerField), findsOneWidget);
    expect(find.byType(TextFieldEditor), findsNothing);
  });
}
