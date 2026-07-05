// lib/services/connection_manager.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'package:apidash/models/mqtt_request_model.dart' show MQTTVersion;
import 'package:apidash_core/apidash_core.dart' show NameValueModel;

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// MQTT v5 lives in a separate package. Both packages export a class named
// `MqttServerClient` (and `MqttQos`, `MqttConnectionState`, …), so the v5
// package is imported behind the `mqtt5` prefix to keep the two apart.
import 'package:mqtt5_client/mqtt5_client.dart' as mqtt5;
import 'package:mqtt5_client/mqtt5_server_client.dart' as mqtt5;
import 'dart:async';

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
  
  /// Maps request ID → active MQTT v3.1.1 client (`mqtt_client` package).
  final Map<String, MqttServerClient> _mqttClients = {};

  /// Maps request ID → active MQTT v5 client (`mqtt5_client` package).
  /// Kept separate because the two packages' clients are different types.
  final Map<String, mqtt5.MqttServerClient> _mqtt5Clients = {};

  /// Maps request ID → the underlying `dart:io` socket. Kept separately so the
  /// heartbeat ping interval can be changed on a live connection (the channel
  /// does not expose the inner socket).
  final Map<String, WebSocket> _sockets = {};

  /// Whether there is an active connection for [requestId].
  bool hasConnection(String requestId) =>
      _channels.containsKey(requestId) ||
      _mqttClients.containsKey(requestId) ||
      _mqtt5Clients.containsKey(requestId);

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

  // --- MQTT LOGIC ---
  
  /// The plaintext MQTT port. Also the model's default ([MQTTRequestModel.port]).
  /// Used to detect "user left the port at its plaintext default" so we can
  /// transparently switch to the TLS port when [useTLS] is enabled.
  static const int _defaultPlaintextPort = 1883;

  /// The conventional secure (TLS) MQTT port.
  static const int _defaultTlsPort = 8883;

  /// Connects to an MQTT broker, routing by protocol [version].
  ///
  /// Two backing packages are used behind a single entry point:
  ///   * [MQTTVersion.v3] / [MQTTVersion.v3_1_1] → `mqtt_client`  (v3.1/3.1.1)
  ///   * [MQTTVersion.v5]                         → `mqtt5_client` (v5.0)
  ///
  /// The TLS / port-defaulting / WebSocket handling (the TLS-agent fix) is
  /// applied identically in both code paths.
  ///
  /// Session persistence — ONE knob ([sessionExpiryInterval]) serves both
  /// protocol versions:
  ///   * `0`  → clean session/start: the broker discards state on disconnect.
  ///   * `>0` → persistent session: v3 connects with cleanSession=false; v5
  ///     connects with cleanStart=false + this expiry interval (seconds).
  ///     Reconnecting with the SAME client id resumes the session, so QoS 1/2
  ///     messages queued while offline are delivered.
  ///
  /// [userProperties] is v5-only (ignored for v3). [onInfo] surfaces
  /// human-readable diagnostics (CONNACK reason code, SUBACK granted QoS /
  /// reason, …) so the caller can log them to the message history.
  Future<void> connectMqtt(
    String requestId,
    String brokerUrl,
    int port, {
    MQTTVersion version = MQTTVersion.v5,
    String? clientId,
    String? username,
    String? password,
    bool useTLS = false,
    bool useWebSocket = false,
    bool allowInvalidCertificates = false,
    List<NameValueModel> userProperties = const [],
    int sessionExpiryInterval = 0,
    int keepAlivePeriod = 60,
    String? willTopic,
    String? willMessage,
    bool willRetain = false,
    int willQos = 0,
    void Function(String topic)? onSubscribed,
    void Function(String topic, String payload)? onMessage,
    void Function()? onDisconnected,
    void Function(String info)? onInfo,
  }) async {
    disconnectMqtt(requestId);

    // Strip any lingering port from the URL if the user typed it manually 
    // and the UI didn't aggressively strip it to preserve cursor position.
    try {
      final uriStr = brokerUrl.contains('://') ? brokerUrl : 'mqtt://$brokerUrl';
      final uri = Uri.parse(uriStr);
      if (uri.hasPort && uri.port > 0) {
        brokerUrl = brokerUrl.replaceFirst(':${uri.port}', '');
      }
    } catch (_) {}

    if (version == MQTTVersion.v5) {
      await _connectMqttV5(
        requestId,
        brokerUrl,
        port,
        clientId: clientId,
        username: username,
        password: password,
        useTLS: useTLS,
        useWebSocket: useWebSocket,
        allowInvalidCertificates: allowInvalidCertificates,
        userProperties: userProperties,
        sessionExpiryInterval: sessionExpiryInterval,
        keepAlivePeriod: keepAlivePeriod,
        willTopic: willTopic,
        willMessage: willMessage,
        willRetain: willRetain,
        willQos: willQos,
        onSubscribed: onSubscribed,
        onMessage: onMessage,
        onDisconnected: onDisconnected,
        onInfo: onInfo,
      );
    } else {
      await _connectMqttV3(
        requestId,
        brokerUrl,
        port,
        clientId: clientId,
        username: username,
        password: password,
        useTLS: useTLS,
        useWebSocket: useWebSocket,
        allowInvalidCertificates: allowInvalidCertificates,
        // v3 has no expiry interval — the single model field maps to the
        // binary clean-session flag (0 = clean, >0 = persistent).
        cleanSession: sessionExpiryInterval == 0,
        keepAlivePeriod: keepAlivePeriod,
        willTopic: willTopic,
        willMessage: willMessage,
        willRetain: willRetain,
        willQos: willQos,
        onSubscribed: onSubscribed,
        onMessage: onMessage,
        onDisconnected: onDisconnected,
        onInfo: onInfo,
      );
    }
  }

  /// Resolves the effective broker port, transparently switching to the TLS
  /// port (8883) when TLS is on but the port is still the plaintext default.
  /// WebSocket ports are never remapped (they are broker-specific). Shared by
  /// both the v3 and v5 paths.
  int _resolveEffectivePort(int port, bool useTLS, bool useWebSocket) {
    if (useTLS && !useWebSocket && port == _defaultPlaintextPort) {
      debugPrint(
        'MQTT: TLS enabled with default plaintext port ($_defaultPlaintextPort); '
        'using TLS port $_defaultTlsPort instead.',
      );
      return _defaultTlsPort;
    }
    return port;
  }

  /// Resolves the server string handed to the underlying client. TCP wants a
  /// bare hostname; WebSocket wants a full ws:// / wss:// URL. Shared by both
  /// the v3 and v5 paths.
  String _resolveServerString(String brokerUrl, bool useTLS, bool useWebSocket) {
    if (useWebSocket) {
      return _buildWebSocketUrl(brokerUrl, useTLS);
    }
    var server = brokerUrl;
    if (server.contains("://")) {
      try {
        final uri = Uri.parse(server);
        server = uri.host.isNotEmpty ? uri.host : server;
      } catch (e) {
        debugPrint("Error parsing MQTT URL: $e");
      }
    }
    return server;
  }

  /// Last-resort fallback only: a fresh timestamped id is a NEW identity to
  /// the broker, so persistent sessions can't be resumed with it. The app
  /// layer (CollectionStateNotifier.sendRequest) generates a default Client
  /// ID once per request and persists it to the model, so this branch should
  /// not be hit from the UI.
  String _resolveClientId(String? clientId) => clientId?.isNotEmpty == true
      ? clientId!
      : 'apidash_${DateTime.now().millisecondsSinceEpoch}';

  // ── MQTT v3.1.1 path (mqtt_client) ─────────────────────────────────────
  Future<MqttServerClient> _connectMqttV3(
    String requestId,
    String brokerUrl,
    int port, {
    String? clientId,
    String? username,
    String? password,
    bool useTLS = false,
    bool useWebSocket = false,
    bool allowInvalidCertificates = false,
    bool cleanSession = true,
    int keepAlivePeriod = 60,
    String? willTopic,
    String? willMessage,
    bool willRetain = false,
    int willQos = 0,
    void Function(String topic)? onSubscribed,
    void Function(String topic, String payload)? onMessage,
    void Function()? onDisconnected,
    void Function(String info)? onInfo,
  }) async {
    final effectivePort = _resolveEffectivePort(port, useTLS, useWebSocket);
    final server = _resolveServerString(brokerUrl, useTLS, useWebSocket);
    final finalClientId = _resolveClientId(clientId);

    final client = MqttServerClient.withPort(server, finalClientId, effectivePort);
    client.logging(on: false);
    client.keepAlivePeriod = keepAlivePeriod;

    // Always supply an explicit CONNECT message: mqtt_client's built-in
    // default (used when none is set) calls startClean(), which silently
    // discards any persistent session. For cleanSession=false we leave the
    // package's cleanStart=false default in place so the broker RESUMES the
    // session — including QoS 1/2 messages queued while this client id was
    // offline. Username/password are applied by client.connect(); keepAlive
    // is copied from client.keepAlivePeriod by the package.
    final connMessage = MqttConnectMessage().withClientIdentifier(finalClientId);
    if (cleanSession) {
      connMessage.startClean();
    }
    if (willTopic != null && willMessage != null) {
      final mqos = MqttQos.values.length > willQos
          ? MqttQos.values[willQos]
          : MqttQos.atMostOnce;
      connMessage
          .withWillTopic(willTopic)
          .withWillMessage(willMessage)
          .withWillQos(mqos);
      if (willRetain) {
        connMessage.withWillRetain();
      }
    }
    client.connectionMessage = connMessage;

    // TLS / transport configuration (see TLS-fix notes). `secure` and
    // `useWebSocket` are mutually exclusive in mqtt_client.
    if (useWebSocket) {
      client.useWebSocket = true;
      if (useTLS) {
        client.securityContext = SecurityContext.defaultContext;
      }
    } else if (useTLS) {
      client.secure = true;
      client.securityContext = SecurityContext.defaultContext;
    }
    // Optionally accept self-signed / untrusted certs (e.g. test.mosquitto.org).
    if (useTLS && allowInvalidCertificates) {
      client.onBadCertificate = (Object? cert) {
        debugPrint('MQTT(v3): accepting bad certificate (allowInvalidCertificates).');
        return true;
      };
    }

    client.onDisconnected = () {
      debugPrint('MQTT(v3): disconnected $requestId');
      _mqttClients.remove(requestId);
      onDisconnected?.call();
    };
    client.onSubscribed = (String topic) {
      onSubscribed?.call(topic);
    };

    try {
      if (username?.isNotEmpty == true && password?.isNotEmpty == true) {
        await client.connect(username, password);
      } else {
        await client.connect();
      }
    } catch (e) {
      debugPrint('MQTT(v3): exception $e');
      client.disconnect();
      _mqttClients.remove(requestId);
      rethrow;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT(v3): connected to $brokerUrl');
      // v3.1.1 CONNACK has only a coarse return code (no rich reason codes).
      onInfo?.call(
        'CONNACK [MQTT 3.1.1]: ${client.connectionStatus!.returnCode?.name ?? 'connectionAccepted'}',
      );
      _mqttClients[requestId] = client;

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final topic = c[0].topic;
        onMessage?.call(topic, payload);
      });
    } else {
      client.disconnect();
      _mqttClients.remove(requestId);
      throw Exception('MQTT Connection failed: ${client.connectionStatus!.state}');
    }

    return client;
  }

  // ── MQTT v5 path (mqtt5_client) ────────────────────────────────────────
  Future<mqtt5.MqttServerClient> _connectMqttV5(
    String requestId,
    String brokerUrl,
    int port, {
    String? clientId,
    String? username,
    String? password,
    bool useTLS = false,
    bool useWebSocket = false,
    bool allowInvalidCertificates = false,
    List<NameValueModel> userProperties = const [],
    int sessionExpiryInterval = 0,
    int keepAlivePeriod = 60,
    String? willTopic,
    String? willMessage,
    bool willRetain = false,
    int willQos = 0,
    void Function(String topic)? onSubscribed,
    void Function(String topic, String payload)? onMessage,
    void Function()? onDisconnected,
    void Function(String info)? onInfo,
  }) async {
    final effectivePort = _resolveEffectivePort(port, useTLS, useWebSocket);
    final server = _resolveServerString(brokerUrl, useTLS, useWebSocket);
    final finalClientId = _resolveClientId(clientId);

    final client =
        mqtt5.MqttServerClient.withPort(server, finalClientId, effectivePort);
    client.logging(on: false);
    client.keepAlivePeriod = keepAlivePeriod;

    // Same TLS / transport rules as v3 (mqtt5_client mirrors the API).
    if (useWebSocket) {
      client.useWebSocket = true;
      if (useTLS) {
        client.securityContext = SecurityContext.defaultContext;
      }
    } else if (useTLS) {
      client.secure = true;
      client.securityContext = SecurityContext.defaultContext;
    }
    if (useTLS && allowInvalidCertificates) {
      client.onBadCertificate = (dynamic cert) {
        debugPrint('MQTT(v5): accepting bad certificate (allowInvalidCertificates).');
        return true;
      };
    }

    client.onDisconnected = () {
      debugPrint('MQTT(v5): disconnected $requestId');
      // Surface the DISCONNECT reason code from the broker, if any.
      try {
        final dr = client.connectionStatus?.disconnectMessage.reasonCode;
        if (dr != null && dr != mqtt5.MqttDisconnectReasonCode.notSet) {
          onInfo?.call('DISCONNECT reason: ${dr.name}');
        }
      } catch (e) {
        // Ignored. MqttConnectionStatus.disconnectMessage throws LateInitializationError if not set.
      }
      _mqtt5Clients.remove(requestId);
      onDisconnected?.call();
    };
    client.onSubscribed = (mqtt5.MqttSubscription sub) {
      final topic = sub.topic.rawTopic ?? sub.topic.toString();
      final rc = sub.reasonCode;
      // SUBACK reason code = granted QoS (grantedQos0/1/2) or a failure code.
      if (rc != null && rc != mqtt5.MqttSubscribeReasonCode.notSet) {
        onInfo?.call('SUBACK "$topic": ${rc.name}');
      }
      onSubscribed?.call(topic);
    };
    client.onSubscribeFail = (mqtt5.MqttSubscription sub) {
      final topic = sub.topic.rawTopic ?? sub.topic.toString();
      onInfo?.call('SUBACK FAILED "$topic": ${sub.reasonCode?.name ?? 'unknown'}');
    };

    // v5 session handling: sessionExpiryInterval == 0 → clean start (session
    // ends at disconnect). > 0 → persistent: startSession() sets
    // cleanStart=false — so an existing session for this client id (including
    // QoS 1/2 messages queued while offline) is RESUMED — and the expiry
    // interval tells the broker how long to retain the session after
    // disconnect. Calling startClean() with an expiry interval (the old code)
    // discarded on every reconnect exactly the state the broker had kept.
    final connMessage = mqtt5.MqttConnectMessage()
        .withClientIdentifier(finalClientId);

    if (sessionExpiryInterval > 0) {
      connMessage.startSession(sessionExpiryInterval: sessionExpiryInterval);
    } else {
      connMessage.startClean();
    }
    
    // Also ensure keep alive is explicitly set on the connect message
    connMessage.keepAliveFor(keepAlivePeriod);

    if (willTopic != null && willMessage != null) {
      final mqos = mqtt5.MqttQos.values.length > willQos
          ? mqtt5.MqttQos.values[willQos]
          : mqtt5.MqttQos.atMostOnce;
      final builder = mqtt5.MqttPayloadBuilder();
      builder.addString(willMessage);
      
      connMessage.will()
          .withWillTopic(willTopic)
          .withWillPayload(builder.payload!)
          .withWillQos(mqos);
          
      if (willRetain) {
        connMessage.withWillRetain();
      }
    }

    client.connectionMessage = connMessage;

    if (username?.isNotEmpty == true) {
      connMessage.authenticateAs(username, password);
    }
    for (final p in userProperties) {
      if (p.name.trim().isEmpty) continue;
      connMessage.addUserPropertyPair(p.name, p.value?.toString() ?? '');
    }

    try {
      if (username?.isNotEmpty == true && password?.isNotEmpty == true) {
        await client.connect(username, password);
      } else {
        await client.connect();
      }
    } catch (e) {
      debugPrint('MQTT(v5): exception $e');
      client.disconnect();
      _mqtt5Clients.remove(requestId);
      rethrow;
    }

    final status = client.connectionStatus;
    if (status != null && status.state == mqtt5.MqttConnectionState.connected) {
      debugPrint('MQTT(v5): connected to $brokerUrl');
      // CONNACK reason code — a major v5 debugging win over v3's return code.
      final rc = status.reasonCode;
      onInfo?.call('CONNACK [MQTT 5.0]: ${rc?.name ?? 'success'}');
      _mqtt5Clients[requestId] = client;

      client.updates.listen((List<mqtt5.MqttReceivedMessage<mqtt5.MqttMessage>> c) {
        final recMess = c[0].payload as mqtt5.MqttPublishMessage;
        final payload =
            mqtt5.MqttUtilities.bytesToStringAsString(recMess.payload.message!);
        final topic = c[0].topic ?? recMess.variableHeader?.topicName ?? '';
        onMessage?.call(topic, payload);
      });
    } else {
      // Even on failure, v5 gives us a precise reason code.
      final rc = status?.reasonCode;
      client.disconnect();
      _mqtt5Clients.remove(requestId);
      throw Exception(
        'MQTT v5 Connection failed: ${status?.state}'
        '${rc != null ? ' (${rc.name})' : ''}',
      );
    }

    return client;
  }

  /// Builds a websocket URL for the MQTT-over-WebSocket transport.
  ///
  /// The mqtt_client library requires the server string to be a full
  /// `ws://` or `wss://` URL when `useWebSocket` is true. This normalises
  /// whatever the user typed:
  ///   - no scheme         -> add `ws://` (or `wss://` if [useTLS])
  ///   - http/https scheme -> rewrite to ws/wss
  ///   - ws/wss scheme     -> upgrade ws->wss when [useTLS] is on, else keep
  /// The path (commonly `/mqtt`) is preserved.
  String _buildWebSocketUrl(String brokerUrl, bool useTLS) {
    final wsScheme = useTLS ? 'wss' : 'ws';
    final trimmed = brokerUrl.trim();
    if (!trimmed.contains('://')) {
      return '$wsScheme://$trimmed';
    }
    try {
      final uri = Uri.parse(trimmed);
      String scheme = uri.scheme.toLowerCase();
      if (scheme == 'http') scheme = 'ws';
      if (scheme == 'https') scheme = 'wss';
      // Honour an explicit TLS request by upgrading ws -> wss.
      if (useTLS && scheme == 'ws') scheme = 'wss';
      return uri.replace(scheme: scheme).toString();
    } catch (e) {
      debugPrint('Error parsing MQTT WebSocket URL: $e');
      return '$wsScheme://$trimmed';
    }
  }

  void subscribeMqtt(String requestId, String topic, int qos) {
    final v3 = _mqttClients[requestId];
    if (v3 != null) {
      final mqttQos = MqttQos.values.firstWhere(
        (q) => q.index == qos,
        orElse: () => MqttQos.atMostOnce,
      );
      v3.subscribe(topic, mqttQos);
      return;
    }
    final v5 = _mqtt5Clients[requestId];
    if (v5 != null) {
      final mqttQos = mqtt5.MqttQos.values.firstWhere(
        (q) => q.index == qos,
        orElse: () => mqtt5.MqttQos.atMostOnce,
      );
      v5.subscribe(topic, mqttQos);
    }
  }

  void unsubscribeMqtt(String requestId, String topic) {
    final v3 = _mqttClients[requestId];
    if (v3 != null) {
      v3.unsubscribe(topic);
      return;
    }
    final v5 = _mqtt5Clients[requestId];
    if (v5 != null) {
      v5.unsubscribeStringTopic(topic);
    }
  }

  /// Publishes [message] to [topic].
  ///
  /// The MQTT v5 extras ([userProperties], [responseTopic], [correlationData],
  /// [messageExpiryInterval]) are honoured only when the active client is a v5
  /// client; they are ignored on the v3 path (which can't carry them).
  void sendMqtt(
    String requestId,
    String topic,
    String message, {
    bool retain = false,
    int qos = 0,
    List<NameValueModel> userProperties = const [],
    String? responseTopic,
    String? correlationData,
    int messageExpiryInterval = 0,
  }) {
    final v3 = _mqttClients[requestId];
    if (v3 != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      final mqttQos = MqttQos.values.firstWhere(
        (q) => q.index == qos,
        orElse: () => MqttQos.atMostOnce,
      );
      v3.publishMessage(topic, mqttQos, builder.payload!, retain: retain);
      return;
    }

    final v5 = _mqtt5Clients[requestId];
    if (v5 == null) {
      debugPrint('MQTT: no active client for $requestId');
      return;
    }

    final mqttQos = mqtt5.MqttQos.values.firstWhere(
      (q) => q.index == qos,
      orElse: () => mqtt5.MqttQos.atMostOnce,
    );

    // Build a rich v5 PUBLISH so we can attach the v5-only properties.
    final builder = mqtt5.MqttPayloadBuilder();
    builder.addString(message);

    final pubMsg = mqtt5.MqttPublishMessage()
        .toTopic(topic)
        .withQos(mqttQos)
        .publishData(builder.payload!);
    if (retain) {
      pubMsg.setRetain(state: true);
    }
    if (messageExpiryInterval > 0) {
      pubMsg.withMessageExpiryInterval(messageExpiryInterval);
    }
    if (responseTopic != null && responseTopic.trim().isNotEmpty) {
      pubMsg.withResponseTopic(responseTopic.trim());
    }
    if (correlationData != null && correlationData.trim().isNotEmpty) {
      // Correlation data is opaque bytes; encode the user's text as UTF-8.
      final cdBuilder = mqtt5.MqttPayloadBuilder();
      cdBuilder.addUTF8String(correlationData.trim());
      pubMsg.withResponseCorrelationdata(cdBuilder.payload!);
    }
    for (final p in userProperties) {
      if (p.name.trim().isEmpty) continue;
      pubMsg.addUserPropertyPair(p.name, p.value?.toString() ?? '');
    }
    v5.publishUserMessage(pubMsg);
  }

  void disconnectMqtt(String requestId) {
    final v3 = _mqttClients.remove(requestId);
    if (v3 != null) {
      debugPrint('MQTT(v3): manually disconnecting $requestId');
      v3.disconnect();
    }
    final v5 = _mqtt5Clients.remove(requestId);
    if (v5 != null) {
      debugPrint('MQTT(v5): manually disconnecting $requestId');
      v5.disconnect();
    }
  }

  /// Tears down every active connection (used on app shutdown / data clear).
  void disconnectAll() {
    for (final entry in _channels.entries) {
      entry.value.sink.close();
    }
    _channels.clear();
    _sockets.clear();

    for (final client in _mqttClients.values.toList()) {
      client.disconnect();
    }
    _mqttClients.clear();

    for (final client in _mqtt5Clients.values.toList()) {
      client.disconnect();
    }
    _mqtt5Clients.clear();
  }
}
