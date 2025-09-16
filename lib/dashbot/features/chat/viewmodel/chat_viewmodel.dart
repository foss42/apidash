import 'dart:async';
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:nanoid/nanoid.dart';
import '../../../core/services/curl_import_service.dart';

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
    if (ai == null && type != ChatMessageType.importCurl) {
      debugPrint('[Chat] No AI model configured');
      _appendSystem(
        'AI model is not configured. Please set one.',
        type,
      );
      return;
    }

    final requestId = _currentRequest?.id ?? 'global';
    final existingMessages = state.chatSessions[requestId] ?? const [];
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

    // If user pasted a cURL in import flow, handle locally without AI
    final lastSystemImport = existingMessages.lastWhere(
      (m) =>
          m.role == MessageRole.system &&
          m.messageType == ChatMessageType.importCurl,
      orElse: () => ChatMessage(
        id: '',
        content: '',
        role: MessageRole.system,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
    final importFlowActive = lastSystemImport.id.isNotEmpty;
    if (text.trim().startsWith('curl ') &&
        (type == ChatMessageType.importCurl || importFlowActive)) {
      await handlePotentialCurlPaste(text);
      return;
    }

    String systemPrompt;
    if (type == ChatMessageType.generateCode) {
      final detectedLang = _detectLanguageFromText(text);
      systemPrompt = _composeSystemPrompt(
        _currentRequest,
        type,
        overrideLanguage: detectedLang,
      );
    } else if (type == ChatMessageType.importCurl) {
      final rqId = _currentRequest?.id ?? 'global';
      _addMessage(
        rqId,
        ChatMessage(
          id: nanoid(),
          content:
              '{"explnation":"Let\'s import a cURL request. Paste your complete cURL command below.","actions":[]}',
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.importCurl,
        ),
      );
      return;
    } else {
      systemPrompt = _composeSystemPrompt(_currentRequest, type);
    }
    final userPrompt = (text.trim().isEmpty && !countAsUser)
        ? 'Please complete the task based on the provided context.'
        : text;
    final enriched = ai!.copyWith(
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
          List<ChatAction>? parsedActions;
          try {
            debugPrint(
                '[Chat] Attempting to parse response: ${state.currentStreamingResponse}');
            final Map<String, dynamic> parsed =
                MessageJson.safeParse(state.currentStreamingResponse);
            debugPrint('[Chat] Parsed JSON: $parsed');
            if (parsed.containsKey('actions') && parsed['actions'] is List) {
              parsedActions = (parsed['actions'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map(ChatAction.fromJson)
                  .toList();
              debugPrint('[Chat] Parsed actions list: ${parsedActions.length}');
            }
            if (parsedActions == null || parsedActions.isEmpty) {
              debugPrint('[Chat] No actions list found in response');
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
              actions: parsedActions,
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
              List<ChatAction>? fallbackActions;
              try {
                final Map<String, dynamic> parsed =
                    MessageJson.safeParse(fallback);
                if (parsed.containsKey('actions') &&
                    parsed['actions'] is List) {
                  fallbackActions = (parsed['actions'] as List)
                      .whereType<Map<String, dynamic>>()
                      .map(ChatAction.fromJson)
                      .toList();
                }
                if ((fallbackActions == null || fallbackActions.isEmpty)) {
                  // no actions
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
                  actions: fallbackActions,
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
      switch (action.actionType) {
        case ChatActionType.updateField:
          await _applyFieldUpdate(action);
          break;
        case ChatActionType.addHeader:
          await _applyHeaderUpdate(action, isAdd: true);
          break;
        case ChatActionType.updateHeader:
          await _applyHeaderUpdate(action, isAdd: false);
          break;
        case ChatActionType.deleteHeader:
          await _applyHeaderDelete(action);
          break;
        case ChatActionType.updateBody:
          await _applyBodyUpdate(action);
          break;
        case ChatActionType.updateUrl:
          await _applyUrlUpdate(action);
          break;
        case ChatActionType.updateMethod:
          await _applyMethodUpdate(action);
          break;
        case ChatActionType.applyCurl:
          await _applyCurl(action);
          break;
        case ChatActionType.other:
          await _applyOtherAction(action);
          break;
        case ChatActionType.showLanguages:
          // UI handles selection;
          break;
        case ChatActionType.noAction:
          break;
        case ChatActionType.uploadAsset:
          // Handled by UI upload button
          break;
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
          final enabled = List<bool>.filled(params.length, true);
          collectionNotifier.update(
            params: params,
            isParamEnabledList: enabled,
            id: requestId,
          );
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
      case 'httpRequestModel':
        if (action.actionType == ChatActionType.applyCurl) {
          await _applyCurl(action);
          break;
        }
        // Unsupported other action
        debugPrint('[Chat] Unsupported other action target: ${action.target}');
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
    final testCode = action.value is String ? action.value as String : '';
    final currentPostScript = _currentRequest?.postRequestScript ?? '';
    final newPostScript = currentPostScript.trim().isEmpty
        ? testCode
        : '$currentPostScript\n\n// Generated Test\n$testCode';

    collectionNotifier.update(postRequestScript: newPostScript, id: requestId);

    debugPrint('[Chat] Test code added to post-request script');
    _appendSystem(
        'Test code has been successfully added to the post-request script.',
        ChatMessageType.generateTest);
  }

  // Parse a pasted cURL and present actions to apply to current or new request
  Future<void> handlePotentialCurlPaste(String text) async {
    // quick check
    final trimmed = text.trim();
    if (!trimmed.startsWith('curl ')) return;
    try {
      debugPrint('[cURL] Original: $trimmed');
      final curl = CurlImportService.tryParseCurl(trimmed);
      if (curl == null) {
        _appendSystem(
            '{"explnation":"Sorry, I couldn\'t parse that cURL command. Please verify it starts with `curl ` and is complete.","actions":[]}',
            ChatMessageType.importCurl);
        return;
      }
      final built = CurlImportService.buildResponseFromParsed(curl);
      final msg = jsonDecode(built.jsonMessage) as Map<String, dynamic>;
      final rqId = _currentRequest?.id ?? 'global';
      _addMessage(
        rqId,
        ChatMessage(
          id: nanoid(),
          content: jsonEncode(msg),
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.importCurl,
          actions: (msg['actions'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ChatAction.fromJson)
              .toList(),
        ),
      );
    } catch (e) {
      debugPrint('[cURL] Exception: $e');
      final safe = e.toString().replaceAll('"', "'");
      _appendSystem('{"explnation":"Parsing failed: $safe","actions":[]}',
          ChatMessageType.importCurl);
    }
  }

  Future<void> _applyCurl(ChatAction action) async {
    final requestId = _currentRequest?.id;
    final collection = _ref.read(collectionStateNotifierProvider.notifier);
    final payload = action.value is Map<String, dynamic>
        ? (action.value as Map<String, dynamic>)
        : <String, dynamic>{};

    String methodStr = (payload['method'] as String?)?.toLowerCase() ?? 'get';
    final method = HTTPVerb.values.firstWhere(
      (m) => m.name == methodStr,
      orElse: () => HTTPVerb.get,
    );
    final url = payload['url'] as String? ?? '';

    final headersMap =
        (payload['headers'] as Map?)?.cast<String, dynamic>() ?? {};
    final headers = headersMap.entries
        .map((e) => NameValueModel(name: e.key, value: e.value.toString()))
        .toList();

    final body = payload['body'] as String?;
    final formFlag = payload['form'] == true;
    final formDataListRaw = (payload['formData'] as List?)?.cast<dynamic>();
    final formData = formDataListRaw == null
        ? <FormDataModel>[]
        : formDataListRaw
            .whereType<Map>()
            .map((e) => FormDataModel(
                  name: (e['name'] as String?) ?? '',
                  value: (e['value'] as String?) ?? '',
                  type: (() {
                    final t = (e['type'] as String?) ?? 'text';
                    try {
                      return FormDataType.values
                          .firstWhere((ft) => ft.name == t);
                    } catch (_) {
                      return FormDataType.text;
                    }
                  })(),
                ))
            .toList();

    ContentType bodyContentType;
    if (formFlag || formData.isNotEmpty) {
      bodyContentType = ContentType.formdata;
    } else if ((body ?? '').trim().isEmpty) {
      bodyContentType = ContentType.text;
    } else {
      // Heuristic JSON detection
      try {
        jsonDecode(body!);
        bodyContentType = ContentType.json;
      } catch (_) {
        bodyContentType = ContentType.text;
      }
    }

    if (action.field == 'apply_to_selected') {
      if (requestId == null) return;
      collection.update(
        method: method,
        url: url,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
      );
      _appendSystem(
          'Applied cURL to the selected request.', ChatMessageType.importCurl);
    } else if (action.field == 'apply_to_new') {
      final model = HttpRequestModel(
        method: method,
        url: url,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
      );
      collection.addRequestModel(model, name: 'Imported cURL');
      _appendSystem(
          'Created a new request from the cURL.', ChatMessageType.importCurl);
    }
  }

  // Helpers
  void _addMessage(String requestId, ChatMessage m) {
    debugPrint(
        '[Chat] Adding message to request ID: $requestId, actions: ${m.actions?.map((e) => e.toJson()).toList()}');
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
    ChatMessageType type, {
    String? overrideLanguage,
  }) {
    final history = _buildHistoryBlock();
    final contextBlock = _buildContextBlock(req);
    final task =
        _buildTaskPrompt(req, type, overrideLanguage: overrideLanguage);
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

  String? _buildTaskPrompt(RequestModel? req, ChatMessageType type,
      {String? overrideLanguage}) {
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
      case ChatMessageType.generateCode:
        // If a language is provided, go for code generation; else ask for language first
        if (overrideLanguage == null || overrideLanguage.isEmpty) {
          return prompts.codeGenerationIntroPrompt(
            url: http?.url,
            method: http?.method.name.toUpperCase(),
            headersMap: http?.headersMap,
            body: http?.body,
            bodyContentType: http?.bodyContentType.name,
            paramsMap: http?.paramsMap,
            authType: http?.authModel?.type.name,
          );
        } else {
          return prompts.generateCodePrompt(
            url: http?.url,
            method: http?.method.name.toUpperCase(),
            headersMap: http?.headersMap,
            body: http?.body,
            bodyContentType: http?.bodyContentType.name,
            paramsMap: http?.paramsMap,
            authType: http?.authModel?.type.name,
            language: overrideLanguage,
          );
        }
      case ChatMessageType.importCurl:
        // No AI prompt needed; handled locally.
        return null;
      case ChatMessageType.general:
        return prompts.generalInteractionPrompt();
    }
  }

  // Very light heuristic to detect language keywords in user text
  String? _detectLanguageFromText(String text) {
    final t = text.toLowerCase();
    if (t.contains('python')) return 'Python (requests)';
    if (t.contains('dart')) return 'Dart (http)';
    if (t.contains('golang') || t.contains('go ')) return 'Go (net/http)';
    if (t.contains('javascript') || t.contains('js') || t.contains('fetch')) {
      return 'JavaScript (fetch)';
    }
    if (t.contains('curl')) return 'cURL';
    return null;
  }
}

final chatViewmodelProvider = StateNotifierProvider<ChatViewmodel, ChatState>((
  ref,
) {
  return ChatViewmodel(ref);
});
