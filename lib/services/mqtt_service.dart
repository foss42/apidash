import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/mqtt_request_model.dart';

enum MQTTEventType { connect, disconnect, subscribe, unsubscribe, send, receive, error }

class MQTTEvent {
  final DateTime timestamp;
  final MQTTEventType type;
  final String? topic;
  final String? payload;
  final String? description;

  MQTTEvent({
    required this.timestamp,
    required this.type,
    this.topic,
    this.payload,
    this.description,
  });
}

class MQTTConnectionState {
  final bool isConnected;
  final String? error;
  final List<MQTTMessage> messages;
  final List<MQTTEvent> eventLog;

  const MQTTConnectionState({
    this.isConnected = false,
    this.error,
    this.messages = const [],
    this.eventLog = const [],
  });

  MQTTConnectionState copyWith({
    bool? isConnected,
    String? error,
    List<MQTTMessage>? messages,
    List<MQTTEvent>? eventLog,
  }) {
    return MQTTConnectionState(
      isConnected: isConnected ?? this.isConnected,
      error: error ?? this.error,
      messages: messages ?? this.messages,
      eventLog: eventLog ?? this.eventLog,
    );
  }
}

class MQTTMessage {
  final String topic;
  final String payload;
  final DateTime timestamp;
  final bool isIncoming;

  const MQTTMessage({
    required this.topic,
    required this.payload,
    required this.timestamp,
    required this.isIncoming,
  });
}

class MQTTService {
  MqttClient? _client;
  MQTTConnectionState _state = const MQTTConnectionState();
  final StreamController<MQTTConnectionState> _stateController = 
      StreamController<MQTTConnectionState>.broadcast();
  final List<MQTTMessage> _messages = [];
  final List<MQTTEvent> _eventLog = [];

  bool get isConnected => _client != null && _client!.connectionStatus?.state == MqttConnectionState.connected;

  Stream<MQTTConnectionState> get stateStream => _stateController.stream;
  MQTTConnectionState get currentState => _state;

  void _addEvent(MQTTEvent event) {
    _eventLog.add(event);
    // Keep only last 200 events
    if (_eventLog.length > 200) {
      _eventLog.removeAt(0);
    }
    _updateState(_state.copyWith(eventLog: List.from(_eventLog)));
  }

