import 'dart:async';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/terminal/terminal.dart';
import 'providers.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/utils.dart';

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

final selectedSubstitutedHttpRequestModelProvider =
    StateProvider<HttpRequestModel?>((ref) {
      final selectedRequestModel = ref.watch(selectedRequestModelProvider);
      final envMap = ref.read(availableEnvironmentVariablesStateProvider);
      final activeEnvId = ref.read(activeEnvironmentIdStateProvider);
      if (selectedRequestModel?.httpRequestModel == null) {
        return null;
      } else {
        return substituteHttpRequestModel(
          selectedRequestModel!.httpRequestModel!,
          envMap,
          activeEnvId,
        );
      }
    });

final requestSequenceProvider = StateProvider<List<String>>((ref) {
  var ids = fileSystemHandler.getIds();
  return ids ?? [];
});

final collectionsStateProvider = StateProvider<Map<String, CollectionModel>>((
  ref,
) {
  return {};
});

final activeCollectionIdStateProvider = StateProvider<String?>((ref) => null);

final StateNotifierProvider<CollectionStateNotifier, Map<String, RequestModel>?>
collectionStateNotifierProvider = StateNotifierProvider((ref) {
  final notifier = CollectionStateNotifier(ref, fileSystemHandler);
  ref.onDispose(notifier.cancelAutosaveTimer);
  return notifier;
});

