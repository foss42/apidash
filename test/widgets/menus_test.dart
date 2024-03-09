import 'package:apidash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/menus.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('Testing RequestCardMenu', (tester) async {
    dynamic changedValue;
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'CardMenu testing',
        theme: kThemeDataLight,
        home: Builder(builder: (context) {
          l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  RequestCardMenu(
                    onSelected: (value) {
                      changedValue = value;
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );

    expect(find.byType(PopupMenuButton<RequestItemMenuOption>), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<RequestItemMenuOption>));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text(l10n.kLabelDelete).last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, RequestItemMenuOption.delete);

    await tester.tap(find.byType(PopupMenuButton<RequestItemMenuOption>));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Duplicate').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, RequestItemMenuOption.duplicate);
  });
}
