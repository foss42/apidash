import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  testWidgets('Testing for Equal SplitView < 900', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

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

  testWidgets('Testing for Equal SplitView < 1000', (tester) async {
    tester.view.physicalSize = const Size(950, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

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
  });

  testWidgets('Testing for Equal SplitView < 1200', (tester) async {
    tester.view.physicalSize = const Size(1100, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

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
  });

  testWidgets('Testing for Equal SplitView >= 1200', (tester) async {
    tester.view.physicalSize = const Size(1300, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

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
  });

  testWidgets('double-tap on the divider resets panes to a 50:50 split', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1300, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

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
    await tester.pumpAndSettle();

    final controller = tester
        .widget<MultiSplitView>(find.byType(MultiSplitView))
        .controller!;

    // Make the split uneven, like a user drag would.
    controller.areas[0].flex = 3;
    await tester.pumpAndSettle();
    expect(controller.areas[0].flex, 3);

    // Double-tap the divider.
    final divider = find.descendant(
      of: find.byType(MultiSplitView),
      matching: find.byType(GestureDetector),
    );
    expect(divider, findsOneWidget);
    final center = tester.getCenter(divider);
    await tester.tapAt(center);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(center);
    await tester.pumpAndSettle();

    expect(controller.areas[0].flex, 1);
    expect(controller.areas[1].flex, 1);
  });
}
