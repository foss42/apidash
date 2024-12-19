import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_body.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/widgets/editor.dart';
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
            body: EditRequestBody()
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

    // Build the DropdownButtonHTTPMethod widget
    await tester.pumpWidget(
      ProviderScope(
          // ignore: deprecated_member_use
        parent: container,
        child: const MaterialApp(
          home: Scaffold(
            body: DropdownButtonHTTPMethod(),
          ),
        ),
      ),
    );
    expect(find.byType(DropdownButton<HTTPVerb>).hitTestable(), findsOneWidget);
    await tester.tap(find.byType(DropdownButton<HTTPVerb>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('GET').first);
    await tester.pumpAndSettle();

    // Build the EditRequestBody widget
    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use
        parent: container,
        child: const MaterialApp(
          home: Scaffold(
              body: EditRequestBody()
          ),
        ),
      ),
    );

    // Add a body to the request, which should trigger the method change
    await tester.enterText(find.byType(TextFieldEditor), 'new body added 2');
    await tester.pump(); // Process the state change

    // Verify that the request method does not change to POST
    expect(notifier.getRequestModel(id)!.httpRequestModel!.method, HTTPVerb.get);

  }, skip: false);
}