class CollectionStateNotifier
    extends StateNotifier<Map<String, RequestModel>?> {
  CollectionStateNotifier(this.ref, this.fileSystemHandler) : super(null) {
    final snap = fileSystemHandler.loadBootstrapSnapshotSync();
    if (snap != null) {
      _bootCollections = snap.collections;
      _bootActiveCollectionId = snap.activeCollectionId;
      _bootRequestSequence = snap.requestSequence;
      state = snap.requestsById;
      _applyBootProviders();
    } else {
      unawaited(_bootstrapFromHive());
    }
  }

  final Ref ref;
  final FileSystemHandler fileSystemHandler;
  final baseHttpResponseModel = const HttpResponseModel();
  Map<String, CollectionModel> _bootCollections = const {};
  String? _bootActiveCollectionId;
  List<String> _bootRequestSequence = const [];

  Timer? _autosaveTimer;

  void cancelAutosaveTimer() {
    _autosaveTimer?.cancel();
    _autosaveTimer = null;
  }

  String? get _activeCollectionId => ref.read(activeCollectionIdStateProvider);

  String get _resolvedActiveCollectionId {
    final active = _activeCollectionId;
    if (active != null && active.isNotEmpty) return active;
    final ids = ref.read(collectionsStateProvider).keys.toList();
    if (ids.isNotEmpty) return ids.first;
    return 'collection_default';
  }

  bool hasId(String id) => state?.keys.contains(id) ?? false;

  RequestModel? getRequestModel(String id) {
    return state?[id];
  }

  void unsave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(kAutosaveDebounce, () {
      unawaited(_persistCollectionsState(removeUnusedAfter: false));
    });
  }

  Future<void> _persistCollectionsState({required bool removeUnusedAfter}) async {
    if (state == null) return;
    ref.read(saveDataStateProvider.notifier).state = true;
    try {
      final saveResponse = ref.read(settingsProvider).saveResponses;
      final activeCollectionId = _resolvedActiveCollectionId;
      final collections = {...ref.read(collectionsStateProvider)};
      final activeRequestIds = ref.read(requestSequenceProvider);
      final activeCollection = collections[activeCollectionId];
      if (activeCollection != null) {
        collections[activeCollectionId] = activeCollection.copyWith(
          requestIds: activeRequestIds,
          updatedAt: DateTime.now(),
        );
        ref.read(collectionsStateProvider.notifier).state = collections;
      }

      await fileSystemHandler.setCollectionIds(collections.keys.toList());
      await fileSystemHandler.setActiveCollectionId(activeCollectionId);
      for (final entry in collections.entries) {
        final collection = entry.value;
        await fileSystemHandler.setCollectionMeta(entry.key, collection.toJson());
        final ids = entry.key == activeCollectionId
            ? activeRequestIds
            : ((await fileSystemHandler.getCollectionRequestIds(entry.key) as List?)
                      ?.whereType<String>()
                      .toList() ??
                  collection.requestIds);
        await fileSystemHandler.setCollectionRequestIds(entry.key, ids);
        if (entry.key == activeCollectionId) {
          for (final id in ids) {
            await fileSystemHandler.setCollectionRequestModel(
              entry.key,
              id,
              saveResponse
                  ? (state?[id])?.toJson()
                  : (state?[id]?.copyWith(httpResponseModel: null))?.toJson(),
            );
          }
        }
      }

      await fileSystemHandler.setIds(activeRequestIds);
      for (final id in activeRequestIds) {
        await fileSystemHandler.setRequestModel(
          id,
          saveResponse
              ? (state?[id])?.toJson()
              : (state?[id]?.copyWith(httpResponseModel: null))?.toJson(),
        );
      }
      if (removeUnusedAfter) {
        await fileSystemHandler.removeUnused();
      }
    } finally {
      ref.read(saveDataStateProvider.notifier).state = false;
    }
  }

  void add() {
    final id = getNewUuid();
    final defaultName = _nextDefaultRequestName();
    final newRequestModel = RequestModel(
      id: id,
      name: defaultName,
      httpRequestModel: const HttpRequestModel(),
    );
    var map = {...state!};
    map[id] = newRequestModel;
    state = map;
    ref
        .read(requestSequenceProvider.notifier)
        .update((state) => [id, ...state]);
    _syncActiveCollectionRequestIds(ref.read(requestSequenceProvider));
    ref.read(selectedIdStateProvider.notifier).state = newRequestModel.id;
    unsave();
  }

  Future<void> addRequestToCollection(String collectionId) async {
    if (!ref.read(collectionsStateProvider).containsKey(collectionId)) return;
    await switchCollection(collectionId);
    add();
  }

  /// Returns the new collection id, or `null` if [name] duplicates an existing
  /// collection name (case-insensitive).
  Future<String?> addCollection({String? name}) async {
    final existing = ref.read(collectionsStateProvider);
    late final String displayName;
    if (name != null && name.trim().isNotEmpty) {
      displayName = name.trim();
      if (existing.values
          .any((c) => collectionDisplayNamesEqual(c.name, displayName))) {
        return null;
      }
    } else {
      displayName = _nextUniqueNewCollectionDisplayName();
    }
    final id = uniqueCollectionFolderId(
      displayName,
      existing.keys.toSet(),
    );
    final firstRequestId = getNewUuid();
    final now = DateTime.now();
    const firstRequestName = 'request 1';
    final model = CollectionModel(
      id: id,
      name: displayName,
      requestIds: [firstRequestId],
      createdAt: now,
      updatedAt: now,
    );

    cancelAutosaveTimer();
    await _persistCollectionsState(removeUnusedAfter: true);

    final all = {...ref.read(collectionsStateProvider)};
    all[id] = model;
    ref.read(collectionsStateProvider.notifier).state = all;
    ref.read(activeCollectionIdStateProvider.notifier).state = id;
    ref.read(requestSequenceProvider.notifier).state = [firstRequestId];
    ref.read(selectedIdStateProvider.notifier).state = firstRequestId;
    state = {
      firstRequestId: RequestModel(
        id: firstRequestId,
        name: firstRequestName,
        httpRequestModel: const HttpRequestModel(),
      ),
    };
    unsave();
    return id;
  }

  String _nextUniqueNewCollectionDisplayName() {
    const base = 'New Collection';
    final taken = ref
        .read(collectionsStateProvider)
        .values
        .map((c) => c.name.trim().toLowerCase())
        .toSet();
    if (!taken.contains(base.toLowerCase())) return base;
    var n = 2;
    while (taken.contains('${base.toLowerCase()} $n')) {
      n++;
    }
    return '$base $n';
  }

  Future<void> switchCollection(String collectionId) async {
    if (collectionId == _activeCollectionId) return;
    if (!ref.read(collectionsStateProvider).containsKey(collectionId)) return;
    cancelAutosaveTimer();
    await _persistCollectionsState(removeUnusedAfter: true);
    ref.read(activeCollectionIdStateProvider.notifier).state = collectionId;
    await _loadCollectionIntoState(collectionId);
  }

  void addRequestModel(HttpRequestModel httpRequestModel, {String? name}) {
    final id = getNewUuid();
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
    _syncActiveCollectionRequestIds(ref.read(requestSequenceProvider));
    ref.read(selectedIdStateProvider.notifier).state = newRequestModel.id;
    unsave();
  }

  void reorder(int oldIdx, int newIdx) {
    var itemIds = ref.read(requestSequenceProvider);
    final itemId = itemIds.removeAt(oldIdx);
    itemIds.insert(newIdx, itemId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    _syncActiveCollectionRequestIds(itemIds);
    unsave();
  }

  void remove({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId!);
    cancelHttpRequest(rId);
    itemIds.remove(rId);
    ref.read(requestSequenceProvider.notifier).state = [...itemIds];
    _syncActiveCollectionRequestIds(itemIds);

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
    map.remove(rId);
    state = map;
    unsave();
  }

  Future<void> removeCollection(String collectionId) async {
    final all = {...ref.read(collectionsStateProvider)};
    if (!all.containsKey(collectionId)) return;
    if (all.length == 1) return;

    cancelAutosaveTimer();
    await _persistCollectionsState(removeUnusedAfter: true);

    all.remove(collectionId);
    ref.read(collectionsStateProvider.notifier).state = all;
    final nextId = all.keys.first;
    ref.read(activeCollectionIdStateProvider.notifier).state = nextId;
    await _loadCollectionIntoState(nextId);
    await fileSystemHandler.deleteCollection(collectionId);
    await _persistCollectionsState(removeUnusedAfter: true);
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
    unsave();
  }

  void duplicate({String? id}) {
    final rId = id ?? ref.read(selectedIdStateProvider);
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    int idx = itemIds.indexOf(rId!);
    var currentModel = state![rId]!;
    final newModel = currentModel.copyWith(
      id: newId,
      name: "${currentModel.name} (copy)",
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
    _syncActiveCollectionRequestIds(itemIds);
    ref.read(selectedIdStateProvider.notifier).state = newId;
    unsave();
  }

  void duplicateFromHistory(HistoryRequestModel historyRequestModel) {
    final newId = getNewUuid();

    var itemIds = ref.read(requestSequenceProvider);
    var currentModel = historyRequestModel;

    final newModel = RequestModel(
      apiType: currentModel.metaData.apiType,
      id: newId,
      name: "${currentModel.metaData.name} (history)",
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
    _syncActiveCollectionRequestIds(itemIds);
    ref.read(selectedIdStateProvider.notifier).state = newId;
    unsave();
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
        preRequestScript: preRequestScript ?? currentModel.preRequestScript,
        postRequestScript: postRequestScript ?? currentModel.postRequestScript,
        aiRequestModel: aiRequestModel ?? currentModel.aiRequestModel,
      );
    }

    var map = {...state!};
    map[rId] = newModel;
    state = map;
    unsave();
  }

  Future<void> sendRequest() async {
    final requestId = ref.read(selectedIdStateProvider);
    ref.read(codePaneVisibleStateProvider.notifier).state = false;

    if (requestId == null || state == null) {
      return;
    }

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
          unsave();

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
        unsave();
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

      String newHistoryId = getNewUuid();
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
          timeStamp: DateTime.now(),
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

    // Final state update
    state = {...state!, requestId: newRequestModel};

    unsave();
  }

  void cancelRequest() {
    final id = ref.read(selectedIdStateProvider);
    cancelHttpRequest(id);
    unsave();
  }

  Future<void> clearData() async {
    cancelAutosaveTimer();
    ref.read(clearDataStateProvider.notifier).state = true;
    ref.read(selectedIdStateProvider.notifier).state = null;
    await fileSystemHandler.clear();
    ref.read(clearDataStateProvider.notifier).state = false;
    ref.read(requestSequenceProvider.notifier).state = [];
    _syncActiveCollectionRequestIds(const []);
    state = {};
  }

  Future<void> _persistDefaultCollectionBootstrap({
    required String defaultCollectionId,
    required String defaultRequestId,
    required CollectionModel defaultCollection,
    required Map<String, dynamic> requestJson,
  }) async {
    await fileSystemHandler.setCollectionIds([defaultCollectionId]);
    await fileSystemHandler.setActiveCollectionId(defaultCollectionId);
    await fileSystemHandler.setCollectionMeta(
      defaultCollectionId,
      defaultCollection.toJson(),
    );
    await fileSystemHandler.setCollectionRequestModel(
      defaultCollectionId,
      defaultRequestId,
      requestJson,
    );
  }

  void _applyBootProviders() {
    Future.microtask(() {
      ref.read(collectionsStateProvider.notifier).state = _bootCollections;
      ref.read(activeCollectionIdStateProvider.notifier).state =
          _bootActiveCollectionId;
      ref.read(requestSequenceProvider.notifier).state = _bootRequestSequence;
      final sequence = _bootRequestSequence;
      ref.read(selectedIdStateProvider.notifier).state =
          sequence.isNotEmpty ? sequence.first : null;
    });
  }

  Future<void> _bootstrapFromHive() async {
    final collectionIdsRaw = await fileSystemHandler.getCollectionIds();
    final collectionIds =
        (collectionIdsRaw as List?)?.whereType<String>().toList() ?? [];
    if (collectionIds.isEmpty) {
      final defaultCollectionId =
          collectionFolderIdFromDisplayName('Default Collection');
      final defaultRequestId = getNewUuid();
      final now = DateTime.now();
      final defaultCollection = CollectionModel(
        id: defaultCollectionId,
        name: 'Default Collection',
        requestIds: [defaultRequestId],
        createdAt: now,
        updatedAt: now,
      );
      _bootCollections = {
        defaultCollectionId: defaultCollection,
      };
      _bootActiveCollectionId = defaultCollectionId;
      _bootRequestSequence = [defaultRequestId];
      state = {
        defaultRequestId: RequestModel(
          id: defaultRequestId,
          httpRequestModel: const HttpRequestModel(),
        ),
      };
      await _persistDefaultCollectionBootstrap(
        defaultCollectionId: defaultCollectionId,
        defaultRequestId: defaultRequestId,
        defaultCollection: defaultCollection,
        requestJson: state![defaultRequestId]!.toJson(),
      );
      _applyBootProviders();
      return;
    }

    final collections = <String, CollectionModel>{};
    for (final cId in collectionIds) {
      final raw = await fileSystemHandler.getCollectionMeta(cId);
      if (raw == null) continue;
      try {
        final map = Map<String, dynamic>.from(raw);
        final model = CollectionModel.fromJson(map);
        collections[cId] = model;
      } catch (_) {}
    }
    if (collections.isEmpty) {
      final defaultCollectionId =
          collectionFolderIdFromDisplayName('Default Collection');
      final defaultRequestId = getNewUuid();
      final now = DateTime.now();
      final defaultCollection = CollectionModel(
        id: defaultCollectionId,
        name: 'Default Collection',
        requestIds: [defaultRequestId],
        createdAt: now,
        updatedAt: now,
      );
      final defaultRequest = RequestModel(
        id: defaultRequestId,
        httpRequestModel: const HttpRequestModel(),
      );
      _bootCollections = {
        defaultCollectionId: defaultCollection,
      };
      _bootActiveCollectionId = defaultCollectionId;
      _bootRequestSequence = [defaultRequestId];
      state = {defaultRequestId: defaultRequest};
      await _persistDefaultCollectionBootstrap(
        defaultCollectionId: defaultCollectionId,
        defaultRequestId: defaultRequestId,
        defaultCollection: defaultCollection,
        requestJson: defaultRequest.toJson(),
      );
      _applyBootProviders();
      return;
    }
    _bootCollections = collections;
    final active = await fileSystemHandler.getActiveCollectionId();
    final activeId =
        active != null && collections.containsKey(active) ? active : collections.keys.first;
    _bootActiveCollectionId = activeId;
    final loaded = await _readCollectionData(activeId);
    _bootRequestSequence = loaded.sequence;
    state = loaded.requestsById;
    _applyBootProviders();
  }

  Future<void> saveData() async {
    cancelAutosaveTimer();
    await _persistCollectionsState(removeUnusedAfter: true);
  }

  Future<Map<String, dynamic>> exportDataToHAR() async {
    var result = await collectionToHAR(state?.values.toList());
    return result;
    // return {
    //   "data": state!.map((e) => e.toJson(includeResponse: false)).toList()
    // };
  }

  HttpRequestModel getSubstitutedHttpRequestModel(
    HttpRequestModel httpRequestModel,
  ) {
    var envMap = ref.read(availableEnvironmentVariablesStateProvider);
    var activeEnvId = ref.read(activeEnvironmentIdStateProvider);

    return substituteHttpRequestModel(httpRequestModel, envMap, activeEnvId);
  }

  Future<void> _loadCollectionIntoState(String collectionId) async {
    final loaded = await _readCollectionData(collectionId);
    ref.read(requestSequenceProvider.notifier).state = loaded.sequence;
    state = loaded.requestsById;
    final sequence = loaded.sequence;
    ref.read(selectedIdStateProvider.notifier).state =
        sequence.isNotEmpty ? sequence.first : null;
  }

  void _syncActiveCollectionRequestIds(List<String> ids) {
    final activeCollectionId = _activeCollectionId;
    if (activeCollectionId == null) return;
    final all = {...ref.read(collectionsStateProvider)};
    final active = all[activeCollectionId];
    if (active == null) return;
    all[activeCollectionId] = active.copyWith(
      requestIds: [...ids],
      updatedAt: DateTime.now(),
    );
    ref.read(collectionsStateProvider.notifier).state = all;
  }

  String _nextDefaultRequestName() {
    final existingNames = (state?.values ?? const <RequestModel>[])
        .map((r) => r.name.trim().toLowerCase())
        .toSet();
    var idx = 1;
    while (existingNames.contains('request $idx')) {
      idx += 1;
    }
    return 'request $idx';
  }

  Future<_LoadedCollectionData> _readCollectionData(String collectionId) async {
    final idsRaw = await fileSystemHandler.getCollectionRequestIds(collectionId);
    final ids = (idsRaw as List?)?.whereType<String>().toList() ?? [];
    final map = <String, RequestModel>{};
    for (final id in ids) {
      final raw = await fileSystemHandler.getCollectionRequestModel(collectionId, id);
      if (raw == null) continue;
      try {
        final jsonMap = Map<String, Object?>.from(raw);
        var requestModel = RequestModel.fromJson(jsonMap);
        if (requestModel.httpRequestModel == null) {
          requestModel = requestModel.copyWith(
            httpRequestModel: const HttpRequestModel(),
          );
        }
        map[id] = requestModel;
      } catch (_) {}
    }
    return _LoadedCollectionData(
      sequence: ids.where(map.containsKey).toList(),
      requestsById: map,
    );
  }

  /// If Git sends a [remoteCollection.name] that matches another collection
  /// (case-insensitive), the active collection is renamed with a ` (2)` suffix.
  Future<List<MalformedRequestFile>> replaceActiveCollectionFromGit({
    required CollectionModel remoteCollection,
    required List<String> requestOrder,
    required Map<String, RequestModel> requestsById,
    required List<MalformedRequestFile> malformedRequests,
  }) async {
    final activeCollectionId = _resolvedActiveCollectionId;
    final existingCollections = {...ref.read(collectionsStateProvider)};
    final existing = existingCollections[activeCollectionId];
    if (existing == null) {
      return const <MalformedRequestFile>[];
    }

    final others = Map<String, CollectionModel>.from(existingCollections)
      ..remove(activeCollectionId);
    final resolvedName = _disambiguateCollectionDisplayName(
      remoteCollection.name,
      others,
    );

    // Keep local folder id ([existing.id]); Git may carry a legacy UUID in JSON.
    final updatedCollection = existing.copyWith(
      name: resolvedName,
      description: remoteCollection.description,
      requestIds: requestOrder,
      activeEnvironmentId: remoteCollection.activeEnvironmentId,
      gitConnection: existing.gitConnection,
      updatedAt: DateTime.now(),
    );

    existingCollections[activeCollectionId] = updatedCollection;
    ref.read(collectionsStateProvider.notifier).state = existingCollections;

    // Update in-memory request state.
    state = requestsById;
    ref.read(requestSequenceProvider.notifier).state = requestOrder;
    ref.read(selectedIdStateProvider.notifier).state =
        requestOrder.isNotEmpty ? requestOrder.first : null;

    // Persist to disk (replace the active collection contract).
    final saveResponses = ref.read(settingsProvider).saveResponses;
    await fileSystemHandler.setCollectionRequestIds(
      activeCollectionId,
      requestOrder,
    );
    for (final id in requestOrder) {
      final model = requestsById[id];
      if (model == null) continue;
      await fileSystemHandler.setCollectionRequestModel(
        activeCollectionId,
        id,
        saveResponses
            ? model.toJson()
            : model.copyWith(httpResponseModel: null).toJson(),
      );
    }
    await fileSystemHandler.setCollectionMeta(
      activeCollectionId,
      updatedCollection.toJson(),
    );
    await fileSystemHandler.removeUnused();

    return malformedRequests;
  }

  String _disambiguateCollectionDisplayName(
    String desired,
    Map<String, CollectionModel> otherCollections,
  ) {
    final taken = otherCollections.values
        .map((c) => c.name.trim().toLowerCase())
        .toSet();
    final base = desired.trim();
    if (base.isEmpty) return desired;
    if (!taken.contains(base.toLowerCase())) return base;
    var n = 2;
    while (taken.contains('$base ($n)'.toLowerCase())) {
      n++;
    }
    return '$base ($n)';
  }

  Future<void> setActiveCollectionGitConnection(GitConnectionModel? gitConnection) async {
    final activeCollectionId = _resolvedActiveCollectionId;
    final all = {...ref.read(collectionsStateProvider)};
    final existing = all[activeCollectionId];
    if (existing == null) return;

    final existingGit = existing.gitConnection;
    if (existingGit != null &&
        gitConnection != null &&
        existingGit.localRepoPath != gitConnection.localRepoPath) {
      throw StateError(
        'This collection is already connected to ${existingGit.localRepoPath}. '
        'Changing the linked repository path is not allowed.',
      );
    }

    final updated = existing.copyWith(
      gitConnection: gitConnection,
      updatedAt: DateTime.now(),
    );

    all[activeCollectionId] = updated;
    ref.read(collectionsStateProvider.notifier).state = all;
    await fileSystemHandler.setCollectionIds(all.keys.toList());
    await fileSystemHandler.setActiveCollectionId(activeCollectionId);
    await fileSystemHandler.setCollectionMeta(activeCollectionId, updated.toJson());
  }
}

class _LoadedCollectionData {
  const _LoadedCollectionData({
    required this.sequence,
    required this.requestsById,
  });

  final List<String> sequence;
  final Map<String, RequestModel> requestsById;
}
