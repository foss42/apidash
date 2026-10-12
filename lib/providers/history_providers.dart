import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:apidash/models/models.dart';
import '../services/services.dart'
    show
        AiRequestSecretsStorage,
        aiRequestSecretsStorage,
        workspaceStorage,
        WorkspaceStorage;
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

final selectedHistoryRequestModelProvider = StateProvider<HistoryRequestModel?>(
  (ref) => null,
);

final historySequenceProvider =
    StateProvider<Map<DateTime, List<HistoryMetaModel>>?>((ref) {
      final historyMetas = ref.watch(historyMetaStateNotifier);
      return getTemporalGroups(historyMetas?.values.toList());
    });

final StateNotifierProvider<
  HistoryMetaStateNotifier,
  Map<String, HistoryMetaModel>?
>
historyMetaStateNotifier = StateNotifierProvider(
  (ref) => HistoryMetaStateNotifier(ref, workspaceStorage),
);

class HistoryMetaStateNotifier
    extends StateNotifier<Map<String, HistoryMetaModel>?> {
  HistoryMetaStateNotifier(this.ref, this.workspaceStorage) : super(null) {
    loadHistoryMetas();
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;

  bool loadHistoryMetas() {
    final allMetas = workspaceStorage.getAllHistoryMetas();
    if (allMetas == null || allMetas.isEmpty) {
      state = null;
      return false;
    }
    final historyMetaMap = <String, HistoryMetaModel>{};
    for (final entry in allMetas.entries) {
      final jsonMap = Map<String, Object?>.from(entry.value);
      historyMetaMap[entry.key] = HistoryMetaModel.fromJson(jsonMap);
    }
    state = historyMetaMap;
    return true;
  }

  Future<void> loadHistoryRequest(String id) async {
    var jsonModel = await workspaceStorage.getHistoryRequest(id);
    if (jsonModel != null) {
      var jsonMap = Map<String, Object?>.from(jsonModel);
      var historyRequestModel = HistoryRequestModel.fromJson(jsonMap);
      final aiRequestModel = historyRequestModel.aiRequestModel;
      if (aiRequestModel != null) {
        final apiKey = await aiRequestSecretsStorage.readHistoryApiKey(
          workspaceStorage.rootPath,
          id,
        );
        if (apiKey != null && apiKey.isNotEmpty) {
          historyRequestModel = historyRequestModel.copyWith(
            aiRequestModel: aiRequestModel.copyWith(apiKey: apiKey),
          );
        }
      }
      ref.read(selectedHistoryRequestModelProvider.notifier).state =
          historyRequestModel;
      ref.read(selectedHistoryIdStateProvider.notifier).state = id;
    }
  }

  Future<Map<String, dynamic>> _prepareHistoryJsonForDisk(
    String historyId,
    Map<String, dynamic> json,
  ) async {
    final apiKey = AiRequestSecretsStorage.apiKeyFromJson(json);
    if (apiKey != null && apiKey.isNotEmpty) {
      await aiRequestSecretsStorage.writeHistoryApiKey(
        workspaceStorage.rootPath,
        historyId,
        apiKey,
      );
    } else {
      await aiRequestSecretsStorage.deleteHistoryApiKey(
        workspaceStorage.rootPath,
        historyId,
      );
    }
    return AiRequestSecretsStorage.stripApiKeyFromJson(json);
  }

  void addHistoryRequest(HistoryRequestModel model) async {
    final id = model.historyId;
    state = {...state ?? {}, id: model.metaData};
    await workspaceStorage.setHistoryMeta(id, model.metaData.toJson());
    final json = await _prepareHistoryJsonForDisk(id, model.toJson());
    await workspaceStorage.setHistoryRequest(id, json);
    await loadHistoryRequest(id);
  }

  void editHistoryRequest(HistoryRequestModel model) async {
    final id = model.historyId;
    state = {...state ?? {}, id: model.metaData};
    await workspaceStorage.setHistoryMeta(id, model.metaData.toJson());
    final json = await _prepareHistoryJsonForDisk(id, model.toJson());
    await workspaceStorage.setHistoryRequest(id, json);
    await loadHistoryRequest(id);
  }

  Future<void> clearAllHistory() async {
    await workspaceStorage.clearAllHistory();
    await aiRequestSecretsStorage.deleteAllHistoryForWorkspace(
      workspaceStorage.rootPath,
    );
    ref.read(selectedHistoryIdStateProvider.notifier).state = null;
    ref.read(selectedHistoryRequestModelProvider.notifier).state = null;
    loadHistoryMetas();
  }
}
