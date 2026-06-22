import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  testWidgets('Testing for History Splitview', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'History Splitview',
        home: Scaffold(
          body: HistorySplitView(
            sidebarWidget: Column(children: const [Text("Pane")]),
            mainWidget: Column(children: const [Text("Viewer")]),
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
