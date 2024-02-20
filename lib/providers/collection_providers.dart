import 'package:apidash/services/websocket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_providers.dart';
import 'ui_providers.dart';
import '../models/models.dart';
import '../services/services.dart' show hiveHandler, HiveHandler, request;
import '../utils/utils.dart' show uuid, collectionToHAR;
import '../consts.dart';
import 'package:http/http.dart' as http;

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

final requestSequenceProvider = StateProvider<List<String>>((ref) {
  var ids = hiveHandler.getIds();
  return ids ?? [];
});

final webSocketManagerProvider =
    Provider.family<WebSocketManager, String>((ref, url) {
  final webhookMessages = ref.read(webhookMessagesProvider.notifier);
  final webSocketManager = WebSocketManager(
    onConnecting: () {
      webhookMessages.addMessage(
          "Connecting to server $url", WebhookMessageType.info);
    },
    onConnected: () {
      ref
          .read(webhookMessagesProvider.notifier)
          .addMessage("Connected to server $url", WebhookMessageType.info);
    },
    onDisconnected: () {
      ref
          .read(webhookMessagesProvider.notifier)
          .addMessage("Disconnected from server $url", WebhookMessageType.info);
    },
    onMessageReceived: (message) {
      ref
          .read(webhookMessagesProvider.notifier)
          .addMessage(message, WebhookMessageType.server);
    },
  );
  ref.onDispose(() => webSocketManager.disconnect());

  webSocketManager.connect(url);
  return webSocketManager;
});

final webSocketProvider =
    StreamProvider.autoDispose.family<dynamic, String>((ref, url) async* {
  final webSocketManager = ref.watch(webSocketManagerProvider(url));

  await for (final value in webSocketManager.channel!.stream) {
    yield value.toString();
  }
});

// class WebhookMessages {
//   WebhookMessages(this.serverMessages, this.clientMessages, this.infoMessages);
//   final List<WebhookMessage> serverMessages;
//   final List<WebhookMessage> clientMessages;
//   final List<WebhookMessage> infoMessages;
// }

enum WebhookMessageType { server, client, info }

class WebhookMessage {
  WebhookMessage(this.message, this.timestamp, this.type);
  final String message;
  final DateTime timestamp;
  final WebhookMessageType type;
}

class MessagesNotifier extends StateNotifier<List<WebhookMessage>> {
  MessagesNotifier() : super([]);

  void addMessage(String message, WebhookMessageType type) {
    state = [
      WebhookMessage(message, DateTime.now(), type),
      ...state,
    ];
  }

  // void addMessage(String message) {
  //   state = [message, ...state];
  // }

  // void clearMessages() {
  //   state = [];
  // }
}

final webhookMessagesProvider =
    StateNotifierProvider<MessagesNotifier, List<WebhookMessage>>((ref) {
  return MessagesNotifier();
});

final StateNotifierProvider<CollectionStateNotifier, Map<String, RequestModel>?>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier(ref, hiveHandler));

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
    Protocol? protocol,
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

    var map = {...state!};
    map[id] = newModel;
    state = map;
  }

  Future<void> connectWebsocket(String id) async {
    ref.read(sentRequestIdStateProvider.notifier).state = id;
    ref.read(codePaneVisibleStateProvider.notifier).state = false;

    RequestModel requestModel = state![id]!;

    ref.watch(webSocketManagerProvider(requestModel.url));

    late final RequestModel newRequestModel;

    newRequestModel = requestModel.copyWith(responseStatus: 200, message: "ok");

    ref.read(sentRequestIdStateProvider.notifier).state = null;
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
  }

  Future<void> sendWebsocketRequest(String id) async {
    ref.read(sentRequestIdStateProvider.notifier).state = id;
    ref.read(codePaneVisibleStateProvider.notifier).state = false;

    RequestModel requestModel = state![id]!;

    final webSocketManager =
        ref.watch(webSocketManagerProvider(state![id]!.url));

    ref
        .read(webhookMessagesProvider.notifier)
        .addMessage(requestModel.message!, WebhookMessageType.client);
    webSocketManager.sendMessage(requestModel.message!);

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
