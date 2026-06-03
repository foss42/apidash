// lib/services/connection_manager.dart

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

/// TODO: it should also be usable for other Protocols
/// A singleton service that holds active WebSocket connections.
///
/// Each connection is keyed by the request-tab ID so that the UI and provider
/// layer can retrieve an existing channel or tear it down when the tab is
/// closed / the user disconnects.
///
class ConnectionManager {
  ConnectionManager._();
  static final ConnectionManager instance = ConnectionManager._();

  /// Maps request ID → active WebSocket channel.
  final Map<String, WebSocketChannel> _channels = {};

  /// Whether there is an active connection for [requestId].
  bool hasConnection(String requestId) => _channels.containsKey(requestId);

  /// Returns the active channel for [requestId], or `null` if none exists.
  WebSocketChannel? getChannel(String requestId) => _channels[requestId];

  /// Opens a new WebSocket connection to [url] with optional [headers].
  ///
  /// The channel is stored under [requestId] so it can be reused for
  /// subsequent sends or torn down later.
  Future<WebSocketChannel> connect(
    String requestId,
    String url, {
    Map<String, String>? headers,
    Duration? pingInterval,
  }) async {
    // Tear down any pre-existing connection for the same tab.
    disconnect(requestId);

    final uri = Uri.parse(url);
    debugPrint('WS: connecting to $uri');
    final channel = IOWebSocketChannel.connect(
      uri,
      headers: headers,
      pingInterval: pingInterval,
    );
    _channels[requestId] = channel;
    return channel;
  }

  /// Sends a text [message] through the channel identified by [requestId].
  void send(String requestId, String message) {
    final channel = _channels[requestId];
    if (channel == null) {
      debugPrint('WS: no active channel for $requestId');
      return;
    }
    channel.sink.add(message);
  }

  /// Closes the WebSocket connection for [requestId].
  void disconnect(String requestId) {
    final channel = _channels.remove(requestId);
    if (channel != null) {
      debugPrint('WS: disconnecting $requestId');
      channel.sink.close();
    }
  }

  /// Tears down every active connection (used on app shutdown / data clear).
  void disconnectAll() {
    for (final entry in _channels.entries) {
      entry.value.sink.close();
    }
    _channels.clear();
  }
}
