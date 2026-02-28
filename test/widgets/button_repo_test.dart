import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/button_repo.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing for Repo button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Repo button',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: RepoButton(
            icon: Icons.code,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.code), findsOneWidget);
    expect(find.text("GitHub"), findsOneWidget);
  });

  testWidgets('Testing for Repo button icon = null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Repo button',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: RepoButton(),
        ),
      ),
    );

    expect(find.byIcon(Icons.code), findsNothing);
    expect(find.text("GitHub"), findsOneWidget);

    final button1 = find.byType(FilledButton);
    expect(button1, findsOneWidget);

    expect(tester.widget<FilledButton>(button1).enabled, isTrue);
  });
}
