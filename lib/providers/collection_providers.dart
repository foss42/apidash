import 'dart:async';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/terminal/terminal.dart';
import 'providers.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/utils.dart';

final selectedIdStateProvider = StateProvider<String?>((ref) => null);

final selectedRequestModelProvider = StateProvider<RequestModel?>((ref) {
  final selectedId = ref.watch(selectedIdStateProvider);
  final collection = ref.watch(collectionStateNotifierProvider);
  if (selectedId == null || collection == null) {
    return null;
  } else {
    return collection[selectedId];
  }
});

final selectedSubstitutedHttpRequestModelProvider =
    StateProvider<HttpRequestModel?>((ref) {
  final selectedRequestModel = ref.watch(selectedRequestModelProvider);
  final envMap = ref.read(availableEnvironmentVariablesStateProvider);
  final activeEnvId = ref.read(activeEnvironmentIdStateProvider);
  if (selectedRequestModel?.httpRequestModel == null) {
    return null;
  } else {
    return substituteHttpRequestModel(
      selectedRequestModel!.httpRequestModel!,
      envMap,
      activeEnvId,
    );
  }
});

final requestSequenceProvider = StateProvider<List<String>>((ref) {
  var ids = hiveHandler.getIds();
  return ids ?? [];
});

final StateNotifierProvider<CollectionStateNotifier, Map<String, RequestModel>?>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier(
          ref,
          hiveHandler,
        ));

