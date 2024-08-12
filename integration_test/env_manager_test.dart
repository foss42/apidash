import 'package:apidash/widgets/menu_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';

import 'package:apidash/screens/envvar/environments_pane.dart';
import '../test/extensions/widget_tester_extensions.dart';
import 'test_helper.dart';

void main() async {
  await ApidashTestHelper.initialize();
  apidashWidgetTest("Testing Environment Manager end-to-end",
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 2));

    /// Navigate to Environment Manager
    Finder envNavbutton = find.byIcon(Icons.laptop_windows_outlined);
    expect(envNavbutton, findsOneWidget);
    await tester.tap(envNavbutton);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    /// Create New Environment
    final newEnvButton =
        spot<EnvironmentsPane>().spot<ElevatedButton>().spotText(kLabelPlusNew);
    newEnvButton.existsOnce();
    await act.tap(newEnvButton);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    /// Open ItemCardMenu of the new environment
    spot<EnvironmentsPane>()
        .spot<EnvironmentsList>()
        .spot<EnvironmentItem>()
        .existsAtLeastNTimes(2);
    Finder envItems = find.byType(EnvironmentItem);
    Finder newEnvItem = envItems.at(1);
    expect(find.descendant(of: newEnvItem, matching: find.text('untitled')),
        findsOneWidget);
    Finder itemCardMenu =
        find.descendant(of: newEnvItem, matching: find.byType(ItemCardMenu));
    await tester.tap(itemCardMenu);
    await tester.pumpAndSettle();

    /// Rename the new environment
    await tester.tap(find.text('Rename').last);
    await tester.pump();
    await tester.enterText(newEnvItem, "New Environment");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await Future.delayed(const Duration(seconds: 2));
  });
}
