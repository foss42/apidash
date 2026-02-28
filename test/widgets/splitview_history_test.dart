import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  testWidgets('Testing for History Splitview', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'History Splitview',
        home: Scaffold(
          body: HistorySplitView(
            sidebarWidget: Column(children: [Text("Pane")]),
            mainWidget: Column(children: [Text("Viewer")]),
          ),
        ),
      ),
    );

    expect(find.text("Pane"), findsOneWidget);
    expect(find.text("Viewer"), findsOneWidget);
    expect(find.byType(MultiSplitViewTheme), findsOneWidget);
  });
  //TODO: Divider not visible on flutter run. Investigate.
}