class CollectionStateNotifier
    extends StateNotifier<Map<String, RequestModel>?> {
  CollectionStateNotifier(
    this.ref,
    this.hiveHandler,
  ) : super(null) {
    var status = loadData();
    Future.microtask(() {
      if (status) {
        ref.read(requestSequenceProvider.notifier).state = [
          state!.keys.first,
        ];
      }
      ref.read(selectedIdStateProvider.notifier).state =
          ref.read(requestSequenceProvider)[0];
    });
  }

  final Ref ref;
  final HiveHandler hiveHandler;
  final baseHttpResponseModel = const HttpResponseModel();
  final WebSocketService _webSocketService = WebSocketService();

  bool hasId(String id) => state?.keys.contains(id) ?? false;

  RequestModel? getRequestModel(String id) {
    return state?[id];
  }

  void unsave() {
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  void add() {
    final id = getNewUuid();
    final newRequestModel = RequestModel(
      id: id,
      httpRequestModel: const HttpRequestModel(),
    );
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
    ref
        .read(requestSequenceProvider.notifier)
        .update((state) => [id, ...state]);
    ref.read(selectedIdStateProvider.notifier).state = newRequestModel.id;
    unsave();
  }

  Uri buildWebSocketUri(WebSocketRequestModel model) {
    final baseUri = Uri.parse(model.url);

    if (model.enabledParamsMap.isEmpty) {
      return baseUri;
    }

    return baseUri.replace(
      queryParameters: model.enabledParamsMap,
    );
  }

  RequestModel _addWsMessage(
    RequestModel model,
    WebSocketMessageModel message,
  ) {
    final conn =
        model.websocketConnectionModel ?? const WebSocketConnectionModel();

    return model.copyWith(
      websocketConnectionModel: conn.copyWith(
        messages: [...conn.messages, message],
      ),
    );
  }

  void addRequestModel(
    HttpRequestModel httpRequestModel, {
    String? name,
  }) {
    final id = getNewUuid();
    final newRequestModel = RequestModel(
      id: id,
      name: name ?? "",
      httpRequestModel: httpRequestModel,
    );
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
    ref
        .read(requestSequenceProvider.notifier)
        .update((state) => [id, ...state]);
    ref.read(selectedIdStateProvider.notifier).state = newRequestModel.id;
    unsave();
  }

  void reorder(int oldIdx, int newIdx) {
    var itemIds = ref.read(requestSequenceProvider);
    final itemId = itemIds.removeAt(oldIdx);
    itemIds.insert(newIdx, itemId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    unsave();
  }

  void remove({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId!);
    cancelHttpRequest(rId);
    itemIds.remove(rId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];

    String? newId;
    if (idx == 0 && itemIds.isNotEmpty) {
      newId = itemIds[0];
    } else if (itemIds.length > 1) {
      newId = itemIds[idx - 1];
    } else {
      newId = null;
    }

    ref.read(selectedIdStateProvider.notifier).state = newId;

    var map = {...state!};
    map.remove(rId);
    state = map;
    unsave();
  }

  void clearResponse({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    if (rId == null || state?[rId] == null) return;
    var currentModel = state![rId]!;
    final newModel = currentModel.copyWith(
      responseStatus: null,
      message: null,
      httpResponseModel: null,
      isWorking: false,
      sendingTime: null,
    );
    var map = {...state!};
    map[rId] = newModel;
    state = map;
    unsave();
  }

  void duplicate({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId!);
    var currentModel = state![rId]!;
    final newModel = currentModel.copyWith(
      id: newId,
      name: "${currentModel.name} (copy)",
      requestTabIndex: 0,
      responseStatus: null,
      message: null,
      httpRequestModel: currentModel.httpRequestModel?.copyWith(),
      aiRequestModel: currentModel.aiRequestModel?.copyWith(),
      websocketRequestModel: currentModel.websocketRequestModel?.copyWith(),
      websocketConnectionModel: null,
      httpResponseModel: null,
      isWorking: false,
      sendingTime: null,
    );

    itemIds.insert(idx + 1, newId);
    var map = {...state!};
    map[newId] = newModel;
    state = map;

    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    ref.read(selectedIdStateProvider.notifier).state = newId;
    unsave();
  }

  void duplicateFromHistory(HistoryRequestModel historyRequestModel) {
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    var currentModel = historyRequestModel;

    final newModel = RequestModel(
      apiType: currentModel.metaData.apiType,
      id: newId,
      name: "${currentModel.metaData.name} (history)",
      aiRequestModel: currentModel.aiRequestModel?.copyWith(),
      httpRequestModel:
          currentModel.httpRequestModel?.copyWith() ?? HttpRequestModel(),
      responseStatus: currentModel.metaData.responseStatus,
      message: kResponseCodeReasons[currentModel.metaData.responseStatus],
      httpResponseModel: currentModel.httpResponseModel,
      websocketRequestModel: currentModel.websocketRequestModel,
      isWorking: false,
      sendingTime: null,
    );

    itemIds.insert(0, newId);
    var map = {...state!};
    map[newId] = newModel;
    state = map;

    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    ref.read(selectedIdStateProvider.notifier).state = newId;
    unsave();
  }

  void update({
    APIType? apiType,
    String? id,
    HTTPVerb? method,
    AuthModel? authModel,
    String? url,
    String? websocketUrl,
    String? name,
    String? description,
    int? requestTabIndex,
    List<NameValueModel>? headers,
    List<NameValueModel>? params,
    List<bool>? isHeaderEnabledList,
    List<bool>? isParamEnabledList,
    ContentType? bodyContentType,
    String? body,
    String? query,
    List<FormDataModel>? formData,
    int? responseStatus,
    String? message,
    HttpResponseModel? httpResponseModel,
    String? preRequestScript,
    String? postRequestScript,
    AIRequestModel? aiRequestModel,
  }) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    if (rId == null) {
      debugPrint("Unable to update as Request Id is null");
      return;
    }
    var currentModel = state![rId]!;
    var currentHttpRequestModel = currentModel.httpRequestModel;
    WebSocketRequestModel? currentWsRequestModel =
        currentModel.websocketRequestModel;
    RequestModel newModel;

    if (apiType != null && currentModel.apiType != apiType) {
      final defaultModel = ref.read(settingsProvider).defaultAIModel;
      newModel = switch (apiType) {
        APIType.rest || APIType.graphql || APIType.ws => currentModel.copyWith(
            apiType: apiType,
            requestTabIndex: 0,
            name: name ?? currentModel.name,
            description: description ?? currentModel.description,
            httpRequestModel: const HttpRequestModel(),
            websocketRequestModel: WebSocketRequestModel(),
            aiRequestModel: null,
          ),
        APIType.ai => currentModel.copyWith(
            apiType: apiType,
            requestTabIndex: 0,
            name: name ?? currentModel.name,
            description: description ?? currentModel.description,
            httpRequestModel: null,
            aiRequestModel: defaultModel == null
                ? const AIRequestModel()
                : AIRequestModel.fromJson(defaultModel)),
      };
    } else {
      newModel = currentModel.copyWith(
        apiType: apiType ?? currentModel.apiType,
        name: name ?? currentModel.name,
        description: description ?? currentModel.description,
        requestTabIndex: requestTabIndex ?? currentModel.requestTabIndex,
        httpRequestModel: currentHttpRequestModel?.copyWith(
          method: method ?? currentHttpRequestModel.method,
          url: url ?? currentHttpRequestModel.url,
          headers: headers ?? currentHttpRequestModel.headers,
          params: params ?? currentHttpRequestModel.params,
          authModel: authModel ?? currentHttpRequestModel.authModel,
          isHeaderEnabledList: isHeaderEnabledList ??
              currentHttpRequestModel.isHeaderEnabledList,
          isParamEnabledList:
              isParamEnabledList ?? currentHttpRequestModel.isParamEnabledList,
          bodyContentType:
              bodyContentType ?? currentHttpRequestModel.bodyContentType,
          body: body ?? currentHttpRequestModel.body,
          query: query ?? currentHttpRequestModel.query,
          formData: formData ?? currentHttpRequestModel.formData,
        ),
        websocketRequestModel: currentModel.apiType == APIType.ws
            ? currentWsRequestModel?.copyWith(
                url: websocketUrl ?? currentWsRequestModel.url,
                headers: headers ?? currentWsRequestModel.headers,
                params: params ?? currentWsRequestModel.params,
                authModel: authModel ?? currentWsRequestModel.authModel,
                isHeaderEnabledList: isHeaderEnabledList ??
                    currentWsRequestModel.isHeaderEnabledList,
                isParamEnabledList: isParamEnabledList ??
                    currentWsRequestModel.isParamEnabledList,
                initialMessage: body ?? currentWsRequestModel.initialMessage,
              )
            : currentModel.websocketRequestModel,
        responseStatus: responseStatus ?? currentModel.responseStatus,
        message: message ?? currentModel.message,
        httpResponseModel: httpResponseModel ?? currentModel.httpResponseModel,
        preRequestScript: preRequestScript ?? currentModel.preRequestScript,
        postRequestScript: postRequestScript ?? currentModel.postRequestScript,
        aiRequestModel: aiRequestModel ?? currentModel.aiRequestModel,
      );
    }

    var map = {...state!};
    map[rId] = newModel;
    state = map;
    unsave();
  }

  Future<void> sendRequest() async {
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;

    if (requestId == null || state == null) {
      return;
    }

    RequestModel? requestModel = state![requestId];
    if (requestModel?.httpRequestModel == null &&
        requestModel?.aiRequestModel == null) {
      return;
    }

    final defaultUriScheme = ref.read(settingsProvider).defaultUriScheme;
    final EnvironmentModel? originalEnvironmentModel =
        ref.read(activeEnvironmentModelProvider);

    RequestModel executionRequestModel = requestModel!.copyWith();

    if (!requestModel.preRequestScript.isNullOrEmpty()) {
      executionRequestModel = await ref
          .read(jsRuntimeNotifierProvider.notifier)
          .handlePreRequestScript(
        executionRequestModel,
        originalEnvironmentModel,
        (envModel, updatedValues) {
          ref
              .read(environmentsStateNotifierProvider.notifier)
              .updateEnvironment(
                envModel.id,
                name: envModel.name,
                values: updatedValues,
              );
        },
      );
    }

    APIType apiType = executionRequestModel.apiType;
    bool noSSL = ref.read(settingsProvider).isSSLDisabled;
    HttpRequestModel substitutedHttpRequestModel;

    if (apiType == APIType.ai) {
      substitutedHttpRequestModel = getSubstitutedHttpRequestModel(
          executionRequestModel.aiRequestModel!.httpRequestModel!);
    } else {
      substitutedHttpRequestModel = getSubstitutedHttpRequestModel(
          executionRequestModel.httpRequestModel!);
    }

    // Terminal
    final terminal = ref.read(terminalStateProvider.notifier);

    var valRes = getValidationResult(substitutedHttpRequestModel);
    if (valRes != null) {
      terminal.logSystem(
        category: 'validation',
        message: valRes,
        level: TerminalLevel.error,
      );
      ref.read(showTerminalBadgeProvider.notifier).state = true;
    }

    // Terminal: start network log
    final logId = terminal.startNetwork(
      apiType: executionRequestModel.apiType,
      method: substitutedHttpRequestModel.method,
      url: substitutedHttpRequestModel.url,
      requestId: requestId,
      requestHeaders: substitutedHttpRequestModel.enabledHeadersMap,
      requestBodyPreview: substitutedHttpRequestModel.body,
      isStreaming: true,
    );

    // Set model to working and streaming
    state = {
      ...state!,
      requestId: requestModel.copyWith(
        isWorking: true,
        sendingTime: DateTime.now(),
      ),
    };
    bool streamingMode = true; //Default: Streaming First

    final stream = await streamHttpRequest(
      requestId,
      apiType,
      substitutedHttpRequestModel,
      defaultUriScheme: defaultUriScheme,
      noSSL: noSSL,
    );

    HttpResponseModel? httpResponseModel;
    HistoryRequestModel? historyModel;
    RequestModel newRequestModel = requestModel;
    bool isStreamingResponse = false;
    final completer = Completer<(Response?, Duration?, String?)>();

    StreamSubscription? sub;

    sub = stream.listen((rec) async {
      if (rec == null) return;

      isStreamingResponse = rec.$1 ?? false;
      final response = rec.$2;
      final duration = rec.$3;
      final errorMessage = rec.$4;

      if (isStreamingResponse) {
        httpResponseModel = httpResponseModel?.copyWith(
          time: duration,
          sseOutput: [
            ...(httpResponseModel?.sseOutput ?? []),
            if (response != null) response.body,
          ],
        );

        newRequestModel = newRequestModel.copyWith(
          httpResponseModel: httpResponseModel,
          isStreaming: true,
        );
        state = {
          ...state!,
          requestId: newRequestModel,
        };
        // Terminal: append chunk preview
        if (response != null && response.body.isNotEmpty) {
          terminal.addNetworkChunk(
            logId,
            BodyChunk(
              ts: DateTime.now(),
              text: response.body,
              sizeBytes: response.body.codeUnits.length,
            ),
          );
        }
        unsave();

        if (historyModel != null && httpResponseModel != null) {
          historyModel =
              historyModel!.copyWith(httpResponseModel: httpResponseModel!);
          ref
              .read(historyMetaStateNotifier.notifier)
              .editHistoryRequest(historyModel!);
        }
      } else {
        streamingMode = false;
      }

      if (!completer.isCompleted) {
        completer.complete((response, duration, errorMessage));
      }
    }, onDone: () {
      sub?.cancel();
      state = {
        ...state!,
        requestId: newRequestModel.copyWith(isStreaming: false),
      };
      unsave();
    }, onError: (e) {
      if (!completer.isCompleted) {
        completer.complete((null, null, 'StreamError: $e'));
      }
      terminal.failNetwork(logId, 'StreamError: $e');
    });

    final (response, duration, errorMessage) = await completer.future;

    if (response == null) {
      newRequestModel = newRequestModel.copyWith(
        responseStatus: -1,
        message: errorMessage,
        isWorking: false,
        isStreaming: false,
      );
      terminal.failNetwork(logId, errorMessage ?? 'Unknown error');
    } else {
      final statusCode = response.statusCode;
      httpResponseModel = baseHttpResponseModel.fromResponse(
        response: response,
        time: duration,
        isStreamingResponse: isStreamingResponse,
      );

      //AI-FORMATTING for Non Streaming Varaint
      if (!streamingMode &&
          apiType == APIType.ai &&
          response.statusCode == 200) {
        final fb = executionRequestModel.aiRequestModel?.getFormattedOutput(
            kJsonDecoder
                .convert(httpResponseModel?.body ?? "Error parsing body"));
        httpResponseModel = httpResponseModel?.copyWith(formattedBody: fb);
      }

      newRequestModel = newRequestModel.copyWith(
        responseStatus: statusCode,
        message: kResponseCodeReasons[statusCode],
        httpResponseModel: httpResponseModel,
        isWorking: false,
      );

      terminal.completeNetwork(
        logId,
        statusCode: statusCode,
        responseHeaders: response.headers,
        responseBodyPreview: httpResponseModel?.body,
        duration: duration,
      );

      String newHistoryId = getNewUuid();
      historyModel = HistoryRequestModel(
        historyId: newHistoryId,
        metaData: HistoryMetaModel(
          historyId: newHistoryId,
          requestId: requestId,
          apiType: requestModel.apiType,
          name: requestModel.name,
          url: substitutedHttpRequestModel.url,
          method: substitutedHttpRequestModel.method,
          responseStatus: statusCode,
          timeStamp: DateTime.now(),
        ),
        httpRequestModel: substitutedHttpRequestModel,
        aiRequestModel: executionRequestModel.aiRequestModel,
        httpResponseModel: httpResponseModel!,
        preRequestScript: requestModel.preRequestScript,
        postRequestScript: requestModel.postRequestScript,
        authModel: requestModel.httpRequestModel?.authModel,
      );

      ref
          .read(historyMetaStateNotifier.notifier)
          .addHistoryRequest(historyModel!);

      if (!requestModel.postRequestScript.isNullOrEmpty()) {
        newRequestModel = await ref
            .read(jsRuntimeNotifierProvider.notifier)
            .handlePostResponseScript(
          newRequestModel,
          originalEnvironmentModel,
          (envModel, updatedValues) {
            ref
                .read(environmentsStateNotifierProvider.notifier)
                .updateEnvironment(
                  envModel.id,
                  name: envModel.name,
                  values: updatedValues,
                );
          },
        );
      }
    }

    // Final state update
    state = {
      ...state!,
      requestId: newRequestModel,
    };

    unsave();
  }

  Future<void> connectToWebsocket() async {
    final requestId = ref.read(selectedIdStateProvider);

    if (requestId == null || state == null) return;

    final requestModel = state![requestId];
    final historyId = getNewUuid();
    WebSocketRequestModel? wsRequest = requestModel?.websocketRequestModel;

    if (requestModel == null || wsRequest == null) {
      return;
    }

    wsRequest = getSubstitutedWebSocketRequestModel(wsRequest);

    final (uri, error) = getValidWebSocketUri(
      wsRequest.url,
      wsRequest.params,
    );

    final terminal = ref.read(terminalStateProvider.notifier);

    if (uri == null) {
      final errorMessage = WebSocketMessageModel(
        id: getNewUuid(),
        type: WebSocketMessageType.error,
        message: error!,
        timestamp: DateTime.now(),
      );

      state = {
        ...state!,
        requestId: requestModel.copyWith(
          isWorking: false,
          isStreaming: false,
          websocketConnectionModel: WebSocketConnectionModel(
            isClosed: true,
            messages: [errorMessage],
          ),
        ),
      };
      unsave();
      return;
    }

    final wsLogId = terminal.startNetwork(
      apiType: APIType.ws,
      method: HTTPVerb.get,
      url: wsRequest.url,
      requestId: requestId,
      requestHeaders: wsRequest.enabledHeadersMap,
      requestBodyPreview: wsRequest.initialMessage,
      isStreaming: true,
    );
    ref.read(requestLogIdProvider.notifier).update((state) => {
          ...state,
          requestId: wsLogId,
        });

    state = {
      ...state!,
      requestId: requestModel.copyWith(
        isWorking: true,
        sendingTime: DateTime.now(),
        websocketConnectionModel: const WebSocketConnectionModel(
          isConnecting: true,
        ),
      ),
    };

    final connectionResult = await _webSocketService.connect(
      uri: uri,
      headers: wsRequest.enabledHeadersMap,
      initialMessage: wsRequest.initialMessage,
    );

    if (!connectionResult.success) {
      terminal.failNetwork(wsLogId, connectionResult.error!);

      final errorMessage = WebSocketMessageModel(
        id: getNewUuid(),
        type: WebSocketMessageType.error,
        message: connectionResult.error!,
        timestamp: DateTime.now(),
      );

      _saveWebSocketHistory(
        historyId: historyId,
        requestId: requestId,
        requestModel: requestModel,
        wsRequest: wsRequest,
        messages: [errorMessage],
      );

      state = {
        ...state!,
        requestId: requestModel.copyWith(
          isWorking: false,
          isStreaming: false,
          websocketConnectionModel: WebSocketConnectionModel(
            isClosed: true,
            messages: [errorMessage],
          ),
        ),
      };
      unsave();
      return;
    }

    var updatedModel = state![requestId]!;
    final connectMessage = connectionResult.initialMessages!.first;

    updatedModel = updatedModel.copyWith(
      isWorking: false,
      websocketConnectionModel: WebSocketConnectionModel(
        isConnecting: false,
        isConnected: true,
        connectedAt: connectionResult.connectedAt,
        messages: connectionResult.initialMessages!,
      ),
    );

    state = {
      ...state!,
      requestId: updatedModel,
    };

    _webSocketService.listen(
      onMessage: (msg) {
        final model = state![requestId]!;
        state = {
          ...state!,
          requestId: _addWsMessage(model, msg),
        };
      },
      onError: (errorMsg) {
        final model = state![requestId]!;
        final conn = model.websocketConnectionModel;
        terminal.failNetwork(wsLogId, errorMsg.message!);

        if (conn == null) return;

        final disconnectMsg = WebSocketMessageModel(
          id: getNewUuid(),
          type: WebSocketMessageType.disconnect,
          message: 'WebSocket disconnected (error)',
          timestamp: DateTime.now(),
        );

        _saveWebSocketHistory(
          historyId: historyId,
          requestId: requestId,
          requestModel: requestModel,
          wsRequest: wsRequest,
          messages: [connectMessage, errorMsg, disconnectMsg],
        );

        state = {
          ...state!,
          requestId: model.copyWith(
            isWorking: false,
            isStreaming: false,
            websocketConnectionModel: conn.copyWith(
              isConnected: false,
              isClosed: true,
              disconnectedAt: DateTime.now(),
              messages: [
                ...conn.messages,
                errorMsg,
                disconnectMsg,
              ],
            ),
          ),
        };

        unsave();
      },
      onDone: (disconnectMsg) {
        final model = state![requestId]!;
        final conn = model.websocketConnectionModel;
        if (conn == null) return;

        terminal.completeNetwork(
          wsLogId,
          statusCode: 0,
          responseHeaders: const {},
          responseBodyPreview: 'WebSocket disconnected by server',
          duration: DateTime.now().difference(
            conn.connectedAt ?? DateTime.now(),
          ),
        );

        ref.read(requestLogIdProvider.notifier).update((state) {
          final m = {...state};
          m.remove(requestId);
          return m;
        });

        _saveWebSocketHistory(
          historyId: historyId,
          requestId: requestId,
          requestModel: requestModel,
          wsRequest: wsRequest,
          messages: [connectMessage, disconnectMsg],
        );

        state = {
          ...state!,
          requestId: model.copyWith(
            isWorking: false,
            isStreaming: false,
            websocketConnectionModel: conn.copyWith(
              isConnected: false,
              isClosed: true,
              disconnectedAt: DateTime.now(),
              messages: [...conn.messages, disconnectMsg],
            ),
          ),
        };

        unsave();
      },
    );
  }

  Future<bool> sendWebSocketMessage(String message) async {
    final requestId = ref.read(selectedIdStateProvider);

    if (requestId == null || state == null) {
      debugPrint("No active request selected");
      return false;
    }

    if (message.trim().isEmpty) {
      debugPrint("Cannot send empty WebSocket message");
      return false;
    }

    final model = state![requestId];
    final conn = model?.websocketConnectionModel;

    if (conn == null || conn.isConnected != true) {
      state = {
        ...state!,
        requestId: _addWsMessage(
          model!,
          WebSocketMessageModel(
            id: getNewUuid(),
            type: WebSocketMessageType.error,
            message: 'WebSocket is not connected',
            timestamp: DateTime.now(),
          ),
        ),
      };
      return false;
    }

    if (!_webSocketService.isConnected) {
      state = {
        ...state!,
        requestId: _addWsMessage(
          model!,
          WebSocketMessageModel(
            id: getNewUuid(),
            type: WebSocketMessageType.error,
            message: 'WebSocket channel is unavailable',
            timestamp: DateTime.now(),
          ),
        ),
      };
      return false;
    }

    final success = _webSocketService.sendMessage(message);

    if (success) {
      state = {
        ...state!,
        requestId: _addWsMessage(
          model!,
          WebSocketMessageModel(
            id: getNewUuid(),
            type: WebSocketMessageType.sent,
            payload: message,
            timestamp: DateTime.now(),
            sizeBytes: message.length,
          ),
        ),
      };
      unsave();
      return true;
    } else {
      state = {
        ...state!,
        requestId: _addWsMessage(
          model!,
          WebSocketMessageModel(
            id: getNewUuid(),
            type: WebSocketMessageType.error,
            message: 'Send failed',
            timestamp: DateTime.now(),
          ),
        ),
      };
      return false;
    }
  }

  Future<void> disconnectToWebsocket() async {
    final requestId = ref.read(selectedIdStateProvider);
    if (requestId == null || state == null) return;

    final model = state![requestId];
    final conn = model?.websocketConnectionModel;

    if (model == null || conn == null || conn.isConnected != true) return;

    final disconnectMsg = await _webSocketService.disconnect();

    final terminal = ref.read(terminalStateProvider.notifier);
    final logMap = ref.read(requestLogIdProvider);
    final logId = logMap[requestId];

    if (logId != null) {
      terminal.completeNetwork(
        logId,
        statusCode: 0,
        responseHeaders: const {},
        responseBodyPreview: 'WebSocket disconnected manually',
        duration: DateTime.now().difference(
          conn.connectedAt ?? DateTime.now(),
        ),
      );

      ref.read(requestLogIdProvider.notifier).update((state) {
        final m = {...state};
        m.remove(requestId);
        return m;
      });
    }

    final updatedMessages = [
      if (conn.messages.isNotEmpty) conn.messages.first,
      disconnectMsg,
    ];

    final historyId = getNewUuid();
    _saveWebSocketHistory(
      historyId: historyId,
      requestId: requestId,
      requestModel: model,
      wsRequest: model.websocketRequestModel!,
      messages: updatedMessages,
    );

    final updatedModel = model.copyWith(
      isWorking: false,
      isStreaming: false,
      websocketConnectionModel: conn.copyWith(
        isConnected: false,
        isClosed: true,
        disconnectedAt: DateTime.now(),
        messages: [...conn.messages, disconnectMsg],
      ),
    );

    state = {
      ...state!,
      requestId: updatedModel,
    };

    unsave();
  }

  Future<void> cancelWebsocketConnection() async {
    await disconnectToWebsocket();
  }

  void _saveWebSocketHistory({
    required String historyId,
    required String requestId,
    required RequestModel requestModel,
    required WebSocketRequestModel? wsRequest,
    required List<WebSocketMessageModel> messages,
  }) {
    final historyModel = HistoryRequestModel(
      historyId: historyId,
      metaData: HistoryMetaModel(
        historyId: historyId,
        requestId: requestId,
        apiType: APIType.ws,
        name: requestModel.name,
        url: wsRequest?.url ?? "",
        method: HTTPVerb.get,
        responseStatus: 101,
        timeStamp: DateTime.now(),
      ),
      websocketRequestModel: wsRequest,
      websocketConnectionModel: WebSocketConnectionModel(
        messages: messages,
      ),
      httpResponseModel: const HttpResponseModel(),
    );
    ref.read(historyMetaStateNotifier.notifier).addHistoryRequest(historyModel);
  }

  void cancelRequest() {
    final id = ref.read(selectedIdStateProvider);
    cancelHttpRequest(id);
    unsave();
  }

  Future<void> clearData() async {
    ref.read(clearDataStateProvider.notifier).state = true;
    ref.read(selectedIdStateProvider.notifier).state = null;
    await hiveHandler.clear();
    ref.read(clearDataStateProvider.notifier).state = false;
    ref.read(requestSequenceProvider.notifier).state = [];
    state = {};
    unsave();
  }

  bool loadData() {
    var ids = hiveHandler.getIds();
    if (ids == null || ids.length == 0) {
      String newId = getNewUuid();
      state = {
        newId: RequestModel(
          id: newId,
          httpRequestModel: const HttpRequestModel(),
        ),
      };
      return true;
    } else {
      Map<String, RequestModel> data = {};
      for (var id in ids) {
        var jsonModel = hiveHandler.getRequestModel(id);
        if (jsonModel != null) {
          var jsonMap = Map<String, Object?>.from(jsonModel);
          var requestModel = RequestModel.fromJson(jsonMap);
          if (requestModel.httpRequestModel == null) {
            requestModel = requestModel.copyWith(
              httpRequestModel: const HttpRequestModel(),
            );
          }
          data[id] = requestModel;
        }
      }
      state = data;
      return false;
    }
  }

  Future<void> saveData() async {
    ref.read(saveDataStateProvider.notifier).state = true;
    final saveResponse = ref.read(settingsProvider).saveResponses;
    final ids = ref.read(requestSequenceProvider);
    await hiveHandler.setIds(ids);
    for (var id in ids) {
      await hiveHandler.setRequestModel(
        id,
        saveResponse
            ? (state?[id]?.copyWith(websocketConnectionModel: null))?.toJson()
            : (state?[id]?.copyWith(
                    httpResponseModel: null, websocketConnectionModel: null))
                ?.toJson(),
      );
    }

    await hiveHandler.removeUnused();
    ref.read(saveDataStateProvider.notifier).state = false;
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }

  Future<Map<String, dynamic>> exportDataToHAR() async {
    var result = await collectionToHAR(state?.values.toList());
    return result;
    // return {
    //   "data": state!.map((e) => e.toJson(includeResponse: false)).toList()
    // };
  }

  HttpRequestModel getSubstitutedHttpRequestModel(
      HttpRequestModel httpRequestModel) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdStateProvider);

    return substituteHttpRequestModel(
      httpRequestModel,
      envMap,
      activeEnvId,
    );
  }

  WebSocketRequestModel getSubstitutedWebSocketRequestModel(
      WebSocketRequestModel webSocketRequestModel) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdStateProvider);

    return substituteWSRequestModel(
      webSocketRequestModel,
      envMap,
      activeEnvId,
    );
  }
}
