import 'package:apidash/consts.dart';
import 'package:apidash/widgets/dialog_export_doc.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_consts.dart';

void main() {
  final testRequest = HttpRequestModel(
    method: HTTPVerb.get,
    url: 'https://api.apidash.dev/users',
    headers: [const NameValueModel(name: 'Accept', value: 'application/json')],
  );

  final testResponse = HttpResponseModel(
    statusCode: 200,
    time: const Duration(milliseconds: 120),
    body: '{"id": 1, "name": "Jane"}',
    formattedBody: '{\n  "id": 1,\n  "name": "Jane"\n}',
    headers: {'content-type': 'application/json; charset=utf-8'},
  );

  testWidgets('ExportDocumentDialog renders with markdown preview by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: ExportDocumentDialog(
            request: testRequest,
            response: testResponse,
            requestName: 'Get Users',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify dialog title and segments
    expect(find.text('Export API Documentation'), findsOneWidget);
    expect(find.text('Markdown (.md)'), findsOneWidget);
    expect(find.text('cURL Session'), findsOneWidget);

    // Verify Action buttons
    expect(find.text('Copy to Clipboard'), findsOneWidget);
    expect(find.text('Save to File'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    // Verify Markdown content is visible in preview
    expect(find.textContaining('Get Users', findRichText: true), findsWidgets);
    expect(
      find.textContaining('https://api.apidash.dev/users', findRichText: true),
      findsWidgets,
    );
  });

  testWidgets(
    'ExportDocumentDialog switches preview between Markdown and cURL Session',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: ExportDocumentDialog(
              request: testRequest,
              response: testResponse,
              requestName: 'Get Users',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on cURL Session segment
      await tester.tap(find.text('cURL Session'));
      await tester.pumpAndSettle();

      // Verify cURL content is displayed
      expect(
        find.textContaining('curl -X', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('# Response: 200 OK', findRichText: true),
        findsOneWidget,
      );

      // Tap back to Markdown segment
      await tester.tap(find.text('Markdown (.md)'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('### Headers', findRichText: true),
        findsOneWidget,
      );
    },
  );

  testWidgets('ExportDocumentDialog invokes onCopy and shows SnackBar', (
    tester,
  ) async {
    String? copiedText;

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: ExportDocumentDialog(
            request: testRequest,
            response: testResponse,
            requestName: 'Get Users',
            onCopy: (content) async {
              copiedText = content;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Copy to Clipboard'));
    await tester.pumpAndSettle();

    expect(copiedText, isNotNull);
    expect(copiedText, contains('# Get Users'));
    expect(find.text(kMsgCopiedToClipboard), findsOneWidget);
  });

  testWidgets(
    'ExportDocumentDialog invokes onSaveToFile with suggested filename <request_name>_api_doc.md',
    (tester) async {
      String? savedContent;
      String? savedFileName;

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: ExportDocumentDialog(
              request: testRequest,
              response: testResponse,
              requestName: 'Get Users',
              onSaveToFile: (content, filename) async {
                savedContent = content;
                savedFileName = filename;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Save to File'));
      await tester.pumpAndSettle();

      expect(savedContent, isNotNull);
      expect(savedFileName, equals('get_users_api_doc.md'));
      expect(find.text('Saved to get_users_api_doc.md'), findsOneWidget);
    },
  );

  testWidgets(
    'ExportDocumentDialog falls back to api_doc.md when requestName is null',
    (tester) async {
      String? savedFileName;

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: ExportDocumentDialog(
              request: testRequest,
              response: testResponse,
              requestName: null,
              onSaveToFile: (content, filename) async {
                savedFileName = filename;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Save to File'));
      await tester.pumpAndSettle();

      expect(savedFileName, equals('api_doc.md'));
      expect(find.text('Saved to api_doc.md'), findsOneWidget);
    },
  );

  testWidgets(
    'showExportDocDialog displays and Close button dismisses dialog on desktop',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showExportDocDialog(
                      context,
                      request: testRequest,
                      response: testResponse,
                      requestName: 'Test Request',
                      isBottomSheet: false,
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Dialog is not shown yet
      expect(find.byType(AlertDialog), findsNothing);

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Export API Documentation'), findsOneWidget);

      // Tap Close button
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Dialog dismissed
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets('showExportDocDialog displays bottom sheet on mobile', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showExportDocDialog(
                    context,
                    request: testRequest,
                    response: testResponse,
                    requestName: 'Test Request',
                    isBottomSheet: true,
                  );
                },
                child: const Text('Open Sheet'),
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ExportDocumentDialog), findsNothing);

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.byType(ExportDocumentDialog), findsOneWidget);
    expect(find.text('Export API Documentation'), findsOneWidget);
    expect(find.text('Markdown (.md)'), findsOneWidget);
    expect(find.text('cURL Session'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(ExportDocumentDialog), findsNothing);
  });

  testWidgets('ExportDocumentSheet renders directly in bottom sheet mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: ExportDocumentSheet(
            request: testRequest,
            response: testResponse,
            requestName: 'Sheet Test',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ExportDocumentSheet), findsOneWidget);
    expect(find.text('Export API Documentation'), findsOneWidget);
    expect(find.text('Copy to Clipboard'), findsOneWidget);
    expect(find.text('Save to File'), findsOneWidget);
  });

  testWidgets(
    'ExportDocumentDialog copies cURL session and handles copy errors gracefully',
    (tester) async {
      String? copiedText;

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: ExportDocumentDialog(
              request: testRequest,
              response: testResponse,
              requestName: 'Get Users',
              onCopy: (content) async {
                copiedText = content;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Switch to cURL tab
      await tester.tap(find.text('cURL Session'));
      await tester.pumpAndSettle();

      // Copy cURL
      await tester.tap(find.text('Copy to Clipboard'));
      await tester.pumpAndSettle();

      expect(copiedText, isNotNull);
      expect(copiedText, contains('curl -X GET'));
      expect(copiedText, contains('# Response: 200 OK'));
      expect(find.text(kMsgCopiedToClipboard), findsOneWidget);

      // Test error handling on copy
      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: ExportDocumentDialog(
              request: testRequest,
              response: testResponse,
              requestName: 'Get Users',
              onCopy: (content) async {
                throw Exception('Clipboard error');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Copy to Clipboard'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Failed to copy: Exception: Clipboard error'),
        findsOneWidget,
      );
    },
  );

  testWidgets('ExportDocumentDialog renders 700x500 modal on desktop', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: ExportDocumentDialog(
            request: testRequest,
            response: testResponse,
            requestName: 'Get Users',
            isBottomSheet: false,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final sizedBoxFinder = find.byWidgetPredicate(
      (widget) =>
          widget is SizedBox && widget.width == 700.0 && widget.height == 500.0,
    );
    expect(sizedBoxFinder, findsOneWidget);
  });
}
