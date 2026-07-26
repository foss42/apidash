import 'dart:async';
import 'dart:io';

import '../consts.dart';
import '../models/sync_models.dart';
import '../storage/sync_storage.dart';
import '../sync_manifest_builder.dart';
import '../sync_session_compute.dart';
import '../sync_workspace_io.dart';
import 'sync_file_transfer.dart';
import 'sync_messages.dart';

enum SyncClientStatus { idle, connecting, connected, error }

/// Mobile-side WebSocket client.
class SyncSessionClient implements SyncFileTransfer {
  SyncSessionClient({
    required this.storage,
    required Map<String, String> localManifest,
    required this.workspaceRoot,
    required this.qrPayload,
    required this.localDisplayName,
    required this.localWorkspaceId,
    required this.localHasBaseline,
    required this.sessionMode,
  }) : _localManifest = localManifest;

  Map<String, String> get localManifest => _localManifest;

  final SyncStorage storage;
  Map<String, String> _localManifest;
  final String workspaceRoot;
  final SyncQrPayload qrPayload;
  final String localDisplayName;
  final String localWorkspaceId;
  final bool localHasBaseline;
  final SyncSessionMode sessionMode;

  WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSub;

  SyncClientStatus _status = SyncClientStatus.idle;
  Map<String, String> _peerManifest = const {};
  final Map<String, String?> _peerFileCache = {};
  final Map<String, Completer<_PeerFileResult>> _pendingPeerFiles = {};

  SyncPeerInfo? _peer;
  bool _wasPairedBefore = false;
  bool _peerHasBaseline = true;

  SyncClientStatus get status => _status;
  bool get isConnected =>
      _socket != null && _status == SyncClientStatus.connected;
  SyncPeerInfo? get peer => _peer;
  bool get wasPairedBefore => _wasPairedBefore;
  Map<String, String> get peerManifest => _peerManifest;

  void Function(SyncPeerInfo peer, bool wasPairedBefore)? onPeerConnected;
  void Function()? onPeerDisconnected;
  void Function(SyncChangeSet changeSet)? onChangeSet;
  void Function(String message)? onError;
  void Function()? onRemoteApplied;

  Future<void> connect() async {
    if (_status != SyncClientStatus.idle) return;
    _status = SyncClientStatus.connecting;

    try {
      _socket = await WebSocket.connect(qrPayload.websocketUrl);
    } catch (e) {
      _status = SyncClientStatus.error;
      onError?.call(kErrSyncConnectFailed);
      return;
    }

    _attachSocket();
    _send(
      SyncMessage.hello(
        token: qrPayload.token,
        workspaceId: localWorkspaceId,
        displayName: localDisplayName,
        hasBaseline: localHasBaseline,
        sessionMode: sessionMode.name,
      ),
    );
  }

  void _attachSocket() {
    _socketSub = _socket!.listen(
      (dynamic data) async {
        if (data is! String) return;
        final message = SyncMessage.tryDecode(data);
        if (message == null) return;

        switch (message.type) {
          case SyncMessageType.helloAck:
            _peerHasBaseline = message.hasBaseline;
            _peer = SyncPeerInfo(
              workspaceId:
                  message.stringWorkspaceId ?? qrPayload.workspaceId,
              workspaceName:
                  message.stringWorkspaceName ?? qrPayload.workspaceName,
              displayName:
                  message.stringDisplayName ?? qrPayload.desktopName,
            );
            _wasPairedBefore = peersPairedBefore(
              localHadBaseline: localHasBaseline,
              peerHadBaseline: message.hasBaseline,
            );
            onPeerConnected?.call(_peer!, _wasPairedBefore);
            break;
          case SyncMessageType.manifest:
            _peerManifest = message.readManifest();
            _send(SyncMessage.manifest(_localManifest));
            await _emitChangeSet();
            _status = SyncClientStatus.connected;
            break;
          case SyncMessageType.fileRequest:
            await _handlePeerFileRequest(message.stringPath);
            break;
          case SyncMessageType.fileContent:
            _resolvePeerFile(message);
            break;
          case SyncMessageType.applyComplete:
            await _applyRemoteResult(message);
            await _persistBaseline(message.readManifest());
            await refreshManifest();
            onRemoteApplied?.call();
            break;
          case SyncMessageType.error:
            onError?.call(message.errorMessage ?? 'Desktop reported an error');
            break;
          case SyncMessageType.bye:
            await disconnect();
            break;
          case SyncMessageType.hello:
            break;
        }
      },
      onDone: () => disconnect(),
      onError: (Object e) {
        onError?.call('Connection error: $e');
        disconnect();
      },
      cancelOnError: true,
    );
  }

