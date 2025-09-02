import 'dart:async';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:nanoid/nanoid.dart';

import '../../../core/constants/dashbot_prompts.dart' as dash;
import '../view/widgets/chat_bubble.dart';
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
    return state.chatSessions[id] ?? const [];
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
        'AI model is not configured. Please set one in AI Request tab.',
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
          _addMessage(
            requestId,
            ChatMessage(
              id: nanoid(),
              content: state.currentStreamingResponse,
              role: MessageRole.system,
              timestamp: DateTime.now(),
              messageType: type,
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
              _addMessage(
                requestId,
                ChatMessage(
                  id: nanoid(),
                  content: fallback,
                  role: MessageRole.system,
                  timestamp: DateTime.now(),
                  messageType: type,
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

  // Helpers
  void _addMessage(String requestId, ChatMessage m) {
    final msgs = state.chatSessions[requestId] ?? const [];
    state = state.copyWith(
      chatSessions: {
        ...state.chatSessions,
        requestId: [...msgs, m],
      },
    );
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
      case ChatMessageType.general:
        return null;
    }
  }
}

final chatViewmodelProvider = StateNotifierProvider<ChatViewmodel, ChatState>((
  ref,
) {
  return ChatViewmodel(ref);
});
