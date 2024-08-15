import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/screens.dart';
import 'package:apidash/screens/common_widgets/env_trigger_options.dart';
import 'package:apidash/screens/envvar/editor_pane/variables_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/envvar/environments_pane.dart';
import '../../test/extensions/widget_tester_extensions.dart';
import '../test_helper.dart';

void main() async {
  const environmentName = "test-env-name";
  const envVarName = "test-env-var";
  const envVarValue = "8700000";
  const testEndpoint = "api.apidash.dev/humanize/social?num=";
  const unknown = "unknown";
  const untitled = "untitled";
  const expectedCurlCode =
      "curl --url 'https://api.apidash.dev/humanize/social?num=8700000'";

  await ApidashTestHelper.initialize(
      size: Size(kCompactWindowWidth, kMinWindowSize.height));
  apidashWidgetTest("Testing Environment Manager in desktop end-to-end",
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    kHomeScaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    /// Navigate to Environment Manager
    await navigateByIcon(tester, Icons.laptop_windows_outlined);
    await Future.delayed(const Duration(milliseconds: 500));

    kEnvScaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

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
    expect(find.descendant(of: newEnvItem, matching: find.text(untitled)),
        findsOneWidget);
    Finder itemCardMenu =
        find.descendant(of: newEnvItem, matching: find.byType(ItemCardMenu));
    await tester.tap(itemCardMenu);
    await tester.pumpAndSettle();

    /// Rename the new environment
    await tester.tap(find.text(ItemMenuOption.edit.label).last);
    await tester.pump();
    await tester.enterText(newEnvItem, environmentName);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 500));

    kEnvScaffoldKey.currentState!.closeDrawer();
    await tester.pumpAndSettle();

    /// Edit Environment Variables
    final envCells = find.descendant(
        of: find.byType(EditEnvironmentVariables),
        matching: find.byType(CellField));
    await tester.enterText(envCells.at(0), envVarName);
    await tester.enterText(envCells.at(1), envVarValue);
    await Future.delayed(const Duration(milliseconds: 500));

    kEnvScaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    /// Navigate to Request Editor
    await navigateByIcon(tester, Icons.auto_awesome_mosaic_outlined);
    await Future.delayed(const Duration(milliseconds: 200));

    kHomeScaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    /// Create a new request
    await act.tap(
        spot<CollectionPane>().spot<ElevatedButton>().spotText(kLabelPlusNew));
    await tester.pumpAndSettle();

    kHomeScaffoldKey.currentState!.closeDrawer();
    await tester.pumpAndSettle();

    /// Set active environment
    await tester.tap(find.descendant(
        of: find.byType(EnvironmentPopupMenu),
        matching: find.byIcon(Icons.unfold_more)));
    await tester.pumpAndSettle();

    await tester.tap(find.text(environmentName).last);
    await tester.pumpAndSettle();

    /// Check if environment suggestions are working
    await act.tap(spot<URLTextField>());
    tester.testTextInput.enterText("$testEndpoint{{$envVarName");
    await tester.pumpAndSettle(
        const Duration(milliseconds: 500)); // wait for suggestions
    await act.tap(spot<EnvironmentTriggerOptions>()
        .spot<ListTile>()
        .spotText(envVarValue));
    await tester.pumpAndSettle();

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();

    /// Check if environment variable is shown on hover
    await gesture.moveTo(tester.getCenter(find.descendant(
        of: find.byType(URLTextField),
        matching: find.text('{{$envVarName}}'))));
    await tester.pumpAndSettle();
    expect(find.text(envVarValue), findsOneWidget);
    await gesture.moveBy(const Offset(0, 100));
    await Future.delayed(const Duration(milliseconds: 500));

    kHomeScaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    /// Change codegen language to curl
    await navigateByIcon(tester, Icons.settings_outlined);
    await tester.tap(find.descendant(
        of: find.byType(CodegenPopupMenu),
        matching: find.byIcon(Icons.unfold_more)));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CodegenLanguage.curl.label).last);
    await tester.pumpAndSettle();
    await navigateByIcon(tester, Icons.auto_awesome_mosaic_outlined);
    await Future.delayed(const Duration(milliseconds: 200));

    /// Check variable substitution in request
    await act.tap(spot<SegmentedTabbar>().spotText(kLabelCode));
    await tester.pumpAndSettle();
    expect(
        find.descendant(
            of: find.byType(CodeGenPreviewer),
            matching: find.text(expectedCurlCode)),
        findsOneWidget);

    kHomeScaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    /// Navigate to Environment Manager
    await navigateByIcon(tester, Icons.laptop_windows_outlined);
    await Future.delayed(const Duration(milliseconds: 200));

    /// Delete the environment variable
    final delButtons = find.descendant(
        of: find.byType(EditEnvironmentVariables),
        matching: find.byIcon(Icons.remove_circle));
    await tester.tap(delButtons.at(0));
    await Future.delayed(const Duration(milliseconds: 500));

    kEnvScaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();

    /// Navigate back to Request Editor
    await navigateByIcon(tester, Icons.auto_awesome_mosaic_outlined);
    await Future.delayed(const Duration(milliseconds: 200));

    /// Check if environment variable is now shown on hover
    await gesture.moveTo(tester.getCenter(find.descendant(
        of: find.byType(URLTextField),
        matching: find.text('{{$envVarName}}'))));
    await tester.pumpAndSettle();
    expect(find.text(unknown), findsNWidgets(2));

    await Future.delayed(const Duration(milliseconds: 500));
  });
}
