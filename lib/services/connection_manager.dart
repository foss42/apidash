// lib/services/connection_manager.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:grpc/grpc.dart';
import 'package:apidash/models/grpc_request_model.dart';

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

  final Map<String, ClientChannel> _grpcChannels = {};

  /// Maps request ID → the open request StreamController that feeds the gRPC
  /// call. For unary/server-streaming this is closed immediately after the
  /// single request message is added (half-close). For client/bidi streaming
  /// it is kept open so the user can push more messages while the call is live.
  final Map<String, StreamController<List<int>>> _grpcRequestControllers = {};

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
    for (final entry in _grpcRequestControllers.entries) {
      if (!entry.value.isClosed) entry.value.close();
    }
    _grpcRequestControllers.clear();
    for (final entry in _grpcChannels.entries) {
      entry.value.terminate();
    }
    _grpcChannels.clear();
  }

  // gRPC 
  ClientChannel getGrpcChannel(String requestId) => _grpcChannels[requestId]!;

  Future<ClientChannel> connectGrpc(String requestId, GrpcRequestModel model) async {
    String host = model.url.trim();
    int port = 50051;

    if (host.contains(':')) {
      final parts = host.split(':');
      host = parts[0].trim();
      final p = int.tryParse(parts[1].trim());
      if (p != null) port = p;
    }

    debugPrint("gRPC Connecting to: $host:$port");
    final channel = ClientChannel(
      host,
      port: port,
      options: ChannelOptions(
        credentials: model.useTLS
            ? (model.allowInvalidCertificates
                ? ChannelCredentials.secure(onBadCertificate: (cert, host) => true)
                : const ChannelCredentials.secure())
            : const ChannelCredentials.insecure(),
      ),
    );
    _grpcChannels[requestId] = channel;
    debugPrint("gRPC Channel established for $requestId");
    return channel;
  }

  void disconnectGrpc(String requestId) {
    _closeGrpcRequestController(requestId);
    final channel = _grpcChannels.remove(requestId);
    channel?.terminate();
  }

  /// Whether there is an OPEN request stream for [requestId] onto which more
  /// gRPC request messages can be pushed (only true for client/bidi streaming
  /// while the call is live and has not yet been half-closed).
  bool hasGrpcRequestStream(String requestId) {
    final controller = _grpcRequestControllers[requestId];
    return controller != null && !controller.isClosed;
  }

  ClientCall<List<int>, List<int>> callGrpcMethod(
    String requestId,
    String service,
    String method,
    List<int> requestBytes, {
    Map<String, String>? metadata,
    GrpcStreamingType streamingType = GrpcStreamingType.unary,
  }) {
    final channel = _grpcChannels[requestId];
    if (channel == null) {
      throw Exception("No active gRPC channel for $requestId");
    }

    // Path is usually /{service}/{method}
    final path = "/$service/$method";

    final clientMethod = ClientMethod<List<int>, List<int>>(
      path,
      (List<int> value) => value,
      (List<int> value) => value,
    );

    // Tear down any leftover request controller from a previous call on the
    // same tab, then build a fresh one. Streaming in the `grpc` package is
    // emergent from this request stream: every message it emits is sent, and
    // the client half-closes when the stream is done.
    _closeGrpcRequestController(requestId);
    final controller = StreamController<List<int>>();
    _grpcRequestControllers[requestId] = controller;

    // The first message is always sent.
    controller.add(requestBytes);

    // unary + server-streaming send exactly one message then half-close.
    // client + bidi keep the request stream open for [pushGrpcMessage].
    final singleShot = streamingType == GrpcStreamingType.unary ||
        streamingType == GrpcStreamingType.server;
    if (singleShot) {
      controller.close();
      _grpcRequestControllers.remove(requestId);
    }

    final call = channel.createCall(
      clientMethod,
      controller.stream,
      CallOptions(metadata: metadata),
    );

    return call;
  }

  /// Pushes an additional request [bytes] message onto the open request stream
  /// for [requestId] (client/bidi streaming). No-op if there is no open stream.
  void pushGrpcMessage(String requestId, List<int> bytes) {
    final controller = _grpcRequestControllers[requestId];
    if (controller == null || controller.isClosed) {
      debugPrint('gRPC: no open request stream for $requestId');
      return;
    }
    controller.add(bytes);
  }

  /// Half-closes the request stream for [requestId] (client/bidi "finish
  /// sending"): the server sees end-of-input and can complete its response.
  void finishGrpcSending(String requestId) {
    _closeGrpcRequestController(requestId);
  }

  void _closeGrpcRequestController(String requestId) {
    final controller = _grpcRequestControllers.remove(requestId);
    if (controller != null && !controller.isClosed) {
      controller.close();
    }
  }
}
