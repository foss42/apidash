import 'dart:convert';
import 'package:apidash/dashbot/features/chat/models/chat_message.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import '../../../core/constants/constants.dart';
import '../../../core/model/chat_attachment.dart';
import '../../../core/services/curl_import_service.dart';
import '../../../core/services/openapi_import_service.dart';

import '../../../core/utils/safe_parse_json_message.dart';
import '../../../core/constants/dashbot_prompts.dart' as dash;
import '../models/chat_action.dart';
import '../models/chat_state.dart';
import '../repository/chat_remote_repository.dart';
import '../providers/service_providers.dart';

class ChatViewmodel extends StateNotifier<ChatState> {
  ChatViewmodel(this._ref) : super(const ChatState());

  final Ref _ref;

  ChatRemoteRepository get _repo => _ref.read(chatRepositoryProvider);
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
    if (ai == null &&
        type != ChatMessageType.importCurl &&
        type != ChatMessageType.importOpenApi) {
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
          id: getNewUuid(),
          content: text,
          role: MessageRole.user,
          timestamp: DateTime.now(),
          messageType: type,
        ),
      );
    }

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

    // Detect OpenAPI import flow: if the last system message was an OpenAPI import prompt,
    // then treat pasted URL or raw spec as part of the import flow.
    final lastSystemOpenApi = existingMessages.lastWhere(
      (m) =>
          m.role == MessageRole.system &&
          m.messageType == ChatMessageType.importOpenApi,
      orElse: () => ChatMessage(
        id: '',
        content: '',
        role: MessageRole.system,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
    final openApiFlowActive = lastSystemOpenApi.id.isNotEmpty;
    if ((_looksLikeOpenApi(text) || _looksLikeUrl(text)) &&
        (type == ChatMessageType.importOpenApi || openApiFlowActive)) {
      if (_looksLikeOpenApi(text)) {
        await handlePotentialOpenApiPaste(text);
      } else {
        await handlePotentialOpenApiUrl(text);
      }
      return;
    }

    final promptBuilder = _ref.read(promptBuilderProvider);
    // Prepare a substituted copy of current request for prompt context
    final currentReq = _currentRequest;
    final substitutedReq = (currentReq?.httpRequestModel != null)
        ? currentReq!.copyWith(
            httpRequestModel:
                _getSubstitutedHttpRequestModel(currentReq.httpRequestModel!),
          )
        : currentReq;
    String systemPrompt;
    if (type == ChatMessageType.generateCode) {
      final detectedLang = promptBuilder.detectLanguage(text);
      systemPrompt = promptBuilder.buildSystemPrompt(
        substitutedReq,
        type,
        overrideLanguage: detectedLang,
        history: currentMessages,
      );
    } else if (type == ChatMessageType.importCurl) {
      final rqId = _currentRequest?.id ?? 'global';
      // Briefly toggle loading to indicate processing of the import flow prompt
      state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
      _addMessage(
        rqId,
        ChatMessage(
          id: getNewUuid(),
          content:
              '{"explnation":"Let\'s import a cURL request. Paste your complete cURL command below.","actions":[]}',
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.importCurl,
        ),
      );
      state = state.copyWith(isGenerating: false, currentStreamingResponse: '');
      return;
    } else if (type == ChatMessageType.importOpenApi) {
      final rqId = _currentRequest?.id ?? 'global';
      state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
      final uploadAction = ChatAction.fromJson({
        'action': 'upload_asset',
        'target': 'attachment',
        'field': 'openapi_spec',
        'path': null,
        'value': {
          'purpose': 'OpenAPI specification',
          'accepted_types': [
            'application/json',
            'application/yaml',
            'application/x-yaml',
            'text/yaml',
            'text/x-yaml'
          ]
        },
      });
      _addMessage(
        rqId,
        ChatMessage(
          id: getNewUuid(),
          content:
              '{"explnation":"Upload your OpenAPI (JSON or YAML) specification, paste the full spec text, or paste a URL to a spec (e.g., https://api.apidash.dev/openapi.json).","actions":[${jsonEncode(uploadAction.toJson())}]}',
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.importOpenApi,
          actions: [uploadAction],
        ),
      );
      if (_looksLikeOpenApi(text)) {
        await handlePotentialOpenApiPaste(text);
      } else if (_looksLikeUrl(text)) {
        await handlePotentialOpenApiUrl(text);
      }
      state = state.copyWith(isGenerating: false, currentStreamingResponse: '');
      return;
    } else {
      systemPrompt = promptBuilder.buildSystemPrompt(
        substitutedReq,
        type,
        history: currentMessages,
      );
    }
    final userPrompt = (text.trim().isEmpty && !countAsUser)
        ? 'Please complete the task based on the provided context.'
        : text;
    final enriched = ai!.copyWith(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      stream: false,
    );
    debugPrint(
        '[Chat] prompts prepared: system=${systemPrompt.length} chars, user=${userPrompt.length} chars');

    state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
    try {
      final response = await _repo.sendChat(request: enriched);
      if (response != null && response.isNotEmpty) {
        List<ChatAction>? actions;
        try {
          debugPrint('[Chat] Parsing non-streaming response');
          final Map<String, dynamic> parsed = MessageJson.safeParse(response);
          if (parsed.containsKey('actions') && parsed['actions'] is List) {
            actions = (parsed['actions'] as List)
                .whereType<Map<String, dynamic>>()
                .map(ChatAction.fromJson)
                .toList();
            debugPrint('[Chat] Parsed actions list: ${actions.length}');
          }
        } catch (e) {
          debugPrint('[Chat] Error parsing action: $e');
        }

        _addMessage(
          requestId,
          ChatMessage(
            id: getNewUuid(),
            content: response,
            role: MessageRole.system,
            timestamp: DateTime.now(),
            messageType: type,
            actions: actions,
          ),
        );
      } else {
        _appendSystem('No response received from the AI.', type);
      }
    } catch (e) {
      debugPrint('[Chat] sendChat error: $e');
      _appendSystem('Error: $e', type);
    } finally {
      state = state.copyWith(
        isGenerating: false,
        currentStreamingResponse: '',
      );
    }
  }

  void cancel() {
    state = state.copyWith(isGenerating: false);
  }

  void clearCurrentChat() {
    final id = _currentRequest?.id ?? 'global';
    final newSessions = {...state.chatSessions};
    newSessions[id] = [];
    state = state.copyWith(
      chatSessions: newSessions,
      isGenerating: false,
      currentStreamingResponse: '',
    );
  }

  Future<void> sendTaskMessage(ChatMessageType type) async {
    final promptBuilder = _ref.read(promptBuilderProvider);
    final userMessage = promptBuilder.getUserMessageForTask(type);

    final requestId = _currentRequest?.id ?? 'global';

    _addMessage(
      requestId,
      ChatMessage(
        id: getNewUuid(),
        content: userMessage,
        role: MessageRole.user,
        timestamp: DateTime.now(),
        messageType: ChatMessageType.general,
      ),
    );

    await sendMessage(text: '', type: type, countAsUser: false);
  }

  Future<void> applyAutoFix(ChatAction action) async {
    try {
      final msg = await _ref.read(autoFixServiceProvider).apply(action);
      if (msg != null && msg.isNotEmpty) {
        // Message type depends on action context; choose sensible defaults
        final t = (action.actionType == ChatActionType.applyCurl)
            ? ChatMessageType.importCurl
            : (action.actionType == ChatActionType.applyOpenApi)
                ? ChatMessageType.importOpenApi
                : ChatMessageType.general;
        _appendSystem(msg, t);
      }
      // Only target-specific 'other' actions remain here
      if (action.actionType == ChatActionType.other) {
        await _applyOtherAction(action);
      }
    } catch (e) {
      debugPrint('[Chat] Error applying auto-fix: $e');
      _appendSystem('Failed to apply auto-fix: $e', ChatMessageType.general);
    }
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
        if (action.actionType == ChatActionType.applyOpenApi ||
            action.field == 'select_operation') {
          await _applyOpenApi(action);
          break;
        }
        // Unsupported other action
        debugPrint('[Chat] Unsupported other action target: ${action.target}');
        break;
      default:
        debugPrint('[Chat] Unsupported other action target: ${action.target}');
    }
  }

  Future<void> _applyOpenApi(ChatAction action) async {
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
    final baseUrl = payload['baseUrl'] as String? ?? _inferBaseUrl(url);
    // Derive a human-readable route path for naming
    String routePath;
    if (baseUrl.isNotEmpty && url.startsWith(baseUrl)) {
      routePath = url.substring(baseUrl.length);
    } else {
      try {
        final u = Uri.parse(url);
        routePath = u.path.isEmpty ? '/' : u.path;
      } catch (_) {
        routePath = url;
      }
    }
    if (!routePath.startsWith('/')) routePath = '/$routePath';

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
      try {
        jsonDecode(body!);
        bodyContentType = ContentType.json;
      } catch (_) {
        bodyContentType = ContentType.text;
      }
    }

    final withEnvUrl = await _maybeSubstituteBaseUrl(url, baseUrl);
    if (action.field == 'apply_to_selected') {
      if (requestId == null) return;
      collection.update(
        method: method,
        url: withEnvUrl,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
        // Wipe existing parameters and authentication to ensure clean state
        params: const [],
        isParamEnabledList: const [],
        authModel: null,
      );
      _appendSystem('Applied OpenAPI operation to the selected request.',
          ChatMessageType.importOpenApi);
    } else if (action.field == 'apply_to_new') {
      final model = HttpRequestModel(
        method: method,
        url: withEnvUrl,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
      );
      final displayName = '${method.name.toUpperCase()} $routePath';
      collection.addRequestModel(model, name: displayName);
      _appendSystem('Created a new request from the OpenAPI operation.',
          ChatMessageType.importOpenApi);
    } else if (action.field == 'select_operation') {
      // Present apply options for the selected operation
      final applyMsg = OpenApiImportService.buildActionMessageFromPayload(
        payload,
        title: 'Selected ${action.path}. Where should I apply it?',
      );
      final rqId = _currentRequest?.id ?? 'global';
      _addMessage(
        rqId,
        ChatMessage(
          id: getNewUuid(),
          content: jsonEncode(applyMsg),
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.importOpenApi,
          actions: (applyMsg['actions'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ChatAction.fromJson)
              .toList(),
        ),
      );
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
    // Show loading while parsing and generating insights
    state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
    try {
      debugPrint('[cURL] Original: $trimmed');
      final curl = CurlImportService.tryParseCurl(trimmed);
      if (curl == null) {
        _appendSystem(
          'I couldn\'t parse that cURL command. Please check that it:\n- Starts with `curl `\n- Has balanced quotes (wrap JSON bodies in single quotes)\n- Uses backslashes for multi-line commands (if any)\n\nFix the command and paste it again below.\n\nExample:\n\ncurl -X POST https://api.apidash.dev/users \\\n  -H \'Content-Type: application/json\'',
          ChatMessageType.importCurl,
        );
        return;
      }
      final currentCtx = _currentRequestContext();
      // Prepare base message first (without AI insights)
      var built = CurlImportService.buildResponseFromParsed(
        curl,
        current: currentCtx,
      );
      var msg = jsonDecode(built.jsonMessage) as Map<String, dynamic>;

      // Ask AI for cURL insights
      try {
        final ai = _selectedAIModel;
        if (ai != null) {
          final summary = CurlImportService.summaryForPayload(
            jsonDecode(built.jsonMessage)['actions'][0]['value']
                as Map<String, dynamic>,
          );
          final diff = CurlImportService.diffForPayload(
            jsonDecode(built.jsonMessage)['actions'][0]['value']
                as Map<String, dynamic>,
            currentCtx,
          );
          final sys = dash.DashbotPrompts().curlInsightsPrompt(
            curlSummary: summary,
            diff: diff,
            current: currentCtx,
          );
          final res = await _repo.sendChat(
            request: ai.copyWith(
              systemPrompt: sys,
              userPrompt:
                  'Provide concise, actionable insights about this cURL import.',
              stream: false,
            ),
          );
          String? insights;
          if (res != null && res.isNotEmpty) {
            try {
              final parsed = MessageJson.safeParse(res);
              if (parsed['explnation'] is String) {
                insights = parsed['explnation'];
              }
            } catch (_) {
              insights = res;
            }
          }
          if (insights != null && insights.isNotEmpty) {
            // Rebuild message including insights in explanation
            final payload = (msg['actions'] as List).isNotEmpty
                ? (((msg['actions'] as List).first as Map)['value']
                    as Map<String, dynamic>)
                : <String, dynamic>{};
            final enriched = CurlImportService.buildActionMessageFromPayload(
              payload,
              current: currentCtx,
              insights: insights,
            );
            msg = enriched;
            built = (
              jsonMessage: jsonEncode(enriched),
              actions: (enriched['actions'] as List)
                  .whereType<Map<String, dynamic>>()
                  .toList(),
            );
          }
        }
      } catch (e) {
        debugPrint('[cURL] insights error: $e');
      }
      final rqId = _currentRequest?.id ?? 'global';
      _addMessage(
        rqId,
        ChatMessage(
          id: getNewUuid(),
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
      _appendSystem(
          'Parsing failed: $safe. Please adjust the command (ensure it starts with `curl ` and quotes/escapes are correct) and paste it again.',
          ChatMessageType.importCurl);
    } finally {
      state = state.copyWith(
        isGenerating: false,
        currentStreamingResponse: '',
      );
    }
  }

  Map<String, dynamic>? _currentRequestContext() {
    final originalRq = _currentRequest?.httpRequestModel;
    if (originalRq == null) return null;
    final rq = _getSubstitutedHttpRequestModel(originalRq);
    final headers = <String, String>{};
    for (final h in rq.headers ?? const []) {
      final k = (h.name).toString();
      final v = (h.value ?? '').toString();
      if (k.isNotEmpty) headers[k] = v;
    }
    final params = <String, String>{};
    for (final p in rq.params ?? const []) {
      final k = (p.name).toString();
      final v = (p.value ?? '').toString();
      if (k.isNotEmpty) params[k] = v;
    }
    final body = rq.body ?? '';
    final formData = (rq.formData ?? const [])
        .map((f) => {
              'name': f.name,
              'value': f.value,
              'type': f.type.name,
            })
        .toList();
    final isForm = rq.bodyContentType == ContentType.formdata;
    return {
      'method': rq.method.name.toUpperCase(),
      'url': rq.url,
      'headers': headers,
      'params': params,
      'body': body,
      'form': isForm,
      'formData': formData,
    };
  }

  Future<void> handleOpenApiAttachment(ChatAttachment att) async {
    try {
      final content = utf8.decode(att.data);
      await handlePotentialOpenApiPaste(content);
    } catch (e) {
      final safe = e.toString().replaceAll('"', "'");
      _appendSystem(
          '{"explnation":"Failed to read attachment: $safe","actions":[]}',
          ChatMessageType.importOpenApi);
    }
  }

  bool _looksLikeUrl(String input) {
    final t = input.trim();
    if (t.isEmpty) return false;
    return t.startsWith('http://') || t.startsWith('https://');
  }

  Future<void> handlePotentialOpenApiUrl(String text) async {
    final trimmed = text.trim();
    if (!_looksLikeUrl(trimmed)) return;
    state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
    try {
      // Build a simple GET using existing networking stack
      final httpModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: trimmed,
        headers: const [
          // Hint servers that we can accept JSON or YAML
          NameValueModel(
              name: 'Accept',
              value: 'application/json, application/yaml, text/yaml, */*'),
        ],
        isHeaderEnabledList: const [true],
      );

      final (resp, _, err) = await sendHttpRequest(
        getNewUuid(),
        APIType.rest,
        httpModel,
      );

      if (err != null) {
        final safe = err.replaceAll('"', "'");
        _appendSystem(
          '{"explnation":"Failed to fetch URL: $safe","actions":[]}',
          ChatMessageType.importOpenApi,
        );
        return;
      }
      if (resp == null) {
        _appendSystem(
          '{"explnation":"No response received when fetching the URL.","actions":[]}',
          ChatMessageType.importOpenApi,
        );
        return;
      }

      final body = resp.body;
      if (body.trim().isEmpty) {
        _appendSystem(
          '{"explnation":"The fetched URL returned an empty body.","actions":[]}',
          ChatMessageType.importOpenApi,
        );
        return;
      }

      // Try to parse fetched content as OpenAPI
      final spec = OpenApiImportService.tryParseSpec(body);
      if (spec == null) {
        _appendSystem(
          '{"explnation":"The fetched content does not look like a valid OpenAPI spec (JSON or YAML).","actions":[]}',
          ChatMessageType.importOpenApi,
        );
        return;
      }

      // Build insights and show picker (reuse local method)
      String? insights;
      try {
        final ai = _selectedAIModel;
        if (ai != null) {
          final summary = OpenApiImportService.summaryForSpec(spec);
          final meta = OpenApiImportService.extractSpecMeta(spec);
          final sys = dash.DashbotPrompts()
              .openApiInsightsPrompt(specSummary: summary, specMeta: meta);
          final res = await _repo.sendChat(
            request: ai.copyWith(
              systemPrompt: sys,
              userPrompt:
                  'Provide concise, actionable insights about these endpoints.',
              stream: false,
            ),
          );
          if (res != null && res.isNotEmpty) {
            try {
              final map = MessageJson.safeParse(res);
              if (map['explnation'] is String) insights = map['explnation'];
            } catch (_) {
              insights = res;
            }
          }
        }
      } catch (e) {
        debugPrint('[OpenAPI URL] insights error: $e');
      }

      final picker = OpenApiImportService.buildOperationPicker(
        spec,
        insights: insights,
      );
      final rqId = _currentRequest?.id ?? 'global';
      _addMessage(
        rqId,
        ChatMessage(
          id: getNewUuid(),
          content: jsonEncode(picker),
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.importOpenApi,
          actions: (picker['actions'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ChatAction.fromJson)
              .toList(),
        ),
      );
    } catch (e) {
      final safe = e.toString().replaceAll('"', "'");
      _appendSystem(
        '{"explnation":"Failed to fetch or parse OpenAPI from URL: $safe","actions":[]}',
        ChatMessageType.importOpenApi,
      );
    } finally {
      state = state.copyWith(isGenerating: false, currentStreamingResponse: '');
    }
  }

  Future<void> handlePotentialOpenApiPaste(String text) async {
    final trimmed = text.trim();
    if (!_looksLikeOpenApi(trimmed)) return;
    // Show loading while parsing and generating insights
    state = state.copyWith(isGenerating: true, currentStreamingResponse: '');
    try {
      debugPrint('[OpenAPI] Original length: ${trimmed.length}');
      final spec = OpenApiImportService.tryParseSpec(trimmed);
      if (spec == null) {
        _appendSystem(
            '{"explnation":"Sorry, I couldn\'t parse that OpenAPI spec. Ensure it\'s valid JSON or YAML.","actions":[]}',
            ChatMessageType.importOpenApi);
        return;
      }
      // Build a short summary + structured meta for the insights prompt
      final summary = OpenApiImportService.summaryForSpec(spec);

      String? insights;
      try {
        final ai = _selectedAIModel;
        if (ai != null) {
          final meta = OpenApiImportService.extractSpecMeta(spec);
          final sys = dash.DashbotPrompts()
              .openApiInsightsPrompt(specSummary: summary, specMeta: meta);
          final res = await _repo.sendChat(
            request: ai.copyWith(
              systemPrompt: sys,
              userPrompt:
                  'Provide concise, actionable insights about these endpoints.',
              stream: false,
            ),
          );
          if (res != null && res.isNotEmpty) {
            // Ensure we only pass the explnation string to embed into explanation
            try {
              final map = MessageJson.safeParse(res);
              if (map['explnation'] is String) insights = map['explnation'];
            } catch (_) {
              insights = res; // fallback raw text
            }
          }
        }
      } catch (e) {
        debugPrint('[OpenAPI] insights error: $e');
      }

      final picker = OpenApiImportService.buildOperationPicker(
        spec,
        insights: insights,
      );
      final rqId = _currentRequest?.id ?? 'global';
      _addMessage(
        rqId,
        ChatMessage(
          id: getNewUuid(),
          content: jsonEncode(picker),
          role: MessageRole.system,
          timestamp: DateTime.now(),
          messageType: ChatMessageType.importOpenApi,
          actions: (picker['actions'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ChatAction.fromJson)
              .toList(),
        ),
      );
      // Do not generate a separate insights prompt; summary is inline now.
    } catch (e) {
      debugPrint('[OpenAPI] Exception: $e');
      final safe = e.toString().replaceAll('"', "'");
      _appendSystem('{"explnation":"Parsing failed: $safe","actions":[]}',
          ChatMessageType.importOpenApi);
    } finally {
      state = state.copyWith(
        isGenerating: false,
        currentStreamingResponse: '',
      );
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
    final baseUrl = _inferBaseUrl(url);

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

    final withEnvUrl = await _maybeSubstituteBaseUrl(url, baseUrl);
    if (action.field == 'apply_to_selected') {
      if (requestId == null) return;
      collection.update(
        method: method,
        url: withEnvUrl,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
        // Wipe existing parameters and authentication to ensure clean state
        params: const [],
        isParamEnabledList: const [],
        authModel: null,
      );
      _appendSystem(
          'Applied cURL to the selected request.', ChatMessageType.importCurl);
    } else if (action.field == 'apply_to_new') {
      final model = HttpRequestModel(
        method: method,
        url: withEnvUrl,
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
        id: getNewUuid(),
        content: text,
        role: MessageRole.system,
        timestamp: DateTime.now(),
        messageType: type,
      ),
    );
  }

  // Prompt helper methods moved to PromptBuilder service.

  bool _looksLikeOpenApi(String text) {
    final t = text.trim();
    if (t.isEmpty) return false;
    if (t.startsWith('{')) {
      try {
        final m = jsonDecode(t);
        if (m is Map &&
            (m.containsKey('openapi') || m.containsKey('swagger'))) {
          return true;
        }
      } catch (_) {}
    }
    return t.contains('openapi:') || t.contains('swagger:');
  }

  String _inferBaseUrl(String url) =>
      _ref.read(urlEnvServiceProvider).inferBaseUrl(url);

  Future<String> _ensureBaseUrlEnv(String baseUrl) async {
    final svc = _ref.read(urlEnvServiceProvider);
    return svc.ensureBaseUrlEnv(
      baseUrl,
      readEnvs: () => _ref.read(environmentsStateNotifierProvider),
      readActiveEnvId: () => _ref.read(activeEnvironmentIdStateProvider),
      updateEnv: (id, {values}) => _ref
          .read(environmentsStateNotifierProvider.notifier)
          .updateEnvironment(id, values: values),
    );
  }

  Future<String> _maybeSubstituteBaseUrl(String url, String baseUrl) async {
    final svc = _ref.read(urlEnvServiceProvider);
    return svc.maybeSubstituteBaseUrl(
      url,
      baseUrl,
      ensure: (b) => _ensureBaseUrlEnv(b),
    );
  }

  HttpRequestModel _getSubstitutedHttpRequestModel(
      HttpRequestModel httpRequestModel) {
    final envMap = _ref.read(availableEnvironmentVariablesStateProvider);
    final activeEnvId = _ref.read(activeEnvironmentIdStateProvider);
    return substituteHttpRequestModel(
      httpRequestModel,
      envMap,
      activeEnvId,
    );
  }
}

final chatViewmodelProvider = StateNotifierProvider<ChatViewmodel, ChatState>((
  ref,
) {
  return ChatViewmodel(ref);
});
