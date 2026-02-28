import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_explorer/json_explorer.dart';

void main() {
  List<NodeViewModelState> _buildList(String jsonString) {
    final builtNodes = buildViewModelNodes(json.decode(jsonString));
    return flatten(builtNodes);
  }

  group('Flatten algorithm tests', () {
    group('Classes', () {
      test('builds a flat list from a simple json', () {
        const jsonString = '''
{
    "firstField": "firstField",
    "secondField": "secondField",
    "thirdField": "thirdField"
}
''';

        final viewModels = _buildList(jsonString);
        expect(viewModels, hasLength(3));
        expect(viewModels[0].key, 'firstField');
        expect(viewModels[0].value, 'firstField');
        expect(viewModels[0].isRoot, isFalse);
        expect(viewModels[0].treeDepth, 0);

        expect(viewModels[1].key, 'secondField');
        expect(viewModels[1].value, 'secondField');
        expect(viewModels[1].isRoot, isFalse);
        expect(viewModels[1].treeDepth, 0);

        expect(viewModels[2].key, 'thirdField');
        expect(viewModels[2].value, 'thirdField');
        expect(viewModels[2].isRoot, isFalse);
        expect(viewModels[2].treeDepth, 0);
      });

      test('builds a flat list from multiple json classes', () {
        const jsonString = '''
{
    "firstClass": {
        "firstField": "firstField",
        "secondField": "secondField",
        "thirdField": "thirdField"
    },
    "secondClass": {
        "firstField": "firstField",
        "secondField": "secondField",
        "thirdField": "thirdField"
    }
}
''';

        final viewModels = _buildList(jsonString);
        expect(viewModels, hasLength(8));
        expect(viewModels[0].key, 'firstClass');
        expect(viewModels[0].value, isNotNull);
        expect(viewModels[0].isRoot, isTrue);
        expect(viewModels[0].isClass, isTrue);
        expect(viewModels[0].isArray, isFalse);
        expect(viewModels[0].childrenCount, 3);
        expect(viewModels[0].treeDepth, 0);

        expect(viewModels[1].key, 'firstField');
        expect(viewModels[1].value, 'firstField');
        expect(viewModels[1].isRoot, isFalse);
        expect(viewModels[1].treeDepth, 1);

        expect(viewModels[2].key, 'secondField');
        expect(viewModels[2].value, 'secondField');
        expect(viewModels[2].isRoot, isFalse);
        expect(viewModels[2].treeDepth, 1);

        expect(viewModels[3].key, 'thirdField');
        expect(viewModels[3].value, 'thirdField');
        expect(viewModels[3].isRoot, isFalse);
        expect(viewModels[3].treeDepth, 1);

        expect(viewModels[4].key, 'secondClass');
        expect(viewModels[4].value, isNotNull);
        expect(viewModels[4].isRoot, isTrue);
        expect(viewModels[4].isClass, isTrue);
        expect(viewModels[4].isArray, isFalse);
        expect(viewModels[4].childrenCount, 3);
        expect(viewModels[4].treeDepth, 0);

        expect(viewModels[5].key, 'firstField');
        expect(viewModels[5].value, 'firstField');
        expect(viewModels[5].isRoot, isFalse);
        expect(viewModels[5].treeDepth, 1);

        expect(viewModels[6].key, 'secondField');
        expect(viewModels[6].value, 'secondField');
        expect(viewModels[6].isRoot, isFalse);
        expect(viewModels[6].treeDepth, 1);

        expect(viewModels[7].key, 'thirdField');
        expect(viewModels[7].value, 'thirdField');
        expect(viewModels[7].isRoot, isFalse);
        expect(viewModels[7].treeDepth, 1);
      });

      test('builds a flat list from multiple nested json classes', () {
        const jsonString = '''
{
    "firstClass": {
        "firstField": "firstField",
        "firstClassField": {
            "firstField": "firstField",
            "innerClassField": {
                "firstField": "firstField"
            }
        },
        "secondClassField": {
            "firstField": "firstField",
            "innerClassField": {
                "firstField": "firstField"
            }
        }
    }
}
''';

        final viewModels = _buildList(jsonString);
        expect(viewModels, hasLength(10));
        expect(viewModels[0].key, 'firstClass');
        expect(viewModels[0].value, isNotNull);
        expect(viewModels[0].isRoot, isTrue);
        expect(viewModels[0].isClass, isTrue);
        expect(viewModels[0].isArray, isFalse);
        expect(viewModels[0].childrenCount, 3);
        expect(viewModels[0].treeDepth, 0);

        expect(viewModels[1].key, 'firstField');
        expect(viewModels[1].value, isNotNull);
        expect(viewModels[1].isRoot, isFalse);
        expect(viewModels[1].treeDepth, 1);

        expect(viewModels[2].key, 'firstClassField');
        expect(viewModels[2].value, isNotNull);
        expect(viewModels[2].isRoot, isTrue);
        expect(viewModels[2].isClass, isTrue);
        expect(viewModels[2].isArray, isFalse);
        expect(viewModels[2].childrenCount, 2);
        expect(viewModels[2].treeDepth, 1);

        expect(viewModels[3].key, 'firstField');
        expect(viewModels[3].value, isNotNull);
        expect(viewModels[3].isRoot, isFalse);
        expect(viewModels[3].treeDepth, 2);

        expect(viewModels[4].key, 'innerClassField');
        expect(viewModels[4].value, isNotNull);
        expect(viewModels[4].isRoot, isTrue);
        expect(viewModels[4].isClass, isTrue);
        expect(viewModels[4].isArray, isFalse);
        expect(viewModels[4].childrenCount, 1);
        expect(viewModels[4].treeDepth, 2);

        expect(viewModels[5].key, 'firstField');
        expect(viewModels[5].value, isNotNull);
        expect(viewModels[5].isRoot, isFalse);
        expect(viewModels[5].treeDepth, 3);

        expect(viewModels[6].key, 'secondClassField');
        expect(viewModels[6].value, isNotNull);
        expect(viewModels[6].isRoot, isTrue);
        expect(viewModels[6].isClass, isTrue);
        expect(viewModels[6].isArray, isFalse);
        expect(viewModels[6].childrenCount, 2);
        expect(viewModels[6].treeDepth, 1);

        expect(viewModels[7].key, 'firstField');
        expect(viewModels[7].value, isNotNull);
        expect(viewModels[7].isRoot, isFalse);
        expect(viewModels[7].treeDepth, 2);

        expect(viewModels[8].key, 'innerClassField');
        expect(viewModels[8].value, isNotNull);
        expect(viewModels[8].isRoot, isTrue);
        expect(viewModels[8].isClass, isTrue);
        expect(viewModels[8].isArray, isFalse);
        expect(viewModels[8].childrenCount, 1);
        expect(viewModels[8].treeDepth, 2);

        expect(viewModels[9].key, 'firstField');
        expect(viewModels[9].value, isNotNull);
        expect(viewModels[9].isRoot, isFalse);
        expect(viewModels[9].treeDepth, 3);
      });
    });

    group('Arrays', () {
      test('builds a flat list from json array', () {
        const jsonString = '[1, 2]';

        final viewModels = _buildList(jsonString);
        expect(viewModels, hasLength(3));

        expect(viewModels[0].key, 'data');
        expect(viewModels[0].value, isNotNull);
        expect(viewModels[0].isRoot, isTrue);
        expect(viewModels[0].isArray, isTrue);
        expect(viewModels[0].childrenCount, 2);
        expect(viewModels[0].treeDepth, 0);

        expect(viewModels[1].key, '0');
        expect(viewModels[1].value, 1);
        expect(viewModels[1].isRoot, isFalse);
        expect(viewModels[1].treeDepth, 1);

        expect(viewModels[2].key, '1');
        expect(viewModels[2].value, 2);
        expect(viewModels[2].isRoot, isFalse);
        expect(viewModels[2].treeDepth, 1);
      });

      test('builds a flat list from array of classes', () {
        const jsonString = '''
[
    {
        "0.firstField": "firstField"
    },
    {
        "1.firstField": "firstField"
    }
]
      ''';

        final viewModels = _buildList(jsonString);
        expect(viewModels, hasLength(5));
        expect(viewModels[0].key, 'data');
        expect(viewModels[0].value, isNotNull);
        expect(viewModels[0].isRoot, isTrue);
        expect(viewModels[0].isArray, isTrue);
        expect(viewModels[0].childrenCount, 2);
        expect(viewModels[0].treeDepth, 0);

        expect(viewModels[1].key, '0');
        expect(viewModels[1].value, isNotNull);
        expect(viewModels[1].isRoot, isTrue);
        expect(viewModels[1].isClass, isTrue);
        expect(viewModels[1].isArray, isFalse);
        expect(viewModels[1].childrenCount, 1);
        expect(viewModels[1].treeDepth, 1);

        expect(viewModels[2].key, '0.firstField');
        expect(viewModels[2].value, isNotNull);
        expect(viewModels[2].isRoot, isFalse);
        expect(viewModels[2].treeDepth, 2);

        expect(viewModels[3].key, '1');
        expect(viewModels[3].value, isNotNull);
        expect(viewModels[3].isRoot, isTrue);
        expect(viewModels[3].isClass, isTrue);
        expect(viewModels[3].isArray, isFalse);
        expect(viewModels[3].childrenCount, 1);
        expect(viewModels[3].treeDepth, 1);

        expect(viewModels[4].key, '1.firstField');
        expect(viewModels[4].value, isNotNull);
        expect(viewModels[4].isRoot, isFalse);
        expect(viewModels[4].treeDepth, 2);
      });

      test('builds a flat list from class with nested arrays', () {
        const jsonString = '''
{
    "firstClass": {
        "firstClass.firstField": "firstField",
        "firstClass.array": [
            1,
            2
        ]
    },
    "secondClass": {
        "secondClass.firstField": "firstField",
        "secondClass.array": [
            3,
            4
        ]
    }
}
      ''';

        final viewModels = _buildList(jsonString);
        expect(viewModels, hasLength(10));
        expect(viewModels[0].key, 'firstClass');
        expect(viewModels[0].value, isNotNull);
        expect(viewModels[0].isRoot, isTrue);
        expect(viewModels[0].isClass, isTrue);
        expect(viewModels[0].isArray, isFalse);
        expect(viewModels[0].childrenCount, 2);
        expect(viewModels[0].treeDepth, 0);

        expect(viewModels[1].key, 'firstClass.firstField');
        expect(viewModels[1].value, 'firstField');
        expect(viewModels[1].isRoot, isFalse);
        expect(viewModels[1].treeDepth, 1);

        expect(viewModels[2].key, 'firstClass.array');
        expect(viewModels[2].value, isNotNull);
        expect(viewModels[2].isRoot, isTrue);
        expect(viewModels[2].isArray, isTrue);
        expect(viewModels[2].childrenCount, 2);
        expect(viewModels[2].treeDepth, 1);

        expect(viewModels[3].key, '0');
        expect(viewModels[3].value, 1);
        expect(viewModels[3].isRoot, isFalse);
        expect(viewModels[3].treeDepth, 2);

        expect(viewModels[4].key, '1');
        expect(viewModels[4].value, 2);
        expect(viewModels[4].isRoot, isFalse);
        expect(viewModels[4].treeDepth, 2);

        expect(viewModels[5].key, 'secondClass');
        expect(viewModels[5].value, isNotNull);
        expect(viewModels[5].isRoot, isTrue);
        expect(viewModels[5].isClass, isTrue);
        expect(viewModels[5].isArray, isFalse);
        expect(viewModels[5].childrenCount, 2);
        expect(viewModels[5].treeDepth, 0);

        expect(viewModels[6].key, 'secondClass.firstField');
        expect(viewModels[6].value, 'firstField');
        expect(viewModels[6].isRoot, isFalse);
        expect(viewModels[6].treeDepth, 1);

        expect(viewModels[7].key, 'secondClass.array');
        expect(viewModels[7].value, isNotNull);
        expect(viewModels[7].isRoot, isTrue);
        expect(viewModels[7].isArray, isTrue);
        expect(viewModels[7].childrenCount, 2);
        expect(viewModels[7].treeDepth, 1);

        expect(viewModels[8].key, '0');
        expect(viewModels[8].value, 3);
        expect(viewModels[8].isRoot, isFalse);
        expect(viewModels[8].treeDepth, 2);

        expect(viewModels[9].key, '1');
        expect(viewModels[9].value, 4);
        expect(viewModels[9].isRoot, isFalse);
        expect(viewModels[9].treeDepth, 2);
      });
    });
  });
}
