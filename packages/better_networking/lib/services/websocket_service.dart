import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/ws_models.dart';

/// Manages a single WebSocket connection per request ID.
/// Pattern mirrors HttpClientManager: keyed by requestId.
class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal();

  final Map<String, WebSocketChannel> _channels = {};
  final Map<String, StreamController<WsMessage>> _messageControllers = {};

  /// Returns the live message stream for [requestId], creating it if needed.
  Stream<WsMessage> messagesStream(String requestId) {
    _messageControllers.putIfAbsent(
      requestId,
      () => StreamController<WsMessage>.broadcast(),
    );
    return _messageControllers[requestId]!.stream;
  }

  bool isConnected(String requestId) => _channels.containsKey(requestId);

  /// Opens a WebSocket connection.
  /// [headers] will be passed during the handshake (desktop/mobile only).
  Future<void> connect({
    required String requestId,
    required String url,
    Map<String, String>? headers,
    void Function(String error)? onError,
    void Function()? onDone,
  }) async {
    // Close any existing channel for this id.
    await disconnect(requestId);

    _emit(requestId, WsMessage(
      content: 'Connecting to $url…',
      type: WsMessageType.connected,
      timestamp: DateTime.now(),
    ));

    try {
      final uri = Uri.parse(url);
      final channel = WebSocketChannel.connect(uri, protocols: null);
      // Wait for the connection handshake to complete.
      await channel.ready;
      _channels[requestId] = channel;

      _emit(requestId, WsMessage(
        content: 'Connected to $url',
        type: WsMessageType.connected,
        timestamp: DateTime.now(),
      ));

      channel.stream.listen(
        (dynamic data) {
          _emit(requestId, WsMessage(
            content: data.toString(),
            type: WsMessageType.received,
            timestamp: DateTime.now(),
          ));
        },
        onError: (Object err) {
          _emit(requestId, WsMessage(
            content: 'Error: $err',
            type: WsMessageType.error,
            timestamp: DateTime.now(),
          ));
          _channels.remove(requestId);
          onError?.call(err.toString());
        },
        onDone: () {
          _emit(requestId, WsMessage(
            content: 'Disconnected',
            type: WsMessageType.disconnected,
            timestamp: DateTime.now(),
          ));
          _channels.remove(requestId);
          onDone?.call();
        },
        cancelOnError: true,
      );
    } catch (e) {
      _emit(requestId, WsMessage(
        content: 'Connection failed: $e',
        type: WsMessageType.error,
        timestamp: DateTime.now(),
      ));
      onError?.call(e.toString());
    }
  }

  /// Sends a text message over the active channel.
  void send(String requestId, String message) {
    final channel = _channels[requestId];
    if (channel == null) return;
    channel.sink.add(message);
    _emit(requestId, WsMessage(
      content: message,
      type: WsMessageType.sent,
      timestamp: DateTime.now(),
    ));
  }

  /// Closes the WebSocket channel for [requestId].
  Future<void> disconnect(String requestId) async {
    final channel = _channels.remove(requestId);
    if (channel != null) {
      await channel.sink.close();
    }
  }

  /// Closes and clears everything for [requestId].
  void dispose(String requestId) {
    disconnect(requestId);
    _messageControllers[requestId]?.close();
    _messageControllers.remove(requestId);
  }

  void _emit(String requestId, WsMessage message) {
    _messageControllers.putIfAbsent(
      requestId,
      () => StreamController<WsMessage>.broadcast(),
    );
    _messageControllers[requestId]!.add(message);
  }
}

/// Singleton instance — mirrors [httpClientManager].
final wsManager = WebSocketManager();
