import 'dart:async';
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/terminal/terminal.dart';
import 'providers.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/utils.dart';

final selectedIdStateProvider = StateProvider<String?>((ref) => null);

final selectedRequestModelProvider = Provider<RequestModel?>((ref) {
  final selectedId = ref.watch(selectedIdStateProvider);
  final collection = ref.watch(activeCollectionProvider);
  if (selectedId == null || collection == null) {
    return null;
  }
  return collection[selectedId];
});

final selectedSubstitutedHttpRequestModelProvider =
    Provider<HttpRequestModel?>((ref) {
      final selectedRequestModel = ref.watch(selectedRequestModelProvider);
      final envMap = ref.watch(availableEnvironmentVariablesStateProvider);
      final activeEnvId = ref.watch(activeEnvironmentIdProvider);
      if (selectedRequestModel?.httpRequestModel == null) {
        return null;
      }
      return substituteHttpRequestModel(
        selectedRequestModel!.httpRequestModel!,
        envMap,
        activeEnvId,
      );
    });

final StateNotifierProvider<ActiveCollectionNotifier, Map<String, RequestModel>?>
activeCollectionProvider = StateNotifierProvider(
  (ref) => ActiveCollectionNotifier(ref, workspaceStorage),
);

class ActiveCollectionNotifier
    extends StateNotifier<Map<String, RequestModel>?> {
  ActiveCollectionNotifier(this.ref, this.workspaceStorage) : super(null) {
    Future.microtask(() {
      if (!isWorkspaceStorageInitialized()) {
        return;
      }
      ref.read(collectionCatalogProvider);
      activateCollection(ref.read(selectedCollectionIdStateProvider));
    });
  }

  List<String> _catalogRequestIds(String collectionId) {
    return ref
            .read(collectionCatalogProvider)?[collectionId]
            ?.requestIds ??
        const [];
  }

  RequestSummary? _summaryForId(String collectionId, String id) {
    if (collectionId == _activeCollectionId && state?[id] != null) {
      return RequestSummary.fromRequestModel(state![id]!);
    }
    final catalog = ref.read(collectionCatalogProvider)?[collectionId];
    for (final summary in catalog?.requests ?? const <RequestSummary>[]) {
      if (summary.id == id) {
        return summary;
      }
    }
    final diskJson = workspaceStorage.getRequestModel(collectionId, id);
    if (diskJson == null) {
      return null;
    }
    return RequestSummary.fromRequestModel(
      RequestModel.fromJson(Map<String, Object?>.from(diskJson)),
    );
  }

  List<RequestSummary> summariesForSequence(
    String collectionId,
    List<String> ids,
  ) {
    return [
      for (final id in ids)
        if (_summaryForId(collectionId, id) case final summary?) summary,
    ];
  }

  void _syncActiveCollectionSummaries() {
    final active = _activeCollectionId;
    if (active == null) {
      return;
    }
    ref.read(collectionCatalogProvider.notifier).syncRequests(
          active,
          summariesForSequence(
            active,
            ref.read(requestSequenceProvider),
          ),
        );
  }

  RequestModel? _requestModelFromDisk(
    String collectionId,
    String folderId, {
    Set<String> takenDisplayNamesLowercase = const {},
  }) {
    return requestModelFromDiskFolder(
      storage: workspaceStorage,
      collectionId: collectionId,
      folderId: folderId,
      takenDisplayNamesLowercase: takenDisplayNamesLowercase,
    );
  }

  Future<void> _persistAdoptedRequest(
    String collectionId,
    String requestId,
    RequestModel model,
  ) async {
    if (!ref.mounted || !isWorkspaceStorageInitialized()) return;
    final settings = ref.read(settingsProvider);
    var json = settings.saveResponses
        ? model.toJson()
        : model.copyWith(httpResponseModel: null).toJson();
    json = await _prepareRequestJsonForDisk(collectionId, requestId, json);
    await workspaceStorage.setRequestModel(
      collectionId,
      requestId,
      json,
      saveMediaAsFiles: settings.saveMediaResponsesAsFiles,
    );
  }

  Future<void> _hydrateAiApiKey(String collectionId, String id) async {
    final apiKey = await aiRequestSecretsStorage.readApiKey(
      workspaceStorage.rootPath,
      collectionId,
      id,
    );
    if (apiKey == null || apiKey.isEmpty) {
      return;
    }
    final current = state?[id];
    if (current?.aiRequestModel == null) {
      return;
    }
    state = {
      ...state!,
      id: current!.copyWith(
        aiRequestModel: current.aiRequestModel?.copyWith(apiKey: apiKey),
      ),
    };
  }

  Future<Map<String, dynamic>> _prepareRequestJsonForDisk(
    String collectionId,
    String requestId,
    Map<String, dynamic> json,
  ) async {
    final apiKey = AiRequestSecretsStorage.apiKeyFromJson(json);
    if (apiKey != null && apiKey.isNotEmpty) {
      await aiRequestSecretsStorage.writeApiKey(
        workspaceStorage.rootPath,
        collectionId,
        requestId,
        apiKey,
      );
    } else {
      await aiRequestSecretsStorage.deleteApiKey(
        workspaceStorage.rootPath,
        collectionId,
        requestId,
      );
    }
    return AiRequestSecretsStorage.stripApiKeyFromJson(json);
  }

  void loadRequest(String id) {
    if (state?[id] != null) {
      return;
    }
    final active = _activeCollectionId;
    if (active == null) {
      return;
    }
    final model = _requestModelFromDisk(active, id);
    if (model == null) {
      return;
    }
    state = {...state ?? {}, id: model};
    _syncedContentFingerprints[id] = requestContentFingerprint(model);
    if (model.aiRequestModel != null) {
      unawaited(_hydrateAiApiKey(active, id));
    }
  }


  bool applyExternalRequestContentChanged(String requestId) {
    final active = _activeCollectionId;
    if (active == null) return false;
    if (!workspaceStorage.requestExistsOnDisk(active, requestId)) {
      return false;
    }
    final diskModel = _requestModelFromDisk(active, requestId);
    if (diskModel == null) return false;

    final current = state?[requestId];
    final inSequence = ref.read(requestSequenceProvider).contains(requestId);

    if (current != null) {
      final synced = _syncedContentFingerprints[requestId];
      if (synced != null &&
          requestContentFingerprint(current) != synced) {
        return false;
      }
    } else if (!inSequence) {
      return applyExternalRequestAdded(requestId);
    }

    state = {...state ?? {}, requestId: diskModel};
    _syncedContentFingerprints[requestId] =
        requestContentFingerprint(diskModel);
    if (diskModel.aiRequestModel != null) {
      unawaited(_hydrateAiApiKey(active, requestId));
    }
    _syncActiveCollectionSummaries();
    return true;
  }

  bool applyExternalRequestAdded(String requestId) {
    final active = _activeCollectionId;
    if (active == null) return false;
    if (!workspaceStorage.requestExistsOnDisk(active, requestId)) {
      return false;
    }

    final sequence = ref.read(requestSequenceProvider);
    if (sequence.contains(requestId)) {
      return false;
    }

    final takenNames = <String>{
      for (final id in sequence)
        if (_summaryForId(active, id)?.name case final name?)
          name.toLowerCase(),
    };
    final takenIds = sequence.toSet();
    final adopted = adoptRequestFolderFromDisk(
      storage: workspaceStorage,
      collectionId: active,
      folderId: requestId,
      takenNamesLower: takenNames,
      takenIds: takenIds,
    );
    if (adopted == null || sequence.contains(adopted.id)) {
      return false;
    }

    ref.read(requestSequenceProvider.notifier).state = [
      ...sequence,
      adopted.id,
    ];
    state = {...state ?? {}, adopted.id: adopted.model};
    _syncedContentFingerprints[adopted.id] =
        requestContentFingerprint(adopted.model);
    if (adopted.model.aiRequestModel != null) {
      unawaited(_hydrateAiApiKey(active, adopted.id));
    }
    _syncActiveCollectionSummaries();
    unawaited(_persistAdoptedRequest(active, adopted.id, adopted.model));
    return true;
  }

  bool applyExternalRequestIndexChanged() {
    final active = _activeCollectionId;
    if (active == null) return false;
    final indexed = workspaceStorage.getIds(active);
    final onDisk = workspaceStorage.listRequestIdsOnDisk(active);
    final ordered = <String>[
      for (final id in indexed)
        if (onDisk.contains(id) ||
            workspaceStorage.requestExistsOnDisk(active, id))
          id,
      for (final id in onDisk)
        if (!indexed.contains(id)) id,
    ];
    final current = ref.read(requestSequenceProvider);
    if (listEquals(current, ordered)) {
      return false;
    }

    ref.read(requestSequenceProvider.notifier).state = ordered;
    _syncActiveCollectionSummaries();
    return true;
  }

  String _storageLabelFor(RequestModel model) {
    if (model.name.trim().isNotEmpty) {
      return model.name;
    }
    final url = model.httpRequestModel?.url ?? model.aiRequestModel?.url;
    return getRequestTitleFromUrl(url);
  }

  void _rekeyRequest(String oldId, String newId, RequestModel model) {
    if (oldId == newId) {
      return;
    }
    final map = {...state!}..remove(oldId);
    map[newId] = model.copyWith(id: newId);
    state = map;

    final sequence = ref.read(requestSequenceProvider);
    ref.read(requestSequenceProvider.notifier).state = [
      for (final id in sequence) id == oldId ? newId : id,
    ];
    if (ref.read(selectedIdStateProvider) == oldId) {
      ref.read(selectedIdStateProvider.notifier).state = newId;
    }
    final active = _activeCollectionId;
    if (active == null) {
      return;
    }
    workspaceStorage.renameRequestSync(active, oldId, newId);
    final fp = _syncedContentFingerprints.remove(oldId);
    if (fp != null) {
      _syncedContentFingerprints[newId] = fp;
    }
    unawaited(
      aiRequestSecretsStorage.rekeyApiKey(
        workspaceStorage.rootPath,
        active,
        oldId,
        newId,
      ),
    );
  }

  void _rekeyUnnamedRequestsFromUrlLabel() {
    for (final id in [...ref.read(requestSequenceProvider)]) {
      final model = state?[id];
      if (model == null || model.name.trim().isNotEmpty) {
        continue;
      }
      final newId = renameStorageId(id, _storageLabelFor(model));
      if (newId == id) {
        continue;
      }
      _rekeyRequest(id, newId, model.copyWith(id: newId));
    }
  }

  void _seedDefaultRequest(String collectionId) {
    final onDisk = workspaceStorage.getKnownRequestIds(collectionId);
    if (onDisk.isNotEmpty) {
      state = {};
      ref.read(requestSequenceProvider.notifier).state = [...onDisk];
      ref.read(selectedIdStateProvider.notifier).state = null;
      return;
    }
    final newId = makeStorageId('');
    state = {
      newId: RequestModel(
        id: newId,
        httpRequestModel: const HttpRequestModel(),
      ),
    };
    ref.read(requestSequenceProvider.notifier).state = [newId];
    ref.read(selectedIdStateProvider.notifier).state = newId;
    ref.read(collectionCatalogProvider.notifier).syncRequests(
          collectionId,
          [RequestSummary.fromRequestModel(state![newId]!)],
        );
  }

  void activateCollection(String? collectionId) {
    _syncedContentFingerprints.clear();
    if (collectionId == null) {
      state = {};
      ref.read(requestSequenceProvider.notifier).state = [];
      ref.read(selectedIdStateProvider.notifier).state = null;
      return;
    }
    ref.read(collectionCatalogProvider.notifier).loadCollection(collectionId);
    var ids = _catalogRequestIds(collectionId);
    if (ids.isEmpty) {
      ids = workspaceStorage.getKnownRequestIds(collectionId);
      if (ids.isNotEmpty) {
        ref
            .read(collectionCatalogProvider.notifier)
            .reloadCollectionFromDisk(collectionId);
      }
    }
    if (ids.isEmpty) {
      _seedDefaultRequest(collectionId);
      return;
    }
    state = {};
    ref.read(requestSequenceProvider.notifier).state = [...ids];
    ref.read(selectedIdStateProvider.notifier).state = null;
  }

  String? get _activeCollectionId =>
      ref.read(selectedCollectionIdStateProvider);

  Future<void> ensureActive(String? collectionId) async {
    if (_activeCollectionId == collectionId && state != null) {
      return;
    }
    final collections = ref.read(collectionCatalogProvider.notifier);
    final from = _activeCollectionId;
    final fromStillExists = from != null &&
        (ref.read(collectionCatalogProvider)?.containsKey(from) ?? false);
    if (state != null && from != collectionId && fromStillExists) {
      collections.loadCollection(from);
      await saveData(collectionId: from);
    }
    if (collectionId != null) {
      collections.loadCollection(collectionId);
    }
    state = {};
    ref.read(selectedCollectionIdStateProvider.notifier).state = collectionId;
    activateCollection(collectionId);
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;
  final baseHttpResponseModel = const HttpResponseModel();
  bool _saveDataInFlight = false;
  String? _pendingSaveCollectionId;

  /// Fingerprint of request content last known to match disk (no response).
  /// Used so external VS Code edits update clean requests without clobbering
  /// in-memory edits that have not been saved yet.
  final Map<String, String> _syncedContentFingerprints = {};

  bool hasId(String id) => state?.keys.contains(id) ?? false;

  RequestModel? getRequestModel(String id) {
    return state?[id];
  }

  void add() {
    final id = makeStorageId('');
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
    _syncActiveCollectionSummaries();
  }

  void addRequestModel(HttpRequestModel httpRequestModel, {String? name}) {
    final id = makeStorageId(name ?? '');
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
    _syncActiveCollectionSummaries();
  }

  void reorder(int oldIdx, int newIdx) {
    var itemIds = ref.read(requestSequenceProvider);
    final itemId = itemIds.removeAt(oldIdx);
    itemIds.insert(newIdx, itemId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    _syncActiveCollectionSummaries();
  }

  void remove({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    if (rId == null) return;
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId);
    if (idx < 0 && !(state?.containsKey(rId) ?? false)) {
      return;
    }
    cancelHttpRequest(rId);
    if (idx >= 0) {
      itemIds = [...itemIds]..removeAt(idx);
      ref.read(requestSequenceProvider.notifier).state = itemIds;
    } else {
      itemIds = [...itemIds];
    }

    if (state != null && state!.containsKey(rId)) {
      var map = {...state!};
      map.remove(rId);
      state = map;
    }
    _syncedContentFingerprints.remove(rId);

    final selectedId = ref.read(selectedIdStateProvider);
    if (selectedId == rId) {
      String? newId;
      if (itemIds.isEmpty) {
        newId = null;
      } else if (idx <= 0) {
        newId = itemIds[0];
      } else if (idx >= itemIds.length) {
        newId = itemIds[itemIds.length - 1];
      } else {
        newId = itemIds[idx - 1];
      }
      // Neighbor may only be in the sequence (lazy load) — hydrate before select
      // so the editor does not show a blank URL/body pane.
      if (newId != null) {
        loadRequest(newId);
      }
      ref.read(selectedIdStateProvider.notifier).state = newId;
    }

    _syncActiveCollectionSummaries();
  }

  /// Applies an external (Finder/editor) deletion of a request folder.
  ///
  /// Idempotent: no-ops when the request is already gone from memory.
  Future<bool> applyExternalRequestRemoved(String requestId) async {
    final inSequence = ref.read(requestSequenceProvider).contains(requestId);
    final inState = state?.containsKey(requestId) ?? false;
    if (!inSequence && !inState) {
      return false;
    }
    remove(id: requestId);
    final active = _activeCollectionId;
    if (active != null) {
      final model = ref.read(collectionCatalogProvider)?[active];
      if (model != null) {
        await workspaceStorage.setCollection(active, model.toJson());
      }
    }
    return true;
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
  }

  void duplicate({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    loadRequest(rId!);
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId);
    var currentModel = state![rId]!;
    final copyName = "${currentModel.name} (copy)";
    final newId = makeStorageId(copyName);
    final newModel = currentModel.copyWith(
      id: newId,
      name: copyName,
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
    _syncActiveCollectionSummaries();
  }

  void duplicateFromHistory(HistoryRequestModel historyRequestModel) {
    var itemIds = ref.read(requestSequenceProvider);
    var currentModel = historyRequestModel;
    final historyName = "${currentModel.metaData.name} (history)";
    final newId = makeStorageId(historyName);

    final newModel = RequestModel(
      apiType: currentModel.metaData.apiType,
      id: newId,
      name: historyName,
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
    _syncActiveCollectionSummaries();
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
    bool clearPreRequestScript = false,
    bool clearPostRequestScript = false,
    AIRequestModel? aiRequestModel,
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
        responseStatus: responseStatus ?? currentModel.responseStatus,
        message: message ?? currentModel.message,
        httpResponseModel: httpResponseModel ?? currentModel.httpResponseModel,
        preRequestScript: clearPreRequestScript
            ? null
            : preRequestScript ?? currentModel.preRequestScript,
        postRequestScript: clearPostRequestScript
            ? null
            : postRequestScript ?? currentModel.postRequestScript,
        aiRequestModel: aiRequestModel ?? currentModel.aiRequestModel,
      );
    }

    if (name != null) {
      final storageLabel = _storageLabelFor(newModel);
      final newId = renameStorageId(rId, storageLabel);
      if (newId != rId) {
        _rekeyRequest(rId, newId, newModel.copyWith(id: newId));
        _syncActiveCollectionSummaries();
        return;
      }
    }

    state = {...state!, rId: newModel};
    _syncActiveCollectionSummaries();
  }

  Future<void> sendRequest() async {
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;

    if (requestId == null || state == null) {
      return;
    }

    loadRequest(requestId);
    RequestModel? requestModel = state![requestId];
    if (requestModel?.httpRequestModel == null &&
        requestModel?.aiRequestModel == null) {
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
    HttpRequestModel substitutedHttpRequestModel;

    if (apiType == APIType.ai) {
      substitutedHttpRequestModel = getSubstitutedHttpRequestModel(
        executionRequestModel.aiRequestModel!.httpRequestModel!,
      );
    } else {
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

      final historyName = requestModel.name.isNotEmpty
          ? requestModel.name
          : substitutedHttpRequestModel.url;
      final historyTimeStamp = DateTime.now();
      String newHistoryId = makeHistoryId(
        timeStamp: historyTimeStamp,
        name: historyName,
      );
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
          timeStamp: historyTimeStamp,
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

    state = {...state!, requestId: newRequestModel};

  }

  void cancelRequest() {
    final id = ref.read(selectedIdStateProvider);
    cancelHttpRequest(id);
  }

  Future<void> clearData() async {
    ref.read(clearDataStateProvider.notifier).state = true;
    ref.read(selectedIdStateProvider.notifier).state = null;
    beginWorkspaceDiskReloadSuppress(ref);
    try {
      await environmentSecretsStorage.deleteAllForWorkspace(
        workspaceStorage.rootPath,
      );
      await aiRequestSecretsStorage.deleteAllForWorkspace(
        workspaceStorage.rootPath,
      );
      await workspaceStorage.clear();
      await ref
          .read(environmentsStateNotifierProvider.notifier)
          .loadEnvironments();
      ref.read(requestSequenceProvider.notifier).state = [];
      state = {};
      _syncedContentFingerprints.clear();
    } finally {
      endWorkspaceDiskReloadSuppress(ref);
      ref.read(clearDataStateProvider.notifier).state = false;
    }
  }

  Future<void> saveData({String? collectionId}) async {
    if (!ref.mounted || !isWorkspaceStorageInitialized()) {
      return;
    }
    if (_saveDataInFlight) {
      _pendingSaveCollectionId = collectionId ?? _activeCollectionId;
      return;
    }
    _saveDataInFlight = true;
    try {
      await _saveDataImpl(collectionId);
    } finally {
      _saveDataInFlight = false;
      final pending = _pendingSaveCollectionId;
      _pendingSaveCollectionId = null;
      if (pending != null && ref.mounted) {
        await saveData(collectionId: pending);
      }
    }
  }

  Future<void> _saveDataImpl(String? collectionId) async {
    if (!ref.mounted || !isWorkspaceStorageInitialized()) {
      return;
    }
    final targetId = collectionId ?? _activeCollectionId;
    if (targetId == null) {
      return;
    }
    ref.read(saveDataStateProvider.notifier).state = true;
    try {
      _rekeyUnnamedRequestsFromUrlLabel();
      if (!ref.mounted) return;
      final settings = ref.read(settingsProvider);
      final saveResponse = settings.saveResponses;
      final saveMediaAsFiles = settings.saveMediaResponsesAsFiles;
      final ids = [...ref.read(requestSequenceProvider)];
      final summaries = summariesForSequence(targetId, ids);
      ref
          .read(collectionCatalogProvider.notifier)
          .syncRequests(targetId, summaries);
      for (final requestId in ids) {
        if (!ref.mounted) return;
        final inMemory = state?[requestId];
        Map<String, dynamic>? json;
        if (inMemory != null) {
          json = saveResponse
              ? inMemory.toJson()
              : inMemory.copyWith(httpResponseModel: null).toJson();
          json = await _prepareRequestJsonForDisk(targetId, requestId, json);
        } else {
          final diskJson = workspaceStorage.getRequestModel(targetId, requestId);
          if (diskJson == null) {
            continue;
          }
          if (saveResponse) {
            json = Map<String, dynamic>.from(diskJson);
          } else {
            final diskModel = RequestModel.fromJson(
              Map<String, Object?>.from(diskJson),
            );
            json = diskModel.copyWith(httpResponseModel: null).toJson();
          }
        }
        await workspaceStorage.setRequestModel(
          targetId,
          requestId,
          json,
          saveMediaAsFiles: saveMediaAsFiles,
        );
        final savedModel = state?[requestId];
        if (savedModel != null) {
          _syncedContentFingerprints[requestId] =
              requestContentFingerprint(savedModel);
        }
      }

      if (!ref.mounted) return;
      final finalIds = ref.read(requestSequenceProvider).toSet();
      await workspaceStorage.removeUnused(targetId, requestIds: finalIds);
      await aiRequestSecretsStorage.deleteOrphansForCollection(
        workspaceStorage.rootPath,
        targetId,
        finalIds,
      );
      _syncedContentFingerprints
          .removeWhere((id, _) => !finalIds.contains(id));
    } finally {
      if (ref.mounted) {
        ref.read(saveDataStateProvider.notifier).state = false;
        ref.read(hasUnsavedChangesProvider.notifier).state = false;
      }
    }
  }

  Future<Map<String, dynamic>> exportDataToHAR() async {
    final collectionId = _activeCollectionId;
    if (collectionId == null) {
      return <String, dynamic>{};
    }
    final models = <RequestModel>[];
    for (final id in ref.read(requestSequenceProvider)) {
      final model =
          state?[id] ?? _requestModelFromDisk(collectionId, id);
      if (model != null) {
        models.add(model);
      }
    }
    var result = await collectionToHAR(models);
    return result;
    // return {
    //   "data": state!.map((e) => e.toJson(includeResponse: false)).toList()
    // };
  }

  HttpRequestModel getSubstitutedHttpRequestModel(
    HttpRequestModel httpRequestModel,
  ) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdProvider);

    return substituteHttpRequestModel(httpRequestModel, envMap, activeEnvId);
  }
}

/// Stable fingerprint of editable request content (excludes response + API key).
String requestContentFingerprint(RequestModel model) {
  final json = Map<String, dynamic>.from(
    model.copyWith(httpResponseModel: null).toJson(),
  );
  final stripped = AiRequestSecretsStorage.stripApiKeyFromJson(json);
  return jsonEncode(stripped);
}
