### Initial Idea Submission

**Full Name:** Rishi Ahuja  
**University name:** National Institute of Technology, Jalandhar  
**Program you are enrolled in (Degree & Major/Minor):** Bachelor of Technology, Information Technology  
**Year:** Sophomore  
**Expected graduation date:** August 2028  

**Project Title:** WebSocket, MQTT & gRPC — First-Class Protocol Support for API Dash  
**Relevant issues:** [#15](https://github.com/foss42/apidash/issues/15) (WebSocket), [#115](https://github.com/foss42/apidash/issues/115) (MQTT), [#14](https://github.com/foss42/apidash/issues/14) (gRPC)

---

## Idea Description

### The Problem

API Dash handles REST and GraphQL well, but a growing share of real-world APIs speak different protocols: **gRPC** (Kubernetes, microservice meshes, ML serving), **WebSocket** (real-time dashboards, chat, collaborative editors), and **MQTT** (IoT sensors, smart home, telemetry). Developers testing these systems today bounce between Postman, grpcurl, MQTTX, and wscat — there's no single open-source, cross-platform desktop client that handles all of them with a unified UX.

This project adds first-class support for all three protocols in API Dash — each with its own transport service, data model, Riverpod state layer, and UI pane, all following the same layered architecture the codebase already uses for REST.

| Protocol | Primary Domain | Wire Format | Connection Model | Spec |
|----------|---------------|-------------|-----------------|------|
| WebSocket | Real-time apps, live data | Frames over TCP | Persistent, full-duplex | [RFC 6455](https://datatracker.ietf.org/doc/html/rfc6455) |
| MQTT | IoT, telemetry, edge devices | Binary packets over TCP | Persistent, pub/sub via broker | [OASIS v3.1.1](https://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html) |
| gRPC | Microservices, ML serving, K8s | Protobuf over HTTP/2 | Persistent, multiplexed | [gRPC/HTTP2](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-HTTP2.md) |

---

### Working Proof of Concept

Before writing this, I built a **working PoC covering all three protocols** — verified against real servers (echo.websocket.org, broker.hivemq.com, grpcb.in). The fork implements the full end-to-end flow for each protocol.

**Fork:** [RishiAhuja/apidash](https://github.com/RishiAhuja/apidash/tree/feat/grpc-support)

I also wrote detailed implementation guides for each protocol before and while writing the code:
- [websocket_implementation.md](https://github.com/RishiAhuja/apidash/blob/feat/grpc-support/doc/dev_guide/websocket_implementation.md)
- [mqtt_planning.md](https://github.com/RishiAhuja/apidash/blob/feat/grpc-support/doc/dev_guide/mqtt_planning.md)
- [grpc_implementation.md](https://github.com/RishiAhuja/apidash/blob/feat/grpc-support/doc/dev_guide/grpc_implementation.md)

#### Video Walkthrough

<p align="center">
  <a href="https://artifacts.rishia.in/apidash/proposal/videos/full-demo.mp4" target="_blank">
    <img 
      src="https://artifacts.rishia.in/apidash/proposal/images/video-thumbail.png"
      alt="Watch Full PoC Demo"
      width="800"
    />
  </a>
</p>

<p align="center">
  <b>Click the thumbnail to watch the complete PoC walkthrough (gRPC + WebSocket + MQTT)</b>
</p>

Individual protocol demos: [WebSocket](https://artifacts.rishia.in/apidash/proposal/videos/ws-demo.mp4) · [MQTT](https://artifacts.rishia.in/apidash/proposal/videos/mqtt-demo.mp4) · [gRPC](https://artifacts.rishia.in/apidash/proposal/videos/grpc-demo.mp4)

---

### High-Level Architecture

All three protocols follow the **same layered pattern** API Dash already uses for REST:

```
┌─────────────────────────────────────────────────┐
│                    UI Layer                      │
│  (Protocol-specific request & response panes)    │
├─────────────────────────────────────────────────┤
│               State Layer (Riverpod)             │
│  (Family providers keyed by request ID)          │
├─────────────────────────────────────────────────┤
│             Transport / Service Layer            │
│  (WebSocketManager, MqttClientManager,           │
│   GrpcClientManager — in better_networking pkg)  │
├─────────────────────────────────────────────────┤
│                  Data Models                     │
│  (WsMessage, MqttRequestModel, GrpcRequestModel) │
└─────────────────────────────────────────────────┘
```

![Architecture Diagram](https://artifacts.rishia.in/apidash/proposal/images/start-artitecture.jpg)

Each protocol gets a dedicated request model (not reusing HttpRequestModel — which was the failure point in previous PRs), and Riverpod family providers keyed by request ID so tab-switching preserves state.

---

## 1. WebSocket

**Issue:** [#15](https://github.com/foss42/apidash/issues/15) — oldest open feature request (April 2023). Five previous PRs were blocked by state persistence loss on tab switching.

I read through the entire [RFC 6455](https://datatracker.ietf.org/doc/html/rfc6455) and wrote a [25-minute blog post](https://rishia.in/blogs/you-dont-know-websockets-yet) explaining every part of it. Understanding the protocol at the spec level informed key implementation decisions — for instance, awaiting `channel.ready` before emitting connected status, because the handshake is a distinct phase (Section 4) and the `web_socket_channel` package returns immediately from `connect()` before the TCP+TLS+HTTP upgrade completes.

### Implementation

**Transport — `WebSocketManager`** (in `packages/better_networking/`): Global singleton managing connections keyed by request ID. Awaits `channel.ready` before emitting connected status, listens on `channel.stream` for incoming frames, catches errors and `onDone` as typed `WsMessage` events.

```dart
final channel = WebSocketChannel.connect(uri, protocols: null);
await channel.ready;  // Wait for handshake to complete (RFC 6455 §4)
_channels[requestId] = channel;
```

**State — `WsStateNotifier`**: Riverpod `StateNotifier` wrapping the manager. Subscribes to the broadcast stream *before* calling `connect()` so no early status messages are missed. Messages tracked as immutable list so Riverpod detects state changes.

**UI — Chat-style message feed**: Sent messages right-aligned, received left-aligned, status centered, errors in red. Request pane reuses existing `EditRequestURLParams` and `EditRequestHeaders` widgets — because the WebSocket handshake *is* an HTTP upgrade request.

![WebSocket echo test](https://artifacts.rishia.in/apidash/proposal/images/ws_poc_echo_test.png)

### Why Previous PRs Failed & How This Fixes It

Previous attempts ([#210](https://github.com/foss42/apidash/pull/210), [#215](https://github.com/foss42/apidash/pull/215), [#555](https://github.com/foss42/apidash/pull/555), [#1003](https://github.com/foss42/apidash/pull/1003), [#1017](https://github.com/foss42/apidash/pull/1017)) lost connection state when switching tabs. My implementation uses **Riverpod family providers keyed by request ID** — the connection, messages, and input state all survive tab switches because they live in the provider tree, not in widget state.

---

## 2. MQTT

**Issue:** [#115](https://github.com/foss42/apidash/issues/115) (Feb 2024). PR [#258](https://github.com/foss42/apidash/pull/258) was closed due to state persistence failure and reusing the HTTP request model. PR [#864](https://github.com/foss42/apidash/pull/864) remains a draft.

I read the [MQTT v3.1.1 OASIS spec](https://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html) in detail and wrote a [planning document](https://github.com/RishiAhuja/apidash/blob/feat/grpc-support/doc/dev_guide/mqtt_planning.md) before writing any code — mapping every MQTT concept to the `mqtt_client` Dart package's API.

### Core Concepts Implemented

- **Pub/Sub via broker** with all three **QoS levels** (0: at-most-once, 1: at-least-once, 2: exactly-once)
- **Retained messages** — last-known-value pattern for new subscribers
- **Clean Session** — fresh vs. resumed session state
- **Last Will and Testament (LWT)** — broker publishes a configurable message if client disconnects ungracefully
- **Authentication** — username/password with environment variable support
- **Topic wildcards** — `+` (single level) and `#` (multi-level)

![MQTT Architecture](https://artifacts.rishia.in/apidash/proposal/images/mqtt-artitecture.jpg)

### Implementation

**Transport — `MqttClientManager`** (in `packages/better_networking/`): Factory-with-registry pattern (`getOrCreate(requestId)` / `remove(requestId)`). Builds `MqttConnectMessage` from config, handles clean session, auth, and LWT. Listens to `client.updates` only after confirming `MqttConnectionState.connected`.

**Data Model — `MqttRequestModel`**: Dedicated model (not reusing HTTP) storing broker URL, port, client ID, MQTT version, auth credentials, keep-alive, clean session, LWT config, and a list of `MqttTopicModel` subscriptions with individual QoS levels.

**State — Split family providers**: Separate providers for connection state, message feed, and each publish-form field. This means the QoS dropdown doesn't rebuild the payload editor when it changes.

**UI — Five-tab request pane**:

| Tab | Purpose |
|-----|---------|
| **Message** | JSON/plain text editor for publish payload |
| **Topics** | Subscription table with live subscribe/unsubscribe toggles per topic |
| **Auth** | Username + password with env var support |
| **Last Will** | LWT topic, message, QoS, retain toggle |
| **Settings** | Port, keep-alive, clean session, MQTT version |

A bottom publish bar (`[Retain] [QoS dropdown] [topic] [Send]`) keeps publish controls always visible.

![MQTT UI — topics tab](https://artifacts.rishia.in/apidash/proposal/images/mqtt-topics.png)

![MQTT response pane — message bubbles](https://artifacts.rishia.in/apidash/proposal/images/mqtt-response-pane.png)

### MQTT v5 — Planned

v5 adds shared subscriptions, user properties, request/response correlation, and enhanced reason codes. The `MqttVersion` enum is already in place; implementation is planned for early GSoC weeks after discussing UX implications with mentor.

---

## 3. gRPC

**Issue:** [#14](https://github.com/foss42/apidash/issues/14) (April 2023). No PR has ever reached a working implementation — the combined scope of reflection, protobuf encoding, streaming, and UI blocked every attempt.

I read the [gRPC spec](https://grpc.io/docs/what-is-grpc/core-concepts/), [Protocol Buffers encoding guide](https://protobuf.dev/programming-guides/encoding/), and the [gRPC over HTTP/2 spec](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-HTTP2.md), then wrote a detailed [implementation guide](https://github.com/RishiAhuja/apidash/blob/feat/grpc-support/doc/dev_guide/grpc_implementation.md) documenting the full architecture and every bug I found.

### What's Implemented

**All four gRPC call types:**

| Call Type | Client Sends | Server Sends |
|-----------|-------------|--------------|
| Unary | 1 message | 1 message |
| Server streaming | 1 message | N messages |
| Client streaming | N messages | 1 message |
| Bidirectional | N messages | N messages |

**Server Reflection** — runtime service/method discovery without needing `.proto` files. I created a local monorepo package (`packages/grpc_reflection/`) that exports the generated Dart stubs for Google's official `reflection.proto` and `descriptor.proto`.

**Dynamic Protobuf Encoder/Decoder** — since API Dash doesn't have compiled `.proto` files (users type JSON, we have the runtime descriptor from reflection), I wrote a custom `jsonToProtobuf` encoder handling all 15 protobuf field types:
- **Varints** (wire type 0): int32, uint32, sint32 (ZigZag), int64, uint64, sint64 (ZigZag), bool, enum
- **Fixed-width** (wire types 1 & 5): float, double, fixed32, sfixed32, fixed64, sfixed64
- **Length-delimited** (wire type 2): string, bytes, nested messages

**`.pb` file import** as alternative to server reflection for production servers with reflection disabled.

**`GrpcTypeRegistry`** — runtime type resolution for nested messages and enums during encoding/decoding.

![gRPC call types](https://artifacts.rishia.in/apidash/proposal/images/grpc-calltypes.jpg)

### Key Technical Challenges Solved

**1. The Dual-Channel Problem:** gRPC Server Reflection uses a bidi-streaming RPC. Cancelling the reflection stream after reading sends an HTTP/2 `RST_STREAM` frame, which causes some servers (including `grpcb.in`) to respond with `GOAWAY` — killing the entire HTTP/2 connection. Fix: use a **separate ephemeral channel** for reflection, shut it down after discovery, then open a clean main channel for actual RPC calls.

```
Reflection Channel (ephemeral)     Main Channel (clean)
        │                                  │
  listServices ──►                         │
  ◄── [service1, service2]                 │
  fileContainingSymbol ──►                 │
  ◄── FileDescriptorProto                  │
        │ shutdown()                       │
        X                           invokeMethod ──►
                                    ◄── response
```

**2. Wire Type Bug:** Initial encoder mapped `FIXED32`/`SFIXED32` to varint wire type (0) instead of 32-bit fixed wire type (5). Since protobuf decoding uses the wire type to know how many bytes a field occupies, a wrong wire type corrupts every subsequent field. Fixed by writing the wire format directly using raw `ByteData`.

**3. Raw Bytes Channel Trick:** The Dart `grpc` package expects compiled `ClientMethod<Req, Res>` types. Since we build messages dynamically, I declared `ClientMethod<List<int>, List<int>>` with identity serializer/deserializer — same approach as `grpcurl`.

**4. Stale Closure & Reconnection Bugs:** Detailed in the [implementation guide](https://github.com/RishiAhuja/apidash/blob/feat/grpc-support/doc/dev_guide/grpc_implementation.md) — `onChanged` callbacks capturing stale model snapshots, broken channel reuse on reconnect, host:port auto-splitting for IPv6 safety.

![gRPC PoC — unary call result](https://artifacts.rishia.in/apidash/proposal/images/grpc_poc_unary_call.png)

### gRPC UI

Request pane with four tabs: **Message** (JSON body → protobuf), **Metadata** (gRPC headers), **Service Definition** (service/method browser), and **Settings** (TLS, reflection toggle, .pb import). Response pane streams incoming messages as separate timestamped cards.

![gRPC UI pane layout](https://artifacts.rishia.in/apidash/proposal/images/grpc_ui_pane.png)

---

## Approach & Timeline Overview

### Implementation Order

1. **WebSocket** (smallest scope, already mostly working) → polish, test, persist
2. **MQTT** (medium scope, v5 is the main new work) → harden, add v5, test
3. **gRPC** (largest scope, encoder hardening and streaming) → complete streaming UI, .pb file picker, edge cases
4. **Code generation** (stretch goal) → WebSocket/MQTT/gRPC codegen following existing `codegen/` architecture

### What Remains Beyond the PoC

| Protocol | Remaining Work |
|----------|---------------|
| **WebSocket** | Binary frame display, ping/pong visibility, auto-reconnect, message persistence to Hive, subprotocol negotiation, unit/widget tests |
| **MQTT** | MQTT v5 (shared subscriptions, user properties, reason codes), TLS/SSL, topic auto-complete, wildcard tree visualization, message persistence, comprehensive tests |
| **gRPC** | `oneof`/`map`/packed repeated fields, well-known types (Timestamp, Duration, Any, Struct), client streaming UI (message-by-message send), bidirectional streaming UI, `.pb` file picker, TLS certificate import, comprehensive tests |
| **Codegen** | WebSocket (Dart/JS/Python), MQTT (Dart/Python/JS), gRPC (Dart/Python/Go) — following existing `codegen/` package architecture |

### Key Design Decisions

- **Dedicated request models per protocol** — not reusing `HttpRequestModel` (was the root cause of failure in previous MQTT/WS PRs)
- **Riverpod family providers keyed by request ID** — connection state survives tab switching
- **Transport layer in `packages/better_networking/`** — keeps protocol logic out of the main app, following the existing monorepo pattern
- **`grpc_reflection` as a local monorepo package** — cleanly encapsulates the generated protobuf stubs for reflection
- **`.pb` binary import over `.proto` text parsing** — simpler, more reliable, avoids maintaining a proto text parser

---

## About Me

I'm a sophomore in IT at [NIT Jalandhar](https://www.nitj.ac.in/). I've been writing Flutter since v2→v3 and built [FernKit](https://fernkit.in/) — a UI toolkit rendering pixel-by-pixel for Linux and WASM, with its own CLI, networking layer, and TTF text rasterizer in C++.

**Professional:** Flutter at [Stack Wealth](https://stackwealth.in/) (YC S21, [#2 contributor](https://artifacts.rishia.in/resume/rishi-resume-v9.pdf)), AI infra at [Annam.ai](https://www.annam.ai/) (IIT Ropar), DevOps at [Zenbase Technologies](http://silentninja.tech) (Singapore). Two research papers under review (IJCAI 2026, ICLR 2026 TSALM Workshop).

**Open Source:**
- API Dash: [#918](https://github.com/foss42/apidash/pull/918) (Hurl import via Rust FFI), [#1121](https://github.com/foss42/apidash/pull/1121) (background media fix)
- AppFlowy: [#8278](https://github.com/AppFlowy-IO/AppFlowy/pull/8278) (merged), [#8261](https://github.com/AppFlowy-IO/AppFlowy/pull/8261)
- asdf-vm: [#2245](https://github.com/asdf-vm/asdf/pull/2245) (interrupted install fix)

**Blog:** [rishia.in/blogs](https://rishia.in/blogs) — 11 in-depth technical posts, including a [deep dive into WebSocket internals](https://rishia.in/blogs/you-dont-know-websockets-yet) after reading the full RFC.  
**GitHub:** [RishiAhuja](https://github.com/RishiAhuja)  
**Discord:** rishi_2220
