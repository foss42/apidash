import 'package:apidash/widgets/workspace_selector.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing WorkspaceSelector initialization and buttons', (tester) async {
    bool cancelCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: WorkspaceSelector(
          onContinue: (path) async {},
          onCancel: () async {
            cancelCalled = true;
          },
        ),
      ),
    );

    expect(find.text(kMsgSelectWorkspace), findsOneWidget);
    expect(find.text("CHOOSE DIRECTORY"), findsOneWidget);
    expect(find.text(kLabelSelect), findsOneWidget);
    
    // Continue should be disabled initially
    final continueButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, kLabelContinue).first,
    );
    expect(continueButton.onPressed, isNull);

    // Cancel should work
    await tester.tap(find.widgetWithText(FilledButton, kLabelCancel).first);
    await tester.pumpAndSettle();

    expect(cancelCalled, isTrue);
  });

  testWidgets('Testing WorkspaceSelector text fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WorkspaceSelector(
          onContinue: (path) async {},
        ),
      ),
    );

    expect(find.byType(ADOutlinedTextField), findsNWidgets(2));

    await tester.enterText(find.byType(ADOutlinedTextField).last, 'MyWorkspace');
    await tester.pumpAndSettle();

    expect(find.text('MyWorkspace'), findsOneWidget);
  });
}
