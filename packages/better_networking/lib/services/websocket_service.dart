import 'dart:async';
import 'package:better_networking/utils/uuid_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'websockets/websocket_handler.dart';
import '../models/models.dart';

class WebSocketService {
  WebSocketChannel? _wsChannel;
  StreamSubscription? _wsSubscription;

  bool get isConnected => _wsChannel != null;

  Future<WebSocketConnectionResult> connect({
    required Uri uri,
    required Map<String, String> headers,
    String? initialMessage,
  }) async {
    try {
      _wsChannel = await connectToWebSocket(uri, headers);

      final connectMessage = WebSocketMessageModel(
        id: getNewUuid(),
        type: WebSocketMessageType.connect,
        message: 'WebSocket connected',
        timestamp: DateTime.now(),
      );

      final messages = <WebSocketMessageModel>[connectMessage];

      if (initialMessage?.isNotEmpty == true) {
        _wsChannel!.sink.add(initialMessage);

        messages.add(WebSocketMessageModel(
          id: getNewUuid(),
          type: WebSocketMessageType.sent,
          payload: initialMessage,
          timestamp: DateTime.now(),
          sizeBytes: initialMessage!.length,
        ));
      }

      return WebSocketConnectionResult.success(
        channel: _wsChannel!,
        initialMessages: messages,
        connectedAt: DateTime.now(),
      );
    } catch (e) {
      return WebSocketConnectionResult.failure(
        error: 'Connection failed: $e',
      );
    }
  }

  StreamSubscription<dynamic> listen({
    required Function(WebSocketMessageModel) onMessage,
    required Function(WebSocketMessageModel) onError,
    required Function(WebSocketMessageModel) onDone,
  }) {
    if (_wsChannel == null) {
      throw StateError('WebSocket channel is not initialized');
    }

    _wsSubscription = _wsChannel!.stream.listen(
      (data) {
        final msg = WebSocketMessageModel(
          id: getNewUuid(),
          type: WebSocketMessageType.received,
          payload: data.toString(),
          timestamp: DateTime.now(),
          sizeBytes: data.toString().length,
        );

        onMessage(msg);
      },
      onError: (error) {
        final errorMsg = WebSocketMessageModel(
          id: getNewUuid(),
          type: WebSocketMessageType.error,
          message: error.toString(),
          timestamp: DateTime.now(),
        );

        onError(errorMsg);
      },
      onDone: () {
        final disconnectMsg = WebSocketMessageModel(
          id: getNewUuid(),
          type: WebSocketMessageType.disconnect,
          message: 'WebSocket disconnected (server closed)',
          timestamp: DateTime.now(),
        );

        onDone(disconnectMsg);
      },
    );

    return _wsSubscription!;
  }

  bool sendMessage(String message) {
    if (_wsChannel == null) {
      return false;
    }

    if (message.trim().isEmpty) {
      return false;
    }

    try {
      _wsChannel!.sink.add(message);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<WebSocketMessageModel> disconnect() async {
    try {
      await _wsSubscription?.cancel();
      _wsSubscription = null;

      await _wsChannel?.sink.close();
      _wsChannel = null;

      return WebSocketMessageModel(
        id: getNewUuid(),
        type: WebSocketMessageType.disconnect,
        message: 'WebSocket disconnected',
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return WebSocketMessageModel(
        id: getNewUuid(),
        type: WebSocketMessageType.error,
        message: 'Disconnect error: $e',
        timestamp: DateTime.now(),
      );
    }
  }

  void cleanup() {
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _wsChannel?.sink.close();
    _wsChannel = null;
  }
}

class WebSocketConnectionResult {
  final bool success;
  final WebSocketChannel? channel;
  final List<WebSocketMessageModel>? initialMessages;
  final DateTime? connectedAt;
  final String? error;

  WebSocketConnectionResult._({
    required this.success,
    this.channel,
    this.initialMessages,
    this.connectedAt,
    this.error,
  });

  factory WebSocketConnectionResult.success({
    required WebSocketChannel channel,
    required List<WebSocketMessageModel> initialMessages,
    required DateTime connectedAt,
  }) {
    return WebSocketConnectionResult._(
      success: true,
      channel: channel,
      initialMessages: initialMessages,
      connectedAt: connectedAt,
    );
  }

  factory WebSocketConnectionResult.failure({
    required String error,
  }) {
    return WebSocketConnectionResult._(
      success: false,
      error: error,
    );
  }
}
