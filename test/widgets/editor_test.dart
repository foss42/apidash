import 'package:apidash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/editor.dart';
import '../test_consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  setUp(() async {
    L10n.supportedLocales.map(
      (locale) async => AppLocalizations.delegate.load(locale),
    );
  });

  testWidgets('Testing Editor', (tester) async {
    dynamic changedValue;
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'Editor',
        theme: kThemeDataLight,
        home: Builder(builder: (context) {
          l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Column(children: [
              Expanded(
                child: TextFieldEditor(
                  fieldKey: '2',
                  onChanged: (value) {
                    changedValue = value;
                  },
                ),
              ),
            ]),
          );
        }),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byKey(const Key("2")), findsOneWidget);
    expect(find.text(l10n.kLabelEnterContent), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, 'entering 123 for testing content body');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing content body    ');
  });
  testWidgets('Testing Editor Dark theme', (tester) async {
    dynamic changedValue;
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'Editor Dark',
        theme: kThemeDataDark,
        home: Builder(builder: (context) {
          l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Column(children: [
              Expanded(
                child: TextFieldEditor(
                  fieldKey: '2',
                  onChanged: (value) {
                    changedValue = value;
                  },
                  initialValue: 'initial',
                ),
              ),
            ]),
          );
        }),
      ),
    );
    expect(find.text('initial'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byKey(const Key("2")), findsOneWidget);
    expect(find.text(l10n.kLabelEnterContent), findsOneWidget);
    var txtForm = find.byKey(const Key("2"));
    await tester.enterText(txtForm, 'entering 123 for testing content body');
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(txtForm);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await tester.pump();
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing content body    ');
  });
}
