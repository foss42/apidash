import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    testWidgets('CustomMarkdown onTapLink callback works',
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
  });
}
