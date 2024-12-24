import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/button_send.dart';
import '../test_consts.dart';

void main() {
  group('SendButton', () {
    testWidgets('renders send state correctly when not working',
        (tester) async {
      bool sendPressed = false;
      bool cancelPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: SendButton(
              isWorking: false,
              onTap: () => sendPressed = true,
              onCancel: () => cancelPressed = true,
            ),
          ),
        ),
      );

      // Verify initial send state
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.text(kLabelSend), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsNothing);
      expect(find.text(kLabelCancel), findsNothing);

      // Tap and verify callback
      await tester.tap(find.byType(FilledButton));
      expect(sendPressed, isTrue);
      expect(cancelPressed, isFalse);
    });

    testWidgets('renders cancel state correctly when working', (tester) async {
      bool sendPressed = false;
      bool cancelPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: SendButton(
              isWorking: true,
              onTap: () => sendPressed = true,
              onCancel: () => cancelPressed = true,
            ),
          ),
        ),
      );

      // Verify initial cancel state
      expect(find.byIcon(Icons.send), findsNothing);
      expect(find.text(kLabelSend), findsNothing);
      expect(find.text(kLabelCancel), findsOneWidget);

      // Tap and verify callback
      await tester.tap(find.byType(FilledButton));
      expect(sendPressed, isFalse);
      expect(cancelPressed, isTrue);
    });

    testWidgets('updates UI when isWorking changes', (tester) async {
      bool isWorking = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: SendButton(
                  isWorking: isWorking,
                  onTap: () => setState(() => isWorking = true),
                  onCancel: () => setState(() => isWorking = false),
                ),
              );
            },
          ),
        ),
      );

      // Initial send state
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.text(kLabelSend), findsOneWidget);

      // Tap to start working
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      // Verify cancel state
      expect(find.text(kLabelCancel), findsOneWidget);

      // Tap to cancel
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      // Verify back to send state
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.text(kLabelSend), findsOneWidget);
    });
  });
}
