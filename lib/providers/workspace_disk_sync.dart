import 'dart:async';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/services/storage/disk_sync.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'collection_catalog_providers.dart';
import 'environment_providers.dart';
import 'settings_providers.dart';
import 'workspace_lifecycle.dart';
import '../workflow/providers/workflow_providers.dart';

const _kDiskSyncDebounce = Duration(milliseconds: 180);
const _kDiskSyncSuppressRetry = Duration(milliseconds: 200);
const _kWorkspaceFolderPollInterval = Duration(seconds: 1);

/// Watches the active workspace and applies external disk changes into UI.
///
/// Self-writes are filtered via [workspaceWriteJournal]. Autosave/git
/// suppress windows defer apply (never drop events).
final workspaceDiskSyncProvider = Provider<void>((ref) {
  if (!kIsDesktop) return;

  final path = ref.watch(
    settingsProvider.select((settings) => settings.workspaceFolderPath),
  );
  if (path == null || path.isEmpty) return;

  final root = p.normalize(path);
  StreamSubscription<FileSystemEvent>? subscription;
  Timer? debounce;
  final pending = <WorkspaceDiskChange>{};

  void enqueue(WorkspaceDiskChange change) {
    pending.add(change);
    debounce?.cancel();
    debounce = Timer(_kDiskSyncDebounce, () {
      final batch = pending.toList(growable: false);
      pending.clear();
      unawaited(_applyDiskSyncBatch(ref, batch));
    });
  }

  unawaited(_ensureActiveWorkspaceStillOnDiskRef(ref));

  final pollTimer = Timer.periodic(_kWorkspaceFolderPollInterval, (_) {
    unawaited(_ensureActiveWorkspaceStillOnDiskRef(ref));
  });

  if (isWorkspaceStorageInitialized()) {
    try {
      subscription = Directory(root).watch(recursive: true).listen(
        (event) {
          if (workspaceWriteJournal.wasRecent(event.path)) {
            return;
          }
          final change = classifyWorkspaceDiskEvent(
            event: event,
            workspaceRoot: root,
          );
          if (change != null) {
            enqueue(change);
          }
        },
        onError: (_) => unawaited(_ensureActiveWorkspaceStillOnDiskRef(ref)),
        onDone: () => unawaited(_ensureActiveWorkspaceStillOnDiskRef(ref)),
      );
    } catch (e, st) {
      debugPrint('workspaceDiskSyncProvider watch failed: $e\n$st');
      unawaited(closeActiveWorkspaceMissingOnDisk(ref));
    }
  }

  ref.onDispose(() {
    debounce?.cancel();
    pollTimer.cancel();
    subscription?.cancel();
  });
});

Future<void> _ensureActiveWorkspaceStillOnDiskRef(Ref ref) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;
  if (!await Directory(p.normalize(path)).exists()) {
    await closeActiveWorkspaceMissingOnDisk(ref);
  }
}

