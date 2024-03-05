import 'package:apidash/models/mqtt/mqtt_topic_model.dart';
import 'package:apidash/services/mqtt_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'settings_providers.dart';
import 'ui_providers.dart';
import '../models/models.dart';
import '../services/services.dart'
    show HiveHandler, connectToMqttServer, hiveHandler, request;
import '../utils/utils.dart' show uuid, collectionToHAR;
import '../consts.dart';
import 'package:http/http.dart' as http;

final selectedIdStateProvider = StateProvider<String?>((ref) => null);

final realtimeConnectionStateProvider = StateProvider<RealtimeConnectionState?>(
    (ref) => RealtimeConnectionState.disconnected);
final realtimeHistoryStateProvider =
    StateProvider<List<Map<String, String>>>((ref) => []);
final clientIdStateProvider = StateProvider<String?>((ref) => null);

final selectedRequestModelProvider = StateProvider<RequestModel?>((ref) {
  final selectedId = ref.watch(selectedIdStateProvider);
  final collection = ref.watch(collectionStateNotifierProvider);
  if (selectedId == null || collection == null) {
    return null;
  } else {
    return collection[selectedId];
  }
});

final requestSequenceProvider = StateProvider<List<String>>((ref) {
  var ids = hiveHandler.getIds();
  return ids ?? [];
});

final StateNotifierProvider<CollectionStateNotifier, Map<String, RequestModel>?>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier(ref, hiveHandler));
final subscribedTopicsStateProvider =
    StateProvider<List<MQTTTopicModel>>((ref) => []);
final messageTopicStateProvider = StateProvider<String?>((ref) => null);
late MqttServerClient mqttClient;

