import 'package:apidash/widgets/button_clear_response.dart';
import 'package:apidash/widgets/button_discord.dart';
import 'package:apidash/widgets/button_form_data_file.dart';
import 'package:apidash/widgets/button_repo.dart';
import 'package:apidash/widgets/button_send.dart';
import 'package:apidash/widgets/button_share.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing ClearResponseButton', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClearResponseButton(onPressed: () => pressed = true),
        ),
      ),
    );
    await tester.tap(find.byType(ADIconButton));
    expect(pressed, isTrue);
  });

  testWidgets('Testing DiscordButton', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DiscordButton())),
    );
    expect(find.byType(ADFilledButton), findsOneWidget);
    // Tap it to cover the launchUrl branch
    await tester.tap(find.byType(ADFilledButton));
    await tester.pumpAndSettle();
  });

  testWidgets('Testing FormDataFileButton', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormDataFileButton(onPressed: () => pressed = true),
        ),
      ),
    );
    expect(find.byType(ADFilledButton), findsOneWidget);
    await tester.tap(find.byType(ADFilledButton));
    expect(pressed, isTrue);
  });

  testWidgets('Testing RepoButton', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RepoButton(icon: Icons.star)),
      ),
    );
    expect(find.byType(ADFilledButton), findsOneWidget);
    await tester.tap(find.byType(ADFilledButton));
    await tester.pumpAndSettle();
  });

  testWidgets('Testing SendButton', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SendButton(
            isStreaming: false,
            isWorking: false,
            onTap: () => pressed = true,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(ADFilledButton));
    expect(pressed, isTrue);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SendButton(
            isStreaming: false,
            isWorking: true,
            onTap: () => pressed = true,
          ),
        ),
      ),
    );
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Testing ShareButton', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ShareButton(toShare: "test")),
      ),
    );
    expect(find.byType(ADIconButton), findsOneWidget);
    await tester.tap(find.byType(ADIconButton));
    await tester.pumpAndSettle();
  });
}
