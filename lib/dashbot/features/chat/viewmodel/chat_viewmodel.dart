import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanoid/nanoid.dart';

import '../../../core/constants/dashbot_prompts.dart' as dash;
import '../../../core/model/dashbot_request_context.dart';
import '../../../core/providers/dashbot_request_provider.dart';
import '../view/widgets/chat_bubble.dart';
import '../models/chat_models.dart';
import '../repository/chat_remote_repository.dart';

class ChatViewmodel extends StateNotifier<ChatState> {
  ChatViewmodel(this._ref) : super(const ChatState());

  final Ref _ref;
  StreamSubscription<String>? _sub;

  ChatRemoteRepository get _repo => _ref.read(chatRepositoryProvider);
  DashbotRequestContext? get _ctx => _ref.read(dashbotRequestContextProvider);

  List<ChatMessage> get currentMessages {
    final id = _ctx?.requestId;
    if (id == null) return const [];
    return state.chatSessions[id] ?? const [];
  }

  Future<void> sendMessage({
    required String text,
    ChatMessageType type = ChatMessageType.general,
    bool countAsUser = true,
  }) async {
    final ctx = _ctx;
    final ai = ctx?.aiRequestModel;
    if (text.trim().isEmpty && countAsUser) return;
    if (ai == null) {
      _appendSystem(
        'AI model is not configured. Please set one in AI Request tab.',
        type,
      );
      return;
    }

    final requestId = ctx?.requestId ?? 'global';

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

    final systemPrompt = _composeSystemPrompt(ctx, type);
    final enriched = ai.copyWith(
      systemPrompt: systemPrompt,
      userPrompt: text,
      stream: true,
    );

    // start stream
    _sub?.cancel();
    state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
    _sub = _repo
        .streamChat(request: enriched)
        .listen(
          (chunk) {
            state = state.copyWith(
              currentStreamingResponse:
                  state.currentStreamingResponse + (chunk),
            );
          },
          onError: (e) {
            state = state.copyWith(isGenerating: false);
            _appendSystem('Error: $e', type);
          },
          onDone: () {
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
    final id = _ctx?.requestId ?? 'global';
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
    DashbotRequestContext? ctx,
    ChatMessageType type,
  ) {
    final history = _buildHistoryBlock();
    final contextBlock = _buildContextBlock(ctx);
    final task = _buildTaskPrompt(ctx, type);
    return [
      if (task != null) task,
      if (contextBlock != null) contextBlock,
      if (history.isNotEmpty) history,
    ].join('\n\n');
  }

  String _buildHistoryBlock({int maxTurns = 8}) {
    final id = _ctx?.requestId ?? 'global';
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

  String? _buildContextBlock(DashbotRequestContext? ctx) {
    final http = ctx?.httpRequestModel;
    if (ctx == null || http == null) return null;
    final headers = http.headersMap.entries
        .map((e) => '"${e.key}": "${e.value}"')
        .join(', ');
    return '''<request_context>
	Request Name: ${ctx.requestName ?? ''}
	URL: ${http.url}
	Method: ${http.method.name.toUpperCase()}
	Status: ${ctx.responseStatus ?? ''}
	Content-Type: ${http.bodyContentType.name}
	Headers: { $headers }
	Body: ${http.body ?? ''}
	Response: ${ctx.httpResponseModel?.body ?? ''}
	</request_context>''';
  }

  String? _buildTaskPrompt(DashbotRequestContext? ctx, ChatMessageType type) {
    if (ctx == null) return null;
    final http = ctx.httpRequestModel;
    final resp = ctx.httpResponseModel;
    final prompts = dash.DashbotPrompts();
    switch (type) {
      case ChatMessageType.explainResponse:
        return prompts.explainApiResponsePrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: ctx.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.debugError:
        return prompts.debugApiErrorPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: ctx.responseStatus,
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
