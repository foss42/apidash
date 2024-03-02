import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/markdown.dart';

void main() {
  testWidgets('Testing CustomMarkdown', (tester) async {
    const markdown = CustomMarkdown(
      data: """Is a markdown ~`star on github`~ 
              
              #br
              #br

              ~`github repo`~ ~`Discord Server`~""",
    );
    await tester.pumpWidget(const MaterialApp(home: markdown));
  });

  group('CustomMarkdown Widget Tests', () {
    testWidgets('CustomMarkdown renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CustomMarkdown(
          data: '# Hello World\nThis is some *markdown* text.',
        ),
      ));

      final headlineTextFinder = find.text('Hello World');
      final markdownTextFinder = find.text('This is some markdown text.');

      expect(headlineTextFinder, findsOneWidget);
      expect(markdownTextFinder, findsOneWidget);
    });

    testWidgets('CustomMarkdown has proper text rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: GestureDetector(
          child: const CustomMarkdown(
            data: '[Link Text](https://apidash.dev/)',
          ),
        ),
      ));

      await tester.tap(find.text('Link Text'));
      await tester.pump();

      expect(find.text('Link Text'), findsOneWidget);

      expect(find.text('https://apidash.dev/'), findsNothing);
    });

    testWidgets('CustomMarkdown creates hyperlink',
        (WidgetTester tester) async {
      bool linkTapped = false;
      await tester.pumpWidget(MaterialApp(
        home: CustomMarkdown(
          data: '[Link Text](https://apidash.dev/)',
          onTapLink: (text, href, title) {
            linkTapped = true;
            expect(text, 'Link Text'); 
            expect(href, 'https://apidash.dev/'); 
          },
        ),
      ));
      expect(find.byType(Markdown), findsOneWidget);
      final markdownWidget = tester.widget<Markdown>(find.byType(Markdown));
      expect(markdownWidget.data, '[Link Text](https://apidash.dev/)');
      await tester.tap(find.text('Link Text'));
      expect(linkTapped, true);
    });
  });
}
