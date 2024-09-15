import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/history/history_widgets/history_widgets.dart';
import '../../test/extensions/widget_tester_extensions.dart';
import '../test_helper.dart';

Future<void> main() async {
  await runMobileHisIntegrationTest();
}

Future<void> runMobileHisIntegrationTest() async {
  apidashWidgetTest(
      "Testing History of Requests in mobile end-to-end", kCompactWindowWidth,
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Create New Request
    await helper.reqHelper.addRequest(
      "https://api.apidash.dev/humanize/social",
      name: "test-his-name",
      params: [("num", "870000")],
      isMobile: true,
    );
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Navigate to History
    await helper.navigateToHistory(scaffoldKey: kHomeScaffoldKey);
    kHisScaffoldKey.currentState!.openDrawer();
    var sidebarCards = find.byType(SidebarHistoryCard, skipOffstage: false);
    final initSidebarCardCount =
        tester.widgetList<SidebarHistoryCard>(sidebarCards).length;
    kHisScaffoldKey.currentState!.closeDrawer();

    await act.tap(
        spot<HistorySheetButton>().spotIcon(Icons.keyboard_arrow_up_rounded));
    await tester.pumpAndSettle();
    var historyCards = find.byType(HistoryRequestCard, skipOffstage: false);
    final initHistoryCardCount =
        tester.widgetList<HistoryRequestCard>(historyCards).length;
    await tester.tapAt(const Offset(100, 100));
    await tester.pumpAndSettle();

    /// Send another request with same name
    await helper.navigateToRequestEditor(scaffoldKey: kHisScaffoldKey);
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.addRequest(
      "https://api.apidash.dev/convert/leet",
      name: "test-his-name",
      params: [("text", "apidash")],
      isMobile: true,
    );
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Check history Card counts
    /// TODO: Having overflowing number of cards causes the test to fail
    await helper.navigateToHistory(scaffoldKey: kHomeScaffoldKey);
    sidebarCards = find.byType(SidebarHistoryCard, skipOffstage: false);
    final newSidebarCardCount =
        tester.widgetList<SidebarHistoryCard>(sidebarCards).length;
    kHisScaffoldKey.currentState!.closeDrawer();

    await act.tap(
        spot<HistorySheetButton>().spotIcon(Icons.keyboard_arrow_up_rounded));
    await tester.pumpAndSettle();
    historyCards = find.byType(HistoryRequestCard, skipOffstage: false);
    final newHistoryCardCount =
        tester.widgetList<HistoryRequestCard>(historyCards).length;
    await tester.tapAt(const Offset(100, 100));
    await tester.pumpAndSettle();
    expect(newSidebarCardCount, initSidebarCardCount);
    expect(newHistoryCardCount, initHistoryCardCount + 1);
  });
}
