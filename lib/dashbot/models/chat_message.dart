import 'package:flutter/foundation.dart';
import '../constants.dart';
import 'chat_action.dart';

class ChatMessage {
  final String id;
  final String explanation;
  final List<ChatAction> actions;
  final MessageRole role;
  final DateTime timestamp;
  final ChatMessageType? messageType;

  const ChatMessage({
    required this.id,
    required this.explanation,
    required this.actions,
    required this.role,
    required this.timestamp,
    this.messageType,
  });

  ChatMessage copyWith({
    String? id,
    String? explanation,
    List<ChatAction>? actions,
    MessageRole? role,
    DateTime? timestamp,
    ChatMessageType? messageType,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      explanation: explanation ?? this.explanation,
      actions: actions ?? this.actions,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, explanation: $explanation, actions: $actions, role: $role, timestamp: $timestamp, messageType: $messageType)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.explanation == explanation &&
        listEquals(other.actions, actions) &&
        other.role == role &&
        other.timestamp == timestamp &&
        other.messageType == messageType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    explanation.hashCode ^
    actions.hashCode ^
    role.hashCode ^
    timestamp.hashCode ^
    messageType.hashCode;
  }
}