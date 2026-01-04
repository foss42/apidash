import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final Map<String, WebSocketChannel> _activeConnections = {};

  Future<Stream<dynamic>> connect(
    String requestId,
    String url, {
    Map<String, String>? headers,
  }) async {
    await disconnect(requestId);

    try {
      final uri = Uri.parse(url);
      final channel = WebSocketChannel.connect(uri, protocols: headers?.keys);
      _activeConnections[requestId] = channel;
      return channel.stream;
    } catch (e) {
      throw Exception('Could not connect to WebSocket: $e');
    }
  }

  void send(String requestId, String message) {
    final channel = _activeConnections[requestId];
    if (channel != null) {
      channel.sink.add(message);
    } else {
      throw Exception('No active connection for requestId: $requestId');
    }
  }

  Future<void> disconnect(String requestId) async {
    final channel = _activeConnections[requestId];
    if (channel != null) {
      await channel.sink.close(status.normalClosure);
      _activeConnections.remove(requestId);
    }
  }

  void dispose() {
    for (var channel in _activeConnections.values) {
      channel.sink.close(status.goingAway);
    }
    _activeConnections.clear();
  }
}

final webSocketService = WebSocketService();
