import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:apidash/agentic_testing/memory/hive_memory_repository.dart';
import 'package:apidash/agentic_testing/memory/memory_entry.dart';
import 'package:apidash/agentic_testing/memory/test_memory.dart';

void main() {
  late Directory tempDir;
  late HiveMemoryRepository repository;

  setUp(() async {
    // Isolate Hive execution exclusively to a temporary test directory
    tempDir = await Directory.systemTemp.createTemp('hive_testing');
    Hive.init(tempDir.path);
    repository = HiveMemoryRepository();
    await repository.init();
  });

  tearDown(() async {
    await repository.clearAll();
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('HiveMemoryRepository', () {
    test('returns null when querying unvisited endpoint', () async {
      final memory = await repository.getMemoryForEndpoint('https://unknown.api');
      expect(memory, isNull);
    });

    test('saves and retrieves memory properly for given URL', () async {
      final entry = MemoryEntry(
        id: 'mock-id-1',
        ruleType: 'MissingHeader',
        note: 'Requires X-Api-Key',
        createdAt: DateTime.utc(2025, 5, 20),
      );

      final originalMemory = TestMemory(
        endpointUrl: 'https://api.test',
        entries: [entry],
      );

      await repository.saveMemory(originalMemory);

      // Verify immediate fetch
      final fetchedMemory = await repository.getMemoryForEndpoint('https://api.test');
      
      expect(fetchedMemory, isNotNull);
      expect(fetchedMemory!.endpointUrl, 'https://api.test');
      expect(fetchedMemory.entries.length, 1);
      
      final fetchedEntry = fetchedMemory.entries.first;
      expect(fetchedEntry.note, 'Requires X-Api-Key');
      expect(fetchedEntry.id, 'mock-id-1');
      expect(fetchedEntry.createdAt, DateTime.utc(2025, 5, 20));
      expect(fetchedEntry.ruleType, 'MissingHeader');
    });

    test('updates existing memory gracefully', () async {
      const url = 'https://api.test';
      
      // Save initial
      final entry1 = MemoryEntry(
        id: 'mock-id-1',
        ruleType: 'Bug',
        note: 'First rule',
        createdAt: DateTime.utc(2025, 1, 1),
      );
      final memory1 = TestMemory(endpointUrl: url, entries: [entry1]);
      await repository.saveMemory(memory1);

      // Mutate and save update
      final entry2 = MemoryEntry(
        id: 'mock-id-2',
        ruleType: 'Performance',
        note: 'Second rule',
        createdAt: DateTime.utc(2025, 1, 2),
      );
      final memory2 = memory1.addOrUpdateEntry(entry2);
      await repository.saveMemory(memory2);

      // Fetch and verify both exist perfectly
      final finalMemory = await repository.getMemoryForEndpoint(url);
      expect(finalMemory!.entries.length, 2);
      expect(finalMemory.entries.any((e) => e.note == 'First rule'), isTrue);
      expect(finalMemory.entries.any((e) => e.note == 'Second rule'), isTrue);
    });
  });
}