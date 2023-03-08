import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../consts.dart';

const _uuid = Uuid();

final activeItemIdStateProvider = StateProvider<String?>((ref) => null);

final StateNotifierProvider<CollectionStateNotifier, List<RequestModel>>
    collectionStateNotifierProvider =
    StateNotifierProvider((ref) => CollectionStateNotifier());

class CollectionStateNotifier extends StateNotifier<List<RequestModel>> {
  CollectionStateNotifier()
      : super([
          RequestModel(
            id: _uuid.v1(),
          ),
        ]);

  final baseResponseModel = const ResponseModel();

  int idxOfId(String id) => state.indexWhere((element) => element.id == id);

  RequestModel getRequestModel(String id) {
    final idx = idxOfId(id);
    return state[idx];
  }

  String add() {
    final newRequestModel = RequestModel(
      id: _uuid.v1(),
    );
    state = [newRequestModel, ...state];
    return newRequestModel.id;
  }

  void reorder(int oldIdx, int newIdx) {
    final item = state.removeAt(oldIdx);
    state.insert(newIdx, item);
  }

  void remove(String id) {
    state = [
      for (final model in state)
        if (model.id != id) model,
    ];
  }

  void duplicate(String id) {
    final idx = idxOfId(id);
    final newModel = state[idx].duplicate(
      id: _uuid.v1(),
    );
    state = [...state.sublist(0, idx + 1), newModel, ...state.sublist(idx + 1)];
  }

  void update(
    String id, {
    HTTPVerb? method,
    String? url,
    int? requestTabIndex,
    List<KVRow>? requestHeaders,
    List<KVRow>? requestParams,
    ContentType? requestBodyContentType,
    dynamic requestBody,
    int? responseStatus,
    String? message,
    ResponseModel? responseModel,
  }) {
    final idx = idxOfId(id);
    final newModel = state[idx].copyWith(
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
    state = [...state.sublist(0, idx), newModel, ...state.sublist(idx + 1)];
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
        message: RESPONSE_CODE_REASONS[statusCode],
        responseModel: responseModel,
      );
    }
    //print(newRequestModel);
    state = [
      ...state.sublist(0, idx),
      newRequestModel,
      ...state.sublist(idx + 1)
    ];
  }
}
