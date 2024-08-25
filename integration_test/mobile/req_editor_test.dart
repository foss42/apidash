import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../test/extensions/widget_tester_extensions.dart';
import '../test_helper.dart';

Future<void> main() async {
  await runMobileReqIntegrationTest();
}

Future<void> runMobileReqIntegrationTest() async {
  const reqName = "test-req-name";
  const testEndpoint = "https://api.apidash.dev/humanize/social";
  const paramKey = "num";
  const paramValue = "870000";
  const headerKey = "Content-Type";
  const headerValue = "application/json";
  const expectedCurlCode = "curl --url '$testEndpoint?$paramKey=$paramValue'";
  const expectedRawCode = '''{
  "data": "870K"
}''';

  apidashWidgetTest(
      "Testing Request Editor in mobile end-to-end", kCompactWindowWidth,
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Create New Request
    await helper.reqHelper.addRequest(testEndpoint,
        name: reqName,
        params: [(paramKey, paramValue)],
        headers: [(headerKey, headerValue)],
        isMobile: true);
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Check if response is received
    await act.tap(spot<SegmentedTabbar>().spotText(kLabelResponse));
    await tester.pumpAndSettle();
    await act.tap(spotText(ResponseBodyView.raw.label));
    await tester.pumpAndSettle();
    spotText(expectedRawCode).existsOnce();

    /// Check Response Headers
    await act.tap(spot<ResponseTabView>().spotText(kLabelHeaders));
    await tester.pumpAndSettle();
    spotText("$kLabelRequestHeaders (1 $kLabelItems)").existsOnce();

    /// Change codegen language to curl
    await helper.navigateToSettings(scaffoldKey: kHomeScaffoldKey);
    await helper.changeCodegenLanguage(CodegenLanguage.curl);
    await helper.navigateToRequestEditor();

    /// Uncheck first header
    await act.tap(spot<SegmentedTabbar>().spotText(kLabelRequest));
    await tester.pumpAndSettle();
    await act.tap(spot<RequestPane>().spot<TabBar>().spotText(kLabelHeaders));
    await tester.pumpAndSettle();
    await helper.reqHelper.unCheckFirstHeader();

    /// Check generated code
    await act.tap(spot<SegmentedTabbar>().spotText(kLabelCode));
    await tester.pumpAndSettle();
    spot<CodeGenPreviewer>().spotText(expectedCurlCode).existsOnce();
  });
}
