import 'package:apidash/widgets/dialog_export_doc.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_consts.dart';

void main() {
  final testRequest = HttpRequestModel(
    method: HTTPVerb.get,
    url: 'https://api.apidash.dev/users',
    headers: [
      const NameValueModel(name: 'Accept', value: 'application/json'),
    ],
  );

  final testResponse = HttpResponseModel(
    statusCode: 200,
    time: const Duration(milliseconds: 120),
    body: '{"id": 1, "name": "Jane"}',
    formattedBody: '{\n  "id": 1,\n  "name": "Jane"\n}',
    headers: {
      'content-type': 'application/json; charset=utf-8',
    },
  );

  testWidgets('ExportDocumentDialog renders with markdown preview by default',
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

    // Verify dialog title and segments
    expect(find.text('Export API Documentation'), findsOneWidget);
    expect(find.text('Markdown (.md)'), findsOneWidget);
    expect(find.text('cURL Session'), findsOneWidget);

    // Verify Action buttons
    expect(find.text('Copy to Clipboard'), findsOneWidget);
    expect(find.text('Save to File'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    // Verify Markdown content is visible in preview
    expect(
      find.textContaining('Get Users', findRichText: true),
      findsWidgets,
    );
    expect(
      find.textContaining('https://api.apidash.dev/users', findRichText: true),
      findsWidgets,
    );
  });

  testWidgets('ExportDocumentDialog switches preview between Markdown and cURL Session',
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
  });

  testWidgets('ExportDocumentDialog invokes onCopy and shows SnackBar',
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

    await tester.tap(find.text('Copy to Clipboard'));
    await tester.pumpAndSettle();

    expect(copiedText, isNotNull);
    expect(copiedText, contains('# Get Users'));
    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  testWidgets('ExportDocumentDialog invokes onSaveToFile and shows SnackBar',
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
    expect(savedFileName, startsWith('get_users_'));
    expect(savedFileName, endsWith('.md'));
    expect(find.text('Saved to $savedFileName'), findsOneWidget);
  });

  testWidgets('showExportDocDialog displays and Close button dismisses dialog',
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
  });
}
