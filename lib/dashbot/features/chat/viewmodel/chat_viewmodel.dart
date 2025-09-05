import 'dart:async';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:nanoid/nanoid.dart';

import '../../../core/utils/safe_parse_json_message.dart';
import '../../../core/constants/dashbot_prompts.dart' as dash;
import '../models/chat_models.dart';
import '../repository/chat_remote_repository.dart';

class ChatViewmodel extends StateNotifier<ChatState> {
  ChatViewmodel(this._ref) : super(const ChatState());

  final Ref _ref;
  StreamSubscription<String>? _sub;

  ChatRemoteRepository get _repo => _ref.read(chatRepositoryProvider);
  // Currently selected request and AI model are read from app providers
  RequestModel? get _currentRequest => _ref.read(selectedRequestModelProvider);
  AIRequestModel? get _selectedAIModel {
    final json = _ref.read(settingsProvider).defaultAIModel;
    if (json == null) return null;
    try {
      return AIRequestModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  List<ChatMessage> get currentMessages {
    final id = _currentRequest?.id ?? 'global';
    debugPrint('[Chat] Getting messages for request ID: $id');
    final messages = state.chatSessions[id] ?? const [];
    debugPrint('[Chat] Found ${messages.length} messages');
    return messages;
  }

  Future<void> sendMessage({
    required String text,
    ChatMessageType type = ChatMessageType.general,
    bool countAsUser = true,
  }) async {
    debugPrint(
        '[Chat] sendMessage start: type=$type, countAsUser=$countAsUser');
    final ai = _selectedAIModel;
    if (text.trim().isEmpty && countAsUser) return;
    if (ai == null) {
      debugPrint('[Chat] No AI model configured');
      _appendSystem(
        'AI model is not configured. Please set one.',
        type,
      );
      return;
    }

    final requestId = _currentRequest?.id ?? 'global';
    debugPrint('[Chat] using requestId=$requestId');

    if (countAsUser) {
      _addMessage(
        requestId,
        ChatMessage(
          id: nanoid(),
          content: text,
          role: MessageRole.user,
          timestamp: DateTime.now(),
          messageType: type,
        ),
      );
    }

    final systemPrompt = _composeSystemPrompt(_currentRequest, type);
    final userPrompt = (text.trim().isEmpty && !countAsUser)
        ? 'Please complete the task based on the provided context.'
        : text;
    final enriched = ai.copyWith(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      stream: true,
    );
    debugPrint(
        '[Chat] prompts prepared: system=${systemPrompt.length} chars, user=${userPrompt.length} chars');

    // start stream
    _sub?.cancel();
    state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
    bool receivedAnyChunk = false;
    _sub = _repo.streamChat(request: enriched).listen(
      (chunk) {
        receivedAnyChunk = true;
        if (chunk.isEmpty) return;
        debugPrint('[Chat] chunk(${chunk.length})');
        state = state.copyWith(
          currentStreamingResponse: state.currentStreamingResponse + (chunk),
        );
      },
      onError: (e) {
        debugPrint('[Chat] stream error: $e');
        state = state.copyWith(isGenerating: false);
        _appendSystem('Error: $e', type);
      },
      onDone: () async {
        debugPrint(
            '[Chat] stream done. total=${state.currentStreamingResponse.length}, anyChunk=$receivedAnyChunk');
        if (state.currentStreamingResponse.isNotEmpty) {
          ChatAction? parsedAction;
          try {
            debugPrint(
                '[Chat] Attempting to parse response: ${state.currentStreamingResponse}');
            final Map<String, dynamic> parsed =
                MessageJson.safeParse(state.currentStreamingResponse);
            debugPrint('[Chat] Parsed JSON: $parsed');
            if (parsed.containsKey('action') && parsed['action'] != null) {
              debugPrint('[Chat] Action object found: ${parsed['action']}');
              parsedAction =
                  ChatAction.fromJson(parsed['action'] as Map<String, dynamic>);
              debugPrint('[Chat] Parsed action: ${parsedAction.toJson()}');
            } else {
              debugPrint('[Chat] No action found in response');
            }
          } catch (e) {
            debugPrint('[Chat] Error parsing action: $e');
            debugPrint('[Chat] Error details: ${e.toString()}');
            // If parsing fails, continue without action
          }

          _addMessage(
            requestId,
            ChatMessage(
              id: nanoid(),
              content: state.currentStreamingResponse,
              role: MessageRole.system,
              timestamp: DateTime.now(),
              messageType: type,
              action: parsedAction,
            ),
          );
        } else if (!receivedAnyChunk) {
          // Fallback to non-streaming request
          debugPrint(
              '[Chat] no streamed content; attempting non-streaming fallback');
          try {
            final fallback =
                await _repo.sendChat(request: enriched.copyWith(stream: false));
            if (fallback != null && fallback.isNotEmpty) {
              ChatAction? fallbackAction;
              try {
                final Map<String, dynamic> parsed =
                    MessageJson.safeParse(fallback);
                if (parsed.containsKey('action') && parsed['action'] != null) {
                  fallbackAction = ChatAction.fromJson(
                      parsed['action'] as Map<String, dynamic>);
                }
              } catch (e) {
                debugPrint('[Chat] Fallback error parsing action: $e');
              }

              _addMessage(
                requestId,
                ChatMessage(
                  id: nanoid(),
                  content: fallback,
                  role: MessageRole.system,
                  timestamp: DateTime.now(),
                  messageType: type,
                  action: fallbackAction,
                ),
              );
            } else {
              _appendSystem('No response received from the AI.', type);
            }
          } catch (err) {
            debugPrint('[Chat] fallback error: $err');
            _appendSystem('Error: $err', type);
          }
        }
        state = state.copyWith(
          isGenerating: false,
          currentStreamingResponse: '',
        );
      },
      cancelOnError: true,
    );
  }

  void cancel() {
    _sub?.cancel();
    state = state.copyWith(isGenerating: false);
  }

  Future<void> applyAutoFix(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null) return;

    try {
      switch (action.action) {
        case 'update_field':
          await _applyFieldUpdate(action);
          break;
        case 'add_header':
          await _applyHeaderUpdate(action, isAdd: true);
          break;
        case 'update_header':
          await _applyHeaderUpdate(action, isAdd: false);
          break;
        case 'delete_header':
          await _applyHeaderDelete(action);
          break;
        case 'update_body':
          await _applyBodyUpdate(action);
          break;
        case 'update_url':
          await _applyUrlUpdate(action);
          break;
        case 'update_method':
          await _applyMethodUpdate(action);
          break;
        case 'other':
          await _applyOtherAction(action);
          break;
        default:
          debugPrint('[Chat] Unsupported action: ${action.action}');
      }
    } catch (e) {
      debugPrint('[Chat] Error applying auto-fix: $e');
      _appendSystem('Failed to apply auto-fix: $e', ChatMessageType.general);
    }
  }

  Future<void> _applyFieldUpdate(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null) return;

    final collectionNotifier =
        _ref.read(collectionStateNotifierProvider.notifier);

    switch (action.field) {
      case 'url':
        collectionNotifier.update(url: action.value as String, id: requestId);
        break;
      case 'method':
        final method = HTTPVerb.values.firstWhere(
          (m) => m.name.toLowerCase() == (action.value as String).toLowerCase(),
          orElse: () => HTTPVerb.get,
        );
        collectionNotifier.update(method: method, id: requestId);
        break;
      case 'params':
        if (action.value is Map<String, dynamic>) {
          final params = (action.value as Map<String, dynamic>)
              .entries
              .map(
                  (e) => NameValueModel(name: e.key, value: e.value.toString()))
              .toList();
          collectionNotifier.update(params: params, id: requestId);
        }
        break;
    }
  }

