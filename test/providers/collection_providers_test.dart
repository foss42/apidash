import 'dart:io';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_body.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash/widgets/response_body.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  testWidgets(
      'Request method changes from GET to POST when body is added and Snackbar is shown',
      (WidgetTester tester) async {
    // Set up the test environment
    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    // Ensure the initial request is a GET request with no body
    final id = notifier.state!.entries.first.key;
    expect(
        notifier.getRequestModel(id)!.httpRequestModel!.method, HTTPVerb.get);
    expect(notifier.getRequestModel(id)!.httpRequestModel!.body, isNull);

    // Build the EditRequestBody widget
    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use
        parent: container,
        child: const MaterialApp(
          home: Scaffold(
            body: EditRequestBody(),
          ),
        ),
      ),
    );

    // Add a body to the request, which should trigger the method change
    await tester.enterText(find.byType(TextFieldEditor), 'new body added');
    await tester.pump(); // Process the state change

    // Verify that the request method changed to POST
    expect(
        notifier.getRequestModel(id)!.httpRequestModel!.method, HTTPVerb.post);

    // Verify that the Snackbar is shown
    expect(find.text('Switched to POST method'), findsOneWidget);
  }, skip: true);

  testWidgets('SSE Output is rendered correctly in UI',
      (WidgetTester tester) async {
    HttpOverrides.global = null; //enable networking in flutter_test

    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    const model = HttpRequestModel(
      url: 'https://sse-demo.netlify.app/sse',
      method: HTTPVerb.get,
    );

    notifier.addRequestModel(model, name: 'sseM');
    final id = notifier.state!.entries.last.key;

    //runAsync to enable user-code awaiting
    await tester.runAsync(() async {
      await notifier.sendRequest();
      await Future.delayed(const Duration(seconds: 3));
    });

    final rm = notifier.getRequestModel(id)!;
    cancelHttpRequest(rm.id);

    final sseOutput = (rm.httpResponseModel?.sseOutput ?? [])
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    expect(sseOutput, isNotEmpty, reason: 'No SSE Output found');

    // Render the widget
    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use
        parent: container,
        child: MaterialApp(
          home: Scaffold(
            body: ResponseBody(selectedRequestModel: rm),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    final matchingTextCount = textWidgets
        .where((text) =>
            text.data != null &&
            text.data!.startsWith('data') &&
            sseOutput.contains(text.data!.trim()))
        .length;

    expect(
      matchingTextCount,
      sseOutput.length,
      reason: 'UI does not match all SSE output lines',
    );

    // Waits for all provider actions to complete before exit
    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 2));
    });
  });
}
