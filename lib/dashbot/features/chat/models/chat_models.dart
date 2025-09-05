/// Role of a chat message author.
enum MessageRole { user, system }

class ChatState {
  final Map<String, List<ChatMessage>> chatSessions; // requestId -> messages
  final bool isGenerating;
  final String currentStreamingResponse;
  final String? currentRequestId;
  final ChatFailure? lastError;

  const ChatState({
    this.chatSessions = const {},
    this.isGenerating = false,
    this.currentStreamingResponse = '',
    this.currentRequestId,
    this.lastError,
  });

  ChatState copyWith({
    Map<String, List<ChatMessage>>? chatSessions,
    bool? isGenerating,
    String? currentStreamingResponse,
    String? currentRequestId,
    ChatFailure? lastError,
  }) {
    return ChatState(
      chatSessions: chatSessions ?? this.chatSessions,
      isGenerating: isGenerating ?? this.isGenerating,
      currentStreamingResponse:
          currentStreamingResponse ?? this.currentStreamingResponse,
      currentRequestId: currentRequestId ?? this.currentRequestId,
      lastError: lastError ?? this.lastError,
    );
  }
}

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final ChatMessageType? messageType;
  final ChatAction? action;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.messageType,
    this.action,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    ChatMessageType? messageType,
    ChatAction? action,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      action: action ?? this.action,
    );
  }
}

class ChatResponse {
  final String content;
  final ChatMessageType? messageType;

  const ChatResponse({required this.content, this.messageType});

  ChatResponse copyWith({String? content, ChatMessageType? messageType}) {
    return ChatResponse(
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
    );
  }
}

enum ChatMessageType {
  explainResponse,
  debugError,
  generateTest,
  generateDoc,
  general
}

// Action model for auto-fix functionality
class ChatAction {
  final String action;
  final String target;
  final String field;
  final String? path;
  final dynamic value;

  const ChatAction({
    required this.action,
    required this.target,
    this.field = '', // Default to empty string
    this.path,
    this.value,
  });

  factory ChatAction.fromJson(Map<String, dynamic> json) {
    return ChatAction(
      action: json['action'] as String,
      target: json['target'] as String,
      field: json['field'] as String? ??
          '', // Default to empty string if not provided
      path: json['path'] as String?,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'target': target,
      'field': field,
      'path': path,
      'value': value,
    };
  }
}

// Failure classes using fpdart Either pattern
abstract class ChatFailure implements Exception {
  final String message;
  final String? code;
  const ChatFailure(this.message, {this.code});

  @override
  String toString() => 'ChatFailure: $message';
}

class NetworkFailure extends ChatFailure {
  const NetworkFailure(super.message, {super.code});
}

class AIModelNotConfiguredFailure extends ChatFailure {
  const AIModelNotConfiguredFailure()
      : super("Please configure an AI model in the AI Request tab");
}

class APIKeyMissingFailure extends ChatFailure {
  const APIKeyMissingFailure(String provider)
      : super("API key missing for $provider");
}

class NoRequestSelectedFailure extends ChatFailure {
  const NoRequestSelectedFailure() : super("No request selected");
}

class InvalidRequestContextFailure extends ChatFailure {
  const InvalidRequestContextFailure(super.message);
}

class RateLimitFailure extends ChatFailure {
  const RateLimitFailure()
      : super("Rate limit exceeded. Please try again later.");
}

class StreamingFailure extends ChatFailure {
  const StreamingFailure(super.message);
}
