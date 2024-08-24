import 'package:apidash/consts.dart';
import 'package:apidash/screens/home_page/collection_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/widgets/menu_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';

class ApidashTestRequestHelper {
  final WidgetTester tester;

  ApidashTestRequestHelper(this.tester);

  Future<void> addNewRequest({bool isMobile = false}) async {
    if (isMobile) {
      kHomeScaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
    }
    await act.tap(
        spot<CollectionPane>().spot<ElevatedButton>().spotText(kLabelPlusNew));
    await tester.pumpAndSettle();
  }

  Future<void> renameNewRequest(String newReqName) async {
    Finder reqItems = find.byType(RequestItem);
    Finder newReqItem = reqItems.at(0);
    expect(find.descendant(of: newReqItem, matching: find.text("untitled")),
        findsOneWidget);
    Finder itemCardMenu =
        find.descendant(of: newReqItem, matching: find.byType(ItemCardMenu));
    await tester.tap(itemCardMenu);
    await tester.pumpAndSettle();

    await tester.tap(find.text(ItemMenuOption.edit.label).last);
    await tester.pump();
    await tester.enterText(newReqItem, newReqName);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  Future<void> addRequestURL(String url) async {
    await act.tap(spot<URLTextField>());
    tester.testTextInput.enterText(url);
  }
}
