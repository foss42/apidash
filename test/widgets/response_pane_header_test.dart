import 'package:apidash/consts.dart';
import 'package:apidash/widgets/dialog_export_doc.dart';
import 'package:apidash/widgets/response_pane_header.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_consts.dart';

void main() {
  final testRequest = const HttpRequestModel(
    method: HTTPVerb.get,
    url: 'https://api.apidash.dev/users',
    headers: [NameValueModel(name: 'Accept', value: 'application/json')],
  );

  final testResponse = const HttpResponseModel(
    statusCode: 200,
    time: Duration(milliseconds: 140),
    body: '{"message": "success"}',
    formattedBody: '{\n  "message": "success"\n}',
    headers: {'content-type': 'application/json'},
  );

  group('ResponsePaneHeader - Export Action Widget Tests', () {
    testWidgets(
      'Export button appears and is enabled when responseStatus is present',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: ResponsePaneHeader(
                responseStatus: 200,
                message: 'OK',
                time: const Duration(milliseconds: 140),
                onExportDoc: () {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify Export button is rendered with proper tooltip and icon
        final exportBtnFinder = find.widgetWithIcon(
          IconButton,
          Icons.description_outlined,
        );
        expect(exportBtnFinder, findsOneWidget);
        expect(find.byTooltip('Export API Documentation'), findsOneWidget);

        final iconBtn = tester.widget<IconButton>(exportBtnFinder);
        expect(iconBtn.onPressed, isNotNull);
      },
    );

    testWidgets(
      'Export button is disabled when responseStatus is null or non-positive',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: ResponsePaneHeader(
                responseStatus: null,
                message: null,
                time: null,
                onExportDoc: () {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final exportBtnFinder = find.widgetWithIcon(
          IconButton,
          Icons.description_outlined,
        );
        expect(exportBtnFinder, findsOneWidget);

        final iconBtn = tester.widget<IconButton>(exportBtnFinder);
        expect(iconBtn.onPressed, isNull);
      },
    );

    testWidgets('Clicking export button invokes onExportDoc callback', (
      tester,
    ) async {
      bool wasExportInvoked = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: ResponsePaneHeader(
              responseStatus: 200,
              message: 'OK',
              time: const Duration(milliseconds: 140),
              onExportDoc: () {
                wasExportInvoked = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final exportBtnFinder = find.widgetWithIcon(
        IconButton,
        Icons.description_outlined,
      );
      await tester.tap(exportBtnFinder);
      await tester.pumpAndSettle();

      expect(wasExportInvoked, isTrue);
    });

    testWidgets(
      'Clicking export button in ResponsePaneHeader opens ExportDocumentDialog and dismisses on Close',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ResponsePaneHeader(
                    responseStatus: 200,
                    message: 'OK',
                    time: const Duration(milliseconds: 140),
                    onExportDoc: () {
                      showExportDocDialog(
                        context,
                        request: testRequest,
                        response: testResponse,
                        requestName: 'Users List',
                        isBottomSheet: false,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(ExportDocumentDialog), findsNothing);

        // Tap export button to open dialog
        final exportBtnFinder = find.widgetWithIcon(
          IconButton,
          Icons.description_outlined,
        );
        await tester.tap(exportBtnFinder);
        await tester.pumpAndSettle();

        // Verify ExportDocumentDialog is visible
        expect(find.byType(ExportDocumentDialog), findsOneWidget);
        expect(find.text('Export API Documentation'), findsOneWidget);
        expect(
          find.textContaining('Users List', findRichText: true),
          findsWidgets,
        );

        // Tap Close button
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(find.byType(ExportDocumentDialog), findsNothing);
      },
    );

    testWidgets(
      'Integrated flow: open dialog from header, toggle tabs between Markdown and cURL, and copy',
      (tester) async {
        String? copiedContent;

        await tester.pumpWidget(
          MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ResponsePaneHeader(
                    responseStatus: 200,
                    message: 'OK',
                    time: const Duration(milliseconds: 140),
                    onExportDoc: () {
                      showExportDocDialog(
                        context,
                        request: testRequest,
                        response: testResponse,
                        requestName: 'Users List',
                        isBottomSheet: false,
                        onCopy: (content) async {
                          copiedContent = content;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 1. Open export dialog
        await tester.tap(
          find.widgetWithIcon(IconButton, Icons.description_outlined),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ExportDocumentDialog), findsOneWidget);

        // 2. Default preview is Markdown
        expect(
          find.textContaining('# Users List', findRichText: true),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            '`GET` `https://api.apidash.dev/users`',
            findRichText: true,
          ),
          findsOneWidget,
        );

        // 3. Copy Markdown content
        await tester.tap(find.text('Copy to Clipboard'));
        await tester.pumpAndSettle();
        expect(copiedContent, isNotNull);
        expect(copiedContent, contains('# Users List'));
        expect(copiedContent, contains('200 OK'));
        expect(find.text(kMsgCopiedToClipboard), findsOneWidget);

        // 4. Switch to cURL Session tab
        await tester.tap(find.text('cURL Session'));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('curl -X GET', findRichText: true),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            '# Response: 200 OK (140 ms)',
            findRichText: true,
          ),
          findsOneWidget,
        );

        // 5. Copy cURL content
        copiedContent = null;
        await tester.tap(find.text('Copy to Clipboard'));
        await tester.pumpAndSettle();
        expect(copiedContent, isNotNull);
        expect(copiedContent, contains('curl -X GET'));
        expect(copiedContent, contains('# Response: 200 OK'));

        // 6. Switch back to Markdown (.md) tab
        await tester.tap(find.text('Markdown (.md)'));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('# Users List', findRichText: true),
          findsOneWidget,
        );

        // 7. Close dialog
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();
        expect(find.byType(ExportDocumentDialog), findsNothing);
      },
    );
  });
}
