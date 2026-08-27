import 'dart:async';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/git/providers/git_status_provider.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/sync/providers/sync_providers.dart';
import 'package:apidash/sync/storage/sync_storage.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod/misc.dart' show ProviderListenable, ProviderOrFamily;

import 'auto_save.dart';
import 'active_collection_providers.dart';
import 'collection_catalog_providers.dart';
import 'environment_providers.dart';
import 'history_providers.dart';
import 'settings_providers.dart';
import 'ui_providers.dart';
import '../workflow/providers/workflow_providers.dart';
import '../workflow/providers/workflow_ui_providers.dart';
import '../workflow/providers/workflow_history_providers.dart';

final workspaceDiskReloadSuppressCountProvider = StateProvider<int>((ref) => 0);

/// While > 0, autosave ignores provider changes from disk→memory apply.
final workspaceDiskSyncMuteAutosaveCountProvider = StateProvider<int>((ref) => 0);

const _kWorkspaceDiskSuppressTail = Duration(milliseconds: 1500);

typedef _WorkspaceReader = T Function<T>(ProviderListenable<T> provider);
typedef _WorkspaceInvalidator =
    void Function(ProviderOrFamily provider, {bool asReload});

bool _workspaceCloseInProgress = false;

String? _activeWorkspacePath(_WorkspaceReader read) {
  final path = read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return null;
  return p.normalize(path);
}

bool workspaceFolderExistsOnDiskSync(Ref ref) {
  final path = _activeWorkspacePath(ref.read);
  if (path == null) return false;
  return Directory(path).existsSync();
}

Future<bool> _workspaceFolderExists(String path) =>
    Directory(p.normalize(path)).exists();

void beginWorkspaceDiskReloadSuppress(Ref ref) {
  _beginWorkspaceDiskReloadSuppress(ref.read);
}

void endWorkspaceDiskReloadSuppress(Ref ref) {
  _endWorkspaceDiskReloadSuppress(ref.read);
}

void beginWorkspaceDiskSyncMuteAutosave(Ref ref) {
  ref.read(workspaceDiskSyncMuteAutosaveCountProvider.notifier).state++;
}

void endWorkspaceDiskSyncMuteAutosave(Ref ref) {
  final notifier = ref.read(workspaceDiskSyncMuteAutosaveCountProvider.notifier);
  final next = notifier.state - 1;
  notifier.state = next < 0 ? 0 : next;
}

Future<T> runWithDiskSyncMuteAutosave<T>(
  Ref ref,
  Future<T> Function() action,
) async {
  beginWorkspaceDiskSyncMuteAutosave(ref);
  try {
    return await action();
  } finally {
    endWorkspaceDiskSyncMuteAutosave(ref);
  }
}

void _beginWorkspaceDiskReloadSuppress(_WorkspaceReader read) {
  read(workspaceDiskReloadSuppressCountProvider.notifier).state++;
}

void _endWorkspaceDiskReloadSuppress(_WorkspaceReader read) {
  Future<void>.delayed(_kWorkspaceDiskSuppressTail, () {
    final notifier = read(workspaceDiskReloadSuppressCountProvider.notifier);
    final next = notifier.state - 1;
    notifier.state = next < 0 ? 0 : next;
  });
}

void _showWorkspaceMissingOnDiskSnackBar() {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final messenger = kAppScaffoldMessengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        getSnackBar(
          kMsgWorkspaceRecentMissing,
          color: kColorRed,
          small: false,
          duration: kWorkspaceMissingSnackDuration,
        ),
      );
  });
}

/// Clears the active workspace and returns the app to the workspace selector.
Future<void> closeActiveWorkspaceMissingOnDisk(Ref ref) async {
  if (_workspaceCloseInProgress) return;

  final path = _activeWorkspacePath(ref.read);
  if (path == null) return;

  _workspaceCloseInProgress = true;
  _beginWorkspaceDiskReloadSuppress(ref.read);
  try {
    await ref.read(autoSaveNotifierProvider.notifier).cancelPendingAndWait();
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
    resetWorkspaceStorage();
    await ref
        .read(settingsProvider.notifier)
        .clearActiveWorkspace(removeFromRecents: true);
    _showWorkspaceMissingOnDiskSnackBar();
  } finally {
    _endWorkspaceDiskReloadSuppress(ref.read);
    _workspaceCloseInProgress = false;
  }
}

/// Reloads workspace providers from disk. Called only from explicit git flows
/// (pull, checkout, restore) — never from passive filesystem watching.
Future<void> reloadWorkspaceFromDisk(WidgetRef ref) =>
    _reloadWorkspaceFromDisk(ref.read, ref.invalidate);

