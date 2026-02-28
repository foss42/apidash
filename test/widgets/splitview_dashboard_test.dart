import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  testWidgets('Testing for Dashboard Splitview', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Dashboard Splitview',
        home: Scaffold(
          body: DashboardSplitView(
            sidebarWidget: Column(children: [Text("Hello")]),
            mainWidget: Column(children: [Text("World")]),
          ),
        ),
      ),
    );

    expect(find.text("World"), findsOneWidget);
    expect(find.text("Hello"), findsOneWidget);
    expect(find.byType(MultiSplitViewTheme), findsOneWidget);
  });
  //TODO: Divider not visible on flutter run. Investigate.
}
