import 'package:apidash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/request_widgets.dart';
import '../test_consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('Testing Request Pane for 1st tab', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Builder(builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return RequestPane(
              selectedId: '1',
              codePaneVisible: true,
              children: const [Text('abc'), Text('xyz'), Text('mno')],
              onPressedCodeButton: () {},
            );
          }),
        ),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text(l10n.kLabelRequests), findsOneWidget);
    expect(find.text(l10n.kLabelHideCode), findsOneWidget);
    expect(find.text(l10n.kLabelShowCode), findsNothing);
    expect(find.text(l10n.kLabelURLParams), findsOneWidget);
    expect(find.text(l10n.kLabelHeaders), findsOneWidget);
    expect(find.text(l10n.kLabelBody), findsOneWidget);
    expect(find.text('abc'), findsOneWidget);
    expect(find.text('mno'), findsNothing);
    expect(find.text('xyz'), findsNothing);

    expect(find.byIcon(Icons.code_off_rounded), findsOneWidget);
    expect(find.byIcon(Icons.code_rounded), findsNothing);
  });
  testWidgets('Testing Request Pane for 2nd tab', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Builder(builder: (context) {
          l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: RequestPane(
              selectedId: '1',
              codePaneVisible: true,
              onPressedCodeButton: () {},
              tabIndex: 1,
              children: const [Text('abc'), Text('xyz'), Text('mno')],
            ),
          );
        }),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text(l10n.kLabelRequests), findsOneWidget);
    expect(find.text(l10n.kLabelHideCode), findsOneWidget);
    expect(find.text(l10n.kLabelShowCode), findsNothing);
    expect(find.text(l10n.kLabelURLParams), findsOneWidget);
    expect(find.text(l10n.kLabelHeaders), findsOneWidget);
    expect(find.text(l10n.kLabelBody), findsOneWidget);
    expect(find.text('abc'), findsNothing);
    expect(find.text('mno'), findsNothing);
    expect(find.text('xyz'), findsOneWidget);

    expect(find.byIcon(Icons.code_off_rounded), findsOneWidget);
    expect(find.byIcon(Icons.code_rounded), findsNothing);
  });
  testWidgets('Testing Request Pane for 3rd tab', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Builder(builder: (context) {
          l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: RequestPane(
              selectedId: '1',
              codePaneVisible: false,
              onPressedCodeButton: () {},
              tabIndex: 2,
              children: const [Text('abc'), Text('xyz'), Text('mno')],
            ),
          );
        }),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text(l10n.kLabelRequests), findsOneWidget);
    expect(find.text(l10n.kLabelHideCode), findsNothing);
    expect(find.text(l10n.kLabelShowCode), findsOneWidget);
    expect(find.text(l10n.kLabelURLParams), findsOneWidget);
    expect(find.text(l10n.kLabelHeaders), findsOneWidget);
    expect(find.text(l10n.kLabelBody), findsOneWidget);
    expect(find.text('abc'), findsNothing);
    expect(find.text('mno'), findsOneWidget);
    expect(find.text('xyz'), findsNothing);

    expect(find.byIcon(Icons.code_off_rounded), findsNothing);
    expect(find.byIcon(Icons.code_rounded), findsOneWidget);
  });
  testWidgets('Testing Request Pane for tapping tabs', (tester) async {
    late AppLocalizations l10n;
    dynamic computedTabIndex;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'Request Pane',
        theme: kThemeDataLight,
        home: Builder(builder: (context) {
          l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: RequestPane(
              selectedId: '1',
              codePaneVisible: false,
              onPressedCodeButton: () {},
              onTapTabBar: (value) {
                computedTabIndex = value;
              },
              children: const [Text('abc'), Text('xyz'), Text('mno')],
            ),
          );
        }),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
    expect(find.text(l10n.kLabelRequests), findsOneWidget);
    expect(find.text(l10n.kLabelURLParams), findsOneWidget);
    expect(find.text(l10n.kLabelHeaders), findsOneWidget);
    expect(find.text(l10n.kLabelBody), findsOneWidget);

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
