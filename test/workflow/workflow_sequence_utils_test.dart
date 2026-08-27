import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/utils/workflow_sequence_utils.dart';
import 'package:test/test.dart';

void main() {
  group('resolveSequenceItems', () {
    test('list is bracket comma-separated', () {
      final items = resolveSequenceItems(
        source: WorkflowSequenceSource.list,
        value: '[alice, bob, carol]',
      );
      expect(items, ['alice', 'bob', 'carol']);
    });

    test('list supports quoted json-ish array', () {
      final items = resolveSequenceItems(
        source: WorkflowSequenceSource.list,
        value: '["alice", "bob"]',
      );
      expect(items, ['alice', 'bob']);
    });

    test('json array', () {
      final items = resolveSequenceItems(
        source: WorkflowSequenceSource.json,
        value: '[{"id":1},{"id":2}]',
      );
      expect(items.length, 2);
      expect(items.first, contains('"id"'));
    });

    test('jsonl lines', () {
      final items = resolveSequenceItems(
        source: WorkflowSequenceSource.jsonl,
        value: '{"prompt":"hi"}\n\n{"prompt":"yo"}',
      );
      expect(items.length, 2);
    });

    test('encodeSequenceVariable round-trips for foreach', () {
      final encoded = encodeSequenceVariable(['a', '{"id":1}']);
      expect(encoded, '["a",{"id":1}]');
    });
  });
}
