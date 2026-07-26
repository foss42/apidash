import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../consts.dart';
import '../models/sync_models.dart';
import '../storage/sync_storage.dart';
import '../sync_manifest_builder.dart';
import '../sync_session_compute.dart' as session_compute;
import '../sync_workspace_io.dart';
import 'sync_file_transfer.dart';
import 'sync_messages.dart';

enum SyncServerStatus { idle, listening, connected, error }

/// Desktop-side LAN sync host.
class SyncSessionServer implements SyncFileTransfer {
  SyncSessionServer({
    required this.storage,
    required this.workspace,
    required Map<String, String> localManifest,
    required this.workspaceRoot,
    required this.desktopName,
    int? port,
    Random? random,
    Duration? sessionTimeout,
  })  : _localManifest = localManifest,
        _preferredPort = port ?? kSyncDefaultPort,
        _sessionTimeout = sessionTimeout ?? kSyncSessionTimeout,
        token = _generateToken(random ?? Random.secure());

  final SyncStorage storage;
  final WorkspaceIdentity workspace;
  Map<String, String> _localManifest;
  final String workspaceRoot;
  final String desktopName;
  final String token;

  Map<String, String> get localManifest => _localManifest;

  final int _preferredPort;
  final Duration _sessionTimeout;

  HttpServer? _httpServer;
  WebSocket? _activeSocket;
  StreamSubscription<dynamic>? _socketSub;
  Timer? _sessionTimer;

  String? _hostAddress;
  int? _boundPort;
  SyncServerStatus _status = SyncServerStatus.idle;
  Map<String, String> _peerManifest = const {};
  SyncPeerInfo? _activePeer;
  bool _peerHasBaseline = true;
  String _phoneWorkspaceId = '';
  final Map<String, String?> _peerFileCache = {};
  final Map<String, Completer<_PeerFileResult>> _pendingPeerFiles = {};

  SyncServerStatus get status => _status;
  bool get isConnected => _activeSocket != null;
  Map<String, String> get peerManifest => _peerManifest;

  void Function(SyncPeerInfo peer, bool wasPairedBefore)? onPeerConnected;
  void Function()? onPeerDisconnected;
  void Function(SyncChangeSet changeSet)? onChangeSet;
  void Function(String message)? onError;
  void Function()? onSessionExpired;
  void Function()? onRemoteApplied;

  Future<SyncQrPayload?> start() async {
    if (_status != SyncServerStatus.idle) return qrPayload;
    final address = await resolveLanIpv4();
    if (address == null) {
      _status = SyncServerStatus.error;
      onError?.call(kErrSyncNoNetwork);
      return null;
    }
    _hostAddress = address;

    try {
      _httpServer = await _bind();
    } on SocketException catch (e) {
      _status = SyncServerStatus.error;
      onError?.call('$kErrSyncServerStart (${e.message})');
      return null;
    }

    _boundPort = _httpServer!.port;
    _status = SyncServerStatus.listening;
    _startSessionTimer();
    _httpServer!.listen(_handleRequest, onError: (Object e) {
      onError?.call('Sync server error: $e');
    });
    return qrPayload;
  }

  SyncQrPayload? get qrPayload {
    final host = _hostAddress;
    final port = _boundPort;
    if (host == null || port == null) return null;
    return SyncQrPayload(
      host: host,
      port: port,
      token: token,
      workspaceId: workspace.id,
      workspaceName: workspace.name,
      desktopName: desktopName,
    );
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(_sessionTimeout, () {
      onSessionExpired?.call();
      unawaited(stop());
    });
  }

  Future<HttpServer> _bind() async {
    try {
      return await HttpServer.bind(InternetAddress.anyIPv4, _preferredPort);
    } on SocketException {
      return HttpServer.bind(InternetAddress.anyIPv4, 0);
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    if (request.uri.path != kSyncWebSocketPath ||
        !WebSocketTransformer.isUpgradeRequest(request)) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }
    if (_activeSocket != null) {
      request.response.statusCode = HttpStatus.conflict;
      await request.response.close();
      return;
    }
    _attachSocket(await WebSocketTransformer.upgrade(request));
  }

