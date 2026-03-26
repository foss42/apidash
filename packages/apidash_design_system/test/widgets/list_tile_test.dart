import 'package:apidash_design_system/widgets/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ADListTile', () {
    testWidgets('switchOnOff renders and triggers onChanged', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ADListTile(
              type: ListTileType.switchOnOff,
              title: 'Switch Tile',
              value: false,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      expect(find.text('Switch Tile'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(changedValue, true);
    });

    testWidgets('checkbox renders and triggers onChanged', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ADListTile(
              type: ListTileType.checkbox,
              title: 'Checkbox Tile',
              value: false,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      expect(find.text('Checkbox Tile'), findsOneWidget);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(changedValue, true);
    });

    testWidgets('button renders and triggers onChanged on tap', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ADListTile(
              type: ListTileType.button,
              title: 'Button Tile',
              value: true,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      expect(find.text('Button Tile'), findsOneWidget);
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();
      expect(changedValue, true);
    });
  });
}
