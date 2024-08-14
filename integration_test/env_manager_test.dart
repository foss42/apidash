import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/screens.dart';
import 'package:apidash/widgets/field_cell.dart';
import 'package:apidash/widgets/menu_item_card.dart';
import 'package:apidash/widgets/popup_menu_env.dart';
import 'package:apidash/screens/common_widgets/env_trigger_options.dart';
import 'package:apidash/screens/envvar/editor_pane/variables_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_request.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/envvar/environments_pane.dart';
import '../test/extensions/widget_tester_extensions.dart';
import 'test_helper.dart';

void main() async {
  await ApidashTestHelper.initialize();
  apidashWidgetTest("Testing Environment Manager end-to-end",
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Navigate to Environment Manager
    await navigateByIcon(Icons.laptop_windows_outlined, tester);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Create New Environment
    final newEnvButton =
        spot<EnvironmentsPane>().spot<ElevatedButton>().spotText(kLabelPlusNew);
    newEnvButton.existsOnce();
    await act.tap(newEnvButton);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 500));

    /// Open ItemCardMenu of the new environment
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
    await Future.delayed(const Duration(milliseconds: 500));

    /// Edit Environment Variables
    final envCells = find.descendant(
        of: find.byType(EditEnvironmentVariables),
        matching: find.byType(CellField));
    await tester.enterText(envCells.at(0), "test-key");
    await tester.enterText(envCells.at(1), "test-value");
    await Future.delayed(const Duration(milliseconds: 500));

    /// Navigate to Request Editor
    await navigateByIcon(Icons.auto_awesome_mosaic_outlined, tester);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Create a new request
    await act.tap(
        spot<CollectionPane>().spot<ElevatedButton>().spotText(kLabelPlusNew));
    await tester.pumpAndSettle();

    /// Set active environment
    await tester.tap(find.descendant(
        of: find.byType(EnvironmentPopupMenu),
        matching: find.byIcon(Icons.unfold_more)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Environment').last);
    await tester.pumpAndSettle();

    /// Check if environment suggestions are working
    await act.tap(spot<RequestEditor>().spot<URLTextField>());
    tester.testTextInput.enterText("{{test-k");
    await tester.pumpAndSettle(
        const Duration(milliseconds: 500)); // wait for suggestions
    spot<EnvironmentTriggerOptions>()
        .spot<ListTile>()
        .spotText('test-key')
        .existsOnce();

    /// Navigate to Environment Manager
    await navigateByIcon(Icons.laptop_windows_outlined, tester);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Delete the environment variable
    final delButtons = find.descendant(
        of: find.byType(EditEnvironmentVariables),
        matching: find.byIcon(Icons.remove_circle));
    await tester.tap(delButtons.at(0));

    /// Navigate back to Request Editor
    await navigateByIcon(Icons.auto_awesome_mosaic_outlined, tester);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Check if environment suggestions are shown
    await act.tap(spot<RequestEditor>().spot<URLTextField>());
    tester.testTextInput.enterText("{{test-k");
    await tester.pumpAndSettle(
        const Duration(milliseconds: 500)); // wait for suggestions
    spot<EnvironmentTriggerOptions>()
        .spot<ListTile>()
        .spotText('test-key')
        .doesNotExist();

    await Future.delayed(const Duration(seconds: 2));
  });
}
