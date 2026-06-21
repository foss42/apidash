import 'package:apidash/widgets/text_simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SimpleText renders title, subtitle, and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SimpleText(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            icon: Icons.abc,
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.abc), findsOneWidget);
  });

  testWidgets('SimpleText renders without title, subtitle, and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SimpleText(),
        ),
      ),
    );

    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Text), findsNothing);
    expect(find.byType(Icon), findsNothing);
  });
}
