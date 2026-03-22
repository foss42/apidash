import 'package:flutter/services.dart';

class ChatAttachment {
  final String id;
  final String name;
  final String mimeType;
  final int sizeBytes;
  final Uint8List data;
  final DateTime createdAt;

  ChatAttachment({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.sizeBytes,
    required this.data,
    required this.createdAt,
  });
}
