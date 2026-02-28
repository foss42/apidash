// ignore_for_file: avoid_private_typedef_functions
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:json_explorer/json_explorer.dart';
import 'package:provider/provider.dart';

import 'test_data.dart';

void main() {
  late final dynamic jsonObject;

  setUpAll(() {
    jsonObject = json.decode(nobelPrizesJson);
  });

  testGoldens(
    'Customization',
    (tester) async {
      Widget buildWidget({
        Key? key,
        bool collapseAll = false,
        void Function(JsonExplorerStore store)? onStoreCreated,
        JsonExplorerTheme? theme,
        NodeBuilder? rootInformationBuilder,
        NodeBuilder? collapsableToggleBuilder,
        NodeBuilder? trailingBuilder,
        Formatter? rootNameFormatter,
        Formatter? propertyNameFormatter,
        Formatter? valueFormatter,
        StyleBuilder? valueStyleBuilder,
        double itemSpacing = 2,
      }) =>
          SizedBox(
            height: 200,
            child: ChangeNotifierProvider(
              create: (context) {
                final store = JsonExplorerStore()
                  ..buildNodes(
                    jsonObject,
                    areAllCollapsed: collapseAll,
                  );
                onStoreCreated?.call(store);
                return store;
              },
              child: Consumer<JsonExplorerStore>(
                builder: (context, state, child) => JsonExplorer(
                  key: key,
                  nodes: state.displayNodes,
                  theme: theme,
                  rootInformationBuilder: rootInformationBuilder,
                  collapsableToggleBuilder: collapsableToggleBuilder,
                  trailingBuilder: trailingBuilder,
                  rootNameFormatter: rootNameFormatter,
                  propertyNameFormatter: propertyNameFormatter,
                  valueFormatter: valueFormatter,
                  valueStyleBuilder: valueStyleBuilder,
                  itemSpacing: itemSpacing,
                ),
              ),
            ),
          );

      final builder = GoldenBuilder.grid(
        columns: 4,
        bgColor: Colors.white,
        widthToHeightRatio: 1,
      )
        ..addScenario('Default', buildWidget())
        ..addScenario(
          'Expand',
          buildWidget(
            collapseAll: true,
            onStoreCreated: (store) =>
                store.expandNode(store.displayNodes.first),
          ),
        )
        ..addScenario(
          'Root information',
          buildWidget(
            rootInformationBuilder: (context, node) => DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0x80E1E1E1),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Text(
                node.isClass
                    ? '{${node.childrenCount}}'
                    : '[${node.childrenCount}]',
              ),
            ),
          ),
        )
        ..addScenario(
          'Collapsable toggle',
          buildWidget(
            collapseAll: true,
            onStoreCreated: (store) =>
                store.expandNode(store.displayNodes.first),
            collapsableToggleBuilder: (context, node) => node.isCollapsed
                ? const Icon(Icons.keyboard_arrow_up)
                : const Icon(Icons.keyboard_arrow_down),
          ),
        )
        ..addScenario(
          'Trailing builder',
          buildWidget(
            trailingBuilder: (context, node) => const Icon(
              Icons.info_outline,
              size: 18,
              color: Colors.black26,
            ),
          ),
        )
        ..addScenario(
          'Name formatters',
          buildWidget(
            rootNameFormatter: (dynamic name) => '$name',
            propertyNameFormatter: (dynamic name) => '$name =',
            valueFormatter: (dynamic value) => '"$value"',
          ),
        )
        ..addScenario(
          'Value style builder',
          buildWidget(
            valueStyleBuilder: (dynamic value, style) {
              final isInt = int.tryParse(value.toString());
              return PropertyOverrides(
                style: isInt != null
                    ? style.copyWith(
                        color: Colors.blue,
                      )
                    : style,
              );
            },
          ),
        )
        ..addScenario('Item Spacing', buildWidget(itemSpacing: 10));

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(1200, 600),
      );
      await tester.pumpAndSettle();
      await screenMatchesGolden(tester, 'data_explorer/customization');
    },
    skip: true,
  );

  testGoldens(
    'Interaction',
    (tester) async {
      Widget buildWidget({
        Key? key,
        bool collapseAll = false,
      }) =>
          ChangeNotifierProvider(
            create: (context) => JsonExplorerStore()
              ..buildNodes(
                jsonObject,
                areAllCollapsed: collapseAll,
              ),
            child: Consumer<JsonExplorerStore>(
              builder: (context, state, child) => SizedBox(
                height: 400,
                child: JsonExplorer(
                  key: key,
                  nodes: state.displayNodes,
                ),
              ),
            ),
          );

      const expandNodeKey = Key('expandNodeKey');
      const mouseHoverKey = Key('mouseHoverKey');
      const collapseNodeKey = Key('collapseNodeKey');
      final builder = GoldenBuilder.grid(
        columns: 4,
        bgColor: Colors.white,
        widthToHeightRatio: 0.5,
      )
        ..addScenario('All collapsed', buildWidget(collapseAll: true))
        ..addScenario(
          'Expand',
          buildWidget(
            key: expandNodeKey,
            collapseAll: true,
          ),
        )
        ..addScenario(
          'Collapse node',
          buildWidget(
            key: collapseNodeKey,
          ),
        )
        ..addScenario(
          'Mouse hover',
          buildWidget(
            key: mouseHoverKey,
          ),
        );
      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(1500, 400),
      );

      await tester.tap(
        find.descendant(
          of: find.byKey(expandNodeKey),
          matching: find.text(
            'prizes:',
            findRichText: true,
          ),
        ),
      );

      await tester.tap(
        find
            .descendant(
              of: find.byKey(collapseNodeKey),
              matching: find.text(
                'laureates:',
                findRichText: true,
              ),
            )
            .first,
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      final finder = find.descendant(
        of: find.byKey(mouseHoverKey),
        matching: find.text(
          'laureates:',
          findRichText: true,
        ),
      );
      await gesture.moveTo(tester.getCenter(finder.first));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'data_explorer/interaction');
    },
    skip: true,
  );
}
