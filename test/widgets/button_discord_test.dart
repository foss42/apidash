import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/button_discord.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing for Discord button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Discord button',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: DiscordButton(),
        ),
      ),
    );

    expect(find.byIcon(Icons.discord), findsOneWidget);
    expect(find.text("Discord Server"), findsOneWidget);
  });
}
