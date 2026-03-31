# GSoC 2026 Proposal — WebSocket, MQTT & gRPC Support in API Dash

### About
1. **Full Name:** Varun S N
2. **Contact info:** varunnamavali@gmail.com
3. **Discord handle:** varsan1622
4. **Home page:** N/A
5. **Blog:** N/A
6. **GitHub profile link:** https://github.com/Varvyju
7. **LinkedIn:** https://www.linkedin.com/in/varun-s-n-5807321b7/
8. **Time zone:** Asia/Kolkata (UTC+5:30)
9. **Link to a resume:** [Resume Link](https://drive.google.com/file/d/1pidB2u6zZO6cCqoFJvaCYyucLETzejfE/view?usp=sharing)

### University Info
1. **University name:** BNM Institute of Technology, Bengaluru (Visvesvaraya Technological University)
2. **Program you are enrolled in:** B.E. Electronics & Communication Engineering
3. **Year:** Graduated 2025
4. **Expected graduation date:** 2025 (completed)

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**
Yes. During the GSoC 2026 application period, I actively contributed to CCExtractor's `ultimate_alarm_clock` repository, handling critical codebase-wide deprecations and database safety:
* **PR #921:** `fix: replace print() with debugPrint()` — 30 replacements across 7 files, addressing production logging consistency.
* **PR #922:** `fix: replace deprecated .withOpacity() with .withValues(alpha:)` — 128 replacements across 40 files, eliminating a Flutter deprecation warning throughout the entire codebase.
* **PR #908:** `fix: prevent StateError crash in getTriggeredAlarm` — Implemented null-safety bounds and optimized `.findFirst()`/`.limit(1)` database queries across both ISAR and Firestore providers to prevent fatal application crashes.

**2. What is your one project/achievement that you are most proud of? Why?**
**PRISM** — an IoT asset tracking system (React, Firebase Realtime Database, Leaflet, Django REST API) that I presented at IITCEE-2025. 
What makes me proudest is not the technology, but the problem it solved: real-time asset location tracking over **WebSocket** connections for live dashboard updates. The challenge of keeping WebSocket state reliable under intermittent connectivity taught me more about protocol-level debugging, fragmentation, and dropped frames than any coursework. 
More significantly, at **Renalyx Health Systems**, I built a production Flutter clinical telemetry application deployed in a real hospital environment. In that context, a broken real-time data stream is a patient safety concern—not an inconvenience. That deployment validated my understanding of what reliable protocol implementation actually requires.

**3. What kind of problems or challenges motivate you the most?**
Protocol-level reliability problems. The gap between "it works in testing" and "it works under real production conditions"—network drops, partial messages, reconnection handling, state management under failure—is where I find the most interesting engineering work. WebSocket, MQTT, and gRPC each present distinct versions of this challenge, which is exactly why Idea #7 appeals to me.

**4. Will you be working on GSoC full-time?**
Yes. I am a 2025 graduate with no current employment or coursework commitments. GSoC will be my full-time work (40 hours/week) from May through September.

**5. Do you mind regularly syncing up with the project mentors?**
Not at all. I prefer regular synchronous check-ins. I commit to weekly Discord syncs, async daily updates, and responding to messages within 2 hours during working hours (10:00 AM–6:00 PM IST).

**6. What interests you the most about API Dash?**
API Dash is the first open-source API client that takes Flutter seriously as a production target—not as a demo, but as the primary UI layer. As someone who has built production Flutter applications, I find it technically honest in a way that most API tooling is not. The fact that it runs natively on macOS, Windows, Linux, Android, and iOS from a single codebase while handling complex API interactions is genuinely impressive engineering.

**7. Can you mention some areas where the project can be improved?**
* **Protocol coverage gap:** REST and GraphQL are well-served. WebSocket, MQTT, and gRPC are first-class protocols in IoT, real-time systems, and microservices—their absence is the most significant missing capability for developers working in those domains.
* **Response visualization for streaming:** Current response visualization is built around request-response. Real-time protocols need a live, scrollable event stream view with time-series diagnostic metadata.
* **Code generation for new protocols:** The existing code generation feature for REST is excellent. Extending it to WebSocket and gRPC client code would immediately reduce integration time for developers.

**8. Have you interacted with and helped the API Dash community?**
I have joined the Discord server (`varsan1622` in `#gsoc-foss-apidash`), reviewed the contribution guidelines, developer docs, and set up the local Flutter environment to analyze the request execution flow.

---

### Project Proposal Information

**1. Proposal Title:** WebSocket, MQTT & gRPC: Protocol Testing, Diagnostics, and Code Generation

**2. Abstract:**
API Dash currently lacks support for WebSocket, MQTT, and gRPC—three critical protocols used in IoT, real-time systems, and microservices. I will design a `ProtocolHandler` abstraction layer and implement full testing, live stream visualization, and code generation (Dart/Python/JS/Go) for all three protocols. The architecture prioritizes isolation, ensuring existing HTTP workflows remain completely untouched, while introducing production-grade transport diagnostics and robust UI patterns for streaming data.

**3. Detailed Description:**

#### A. Architecture Design & Integration Strategy
The core architectural rule for this project is **Isolation and Non-Regression**. Previous attempts to add protocols to API Dash failed because they tried to bolt new fields onto the existing `HttpRequestModel`, causing state bloat and runtime crashes. 

I will design a clean **Protocol Routing** architecture that leaves the HTTP pipeline untouched:
* **Dedicated Models:** `WebSocketRequestModel`, `MqttRequestModel`, and `GrpcRequestModel` will live completely isolated from HTTP.
* **Execution Dispatch:** `RequestExecutor → ProtocolRouter → ProtocolHandler`. HTTP requests hit the existing pipeline; new protocols are routed to their own state machines.
* **Backward Compatibility:** Provider updates will use defensive `?? 0` null-checks to ensure older persisted sessions don't crash the app during hot-reloads or migrations.

#### B. Protocol Implementations

**WebSocket Implementation (Transport & Diagnostics)**
* **Connection Lifecycle:** Explicit states for connecting, connected, reconnecting (with exponential backoff), and disconnected. 
* **Message Handling:** Support for Text, JSON, and Binary payloads with a configurable decoder (UTF-8, hex, base64).
* **Deep Diagnostics:** Timeline view will not just show messages, but also transport-level events like Ping/Pong frames, sequence gaps, and TLS certificate metadata.
* **Reproducibility:** JSONL session export/import to save and replay exact message sequences for debugging.

**MQTT Implementation (Broker & Pub/Sub)**
* **Intelligent Connectivity:** Map raw `CONNACK` return codes to human-readable errors (e.g., "Identifier rejected" instead of generic "Connection refused"). Support for `mqtts://` (TLS).
* **Pub/Sub Engine:** Dynamic subscribe/unsubscribe without dropping the connection. Publish with explicit QoS (0, 1, 2) and Retain flags.
* **Live Telemetry:** A status strip showing real-time rolling metrics: msgs/sec, total sent/received, throughput (B/s), and latency.

**gRPC Implementation (Reflection-First)**
* **Discovery Strategy:** A **Reflection-First** approach. API Dash will attempt Server Reflection to automatically populate available services and methods in a Service Explorer tree. 
* **Descriptor Fallback:** If reflection is disabled on the server, users can upload a `.pb` descriptor file.
* **Dynamic Encoding:** Because API Dash doesn't compile `.proto` stubs at runtime, I will build a `DynamicProtoEncoder` to handle wire types directly from the descriptor payload, supporting Unary, Server Streaming, Client Streaming, and Bidirectional calls.

#### C. UI/UX Strategy: The "Advanced Toggle" Pattern
Three new protocols introduce massive UI surface area. To prevent API Dash from becoming cluttered, I will enforce an **"Advanced Toggle"** pattern:
* **The Default View:** Remains compact (URL/Broker, Connect Button, Message Timeline).
* **The Advanced Panel:** Complex tools (Decoder pipelines, JSONL Replay controls, TLS diagnostics, Retain flags) will live behind a hidden toggle. This ensures the tool remains approachable for beginners while powerful for power-users.

#### D. Risk Management Matrix
| Risk | Mitigation Strategy |
| :--- | :--- |
| **gRPC Connection Drops** | Reflection RPCs often close with an HTTP/2 `GOAWAY` frame. I will use a separate ephemeral channel specifically for discovery, shutting it down cleanly before opening the main channel for real RPC calls. |
| **UI Thread Blocking (Jank)** | High-frequency MQTT streams (e.g., IoT telemetry) can cause `RenderFlex` overload. Incoming message streams will be buffered and yielded to the UI in batches, ensuring 60fps scrolling. |
| **State Migration Crashes** | Adding new fields to protocol models means older persisted sessions might be missing them. I will enforce defensive defaults (nullable counters) to ensure safe model evolution. |

**4. Weekly Timeline (175 Hours)**

**Community Bonding (May 1–26):**
* Deep review of API Dash request execution engine and `better_networking` layer.
* Set up local dev environment, run all existing tests.
* Finalize `ProtocolRouter` abstraction interface design with mentors.

**Week 1–2 (May 27–Jun 9): Architecture & WebSocket Foundation**
* Implement `ProtocolRouter` and interface separation.
* WebSocket connection manager: connect, disconnect, send, receive.
* Basic WebSocket UI: connection panel, message composer.

**Week 3–4 (Jun 10–Jun 23): WebSocket Complete & Diagnostics**
* Live message stream view with timestamps and direction indicators.
* Transport diagnostics (Ping/Pong, TLS metadata) and Reconnection logic.
* WebSocket code generation: Dart, JavaScript, Python.

**Week 5–6 (Jun 24–Jul 7): MQTT Foundation**
* MQTT connection manager using `mqtt_client`.
* Connection config UI: broker, port, client ID, QoS, clean session.
* Map `CONNACK` error codes to UI validation states.

**Week 7–8 (Jul 8–Jul 21): MQTT Complete**
* Topic subscription manager with wildcard support and retain flags.
* Filterable live message stream and live telemetry strip.
* MQTT code generation: Dart, Python, JavaScript.
* **MIDTERM DELIVERABLE:** WebSocket and MQTT fully functional, isolated from HTTP, with robust diagnostics.

**Week 9–10 (Jul 22–Aug 4): gRPC Foundation (Reflection & Stubs)**
* Protobuf file parser: extract services and methods.
* Server Reflection discovery implementation.
* Request builder: auto-generated form from proto schema.

**Week 11–12 (Aug 5–Aug 18): gRPC Complete & Dynamic Encoding**
* Implement `DynamicProtoEncoder` for Unary and Streaming calls.
* gRPC error handling: status codes, metadata, and trailers display.
* gRPC code generation: Dart, Python, Go.

**Week 13 (Aug 19–Aug 25): Cross-Protocol Polish**
* Unified connection history across all three protocols.
* Implement the "Advanced Toggle" UI pattern across all protocol panes.
* Export/import connection configurations (JSONL).

**Week 14 (Aug 26–Sep 1): Testing & Hardening**
* **Unit Tests:** For protocol models, `ProtocolRouter` state transitions, and `DynamicProtoEncoder` serialization.
* **Widget Tests:** Ensure "Advanced" toggles and disabled states behave correctly without layout overflow.
* **Integration Tests:** End-to-end flows against public test infrastructure (`broker.hivemq.com`, `grpcb.in`).

**Week 15 (Sep 2–Sep 12): Final Submission**
* Contributor guide: how to add a new protocol using the abstraction layer.
* Final PR cleanup, documentation, and GSoC submission.