import 'package:apidash/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

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
      id: getNewUuid(),
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
