import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/intro_message.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  testWidgets('Testing Intro Message', (tester) async {
    PackageInfo.setMockInitialValues(
        appName: 'API Dash',
        packageName: 'dev.apidash.apidash',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: 'buildSignature');
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Intro Message',
        home: Scaffold(
          body: IntroMessage(),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Welcome to API Dash ⚡️'), findsOneWidget);

    expect(find.byType(RichText), findsAtLeastNWidgets(1));
    expect(
        find.textContaining("Please support this project by giving us a ",
            findRichText: true),
        findsOneWidget);

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('Star on GitHub'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.star));
  });
}
