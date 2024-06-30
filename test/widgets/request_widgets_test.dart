import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/request_widgets.dart';
import '../extensions/widget_tester_extensions.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Request Pane for 1st tab', (tester) async {
    await tester.setScreenSize(largeWidthDevice);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Scaffold(
          body: RequestPane(
            selectedId: '1',
            codePaneVisible: true,
            children: const [Text('abc'), Text('xyz'), Text('mno')],
            onPressedCodeButton: () {},
          ),
        ),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text('Hide Code'), findsOneWidget);
    expect(find.text('View Code'), findsNothing);
    expect(find.text('URL Params'), findsOneWidget);
    expect(find.text('Headers'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('abc'), findsOneWidget);
    expect(find.text('mno'), findsNothing);
    expect(find.text('xyz'), findsNothing);

    expect(find.byIcon(Icons.code_off_rounded), findsOneWidget);
    expect(find.byIcon(Icons.code_rounded), findsNothing);
  });
  testWidgets('Testing Request Pane for 2nd tab', (tester) async {
    await tester.setScreenSize(largeWidthDevice);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Scaffold(
          body: RequestPane(
            selectedId: '1',
            codePaneVisible: true,
            onPressedCodeButton: () {},
            tabIndex: 1,
            children: const [Text('abc'), Text('xyz'), Text('mno')],
          ),
        ),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text('Hide Code'), findsOneWidget);
    expect(find.text('View Code'), findsNothing);
    expect(find.text('URL Params'), findsOneWidget);
    expect(find.text('Headers'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('abc'), findsNothing);
    expect(find.text('mno'), findsNothing);
    expect(find.text('xyz'), findsOneWidget);

    expect(find.byIcon(Icons.code_off_rounded), findsOneWidget);
    expect(find.byIcon(Icons.code_rounded), findsNothing);
  });
  testWidgets('Testing Request Pane for 3rd tab', (tester) async {
    await tester.setScreenSize(largeWidthDevice);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Scaffold(
          body: RequestPane(
            selectedId: '1',
            codePaneVisible: false,
            onPressedCodeButton: () {},
            tabIndex: 2,
            children: const [Text('abc'), Text('xyz'), Text('mno')],
          ),
        ),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text('Hide Code'), findsNothing);
    expect(find.text('View Code'), findsOneWidget);
    expect(find.text('URL Params'), findsOneWidget);
    expect(find.text('Headers'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('abc'), findsNothing);
    expect(find.text('mno'), findsOneWidget);
    expect(find.text('xyz'), findsNothing);

    expect(find.byIcon(Icons.code_off_rounded), findsNothing);
    expect(find.byIcon(Icons.code_rounded), findsOneWidget);
  });
  testWidgets('Testing Request Pane for tapping tabs', (tester) async {
    dynamic computedTabIndex;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Scaffold(
          body: RequestPane(
            selectedId: '1',
            codePaneVisible: false,
            onPressedCodeButton: () {},
            onTapTabBar: (value) {
              computedTabIndex = value;
            },
            children: const [Text('abc'), Text('xyz'), Text('mno')],
          ),
        ),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text('URL Params'), findsOneWidget);
    expect(find.text('Headers'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);

    await tester.tap(find.text('Headers'));
    await tester.pumpAndSettle();
    expect(computedTabIndex, 1);

    expect(find.text('abc'), findsNothing);
    expect(find.text('mno'), findsNothing);
    expect(find.text('xyz'), findsOneWidget);

    await tester.tap(find.text('Body'));
    await tester.pumpAndSettle();
    expect(computedTabIndex, 2);

    expect(find.text('abc'), findsNothing);
    expect(find.text('mno'), findsOneWidget);
    expect(find.text('xyz'), findsNothing);

    await tester.tap(find.text('URL Params'));
    await tester.pumpAndSettle();
    expect(computedTabIndex, 0);

    expect(find.text('abc'), findsOneWidget);
    expect(find.text('mno'), findsNothing);
    expect(find.text('xyz'), findsNothing);
  });
}
