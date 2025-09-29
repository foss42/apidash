import 'package:flutter/foundation.dart';
import '../constants.dart';
import 'chat_action.dart';

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final ChatMessageType? messageType;
  // Multiple actions support. If provided, UI should render these.
  final List<ChatAction>? actions;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.messageType,
    this.actions,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    ChatMessageType? messageType,
    List<ChatAction>? actions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      actions: actions ?? this.actions,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: $content, role: $role, timestamp: $timestamp, messageType: $messageType, actions: $actions)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.content == content &&
        other.role == role &&
        other.timestamp == timestamp &&
        other.messageType == messageType &&
        listEquals(other.actions, actions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        role.hashCode ^
        timestamp.hashCode ^
        messageType.hashCode ^
        actions.hashCode;
  }
}
