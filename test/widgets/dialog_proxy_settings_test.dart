import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('ProxySettingsDialog shows correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ProxySettingsDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog is shown
    expect(find.byType(ProxySettingsDialog), findsOneWidget);
    expect(find.text('Proxy Settings'), findsOneWidget);
    expect(find.text('Proxy Host'), findsOneWidget);
    expect(find.text('Proxy Port'), findsOneWidget);
    expect(find.text('Username (Optional)'), findsOneWidget);
    expect(find.text('Password (Optional)'), findsOneWidget);
  });

  testWidgets('ProxySettingsDialog saves settings', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ProxySettingsDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Enter proxy settings
    await tester.enterText(find.widgetWithText(TextField, 'Proxy Host'), 'localhost');
    await tester.enterText(find.widgetWithText(TextField, 'Proxy Port'), '8080');
    await tester.enterText(find.widgetWithText(TextField, 'Username (Optional)'), 'user');
    await tester.enterText(find.widgetWithText(TextField, 'Password (Optional)'), 'pass');

    // Save settings
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify dialog is closed
    expect(find.byType(ProxySettingsDialog), findsNothing);
  });

  testWidgets('ProxySettingsDialog cancels without saving', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ProxySettingsDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Enter proxy settings
    await tester.enterText(find.widgetWithText(TextField, 'Proxy Host'), 'localhost');
    await tester.enterText(find.widgetWithText(TextField, 'Proxy Port'), '8080');

    // Cancel without saving
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify dialog is closed
    expect(find.byType(ProxySettingsDialog), findsNothing);
  });
}
