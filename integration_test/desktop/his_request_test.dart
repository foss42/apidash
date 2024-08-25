import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../test/extensions/widget_tester_extensions.dart';
import '../test_helper.dart';

Future<void> main() async {
  await runDesktopHisIntegrationTest();
}

Future<void> runDesktopHisIntegrationTest() async {
  apidashWidgetTest(
      "Testing History of Requests in desktop end-to-end", kExpandedWindowWidth,
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Create New Request
    await helper.reqHelper.addRequest(
      "https://api.apidash.dev/humanize/social",
      name: "test-his-name",
      params: [("num", "870000")],
    );
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Navigate to History
    await helper.navigateToHistory();
    var sidebarCards = find.byType(SidebarHistoryCard, skipOffstage: false);
    final initSidebarCardCount =
        tester.widgetList<SidebarHistoryCard>(sidebarCards).length;
    var historyCards = find.byType(HistoryRequestCard, skipOffstage: false);
    final initHistoryCardCount =
        tester.widgetList<HistoryRequestCard>(historyCards).length;

    /// Send another request with same name
    await helper.navigateToRequestEditor();
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.addRequest(
      "https://api.apidash.dev/convert/leet",
      name: "test-his-name",
      params: [("text", "apidash")],
    );
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Check history Card counts
    /// TODO: Having overflowing number of cards causes the test to fail
    await helper.navigateToHistory();
    sidebarCards = find.byType(SidebarHistoryCard, skipOffstage: false);
    final newSidebarCardCount =
        tester.widgetList<SidebarHistoryCard>(sidebarCards).length;
    historyCards = find.byType(HistoryRequestCard, skipOffstage: false);
    final newHistoryCardCount =
        tester.widgetList<HistoryRequestCard>(historyCards).length;
    expect(newSidebarCardCount, initSidebarCardCount);
    expect(newHistoryCardCount, initHistoryCardCount + 1);
  });
}
