import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:spot/spot.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/envvar/environments_pane.dart';
import 'package:apidash/screens/envvar/editor_pane/variables_pane.dart';

class ApidashTestEnvHelper {
  final WidgetTester tester;

  ApidashTestEnvHelper(this.tester);

  Future<void> addNewEnvironment({bool isMobile = false}) async {
    if (isMobile) {
      kEnvScaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
    }
    final newEnvButton =
        spot<EnvironmentsPane>().spot<ElevatedButton>().spotText(kLabelPlusNew);
    newEnvButton.existsOnce();
    await act.tap(newEnvButton);
    await tester.pumpAndSettle();
  }

  Future<void> renameNewEnvironment(String newEnvName) async {
    Finder envItems = find.byType(EnvironmentItem);
    Finder newEnvItem = envItems.at(1);
    expect(find.descendant(of: newEnvItem, matching: find.text("untitled")),
        findsOneWidget);
    Finder itemCardMenu =
        find.descendant(of: newEnvItem, matching: find.byType(ItemCardMenu));
    await tester.tap(itemCardMenu);
    await tester.pumpAndSettle();

    await tester.tap(find.text(ItemMenuOption.edit.label).last);
    await tester.pump();
    await tester.enterText(newEnvItem, newEnvName);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  Future<void> addEnvironmentVariables(
      List<(String, String)> keyValuePairs) async {
    var envCells = find.descendant(
        of: find.byType(EditEnvironmentVariables),
        matching: find.byType(CellField));
    for (var i = 0; i < keyValuePairs.length; i++) {
      await tester.enterText(envCells.at(i * 2), keyValuePairs[i].$1);
      await tester.enterText(envCells.at(i * 2 + 1), keyValuePairs[i].$2);
      envCells = find.descendant(
          of: find.byType(EditEnvironmentVariables),
          matching: find.byType(CellField));
    }
  }

  Future<void> deleteFirstEnvironmentVariable() async {
    final delButtons = find.descendant(
        of: find.byType(EditEnvironmentVariables),
        matching: find.byIcon(Icons.remove_circle));
    await tester.tap(delButtons.at(0));
    await tester.pump();
  }

  Future<void> setActiveEnvironment(String envName) async {
    await tester.tap(find.descendant(
        of: find.byType(EnvironmentPopupMenu),
        matching: find.byIcon(Icons.unfold_more)));
    await tester.pumpAndSettle();

    await tester.tap(find.text(envName).last);
    await tester.pumpAndSettle();
  }
}
