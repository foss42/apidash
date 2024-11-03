import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';

import '../test_consts.dart';

void main() {
  final List<HistoryMetaModel> sampleModels = [
    HistoryMetaModel(
      historyId: 'historyId',
      requestId: 'requestId',
      url: 'https://api.apidash.dev',
      method: HTTPVerb.get,
      timeStamp: DateTime.now(),
      responseStatus: 200,
    )
  ];
  testWidgets('Testing Sidebar History Card', (tester) async {
    dynamic changedValue;

    await tester.pumpWidget(
      MaterialApp(
        title: 'Sidebar History Card',
        theme: kThemeDataLight,
        home: Scaffold(
          body: ListView(
            children: [
              SidebarHistoryCard(
                id: '1',
                models: sampleModels,
                method: HTTPVerb.get,
                onTap: () {
                  changedValue = 'Tapped';
                },
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(InkWell), findsOneWidget);

    expect(find.text('https://api.apidash.dev'), findsOneWidget);
    expect(find.widgetWithText(SizedBox, 'https://api.apidash.dev'),
        findsOneWidget);
    expect(
        find.widgetWithText(Card, 'https://api.apidash.dev'), findsOneWidget);
    await tester.pumpAndSettle();
    var tappable = find.widgetWithText(Card, 'https://api.apidash.dev');
    await tester.tap(tappable);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(changedValue, 'Tapped');
    await tester.pumpAndSettle();
  });

  testWidgets('Testing Sidebar History Card dark mode', (tester) async {
    dynamic changedValue;

    await tester.pumpWidget(
      MaterialApp(
        title: 'Sidebar History Card',
        theme: kThemeDataDark,
        home: Scaffold(
          body: ListView(
            children: [
              SidebarHistoryCard(
                id: '1',
                models: sampleModels,
                method: HTTPVerb.get,
                onTap: () {
                  changedValue = 'Tapped';
                },
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(InkWell), findsOneWidget);

    expect(find.text('https://api.apidash.dev'), findsOneWidget);
    expect(find.widgetWithText(SizedBox, 'https://api.apidash.dev'),
        findsOneWidget);
    expect(
        find.widgetWithText(Card, 'https://api.apidash.dev'), findsOneWidget);
    await tester.pumpAndSettle();
    var tappable = find.widgetWithText(Card, 'https://api.apidash.dev');
    await tester.tap(tappable);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(changedValue, 'Tapped');
    await tester.pumpAndSettle();
  });
}
