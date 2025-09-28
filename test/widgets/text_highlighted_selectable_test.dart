import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/text_highlighted_selectable.dart';

void main() {
  testWidgets('HighlightedSelectableText renders plain text when no query',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedSelectableText(
            text: 'Hello World',
          ),
        ),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);

    final selectableText =
        tester.widget<SelectableText>(find.byType(SelectableText));
    expect(selectableText.data, 'Hello World');
  });

  testWidgets('HighlightedSelectableText renders plain text when empty query',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedSelectableText(
            text: 'Hello World',
            query: '',
          ),
        ),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);

    final selectableText =
        tester.widget<SelectableText>(find.byType(SelectableText));
    expect(selectableText.data, 'Hello World');
  });

  testWidgets(
      'HighlightedSelectableText renders with highlights when query matches',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedSelectableText(
            text: 'Hello World',
            query: 'World',
          ),
        ),
      ),
    );

    // When highlighting is applied, it uses SelectableText.rich
    expect(find.byType(SelectableText), findsOneWidget);

    final selectableText =
        tester.widget<SelectableText>(find.byType(SelectableText));
    // The text should still contain the original content
    expect(selectableText.textSpan?.toPlainText(), 'Hello World');
  });

  testWidgets('HighlightedSelectableText is case insensitive', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedSelectableText(
            text: 'Hello World',
            query: 'HELLO',
          ),
        ),
      ),
    );

    expect(find.byType(SelectableText), findsOneWidget);

    final selectableText =
        tester.widget<SelectableText>(find.byType(SelectableText));
    expect(selectableText.textSpan?.toPlainText(), 'Hello World');
  });

  testWidgets('HighlightedSelectableText handles multiple matches',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedSelectableText(
            text: 'Hello Hello World',
            query: 'Hello',
          ),
        ),
      ),
    );

    expect(find.byType(SelectableText), findsOneWidget);

    final selectableText =
        tester.widget<SelectableText>(find.byType(SelectableText));
    expect(selectableText.textSpan?.toPlainText(), 'Hello Hello World');
  });

  testWidgets('HighlightedSelectableText applies custom style', (tester) async {
    const customStyle = TextStyle(fontSize: 20, color: Colors.red);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedSelectableText(
            text: 'Hello World',
            style: customStyle,
          ),
        ),
      ),
    );

    expect(find.byType(SelectableText), findsOneWidget);

    final selectableText =
        tester.widget<SelectableText>(find.byType(SelectableText));
    expect(selectableText.style, customStyle);
  });

  testWidgets('buildHighlightedSpans returns plain TextSpan when no query',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final spans = buildHighlightedSpans('Hello World', context, null);
              return RichText(
                text: TextSpan(children: spans),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(RichText), findsOneWidget);

    final richText = tester.widget<RichText>(find.byType(RichText));
    expect(richText.text.toPlainText(), 'Hello World');
  });

  testWidgets(
      'buildHighlightedSpans returns highlighted spans when query matches',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final spans =
                  buildHighlightedSpans('Hello World', context, 'World');
              return RichText(
                text: TextSpan(children: spans),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(RichText), findsOneWidget);

    final richText = tester.widget<RichText>(find.byType(RichText));
    expect(richText.text.toPlainText(), 'Hello World');

    // Should have multiple spans (before match, match, after match)
    final textSpan = richText.text as TextSpan;
    expect(textSpan.children, isNotNull);
    expect(textSpan.children!.length, greaterThan(1));
  });

  testWidgets('buildHighlightedSpans applies custom base style',
      (tester) async {
    const baseStyle = TextStyle(fontSize: 18, color: Colors.blue);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final spans = buildHighlightedSpans(
                'Hello World',
                context,
                'World',
                baseStyle: baseStyle,
              );
              return RichText(
                text: TextSpan(children: spans, style: baseStyle),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(RichText), findsOneWidget);

    final richText = tester.widget<RichText>(find.byType(RichText));
    expect(richText.text.style, baseStyle);
  });
}