Future<void> reloadWorkspaceFromDiskRef(Ref ref) async {
  final path = _activeWorkspacePath(ref.read);
  if (path != null && !await _workspaceFolderExists(path)) {
    await closeActiveWorkspaceMissingOnDisk(ref);
    return;
  }
  await _reloadWorkspaceFromDisk(ref.read, ref.invalidate);
}

Future<void> _reloadWorkspaceFromDisk(
  _WorkspaceReader read,
  _WorkspaceInvalidator invalidate,
) async {
  _beginWorkspaceDiskReloadSuppress(read);
  try {
    read(autoSaveNotifierProvider.notifier).cancelPending();
    read(hasUnsavedChangesProvider.notifier).state = false;
    _resetWorkspaceSelectionState(read);
    await SchedulerBinding.instance.endOfFrame;
    _invalidateWorkspaceProviders(invalidate);
    invalidate(gitStatusProvider);
    read(gitDiskRevisionProvider.notifier).bump();
    await SchedulerBinding.instance.endOfFrame;
    read(collectionCatalogProvider.notifier).reloadAllCollectionsFromDisk();
    final activeCollectionId = read(selectedCollectionIdStateProvider);
    if (activeCollectionId != null) {
      await read(activeCollectionProvider.notifier).ensureActive(
        activeCollectionId,
      );
    }
    await read(workflowCatalogProvider.notifier).reloadFromDisk();
    read(flowHistoryMetasProvider.notifier).reload();
    final activeWorkflowId = read(selectedWorkflowIdStateProvider);
    if (activeWorkflowId != null) {
      await read(activeWorkflowProvider.notifier).load(activeWorkflowId);
    } else {
      read(activeWorkflowProvider.notifier).clear();
    }
  } finally {
    _endWorkspaceDiskReloadSuppress(read);
  }
}

void resetWorkspaceSelectionState(WidgetRef ref) {
  _resetWorkspaceSelectionState(ref.read);
}

void _resetWorkspaceSelectionState(_WorkspaceReader read) {
  if (!isWorkspaceStorageInitialized()) {
    return;
  }
  final index = workspaceStorage.getCollectionsIndex();
  final firstCollectionId = index.isNotEmpty ? index.first.id : null;
  read(selectedCollectionIdStateProvider.notifier).state = firstCollectionId;
  read(selectedIdStateProvider.notifier).state = null;
  read(selectedEnvironmentIdStateProvider.notifier).state =
      kGlobalEnvironmentId;
  read(selectedHistoryIdStateProvider.notifier).state = null;
  read(selectedHistoryRequestModelProvider.notifier).state = null;
  read(requestSequenceProvider.notifier).state = [];
  read(expandedCollectionIdsProvider.notifier).state =
      firstCollectionId != null ? {firstCollectionId} : {};
  final workflowIds = workspaceStorage.getKnownWorkflowIds();
  read(selectedWorkflowIdStateProvider.notifier).state =
      workflowIds.isNotEmpty ? workflowIds.first : null;
  read(selectedWorkflowNodeIdProvider.notifier).state = null;
  final settings = read(settingsProvider);
  if (settings.activeEnvironmentId != kGlobalEnvironmentId) {
    unawaited(
      read(
        settingsProvider.notifier,
      ).update(activeEnvironmentId: kGlobalEnvironmentId),
    );
  }
}

void invalidateWorkspaceProviders(WidgetRef ref) =>
    _invalidateWorkspaceProviders(ref.invalidate);

void _invalidateWorkspaceProviders(_WorkspaceInvalidator invalidate) {
  invalidate(collectionCatalogProvider);
  invalidate(activeCollectionProvider);
  invalidate(environmentsStateNotifierProvider);
  invalidate(historyMetaStateNotifier);
  invalidate(syncUnsyncedCountProvider);
  invalidate(workflowCatalogProvider);
  invalidate(activeWorkflowProvider);
}

Future<void> clearAllWorkspaceData(WidgetRef ref) async {
  if (!isWorkspaceStorageInitialized()) {
    return;
  }

  ref.read(clearDataStateProvider.notifier).state = true;
  ref.read(saveDataStateProvider.notifier).state = true;
  ref.read(hasUnsavedChangesProvider.notifier).state = false;

  _beginWorkspaceDiskReloadSuppress(ref.read);
  try {
    ref.read(autoSaveNotifierProvider.notifier).cancelPending();

    final root = workspaceStorage.rootPath;
    await SyncStorage(root).deleteApidashDir();
    await workspaceStorage.clear();

    invalidateWorkspaceProviders(ref);
    ref.invalidate(gitStatusProvider);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await SchedulerBinding.instance.endOfFrame;
  } finally {
    _endWorkspaceDiskReloadSuppress(ref.read);
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
    ref.read(clearDataStateProvider.notifier).state = false;
    ref.read(saveDataStateProvider.notifier).state = false;
  }
}
