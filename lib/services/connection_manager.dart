// lib/services/connection_manager.dart

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:grpc/grpc.dart';
import 'package:apidash/models/protocols/websocket_model.dart';
import 'package:apidash/models/protocols/mqtt_model.dart';
import 'package:apidash/models/protocols/grpc_model.dart';

/// A singleton service that holds active connections.
/// It allows the UI or CLI to retrieve an existing connection or create a new one.
class ConnectionManager {
  ConnectionManager._privateConstructor();
  static final ConnectionManager _instance = ConnectionManager._privateConstructor();
  static ConnectionManager get instance => _instance;

  // Maps request id to active connections.
  final Map<String, WebSocketChannel> _webSocketChannels = {};
  final Map<String, MqttServerClient> _mqttClients = {};
  final Map<String, ClientChannel> _grpcChannels = {};

  //  WebSocket 
  WebSocketChannel getWebSocketChannel(String requestId) => _webSocketChannels[requestId]!;

  Future<WebSocketChannel> connectWebSocket(String requestId, WebSocketRequestModel model) async {
    final uri = Uri.parse(model.url);
    final channel = IOWebSocketChannel.connect(uri, headers: model.customHeaders);
    _webSocketChannels[requestId] = channel;
    return channel;
  }

  void disconnectWebSocket(String requestId) {
    final channel = _webSocketChannels.remove(requestId);
    channel?.sink.close();
  }

  // MQTT 
  MqttServerClient getMqttClient(String requestId) => _mqttClients[requestId]!;

  Future<MqttServerClient> connectMqtt(String requestId, MQTTRequestModel model) async {
    String host = model.brokerUrl;
    if (host.contains("://")) {
      try {
        final uri = Uri.parse(host);
        host = uri.host;
      } catch (e) {
        debugPrint("Error parsing MQTT URL: $e");
      }
    }
    
    debugPrint("Connecting to MQTT broker: $host:${model.port} (TLS: ${model.useTLS})");
    
    final client = MqttServerClient(host, model.clientId ?? 'apidash_$requestId');
    client.port = model.port;
    client.useWebSocket = model.useWebSocket;
    client.logging(on: true); // Temporarily enable logging to debug
    client.keepAlivePeriod = 20;
    client.secure = model.useTLS;
    
    // Set protocol version
    if (model.version == MQTTVersion.v3) {
      client.setProtocolV31();
    } else if (model.version == MQTTVersion.v3_1_1) {
      client.setProtocolV311();
    }
    // MqttServerClient by default supports v3.1.1 or v5 depending on version. 
    // For V5, usually we use MqttServerClient.withPort if needed or it defaults if supported.

    if (model.username != null && model.username!.isNotEmpty) {
      client.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(client.clientIdentifier)
          .authenticateAs(model.username!, model.password ?? '');
    }
    
    final status = await client.connect();
    if (status?.state != MqttConnectionState.connected) {
       throw Exception("Connection failed: ${status?.state}");
    }
    
    _mqttClients[requestId] = client;
    return client;
  }

  void subscribeMqtt(String requestId, String topic, int qos) {
    final client = _mqttClients[requestId];
    if (client != null && client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.values[qos]);
    }
  }

  void unsubscribeMqtt(String requestId, String topic) {
    final client = _mqttClients[requestId];
    if (client != null && client.connectionStatus?.state == MqttConnectionState.connected) {
      client.unsubscribe(topic);
    }
  }

  void publishMqtt(String requestId, String topic, String message, int qos) {
    final client = _mqttClients[requestId];
    if (client != null && client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.values[qos], builder.payload!);
    }
  }

  void disconnectMqtt(String requestId) {
    final client = _mqttClients.remove(requestId);
    client?.disconnect();
  }

  // gRPC 
  ClientChannel getGrpcChannel(String requestId) => _grpcChannels[requestId]!;

  Future<ClientChannel> connectGrpc(String requestId, GrpcRequestModel model) async {
    String host = model.host.trim();
    int port = model.port;

    if (host.contains(':')) {
      final parts = host.split(':');
      host = parts[0].trim();
      final p = int.tryParse(parts[1].trim());
      if (p != null) port = p;
    }

    print("gRPC Connecting to: $host:$port");
    final channel = ClientChannel(
      host,
      port: port,
      options: ChannelOptions(
        credentials: model.useTLS
            ? const ChannelCredentials.secure()
            : const ChannelCredentials.insecure(),
      ),
    );
    _grpcChannels[requestId] = channel;
    print("gRPC Channel established for $requestId");
    return channel;
  }

  void disconnectGrpc(String requestId) {
    final channel = _grpcChannels.remove(requestId);
    channel?.terminate();
  }

  Stream<List<int>> callGrpcMethod(
    String requestId,
    String service,
    String method,
    List<int> requestBytes, {
    Map<String, String>? metadata,
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

    final call = channel.createCall(
      clientMethod,
      Stream.fromIterable([requestBytes]),
      CallOptions(metadata: metadata),
    );

    return call.response;
  }
}
