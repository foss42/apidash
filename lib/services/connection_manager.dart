// lib/services/connection_manager.dart

import 'dart:io';

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

  /// Maps request ID → the underlying `dart:io` socket. Kept separately so the
  /// heartbeat ping interval can be changed on a live connection (the channel
  /// does not expose the inner socket).
  final Map<String, WebSocket> _sockets = {};

  /// Whether there is an active connection for [requestId].
  bool hasConnection(String requestId) => _channels.containsKey(requestId);

  /// Returns the active channel for [requestId], or `null` if none exists.
  WebSocketChannel? getChannel(String requestId) => _channels[requestId];

  /// Opens a new WebSocket connection to [url] with optional [headers].
  ///
  /// The channel is stored under [requestId] so it can be reused for
  /// subsequent sends or torn down later. [pingInterval] sets the initial
  /// heartbeat; it can be changed later via [updatePingInterval].
  Future<WebSocketChannel> connect(
    String requestId,
    String url, {
    Map<String, String>? headers,
    Duration? pingInterval,
  }) async {
    // Tear down any pre-existing connection for the same tab.
    disconnect(requestId);

    debugPrint('WS: connecting to $url');
    // Connect via the dart:io WebSocket directly (rather than
    // IOWebSocketChannel.connect) so we keep a reference to the underlying
    // socket. WebSocket.pingInterval is mutable at runtime, which lets us
    // change the heartbeat on a live connection (see [updatePingInterval]).
    final webSocket = await WebSocket.connect(url, headers: headers);
    webSocket.pingInterval = pingInterval;
    final channel = IOWebSocketChannel(webSocket);
    _channels[requestId] = channel;
    _sockets[requestId] = webSocket;
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

  /// Changes the heartbeat ping interval on a LIVE connection.
  ///
  /// `dart:io`'s [WebSocket.pingInterval] is mutable, so changing the interval
  /// (or enabling/disabling heartbeats) takes effect immediately without
  /// reconnecting. Pass `null` to disable heartbeats. No-op if there is no
  /// active socket for [requestId].
  void updatePingInterval(String requestId, Duration? pingInterval) {
    final webSocket = _sockets[requestId];
    if (webSocket != null) {
      webSocket.pingInterval = pingInterval;
      debugPrint('WS: updated pingInterval for $requestId -> $pingInterval');
    }
  }

  /// Closes the WebSocket connection for [requestId].
  void disconnect(String requestId) {
    final channel = _channels.remove(requestId);
    _sockets.remove(requestId);
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
    _sockets.clear();
  }
}