  void _attachSocket(WebSocket socket) {
    _activeSocket = socket;
    _socketSub = socket.listen(
      (dynamic data) async {
        if (data is! String) return;
        final message = SyncMessage.tryDecode(data);
        if (message == null) return;

        switch (message.type) {
          case SyncMessageType.hello:
            if (message.stringToken != token) {
              _send(SyncMessage.error('Invalid or expired token'));
              await _closeSocket(notify: false);
              return;
            }
            _peerHasBaseline = message.hasBaseline;
            _phoneWorkspaceId = message.stringWorkspaceId ?? '';
            _activePeer = SyncPeerInfo(
              workspaceId: _phoneWorkspaceId.isNotEmpty
                  ? _phoneWorkspaceId
                  : workspace.id,
              workspaceName: workspace.name,
              displayName: message.stringDisplayName ?? 'Phone',
            );
            final syncState = await storage.readSyncState();
            final localHadBaseline = syncState?.hasBaseline ?? false;
            final wasPaired = session_compute.peersPairedBefore(
              localHadBaseline: localHadBaseline,
              peerHadBaseline: message.hasBaseline,
            );
            _send(SyncMessage.helloAck(
              workspaceId: workspace.id,
              workspaceName: workspace.name,
              displayName: desktopName,
              hasBaseline: localHadBaseline,
            ));
            _send(SyncMessage.manifest(_localManifest));
            onPeerConnected?.call(_activePeer!, wasPaired);
            _status = SyncServerStatus.connected;
            break;
          case SyncMessageType.manifest:
            _peerManifest = message.readManifest();
            await _emitChangeSet();
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
          case SyncMessageType.bye:
            await _closeSocket();
            break;
          case SyncMessageType.error:
            onError?.call(message.errorMessage ?? 'Phone reported an error');
            break;
          case SyncMessageType.helloAck:
            break;
        }
      },
      onDone: () => _closeSocket(),
      onError: (Object e) {
        onError?.call('Connection error: $e');
        _closeSocket();
      },
      cancelOnError: true,
    );
  }

  Future<void> refreshManifest() async {
    _localManifest = await buildSyncManifest(workspaceRoot);
    await _emitChangeSet();
  }

  Future<void> _emitChangeSet() async {
    final state = await storage.readSyncState();
    final baseline = state?.baseline ?? const <String, String>{};
    final changeSet = session_compute.computeSessionChangeSet(
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
    _peerFileCache[path] = message.isDeleted ? null : message.stringContent;
    _pendingPeerFiles.remove(path)?.complete(
          _PeerFileResult(
            content: message.isDeleted ? null : message.stringContent,
            deleted: message.isDeleted,
          ),
        );
  }

  @override
  Future<String?> fetchPeerFile(
    String path, {
    Duration timeout = kSyncFileRequestTimeout,
  }) async {
    if (_peerFileCache.containsKey(path)) return _peerFileCache[path];
    if (_activeSocket == null) return null;

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
    final peer = _activePeer;
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

  void _send(SyncMessage message) => _activeSocket?.add(message.encode());

  Future<void> _closeSocket({bool notify = true}) async {
    final socket = _activeSocket;
    _activeSocket = null;
    _activePeer = null;
    await _socketSub?.cancel();
    _socketSub = null;
    if (socket != null) await socket.close();
    for (final pending in _pendingPeerFiles.values) {
      if (!pending.isCompleted) {
        pending.completeError(StateError('Connection closed'));
      }
    }
    _pendingPeerFiles.clear();
    if (_status == SyncServerStatus.connected) {
      _status = SyncServerStatus.listening;
    }
    if (notify) onPeerDisconnected?.call();
  }

  Future<void> stop() async {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    if (_activeSocket != null) {
      _send(SyncMessage.bye());
    }
    await _closeSocket(notify: false);
    await _httpServer?.close(force: true);
    _httpServer = null;
    _status = SyncServerStatus.idle;
  }
}

class _PeerFileResult {
  const _PeerFileResult({required this.content, required this.deleted});

  final String? content;
  final bool deleted;
}

String _generateToken(Random random) {
  return List.generate(
    kSyncTokenLength,
    (_) => kSyncTokenAlphabet[random.nextInt(kSyncTokenAlphabet.length)],
  ).join();
}

Future<String?> resolveLanIpv4() async {
  try {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
      includeLinkLocal: false,
    );
    String? fallback;
    for (final interface in interfaces) {
      for (final addr in interface.addresses) {
        final ip = addr.address;
        if (addr.isLoopback || ip.startsWith('169.254.')) continue;
        if (_isPrivateIpv4(ip)) return ip;
        fallback ??= ip;
      }
    }
    return fallback;
  } on SocketException {
    return null;
  }
}

bool _isPrivateIpv4(String ip) {
  if (ip.startsWith('10.') || ip.startsWith('192.168.')) return true;
  if (ip.startsWith('172.')) {
    final second = int.tryParse(ip.split('.').elementAt(1)) ?? 0;
    return second >= 16 && second <= 31;
  }
  return false;
}
