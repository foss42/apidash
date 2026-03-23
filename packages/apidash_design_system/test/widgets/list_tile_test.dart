import 'package:apidash_design_system/widgets/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('switchOnOff tile renders and triggers callback', (tester) async {
    bool? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ADListTile(
            type: ListTileType.switchOnOff,
            title: 'Theme',
            subtitle: 'Toggle theme',
            value: false,
            onChanged: (value) => changedValue = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(changedValue, true);
  });

  testWidgets('checkbox tile renders and triggers callback', (tester) async {
    bool? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ADListTile(
            type: ListTileType.checkbox,
            title: 'Save responses',
            subtitle: 'Store response body locally',
            value: false,
            onChanged: (value) => changedValue = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(changedValue, true);
  });

  testWidgets('button tile renders and triggers callback', (tester) async {
    bool? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ADListTile(
            type: ListTileType.button,
            title: 'Run action',
            subtitle: 'Tap to run',
            value: true,
            onChanged: (value) => changedValue = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(changedValue, true);
  });
}
