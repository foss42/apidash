import 'dart:io';
import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_download_doc_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_consts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDownloadsDir;

  setUp(() {
    tempDownloadsDir = Directory.systemTemp.createTempSync('dashbot_download');
  });

  tearDown(() {
    if (tempDownloadsDir.existsSync()) {
      tempDownloadsDir.deleteSync(recursive: true);
    }
  });

  group('DashbotDownloadDocButton', () {
    testWidgets('disables download when content is empty', (tester) async {
      const action = ChatAction(
        action: 'download_doc',
        target: 'code',
        path: 'doc',
        value: '',
        actionType: ChatActionType.downloadDoc,
        targetType: ChatActionTarget.code,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: DashbotDownloadDocButton(action: action),
            ),
          ),
        ),
      );

      final buttonFinder =
          find.byWidgetPredicate((widget) => widget is ButtonStyleButton);
      final button = tester.widget<ButtonStyleButton>(buttonFinder);
      expect(button.onPressed, isNull);
    });
    // TODO: Fix this test for downloading
    //   testWidgets('saves documentation to downloads directory', (tester) async {
    //     const action = ChatAction(
    //       action: 'download_doc',
    //       target: 'code',
    //       path: 'api-docs',
    //       value: '# Markdown',
    //       actionType: ChatActionType.downloadDoc,
    //       targetType: ChatActionTarget.code,
    //     );

    //     await tester.pumpWidget(
    //       ProviderScope(
    //         child: MaterialApp(
    //           theme: kThemeDataLight,
    //           home: const Scaffold(
    //             body: DashbotDownloadDocButton(action: action),
    //           ),
    //         ),
    //       ),
    //     );

    //     final buttonFinder =
    //         find.byWidgetPredicate((widget) => widget is ButtonStyleButton);
    //     final button = tester.widget<ButtonStyleButton>(buttonFinder);
    //     expect(button.onPressed, isNotNull);

    //     await tester.tap(find.text('Download Documentation'));
    //     await tester.pumpAndSettle();

    //     final savedPath =
    //         '${tempDownloadsDir.path}${Platform.pathSeparator}api-docs.md';
    //     final savedFile = File(savedPath);
    //     expect(savedFile.existsSync(), isTrue);
    //     expect(savedFile.readAsStringSync(), '# Markdown');
    //   });
  });
}
