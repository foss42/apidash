import 'package:apidash/widgets/button_share.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ShareButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ShareButton(toShare: 'test content')),
      ),
    );

    expect(find.byType(ShareButton), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
  });

  testWidgets('ShareButton tap triggers onPressed logic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ShareButton(toShare: 'test content')),
      ),
    );

    // Tap the button. We just want to ensure it doesn't crash when pressed.
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (MethodCall methodCall) async {
        return null; // Simulate success
      },
    );

    await tester.tap(find.byType(ShareButton));
    await tester.pumpAndSettle();

    // Now test the error case
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (MethodCall methodCall) async {
        throw Exception('Simulated share error');
      },
    );

    await tester.tap(find.byType(ShareButton));
    await tester.pumpAndSettle();

    expect(find.text(kMsgShareError), findsOneWidget);

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      null,
    );
  });
}
