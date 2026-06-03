import 'dart:async';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
collectionStateNotifierProvider = StateNotifierProvider(
  (ref) => CollectionStateNotifier(ref, hiveHandler),
);

class CollectionStateNotifier
    extends StateNotifier<Map<String, RequestModel>?> {
  CollectionStateNotifier(this.ref, this.hiveHandler) : super(null) {
    var status = loadData();
    Future.microtask(() {
      if (status) {
        ref.read(requestSequenceProvider.notifier).state = [state!.keys.first];
      }
      ref.read(selectedIdStateProvider.notifier).state = ref.read(
        requestSequenceProvider,
      )[0];
    });
  }

  final Ref ref;
  final HiveHandler hiveHandler;
  final baseHttpResponseModel = const HttpResponseModel();
  final Map<String, Timer> _heartbeatTimers = {};

  void _stopHeartbeat(String requestId) {
    _heartbeatTimers.remove(requestId)?.cancel();
  }

  void _startHeartbeat(String requestId) {
    _stopHeartbeat(requestId);
    final currentRequest = state?[requestId];
    final wsModel = currentRequest?.wsRequestModel;
    if (wsModel == null || !wsModel.enableHeartbeat) return;

    _heartbeatTimers[requestId] = Timer.periodic(const Duration(seconds: 30), (timer) {
      final req = state?[requestId];
      final ws = req?.wsRequestModel;
      if (req == null || ws == null || !req.isStreaming) {
        timer.cancel();
        _heartbeatTimers.remove(requestId);
        return;
      }
      final heartbeatMsg = WebSocketMessage(
        payload: "Heartbeat ping",
        timestamp: DateTime.now(),
        outgoing: true,
        messageType: WebSocketMessageType.sent,
      );
      update(
        id: requestId,
        wsRequestModel: ws.copyWith(
          messageHistory: [...ws.messageHistory, heartbeatMsg],
        ),
      );
    });
  }

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

  void addRequestModel(HttpRequestModel httpRequestModel, {String? name}) {
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
    if (rId == null) return;
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId);

    // Cleanup active connections
    ConnectionManager.instance.disconnect(rId);
    cancelHttpRequest(rId);

    itemIds.remove(rId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];

    String? newId;
    if (itemIds.isNotEmpty) {
      if (idx == 0) {
        newId = itemIds[0];
      } else if (idx < itemIds.length) {
        newId = itemIds[idx];
      } else {
        newId = itemIds.last;
      }
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
    WebSocketRequestModel? wsRequestModel,
    bool? isStreaming,
    bool? isWorking,
  }) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    if (rId == null) {
      debugPrint("Unable to update as Request Id is null");
      return;
    }
    var currentModel = state![rId]!;
    var currentHttpRequestModel = currentModel.httpRequestModel;

    RequestModel newModel;

    if (apiType != null && currentModel.apiType != apiType) {
      final defaultModel = ref.read(settingsProvider).defaultAIModel;
      newModel = switch (apiType) {
        APIType.rest || APIType.graphql => currentModel.copyWith(
          apiType: apiType,
          requestTabIndex: 0,
          name: name ?? currentModel.name,
          description: description ?? currentModel.description,
          httpRequestModel: const HttpRequestModel(),
          aiRequestModel: null,
          wsRequestModel: null,
        ),
        APIType.ai => currentModel.copyWith(
          apiType: apiType,
          requestTabIndex: 0,
          name: name ?? currentModel.name,
          description: description ?? currentModel.description,
          httpRequestModel: null,
          aiRequestModel: defaultModel == null
              ? const AIRequestModel()
              : AIRequestModel.fromJson(defaultModel),
          wsRequestModel: null,
        ),
        APIType.websocket => currentModel.copyWith(
          apiType: apiType,
          requestTabIndex: 0,
          name: name ?? currentModel.name,
          description: description ?? currentModel.description,
          httpRequestModel: null,
          aiRequestModel: null,
          wsRequestModel: const WebSocketRequestModel(),
        ),
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
          isHeaderEnabledList:
              isHeaderEnabledList ??
              currentHttpRequestModel.isHeaderEnabledList,
          isParamEnabledList:
              isParamEnabledList ?? currentHttpRequestModel.isParamEnabledList,
          bodyContentType:
              bodyContentType ?? currentHttpRequestModel.bodyContentType,
          body: body ?? currentHttpRequestModel.body,
          query: query ?? currentHttpRequestModel.query,
          formData: formData ?? currentHttpRequestModel.formData,
        ),
        responseStatus: responseStatus ?? currentModel.responseStatus,
        message: message ?? currentModel.message,
        httpResponseModel: httpResponseModel ?? currentModel.httpResponseModel,
        preRequestScript: preRequestScript ?? currentModel.preRequestScript,
        postRequestScript: postRequestScript ?? currentModel.postRequestScript,
        aiRequestModel: aiRequestModel ?? currentModel.aiRequestModel,
        wsRequestModel: wsRequestModel ?? currentModel.wsRequestModel,
        isStreaming: isStreaming ?? currentModel.isStreaming,
        isWorking: isWorking ?? currentModel.isWorking,
      );
    }

    var map = {...state!};
    map[rId] = newModel;
    state = map;
    unsave();
  }

  /// Send a text message over an active WebSocket connection.
  void sendWebSocketMessage(String requestId, String message) {
    final currentRequest = state?[requestId];
    if (currentRequest == null || currentRequest.apiType != APIType.websocket)
      return;
    final wsModel = currentRequest.wsRequestModel;
    if (wsModel == null) return;

    try {
      ConnectionManager.instance.send(requestId, message);

      final newMessage = WebSocketMessage(
        payload: message,
        timestamp: DateTime.now(),
        outgoing: true,
        messageType: WebSocketMessageType.sent,
      );

      update(
        id: requestId,
        wsRequestModel: wsModel.copyWith(
          messageHistory: [...wsModel.messageHistory, newMessage],
        ),
      );
    } catch (e) {
      debugPrint("Error sending WS message: $e");
    }
  }

  Future<void> _connectWebSocket(
    String requestId,
    RequestModel requestModel,
    WebSocketRequestModel wsModel,
  ) async {
    final connMsg1 = WebSocketMessage(
      payload: "Attempting to connect to ${wsModel.url}",
      timestamp: DateTime.now(),
      outgoing: false,
      messageType: WebSocketMessageType.connected,
    );

    state = {
      ...state!,
      requestId: requestModel.copyWith(
        isWorking: true,
        sendingTime: DateTime.now(),
        wsRequestModel: wsModel.copyWith(
          messageHistory: [...wsModel.messageHistory, connMsg1],
        ),
      ),
    };

    try {
      final channel = await ConnectionManager.instance.connect(
        requestId,
        wsModel.url,
        headers: wsModel.customHeaders.isNotEmpty
            ? wsModel.customHeaders
            : null,
        pingInterval: wsModel.enableHeartbeat ? const Duration(seconds: 30) : null,
      );

      // Await socket handshake validation to catch handshake errors cleanly
      await channel.ready;

      final connMsg2 = WebSocketMessage(
        payload: "Connected to ${wsModel.url}",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final latestRequest = state?[requestId];
      final currentWs = latestRequest?.wsRequestModel ?? wsModel;

      state = {
        ...state!,
        requestId: (latestRequest ?? requestModel).copyWith(
          isWorking: false,
          isStreaming: true,
          wsRequestModel: currentWs.copyWith(
            messageHistory: [...currentWs.messageHistory, connMsg2],
          ),
        ),
      };

      _startHeartbeat(requestId);

      channel.stream.listen(
        (data) {
          final currentRequest = state?[requestId];
          if (currentRequest != null) {
            final currentWs = currentRequest.wsRequestModel;
            if (currentWs != null) {
              final newMessage = WebSocketMessage(
                payload: data.toString(),
                timestamp: DateTime.now(),
                outgoing: false,
                messageType: WebSocketMessageType.received,
              );
              update(
                id: requestId,
                wsRequestModel: currentWs.copyWith(
                  messageHistory: [...currentWs.messageHistory, newMessage],
                ),
              );
            }
          }
        },
        onError: (e) {
          _stopHeartbeat(requestId);
          final currentRequest = state?[requestId];
          final ws = currentRequest?.wsRequestModel;
          if (ws != null) {
            final errMsg = WebSocketMessage(
              payload: "Connection error: $e",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.error,
            );
            update(
              id: requestId,
              wsRequestModel: ws.copyWith(
                messageHistory: [...ws.messageHistory, errMsg],
              ),
            );
          }
        },
        onDone: () async {
          _stopHeartbeat(requestId);
          final currentRequest = state?[requestId];
          if (currentRequest == null) return;
          final ws = currentRequest.wsRequestModel;
          if (ws == null) return;

          if (ws.autoReconnect && currentRequest.isStreaming) {
            final reconnMsg = WebSocketMessage(
              payload: "Connection closed. Reconnecting...",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.disconnected,
            );
            final updatedWs = ws.copyWith(
              messageHistory: [...ws.messageHistory, reconnMsg],
            );
            final latestReq = state?[requestId];
            if (latestReq != null) {
              _connectWebSocket(requestId, latestReq, updatedWs);
            }
          } else {
            final discMsg = WebSocketMessage(
              payload: "Connection closed",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.disconnected,
            );
            update(
              id: requestId,
              isStreaming: false,
              wsRequestModel: ws.copyWith(
                messageHistory: [...ws.messageHistory, discMsg],
              ),
            );
          }
        },
      );
    } catch (e) {
      _stopHeartbeat(requestId);
      final currentRequest = state?[requestId];
      final ws = currentRequest?.wsRequestModel ?? wsModel;
      final errMsg = WebSocketMessage(
        payload: "Connection error: $e",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.error,
      );
      final discMsg = WebSocketMessage(
        payload: "Connection failed",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.disconnected,
      );
      state = {
        ...state!,
        requestId: (currentRequest ?? requestModel).copyWith(
          isWorking: false,
          isStreaming: false,
          wsRequestModel: ws.copyWith(
            messageHistory: [...ws.messageHistory, errMsg, discMsg],
          ),
        ),
      };
    }
  }

  Future<void> sendRequest() async {
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;

    if (requestId == null || state == null) {
      return;
    }

    RequestModel? requestModel = state![requestId];
    if (requestModel?.httpRequestModel == null &&
        requestModel?.aiRequestModel == null &&
        requestModel?.wsRequestModel == null) {
      return;
    }

    // ── WebSocket: connect (not HTTP send) ────────────────────────
    if (requestModel!.apiType == APIType.websocket) {
      final wsModel = requestModel.wsRequestModel;
      if (wsModel != null) {
        await _connectWebSocket(requestId, requestModel, wsModel);
      } else {
        update(id: requestId, message: "Invalid WebSocket model");
      }
      return;
    }

    final defaultUriScheme = ref.read(settingsProvider).defaultUriScheme;
    final EnvironmentModel? originalEnvironmentModel = ref.read(
      activeEnvironmentModelProvider,
    );

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
        executionRequestModel.aiRequestModel!.httpRequestModel!,
      );
    } else {
      substitutedHttpRequestModel = getSubstitutedHttpRequestModel(
        executionRequestModel.httpRequestModel!,
      );
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

    sub = stream.listen(
      (rec) async {
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
          state = {...state!, requestId: newRequestModel};
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
            historyModel = historyModel!.copyWith(
              httpResponseModel: httpResponseModel!,
            );
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
      },
      onDone: () {
        sub?.cancel();
        state = {
          ...state!,
          requestId: newRequestModel.copyWith(isStreaming: false),
        };
        unsave();
      },
      onError: (e) {
        if (!completer.isCompleted) {
          completer.complete((null, null, 'StreamError: $e'));
        }
        terminal.failNetwork(logId, 'StreamError: $e');
      },
    );

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

      //AI-FORMATTING for Non Streaming Variant
      if (!streamingMode &&
          apiType == APIType.ai &&
          response.statusCode == 200) {
        final fb = executionRequestModel.aiRequestModel?.getFormattedOutput(
          kJsonDecoder.convert(httpResponseModel?.body ?? "Error parsing body"),
        );
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
    state = {...state!, requestId: newRequestModel};

    unsave();
  }

  void cancelRequest() {
    final id = ref.read(selectedIdStateProvider);
    if (id == null) return;
    final requestModel = state?[id];
    if (requestModel?.apiType == APIType.websocket) {
      _stopHeartbeat(id);
      final ws = requestModel?.wsRequestModel;
      if (ws != null) {
        final discMsg = WebSocketMessage(
          payload: "Disconnected by user",
          timestamp: DateTime.now(),
          outgoing: false,
          messageType: WebSocketMessageType.disconnected,
        );
        update(
          id: id,
          isStreaming: false,
          isWorking: false,
          wsRequestModel: ws.copyWith(
            messageHistory: [...ws.messageHistory, discMsg],
          ),
        );
      } else {
        update(id: id, isStreaming: false, isWorking: false);
      }
      ConnectionManager.instance.disconnect(id);
    } else {
      cancelHttpRequest(id);
    }
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
            ? (state?[id])?.toJson()
            : (state?[id]?.copyWith(httpResponseModel: null))?.toJson(),
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
    HttpRequestModel httpRequestModel,
  ) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdStateProvider);

    return substituteHttpRequestModel(httpRequestModel, envMap, activeEnvId);
  }
}
