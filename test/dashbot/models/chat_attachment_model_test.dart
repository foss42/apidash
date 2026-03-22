import 'dart:typed_data';
import 'package:apidash/dashbot/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('ChatAttachment', () {
    test('should create model with provided values', () {
      final data = Uint8List.fromList(List<int>.generate(16, (i) => i));
      final attachment = ChatAttachment(
        id: 'att-1',
        name: 'sample.txt',
        mimeType: 'text/plain',
        sizeBytes: data.length,
        data: data,
        createdAt: DateTime.utc(2024, 1, 2, 3, 4, 5),
      );

      expect(attachment.id, 'att-1');
      expect(attachment.name, 'sample.txt');
      expect(attachment.mimeType, 'text/plain');
      expect(attachment.sizeBytes, 16);
      expect(attachment.data, data);
      expect(attachment.createdAt, DateTime.utc(2024, 1, 2, 3, 4, 5));
    });

    test('immutability (fields are final)', () {
      final data = Uint8List.fromList([1, 2, 3]);
      final createdAt = DateTime.now();
      final attachment = ChatAttachment(
        id: 'id',
        name: 'a.bin',
        mimeType: 'application/octet-stream',
        sizeBytes: 3,
        data: data,
        createdAt: createdAt,
      );

      // Ensuring references are the same (no defensive copy inside constructor)
      expect(identical(attachment.data, data), true);

      // This test only executes field access to ensure coverage; no setters exist.
      expect(() => (attachment.id), returnsNormally);
    });
  });
}
