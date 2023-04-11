import 'package:flutter/material.dart' show Color;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../consts.dart';

const _uuid = Uuid();

final activeIdStateProvider = StateProvider<String?>((ref) => null);
final sentRequestIdStateProvider = StateProvider<String?>((ref) => null);
final codePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final saveDataStateProvider = StateProvider<bool>((ref) => false);
final clearDataStateProvider = StateProvider<bool>((ref) => false);

final StateNotifierProvider<ThemeStateNotifier, ThemeModel> themeStateProvider =
    StateNotifierProvider((ref) => ThemeStateNotifier());

class ThemeStateNotifier extends StateNotifier<ThemeModel> {
  ThemeStateNotifier() : super(ThemeModel()) {
    loadData();
  }

  final hiveHandler = HiveHandler();

  Future<void> toggle() async {
    if (state.themeMode == null) {
      state = state.copyWith(themeMode: false);
    } else {
      state = state.copyWith(themeMode: !state.themeMode!);
    }
    await hiveHandler.setTheme(state.toJson());
  }

  Future<void> setPrimaryColor(Color color) async {
    state = state.copyWith(primaryColor: color);
    await hiveHandler.setTheme(state.toJson());
  }

  void loadData() {
    dynamic themeResult = hiveHandler.getTheme();
    if (themeResult != null) {
      state = ThemeModel.fromJson(
          Map<String, dynamic>.from(hiveHandler.getTheme()));
    }
  }

  void delete() {
    state = ThemeModel();
    hiveHandler.delete(kDataBoxTheme);
  }
}

final StateNotifierProvider<CollectionStateNotifier, List<RequestModel>?>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier());

class CollectionStateNotifier extends StateNotifier<List<RequestModel>?> {
  CollectionStateNotifier() : super(null) {
    loadData();
  }

  final baseResponseModel = const ResponseModel();
  final hiveHandler = HiveHandler();

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
