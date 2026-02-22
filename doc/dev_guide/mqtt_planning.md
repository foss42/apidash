# MQTT — Deep-Dive & Implementation Plan for API Dash

> **Audience:** Developer with zero prior MQTT knowledge picking this up for GSoC 2026.  
> **Goal:** Understand MQTT end-to-end, then understand exactly how to implement it in API Dash following the same architecture as the WebSocket feature.

---

## Table of Contents

1. [What is MQTT?](#1-what-is-mqtt)
2. [The Broker — the central piece](#2-the-broker--the-central-piece)
3. [Topics — the addressing system](#3-topics--the-addressing-system)
4. [Publish / Subscribe model](#4-publish--subscribe-model)
5. [Quality of Service (QoS)](#5-quality-of-service-qos)
6. [Retained messages](#6-retained-messages)
7. [Clean Session vs Persistent Session](#7-clean-session-vs-persistent-session)
8. [Last Will and Testament (LWT)](#8-last-will-and-testament-lwt)
9. [Authentication & TLS](#9-authentication--tls)
10. [MQTT vs REST vs WebSocket — side by side](#10-mqtt-vs-rest-vs-websocket--side-by-side)
11. [The MQTT packet lifecycle (what actually goes over the wire)](#11-the-mqtt-packet-lifecycle)
12. [MQTT v3.1.1 vs v5 — what changed](#12-mqtt-v311-vs-v5)
13. [The `mqtt_client` Dart package](#13-the-mqtt_client-dart-package)
14. [How to implement MQTT in API Dash](#14-how-to-implement-mqtt-in-api-dash)
   - [14.1 Files to create](#141-files-to-create)
   - [14.2 Files to modify](#142-files-to-modify)
   - [14.3 Data model design](#143-data-model-design)
   - [14.4 MqttManager service](#144-mqttmanager-service)
   - [14.5 Riverpod state](#145-riverpod-state)
   - [14.6 UI design](#146-ui-design)
15. [Public test brokers](#15-public-test-brokers)
16. [Gotchas and known traps](#16-gotchas-and-known-traps)

---

## 1. What is MQTT?

**MQTT** (Message Queuing Telemetry Transport) is a lightweight, binary publish/subscribe messaging protocol invented in 1999 by IBM engineers Andy Stanford-Clark and Arlen Nipper. It was designed for:

- **Constrained devices** — an Arduino with 2 KB RAM can run an MQTT client.
- **Unreliable networks** — works over satellite links with 50% packet loss.
- **Low bandwidth** — the smallest MQTT message header is only **2 bytes**.

Today MQTT is the backbone protocol for most IoT systems — smart homes, industrial sensors, connected cars, healthcare devices. It is also used in mobile push notifications and real-time data pipelines.

**The transport is usually TCP** (port 1883 for plain, port 8883 for TLS). MQTT can also run over WebSockets (port 8083/8084) which is how it works in browsers and some load-balanced cloud environments.

---

## 2. The Broker — the central piece

Unlike REST (client talks directly to a server) and WebSocket (client connects directly to a server), **MQTT clients never talk to each other directly**. They all connect to a central server called a **broker**.

```
[Sensor A]──publish──▶│           │◀──subscribe──[Dashboard]
[Sensor B]──publish──▶│  BROKER   │──deliver────▶[Dashboard]
[Phone]────subscribe──▶│           │──deliver────▶[Phone]
```

The broker's job is:
1. Accept connections from clients.
2. Match published messages to subscriber client lists by topic.
3. Deliver matching messages to all subscribers.
4. Store retained messages.
5. Handle QoS acknowledgement flows.

**Popular brokers you can use for testing:**
| Broker | Type | URL |
|--------|------|-----|
| HiveMQ | Cloud (free tier) | broker.hivemq.com:1883 |
| Mosquitto | Open-source, self-hosted | — |
| EMQX | Open-source / cloud | broker.emqx.io:1883 |
| test.mosquitto.org | Public test | test.mosquitto.org:1883 |

The API Dash MQTT client connects **to the broker**, not to any application server. Users will type in a broker URL instead of an API endpoint.

---

## 3. Topics — the addressing system

A **topic** is a UTF-8 string used to route messages. It looks like a file path:

```
home/livingroom/temperature
factory/line1/sensor42/pressure
company/team/alerts
```

**Rules:**
- Forward slash `/` is the level separator.
- Topics are case-sensitive: `Home/Temp` ≠ `home/temp`.
- No leading slash needed (but allowed).
- Maximum 65535 bytes.

### Wildcards (subscribe only)

You cannot publish to a wildcard topic, but you can **subscribe** using wildcards:

| Wildcard | Meaning | Example |
|----------|---------|---------|
| `+` | Single level | `home/+/temperature` matches `home/livingroom/temperature` and `home/bedroom/temperature` but NOT `home/floor1/room2/temperature` |
| `#` | Multi-level (must be last) | `home/#` matches everything under `home/` including `home/livingroom/temp` and `home/floor1/room2/temp` |

So a single subscription to `sensors/#` can pull data from thousands of devices at once.

**System topics:** Topics starting with `$` are reserved (e.g. `$SYS/broker/clients/connected` on Mosquitto gives live broker stats). Clients cannot publish to `$` topics.

---

## 4. Publish / Subscribe model

This is the most fundamental thing to understand about MQTT. Forget the request/response model you know from REST. MQTT is **fire and forget on the sender side, always-on-receiving on the subscriber side**.

### Publishing

Any client can publish a message to any topic at any time:

```
client.publishMessage(
  'home/livingroom/temperature',
  MqttQos.atLeastOnce,
  payload,         // raw bytes
);
```

The client does NOT need to know who (if anyone) is listening. It just sends the message to the broker and moves on.

### Subscribing

Any client can subscribe to any topic (or wildcard pattern):

```
client.subscribe('home/livingroom/temperature', MqttQos.atLeastOnce);
```

After subscribing, the client's `updates` stream fires automatically whenever a matching message arrives from the broker. There is no polling, no request, no "waiting for a response" — messages just arrive whenever they are published.

### Flow timeline

```
Time ──────────────────────────────────────────────────────────▶

Sensor:    publish──▶       publish──▶       publish──▶
Broker:         receive/route    receive/route    receive/route
Dashboard:    ──subscribe──▶ ◀──deliver    ◀──deliver    ◀──deliver
```

The sensor does not know the dashboard exists. The dashboard does not request data — it just receives it passively. The broker is the only shared infrastructure.

For API Dash, the user will:
1. Connect to a broker.
2. Subscribe to one or more topics (to see incoming messages).
3. Optionally publish messages to topics.

---

## 5. Quality of Service (QoS)

QoS is a per-message delivery guarantee contract between client and broker. There are three levels:

### QoS 0 — At most once ("fire and forget")

```
Publisher ──[PUBLISH]──▶ Broker ──[PUBLISH]──▶ Subscriber
```

- Message is delivered **zero or one times** (may be lost).
- No acknowledgement, no retransmission.
- Fastest, lowest overhead.
- Use when: loss is acceptable (e.g. temperature readings every second — losing one is fine).

### QoS 1 — At least once

```
Publisher ──[PUBLISH]──▶ Broker ──[PUBACK]──▶ Publisher
                              ──[PUBLISH]──▶ Subscriber ──[PUBACK]──▶ Broker
```

- Message is delivered **one or more times** (may be duplicated, never lost).
- Publisher retransmits until it gets `PUBACK`.
- Subscriber may receive duplicates — must be idempotent.
- Use when: message must arrive, duplicates are acceptable (most IoT use cases).

### QoS 2 — Exactly once

```
Publisher ──[PUBLISH]──▶ Broker ──[PUBREC]──▶ Publisher
          ◀──[PUBREL]──           ◀──[PUBCOMP]──
```

- Message is delivered **exactly once** (four-way handshake).
- Slowest, highest overhead.
- Use when: billing events, commands that must execute exactly once.

For the API Dash UI: the user should be able to select QoS level from a dropdown (0 / 1 / 2) both for subscriptions and for each publish action.

---

## 6. Retained messages

When a client publishes with `retained = true`, the broker **stores the last message on that topic** and immediately delivers it to any future subscriber when they subscribe.

```
Sensor publishes: topic="home/temp", payload="23.5°C", retain=true
                                    ↓
[Broker stores: "home/temp" → "23.5°C"]

New dashboard connects and subscribes to "home/temp"
                                    ↓
[Broker immediately delivers "23.5°C" without waiting for next publish]
```

**Without retain:** a subscriber that connects after the last publish would have to wait until the next publish — which might be hours away for a slow sensor.

**To clear a retained message:** publish a zero-length payload to the same topic with `retain=true`.

In API Dash: when building the publish UI, include a **"Retain" checkbox**.

---

## 7. Clean Session vs Persistent Session

When connecting, a client sets a `cleanSession` flag:

### `cleanSession = true`  (default for testing tools)

- Broker forgets everything about this client when it disconnects.
- Any QoS 1/2 messages published while the client was offline are **discarded**.
- Any subscriptions are **cleared** on disconnect.
- Next connection starts completely fresh.
- Best for: test clients, one-time scripts, API Dash.

### `cleanSession = false`  (persistent session)

- Broker remembers the client by its `clientId`.
- Offline QoS 1/2 messages are **queued** and delivered when the client reconnects.
- Subscriptions **persist** across disconnects.
- Best for: resource-constrained IoT devices that sleep between sends.

For API Dash: `cleanSession = true` is the right default. Expose it as an advanced option.

---

## 8. Last Will and Testament (LWT)

When connecting, a client can register a "will" — a message the broker automatically publishes **on the client's behalf if the client disconnects ungracefully** (network drop, crash, power cut).

```dart
final connMessage = MqttConnectMessage()
  .withWillTopic('devices/sensor42/status')
  .withWillMessage('offline')
  .withWillQos(MqttQos.atLeastOnce)
  .withWillRetain();
```

If the client disconnects normally (with a `DISCONNECT` packet), the will is NOT sent. If the keep-alive timer expires without a `PINGREQ`, the broker sends the will.

**Real-world use:** every IoT device connects with `will = {topic: "devices/{id}/status", payload: "offline", retain: true}`. Other services can subscribe to `devices/+/status` to track which devices are currently online.

For API Dash: LWT is an advanced feature. Add it as a collapsible "Advanced" section in the connection settings.

---

## 9. Authentication & TLS

MQTT brokers support:

| Method | Details |
|--------|---------|
| **Username/Password** | Sent in the `CONNECT` packet. Most brokers support this. |
| **TLS client certificates** | Mutual TLS — client presents a certificate. Used in enterprise/cloud IoT. |
| **API keys (username only)** | Some cloud brokers use the username field for API keys. |
| **Anonymous** | Many test brokers allow anonymous connections. |

**Port conventions:**
- `1883` — plain TCP, no TLS
- `8883` — TLS (like HTTPS but for MQTT)
- `8083` — WebSocket, no TLS
- `8084` — WebSocket + TLS

The `mqtt_client` Dart package handles TLS via its `MqttServerClient.secure = true` flag plus optional `SecurityContext` for custom certificates.

For API Dash: implement username/password first (covers 90% of use cases). TLS and client certs can come in a follow-up.

---

## 10. MQTT vs REST vs WebSocket — side by side

| Aspect | REST (HTTP) | WebSocket | MQTT |
|--------|------------|-----------|------|
| **Transport** | TCP+HTTP | TCP (upgraded from HTTP) | TCP (or WebSocket) |
| **Pattern** | Request/Response (1 client → 1 server) | Full-duplex (1 client ↔ 1 server) | Publish/Subscribe (N clients ↔ broker ↔ M clients) |
| **Who initiates message** | Always the client | Either side | Publisher (unprompted) |
| **Idle overhead** | New TCP connection per request | One TCP connection, zero overhead | One TCP connection + keep-alive PINGs |
| **Min message size** | ~hundreds of bytes (HTTP headers) | 2–12 bytes (framing) | **2 bytes** |
| **Addressing** | URL (endpoints) | No concept — single connection | Topics (hierarchical strings) |
| **Delivery guarantees** | Depends on HTTP | None built-in | QoS 0/1/2 |
| **Offline delivery** | No | No | Yes (persistent sessions, QoS≥1) |
| **Fan-out to many clients** | Requires polling | Requires N WebSocket connections | Single publish reaches N subscribers |
| **Typical use** | APIs, web services | Real-time game data, chat | IoT, telemetry, fleet management |

**The key mental model:** REST is like making a phone call. WebSocket is like an open phone line. MQTT is like a radio station — the broadcaster doesn't know or care who is listening, and any number of receivers can tune in to the same channel.

---

## 11. The MQTT Packet Lifecycle

MQTT is a binary protocol. Every interaction is a typed packet. Here are the key ones:

### Connection

```
Client                              Broker
  │──── CONNECT ──────────────────▶│
  │     (clientId, username,        │
  │      password, cleanSession,    │
  │      keepAlive, will)           │
  │◀─── CONNACK ────────────────────│
  │     (returnCode: 0=accepted)    │
```

`CONNECT` is the first packet sent. `CONNACK` return code `0` means success; `1–5` are error codes (bad credentials, banned, broker unavailable, etc).

### Keep-Alive (ping)

```
Client                              Broker
  │──── PINGREQ ───────────────────▶│  (every keepAlive seconds)
  │◀─── PINGRESP ───────────────────│
```

No ping response within 1.5× the keepAlive interval = broker declares client dead and sends its LWT.

### Publish (QoS 0)

```
Client                              Broker
  │──── PUBLISH ───────────────────▶│
  │     (topic, payload, QoS=0)     │──▶ delivers to subscribers
```

### Publish (QoS 1)

```
Client                              Broker
  │──── PUBLISH (packetId=5) ──────▶│──▶ delivers to subscribers
  │◀─── PUBACK  (packetId=5) ───────│
```

### Subscribe

```
Client                              Broker
  │──── SUBSCRIBE (topic, QoS) ────▶│
  │◀─── SUBACK (granted QoS) ───────│
  │                                  │
  │◀─── PUBLISH (incoming msg) ─────│  (whenever a match is published)
```

### Disconnect

```
Client                              Broker
  │──── DISCONNECT ────────────────▶│
  │     (connection closes cleanly) │ (LWT is NOT sent)
```

---

## 12. MQTT v3.1.1 vs v5

The `mqtt_client` Dart package implements **v3.1.1** (the most widely deployed version). A separate package `mqtt5_client` covers v5.

**What v5 adds (not needed for basic implementation):**
- User properties (arbitrary key-value pairs on every packet)
- Message expiry interval
- Shared subscriptions (load-balancing across multiple subscribers)
- Subscription identifiers
- Enhanced authentication (challenge/response)
- Topic aliases (send a number instead of a long topic string)
- Flow control

**Recommendation:** implement v3.1.1 first using `mqtt_client`. v5 support can be a separate `APIType` or an "MQTT version" dropdown later.

---

## 13. The `mqtt_client` Dart Package

**Package:** `mqtt_client: ^10.11.9` (pub.dev)  
**License:** BSD-3 / MIT  
**Platforms:** all (Android, iOS, macOS, Linux, Windows, Web)  
**520+ weekly downloads**, 532 likes, used in production with AWS IoT, Google IoT Core, Azure IoT Hub, HiveMQ.

### Two client classes

| Class | Use |
|-------|-----|
| `MqttServerClient` | TCP connection — desktop, mobile, server |
| `MqttBrowserClient` | WebSocket only — web platform |

For API Dash (desktop-first), use `MqttServerClient`. The package handles TCP internally.

### Connection flow in code

```dart
// 1. Create client (host, clientId)
final client = MqttServerClient('broker.hivemq.com', 'apidash-${uuid()}');
client.port = 1883;
client.keepAlivePeriod = 60;           // seconds between PINGs
client.logging(on: false);             // disable verbose internal logs
client.onDisconnected = _onDisconnected;
client.onConnected = _onConnected;
client.onSubscribed = _onSubscribed;

// 2. Build the CONNECT message
final connMessage = MqttConnectMessage()
    .withClientIdentifier(client.clientIdentifier)
    .startClean()                      // cleanSession = true
    .withWillQos(MqttQos.atLeastOnce);

// 3. Optional: username/password
if (username != null) {
  connMessage.authenticateAs(username, password);
}

client.connectionMessage = connMessage;

// 4. Connect (await)
try {
  await client.connect();
} on NoConnectionException catch (e) {
  // CONNACK returned error code
}
if (client.connectionStatus!.state != MqttConnectionState.connected) {
  // Something went wrong
}
```

### Subscribing

```dart
// Subscribe to a topic
client.subscribe('home/temperature', MqttQos.atLeastOnce);

// Listen for incoming messages (single stream for ALL subscriptions)
client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
  for (final msg in messages) {
    final topic = msg.topic;
    final payload = msg.payload as MqttPublishMessage;
    final payloadString = MqttPublishPayload.bytesToStringAsString(
      payload.payload.message,
    );
    // → process topic + payloadString
  }
});
```

**Important:** `client.updates` is a **single stream for ALL subscribed topics**. Each item in the list is one received message with its topic and payload. You filter by `msg.topic` to handle different subscriptions differently.

### Publishing

```dart
final builder = MqttClientPayloadBuilder();
builder.addString('hello world');

client.publishMessage(
  'home/command',
  MqttQos.atLeastOnce,
  builder.payload!,
  retain: false,
);
```

### Unsubscribing & Disconnecting

```dart
client.unsubscribe('home/temperature');
client.disconnect();   // sends DISCONNECT packet, LWT not triggered
```

---

## 14. How to Implement MQTT in API Dash

Following the exact same architectural pattern as WebSocket:

```
Layer                Files
─────────────────────────────────────────────────────────────
Transport       packages/better_networking/  ← MqttManager
State           lib/providers/              ← MqttState, MqttStateNotifier
UI              lib/screens/...             ← request pane, response pane
Routing         url_card, details_card,     ← connect button, pane routing
                request_pane, ui_utils,
                texts, collection_providers
```

---

### 14.1 Files to Create

| File | Purpose |
|------|---------|
| `packages/better_networking/lib/models/mqtt_models.dart` | Data types: `MqttMessage`, `MqttSubscription`, `MqttConnectionConfig` |
| `packages/better_networking/lib/services/mqtt_service.dart` | `MqttManager` singleton — wraps `mqtt_client` |
| `lib/providers/mqtt_providers.dart` | `MqttState`, `MqttStateNotifier`, `mqttStateProvider` |
| `lib/screens/.../request_pane/request_pane_mqtt.dart` | Left pane: connection config + subscriptions + publish |
| `lib/screens/.../mqtt_response_pane.dart` | Right pane: live message stream |

---

### 14.2 Files to Modify

| File | Change |
|------|--------|
| `packages/better_networking/pubspec.yaml` | Add `mqtt_client: ^10.11.9` |
| `packages/better_networking/lib/consts.dart` | Add `APIType.mqtt("MQTT", "MQTT")` |
| `packages/better_networking/lib/models/models.dart` | Export `mqtt_models.dart` |
| `packages/better_networking/lib/services/services.dart` | Export `mqtt_service.dart` |
| `packages/better_networking/lib/better_networking.dart` | Export `mqtt_client` package if needed |
| `packages/better_networking/lib/utils/http_request_utils.dart` | Add `APIType.mqtt => null` to `getRequestBody()` |
| `lib/providers/providers.dart` | Export `mqtt_providers.dart` |
| `lib/providers/collection_providers.dart` | Add mqtt arm to type-switch |
| `lib/models/request_model.g.dart` | Add `APIType.mqtt: 'mqtt'` to serialization map |
| `lib/models/history_meta_model.g.dart` | Add `APIType.mqtt: 'mqtt'` to serialization map |
| `lib/utils/ui_utils.dart` | Add `APIType.mqtt => Colors.purple` (MQTT is conventionally purple) |
| `lib/widgets/texts.dart` | Add `APIType.mqtt => apiType.abbr` |
| `lib/screens/.../details_card.dart` | Route mqtt to `MqttResponsePane` |
| `lib/screens/.../request_pane.dart` | Route mqtt to `EditMqttRequestPane` |
| `lib/screens/.../url_card.dart` | Add `MqttConnectButton`, add mqtt to method-selector switches |

---

### 14.3 Data Model Design

#### `MqttMessage` — one incoming message

```dart
// packages/better_networking/lib/models/mqtt_models.dart

enum MqttMessageDirection { received, published, status, error }
enum MqttQosLevel { atMostOnce, atLeastOnce, exactlyOnce }

class MqttMessage {
  final String topic;           // which topic this arrived on / was sent to
  final String payload;         // message content (UTF-8 decoded)
  final MqttMessageDirection direction;
  final MqttQosLevel qos;
  final bool retained;          // was this a retained message?
  final DateTime timestamp;

  // convenience getters
  bool get isStatus   => direction == MqttMessageDirection.status;
  bool get isError    => direction == MqttMessageDirection.error;
  bool get isIncoming => direction == MqttMessageDirection.received;
  bool get isOutgoing => direction == MqttMessageDirection.published;
}
```

#### `MqttSubscription` — user-defined subscription

```dart
class MqttSubscription {
  final String topic;           // may contain + and # wildcards
  final MqttQosLevel qos;
  final bool active;            // is the broker ack received?
  final String id;              // uuid for list management
}
```

MQTT sessions can have **multiple simultaneous subscriptions**. The UI needs to manage a list of them — add/remove while connected.

#### `MqttConnectionConfig` — connection parameters

```dart
class MqttConnectionConfig {
  final String host;            // broker.hivemq.com
  final int port;               // 1883 / 8883 / 8083
  final String clientId;        // random UUID generated per connection
  final String? username;
  final String? password;
  final int keepAliveSecs;      // default 60
  final bool cleanSession;      // default true
  final bool useTls;            // default false
  // LWT (optional)
  final String? willTopic;
  final String? willPayload;
  final MqttQosLevel willQos;
  final bool willRetain;
}
```

This is richer than what WebSocket needed (just a URL) because MQTT has many connection parameters. The `httpRequestModel` URL field can store `broker:port` — extra fields go into a new `mqttRequestModel`.

---

### 14.4 MqttManager Service

```dart
// packages/better_networking/lib/services/mqtt_service.dart

class MqttManager {
  static final MqttManager _instance = MqttManager._internal();
  factory MqttManager() => _instance;
  MqttManager._internal();

  // Per requestId state
  final Map<String, MqttServerClient> _clients = {};
  final Map<String, StreamController<MqttMessage>> _controllers = {};
  final Map<String, StreamSubscription> _subscriptions = {};

  // ───── Stream ─────────────────────────────────────────────────
  Stream<MqttMessage> messagesStream(String requestId) {
    _controllers.putIfAbsent(
      requestId,
      () => StreamController<MqttMessage>.broadcast(),
    );
    return _controllers[requestId]!.stream;
  }

  // ───── Connect ────────────────────────────────────────────────
  Future<void> connect({
    required String requestId,
    required MqttConnectionConfig config,
  }) async {
    await disconnect(requestId);

    final client = MqttServerClient(config.host, config.clientId);
    client.port = config.port;
    client.keepAlivePeriod = config.keepAliveSecs;
    client.secure = config.useTls;

    // Wire up callbacks to emit status MqttMessages into our stream
    client.onConnected = () {
      _emit(requestId, MqttMessage(
        topic: '',
        payload: 'Connected to ${config.host}:${config.port}',
        direction: MqttMessageDirection.status,
        ...
      ));
    };
    client.onDisconnected = () {
      _emit(requestId, MqttMessage(
        topic: '',
        payload: 'Disconnected',
        direction: MqttMessageDirection.status,
        ...
      ));
      _clients.remove(requestId);
    };

    // Build CONNECT message
    var connMsg = MqttConnectMessage()
        .withClientIdentifier(config.clientId)
        .withKeepAliveOf(config.keepAliveSecs);

    if (config.cleanSession) connMsg = connMsg.startClean();
    if (config.username != null) {
      connMsg = connMsg.authenticateAs(config.username!, config.password);
    }
    if (config.willTopic != null) {
      connMsg = connMsg
          .withWillTopic(config.willTopic!)
          .withWillMessage(config.willPayload ?? '');
    }

    client.connectionMessage = connMsg;

    try {
      await client.connect();
    } catch (e) {
      _emit(requestId, MqttMessage(
        topic: '',
        payload: 'Connection failed: $e',
        direction: MqttMessageDirection.error,
        ...
      ));
      return;
    }

    _clients[requestId] = client;

    // Listen for all incoming published messages
    _subscriptions[requestId] = client.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage>> messages) {
        // Note: MqttMessage here is the mqtt_client type, not our own
        for (final msg in messages) {
          final pub = msg.payload as MqttPublishMessage;
          final payloadStr = MqttPublishPayload
              .bytesToStringAsString(pub.payload.message);
          _emit(requestId, MqttMessage(   // our own MqttMessage type
            topic: msg.topic,
            payload: payloadStr,
            direction: MqttMessageDirection.received,
            qos: _mapQos(pub.header!.qos),
            retained: pub.header!.retain,
            timestamp: DateTime.now(),
          ));
        }
      },
    );
  }

  // ───── Subscribe ──────────────────────────────────────────────
  void subscribe(String requestId, String topic, MqttQosLevel qos) {
    final client = _clients[requestId];
    if (client == null) return;
    client.subscribe(topic, _toMqttQos(qos));
  }

  void unsubscribe(String requestId, String topic) {
    _clients[requestId]?.unsubscribe(topic);
  }

  // ───── Publish ────────────────────────────────────────────────
  void publish(String requestId, String topic, String payload,
      MqttQosLevel qos, bool retain) {
    final client = _clients[requestId];
    if (client == null) return;
    final builder = MqttClientPayloadBuilder()..addString(payload);
    client.publishMessage(topic, _toMqttQos(qos), builder.payload!,
        retain: retain);
    _emit(requestId, MqttMessage(
      topic: topic,
      payload: payload,
      direction: MqttMessageDirection.published,
      qos: qos,
      retained: retain,
      timestamp: DateTime.now(),
    ));
  }

  // ───── Disconnect ─────────────────────────────────────────────
  Future<void> disconnect(String requestId) async {
    _subscriptions[requestId]?.cancel();
    _subscriptions.remove(requestId);
    _clients[requestId]?.disconnect();
    _clients.remove(requestId);
  }
}

// Global singleton (same pattern as wsManager)
final mqttManager = MqttManager();
```

---

### 14.5 Riverpod State

```dart
// lib/providers/mqtt_providers.dart

enum MqttConnectionStatus { idle, connecting, connected, disconnected, error }

class MqttState {
  final MqttConnectionStatus status;
  final List<MqttMessage> messages;         // all received + published + status
  final List<MqttSubscription> subscriptions;  // user-added subscriptions
  // Publish form state
  final String publishTopic;
  final String publishPayload;
  final MqttQosLevel publishQos;
  final bool publishRetain;

  bool get isConnected  => status == MqttConnectionStatus.connected;
  bool get isConnecting => status == MqttConnectionStatus.connecting;
  bool get canPublish   => isConnected && publishTopic.isNotEmpty;
}

class MqttStateNotifier extends StateNotifier<MqttState> {
  final String requestId;
  StreamSubscription<MqttMessage>? _sub;

  // Connect: takes full MqttConnectionConfig built from UI
  Future<void> connect(MqttConnectionConfig config) async {
    state = state.copyWith(status: MqttConnectionStatus.connecting, messages: []);
    await _sub?.cancel();
    _sub = mqttManager.messagesStream(requestId).listen((msg) {
      state = state.copyWith(messages: [...state.messages, msg]);
      if (msg.direction == MqttMessageDirection.status) {
        if (msg.payload.startsWith('Connected')) {
          state = state.copyWith(status: MqttConnectionStatus.connected);
        } else if (msg.payload == 'Disconnected') {
          state = state.copyWith(status: MqttConnectionStatus.disconnected);
        }
      } else if (msg.direction == MqttMessageDirection.error) {
        state = state.copyWith(status: MqttConnectionStatus.error);
      }
    });
    await mqttManager.connect(requestId: requestId, config: config);
  }

  // Subscribe to a topic
  void addSubscription(String topic, MqttQosLevel qos) {
    mqttManager.subscribe(requestId, topic, qos);
    state = state.copyWith(subscriptions: [
      ...state.subscriptions,
      MqttSubscription(topic: topic, qos: qos, active: true, id: uuid()),
    ]);
  }

  // Remove a subscription
  void removeSubscription(String subscriptionId) {
    final sub = state.subscriptions.firstWhere((s) => s.id == subscriptionId);
    mqttManager.unsubscribe(requestId, sub.topic);
    state = state.copyWith(
      subscriptions: state.subscriptions.where((s) => s.id != subscriptionId).toList(),
    );
  }

  // Publish
  void publish() {
    if (!state.canPublish) return;
    mqttManager.publish(
      requestId,
      state.publishTopic,
      state.publishPayload,
      state.publishQos,
      state.publishRetain,
    );
    state = state.copyWith(publishPayload: '');  // clear payload after send
  }
}

final mqttStateProvider =
    StateNotifierProvider.family<MqttStateNotifier, MqttState, String>(
  (ref, requestId) => MqttStateNotifier(requestId),
);
```

---

### 14.6 UI Design

#### URL Card — `MqttConnectButton`

Replace the "Send" button with a Connect/Disconnect button (same pattern as `WsConnectButton`).

The **URL field** for MQTT should contain just the broker host (e.g. `broker.hivemq.com`). Port, credentials, etc. live in the request pane.

#### Left Pane — `EditMqttRequestPane`

This is more complex than WebSocket because MQTT has more parameters. Proposed tab layout:

```
┌─────────────────────────────────────────────────┐
│  Tabs: Connection | Subscriptions | Publish      │
└─────────────────────────────────────────────────┘

CONNECTION tab:
  ┌──────────────────────────────────────────┐
  │ Port        [1883      ▾]                 │
  │ Client ID   [apidash-uuid    ] [Generate] │
  │ Username    [                ]            │
  │ Password    [                ]            │
  │ Keep Alive  [60] seconds                  │
  │ Clean Session  [✓]                        │
  │ Use TLS     [ ]                           │
  │                                          │
  │ ▶ Last Will (collapsible)                 │
  │    Topic    [                ]            │
  │    Payload  [                ]            │
  │    QoS      [1           ▾]              │
  │    Retain   [ ]                           │
  └──────────────────────────────────────────┘

SUBSCRIPTIONS tab:
  ┌──────────────────────────────────────────┐
  │ [+ Add subscription]                     │
  │                                          │
  │ ● home/temperature  QoS 1  [Unsubscribe] │
  │ ● sensors/#         QoS 0  [Unsubscribe] │
  └──────────────────────────────────────────┘

PUBLISH tab:
  ┌──────────────────────────────────────────┐
  │ Topic   [home/command              ]     │
  │ QoS     [1 - At least once      ▾]      │
  │ Retain  [ ]                              │
  │                                          │
  │ ┌──────────────────────────────────────┐ │
  │ │ {"command": "on"}                    │ │
  │ │                                      │ │
  │ └──────────────────────────────────────┘ │
  │                            [Publish  ▶]  │
  └──────────────────────────────────────────┘
```

#### Right Pane — `MqttResponsePane`

Chat-style message log, same as `WsResponsePane` but with topic displayed on each bubble:

```
┌─────────────────────────────────────────────────────────────┐
│ ● Connected  broker.hivemq.com:1883        [Disconnect]     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ─── Connected to broker.hivemq.com:1883 ───                │
│  ─── Subscribed: home/temperature (QoS 1) ───               │
│                                                              │
│  ┌──────────────────────────────────────┐                   │
│  │ home/temperature                     │                   │
│  │ 23.5                         09:12:01│  ◀ received       │
│  └──────────────────────────────────────┘                   │
│                                                              │
│                 ┌─────────────────────────────┐             │
│                 │ home/command                │             │
│                 │ {"command":"on"}   09:12:05 │  published ▶│
│                 └─────────────────────────────┘             │
│  ┌──────────────────────────────────────┐                   │
│  │ home/temperature                     │                   │
│  │ 24.1                         09:12:11│                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
│ Filter by topic: [              ]         [Clear All]        │
└─────────────────────────────────────────────────────────────┘
```

Key differences from WebSocket response pane:
- Each bubble shows the **topic** above the payload (MQTT can receive messages on many topics).
- **Filter by topic** input — lets the user search/filter by topic when they're subscribed to a wildcard like `sensors/#` that brings in many topics.
- Retained messages could show a 📌 pin icon.

---

## 15. Public Test Brokers

Use these to test your implementation without setting up a local broker:

| Broker | Host | Port | Notes |
|--------|------|------|-------|
| HiveMQ Public | `broker.hivemq.com` | 1883 | No auth, reliable |
| EMQX Public | `broker.emqx.io` | 1883 | No auth |
| Mosquitto Test | `test.mosquitto.org` | 1883 | No auth, 8883 for TLS |
| Mosquitto Test (auth) | `test.mosquitto.org` | 1884 | user:`rw` pass:`readwrite` |

**Quick test flow:**
1. Connect to `broker.hivemq.com:1883` with any client ID.
2. Subscribe to `apidash/test/response`.
3. Publish `hello world` to `apidash/test/response`.
4. You should immediately receive your own message back (the broker routes it back to you since you're both publisher and subscriber).

---

## 16. Gotchas and Known Traps

### Client ID must be unique
Two clients connecting with the same Client ID to a broker causes the **first to be forcibly disconnected**. Always generate a random UUID as the Client ID, or let the user set it manually.

### `client.updates` is null until connected
The `mqtt_client` package returns `null` for `client.updates` before a successful connection. Always null-check before calling `.listen()`.

### The `MqttMessage` name collision
`mqtt_client` exports its own `MqttMessage` type. Our own `MqttMessage` model in `better_networking` would clash. Solve by naming ours `MqttEvent` or importing `mqtt_client` with a prefix:
```dart
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
```

### QoS 2 is rarely needed
Most real-world MQTT use cases work fine with QoS 0 or 1. QoS 2 involves 4 round-trips and many brokers cap it or treat it as QoS 1 anyway. Implement all three in the UI but document that QoS 2 may not behave differently on test brokers.

### Keep-alive and background execution
On mobile, iOS may kill the TCP connection when the app goes to background. This breaks the MQTT keep-alive. For a desktop tool like API Dash this is not a concern, but worth noting for future mobile support.

### `MqttServerClient` vs `MqttBrowserClient`
On Flutter Web, `MqttServerClient` does not work — it uses `dart:io` sockets. Must use `MqttBrowserClient` (WebSocket-based). This can be handled with a conditional import or a factory constructor. For the initial implementation targeting desktop, `MqttServerClient` is fine.

### Topic filter `client.updates` returns ALL topics
`client.updates` delivers messages from ALL subscriptions in a single stream. Unlike WebSocket where there is only one "topic", MQTT can have dozens of active subscriptions. The response pane must display the topic name on each message, and ideally provide filtering.

### Payload is always bytes
`mqtt_client` payloads are `typed_data.Uint8List`. Use `MqttPublishPayload.bytesToStringAsString()` for text. For binary payloads (images, sensor data encoded as bytes), a hex view would be ideal as a follow-up feature.

---

## Implementation Order (Suggested)

1. Add `mqtt_client` dep + `APIType.mqtt` enum + serialization maps.
2. Create `MqttMessage` model (rename to `MqttEvent` to avoid collision).
3. Create `MqttManager` service (connect/disconnect/subscribe/publish).
4. Create `MqttState` + `MqttStateNotifier` + `mqttStateProvider`.
5. Create `MqttConnectButton` in `url_card.dart`.
6. Create `EditMqttRequestPane` (start with just Connection tab, add others iteratively).
7. Create `MqttResponsePane` (start with basic message list, add topic filter later).
8. Wire up routing in `details_card.dart`, `request_pane.dart`, `ui_utils.dart`, `texts.dart`.
9. Fix exhaustive switches (`collection_providers.dart`, `http_request_utils.dart`).
10. Test against `broker.hivemq.com`.
11. Add unit tests for `MqttManager` and `MqttStateNotifier`.
