import 'package:apidash/workflow/utils/workflow_loop_utils.dart';
import 'package:test/test.dart';

void main() {
  group('parseLoopListVariableName', () {
    test('accepts mustache, bare, and var: forms', () {
      expect(parseLoopListVariableName('{{users}}'), 'users');
      expect(parseLoopListVariableName('{{ users }}'), 'users');
      expect(parseLoopListVariableName('users'), 'users');
      expect(parseLoopListVariableName('var:users'), 'users');
      expect(formatLoopListVariableRef('var:users'), '{{users}}');
      expect(encodeLoopListExpression('{{users}}'), 'var:users');
    });

    test('builds live extraction preview from list and path', () {
      expect(
        formatLoopItemExtractionPreview(
          listRaw: '{{users}}',
          pathRaw: 'id',
        ),
        '{{users}}.id',
      );
      expect(
        formatLoopItemExtractionPreview(listRaw: '{{users}}', pathRaw: ''),
        isNull,
      );
    });
  });

  group('stringifyLoopItem', () {
    test('keeps primitives bare', () {
      expect(stringifyLoopItem(1), '1');
      expect(stringifyLoopItem(true), 'true');
      expect(stringifyLoopItem('ada'), 'ada');
    });

    test('json-encodes objects and arrays', () {
      expect(stringifyLoopItem({'id': 1, 'name': 'Ada'}), '{"id":1,"name":"Ada"}');
      expect(stringifyLoopItem([1, 2]), '[1,2]');
    });
  });

  group('resolveLoopItemList', () {
    test('parses JSON object arrays without Dart toString', () {
      final items = resolveLoopItemList(
        '[{"id":1,"name":"Ada"},{"id":2,"name":"Grace"}]',
      );
      expect(items, [
        '{"id":1,"name":"Ada"}',
        '{"id":2,"name":"Grace"}',
      ]);
    });

    test('parses primitive JSON arrays', () {
      expect(resolveLoopItemList('[1,2,3]'), ['1', '2', '3']);
    });

    test('parses comma-separated values', () {
      expect(resolveLoopItemList('1, 2, 3'), ['1', '2', '3']);
    });
  });

  group('applyLoopScopedVariables', () {
    test('flattens object fields for {{loop.item.id}}', () {
      final scoped = <String, String>{};
      applyLoopScopedVariables(
        scoped,
        loopItem: '{"id":42,"name":"Ada","auth":{"token":"abc"}}',
        loopIndex: '0',
      );

      expect(scoped['loop.index'], '0');
      expect(scoped['loop.item'], contains('"id":42'));
      expect(scoped['loop.item.id'], '42');
      expect(scoped['loop.item.name'], 'Ada');
      expect(scoped['loop.item.auth.token'], 'abc');
    });

    test('promotes item field into Save as variable', () {
      final scoped = <String, String>{};
      applyLoopScopedVariables(
        scoped,
        loopItem: '{"id":42,"name":"Ada"}',
        loopIndex: '0',
        itemField: 'id',
        itemAs: 'userId',
      );

      expect(scoped['userId'], '42');
      expect(scoped['loop.item.id'], '42');
    });

    test('clears previous loop.item.* on next apply', () {
      final scoped = <String, String>{
        'loop.item': '{"id":1}',
        'loop.item.id': '1',
        'loop.item.name': 'Old',
        'loop.index': '0',
        'userId': '1',
      };
      applyLoopScopedVariables(
        scoped,
        loopItem: '{"id":2}',
        loopIndex: '1',
        itemField: 'id',
        itemAs: 'userId',
      );

      expect(scoped['loop.item.id'], '2');
      expect(scoped.containsKey('loop.item.name'), isFalse);
      expect(scoped['loop.index'], '1');
      expect(scoped['userId'], '2');
    });
  });
}
