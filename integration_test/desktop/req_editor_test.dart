import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../test/extensions/widget_tester_extensions.dart';
import '../test_helper.dart';

Future<void> main() async {
  await runDesktopReqIntegrationTest();
}

Future<void> runDesktopReqIntegrationTest() async {
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
      "Testing Request Editor in desktop end-to-end", kExpandedWindowWidth,
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Create New Request
    await helper.reqHelper.addRequest(testEndpoint,
        name: reqName,
        params: [(paramKey, paramValue)],
        headers: [(headerKey, headerValue)]);
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Check if response is received
    await act.tap(spotText(ResponseBodyView.raw.label));
    await tester.pumpAndSettle();
    spotText(expectedRawCode).existsOnce();

    /// Check Response Headers
    await act.tap(spot<ResponseTabView>().spotText(kLabelHeaders));
    await tester.pumpAndSettle();
    spotText("$kLabelRequestHeaders (1 $kLabelItems)").existsOnce();

    /// Change codegen language to curl
    await helper.navigateToSettings();
    await helper.changeCodegenLanguage(CodegenLanguage.curl);
    await helper.navigateToRequestEditor();

    /// Check generated code
    await helper.reqHelper.unCheckFirstHeader();
    await act.tap(spot<RequestPane>().spotText(kLabelViewCode));
    await tester.pumpAndSettle();
    spot<CodeGenPreviewer>().spotText(expectedCurlCode).existsOnce();
  });
}
