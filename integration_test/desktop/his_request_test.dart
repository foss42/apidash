import 'dart:ui';

import 'package:apidash/screens/history/history_pane.dart';
import 'package:apidash/screens/history/history_requests.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import '../../test/extensions/widget_tester_extensions.dart';
import '../test_helper.dart';

void main() async {
  await ApidashTestHelper.initialize(
      size: Size(kExpandedWindowWidth, kMinWindowSize.height));
  apidashWidgetTest("Testing Environment Manager in desktop end-to-end",
      (WidgetTester tester, helper) async {
    await tester.pumpUntilFound(find.byType(DashApp));
    await Future.delayed(const Duration(seconds: 1));

    /// Create New Request
    await helper.reqHelper.addRequest(
      "https://api.apidash.dev/humanize/social",
      name: "Social",
      params: [("num", "870000")],
    );
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Navigate to History
    await helper.navigateToHistory();
    var sidebarCards = spot<HistoryPane>().spot<SidebarHistoryCard>().finder;
    final initSidebarCardCount =
        tester.widgetList<SidebarHistoryCard>(sidebarCards).length;
    var historyCards =
        spot<HistoryRequests>().spot<HistoryRequestCard>().finder;
    final initHistoryCardCount =
        tester.widgetList<HistoryRequestCard>(historyCards).length;

    /// Send another request with same name
    await helper.navigateToRequestEditor();
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.addRequest(
      "https://api.apidash.dev/convert/leet",
      name: "Social",
      params: [("text", "870000")],
    );
    await Future.delayed(const Duration(milliseconds: 200));
    await helper.reqHelper.sendRequest();

    /// Check history Card counts
    await helper.navigateToHistory();
    sidebarCards = spot<HistoryPane>().spot<SidebarHistoryCard>().finder;
    final newSidebarCardCount =
        tester.widgetList<SidebarHistoryCard>(sidebarCards).length;
    historyCards = spot<HistoryRequests>().spot<HistoryRequestCard>().finder;
    final newHistoryCardCount =
        tester.widgetList<HistoryRequestCard>(historyCards).length;
    expect(newSidebarCardCount, initSidebarCardCount);
    expect(newHistoryCardCount, initHistoryCardCount + 1);
  });
}
