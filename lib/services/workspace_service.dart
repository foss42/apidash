import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/storage/workspace_meta.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<bool> activateWorkspace(
  WidgetRef ref,
  String path, {
  String? preferredName,
  bool createIfMissing = true,
}) async {
  final opened = await initWorkspaceStorage(
    kIsDesktop,
    path,
    createIfMissing: createIfMissing,
  );
  if (!opened) {
    return false;
  }

  try {
    ref.read(autoSaveNotifierProvider.notifier).cancelPending();
  } catch (_) {
    // ignore
  }
  final name = await ensureAndReadWorkspaceName(
    path,
    preferredName: preferredName,
  );
  await ref.read(settingsProvider.notifier).rememberWorkspace(
        path: path,
        name: name,
      );
  _invalidateWorkspaceProviders(ref);
  return true;
}

void _invalidateWorkspaceProviders(WidgetRef ref) {
  ref.invalidate(collectionsStateNotifierProvider);
  ref.invalidate(collectionStateNotifierProvider);
  ref.invalidate(environmentsStateNotifierProvider);
  ref.invalidate(historyMetaStateNotifier);
  ref.invalidate(selectedIdStateProvider);
  ref.invalidate(selectedCollectionIdStateProvider);
  ref.invalidate(selectedEnvironmentIdStateProvider);
  ref.invalidate(selectedHistoryIdStateProvider);
  ref.invalidate(selectedHistoryRequestModelProvider);
  ref.invalidate(requestSequenceProvider);
  ref.invalidate(expandedCollectionIdsProvider);
}