Future<void> _applyDiskSyncBatch(
  Ref ref,
  List<WorkspaceDiskChange> batch,
) async {
  if (!ref.mounted || batch.isEmpty) return;
  if (ref.read(workspaceDiskReloadSuppressCountProvider) > 0) {
    Timer(_kDiskSyncSuppressRetry, () {
      if (!ref.mounted) return;
      unawaited(_applyDiskSyncBatch(ref, batch));
    });
    return;
  }
  if (!isWorkspaceStorageInitialized()) return;

  if (batch.any((c) => c is WorkspaceRootRemoved)) {
    await closeActiveWorkspaceMissingOnDisk(ref);
    return;
  }

  final catalog = ref.read(collectionCatalogProvider.notifier);
  final workflows = ref.read(workflowCatalogProvider.notifier);
  final environments = ref.read(environmentsStateNotifierProvider.notifier);
  var removedRequest = false;
  var removedCollection = false;
  var removedWorkflow = false;
  var removedEnvironment = false;

  // Structural changes before index/content so order heals last.
  final ordered = [
    ...batch.whereType<CollectionRemovedFromDisk>(),
    ...batch.whereType<RequestRemovedFromDisk>(),
    ...batch.whereType<WorkflowRemovedFromDisk>(),
    ...batch.whereType<EnvironmentRemovedFromDisk>(),
    ...batch.whereType<CollectionAddedFromDisk>(),
    ...batch.whereType<RequestAddedFromDisk>(),
    ...batch.whereType<WorkflowAddedFromDisk>(),
    ...batch.whereType<EnvironmentAddedFromDisk>(),
    ...batch.whereType<RequestContentChangedOnDisk>(),
    ...batch.whereType<WorkflowContentChangedOnDisk>(),
    ...batch.whereType<EnvironmentContentChangedOnDisk>(),
    ...batch.whereType<CollectionIndexChangedOnDisk>(),
    ...batch.whereType<RequestIndexChangedOnDisk>(),
    ...batch.whereType<WorkflowIndexChangedOnDisk>(),
    ...batch.whereType<EnvironmentIndexChangedOnDisk>(),
  ];

  await runWithDiskSyncMuteAutosave(ref, () async {
    for (final change in ordered) {
      switch (change) {
        case CollectionRemovedFromDisk(:final collectionId):
          if (workspaceStorage.getCollection(collectionId) != null) {
            continue;
          }
          final collectionDir = Directory(
            p.join(
              workspaceStorage.rootPath,
              kWorkspaceCollectionsDir,
              collectionId,
            ),
          );
          if (await collectionDir.exists()) {
            continue;
          }
          if (await catalog.applyExternalCollectionRemoved(collectionId)) {
            removedCollection = true;
          }
        case CollectionAddedFromDisk(:final collectionId):
          await catalog.applyExternalCollectionAdded(collectionId);
        case RequestRemovedFromDisk(:final collectionId, :final requestId):
          if (workspaceStorage.requestExistsOnDisk(collectionId, requestId)) {
            continue;
          }
          if (await catalog.applyExternalRequestRemoved(
            collectionId,
            requestId,
          )) {
            removedRequest = true;
          }
        case RequestAddedFromDisk(:final collectionId, :final requestId):
          if (!workspaceStorage.requestExistsOnDisk(collectionId, requestId)) {
            await Future<void>.delayed(const Duration(milliseconds: 80));
          }
          if (!workspaceStorage.requestExistsOnDisk(collectionId, requestId)) {
            continue;
          }
          catalog.applyExternalRequestAdded(collectionId, requestId);
        case RequestContentChangedOnDisk(:final collectionId, :final requestId):
          catalog.applyExternalRequestContentChanged(collectionId, requestId);
        case CollectionIndexChangedOnDisk():
          await catalog.applyExternalCollectionIndexChanged();
        case RequestIndexChangedOnDisk(:final collectionId):
          catalog.applyExternalRequestIndexChanged(collectionId);
        case WorkflowRemovedFromDisk(:final workflowId):
          if (workspaceStorage.workflowExistsOnDisk(workflowId)) {
            continue;
          }
          if (await workflows.applyExternalWorkflowRemoved(workflowId)) {
            removedWorkflow = true;
          }
        case WorkflowAddedFromDisk(:final workflowId):
          if (!workspaceStorage.workflowExistsOnDisk(workflowId)) {
            await Future<void>.delayed(const Duration(milliseconds: 80));
          }
          if (!workspaceStorage.workflowExistsOnDisk(workflowId)) {
            continue;
          }
          await workflows.applyExternalWorkflowAdded(workflowId);
        case WorkflowContentChangedOnDisk(:final workflowId):
          await workflows.applyExternalWorkflowContentChanged(workflowId);
        case WorkflowIndexChangedOnDisk():
          await workflows.applyExternalWorkflowIndexChanged();
        case EnvironmentRemovedFromDisk(:final environmentId):
          if (environmentId == kGlobalEnvironmentId) {
            await environments.ensureGlobalEnvironment();
            continue;
          }
          if (workspaceStorage.environmentExistsOnDisk(environmentId)) {
            continue;
          }
          if (await environments
              .applyExternalEnvironmentRemoved(environmentId)) {
            removedEnvironment = true;
          }
        case EnvironmentAddedFromDisk(:final environmentId):
          if (environmentId == kGlobalEnvironmentId) {
            await environments.ensureGlobalEnvironment();
            continue;
          }
          if (!workspaceStorage.environmentExistsOnDisk(environmentId)) {
            await Future<void>.delayed(const Duration(milliseconds: 80));
          }
          if (!workspaceStorage.environmentExistsOnDisk(environmentId)) {
            continue;
          }
          await environments.applyExternalEnvironmentAdded(environmentId);
        case EnvironmentContentChangedOnDisk(:final environmentId):
          await environments
              .applyExternalEnvironmentContentChanged(environmentId);
        case EnvironmentIndexChangedOnDisk():
          await environments.applyExternalEnvironmentIndexChanged();
        case WorkspaceRootRemoved():
          break;
      }
    }
  });

  if (removedCollection) {
    _showDiskRemovalSnackBar(kMsgCollectionRemovedFromDisk);
  } else if (removedRequest) {
    _showDiskRemovalSnackBar(kMsgRequestRemovedFromDisk);
  } else if (removedWorkflow) {
    _showDiskRemovalSnackBar(kMsgWorkflowRemovedFromDisk);
  } else if (removedEnvironment) {
    _showDiskRemovalSnackBar(kMsgEnvironmentRemovedFromDisk);
  }
}

void _showDiskRemovalSnackBar(String message) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final messenger = kAppScaffoldMessengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        getSnackBar(
          message,
          color: kColorRed,
          small: false,
          duration: kWorkspaceMissingSnackDuration,
        ),
      );
  });
}
