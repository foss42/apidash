import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanoid/nanoid.dart';

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

class AttachmentsState {
  final List<ChatAttachment> items;
  const AttachmentsState({this.items = const []});

  AttachmentsState copyWith({List<ChatAttachment>? items}) =>
      AttachmentsState(items: items ?? this.items);
}

class AttachmentsNotifier extends StateNotifier<AttachmentsState> {
  AttachmentsNotifier() : super(const AttachmentsState());

  ChatAttachment add({
    required String name,
    required String mimeType,
    required Uint8List data,
  }) {
    final att = ChatAttachment(
      id: nanoid(),
      name: name,
      mimeType: mimeType,
      sizeBytes: data.length,
      data: data,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(items: [...state.items, att]);
    debugPrint('[Attachments] Added ${att.name} (${att.sizeBytes} bytes)');
    return att;
  }
}

final attachmentsProvider =
    StateNotifierProvider<AttachmentsNotifier, AttachmentsState>((ref) {
  return AttachmentsNotifier();
});
