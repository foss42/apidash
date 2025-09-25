import '../../../core/constants/constants.dart';

class ChatResponse {
  final String content;
  final ChatMessageType? messageType;

  const ChatResponse({
    required this.content,
    this.messageType,
  });

  ChatResponse copyWith({
    String? content,
    ChatMessageType? messageType,
  }) {
    return ChatResponse(
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
    );
  }

  @override
  String toString() =>
      'ChatResponse(content: $content, messageType: $messageType)';

  @override
  bool operator ==(covariant ChatResponse other) {
    if (identical(this, other)) return true;

    return other.content == content && other.messageType == messageType;
  }

  @override
  int get hashCode => content.hashCode ^ messageType.hashCode;
}
