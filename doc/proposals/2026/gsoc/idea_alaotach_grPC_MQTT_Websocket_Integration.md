### Initial Idea Submission

**Full Name:** Aryan Mishra  
**University name:** Jawaharlal Nehru University  
**Program you are enrolled in (Degree & Major/Minor):** B.Tech (Electronics and Communication Engineering)  
**Year:** Second Year  
**Expected graduation date:** 2028 

---

### Project Title  
WebSocket, MQTT and gRPC Support in API Dash

---

### Relevant issues:
[#15](https://github.com/foss42/apidash/issues/15) (WebSocket),
[#115](https://github.com/foss42/apidash/issues/115) (MQTT), 
[#14](https://github.com/foss42/apidash/issues/14) (gRPC)

---

### Idea description:

API Dash currently focuses on HTTP-based workflows such as REST, GraphQL, and AI requests. This limits its usefulness in modern systems where communication is increasingly stateful, streaming, and event-driven. Protocols like WebSocket, MQTT, and gRPC are widely used in real-time systems, IoT infrastructures, and microservice architectures but are not supported in API Dash.

This project aims to transform API Dash into a multi-protocol API client and testing platform, extending its capabilities beyond HTTP.

To ground this proposal in the current codebase, I verified that `HttpRequestModel` is defined in `packages/better_networking/lib/models/http_request_model.dart`, the request-editor API type switch currently lives in `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart`, and request execution is orchestrated through `sendRequest()` in `lib/providers/collection_providers.dart`, which is the natural integration point for protocol-specific routing.

---

### 1. Architecture Extension

Instead of modifying the existing HTTP request model, the system will be extended with protocol-specific abstractions:

- `WebSocketRequestModel`  
- `MqttRequestModel`  
- `GrpcRequestModel`  

Each model will encapsulate its own configuration and validation logic while following a shared execution interface.

Execution will follow a protocol routing flow:
RequestExecutor -> ProtocolRouter -> ProtocolHandler

This ensures modularity, clean separation of concerns, and future extensibility without affecting existing features.

---

### 2. WebSocket Implementation

The WebSocket module will enable persistent, bidirectional communication testing within API Dash, targeting real-time applications, chat systems, and live data feeds.

**Library:** `package:web_socket_channel`

**Connection Management:**
- Connect to `ws://` and `wss://` endpoints with TLS support
- Custom headers and query parameters per connection
- Manual connect/disconnect controls with explicit state tracking (`connecting → open → closing → closed`)
- Automatic reconnection with exponential backoff on unexpected drops
- Multiple simultaneous connections via isolated `WebSocketChannel` instances

**Messaging:**
- Send and receive text, JSON, and binary frames
- Outgoing messages via `channel.sink.add()`, incoming via `channel.stream` subscription
- Binary frames displayed as hex dump with optional Base64 toggle
- Protobuf-encoded binary frames can be decoded by attaching a `.proto` schema and selecting the expected message type — rendered as structured JSON in the timeline alongside raw hex, reusing the same `FileDescriptorSet` pipeline from the gRPC module

**UI — Message Timeline:**
- Chronological timeline with direction indicators (↑ sent / ↓ received)
- Per-message timestamp, payload size, and type label (`text` / `binary` / `proto`)
- Collapsible payload view for large messages

**Persistence:**
- Session summary stored in `WebSocketRequestModel` including endpoint, headers, full message history, and connection duration

### 3. MQTT Implementation

The MQTT module will enable testing of broker-based pub/sub messaging systems,
targeting IoT infrastructure, telemetry pipelines, and smart home systems.

**Library:** `package:mqtt_client`

**Connection Management:**
- Broker host, port, and optional TLS configuration
- Client ID, username/password authentication
- CONNACK return codes mapped to human-readable errors
  (code 4 = bad credentials, code 5 = not authorized)
- Clean session and keep-alive configuration
- Last Will and Testament (LWT) — broker publishes a configurable message
  if client disconnects ungracefully

**Pub/Sub:**
- Publish messages to topics with QoS level and retain flag
  - QoS 0: at-most-once
  - QoS 1: at-least-once
  - QoS 2: exactly-once
- Subscribe and unsubscribe from topics dynamically
- Wildcard topic filters — `+` (single level) and `#` (multi-level)
- Multiple simultaneous subscriptions via isolated `StreamController` instances
  per topic, merged into a unified feed using `StreamGroup`
- Incoming message listener gated behind `MqttConnectionState.connected`
  check — `client.updates` is null until connection is confirmed

**MQTT v5** *(Planned)*
- Shared subscriptions, user properties, and enhanced reason codes
- `MqttVersion` enum in place; v5 scoped after core v3.1.1 is stable

### 4. gRPC & ConnectRPC Implementation

The gRPC module introduces schema-driven, type-safe API interaction within API Dash, targeting microservice architectures and high-performance backend systems.

**Library:** `package:grpc`

**Service Discovery:**
- **Primary:** gRPC Server Reflection via `grpc.reflection.v1alpha.ServerReflection` — no `.proto` file needed, schema fetched directly from the live server
- **Fallback:** User uploads `.proto` files, processed via `protoc --descriptor_set_out` to generate a `FileDescriptorSet` binary, parsed using `package:protobuf`'s descriptor API
- Extracted services, RPC methods, and message types populate the UI dynamically

**Connection Management:**
- Plaintext (`grpc://`) and TLS (`grpcs://`) channel support
- Per-request metadata headers
- Channel lifecycle managed by `GrpcHandler` — open, idle, and teardown states tracked explicitly

**Messaging:**
- Dynamic request body UI auto-generated from message definitions
- JSON → Protobuf serialization for outgoing requests
- Protobuf → JSON deserialization for responses
- Response metadata, status codes, and trailers displayed in structured panel

**A note on dynamic Protobuf encoding:**
`package:protobuf`'s `CodedBufferWriter` handles wire types correctly but is
designed for generated code — it expects compiled Dart stubs with pre-known field
types. Since API Dash encodes dynamically (user-provided JSON + runtime schema from
reflection, no generated stubs), `CodedBufferWriter` doesn't fit cleanly. The
encoder will instead write the wire format directly using `ByteData`, resolving
all 15 protobuf field types at runtime:
- **Varint** (wire type 0): `int32`, `uint32`, `sint32`, `int64`, `uint64`,
  `sint64` (ZigZag), `bool`, `enum`
- **Fixed-width** (wire types 1 & 5): `float`, `double`, `fixed32`, `sfixed32`,
  `fixed64`, `sfixed64`
- **Length-delimited** (wire type 2): `string`, `bytes`, nested messages

**Call Types:**
- Unary RPC
- Server streaming RPC (responses rendered incrementally in a live feed)

**ConnectRPC** *(Stretch Goal)*
ConnectRPC runs over standard HTTP/1.1 and HTTP/2, making it naturally compatible with API Dash's existing HTTP infrastructure — no new networking layer required.
For ConnectRPC, I will reuse the existing predefined HTTP request path instead of introducing a separate transport model: `RequestModel` already carries `httpRequestModel` in `lib/models/request_model.dart`, request execution already routes through `sendRequest()` in `lib/providers/collection_providers.dart`, and the underlying HTTP streaming/send flow is already implemented in `packages/better_networking/lib/services/http_service.dart` (`sendHttpRequest` / `streamHttpRequest`).
- Reuse existing HTTP client with Connect-specific headers (`application/connect+json` / `application/connect+proto`)
- Handle Connect envelope framing for streaming responses
- Reuse the same `FileDescriptorSet` pipeline for request body generation
- Surface as a protocol toggle in the gRPC editor — same UI, different transport

**Stretch Goals:**
- ConnectRPC support *(above)*
- Client streaming RPC
- Bidirectional streaming RPC

---

### 5. User Interface Integration

API Dash’s API-type switching system will be extended with dedicated editors:

- WebSocket editor with connection controls and live stream console  
- MQTT editor with broker configuration and topic activity panel  
- gRPC editor with schema-driven request builder  

All editors will follow existing UI conventions for consistency.

**Response Pane — MQTT:**
- **Left panel — Topic Explorer:**
  - Tree view of subscribed topics
  - Each topic shows message count badge and last received timestamp
  - Active topics highlighted, inactive dimmed
  - Clicking a topic filters the message log to that topic only

- **Right panel — Message Log:**
  - Table view: `Time`, `Topic`, `QoS` (badge colored by level — 0 grey, 1 blue, 
    2 green), `Retain` flag, `Size`, `Payload preview`
  - Expanding a row shows full payload with raw / JSON toggle
  - Publish history shown with distinct `↑ PUB` label vs `↓ SUB` for received

- **Filter bar** — filter by topic, QoS level, direction, keyword


**Response Pane — WebSocket:**
- **Message log table** (not chat bubbles) with columns:
  - `#` index, `Direction` (↑/↓), `Time`, `Latency`, `Type` (`text`/`binary`/`proto`), 
    `Size`, `Payload preview`
- Clicking a row expands a **detail drawer** below the table showing:
  - Raw payload (hex for binary, plaintext for text)
  - Decoded JSON if parseable
  - Protobuf-decoded view if `.proto` schema attached
  - Toggle between raw / decoded / hex
- **Filter bar** — filter by direction, type, or keyword in payload
- **Stats strip** at top — total messages, ↑ sent, ↓ received, session duration, 
  avg message size

---

### 6. History and Persistence

Since WebSocket and MQTT are session-based, the history model will be extended to include:

- Session duration  
- Message count  
- Connection status  
- Error logs  

This approach preserves useful debugging data without storing entire message streams.

---

### 7. Testing Strategy

Testing will include:

- Unit tests for protocol models  
- UI tests for request editors  
- Integration tests using:
  - WebSocket echo servers  
  - MQTT test brokers  
  - Sample gRPC services  

Regression testing will ensure no impact on existing REST and GraphQL functionality.

---

### 8. Expected Outcome

By the end of the project, API Dash will support:

- WebSocket-based real-time communication testing  
- MQTT publish and subscribe workflows  
- gRPC service interaction using `.proto`  

This will position API Dash as a comprehensive protocol testing tool for modern distributed systems.

### 9. Tentative Timeline

| Weeks | Focus |
|-------|-------|
| 1–2 | Codebase familiarization, architecture setup, protocol models |
| 3–5 | WebSocket implementation + response pane UI |
| 6–8 | MQTT implementation + topic explorer UI |
| 9–11 | gRPC implementation + reflection + dynamic encoder |
| 12 | ConnectRPC stretch goal, testing, documentation |