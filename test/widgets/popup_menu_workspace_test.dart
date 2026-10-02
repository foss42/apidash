import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/popup_menu_workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_consts.dart';

void main() {
  testWidgets('selecting a saved workspace path calls onPathSelected', (
    tester,
  ) async {
    String? selectedPath;
    var openedWorkspace = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: WorkspacePopupMenu(
            currentLabel: 'Alpha',
            workspaces: const [
              SavedWorkspaceEntry(path: '/tmp/alpha', name: 'Alpha'),
              SavedWorkspaceEntry(path: '/tmp/beta', name: 'Beta'),
            ],
            onPathSelected: (path) {
              selectedPath = path;
            },
            onOpenWorkspace: () {
              openedWorkspace = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta').last);
    await tester.pumpAndSettle();

    expect(selectedPath, '/tmp/beta');
    expect(openedWorkspace, isFalse);
  });

  testWidgets('Open workspace menu item calls onOpenWorkspace', (
    tester,
  ) async {
    var openedWorkspace = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: kThemeDataLight,
        home: Scaffold(
          body: WorkspacePopupMenu(
            currentLabel: 'Alpha',
            workspaces: const [
              SavedWorkspaceEntry(path: '/tmp/alpha', name: 'Alpha'),
            ],
            onPathSelected: (_) {},
            onOpenWorkspace: () {
              openedWorkspace = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(kLabelOpenWorkspaceMenu).last);
    await tester.pumpAndSettle();

    expect(openedWorkspace, isTrue);
  });
}
