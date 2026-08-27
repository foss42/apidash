import 'package:apidash/consts.dart';

import 'models/sync_models.dart';
import 'storage/sync_storage.dart';
import 'sync_diff.dart';
import 'sync_manifest_builder.dart';
import 'sync_workspace_io.dart';
import 'transport/sync_file_transfer.dart';

class SyncApplyResult {
  const SyncApplyResult({
    required this.appliedIncoming,
    required this.sentOutgoing,
    required this.newBaseline,
  });

  final int appliedIncoming;
  final int sentOutgoing;
  final Map<String, String> newBaseline;
}

List<String> expandSyncWritePaths(Iterable<SyncFileChange> outgoing) {
  final expanded = <String>{};
  for (final change in outgoing) {
    if (change.kind == SyncFileChangeKind.deleted) {
      continue;
    }
    expanded.add(change.path);
  }

  var touchedCollections = false;
  for (final path in List<String>.from(expanded)) {
    if (!path.startsWith('$kWorkspaceCollectionsDir/')) {
      continue;
    }
    final segments = path.split('/');
    if (segments.length < 2) {
      continue;
    }
    touchedCollections = true;
    final collectionId = segments[1];
    if (segments.length >= 3) {
      expanded.add(
        '$kWorkspaceCollectionsDir/$collectionId/$kWorkspaceRequestIndexFile',
      );
    }
  }
  if (touchedCollections) {
    expanded.add(
      '$kWorkspaceCollectionsDir/$kWorkspaceCollectionsIndexFile',
    );
  }

  final touchesEnvironments = expanded.any(
    (path) =>
        path.startsWith('$kWorkspaceEnvironmentsDir/') &&
        !path.endsWith(kWorkspaceEnvironmentIndexFile),
  );
  if (touchesEnvironments) {
    expanded.add(
      '$kWorkspaceEnvironmentsDir/$kWorkspaceEnvironmentIndexFile',
    );
  }

  var touchedWorkflows = false;
  for (final path in List<String>.from(expanded)) {
    if (!path.startsWith('$kWorkspaceWorkflowsDir/')) {
      continue;
    }
    touchedWorkflows = true;
  }
  if (touchedWorkflows) {
    expanded.add(
      '$kWorkspaceWorkflowsDir/$kWorkspaceWorkflowsIndexFile',
    );
  }

  return expanded.toList()..sort();
}

/// Push local [outgoing] changes to the peer. Local disk is unchanged.
Future<SyncApplyResult> applySend({
  required String workspaceRoot,
  required SyncStorage storage,
  required SyncPeerInfo peer,
  required List<SyncFileChange> outgoing,
  required SyncFileTransfer transfer,
  required Map<String, String> peerManifest,
}) async {
  final writes = <String, String>{};
  final deletes = <String>[];

  for (final change in outgoing) {
    if (change.kind == SyncFileChangeKind.deleted) {
      deletes.add(change.path);
    }
  }

  for (final path in expandSyncWritePaths(outgoing)) {
    final content = await readSyncableWorkspaceFile(workspaceRoot, path);
    if (content != null) {
      writes[path] = content;
    }
  }

  final newBaseline = await buildSyncManifest(workspaceRoot);

  return _persistAndNotifyPeer(
    storage: storage,
    peer: peer,
    transfer: transfer,
    newBaseline: newBaseline,
    writes: writes,
    deletes: deletes,
    appliedIncoming: 0,
    sentOutgoing: writes.length + deletes.length,
  );
}

/// Pull [incoming] changes from the peer. Peer disk is unchanged.
Future<SyncApplyResult> applyReceive({
  required String workspaceRoot,
  required SyncStorage storage,
  required SyncPeerInfo peer,
  required List<SyncFileChange> incoming,
  required SyncFileTransfer transfer,
  required Map<String, String> peerManifest,
}) async {
  var appliedIncoming = 0;
  for (final change in incoming) {
    if (change.kind == SyncFileChangeKind.deleted) {
      await deleteSyncableWorkspaceFile(workspaceRoot, change.path);
      appliedIncoming++;
      continue;
    }

    final content = await transfer.fetchPeerFile(change.path);
    if (content == null) {
      throw StateError('Peer did not send ${change.path}');
    }
    await writeSyncableWorkspaceFile(workspaceRoot, change.path, content);
    appliedIncoming++;
  }

  // Use post-write local hashes, not the peer manifest captured at connect.
  // Peer manifest can be stale after flush/autosave and does not reflect bytes
  // we just persisted locally.
  final newBaseline = await buildSyncManifest(workspaceRoot);

  return _persistAndNotifyPeer(
    storage: storage,
    peer: peer,
    transfer: transfer,
    newBaseline: newBaseline,
    appliedIncoming: appliedIncoming,
    sentOutgoing: 0,
  );
}

Future<SyncApplyResult> applyReplaceFromPeer({
  required String workspaceRoot,
  required SyncStorage storage,
  required SyncPeerInfo peer,
  required SyncFileTransfer transfer,
  required Map<String, String> peerManifest,
}) async {
  var appliedIncoming = 0;
  for (final path in peerManifest.keys) {
    final content = await transfer.fetchPeerFile(path);
    if (content == null) continue;
    await writeSyncableWorkspaceFile(workspaceRoot, path, content);
    appliedIncoming++;
  }

  final localManifest = await buildSyncManifest(workspaceRoot);
  for (final path in localManifest.keys) {
    if (!peerManifest.containsKey(path)) {
      await deleteSyncableWorkspaceFile(workspaceRoot, path);
    }
  }

  final newBaseline = await buildSyncManifest(workspaceRoot);
  return _persistAndNotifyPeer(
    storage: storage,
    peer: peer,
    transfer: transfer,
    newBaseline: newBaseline,
    appliedIncoming: appliedIncoming,
    sentOutgoing: 0,
  );
}

Future<SyncApplyResult> _persistAndNotifyPeer({
  required SyncStorage storage,
  required SyncPeerInfo peer,
  required SyncFileTransfer transfer,
  required Map<String, String> newBaseline,
  Map<String, String> writes = const {},
  List<String> deletes = const [],
  required int appliedIncoming,
  required int sentOutgoing,
}) async {
  final now = DateTime.now().toUtc().toIso8601String();
  await storage.saveSyncState(
    SyncState(
      lastSyncAt: now,
      peerDisplayName: peer.displayName,
      baseline: newBaseline,
    ),
  );
  await transfer.sendApplyComplete(
    newBaseline,
    writes: writes,
    deletes: deletes,
  );

  return SyncApplyResult(
    appliedIncoming: appliedIncoming,
    sentOutgoing: sentOutgoing,
    newBaseline: newBaseline,
  );
}

Future<int> countUnsyncedOutgoingChanges(String workspaceRoot) async {
  final local = await buildSyncManifest(workspaceRoot);
  final storage = SyncStorage(workspaceRoot);
  final state = await storage.readSyncState();
  if (state == null || !state.hasBaseline) return 0;
  final changeSet = computeSyncChangeSet(
    baseline: state.baseline,
    local: local,
    peer: state.baseline,
  );
  return changeSet.outgoing.length;
}
