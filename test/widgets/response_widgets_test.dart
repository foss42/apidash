import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/response_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing Sending Widget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Send',
        theme: kThemeDataDark,
        home: const Scaffold(
          body: SendingWidget(),
        ),
      ),
    );

    expect(find.byType(Lottie), findsOneWidget);
  });
  testWidgets('Testing Not Sent Widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Not Sent',
        home: Scaffold(
          body: NotSentWidget(),
        ),
      ),
    );

    expect(find.byIcon(Icons.north_east_rounded), findsOneWidget);
    expect(find.text('Not Sent'), findsOneWidget);
  });
  testWidgets('Testing Response Pane Header', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Pane Header',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponsePaneHeader(
              responseStatus: 200,
              message: 'Hi',
              time: Duration(microseconds: 23)),
        ),
      ),
    );

    expect(find.byType(RichText), findsAtLeastNWidgets(1));
    expect(
        find.textContaining("Response (", findRichText: true), findsOneWidget);
    expect(find.text('Hi'), findsOneWidget);
    expect(find.textContaining("200", findRichText: true), findsOneWidget);
    expect(find.text(humanizeDuration(const Duration(microseconds: 23))),
        findsOneWidget);
  });
  testWidgets('Testing Response Tab View', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Tab View',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponseTabView(
              activeId: '1', children: [Text('first'), Text('second')]),
        ),
      ),
    );

    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Headers'), findsOneWidget);

    await tester.tap(find.text('Headers'));
    await tester.pumpAndSettle();

    expect(find.text('first'), findsNothing);
    expect(find.text('second'), findsOneWidget);
    await tester.tap(find.text('Body'));
    await tester.pumpAndSettle();

    expect(find.text('first'), findsOneWidget);
    expect(find.text('second'), findsNothing);
  });
  testWidgets('Testing ResponseHeadersHeader', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Headers Header',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponseHeadersHeader(
              map: {'text': 'a', 'value': '1'}, name: 'xyz'),
        ),
      ),
    );

    expect(find.text('xyz (2 items)'), findsOneWidget);

    expect(find.byIcon(Icons.content_copy), findsOneWidget);
    expect(find.text(kLabelCopy), findsOneWidget);
    final textButton1 = find.byType(TextButton);
    expect(textButton1, findsOneWidget);
    await tester.tap(textButton1);
  });

  testWidgets('Testing Response Headers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Headers',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponseHeaders(
            responseHeaders: {
              "Content-Length": "4506",
              "Cache-Control": "private",
              "Content-Type": "application/json",
            },
            requestHeaders: {
              'Host': 'developer',
              'user-agent':
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:50.0) Gecko/20100101 Firefox/50.0',
              'accept': 'text/html',
            },
          ),
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Response Headers (3 items)'), findsOneWidget);
    expect(find.text("Content-Length"), findsOneWidget);
    expect(find.text("4506"), findsOneWidget);

    expect(find.text('Request Headers (3 items)'), findsOneWidget);
    expect(find.text("Accept"), findsOneWidget);
    expect(find.text("User-Agent"), findsOneWidget);
    expect(find.text("developer"), findsOneWidget);

    expect(find.byIcon(Icons.content_copy), findsNWidgets(2));
    expect(find.text(kLabelCopy), findsNWidgets(2));
  });
}