class CollectionStateNotifier
    extends StateNotifier<Map<String, RequestModel>?> {
  CollectionStateNotifier(this.ref, this.hiveHandler) : super(null) {
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
  final baseResponseModel = const ResponseModel();

  bool hasId(String id) => state?.keys.contains(id) ?? false;

  RequestModel? getRequestModel(String id) {
    return state?[id];
  }

  void add() {
    final id = uuid.v1();
    final newRequestModel = RequestModel(
      id: id,
    );
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
    ref
        .read(requestSequenceProvider.notifier)
        .update((state) => [id, ...state]);
    ref.read(selectedIdStateProvider.notifier).state = newRequestModel.id;
  }

  void reorder(int oldIdx, int newIdx) {
    var itemIds = ref.read(requestSequenceProvider);
    final itemId = itemIds.removeAt(oldIdx);
    itemIds.insert(newIdx, itemId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
  }

  void remove(String id) {
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(id);
    itemIds.remove(id);
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
    map.remove(id);
    state = map;
  }

  void duplicate(String id) {
    final newId = uuid.v1();

    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(id);

    final newModel = state![id]!.duplicate(
      id: newId,
    );

    itemIds.insert(idx + 1, newId);
    var map = {...state!};
    map[newId] = newModel;
    state = map;

    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    ref.read(selectedIdStateProvider.notifier).state = newId;
  }

  void update(
    String id, {
    ProtocolType? protocol,
    HTTPVerb? method,
    String? url,
    String? name,
    String? description,
    int? requestTabIndex,
    List<NameValueModel>? requestHeaders,
    List<NameValueModel>? requestParams,
    List<bool>? isHeaderEnabledList,
    List<bool>? isParamEnabledList,
    ContentType? requestBodyContentType,
    String? requestBody,
    List<FormDataModel>? requestFormDataList,
    int? responseStatus,
    String? message,
    ResponseModel? responseModel,
  }) {
    final newModel = state![id]!.copyWith(
        protocol: protocol,
        method: method,
        url: url,
        name: name,
        description: description,
        requestTabIndex: requestTabIndex,
        requestHeaders: requestHeaders,
        requestParams: requestParams,
        isHeaderEnabledList: isHeaderEnabledList,
        isParamEnabledList: isParamEnabledList,
        requestBodyContentType: requestBodyContentType,
        requestBody: requestBody,
        requestFormDataList: requestFormDataList,
        responseStatus: responseStatus,
        message: message,
        responseModel: responseModel);
    //print(newModel);
    var map = {...state!};
    map[id] = newModel;
    state = map;
  }

  Future<void> connectToBroker(String id) async {
    RequestModel requestModel = state![id]!;
    late final RequestModel newRequestModel;
    ref.read(realtimeConnectionStateProvider.notifier).state =
        RealtimeConnectionState.connecting;
    ref.read(subscribedTopicsStateProvider.notifier).state = [];
    ref.read(selectedIdStateProvider.notifier).state = id;
    ref.read(realtimeHistoryStateProvider.notifier).state = [];
    ref.read(sentRequestIdStateProvider.notifier).state = id;
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    String? clientId = ref.read(clientIdStateProvider.notifier).state;

    try {
      RequestModel requestModel = state![id]!;
      mqttClient = await connectToMqttServer(
          broker: requestModel.url, clientId: clientId!);

      var map = {...state!};
      state = map;
    } catch (e) {
      newRequestModel = requestModel.copyWith(
        responseStatus: -1,
        message: e.toString(),
      );
      var map = {...state!};
      map[id] = newRequestModel;
      state = map;
      ref.read(sentRequestIdStateProvider.notifier).state = null;
      ref.read(realtimeConnectionStateProvider.notifier).state =
          RealtimeConnectionState.disconnected;
    }
    if (mqttClient.connectionStatus?.state == MqttConnectionState.connected) {
      ref.read(realtimeHistoryStateProvider.notifier).state = [
        {
          "direction": 'info',
          "message": 'Connected to broker',
        },
        ...ref.read(realtimeHistoryStateProvider)
      ];
      mqttClient.onDisconnected = () {
        ref.read(realtimeHistoryStateProvider.notifier).state = [
          {
            "direction": 'info',
            "message": 'Disconnected from broker',
          },
          ...ref.read(realtimeHistoryStateProvider)
        ];
        ref.read(realtimeConnectionStateProvider.notifier).state =
            RealtimeConnectionState.disconnected;
      };
      mqttClient.updates?.listen(
        (List<MqttReceivedMessage<MqttMessage>> c) {
          final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
          final String pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          // Update the history
          ref.read(realtimeHistoryStateProvider.notifier).state = [
            {
              "direction": 'receive',
              "message": "${c[0].topic}: $pt",
            },
            ...ref.read(realtimeHistoryStateProvider),
          ];
        },
      );
      newRequestModel = requestModel.copyWith(
        responseStatus: 1, // 1 is for connected
        message: 'Connected',
      );
      var map = {...state!};
      map[id] = newRequestModel;
      state = map;
      ref.read(realtimeConnectionStateProvider.notifier).state =
          RealtimeConnectionState.connected;
    }
  }

  Future<void> sendMessage(String id) async {
    ref.read(subscribedTopicsStateProvider.notifier).state = [];
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    String? topic = ref.watch(messageTopicStateProvider.notifier).state;
    RequestModel requestModel = state![id]!;
    publishMessage(
        client: mqttClient,
        topic: topic!,
        message: requestModel.requestBody!,
        qos: MqttQos.atLeastOnce);
    // Update the history
    ref.read(realtimeHistoryStateProvider.notifier).state = [
      {
        "direction": 'send',
        "message": '$topic: ${requestModel.requestBody!}',
      },
      ...ref.read(realtimeHistoryStateProvider),
    ];
  }

  Future<void> subscribeTopic(String topic, MqttQos qosLevel) async {
    subscribeToTopic(mqttClient, topic, qosLevel);
    ref.read(realtimeHistoryStateProvider.notifier).state = [
      {
        "direction": 'info',
        "message": 'Subscribed to the topic $topic from broker',
      },
      ...ref.read(realtimeHistoryStateProvider)
    ];
  }

  Future<void> unsubscribeTopic(String topic) async {
    mqttClient.unsubscribe(topic);
    ref.read(realtimeHistoryStateProvider.notifier).state = [
      {
        "direction": 'info',
        "message": 'Unsubscribed to the topic $topic from broker',
      },
      ...ref.read(realtimeHistoryStateProvider)
    ];
  }

  Future<void> disconnectFromBroker(String id) async {
    ref.read(realtimeConnectionStateProvider.notifier).state =
        RealtimeConnectionState.disconnecting;
    ref.read(subscribedTopicsStateProvider.notifier).state = [];
    ref.read(selectedIdStateProvider.notifier).state = id;
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    await disconnectFromMqttServer(mqttClient);

    ref.read(realtimeConnectionStateProvider.notifier).state =
        RealtimeConnectionState.disconnected;
    ref.read(sentRequestIdStateProvider.notifier).state = null;
  }

  Future<void> sendRequest(String id) async {
    ref.read(sentRequestIdStateProvider.notifier).state = id;
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    final defaultUriScheme =
        ref.read(settingsProvider.select((value) => value.defaultUriScheme));
    RequestModel requestModel = state![id]!;
    (http.Response?, Duration?, String?)? responseRec = await request(
      requestModel,
      defaultUriScheme: defaultUriScheme,
      isMultiPartRequest:
          requestModel.requestBodyContentType == ContentType.formdata,
    );
    late final RequestModel newRequestModel;
    if (responseRec.$1 == null) {
      newRequestModel = requestModel.copyWith(
        responseStatus: -1,
        message: responseRec.$3,
      );
    } else {
      final responseModel = baseResponseModel.fromResponse(
        response: responseRec.$1!,
        time: responseRec.$2!,
      );
      int statusCode = responseRec.$1!.statusCode;
      newRequestModel = requestModel.copyWith(
        responseStatus: statusCode,
        message: kResponseCodeReasons[statusCode],
        responseModel: responseModel,
      );
    }
    ref.read(sentRequestIdStateProvider.notifier).state = null;
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
  }

  Future<void> clearData() async {
    ref.read(clearDataStateProvider.notifier).state = true;
    ref.read(selectedIdStateProvider.notifier).state = null;
    await hiveHandler.clear();
    ref.read(clearDataStateProvider.notifier).state = false;
    ref.read(requestSequenceProvider.notifier).state = [];
    state = {};
  }

  bool loadData() {
    var ids = hiveHandler.getIds();
    if (ids == null || ids.length == 0) {
      String newId = uuid.v1();
      state = {
        newId: RequestModel(
          id: newId,
        ),
      };
      return true;
    } else {
      Map<String, RequestModel> data = {};
      for (var id in ids) {
        var jsonModel = hiveHandler.getRequestModel(id);
        if (jsonModel != null) {
          var requestModel =
              RequestModel.fromJson(Map<String, dynamic>.from(jsonModel));
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
        state?[id]?.toJson(includeResponse: saveResponse),
      );
    }
    await hiveHandler.removeUnused();
    ref.read(saveDataStateProvider.notifier).state = false;
  }

  Future<Map<String, dynamic>> exportDataToHAR() async {
    var result = await collectionToHAR(state?.values.toList());
    return result;
    // return {
    //   "data": state!.map((e) => e.toJson(includeResponse: false)).toList()
    // };
  }
}
