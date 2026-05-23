import 'dart:async';
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/terminal/terminal.dart';
import 'providers.dart';
import '../models/models.dart';
import '../models/protocols/base_protocol_model.dart';
import '../models/protocols/websocket_model.dart';
import '../models/protocols/mqtt_model.dart';
import '../models/protocols/grpc_model.dart';

import '../services/connection_manager.dart';
import '../services/services.dart';
import '../services/grpc_reflection_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
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

    // Cleanup of active connections
    ConnectionManager.instance.disconnectWebSocket(rId);
    ConnectionManager.instance.disconnectMqtt(rId);
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

  void sendWebSocketMessage(String requestId, String message) {
    final currentRequest = state?[requestId];
    if (currentRequest != null && currentRequest.apiType == APIType.websocket) {
      final protocolModel = currentRequest.protocolModel;
      if (protocolModel is WebSocketRequestModel) {
        final wsModel = protocolModel;
        try {
          final channel = ConnectionManager.instance.getWebSocketChannel(
            requestId,
          );
          channel.sink.add(message);

          final newMessage = WebSocketMessage(
            payload: message,
            timestamp: DateTime.now(),
            outgoing: true,
            messageType: WebSocketMessageType.sent,
          );

          final updatedWsModel = wsModel.copyWith(
            messageHistory: [...wsModel.messageHistory, newMessage],
          );

          update(id: requestId, protocolModel: updatedWsModel);
        } catch (e) {
          debugPrint("Error sending WS message: $e");
        }
      }
    }
  }

  void sendMqttMessage(String requestId, String topic, String message) {
    final currentRequest = state?[requestId];
    if (currentRequest != null && currentRequest.apiType == APIType.mqtt) {
      final protocolModel = currentRequest.protocolModel;
      if (protocolModel is MQTTRequestModel) {
        final mqttModel = protocolModel;
        try {
          ConnectionManager.instance.publishMqtt(
            requestId,
            topic,
            message,
            mqttModel.qos,
          );

          final newMessage = WebSocketMessage(
            payload: "Topic: $topic\nMessage: $message",
            timestamp: DateTime.now(),
            outgoing: true,
            messageType: WebSocketMessageType.sent,
            qos: mqttModel.qos,
          );

          final updatedMqttModel = mqttModel.copyWith(
            messageHistory: [...mqttModel.messageHistory, newMessage],
          );

          update(id: requestId, protocolModel: updatedMqttModel);
        } catch (e) {
          debugPrint("Error sending MQTT message: $e");
        }
      }
    }
  }

  void subscribeMqttTopic(String requestId, String topic, int qos) {
    final currentRequest = state?[requestId];
    if (currentRequest != null &&
        currentRequest.protocolModel is MQTTRequestModel) {
      final mqttModel = currentRequest.protocolModel as MQTTRequestModel;
      ConnectionManager.instance.subscribeMqtt(requestId, topic, qos);

      final logMsg = WebSocketMessage(
        payload: "Subscribed to topic: $topic",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final updatedModel = mqttModel.copyWith(
        messageHistory: [...mqttModel.messageHistory, logMsg],
      );
      update(id: requestId, protocolModel: updatedModel, isWorking: false);
    }
  }

  void unsubscribeMqttTopic(String requestId, String topic) {
    final currentRequest = state?[requestId];
    if (currentRequest != null &&
        currentRequest.protocolModel is MQTTRequestModel) {
      final mqttModel = currentRequest.protocolModel as MQTTRequestModel;
      ConnectionManager.instance.unsubscribeMqtt(requestId, topic);

      final logMsg = WebSocketMessage(
        payload: "Unsubscribed from topic: $topic",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final updatedModel = mqttModel.copyWith(
        messageHistory: [...mqttModel.messageHistory, logMsg],
      );
      update(id: requestId, protocolModel: updatedModel, isWorking: false);
    }
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
    ProtocolModel? protocolModel,
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
          protocolModel: null,
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
          protocolModel: null,
        ),
        APIType.websocket => currentModel.copyWith(
          apiType: apiType,
          requestTabIndex: 0,
          name: name ?? currentModel.name,
          description: description ?? currentModel.description,
          httpRequestModel: null,
          aiRequestModel: null,
          protocolModel: const WebSocketRequestModel(url: ""),
        ),
        APIType.mqtt => currentModel.copyWith(
          apiType: apiType,
          requestTabIndex: 0,
          name: name ?? currentModel.name,
          description: description ?? currentModel.description,
          httpRequestModel: null,
          aiRequestModel: null,
          protocolModel: const MQTTRequestModel(brokerUrl: "", port: 1883),
        ),

        APIType.grpc => currentModel.copyWith(
          apiType: apiType,
          requestTabIndex: 0,
          name: name ?? currentModel.name,
          description: description ?? currentModel.description,
          httpRequestModel: null,
          aiRequestModel: null,
          protocolModel: const GrpcRequestModel(host: ""),
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
        protocolModel:
            protocolModel ??
            ((currentModel.protocolModel is GrpcRequestModel)
                ? (currentModel.protocolModel as GrpcRequestModel).copyWith(
                    metadata:
                        headers ??
                        (currentModel.protocolModel as GrpcRequestModel)
                            .metadata,
                    isMetadataEnabled:
                        isHeaderEnabledList ??
                        (currentModel.protocolModel as GrpcRequestModel)
                            .isMetadataEnabled,
                  )
                : currentModel.protocolModel),
        responseStatus: responseStatus ?? currentModel.responseStatus,
        message: message ?? currentModel.message,
        httpResponseModel: httpResponseModel ?? currentModel.httpResponseModel,
        preRequestScript: preRequestScript ?? currentModel.preRequestScript,
        postRequestScript: postRequestScript ?? currentModel.postRequestScript,
        aiRequestModel: aiRequestModel ?? currentModel.aiRequestModel,
        isStreaming: isStreaming ?? currentModel.isStreaming,
        isWorking: isWorking ?? currentModel.isWorking,
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
        requestModel?.aiRequestModel == null &&
        requestModel?.protocolModel == null) {
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

    if (apiType == APIType.websocket) {
      final protocolModel = requestModel.protocolModel;
      if (protocolModel is WebSocketRequestModel) {
        await _connectWebSocket(requestId, requestModel, protocolModel);
      } else {
        update(id: requestId, message: "Invalid WebSocket model");
      }
      return;
    }

    if (apiType == APIType.mqtt) {
      final protocolModel = requestModel.protocolModel;
      if (protocolModel is MQTTRequestModel) {
        await _connectMqtt(requestId, requestModel, protocolModel);
      } else {
        update(id: requestId, message: "Invalid MQTT model");
      }
      return;
    }

    if (apiType == APIType.grpc) {
      final protocolModel = requestModel.protocolModel;
      if (protocolModel is GrpcRequestModel) {
        await _connectGrpc(requestId, requestModel, protocolModel);
      } else {
        update(id: requestId, message: "Invalid gRPC model");
      }
      return;
    }

    HttpRequestModel substitutedHttpRequestModel;

    if (apiType == APIType.ai) {
      if (executionRequestModel.aiRequestModel?.httpRequestModel == null) {
        update(id: requestId, message: "Invalid AI model");
        return;
      }
      substitutedHttpRequestModel = getSubstitutedHttpRequestModel(
        executionRequestModel.aiRequestModel!.httpRequestModel!,
      );
    } else {
      if (executionRequestModel.httpRequestModel == null) {
        update(id: requestId, message: "Invalid Request model");
        return;
      }
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
    final apiType = requestModel?.apiType;

    if (apiType == APIType.websocket) {
      // Set streaming to false first so onDone doesn't trigger auto-reconnect
      final map = {...state!};
      map[id] = requestModel!.copyWith(isWorking: false, isStreaming: false);
      state = map;

      ConnectionManager.instance.disconnectWebSocket(id);
      unsave();
      return;
    }

    if (apiType == APIType.mqtt) {
      final map = {...state!};
      map[id] = requestModel!.copyWith(isWorking: false, isStreaming: false);
      state = map;

      ConnectionManager.instance.disconnectMqtt(id);
      unsave();
      return;
    }

    if (apiType == APIType.grpc) {
      final map = {...state!};
      map[id] = requestModel!.copyWith(isWorking: false, isStreaming: false);
      state = map;

      ConnectionManager.instance.disconnectGrpc(id);
      unsave();
      return;
    }

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

  Future<void> _connectWebSocket(
    String requestId,
    RequestModel requestModel,
    WebSocketRequestModel wsModel,
  ) async {
    state = {
      ...state!,
      requestId: requestModel.copyWith(
        isWorking: true,
        sendingTime: DateTime.now(),
      ),
    };
    try {
      final now = DateTime.now();
      final connMsg1 = WebSocketMessage(
        payload: "Attempting to connect to ${wsModel.url}",
        timestamp: now,
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );
      final connMsg2 = WebSocketMessage(
        payload: "WebSocket channel created, waiting for connection...",
        timestamp: now,
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final channel = await ConnectionManager.instance.connectWebSocket(
        requestId,
        wsModel,
      );

      final connMsg3 = WebSocketMessage(
        payload: "Connected to ${wsModel.url}",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final connectedWsModel = wsModel.copyWith(
        messageHistory: [connMsg1, connMsg2, connMsg3],
      );
      state = {
        ...state!,
        requestId: requestModel.copyWith(
          isWorking: false,
          isStreaming: true,
          protocolModel: connectedWsModel,
        ),
      };

      channel.stream.listen(
        (data) {
          final currentRequest = state?[requestId];
          if (currentRequest != null) {
            final protocolModel = currentRequest.protocolModel;
            if (protocolModel is WebSocketRequestModel) {
              final newMessage = WebSocketMessage(
                payload: data.toString(),
                timestamp: DateTime.now(),
                outgoing: false,
                messageType: WebSocketMessageType.received,
              );
              final updatedWsModel = protocolModel.copyWith(
                messageHistory: [...protocolModel.messageHistory, newMessage],
              );
              update(id: requestId, protocolModel: updatedWsModel);
            }
          }
        },
        onError: (e) {
          update(id: requestId, message: e.toString());
        },
        onDone: () async {
          final currentRequest = state?[requestId];
          if (currentRequest == null ||
              currentRequest.protocolModel is! WebSocketRequestModel)
            return;

          final ws = currentRequest.protocolModel as WebSocketRequestModel;

          // If it was a manual stop, isStreaming would already be or will be false.
          // We check the state to see if we should attempt a reconnect.
          if (ws.autoReconnect && currentRequest.isStreaming) {
            final now = DateTime.now();
            final reconnectMsg = WebSocketMessage(
              payload:
                  "Connection lost. Attempting to reconnect in 3 seconds...",
              timestamp: now,
              outgoing: false,
              messageType: WebSocketMessageType.connected,
            );
            final updatedWsModel = ws.copyWith(
              messageHistory: [...ws.messageHistory, reconnectMsg],
            );
            update(id: requestId, protocolModel: updatedWsModel);

            await Future.delayed(const Duration(seconds: 3));

            // Check again if we should still reconnect (user might have stopped it during the delay)
            final latestReq = state?[requestId];
            if (latestReq != null && latestReq.isStreaming) {
              _connectWebSocket(requestId, latestReq, updatedWsModel);
            }
          } else {
            update(id: requestId, isStreaming: false);
          }
        },
      );
    } catch (e) {
      state = {
        ...state!,
        requestId: requestModel.copyWith(
          isWorking: false,
          message: e.toString(),
        ),
      };
    }
  }

  Future<void> _connectMqtt(
    String requestId,
    RequestModel requestModel,
    MQTTRequestModel mqttModel,
  ) async {
    state = {
      ...state!,
      requestId: requestModel.copyWith(
        isWorking: true,
        isStreaming: false,
        sendingTime: DateTime.now(),
        message: null,
      ),
    };
    try {
      final now = DateTime.now();
      final connMsg1 = WebSocketMessage(
        payload: "Attempting to connect to ${mqttModel.brokerUrl}",
        timestamp: now,
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final client = await ConnectionManager.instance.connectMqtt(
        requestId,
        mqttModel,
      );

      final connMsg2 = WebSocketMessage(
        payload: "Connected to ${mqttModel.brokerUrl}",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final List<WebSocketMessage> subscriptionLogs = [];
      // Subscribe to initial topics
      for (int i = 0; i < mqttModel.subscribedTopics.length; i++) {
        bool isEnabled = i < mqttModel.isTopicEnabledList.length
            ? mqttModel.isTopicEnabledList[i]
            : true;
        if (isEnabled) {
          final topic = mqttModel.subscribedTopics[i].name;
          if (topic.isNotEmpty) {
            ConnectionManager.instance.subscribeMqtt(
              requestId,
              topic,
              mqttModel.qos,
            );
            subscriptionLogs.add(WebSocketMessage(
              payload: "Subscribed to topic: $topic",
              timestamp: DateTime.now(),
              outgoing: false,
              messageType: WebSocketMessageType.connected,
            ));
          }
        }
      }

      final updatedMqttModel = mqttModel.copyWith(
        messageHistory: [connMsg1, connMsg2, ...subscriptionLogs],
      );

      state = {
        ...state!,
        requestId: requestModel.copyWith(
          isWorking: false,
          isStreaming: true,
          protocolModel: updatedMqttModel,
        ),
      };

      client.updates!.listen(
        (List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message,
          );

          final currentRequest = state?[requestId];
          if (currentRequest != null) {
            final protocolModel = currentRequest.protocolModel;
            if (protocolModel is MQTTRequestModel) {
              final newMessage = WebSocketMessage(
                payload: "Topic: ${c[0].topic}\n$pt",
                timestamp: DateTime.now(),
                outgoing: false,
                messageType: WebSocketMessageType.received,
                qos: recMess.header?.qos.index,
              );
              final updatedModel = protocolModel.copyWith(
                messageHistory: [...protocolModel.messageHistory, newMessage],
              );
              update(id: requestId, protocolModel: updatedModel);
            }
          }
        },
        onError: (e) {
          update(id: requestId, message: e.toString());
        },
        onDone: () {
          update(id: requestId, isStreaming: false);
        },
      );
    } catch (e) {
      final errorMsg = WebSocketMessage(
        payload: "Connection Error: ${e.toString()}",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.error,
      );

      final currentRequest = state?[requestId];
      if (currentRequest != null &&
          currentRequest.protocolModel is MQTTRequestModel) {
        final currentMqttModel =
            currentRequest.protocolModel as MQTTRequestModel;
        final updatedModel = currentMqttModel.copyWith(
          messageHistory: [...currentMqttModel.messageHistory, errorMsg],
        );
        state = {
          ...state!,
          requestId: currentRequest.copyWith(
            isWorking: false,
            message: e.toString(),
            protocolModel: updatedModel,
          ),
        };
      } else {
        state = {
          ...state!,
          requestId: requestModel.copyWith(
            isWorking: false,
            message: e.toString(),
          ),
        };
      }
    }
  }

  Future<void> _connectGrpc(
    String requestId,
    RequestModel requestModel,
    GrpcRequestModel grpcModel,
  ) async {
    try {
      update(id: requestId, isWorking: true);
      await ConnectionManager.instance.connectGrpc(requestId, grpcModel);

      final msg = WebSocketMessage(
        payload: "Connected to gRPC host: ${grpcModel.host}:${grpcModel.port}",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      );

      final currentRequest = state?[requestId];
      if (currentRequest != null &&
          currentRequest.protocolModel is GrpcRequestModel) {
        final currentGrpcModel =
            currentRequest.protocolModel as GrpcRequestModel;
        state = {
          ...state!,
          requestId: currentRequest.copyWith(
            isWorking: (grpcModel.service != null && grpcModel.method != null),
            isStreaming: true,
            protocolModel: currentGrpcModel.copyWith(
              messageHistory: [msg],
            ),
          ),
        };

        print("gRPC: Host established. Checking for method invocation...");
        // Invoke method
        if (grpcModel.service != null && grpcModel.method != null) {
          print(
            "gRPC: Invoking method ${grpcModel.service}/${grpcModel.method}",
          );
          
          GrpcMethodSchema? methodSchema;
          if (grpcModel.useReflection) {
            methodSchema = await GrpcReflectionService.getMethodSchema(
              requestId, grpcModel, grpcModel.service!, grpcModel.method!);
          }
          
          final startTime = DateTime.now();
          final requestData = grpcModel.parameters.isNotEmpty
              ? GrpcUtils.paramsToBytes(grpcModel.parameters)
              : utf8.encode(grpcModel.requestBody);

          final call = ConnectionManager.instance.callGrpcMethod(
            requestId,
            grpcModel.service!,
            grpcModel.method!,
            requestData,
            metadata: grpcModel.metadataMap,
          );

          call.listen(
            (data) {
              final duration = DateTime.now().difference(startTime);
                  final payload = GrpcUtils.decodeBinaryResponse(data, schema: methodSchema);
                  final responseMsg = WebSocketMessage(
                    payload:
                        "Response (${duration.inMilliseconds}ms):\n$payload",
                    timestamp: DateTime.now(),
                    outgoing: false,
                    messageType: WebSocketMessageType.received,
                  );

                  final currentRequest = state?[requestId];
                  if (currentRequest != null) {
                    final protocolModel = currentRequest.protocolModel;
                    if (protocolModel is GrpcRequestModel) {
                      final receivedCount = protocolModel.messageHistory
                          .where(
                            (m) => m.messageType == WebSocketMessageType.received,
                          )
                          .length;

                      state = {
                    ...state!,
                    requestId: currentRequest.copyWith(
                      isWorking: false,
                      isStreaming: false,
                      responseStatus: receivedCount == 0 ? 200 : null,
                      httpResponseModel: receivedCount == 0
                          ? HttpResponseModel(body: payload, time: duration)
                          : currentRequest.httpResponseModel,
                      protocolModel: protocolModel.copyWith(
                        messageHistory: [
                          ...protocolModel.messageHistory,
                          responseMsg,
                        ],
                      ),
                    ),
                  };
                }
              }
            },
            onDone: () {
              final currentRequest = state?[requestId];
              if (currentRequest != null) {
                state = {
                  ...state!,
                  requestId: currentRequest.copyWith(
                    isWorking: false,
                    isStreaming: false,
                  ),
                };
              }
            },
            onError: (e) {
              final errorMsg = WebSocketMessage(
                payload: "RPC Error: ${e.toString()}",
                timestamp: DateTime.now(),
                outgoing: false,
                messageType: WebSocketMessageType.error,
              );

              final currentRequest = state?[requestId];
              if (currentRequest != null &&
                  currentRequest.protocolModel is GrpcRequestModel) {
                final currentGrpcModel =
                    currentRequest.protocolModel as GrpcRequestModel;
                state = {
                  ...state!,
                  requestId: currentRequest.copyWith(
                    isWorking: false,
                    isStreaming: false,
                    protocolModel: currentGrpcModel.copyWith(
                      messageHistory: [
                        ...currentGrpcModel.messageHistory,
                        errorMsg,
                      ],
                    ),
                  ),
                };
              }
            },
          );
        }
      }
    } catch (e) {
      final errorMsg = WebSocketMessage(
        payload: "Connection Error: ${e.toString()}",
        timestamp: DateTime.now(),
        outgoing: false,
        messageType: WebSocketMessageType.error,
      );

      final currentRequest = state?[requestId];
      if (currentRequest != null &&
          currentRequest.protocolModel is GrpcRequestModel) {
        final currentGrpcModel =
            currentRequest.protocolModel as GrpcRequestModel;
        state = {
          ...state!,
          requestId: currentRequest.copyWith(
            isWorking: false,
            message: e.toString(),
            protocolModel: currentGrpcModel.copyWith(
              messageHistory: [...currentGrpcModel.messageHistory, errorMsg],
            ),
          ),
        };
      }
    }
  }
}
