import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../consts.dart';
import '../models/models.dart';
import '../services/services.dart' show hiveHandler, HiveHandler, request;
import '../utils/utils.dart' show getNewUuid, collectionToHAR;
import 'settings_providers.dart';
import 'ui_providers.dart';

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
  final baseResponseModel = const HttpResponseModel();

  bool hasId(String id) => state?.keys.contains(id) ?? false;

  RequestModel? getRequestModel(String id) {
    return state?[id];
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
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  void reorder(int oldIdx, int newIdx) {
    var itemIds = ref.read(requestSequenceProvider);
    final itemId = itemIds.removeAt(oldIdx);
    itemIds.insert(newIdx, itemId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
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
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  void clearResponse(String? id) {
    if (id == null || state?[id] == null) return;
    var currentModel = state![id]!;
    final newModel = currentModel.copyWith(
      responseStatus: null,
      message: null,
      httpResponseModel: null,
      isWorking: false,
      sendingTime: null,
    );
    var map = {...state!};
    map[id] = newModel;
    state = map;
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  void duplicate(String id) {
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(id);
    var currentModel = state![id]!;
    final newModel = currentModel.copyWith(
      id: newId,
      name: "${currentModel.name} (copy)",
      requestTabIndex: 0,
      responseStatus: null,
      message: null,
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
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  void update(
    String id, {
    HTTPVerb? method,
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
    List<FormDataModel>? formData,
    int? responseStatus,
    String? message,
    HttpResponseModel? httpResponseModel,
  }) {
    var currentModel = state![id]!;
    var currentHttpRequestModel = currentModel.httpRequestModel;
    final newModel = currentModel.copyWith(
      name: name ?? currentModel.name,
      description: description ?? currentModel.description,
      requestTabIndex: requestTabIndex ?? currentModel.requestTabIndex,
      httpRequestModel: currentHttpRequestModel?.copyWith(
        method: method ?? currentHttpRequestModel.method,
        url: url ?? currentHttpRequestModel.url,
        headers: headers ?? currentHttpRequestModel.headers,
        params: params ?? currentHttpRequestModel.params,
        isHeaderEnabledList:
            isHeaderEnabledList ?? currentHttpRequestModel.isHeaderEnabledList,
        isParamEnabledList:
            isParamEnabledList ?? currentHttpRequestModel.isParamEnabledList,
        bodyContentType:
            bodyContentType ?? currentHttpRequestModel.bodyContentType,
        body: body ?? currentHttpRequestModel.body,
        formData: formData ?? currentHttpRequestModel.formData,
      ),
      responseStatus: responseStatus ?? currentModel.responseStatus,
      message: message ?? currentModel.message,
      httpResponseModel: httpResponseModel ?? currentModel.httpResponseModel,
    );

    var map = {...state!};
    map[id] = newModel;
    state = map;
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  Future<void> sendRequest(String id) async {
    ref.read(codePaneVisibleStateProvider.notifier).state = false;
    final defaultUriScheme = ref.read(
      settingsProvider.select(
        (value) => value.defaultUriScheme,
      ),
    );

    RequestModel requestModel = state![id]!;

    if (requestModel.httpRequestModel == null) {
      return;
    }

    // set current model's isWorking to true and update state
    var map = {...state!};
    map[id] = requestModel.copyWith(
      isWorking: true,
      sendingTime: DateTime.now(),
    );
    state = map;

    (http.Response?, Duration?, String?)? responseRec = await request(
      requestModel.httpRequestModel!,
      defaultUriScheme: defaultUriScheme,
    );
    late final RequestModel newRequestModel;
    if (responseRec.$1 == null) {
      newRequestModel = requestModel.copyWith(
        responseStatus: -1,
        message: responseRec.$3,
        isWorking: false,
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
        httpResponseModel: responseModel,
        isWorking: false,
      );
    }

    // update state with response data
    map = {...state!};
    map[id] = newRequestModel;
    state = map;
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  Future<void> clearData() async {
    ref.read(clearDataStateProvider.notifier).state = true;
    ref.read(selectedIdStateProvider.notifier).state = null;
    await hiveHandler.clear();
    ref.read(clearDataStateProvider.notifier).state = false;
    ref.read(requestSequenceProvider.notifier).state = [];
    state = {};
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
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
}
