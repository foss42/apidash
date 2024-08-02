import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  testWidgets('Testing for Equal SplitView', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Equal SplitView',
        home: Scaffold(
          body: EqualSplitView(
            leftWidget: Column(children: [Text("Hello equal")]),
            rightWidget: Column(children: [Text("World equal")]),
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
