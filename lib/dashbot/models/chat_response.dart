import '../constants.dart';

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
}
