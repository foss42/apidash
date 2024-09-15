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
  await runDesktopEnvIntegrationTest();
}

Future<void> runDesktopEnvIntegrationTest() async {
  const environmentName = "test-env-name";
  const envVarName = "test-env-var";
  const envVarValue = "8700000";
  const testEndpoint = "https://api.apidash.dev/humanize/social?num=";
  const unknown = "unknown";
  const expectedCurlCode = "curl --url '$testEndpoint$envVarValue'";

  apidashWidgetTest(
      "Testing Environment Manager in desktop end-to-end", kExpandedWindowWidth,
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Navigate to Environment Manager
    await helper.navigateToEnvironmentManager();
    await Future.delayed(const Duration(milliseconds: 500));

    /// Create New Environment
    await helper.envHelper.addNewEnvironment();
    await Future.delayed(const Duration(milliseconds: 500));

    /// Rename the new environment
    await helper.envHelper.renameNewEnvironment(environmentName);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Add Environment Variables
    await helper.envHelper.addEnvironmentVariables([(envVarName, envVarValue)]);
    await Future.delayed(const Duration(milliseconds: 500));

    /// Navigate to Request Editor
    await helper.navigateToRequestEditor();
    await Future.delayed(const Duration(milliseconds: 200));

    /// Create a new request
    await helper.reqHelper.addNewRequest();

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

    /// Check if environment variable is shown on hover
    await gesture.moveTo(tester.getCenter(find.descendant(
        of: find.byType(URLTextField),
        matching: find.text('{{$envVarName}}'))));
    await tester.pumpAndSettle();
    expect(find.text(envVarValue), findsOneWidget);
    await Future.delayed(const Duration(milliseconds: 500));

    await helper.navigateToSettings();

    /// Change codegen language to curl
    await helper.changeCodegenLanguage(CodegenLanguage.curl);

    await helper.navigateToRequestEditor();
    await Future.delayed(const Duration(milliseconds: 200));

    /// Check variable substitution in request
    await act.tap(spot<RequestPane>().spotText(kLabelViewCode));
    await tester.pumpAndSettle();
    expect(
        find.descendant(
            of: find.byType(CodeGenPreviewer),
            matching: find.text(expectedCurlCode)),
        findsOneWidget);

    /// Navigate to Environment Manager
    await helper.navigateToEnvironmentManager();
    await Future.delayed(const Duration(milliseconds: 200));

    /// Delete the environment variable
    await helper.envHelper.deleteFirstEnvironmentVariable();
    await Future.delayed(const Duration(milliseconds: 500));

    /// Navigate back to Request Editor
    await helper.navigateToRequestEditor();
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
