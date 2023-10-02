import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/services.dart'
    show hiveHandler, HiveHandler, request;
import 'package:apidash/utils/utils.dart' show uuid, collectionToHAR;
import 'package:apidash/consts.dart';

final activeRequestModelProvider = StateProvider<RequestModel?>((ref) {
  final activeId = ref.watch(activeIdStateProvider);
  final collection = ref.watch(collectionStateNotifierProvider);
  if (activeId == null || collection == null) {
    return null;
  } else {
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    if (idIdx.isNegative) {
      return null;
    } else {
      return collection[idIdx];
    }
  }
});

final StateNotifierProvider<CollectionStateNotifier, List<RequestModel>?>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier(ref, hiveHandler));

class CollectionStateNotifier extends StateNotifier<List<RequestModel>?> {
  CollectionStateNotifier(this.ref, this.hiveHandler) : super(null) {
    loadData();
    Future.microtask(() =>
        ref.read(activeIdStateProvider.notifier).update((s) => state?[0].id));
  }

  final Ref ref;
  final HiveHandler hiveHandler;
  final baseResponseModel = const ResponseModel();

  List<String> getIds() => state!.map((e) => e.id).toList();
  int idxOfId(String id) => state!.indexWhere((element) => element.id == id);

  RequestModel getRequestModel(String id) {
    final idx = idxOfId(id);
    return state![idx];
  }

  void add() {
    final newRequestModel = RequestModel(
      id: uuid.v1(),
    );
    state = [newRequestModel, ...state!];
    ref
        .read(activeIdStateProvider.notifier)
        .update((state) => newRequestModel.id);
  }

  void reorder(int oldIdx, int newIdx) {
    final item = state!.removeAt(oldIdx);
    state!.insert(newIdx, item);
  }

  void remove(String id) {
    int idx = idxOfId(id);
    String? newId;
    if (idx == 0 && state!.length > 1) {
      newId = state![1].id;
    } else if (state!.length > 2) {
      newId = state![idx - 1].id;
    } else {
      newId = null;
    }

    state = [
      for (final model in state!)
        if (model.id != id) model,
    ];
    ref.read(activeIdStateProvider.notifier).update((state) => newId);
  }

  void duplicate(String id) {
    final idx = idxOfId(id);
    final newModel = state![idx].duplicate(
      id: uuid.v1(),
    );
    state = [
      ...state!.sublist(0, idx + 1),
      newModel,
      ...state!.sublist(idx + 1)
    ];
  }

  void update(
    String id, {
    HTTPVerb? method,
    String? url,
    String? name,
    String? description,
    int? requestTabIndex,
    List<NameValueModel>? requestHeaders,
    List<NameValueModel>? requestParams,
    ContentType? requestBodyContentType,
    String? requestBody,
    int? responseStatus,
    String? message,
    ResponseModel? responseModel,
  }) {
    final idx = idxOfId(id);
    final newModel = state![idx].copyWith(
        method: method,
        url: url,
        name: name,
        description: description,
        requestTabIndex: requestTabIndex,
        requestHeaders: requestHeaders,
        requestParams: requestParams,
        requestBodyContentType: requestBodyContentType,
        requestBody: requestBody,
        responseStatus: responseStatus,
        message: message,
        responseModel: responseModel);
    //print(newModel);
    state = [...state!.sublist(0, idx), newModel, ...state!.sublist(idx + 1)];
  }

  Future<void> sendRequest(String id) async {
    ref.read(sentRequestIdStateProvider.notifier).update((state) => id);
    ref.read(codePaneVisibleStateProvider.notifier).update((state) => false);
    final defaultUriScheme =
        ref.read(settingsProvider.select((value) => value.defaultUriScheme));
    final idx = idxOfId(id);
    RequestModel requestModel = getRequestModel(id);
    var responseRec =
        await request(requestModel, defaultUriScheme: defaultUriScheme);
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
    //print(newRequestModel);
    ref.read(sentRequestIdStateProvider.notifier).update((state) => null);
    state = [
      ...state!.sublist(0, idx),
      newRequestModel,
      ...state!.sublist(idx + 1)
    ];
  }

  Future<void> clearData() async {
    ref.read(clearDataStateProvider.notifier).update((state) => true);
    ref.read(activeIdStateProvider.notifier).update((state) => null);
    await hiveHandler.clear();
    ref.read(clearDataStateProvider.notifier).update((state) => false);
    state = [];
  }

  void loadData() {
    var ids = hiveHandler.getIds();
    if (ids == null || ids.length == 0) {
      state = [
        RequestModel(
          id: uuid.v1(),
        ),
      ];
    } else {
      List<RequestModel> data = [];
      for (var id in ids) {
        var jsonModel = hiveHandler.getRequestModel(id);
        if (jsonModel != null) {
          var requestModel =
              RequestModel.fromJson(Map<String, dynamic>.from(jsonModel));
          data.add(requestModel);
        }
      }
      state = data;
    }
  }

  Future<void> saveData() async {
    ref.read(saveDataStateProvider.notifier).update((state) => true);
    final saveResponse =
        ref.read(settingsProvider.select((value) => value.saveResponses));
    final ids = getIds();
    await hiveHandler.setIds(ids);
    for (var e in state!) {
      await hiveHandler.setRequestModel(
        e.id,
        e.toJson(includeResponse: saveResponse),
      );
    }
    await hiveHandler.removeUnused();
    ref.read(saveDataStateProvider.notifier).update((state) => false);
  }

  Future<Map<String, dynamic>> exportDataToHAR() async {
    var result = await collectionToHAR(state);
    return result;
    // return {
    //   "data": state!.map((e) => e.toJson(includeResponse: false)).toList()
    // };
  }
}