  Future<bool> connect(MQTTRequestModel request) async {
    print('[MQTT] Attempting to connect:');
    print('  Broker URL: ${request.brokerUrl}');
    print('  Port: ${request.port}');
    print('  Client ID: ${request.clientId}');
    print('  Username: ${request.username}');
    print('  Password: ${request.password.isNotEmpty ? "***" : "(empty)"}');
    print('  Topics to subscribe: ${request.topics.map((t) => '${t.topic} (qos: ${t.qos}, sub: ${t.subscribe})').toList()}');
    _eventLog.clear(); // Clear log for new session
    try {
      // Parse broker URL, add scheme if missing
      String brokerUrl = request.brokerUrl.trim();
      if (!brokerUrl.contains('://')) {
        brokerUrl = 'mqtt://$brokerUrl';
      }
      final uri = Uri.parse(brokerUrl);
      final isWebSocket = uri.scheme == 'ws' || uri.scheme == 'wss';
      
      // Create client based on platform and protocol
      if (isWebSocket) {
        _client = MqttServerClient(uri.toString(), 'apidash_${DateTime.now().millisecondsSinceEpoch}');
      } else {
        _client = MqttServerClient(uri.host, 'apidash_${DateTime.now().millisecondsSinceEpoch}');
        _client!.port = request.port == 0 ? 1883 : request.port;
      }

      // Configure client
      _client!.keepAlivePeriod = request.keepAlive;
      _client!.connectTimeoutPeriod = request.connectTimeout * 1000;
      _client!.onDisconnected = _onDisconnected;
      _client!.onConnected = _onConnected;
      _client!.onSubscribed = _onSubscribed;

      // Set up connection message
      _client!.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(request.clientId.isNotEmpty ? request.clientId : 'apidash_client_${DateTime.now().millisecondsSinceEpoch}')
          .withWillTopic('apidash/disconnect')
          .withWillMessage('Client disconnected')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      // Connect
      print('[MQTT] Connecting...');
      await _client!.connect();
      
      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('[MQTT] Connected successfully!');
        _updateState(_state.copyWith(isConnected: true, error: null));
        
        // Subscribe to topics
        for (final topic in request.topics.where((t) => t.subscribe)) {
          await subscribe(topic.topic, topic.qos);
        }
        
        // Set up message listener
        _client!.updates!.listen(_onMessageReceived);
        
        return true;
      } else {
        final error = 'Failed to connect: ${_client!.connectionStatus}';
        print('[MQTT] $error');
        _addEvent(MQTTEvent(
          timestamp: DateTime.now(),
          type: MQTTEventType.error,
          description: error,
        ));
        _updateState(_state.copyWith(isConnected: false, error: error));
        return false;
      }
    } catch (e) {
      final error = 'Connection error: $e';
      print('[MQTT] $error');
      _addEvent(MQTTEvent(
        timestamp: DateTime.now(),
        type: MQTTEventType.error,
        description: error,
      ));
      _updateState(_state.copyWith(isConnected: false, error: error));
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_client != null && _client!.connectionStatus!.state == MqttConnectionState.connected) {
      _client!.disconnect();
    }
    _client = null;
    _updateState(const MQTTConnectionState());
  }

  Future<bool> subscribe(String topic, int qos) async {
    if (_client == null || _client!.connectionStatus!.state != MqttConnectionState.connected) {
      return false;
    }

    try {
      _client!.subscribe(topic, MqttQos.values[qos]);
      return true;
    } catch (e) {
      _addEvent(MQTTEvent(
        timestamp: DateTime.now(),
        type: MQTTEventType.error,
        topic: topic,
        description: 'Subscribe error: $e',
      ));
      _updateState(_state.copyWith(error: 'Subscribe error: $e'));
      return false;
    }
  }

  Future<bool> unsubscribe(String topic) async {
    if (_client == null || _client!.connectionStatus!.state != MqttConnectionState.connected) {
      return false;
    }

    try {
      _client!.unsubscribe(topic);
      _addEvent(MQTTEvent(
        timestamp: DateTime.now(),
        type: MQTTEventType.unsubscribe,
        topic: topic,
        description: "Unsubscribed from topic $topic",
      ));
      return true;
    } catch (e) {
      _addEvent(MQTTEvent(
        timestamp: DateTime.now(),
        type: MQTTEventType.error,
        topic: topic,
        description: 'Unsubscribe error: $e',
      ));
      _updateState(_state.copyWith(error: 'Unsubscribe error: $e'));
      return false;
    }
  }

  Future<bool> publish(String topic, String payload, {int qos = 0, bool retain = false}) async {
    if (_client == null || _client!.connectionStatus!.state != MqttConnectionState.connected) {
      return false;
    }

    try {
      final message = MqttClientPayloadBuilder();
      message.addString(payload);
      _client!.publishMessage(topic, MqttQos.values[qos], message.payload!, retain: retain);
      
      // Add outgoing message to history
      final outgoingMessage = MQTTMessage(
        topic: topic,
        payload: payload,
        timestamp: DateTime.now(),
        isIncoming: false,
      );
      _addMessage(outgoingMessage);
      _addEvent(MQTTEvent(
        timestamp: DateTime.now(),
        type: MQTTEventType.send,
        topic: topic,
        payload: payload,
        description: "Message sent to $topic",
      ));
      
      return true;
    } catch (e) {
      _addEvent(MQTTEvent(
        timestamp: DateTime.now(),
        type: MQTTEventType.error,
        topic: topic,
        description: 'Publish error: $e',
      ));
      _updateState(_state.copyWith(error: 'Publish error: $e'));
      return false;
    }
  }

  void _onConnected() {
    _addEvent(MQTTEvent(
      timestamp: DateTime.now(),
      type: MQTTEventType.connect,
      description: "Connected to broker",
    ));
    _updateState(_state.copyWith(isConnected: true, error: null));
  }

  void _onDisconnected() {
    _addEvent(MQTTEvent(
      timestamp: DateTime.now(),
      type: MQTTEventType.disconnect,
      description: "Disconnected from broker",
    ));
    _updateState(_state.copyWith(isConnected: false));
  }

  void _onSubscribed(String topic) {
    _addEvent(MQTTEvent(
      timestamp: DateTime.now(),
      type: MQTTEventType.subscribe,
      topic: topic,
      description: "Subscribed to topic $topic",
    ));
    // Topic subscription successful
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final message in messages) {
      String payload = '';
      try {
        final mqttMsg = message.payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(mqttMsg.payload.message);
        payload = pt;
      } catch (e) {
        payload = message.payload.toString();
      }
      print('[MQTT] Received message on topic: ${message.topic}, payload: $payload');
      final incomingMessage = MQTTMessage(
        topic: message.topic,
        payload: payload,
        timestamp: DateTime.now(),
        isIncoming: true,
      );
      _addMessage(incomingMessage);
      _addEvent(MQTTEvent(
        timestamp: DateTime.now(),
        type: MQTTEventType.receive,
        topic: message.topic,
        payload: payload,
        description: "Message received from ${message.topic}",
      ));
    }
  }

  void _addMessage(MQTTMessage message) {
    _messages.add(message);
 
    _updateState(_state.copyWith(messages: List.from(_messages)));
  }

  void _updateState(MQTTConnectionState newState) {
    
    _state = newState.copyWith(eventLog: List.from(_eventLog));
    _stateController.add(_state);
  }

  void dispose() {
    disconnect();
    _stateController.close();
  }
} 