  Future<void> _applyHeaderUpdate(ChatAction action,
      {required bool isAdd}) async {
    final requestId = _currentRequest?.id;
    if (requestId == null || action.path == null) return;

    final collectionNotifier =
        _ref.read(collectionStateNotifierProvider.notifier);
    final currentRequest = _currentRequest;
    if (currentRequest?.httpRequestModel == null) return;

    final headers = List<NameValueModel>.from(
        currentRequest!.httpRequestModel!.headers ?? []);

    if (isAdd) {
      headers.add(
          NameValueModel(name: action.path!, value: action.value as String));
    } else {
      final index = headers.indexWhere((h) => h.name == action.path);
      if (index != -1) {
        headers[index] = headers[index].copyWith(value: action.value as String);
      }
    }

    collectionNotifier.update(headers: headers, id: requestId);
  }

  Future<void> _applyHeaderDelete(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null || action.path == null) return;

    final collectionNotifier =
        _ref.read(collectionStateNotifierProvider.notifier);
    final currentRequest = _currentRequest;
    if (currentRequest?.httpRequestModel == null) return;

    final headers = List<NameValueModel>.from(
        currentRequest!.httpRequestModel!.headers ?? []);
    headers.removeWhere((h) => h.name == action.path);

    collectionNotifier.update(headers: headers, id: requestId);
  }

  Future<void> _applyBodyUpdate(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null) return;

    final collectionNotifier =
        _ref.read(collectionStateNotifierProvider.notifier);
    collectionNotifier.update(body: action.value as String, id: requestId);
  }

  Future<void> _applyUrlUpdate(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null) return;

    final collectionNotifier =
        _ref.read(collectionStateNotifierProvider.notifier);
    collectionNotifier.update(url: action.value as String, id: requestId);
  }

  Future<void> _applyMethodUpdate(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null) return;

    final collectionNotifier =
        _ref.read(collectionStateNotifierProvider.notifier);
    final method = HTTPVerb.values.firstWhere(
      (m) => m.name.toLowerCase() == (action.value as String).toLowerCase(),
      orElse: () => HTTPVerb.get,
    );
    collectionNotifier.update(method: method, id: requestId);
  }

  Future<void> _applyOtherAction(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null) return;

    switch (action.target) {
      case 'test':
        await _applyTestToPostScript(action);
        break;
      default:
        debugPrint('[Chat] Unsupported other action target: ${action.target}');
    }
  }

  Future<void> _applyTestToPostScript(ChatAction action) async {
    final requestId = _currentRequest?.id;
    if (requestId == null) return;

    final collectionNotifier =
        _ref.read(collectionStateNotifierProvider.notifier);
    final testCode = action.value as String;

    // Get the current post-request script (if any)
    final currentRequest = _currentRequest;
    final currentPostScript = currentRequest?.postRequestScript ?? '';

    // Append the test code to the existing post-request script
    final newPostScript = currentPostScript.isEmpty
        ? testCode
        : '$currentPostScript\n\n// Generated Test\n$testCode';

    collectionNotifier.update(postRequestScript: newPostScript, id: requestId);

    debugPrint('[Chat] Test code added to post-request script');
    _appendSystem(
        'Test code has been successfully added to the post-request script.',
        ChatMessageType.generateTest);
  }

  // Helpers
  void _addMessage(String requestId, ChatMessage m) {
    debugPrint(
        '[Chat] Adding message to request ID: $requestId, action: ${m.action?.toJson()}');
    final msgs = state.chatSessions[requestId] ?? const [];
    state = state.copyWith(
      chatSessions: {
        ...state.chatSessions,
        requestId: [...msgs, m],
      },
    );
    debugPrint(
        '[Chat] Message added, total messages for $requestId: ${(state.chatSessions[requestId]?.length ?? 0)}');
  }

  void _appendSystem(String text, ChatMessageType type) {
    final id = _currentRequest?.id ?? 'global';
    _addMessage(
      id,
      ChatMessage(
        id: nanoid(),
        content: text,
        role: MessageRole.system,
        timestamp: DateTime.now(),
        messageType: type,
      ),
    );
  }

  String _composeSystemPrompt(
    RequestModel? req,
    ChatMessageType type,
  ) {
    final history = _buildHistoryBlock();
    final contextBlock = _buildContextBlock(req);
    final task = _buildTaskPrompt(req, type);
    return [
      if (task != null) task,
      if (contextBlock != null) contextBlock,
      if (history.isNotEmpty) history,
    ].join('\n\n');
  }

  String _buildHistoryBlock({int maxTurns = 8}) {
    final id = _currentRequest?.id ?? 'global';
    final messages = state.chatSessions[id] ?? const [];
    if (messages.isEmpty) return '';
    final start = messages.length > maxTurns ? messages.length - maxTurns : 0;
    final recent = messages.sublist(start);
    final buf = StringBuffer('''<conversation_context>
	Only use the following short chat history to maintain continuity. Do not repeat it back.
	''');
    for (final m in recent) {
      final role = m.role == MessageRole.user ? 'user' : 'assistant';
      buf.writeln('- $role: ${m.content}');
    }
    buf.writeln('</conversation_context>');
    return buf.toString();
  }

  String? _buildContextBlock(RequestModel? req) {
    final http = req?.httpRequestModel;
    if (req == null || http == null) return null;
    final headers = http.headersMap.entries
        .map((e) => '"${e.key}": "${e.value}"')
        .join(', ');
    return '''<request_context>
  Request Name: ${req.name}
	URL: ${http.url}
	Method: ${http.method.name.toUpperCase()}
  Status: ${req.responseStatus ?? ''}
	Content-Type: ${http.bodyContentType.name}
	Headers: { $headers }
	Body: ${http.body ?? ''}
  Response: ${req.httpResponseModel?.body ?? ''}
	</request_context>''';
  }

  String? _buildTaskPrompt(RequestModel? req, ChatMessageType type) {
    if (req == null) return null;
    final http = req.httpRequestModel;
    final resp = req.httpResponseModel;
    final prompts = dash.DashbotPrompts();
    switch (type) {
      case ChatMessageType.explainResponse:
        return prompts.explainApiResponsePrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.debugError:
        return prompts.debugApiErrorPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateTest:
        return prompts.generateTestCasesPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateDoc:
        return prompts.generateDocumentationPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.general:
        return prompts.generalInteractionPrompt();
    }
  }
}

final chatViewmodelProvider = StateNotifierProvider<ChatViewmodel, ChatState>((
  ref,
) {
  return ChatViewmodel(ref);
});
