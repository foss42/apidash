import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/common_widgets/env_trigger_options.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import '../../test/extensions/widget_tester_extensions.dart';
import '../test_helper.dart';

Future<void> main() async {
  await runMobileEnvIntegrationTest();
}

Future<void> runMobileEnvIntegrationTest() async {
  const environmentName = "test-env-name";
  const envVarName = "test-env-var";
  const envVarValue = "8700000";
  // TODO: Hover on variable doesn't work in test for long URLs
  const testEndpoint = "https://api.apidash.dev?num=";
  const unknown = "unknown";
  const expectedCurlCode = "curl --url '$testEndpoint$envVarValue'";

  apidashWidgetTest(
      "Testing Environment Manager in mobile end-to-end", kCompactWindowWidth,
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Navigate to Environment Manager
    await helper.navigateToEnvironmentManager(scaffoldKey: kHomeScaffoldKey);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Create New Environment
    await helper.envHelper.addNewEnvironment(isMobile: true);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Rename the new environment
    await helper.envHelper.renameNewEnvironment(environmentName);
    await Future.delayed(const Duration(milliseconds: 500));

    kEnvScaffoldKey.currentState!.closeDrawer();
    await tester.pumpAndSettle();

    /// Add Environment Variables
    await helper.envHelper.addEnvironmentVariables([(envVarName, envVarValue)]);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Navigate to Request Editor
    await helper.navigateToRequestEditor(scaffoldKey: kEnvScaffoldKey);
    await Future.delayed(const Duration(milliseconds: 200));

    /// Create a new request
    await helper.reqHelper.addNewRequest(isMobile: true);

    kHomeScaffoldKey.currentState!.closeDrawer();
    await tester.pumpAndSettle();

    /// Set active environment
    await helper.envHelper.setActiveEnvironment(environmentName);

    /// Check if environment suggestions are working
    await helper.reqHelper.addRequestURL("$testEndpoint{{$envVarName");
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

    /// Check if environment variable is shown
    if (kIsMobile) {
      // TODO: Unable to get Popover to show on mobile
      // await tester.tapAt(tester.getCenter(find.descendant(
      //     of: find.byType(URLTextField),
      //     matching: find.text('{{$envVarName}}'))));
      // await tester.pumpAndSettle();
      // expect(find.text(envVarValue), findsOneWidget);
      // await tester.tapAt(tester.getCenter(find.descendant(
      //         of: find.byType(URLTextField),
      //         matching: find.byType(WidgetSpan))) +
      //     const Offset(0, 100));
    } else {
      await gesture.moveTo(tester.getCenter(find.descendant(
          of: find.byType(URLTextField),
          matching: find.text('{{$envVarName}}'))));
      await tester.pumpAndSettle();
      expect(find.text(envVarValue), findsOneWidget);
      await gesture.moveBy(const Offset(0, 100));
    }
    await Future.delayed(const Duration(milliseconds: 500));

    await helper.navigateToSettings(scaffoldKey: kHomeScaffoldKey);

    /// Change codegen language to curl
    await helper.changeCodegenLanguage(CodegenLanguage.curl);

    await helper.navigateToRequestEditor();
    await Future.delayed(const Duration(milliseconds: 200));

    /// Check variable substitution in request
    await act.tap(spot<SegmentedTabbar>().spotText(kLabelCode));
    await tester.pumpAndSettle();
    expect(
        find.descendant(
            of: find.byType(CodeGenPreviewer),
            matching: find.text(expectedCurlCode)),
        findsOneWidget);

    /// Navigate to Environment Manager
    await helper.navigateToEnvironmentManager(scaffoldKey: kHomeScaffoldKey);
    await Future.delayed(const Duration(milliseconds: 200));

    /// Delete the environment variable
    await helper.envHelper.deleteFirstEnvironmentVariable();
    await Future.delayed(const Duration(milliseconds: 500));

    /// Navigate back to Request Editor
    await helper.navigateToRequestEditor(scaffoldKey: kEnvScaffoldKey);
    await Future.delayed(const Duration(milliseconds: 200));

    /// Check if environment variable is now shown as unknown
    if (kIsMobile) {
      // TODO: Unable to get Popover to show on mobile
      // await tester.tapAt(tester.getCenter(find.descendant(
      //     of: find.byType(URLTextField),
      //     matching: find.text('{{$envVarName}}'))));
      // await tester.pumpAndSettle();
      // expect(find.text(unknown), findsNWidgets(2));
    } else {
      await gesture.moveTo(tester.getCenter(find.descendant(
          of: find.byType(URLTextField),
          matching: find.text('{{$envVarName}}'))));
      await tester.pumpAndSettle();
      expect(find.text(unknown), findsNWidgets(2));
    }

    await Future.delayed(const Duration(milliseconds: 500));
  });
}
