import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/cards.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Sidebar Request Card', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Sidebar Request Card',
        theme: kThemeDataLight,
        home: Scaffold(
          body: ListView(
            children: [
              SidebarRequestCard(
                id: '23',
                activeRequestId: '2',
                url: 'https://api.foss42.com',
                method: HTTPVerb.get,
                onTap: () {
                  changedValue = 'Single Tapped';
                },
                onDoubleTap: () {
                  changedValue = 'Double Tapped';
                },
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(InkWell), findsOneWidget);

    expect(find.text('api.foss42.com'), findsOneWidget);
    expect(find.widgetWithText(SizedBox, 'api.foss42.com'), findsOneWidget);
    expect(find.widgetWithText(Card, 'api.foss42.com'), findsOneWidget);
    await tester.pumpAndSettle();
    var tappable = find.widgetWithText(Card, 'api.foss42.com');
    await tester.tap(tappable);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(changedValue, 'Single Tapped');
    await tester.pumpAndSettle();

    // await tester.tap(tappable);
    // await tester.pump(const Duration(milliseconds: 100));
    // await tester.tap(tappable);
    // await tester.pumpAndSettle(const Duration(seconds: 2));
    // expect(changedValue, 'Double Tapped');
  });
  testWidgets('Testing Sidebar Request Card dark mode', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Sidebar Request Card',
        theme: kThemeDataDark,
        home: Scaffold(
          body: ListView(
            children: [
              SidebarRequestCard(
                id: '2',
                activeRequestId: '2',
                editRequestId: '2',
                url: 'https://api.foss42.com',
                method: HTTPVerb.get,
                onTapOutsideNameEditor: () {
                  changedValue = 'Tapped Outside';
                },
                onChangedNameEditor: (value) {
                  changedValue = value;
                },
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(InkWell), findsOneWidget);
    await tester.pumpAndSettle();
    var tappable = find.byType(TextFormField);

    await tester.enterText(tappable, 'entering 123 for testing');
    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing');

    await tester.tapAt(const Offset(100, 100));
    await tester.pumpAndSettle();
    expect(changedValue, 'Tapped Outside');
  });
  testWidgets('Testing Request Details Card', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Request Details Card',
        home: Scaffold(
            body: RequestDetailsCard(child: SizedBox(height: 10, width: 10))),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
