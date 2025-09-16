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
  generateCode,
  importCurl,
  general
}

// Enum definitions for action types and targets to reduce stringly-typed logic.
enum ChatActionType {
  updateField,
  addHeader,
  updateHeader,
  deleteHeader,
  updateBody,
  updateUrl,
  updateMethod,
  showLanguages,
  applyCurl,
  other,
  noAction,
  uploadAsset,
}

enum ChatActionTarget {
  httpRequestModel,
  codegen,
  test,
  code,
  attachment,
}

ChatActionType _chatActionTypeFromString(String s) {
  switch (s) {
    case 'update_field':
      return ChatActionType.updateField;
    case 'add_header':
      return ChatActionType.addHeader;
    case 'update_header':
      return ChatActionType.updateHeader;
    case 'delete_header':
      return ChatActionType.deleteHeader;
    case 'update_body':
      return ChatActionType.updateBody;
    case 'update_url':
      return ChatActionType.updateUrl;
    case 'update_method':
      return ChatActionType.updateMethod;
    case 'show_languages':
      return ChatActionType.showLanguages;
    case 'apply_curl':
      return ChatActionType.applyCurl;
    case 'upload_asset':
      return ChatActionType.uploadAsset;
    case 'no_action':
      return ChatActionType.noAction;
    case 'other':
      return ChatActionType.other;
    default:
      return ChatActionType.other;
  }
}

String chatActionTypeToString(ChatActionType t) {
  switch (t) {
    case ChatActionType.updateField:
      return 'update_field';
    case ChatActionType.addHeader:
      return 'add_header';
    case ChatActionType.updateHeader:
      return 'update_header';
    case ChatActionType.deleteHeader:
      return 'delete_header';
    case ChatActionType.updateBody:
      return 'update_body';
    case ChatActionType.updateUrl:
      return 'update_url';
    case ChatActionType.updateMethod:
      return 'update_method';
    case ChatActionType.showLanguages:
      return 'show_languages';
    case ChatActionType.applyCurl:
      return 'apply_curl';
    case ChatActionType.other:
      return 'other';
    case ChatActionType.noAction:
      return 'no_action';
    case ChatActionType.uploadAsset:
      return 'upload_asset';
  }
}

ChatActionTarget _chatActionTargetFromString(String s) {
  switch (s) {
    case 'httpRequestModel':
      return ChatActionTarget.httpRequestModel;
    case 'codegen':
      return ChatActionTarget.codegen;
    case 'test':
      return ChatActionTarget.test;
    case 'code':
      return ChatActionTarget.code;
    case 'attachment':
      return ChatActionTarget.attachment;
    default:
      return ChatActionTarget.httpRequestModel;
  }
}

String chatActionTargetToString(ChatActionTarget t) {
  switch (t) {
    case ChatActionTarget.httpRequestModel:
      return 'httpRequestModel';
    case ChatActionTarget.codegen:
      return 'codegen';
    case ChatActionTarget.test:
      return 'test';
    case ChatActionTarget.code:
      return 'code';
    case ChatActionTarget.attachment:
      return 'attachment';
  }
}

// Action model for auto-fix functionality
class ChatAction {
  final String action;
  final String target;
  final String field;
  final String? path;
  final dynamic value;
  final ChatActionType actionType; // enum representation
  final ChatActionTarget targetType; // enum representation

  const ChatAction({
    required this.action,
    required this.target,
    this.field = '', // Default to empty string
    this.path,
    this.value,
    required this.actionType,
    required this.targetType,
  });

  factory ChatAction.fromJson(Map<String, dynamic> json) {
    final actionStr = json['action'] as String? ?? 'other';
    final targetStr = json['target'] as String? ?? 'httpRequestModel';
    return ChatAction(
      action: actionStr,
      target: targetStr,
      field: json['field'] as String? ?? '',
      path: json['path'] as String?,
      value: json['value'],
      actionType: _chatActionTypeFromString(actionStr),
      targetType: _chatActionTargetFromString(targetStr),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'target': target,
      'field': field,
      'path': path,
      'value': value,
      'action_type': chatActionTypeToString(actionType),
      'target_type': chatActionTargetToString(targetType),
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
