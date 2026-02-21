import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import '../constants.dart';
import '../models/models.dart';
import '../prompts/prompts.dart' as dash;
import '../repository/repository.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import 'dashbot_active_route_provider.dart';
import 'service_providers.dart';

final chatViewmodelProvider =
    StateNotifierProvider<ChatViewmodel, ChatState>((ref) {
  return ChatViewmodel(ref);
});

class ChatViewmodel extends StateNotifier<ChatState> {
  ChatViewmodel(this._ref) : super(const ChatState());

  final Ref _ref;

  ChatRemoteRepository get _repo => _ref.read(chatRepositoryProvider);
  RequestModel? get _currentRequest => _ref.read(selectedRequestModelProvider);
  HttpRequestModel? get _currentSubstitutedHttpRequestModel =>
      _ref.read(selectedSubstitutedHttpRequestModelProvider);
  AIRequestModel? get _selectedAIModel {
    final json = _ref.read(settingsProvider).defaultAIModel;
    if (json == null) {
      return null;
    }
    try {
      return AIRequestModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  bool _isAIModelValid(AIRequestModel? ai) {
    if (ai == null) return false;
    try {
      return ai.httpRequestModel != null;
    } catch (_) {
      return false;
    }
  }

  List<ChatMessage> get currentMessages {
    final id = _currentRequest?.id ?? 'global';
    final messages = state.chatSessions[id] ?? const [];
    return messages;
  }

  Future<void> sendMessage({
    required String text,
    ChatMessageType type = ChatMessageType.general,
    bool countAsUser = true,
  }) async {
    final ai = _selectedAIModel;
    if (text.trim().isEmpty && countAsUser) return;

    final requestId = _currentRequest?.id ?? 'global';

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

    final existingMessages = state.chatSessions[requestId] ?? const [];

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

    // If no AI Model is configured, block generation UNLESS it is an import flow or pasting text
    if (!_isAIModelValid(ai) &&
        type != ChatMessageType.importCurl &&
        type != ChatMessageType.importOpenApi &&
        !(text.trim().startsWith('curl ') && importFlowActive) &&
        !((_looksLikeOpenApi(text) || _looksLikeUrl(text)) &&
            openApiFlowActive)) {
      debugPrint('[Chat] No AI model configured or incorrectly configured');
      _appendSystem(
        'AI model is not properly configured. Please select and configure a model using the button at the top.',
        type,
      );
      return;
    }

    // Extract import logic that doesn't require an LLM to proceed initially
    if (type == ChatMessageType.importCurl ||
        (text.trim().startsWith('curl ') && importFlowActive)) {
      if (text.trim().startsWith('curl ')) {
        await handlePotentialCurlPaste(text);
        return;
      }
    }

    if (type == ChatMessageType.importOpenApi ||
        ((_looksLikeOpenApi(text) || _looksLikeUrl(text)) &&
            openApiFlowActive)) {
      if (_looksLikeOpenApi(text)) {
        await handlePotentialOpenApiPaste(text);
        return;
      } else if (_looksLikeUrl(text)) {
        await handlePotentialOpenApiUrl(text);
        return;
      }
    }

    // At this point, all basic import checks and logic are finished
    // Anything below this point will execute an AI request via `buildTaskPrompt` or `buildMessagePrompt`

    final promptBuilder = _ref.read(promptBuilderProvider);
    // Prepare a substituted copy of current request for prompt context
    final currentReq = _currentRequest;
    final substitutedReq = (currentReq?.httpRequestModel != null)
        ? currentReq!.copyWith(
            httpRequestModel: _currentSubstitutedHttpRequestModel?.copyWith())
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
              '{"explanation":"Let\'s import a cURL request. Paste your complete cURL command below.","actions":[]}',
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
              '{"explanation":"Upload your OpenAPI (JSON or YAML) specification, paste the full spec text, or paste a URL to a spec (e.g., https://api.apidash.dev/openapi.json).","actions":[${jsonEncode(uploadAction.toJson())}]}',
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
    if (ai == null) {
      if (type != ChatMessageType.importCurl &&
          type != ChatMessageType.importOpenApi) {
        _appendSystem('Cannot generate task: AI model is missing.',
            ChatMessageType.general);
      }
      return;
    }

    final enriched = ai.copyWith(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      stream: false,
    );

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
      final safeError = e.toString().replaceFirst('Exception: ', '');
      _appendSystem('Error: $safeError', type);
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
    // Reset to base route (unpins chat) after clearing messages.
    _ref.read(dashbotActiveRouteProvider.notifier).resetToBaseRoute();
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
      if (action.actionType == ChatActionType.applyOpenApi) {
        await _applyOpenApi(action);
        return;
      }
      if (action.actionType == ChatActionType.applyCurl) {
        await _applyCurl(action);
        return;
      }

      final msg = await _ref.read(autoFixServiceProvider).apply(action);
      if (msg != null && msg.isNotEmpty) {
        final t = ChatMessageType.general;
        _appendSystem(msg, t);
      }
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

    String sourceTitle = (payload['sourceName'] as String?) ?? '';
    if (sourceTitle.trim().isEmpty) {
      final specObj = payload['spec'];
      if (specObj is OpenApi) {
        try {
          final t = specObj.info.title.trim();
          if (t.isNotEmpty) sourceTitle = t;
        } catch (_) {}
      }
    }
    debugPrint('[OpenAPI] baseUrl="$baseUrl" title="$sourceTitle" url="$url"');
    final withEnvUrl = await _maybeSubstituteBaseUrlForOpenApi(
      url,
      baseUrl,
      sourceTitle,
    );
    debugPrint('[OpenAPI] withEnvUrl="$withEnvUrl');
    if (action.field == 'apply_to_new') {
      debugPrint('[OpenAPI] withEnvUrl="$withEnvUrl');
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
        'Test code has been successfully added to the post-response script.',
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
      final curl = Curl.tryParse(trimmed);
      if (curl == null) {
        _appendSystem(
          'I couldn\'t parse that cURL command. Please check that it:\n- Starts with `curl `\n- Has balanced quotes (wrap JSON bodies in single quotes)\n- Uses backslashes for multi-line commands (if any)\n\nFix the command and paste it again below.\n\nExample:\n\ncurl -X POST https://api.apidash.dev/users \\\n  -H \'Content-Type: application/json\'',
          ChatMessageType.importCurl,
        );
        return;
      }
      final currentSubstitutedHttpRequestJson =
          _currentSubstitutedHttpRequestModel?.toJson();
      final payload = convertCurlToHttpRequestModel(curl).toJson();
      // Prepare base message first (without AI insights)
      var built = CurlImportService.buildResponseFromParsed(
        payload,
        currentJson: currentSubstitutedHttpRequestJson,
      );
      var msg = jsonDecode(built.jsonMessage) as Map<String, dynamic>;

      // Ask AI for cURL insights
      try {
        final ai = _selectedAIModel;
        if (ai != null) {
          final diff = jsonDecode(built.jsonMessage)['meta']['diff'] as String;
          final sys = dash.DashbotPrompts().curlInsightsPrompt(
            diff: diff,
            newReq: payload,
          );
          final res = await _repo.sendChat(
            request: ai.copyWith(
              systemPrompt: sys,
              stream: false,
            ),
          );
          String? insights;
          if (res != null && res.isNotEmpty) {
            try {
              final parsed = MessageJson.safeParse(res);
              if (parsed['explanation'] is String) {
                insights = parsed['explanation'];
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
              current: currentSubstitutedHttpRequestJson,
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
    final originalRq = _currentSubstitutedHttpRequestModel;
    if (originalRq == null) return null;
    return originalRq.toJson();
  }

  Future<void> handleOpenApiAttachment(ChatAttachment att) async {
    try {
      final content = utf8.decode(att.data);
      await handlePotentialOpenApiPaste(content);
    } catch (e) {
      final safe = e.toString().replaceAll('"', "'");
      _appendSystem(
          '{"explanation":"Failed to read attachment: $safe","actions":[]}',
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
          '{"explanation":"Failed to fetch URL: $safe","actions":[]}',
          ChatMessageType.importOpenApi,
        );
        return;
      }
      if (resp == null) {
        _appendSystem(
          '{"explanation":"No response received when fetching the URL.","actions":[]}',
          ChatMessageType.importOpenApi,
        );
        return;
      }

      final body = resp.body;
      if (body.trim().isEmpty) {
        _appendSystem(
          '{"explanation":"The fetched URL returned an empty body.","actions":[]}',
          ChatMessageType.importOpenApi,
        );
        return;
      }

      // Try to parse fetched content as OpenAPI
      final spec = OpenApiImportService.tryParseSpec(body);
      if (spec == null) {
        _appendSystem(
          '{"explanation":"The fetched content does not look like a valid OpenAPI spec (JSON or YAML).","actions":[]}',
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
              if (map['explanation'] is String) insights = map['explanation'];
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
        '{"explanation":"Failed to fetch or parse OpenAPI from URL: $safe","actions":[]}',
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
            '{"explanation":"Sorry, I couldn\'t parse that OpenAPI spec. Ensure it\'s valid JSON or YAML.","actions":[]}',
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
            // Ensure we only pass the explanation string to embed into explanation
            try {
              final map = MessageJson.safeParse(res);
              if (map['explanation'] is String) insights = map['explanation'];
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
      _appendSystem('{"explanation":"Parsing failed: $safe","actions":[]}',
          ChatMessageType.importOpenApi);
    } finally {
      state = state.copyWith(
        isGenerating: false,
        currentStreamingResponse: '',
      );
    }
  }

  Future<void> _applyCurl(ChatAction action) async {
    try {
      final requestId = _currentRequest?.id;
      final payload = action.value is Map<String, dynamic>
          ? (action.value as Map<String, dynamic>)
          : <String, dynamic>{};
      final httpRequestModel = HttpRequestModel.fromJson(payload);
      final baseUrl = _inferBaseUrl(httpRequestModel.url);
      final withEnvUrl =
          await _maybeSubstituteBaseUrl(httpRequestModel.url, baseUrl);

      if (action.field == 'apply_to_selected') {
        if (requestId == null) return;
        _ref.read(collectionStateNotifierProvider.notifier).update(
              method: httpRequestModel.method,
              url: withEnvUrl,
              headers: httpRequestModel.headers,
              isHeaderEnabledList: List<bool>.filled(
                  httpRequestModel.headers?.length ?? 0, true),
              body: httpRequestModel.body,
              bodyContentType: httpRequestModel.bodyContentType,
              formData: httpRequestModel.formData,
              params: httpRequestModel.params,
              isParamEnabledList:
                  List<bool>.filled(httpRequestModel.params?.length ?? 0, true),
              authModel: null,
            );
        _appendSystem('Applied cURL to the selected request.',
            ChatMessageType.importCurl);
      } else if (action.field == 'apply_to_new') {
        final model = httpRequestModel.copyWith(
          url: withEnvUrl,
        );
        _ref
            .read(collectionStateNotifierProvider.notifier)
            .addRequestModel(model, name: 'Imported cURL');
        _appendSystem(
            'Created a new request from the cURL.', ChatMessageType.importCurl);
      }
    } catch (e) {
      _appendSystem('Error encountered while importing cURL - $e',
          ChatMessageType.importCurl);
    }
  }

  // Helpers
  void _addMessage(String requestId, ChatMessage m) {
    final msgs = state.chatSessions[requestId] ?? const [];
    final updatedSessions =
        Map<String, List<ChatMessage>>.from(state.chatSessions);
    updatedSessions[requestId] = [...msgs, m];
    state = state.copyWith(chatSessions: updatedSessions);
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

  Future<String> _maybeSubstituteBaseUrlForOpenApi(
      String url, String baseUrl, String title) async {
    final svc = _ref.read(urlEnvServiceProvider);
    return svc.maybeSubstituteBaseUrl(
      url,
      baseUrl,
      ensure: (b) => svc.ensureBaseUrlEnvForOpenApi(
        b,
        title: title,
        readEnvs: () => _ref.read(environmentsStateNotifierProvider),
        readActiveEnvId: () => _ref.read(activeEnvironmentIdStateProvider),
        updateEnv: (id, {values}) => _ref
            .read(environmentsStateNotifierProvider.notifier)
            .updateEnvironment(id, values: values),
      ),
    );
  }
}
