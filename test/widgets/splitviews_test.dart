import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/splitviews.dart';
import 'package:multi_split_view/multi_split_view.dart';

void main() {
  testWidgets('Testing for Dashboard Splitview', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Dashboard Splitview',
        home: Scaffold(
          body: DashboardSplitView(
            sidebarWidget: Column(children: const [Text("Hello")]),
            mainWidget: Column(children: const [Text("World")]),
          ),
        ),
      ),
    );

    expect(find.text("World"), findsOneWidget);
    expect(find.text("Hello"), findsOneWidget);
    expect(find.byType(MultiSplitViewTheme), findsOneWidget);
  });
  testWidgets('Testing for Equal SplitView', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Equal SplitView',
        home: Scaffold(
          body: EqualSplitView(
            leftWidget: Column(children: const [Text("Hello equal")]),
            rightWidget: Column(children: const [Text("World equal")]),
          ),
        ),
      ),
    );

    expect(find.text("World equal"), findsOneWidget);
    expect(find.text("Hello equal"), findsOneWidget);
    expect(find.byType(MultiSplitViewTheme), findsOneWidget);
  });
  //TODO: Divider not visible on flutter run. Investigate.
}
