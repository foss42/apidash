// ignore_for_file: avoid_private_typedef_functions
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:json_explorer/json_explorer.dart';
import 'package:provider/provider.dart';

import 'test_data.dart';

typedef _NodeBuilder = Widget Function(int treeDepth, JsonExplorerTheme theme);

void main() {
  testGoldens(
    'Json attribute',
    (tester) async {
      final dynamic jsonObject = json.decode(nobelPrizesJson);

      final node = NodeViewModelState.fromProperty(
        treeDepth: 0,
        key: 'property',
        value: 'value',
        parent: null,
      );

      final widget = ChangeNotifierProvider(
        create: (context) => JsonExplorerStore()..buildNodes(jsonObject),
        child: Consumer<JsonExplorerStore>(
          builder: (context, state, child) => JsonAttribute(
            node: node,
            theme: JsonExplorerTheme.defaultTheme,
          ),
        ),
      );

      final builder = GoldenBuilder.column(bgColor: Colors.white)
        ..addScenario('Default font size', widget)
        ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
        ..addTextScaleScenario('Largest font', widget, textScaleFactor: 3.0);

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'json_attribute');
    },
    skip: true,
  );

  group(
    'Search',
    () {
      const _searchTestJson = '''
    {
      "property": "property value",
      "anotherProperty": "another property value"
    }
    ''';

      testGoldens('Highlight', (tester) async {
        final dynamic jsonObject = json.decode(_searchTestJson);
        Widget buildWidget({
          required String searchTerm,
          Function(JsonExplorerStore store)? onStoreCreate,
          JsonExplorerTheme? theme,
        }) {
          return ChangeNotifierProvider(
            create: (context) {
              final store = JsonExplorerStore()
                ..buildNodes(jsonObject)
                ..search(searchTerm);
              onStoreCreate?.call(store);
              return store;
            },
            child: Consumer<JsonExplorerStore>(
              builder: (context, state, child) => JsonAttribute(
                node: state.displayNodes.last,
                theme: theme ?? JsonExplorerTheme.defaultTheme,
              ),
            ),
          );
        }

        final customTheme = JsonExplorerTheme(
          keySearchHighlightTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.green,
          ),
          valueSearchHighlightTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            backgroundColor: Colors.purpleAccent,
          ),
          focusedKeySearchHighlightTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.black,
          ),
          focusedValueSearchHighlightTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.red,
          ),
        );

        final builder = GoldenBuilder.column(bgColor: Colors.white)
          ..addScenario(
            'highlight',
            buildWidget(
              searchTerm: 'property',
            ),
          )
          ..addScenario(
            'property focused highlight',
            buildWidget(
              searchTerm: 'property',
              onStoreCreate: (store) => store
                ..focusNextSearchResult()
                ..focusNextSearchResult(),
            ),
          )
          ..addScenario(
            'value focused highlight',
            buildWidget(
              searchTerm: 'property',
              onStoreCreate: (store) => store
                ..focusNextSearchResult()
                ..focusNextSearchResult()
                ..focusNextSearchResult(),
            ),
          )
          ..addScenario(
            'custom theme highlight',
            buildWidget(
              searchTerm: 'property',
              theme: customTheme,
            ),
          )
          ..addScenario(
            'custom theme property focused highlight',
            buildWidget(
              searchTerm: 'property',
              theme: customTheme,
              onStoreCreate: (store) => store
                ..focusNextSearchResult()
                ..focusNextSearchResult(),
            ),
          )
          ..addScenario(
            'custom theme value focused highlight',
            buildWidget(
              searchTerm: 'property',
              theme: customTheme,
              onStoreCreate: (store) => store
                ..focusNextSearchResult()
                ..focusNextSearchResult()
                ..focusNextSearchResult(),
            ),
          );

        await tester.pumpWidgetBuilder(
          builder.build(),
          surfaceSize: const Size(400, 600),
        );
        await screenMatchesGolden(tester, 'search');
      });
    },
    skip: true,
  );

  group('Indentation', () {
    Future testIndentationGuidelines(
      WidgetTester tester, {
      required _NodeBuilder nodeBuilder,
      required String goldenName,
    }) async {
      final builder = GoldenBuilder.column(bgColor: Colors.white)
        ..addScenario(
          'no indentation',
          nodeBuilder(0, JsonExplorerTheme.defaultTheme),
        )
        ..addScenario(
          '1 step',
          nodeBuilder(1, JsonExplorerTheme.defaultTheme),
        )
        ..addScenario(
          '2 steps',
          nodeBuilder(2, JsonExplorerTheme.defaultTheme),
        )
        ..addScenario(
          '3 steps',
          nodeBuilder(3, JsonExplorerTheme.defaultTheme),
        )
        ..addScenario(
          '4 steps',
          nodeBuilder(4, JsonExplorerTheme.defaultTheme),
        )
        ..addScenario(
          'custom color',
          nodeBuilder(
            4,
            JsonExplorerTheme(
              indentationLineColor: Colors.blue,
            ),
          ),
        )
        ..addScenario(
          'no guidelines',
          nodeBuilder(
            4,
            JsonExplorerTheme(
              indentationLineColor: Colors.transparent,
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (widget) => materialAppWrapper()(
          ChangeNotifierProvider(
            create: (context) => JsonExplorerStore(),
            child: Consumer<JsonExplorerStore>(
              builder: (context, state, child) => widget,
            ),
          ),
        ),
        surfaceSize: const Size(200, 600),
      );
      await screenMatchesGolden(tester, 'indentation/$goldenName');
    }

    testGoldens(
      'Property indentation guidelines',
      (tester) async {
        await testIndentationGuidelines(
          tester,
          goldenName: 'property_indentation',
          nodeBuilder: (treeDepth, theme) {
            final node = NodeViewModelState.fromProperty(
              treeDepth: treeDepth,
              key: 'property',
              value: 'value',
              parent: null,
            );
            return JsonAttribute(
              node: node,
              theme: theme,
            );
          },
        );
      },
      skip: true,
    );

    testGoldens(
      'Property indentation guidelines',
      (tester) async {
        await testIndentationGuidelines(
          tester,
          goldenName: 'class_indentation',
          nodeBuilder: (treeDepth, theme) {
            final node = NodeViewModelState.fromClass(
              treeDepth: treeDepth,
              key: 'class',
              parent: null,
            )..value = <String, NodeViewModelState>{};
            return JsonAttribute(
              node: node,
              theme: theme,
            );
          },
        );
      },
      skip: true,
    );

    testGoldens(
      'Array indentation guidelines',
      (tester) async {
        await testIndentationGuidelines(
          tester,
          goldenName: 'array_indentation',
          nodeBuilder: (treeDepth, theme) {
            final node = NodeViewModelState.fromArray(
              treeDepth: treeDepth,
              key: 'array',
              parent: null,
            )..value = <dynamic>[];
            return JsonAttribute(
              node: node,
              theme: theme,
            );
          },
        );
      },
      skip: true,
    );
  });
}
