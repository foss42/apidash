import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/mqtt_request_model.dart';
import '../models/mqtt_message_model.dart';
import '../consts.dart';

mqtt.MqttQos _toMqttQos(MqttQos qos) {
  return switch (qos) {
    MqttQos.atMostOnce => mqtt.MqttQos.atMostOnce,
    MqttQos.atLeastOnce => mqtt.MqttQos.atLeastOnce,
    MqttQos.exactlyOnce => mqtt.MqttQos.exactlyOnce,
  };
}

class MqttClientManager {
  MqttClientManager._();

  static final Map<String, MqttClientManager> _instances = {};

  static MqttClientManager getOrCreate(String requestId) {
    return _instances.putIfAbsent(requestId, () => MqttClientManager._());
  }

  static void remove(String requestId) {
    final manager = _instances.remove(requestId);
    manager?._dispose();
  }

  MqttServerClient? _client;
  final StreamController<MqttMessageModel> _messageController =
      StreamController<MqttMessageModel>.broadcast();
  final Set<String> _subscribedTopics = {};

  Stream<MqttMessageModel> get messageStream => _messageController.stream;
  Set<String> get subscribedTopics => Set.unmodifiable(_subscribedTopics);

  bool get isConnected =>
      _client?.connectionStatus?.state == mqtt.MqttConnectionState.connected;

  mqtt.MqttConnectionState? get connectionState =>
      _client?.connectionStatus?.state;

  mqtt.MqttConnectReturnCode? get returnCode =>
      _client?.connectionStatus?.returnCode;

  Future<mqtt.MqttClientConnectionStatus?> connect(
      MqttRequestModel config) async {
    final host = config.url.trim();
    if (host.isEmpty) {
      return null;
    }

    final clientId = config.clientId.isNotEmpty
        ? config.clientId
        : 'apidash_${DateTime.now().millisecondsSinceEpoch}';

    _client = MqttServerClient.withPort(host, clientId, config.port);
    _client!.logging(on: false);
    _client!.keepAlivePeriod = config.keepAlive;
    _client!.autoReconnect = false;
    _client!.setProtocolV311();

    final connMessage = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientId);

    if (config.cleanSession) {
      connMessage.startClean();
    }

    if (config.hasAuth) {
      connMessage.authenticateAs(config.username!, config.password!);
    }

    if (config.hasLastWill) {
      connMessage.withWillTopic(config.lastWillTopic!);
      connMessage.withWillMessage(config.lastWillMessage ?? "");
      connMessage.withWillQos(_toMqttQos(config.lastWillQos));
      if (config.lastWillRetain) {
        connMessage.withWillRetain();
      }
    }

    _client!.connectionMessage = connMessage;

    try {
      final status = await _client!.connect();
      if (status?.state == mqtt.MqttConnectionState.connected) {
        _listenToUpdates();
      }
      return status;
    } catch (e) {
      _client?.disconnect();
      rethrow;
    }
  }

  void _listenToUpdates() {
    _client?.updates?.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> messages) {
      for (final msg in messages) {
        final topic = msg.topic;
        final payload = msg.payload as mqtt.MqttPublishMessage;
        final message = mqtt.MqttPublishPayload.bytesToStringAsString(
            payload.payload.message);
        _messageController.add(MqttMessageModel(
          topic: topic,
          payload: message,
          timestamp: DateTime.now(),
          isPublished: false,
          qos: MqttQos.values.firstWhere(
            (q) => q.value == payload.header?.qos.index,
            orElse: () => MqttQos.atMostOnce,
          ),
          retained: payload.header?.retain ?? false,
        ));
      }
    });
  }

  void subscribe(String topic, MqttQos qos) {
    if (_client == null || !isConnected) return;
    _client!.subscribe(topic, _toMqttQos(qos));
    _subscribedTopics.add(topic);
  }

  void unsubscribe(String topic) {
    if (_client == null || !isConnected) return;
    _client!.unsubscribe(topic);
    _subscribedTopics.remove(topic);
  }

  void publish(String topic, String payload, MqttQos qos, bool retain) {
    if (_client == null || !isConnected) return;
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(payload);
    _client!.publishMessage(topic, _toMqttQos(qos), builder.payload!,
        retain: retain);
  }

  void disconnect() {
    _subscribedTopics.clear();
    _client?.disconnect();
    _client = null;
  }

  void _dispose() {
    disconnect();
    _messageController.close();
  }
}