  Future<void> refreshManifest() async {
    _localManifest = await buildSyncManifest(workspaceRoot);
    await _emitChangeSet();
  }

  Future<void> _emitChangeSet() async {
    if (_peer == null) return;
    final state = await storage.readSyncState();
    final baseline = state?.baseline ?? const {};
    final changeSet = computeSessionChangeSet(
      baseline: baseline,
      local: _localManifest,
      peer: _peerManifest,
      peerHasBaseline: _peerHasBaseline,
    );
    onChangeSet?.call(changeSet);
  }

  Future<void> _handlePeerFileRequest(String? path) async {
    if (path == null || path.isEmpty) return;
    final content = await readSyncableWorkspaceFile(workspaceRoot, path);
    if (content == null) {
      _send(SyncMessage.fileContent(path: path, deleted: true));
      return;
    }
    _send(SyncMessage.fileContent(path: path, content: content));
  }

  void _resolvePeerFile(SyncMessage message) {
    final path = message.stringPath;
    if (path == null || path.isEmpty) return;
    final result = _PeerFileResult(
      content: message.isDeleted ? null : message.stringContent,
      deleted: message.isDeleted,
    );
    _peerFileCache[path] = result.content;
    _pendingPeerFiles.remove(path)?.complete(result);
  }

  @override
  Future<String?> fetchPeerFile(
    String path, {
    Duration timeout = kSyncFileRequestTimeout,
  }) async {
    if (_peerFileCache.containsKey(path)) return _peerFileCache[path];
    if (_socket == null) return null;

    final completer = Completer<_PeerFileResult>();
    _pendingPeerFiles[path] = completer;
    _send(SyncMessage.fileRequest(path));

    try {
      final result = await completer.future.timeout(timeout);
      if (result.deleted) return null;
      return result.content;
    } on TimeoutException {
      _pendingPeerFiles.remove(path);
      return null;
    }
  }

  @override
  Future<void> sendApplyComplete(
    Map<String, String> manifest, {
    Map<String, String> writes = const {},
    List<String> deletes = const [],
  }) async {
    _send(SyncMessage.applyComplete(manifest, writes: writes, deletes: deletes));
  }

  Future<void> _applyRemoteResult(SyncMessage message) async {
    for (final entry in message.readWrites().entries) {
      await writeSyncableWorkspaceFile(workspaceRoot, entry.key, entry.value);
    }
    for (final path in message.readDeletes()) {
      await deleteSyncableWorkspaceFile(workspaceRoot, path);
    }
  }

  Future<void> _persistBaseline(Map<String, String> files) async {
    final peer = _peer;
    if (peer == null) return;
    final now = DateTime.now().toUtc().toIso8601String();
    await storage.saveSyncState(
      SyncState(
        lastSyncAt: now,
        peerDisplayName: peer.displayName,
        baseline: files,
      ),
    );
  }

  void _send(SyncMessage message) => _socket?.add(message.encode());

  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    await _socketSub?.cancel();
    _socketSub = null;
    if (socket != null) await socket.close();
    for (final pending in _pendingPeerFiles.values) {
      if (!pending.isCompleted) {
        pending.completeError(StateError('Connection closed'));
      }
    }
    _pendingPeerFiles.clear();
    _status = SyncClientStatus.idle;
    onPeerDisconnected?.call();
  }

  Future<void> endSession() async {
    if (_status == SyncClientStatus.idle) return;
    _send(SyncMessage.bye());
    await disconnect();
  }

  void setPeerHasBaseline(bool value) => _peerHasBaseline = value;
}

class _PeerFileResult {
  const _PeerFileResult({required this.content, required this.deleted});

  final String? content;
  final bool deleted;
}
