import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/screens/home_page/collection_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_params.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_headers.dart';

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

  Future<void> setRequestMethod(HTTPVerb method) async {
    final methodDropdown = spot<DropdownButtonHTTPMethod>();
    await act.tap(methodDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(method.name.toUpperCase()).last);
    await tester.pumpAndSettle();
  }

  Future<void> addRequestParams(List<(String, String)> keyValuePairs) async {
    final paramTabButton =
        spot<RequestPane>().spot<TabBar>().spotText(kLabelURLParams);
    await act.tap(paramTabButton);
    await tester.pumpAndSettle();

    var paramCells = find.descendant(
        of: find.byType(EditRequestURLParams),
        matching: find.byType(EnvCellField));
    for (var i = 0; i < keyValuePairs.length; i++) {
      await tester.tap(paramCells.at(i));
      tester.testTextInput.enterText(keyValuePairs[i].$1);
      await tester.tap(paramCells.at(i + 1));
      tester.testTextInput.enterText(keyValuePairs[i].$2);
      paramCells = find.descendant(
          of: find.byType(EditRequestURLParams),
          matching: find.byType(EnvCellField));
    }
  }

  Future<void> addRequestHeaders(List<(String, String)> keyValuePairs) async {
    final headerTabButton =
        spot<RequestPane>().spot<TabBar>().spotText(kLabelHeaders);
    await act.tap(headerTabButton);
    await tester.pumpAndSettle();

    var headerCells = find.descendant(
        of: find.byType(EditRequestHeaders),
        matching: find.byType(HeaderField));
    var valueCells = find.descendant(
        of: find.byType(EditRequestHeaders),
        matching: find.byType(EnvCellField));
    for (var i = 0; i < keyValuePairs.length; i++) {
      await tester.tap(headerCells.at(i));
      tester.testTextInput.enterText(keyValuePairs[i].$1);
      await tester.tap(valueCells.at(i));
      tester.testTextInput.enterText(keyValuePairs[i].$2);
      headerCells = find.descendant(
          of: find.byType(EditRequestHeaders),
          matching: find.byType(HeaderField));
      valueCells = find.descendant(
          of: find.byType(EditRequestHeaders),
          matching: find.byType(EnvCellField));
    }
  }

  Future<void> unCheckFirstHeader() async {
    final headerCells = find.descendant(
        of: find.byType(EditRequestHeaders), matching: find.byType(CheckBox));
    await tester.tap(headerCells.at(0));
    await tester.pumpAndSettle();
  }

  Future<void> addRequest(
    String url, {
    String? name,
    HTTPVerb method = HTTPVerb.get,
    List<(String, String)> params = const [],
    List<(String, String)> headers = const [],
    bool isMobile = false,
  }) async {
    await addNewRequest(isMobile: isMobile);
    if (name != null) {
      await renameNewRequest(name);
    }
    if (isMobile) {
      kHomeScaffoldKey.currentState!.closeDrawer();
      await tester.pumpAndSettle();
    }
    if (method != HTTPVerb.get) {
      await setRequestMethod(method);
    }
    await addRequestURL(url);
    if (params.isNotEmpty) await addRequestParams(params);
    if (headers.isNotEmpty) await addRequestHeaders(headers);
  }

  Future<void> sendRequest(
      {Duration stallTime = const Duration(seconds: 3)}) async {
    await act.tap(spot<SendRequestButton>());
    await tester.pumpAndSettle(stallTime);
  }
}
