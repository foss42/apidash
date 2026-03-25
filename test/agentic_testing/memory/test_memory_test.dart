import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/agentic_testing/memory/memory_entry.dart';
import 'package:apidash/agentic_testing/memory/test_memory.dart';

void main() {
  group('TestMemory Domain', () {
    test('MemoryEntry serializes and deserializes correctly', () {
      // Use DateTime.utc directly to avoid local timezone offsets entirely
      final date = DateTime.utc(2025, 1, 1);
      final entry = MemoryEntry(
        id: '123',
        ruleType: 'Authentication',
        note: 'Endpoint strictly requires Bearer prefix',
        createdAt: date,
        isVerified: true,
      );

      final json = entry.toJson();
      expect(json, {
        'id': '123',
        'ruleType': 'Authentication',
        'note': 'Endpoint strictly requires Bearer prefix',
        'createdAt': '2025-01-01T00:00:00.000Z',
        'isVerified': true,
      });

      final rebuilt = MemoryEntry.fromJson(json);
      expect(rebuilt.id, '123');
      expect(rebuilt.isVerified, true);
      expect(rebuilt.createdAt, date);
    });

    test('TestMemory correctly manages entries map and serialization', () {
      final entry1 = MemoryEntry(
        id: 'uuid-1',
        ruleType: 'Performance',
        note: 'Rate limits hit after 50 reqs',
        createdAt: DateTime.utc(2025, 1, 1),
      );

      final entry2 = MemoryEntry(
        id: 'uuid-1', // Same ID, should replace
        ruleType: 'Performance',
        note: 'Rate limits hit after 100 reqs (updated)',
        createdAt: DateTime.utc(2025, 1, 2),
        isVerified: true,
      );

      var memory = const TestMemory(endpointUrl: 'https://api.test');
      memory = memory.addOrUpdateEntry(entry1);
      expect(memory.entries.length, 1);
      expect(memory.entries.first.note, contains('50 reqs'));

      memory = memory.addOrUpdateEntry(entry2);
      expect(memory.entries.length, 1); // Should have overwritten entry1
      expect(memory.entries.first.note, contains('100 reqs'));
      expect(memory.entries.first.isVerified, true);
    });
  });
}