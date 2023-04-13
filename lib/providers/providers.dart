import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../consts.dart';

const _uuid = Uuid();

final hiveHandler = HiveHandler();

final StateNotifierProvider<ThemeStateNotifier, bool> darkModeProvider =
    StateNotifierProvider((ref) => ThemeStateNotifier(hiveHandler));

class ThemeStateNotifier extends StateNotifier<bool> {
  ThemeStateNotifier(this.hiveHandler) : super(false) {
    state = hiveHandler.getDarkMode() ?? false;
  }
  final HiveHandler hiveHandler;

  Future<void> toggle() async {
    state = !state;
    await hiveHandler.setDarkMode(state);
  }
}

final activeIdStateProvider = StateProvider<String?>((ref) => null);
final sentRequestIdStateProvider = StateProvider<String?>((ref) => null);
final codePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final saveDataStateProvider = StateProvider<bool>((ref) => false);
final clearDataStateProvider = StateProvider<bool>((ref) => false);

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

  String add() {
    final newRequestModel = RequestModel(
      id: _uuid.v1(),
    );
    state = [newRequestModel, ...state!];
    return newRequestModel.id;
  }

  void reorder(int oldIdx, int newIdx) {
    final item = state!.removeAt(oldIdx);
    state!.insert(newIdx, item);
  }

  void remove(String id) {
    hiveHandler.delete(id);
    state = [
      for (final model in state!)
        if (model.id != id) model,
    ];
  }

  void duplicate(String id) {
    final idx = idxOfId(id);
    final newModel = state![idx].duplicate(
      id: _uuid.v1(),
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
    int? requestTabIndex,
    List<KVRow>? requestHeaders,
    List<KVRow>? requestParams,
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
    final idx = idxOfId(id);
    RequestModel requestModel = getRequestModel(id);
    var responseRec = await request(requestModel);
    late final RequestModel newRequestModel;
    if (responseRec.$0 == null) {
      newRequestModel = requestModel.copyWith(
        responseStatus: -1,
        message: responseRec.$2,
      );
    } else {
      final responseModel = baseResponseModel.fromResponse(
        response: responseRec.$0!,
        time: responseRec.$1!,
      );
      int statusCode = responseRec.$0!.statusCode;
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
    await hiveHandler.clear();
    state = [];
  }

  Future<void> loadData() async {
    var ids = hiveHandler.getIds();
    if (ids == null) {
      state = [
        RequestModel(
          id: _uuid.v1(),
        ),
      ];
    } else {
      await hiveHandler.removeUnused();
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
    final ids = getIds();
    await hiveHandler.setIds(ids);
    for (var e in state!) {
      await hiveHandler.setRequestModel(e.id, e.toJson());
    }
  }
}
