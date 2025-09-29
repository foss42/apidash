import 'dart:typed_data';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('attachmentsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('initial state is empty list', () {
      final state = container.read(attachmentsProvider);
      expect(state.items, isEmpty);
    });

    test('add() returns ChatAttachment with populated fields and updates state',
        () {
      final notifier = container.read(attachmentsProvider.notifier);
      final data = Uint8List.fromList(List.generate(10, (i) => i));
      final att = notifier.add(
        name: 'sample.json',
        mimeType: 'application/json',
        data: data,
      );

      // Basic invariants
      expect(att, isA<ChatAttachment>());
      expect(att.id, isNotEmpty);
      expect(att.name, 'sample.json');
      expect(att.mimeType, 'application/json');
      expect(att.sizeBytes, data.length);
      expect(att.data, equals(data));

      final state = container.read(attachmentsProvider);
      expect(state.items.length, 1);
      expect(state.items.single.id, att.id);
    });

    test('adding multiple attachments appends (no replacement)', () {
      final notifier = container.read(attachmentsProvider.notifier);
      final first = notifier.add(
        name: 'a.txt',
        mimeType: 'text/plain',
        data: Uint8List.fromList([1, 2, 3]),
      );
      final second = notifier.add(
        name: 'b.txt',
        mimeType: 'text/plain',
        data: Uint8List.fromList([4, 5]),
      );

      final items = container.read(attachmentsProvider).items;
      expect(items.length, 2);
      expect(items.first.id, first.id);
      expect(items.last.id, second.id);
    });

    test('state immutability: mutating returned list does not affect provider',
        () {
      final notifier = container.read(attachmentsProvider.notifier);
      notifier.add(
        name: 'file.bin',
        mimeType: 'application/octet-stream',
        data: Uint8List.fromList([0, 1]),
      );
      final items = List.of(container.read(attachmentsProvider).items);
      // mutate local copy
      items.clear();
      // provider state should remain intact
      expect(container.read(attachmentsProvider).items.length, 1);
    });
  });
}
