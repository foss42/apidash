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
  final Map<String, Timer> _appHeartbeatTimers = {};

  /// Pending auto-reconnect timer per request id. At most one entry per id
  /// exists, which is what keeps repeated closes from fanning out into a
  /// reconnect storm.
  final Map<String, Timer> _wsReconnectTimers = {};

  /// Consecutive auto-reconnect attempts per request id, used to compute the
  /// backoff delay. Cleared once a connection proves stable.
  final Map<String, int> _wsReconnectAttempts = {};

  /// When the current connection for a request id was established, used to tell
  /// a recovered session from a flapping one (see [kWsConnectionStableAfter]).
  final Map<String, DateTime> _wsConnectedAt = {};

  @override
  void dispose() {
    for (final timer in _appHeartbeatTimers.values) {
      timer.cancel();
    }
    _appHeartbeatTimers.clear();
    for (final timer in _wsReconnectTimers.values) {
      timer.cancel();
    }
    _wsReconnectTimers.clear();
    _wsReconnectAttempts.clear();
    _wsConnectedAt.clear();
    super.dispose();
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
    _stopMessageHeartbeat(rId);
    _resetWsReconnect(rId);
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
      wsRequestModel: currentModel.wsRequestModel?.copyWith(),
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
        wsRequestModel: currentModel.apiType == APIType.websocket
            ? (wsRequestModel ?? currentModel.wsRequestModel)?.copyWith(
                // Resolution order matters. The top-level headers/params args
                // are an optional MERGE onto the model being written. A freshly
                // passed `wsRequestModel` may already carry its own
                // headers/params; those must NOT be clobbered when the merge
                // args are null. Falling straight back to
                // `currentModel.wsRequestModel?.x` (which is null for a brand
                // new ws model) would pass `null` explicitly to freezed
                // copyWith and overwrite the passed model's fields. So prefer:
                //   1. the explicit top-level arg (caller-supplied merge),
                //   2. the just-passed wsRequestModel's own field,
                //   3. the existing model's field.
                headers: headers ??
                    wsRequestModel?.headers ??
                    currentModel.wsRequestModel?.headers,
                isHeaderEnabledList: isHeaderEnabledList ??
                    wsRequestModel?.isHeaderEnabledList ??
                    currentModel.wsRequestModel?.isHeaderEnabledList,
                params: params ??
                    wsRequestModel?.params ??
                    currentModel.wsRequestModel?.params,
                isParamEnabledList: isParamEnabledList ??
                    wsRequestModel?.isParamEnabledList ??
                    currentModel.wsRequestModel?.isParamEnabledList,
              )
            : (wsRequestModel ?? currentModel.wsRequestModel),
        isStreaming: isStreaming ?? currentModel.isStreaming,
        isWorking: isWorking ?? currentModel.isWorking,
      );
    }

    var map = {...state!};
    map[rId] = newModel;
    state = map;
    unsave();

    // Apply heartbeat changes to a LIVE WebSocket connection immediately.
    // dart:io's WebSocket.pingInterval is mutable, so toggling heartbeat or
    // changing the interval while connected takes effect without a reconnect.
    // Previously these edits only applied on the next connect.
    if (newModel.apiType == APIType.websocket &&
        ConnectionManager.instance.hasConnection(rId)) {
      final oldWs = currentModel.wsRequestModel;
      final newWs = newModel.wsRequestModel;
      if (newWs != null) {
        // Protocol-level ping interval (mutable on a live connection).
        if (oldWs?.enableHeartbeat != newWs.enableHeartbeat ||
            oldWs?.heartbeatInterval != newWs.heartbeatInterval) {
          ConnectionManager.instance
              .updatePingInterval(rId, _wsPingInterval(newWs));
        }
        // App-level repeating-message heartbeat (restart timer on any change,
        // without reconnecting). Fires independently of the ping change above.
        if (oldWs?.enableMessageHeartbeat != newWs.enableMessageHeartbeat ||
            oldWs?.messageHeartbeatInterval != newWs.messageHeartbeatInterval ||
            oldWs?.messageHeartbeatPayload != newWs.messageHeartbeatPayload) {
          _stopMessageHeartbeat(rId);
          _startMessageHeartbeat(rId, newWs);
        }
      }
    }
  }

  /// Heartbeat ping interval for [ws], or `null` when heartbeats are disabled.
  /// Falls back to 30s when the interval is non-positive (mirrors connect()).
  Duration? _wsPingInterval(WebSocketRequestModel ws) => ws.enableHeartbeat
      ? Duration(
          seconds: ws.heartbeatInterval > 0 ? ws.heartbeatInterval : 30,
        )
      : null;

  /// Builds the combined env-var map (global env overlaid by active env),
  /// matching the order used when connecting a WebSocket.
  Map<String, String> _buildCombinedEnvVarMap() {
    final envMap = ref.read(availableEnvironmentVariablesStateProvider);
    final activeEnvId = ref.read(activeEnvironmentIdStateProvider);
    final Map<String, String> combined = {};
    for (var variable in (envMap[kGlobalEnvironmentId] ?? [])) {
      combined[variable.key] = variable.value;
    }
    for (var variable in (envMap[activeEnvId] ?? [])) {
      combined[variable.key] = variable.value;
    }
    return combined;
  }

  /// Stop and remove the app-level (repeating-message) heartbeat for [requestId].
  void _stopMessageHeartbeat(String requestId) {
    _appHeartbeatTimers.remove(requestId)?.cancel();
  }

  /// Cancel a queued auto-reconnect for [requestId], leaving the attempt
  /// counter intact so an in-progress backoff keeps escalating.
  void _cancelPendingWsReconnect(String requestId) {
    _wsReconnectTimers.remove(requestId)?.cancel();
  }

  /// Cancel a queued auto-reconnect for [requestId] and clear its backoff
  /// ladder, so the next connect starts again from [kWsReconnectBaseDelay].
  void _resetWsReconnect(String requestId) {
    _cancelPendingWsReconnect(requestId);
    _wsReconnectAttempts.remove(requestId);
    _wsConnectedAt.remove(requestId);
  }

  /// Queue the next auto-reconnect attempt for [requestId] after an
  /// exponentially increasing, jittered delay.
  ///
  /// Reconnects are driven solely by this timer, and only one is ever pending
  /// per request, so a server that accepts and immediately closes can no longer
  /// spin up an unbounded number of connections. After
  /// [kWsMaxReconnectAttempts] consecutive attempts the request gives up and
  /// stops streaming.
  ///
  /// [lead] opens the user-visible message and names what triggered the retry
  /// (a close from the server vs. a refused connect).
  void _scheduleWebSocketReconnect(
    String requestId, {
    String? historyId,
    String lead = "Connection closed.",
  }) {
    final currentRequest = state?[requestId];
    final ws = currentRequest?.wsRequestModel;
    if (currentRequest == null || ws == null) return;

    final attempt = (_wsReconnectAttempts[requestId] ?? 0) + 1;

    if (attempt > kWsMaxReconnectAttempts) {
      _resetWsReconnect(requestId);
      final giveUpMsg = WebSocketMessage(
        payload:
            "Reconnect failed after $kWsMaxReconnectAttempts attempts. "
            "Giving up.",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.error,
      );
      final updatedWs = ws.copyWith(
        messageHistory: appendWebSocketMessage(ws.messageHistory, giveUpMsg),
      );
      update(
        id: requestId,
        isStreaming: false,
        isWorking: false,
        wsRequestModel: updatedWs,
      );
      if (historyId != null) {
        _updateWebSocketHistoryRecord(historyId, updatedWs);
      }
      return;
    }

    _wsReconnectAttempts[requestId] = attempt;
    final delay = webSocketReconnectDelay(attempt);

    final reconnMsg = WebSocketMessage(
      payload:
          "$lead Reconnecting in "
          "${(delay.inMilliseconds / 1000).toStringAsFixed(1)}s "
          "(attempt $attempt of $kWsMaxReconnectAttempts)...",
      timestamp: DateTime.now(),
      outgoing: false,
      messageType: WebSocketMessageType.disconnected,
    );
    final updatedWs = ws.copyWith(
      messageHistory: appendWebSocketMessage(ws.messageHistory, reconnMsg),
    );
    update(id: requestId, wsRequestModel: updatedWs);
    if (historyId != null) {
      _updateWebSocketHistoryRecord(historyId, updatedWs);
    }

    _cancelPendingWsReconnect(requestId);
    _wsReconnectTimers[requestId] = Timer(delay, () async {
      _wsReconnectTimers.remove(requestId);
      if (!mounted) return;
      final latestReq = state?[requestId];
      final latestWs = latestReq?.wsRequestModel;
      // Re-check intent: during the backoff the user may have disconnected,
      // switched auto-reconnect off, or removed the request entirely.
      if (latestReq == null ||
          latestWs == null ||
          !latestReq.isStreaming ||
          !latestWs.autoReconnect) {
        _wsReconnectAttempts.remove(requestId);
        return;
      }
      await _connectWebSocket(
        requestId,
        latestReq,
        latestWs,
        historyId: historyId,
      );
    });
  }

  /// Start (or restart) the app-level (repeating-message) heartbeat for
  /// [requestId]. Sends [WebSocketRequestModel.messageHeartbeatPayload]
  /// (with {{vars}} substituted) as a normal Sent message on each tick.
  void _startMessageHeartbeat(String requestId, WebSocketRequestModel ws) {
    _stopMessageHeartbeat(requestId);
    if (ws.enableMessageHeartbeat && ws.messageHeartbeatInterval > 0) {
      _appHeartbeatTimers[requestId] = Timer.periodic(
        Duration(seconds: ws.messageHeartbeatInterval),
        (_) {
          if (!mounted ||
              !ConnectionManager.instance.hasConnection(requestId)) {
            return;
          }
          final combined = _buildCombinedEnvVarMap();
          final substituted =
              substituteVariables(ws.messageHeartbeatPayload, combined) ??
                  ws.messageHeartbeatPayload;
          sendWebSocketMessage(requestId, substituted);
        },
      );
    }
  }

  /// Send a text message over an active WebSocket connection.
  void sendWebSocketMessage(String requestId, String message) {
    final currentRequest = state?[requestId];
    if (currentRequest == null || currentRequest.apiType != APIType.websocket) {
      return;
    }
    final wsModel = currentRequest.wsRequestModel;
    if (wsModel == null) return;

    // Guard: bail if the connection isn't actually open (avoids appending a
    // Sent message when the channel is closed/closing).
    if (!ConnectionManager.instance.hasConnection(requestId)) {
      return;
    }

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
          messageHistory: appendWebSocketMessage(
            wsModel.messageHistory,
            newMessage,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error sending WS message: $e");
    }
  }

  Future<void> _connectWebSocket(
    String requestId,
    RequestModel requestModel,
    WebSocketRequestModel wsModel, {
    String? historyId,
  }) async {
    // A connect is starting for this id, so any queued reconnect for it is
    // stale. The attempt counter is left alone: when this call came from the
    // backoff timer the ladder must keep escalating.
    _cancelPendingWsReconnect(requestId);

    final Map<String, String> combinedEnvVarMap = _buildCombinedEnvVarMap();

    final substitutedUrl =
        substituteVariables(wsModel.url, combinedEnvVarMap) ?? wsModel.url;

    String finalUrl = substitutedUrl;
    if (wsModel.params != null && wsModel.isParamEnabledList != null) {
      try {
        final uri = Uri.parse(substitutedUrl);
        final queryParams = Map<String, dynamic>.from(uri.queryParameters);
        for (int i = 0; i < wsModel.params!.length; i++) {
          if (wsModel.isParamEnabledList![i]) {
            final param = wsModel.params![i];
            if (param.name.isNotEmpty) {
              final subKey =
                  substituteVariables(param.name, combinedEnvVarMap) ??
                  param.name;
              final subVal =
                  substituteVariables(param.value, combinedEnvVarMap) ??
                  param.value;
              queryParams[subKey] = subVal;
            }
          }
        }
        if (queryParams.isNotEmpty) {
          finalUrl = uri.replace(queryParameters: queryParams).toString();
        }
      } catch (e) {
        debugPrint("Error parsing WebSocket URL parameters: $e");
      }
    }

    state = {
      ...state!,
      requestId: requestModel.copyWith(
        isWorking: true,
        sendingTime: DateTime.now(),
        wsRequestModel: wsModel.copyWith(
          messageHistory: wsModel.messageHistory,
        ),
      ),
    };

    Map<String, String>? headers = {};
    if (wsModel.headers != null && wsModel.isHeaderEnabledList != null) {
      for (int i = 0; i < wsModel.headers!.length; i++) {
        if (wsModel.isHeaderEnabledList![i]) {
          final header = wsModel.headers![i];
          if (header.name.isNotEmpty) {
            final subKey =
                substituteVariables(header.name, combinedEnvVarMap) ??
                header.name;
            final subVal =
                substituteVariables(header.value, combinedEnvVarMap) ??
                header.value;
            headers[subKey] = subVal;
          }
        }
      }
    }

    if (headers.isEmpty) headers = null;

    try {
      final channel = await ConnectionManager.instance.connect(
        requestId,
        finalUrl,
        headers: headers,
        pingInterval: _wsPingInterval(wsModel),
      );

      await channel.ready;

      // Guard: the notifier may have been disposed while awaiting the
      // handshake; the `state` reads/writes below would throw otherwise.
      if (!mounted) return;

      // Note the connect time rather than clearing the ladder outright: a
      // handshake alone proves nothing, since the storm case is a server that
      // accepts and immediately closes. The ladder resets on close, but only if
      // the session lasted (see [kWsConnectionStableAfter]).
      _wsConnectedAt[requestId] = DateTime.now();

      final latestRequest = state?[requestId];
      final currentWs = latestRequest?.wsRequestModel ?? wsModel;

      final connectedMessage = WebSocketMessage(
        payload: "Connected to $finalUrl",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      state = {
        ...state!,
        requestId: (latestRequest ?? requestModel).copyWith(
          isWorking: false,
          isStreaming: true,
          wsRequestModel: currentWs.copyWith(
            messageHistory: appendWebSocketMessage(
              currentWs.messageHistory,
              connectedMessage,
            ),
          ),
        ),
      };

      _startMessageHeartbeat(requestId, currentWs);

      channel.stream.listen(
        (data) {
          // Guard: stream events can arrive after the notifier is disposed
          // (free-floating subscription); touching `state` then throws.
          if (!mounted) return;
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
                  messageHistory: appendWebSocketMessage(
                    currentWs.messageHistory,
                    newMessage,
                  ),
                ),
              );
            }
          }
        },
        onError: (e) {
          // Guard: onError can fire after dispose (connection closing while the
          // tab is torn down); touching `state` then throws "used after dispose".
          if (!mounted) return;
          _stopMessageHeartbeat(requestId);
          final currentRequest = state?[requestId];
          final ws = currentRequest?.wsRequestModel;
          if (ws != null) {
            final errMsg = WebSocketMessage(
              payload: "Connection error: $e",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.error,
            );
            final updatedWs = ws.copyWith(
              messageHistory: appendWebSocketMessage(ws.messageHistory, errMsg),
            );
            update(id: requestId, wsRequestModel: updatedWs);
            if (historyId != null) {
              _updateWebSocketHistoryRecord(historyId, updatedWs);
            }
          }
        },
        onDone: () async {
          // Guard: onDone fires asynchronously after the channel closes and may
          // run after the notifier is disposed; touching `state` then throws.
          if (!mounted) return;
          final currentRequest = state?[requestId];
          if (currentRequest == null) return;
          final ws = currentRequest.wsRequestModel;
          if (ws == null) return;
          // Stop the app-level heartbeat on close. It restarts on the next
          // successful connect (auto-reconnect calls _connectWebSocket again).
          _stopMessageHeartbeat(requestId);

          // A session that stayed up long enough counts as recovered, so the
          // next drop starts a fresh ladder. A short-lived one leaves the ladder
          // escalating, which is what makes a flapping server eventually give up
          // instead of reconnecting at a fixed rate forever.
          final connectedAt = _wsConnectedAt.remove(requestId);
          if (connectedAt != null &&
              webSocketConnectionWasStable(connectedAt, DateTime.now())) {
            _wsReconnectAttempts.remove(requestId);
          }

          if (ws.autoReconnect && currentRequest.isStreaming) {
            _scheduleWebSocketReconnect(requestId, historyId: historyId);
          } else {
            // Closed for good: nothing is queued, so clear the ladder.
            _resetWsReconnect(requestId);
            final discMsg = WebSocketMessage(
              payload: "Connection closed",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.disconnected,
            );
            final updatedWs = ws.copyWith(
              messageHistory: appendWebSocketMessage(
                ws.messageHistory,
                discMsg,
              ),
            );
            update(
              id: requestId,
              isStreaming: false,
              wsRequestModel: updatedWs,
            );
            if (historyId != null) {
              _updateWebSocketHistoryRecord(historyId, updatedWs);
            }
          }
        },
      );
    } catch (e) {
      // Guard: the connect future can complete (throw) after the notifier is
      // disposed; touching `state` below would throw "used after dispose".
      if (!mounted) return;
      _stopMessageHeartbeat(requestId);
      final currentRequest = state?[requestId];
      final ws = currentRequest?.wsRequestModel ?? wsModel;
      final errMsg = WebSocketMessage(
        payload: "Connection error: $e",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.error,
      );

      // A refused *reconnect* keeps the ladder going instead of giving up on
      // the first failure: the request is still marked streaming (the backoff
      // timer verified that before calling) and the user asked for
      // auto-reconnect, so a server that is briefly down is retried up to
      // [kWsMaxReconnectAttempts] times. A failed first connect is terminal —
      // there is no session to restore, so it just reports the error.
      final isReconnectAttempt =
          (currentRequest?.isStreaming ?? false) && ws.autoReconnect;
      if (isReconnectAttempt) {
        final updatedWs = ws.copyWith(
          messageHistory: appendWebSocketMessage(ws.messageHistory, errMsg),
        );
        update(id: requestId, isWorking: false, wsRequestModel: updatedWs);
        if (historyId != null) {
          _updateWebSocketHistoryRecord(historyId, updatedWs);
        }
        _scheduleWebSocketReconnect(
          requestId,
          historyId: historyId,
          lead: "Connection failed.",
        );
        return;
      }

      final discMsg = WebSocketMessage(
        payload: "Connection failed",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.disconnected,
      );
      // Giving up here, so no retry stays queued and the ladder resets.
      _resetWsReconnect(requestId);
      final updatedWs = ws.copyWith(
        messageHistory: appendWebSocketMessages(ws.messageHistory, [
          errMsg,
          discMsg,
        ]),
      );
      state = {
        ...state!,
        requestId: (currentRequest ?? requestModel).copyWith(
          isWorking: false,
          isStreaming: false,
          wsRequestModel: updatedWs,
        ),
      };
      if (historyId != null) {
        _updateWebSocketHistoryRecord(historyId, updatedWs);
      }
    }
  }

  void _updateWebSocketHistoryRecord(String historyId, WebSocketRequestModel wsRequestModel) {
    final historyMap = ref.read(historyMetaStateNotifier);
    if (historyMap != null && historyMap.containsKey(historyId)) {
      final historyMeta = historyMap[historyId]!;
      final historyModel = HistoryRequestModel(
        historyId: historyId,
        metaData: historyMeta,
        wsRequestModel: wsRequestModel,
      );
      ref.read(historyMetaStateNotifier.notifier).editHistoryRequest(historyModel);
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

    if (requestModel!.apiType == APIType.websocket) {
      final wsModel = requestModel.wsRequestModel;
      if (wsModel != null) {
        // A user-initiated connect is a clean slate for the backoff ladder;
        // auto-reconnect calls _connectWebSocket directly so it keeps its own.
        _resetWsReconnect(requestId);

        // Save history for WebSocket connection attempt first
        String newHistoryId = getNewUuid();
        final historyModel = HistoryRequestModel(
          historyId: newHistoryId,
          metaData: HistoryMetaModel(
            historyId: newHistoryId,
            requestId: requestId,
            apiType: APIType.websocket,
            name: requestModel.name,
            url: wsModel.url,
            method: HTTPVerb.get, // WebSockets initiate via HTTP GET
            responseStatus: 0,
            timeStamp: DateTime.now(),
          ),
          wsRequestModel: wsModel.copyWith(messageHistory: []),
          preRequestScript: requestModel.preRequestScript,
          postRequestScript: requestModel.postRequestScript,
        );

        ref
            .read(historyMetaStateNotifier.notifier)
            .addHistoryRequest(historyModel);

        await _connectWebSocket(requestId, requestModel, wsModel, historyId: newHistoryId);
      } else {
        update(id: requestId, message: "Invalid WebSocket model");
      }
      return;
    }

    final defaultUriScheme = ref.read(settingsProvider).defaultUriScheme;
    final EnvironmentModel? originalEnvironmentModel = ref.read(
      activeEnvironmentModelProvider,
    );

    RequestModel executionRequestModel = requestModel.copyWith();

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

    final logId = terminal.startNetwork(
      apiType: executionRequestModel.apiType,
      method: substitutedHttpRequestModel.method,
      url: substitutedHttpRequestModel.url,
      requestId: requestId,
      requestHeaders: substitutedHttpRequestModel.enabledHeadersMap,
      requestBodyPreview: substitutedHttpRequestModel.body,
      isStreaming: true,
    );

    state = {
      ...state!,
      requestId: requestModel.copyWith(
        isWorking: true,
        sendingTime: DateTime.now(),
      ),
    };
    bool streamingMode = true;

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

    state = {...state!, requestId: newRequestModel};
    unsave();
  }

  void cancelRequest() {
    final id = ref.read(selectedIdStateProvider);
    if (id == null) return;
    final requestModel = state?[id];
    if (requestModel?.apiType == APIType.websocket) {
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
            messageHistory: appendWebSocketMessage(ws.messageHistory, discMsg),
          ),
        );
      } else {
        update(id: id, isStreaming: false, isWorking: false);
      }
      _stopMessageHeartbeat(id);
      // The user asked to stop, so drop any queued reconnect outright.
      _resetWsReconnect(id);
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
  }

  HttpRequestModel getSubstitutedHttpRequestModel(
    HttpRequestModel httpRequestModel,
  ) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdStateProvider);
    return substituteHttpRequestModel(httpRequestModel, envMap, activeEnvId);
  }
}
