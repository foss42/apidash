import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import '../services/services.dart' show hiveHandler, HiveHandler;
import '../utils/history_utils.dart';

final selectedHistoryIdStateProvider = StateProvider<String?>((ref) => null);

final selectedRequestGroupIdStateProvider = StateProvider<String?>((ref) {
  final selectedHistoryId = ref.watch(selectedHistoryIdStateProvider);
  final historyMetaState = ref.read(historyMetaStateNotifier);
  if (selectedHistoryId == null) {
    return null;
  }
  return getHistoryRequestKey(historyMetaState![selectedHistoryId]!);
});

final selectedHistoryRequestModelProvider =
    StateProvider<HistoryRequestModel?>((ref) => null);

final historySequenceProvider =
    StateProvider<Map<DateTime, List<HistoryMetaModel>>?>((ref) {
  final historyMetas = ref.watch(historyMetaStateNotifier);
  return getTemporalGroups(historyMetas?.values.toList());
});

final StateNotifierProvider<HistoryMetaStateNotifier,
        Map<String, HistoryMetaModel>?> historyMetaStateNotifier =
    StateNotifierProvider((ref) => HistoryMetaStateNotifier(ref, hiveHandler));

class HistoryMetaStateNotifier
    extends StateNotifier<Map<String, HistoryMetaModel>?> {
  HistoryMetaStateNotifier(this.ref, this.hiveHandler) : super(null) {
    var status = loadHistoryMetas();
    Future.microtask(() {
      if (status) {
        final temporalGroups = getTemporalGroups(state?.values.toList());
        final latestRequestId = getLatestRequestId(temporalGroups);
        if (latestRequestId != null) {
          loadHistoryRequest(latestRequestId);
        }
      }
    });
  }

  final Ref ref;
  final HiveHandler hiveHandler;

  bool loadHistoryMetas() {
    List<String>? historyIds = hiveHandler.getHistoryIds();
    if (historyIds == null || historyIds.isEmpty) {
      state = null;
      return false;
    } else {
      Map<String, HistoryMetaModel> historyMetaMap = {};
      for (var historyId in historyIds) {
        var jsonModel = hiveHandler.getHistoryMeta(historyId);
        if (jsonModel != null) {
          var jsonMap = Map<String, Object?>.from(jsonModel);
          var historyMetaModelFromJson = HistoryMetaModel.fromJson(jsonMap);
          historyMetaMap[historyId] = historyMetaModelFromJson;
        }
      }
      state = historyMetaMap;
      return true;
    }
  }

  Future<void> loadHistoryRequest(String id) async {
    var jsonModel = await hiveHandler.getHistoryRequest(id);
    if (jsonModel != null) {
      var jsonMap = Map<String, Object?>.from(jsonModel);
      var historyRequestModelFromJson = HistoryRequestModel.fromJson(jsonMap);
      ref.read(selectedHistoryRequestModelProvider.notifier).state =
          historyRequestModelFromJson;
      ref.read(selectedHistoryIdStateProvider.notifier).state = id;
    }
  }

  void addHistoryRequest(HistoryRequestModel model) async {
    final id = model.historyId;
    state = {
      ...state ?? {},
      id: model.metaData,
    };
    final List<String> updatedHistoryKeys =
        state == null ? [id] : [...state!.keys, id];
    hiveHandler.setHistoryIds(updatedHistoryKeys);
    hiveHandler.setHistoryMeta(id, model.metaData.toJson());
    await hiveHandler.setHistoryRequest(id, model.toJson());
    await loadHistoryRequest(id);
  }
}
