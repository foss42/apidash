### About

1. **Full Name:** Aryan Mishra
2. **Contact info (public email):** aryanmi2001@gmail.com
3. **Discord handle in our server (mandatory):** alaotach
6. **GitHub profile link:** https://github.com/alaotach
7. **Twitter, LinkedIn, other socials:** [Twitter](https://x.com/alaotach) [Linkedin](https://linkedin.com/in/alaotach)
8. **Time zone:** IST (UTC+05:30)
9. **Link to a resume:** [Resume](https://drive.google.com/file/d/1hnyt2KPOfiS1uNWjsXIU33ENeKOni_Yh/view?usp=sharing)

---

### University Info

1. **University name:** Jawaharlal Nehru University
2. **Program you are enrolled in:** B.Tech (Electronics and Communication Engineering)
3. **Year:** Second Year
4. **Expected graduation date:** 2028

---

## Motivation & Past Experience

### 1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

Yes. I have made some contributions to API Dash itself and hackclub community and worked on real user-facing issues covering crash prevention, validation robustness, UI correctness, and execution-history UX.

Highlighted PRs:

- **[PR #1281 (Fix #1264)](https://github.com/foss42/apidash/pull/1281):** Prevented unhandled crash when Infinity/NaN values enter AI config numeric fields.
	- Added input-level validation and autovalidation.
	- Added reactive provider-level invalid-state detection to disable send action.
	- Added model-level defensive guards to prevent invalid payload serialization.
	- Added tests for deserialization and payload-value safety.

- **[PR #1285 (Fix #1283)](https://github.com/foss42/apidash/pull/1285):** Fixed response body segmented tab wrapping on cold start.
	- Corrected width calculation for segmented control.
	- Prevented icon/label layout mis-measurement and ensured single-line labels.

- **[PR #1286 (Fix #1183)](https://github.com/foss42/apidash/pull/1286):** Added inline validation for API key and endpoint URL in AI model selector dialog.
	- Blocking save on invalid state.
	- Live error clear on user input.

- **[PR #1320 (Feat #1319)](https://github.com/foss42/apidash/pull/1320):** Added response latency in history sidebar cards.
	- Extended metadata model and serialization.
	- Rendered latency in history cards without lazy-loading full request objects.
	- Updated model fixtures/tests.

- **[PR #1473 (GSoC PoC)](https://github.com/foss42/apidash/pull/1473):** Added MQTT, WebSocket, and gRPC support in a PoC branch.

These contributions reflect that I already understand API Dash coding conventions, state flow, model generation workflow, and quality expectations for review-ready PRs.

Additional FOSS contributions (Hack Club YSWS Catalog):

- [PR #257: fix carnival active status](https://github.com/hackclub/YSWS-Catalog/pull/257) (merged)
	- Updated catalog status correctness and related entries.
- [PR #255: fixed terminal craft v5 description](https://github.com/hackclub/YSWS-Catalog/pull/255) (merged)
	- Corrected grant/hour and description data accuracy.

While these were smaller PRs, they demonstrate consistent open-source participation, quick turnaround, and attention to correctness in production-facing content.

### 2. **What is your one project/achievement that you are most proud of? Why?**

The project I'm most proud of is [**DotVerse**](https://github.com/alaotach/dotverse), a realtime multiplayer pixel-art metaverse. But honestly, what I'm proud of isn't the product, it's surviving one particular bug that drove me insane for days.
Pixels were broken in three different ways at once. Sometimes you'd draw something and it would just disappear a second later. Sometimes your pixels would show up for everyone else but not for you. Sometimes they wouldn't update at all. And the thing that made it genuinely maddening was that none of this was consistent, it would happen randomly, so I couldn't even reliably reproduce it to debug it. I spent a lot of time just staring at the screen trying to catch it happening.
After a lot of trial and error I finally traced it back to something embarrassingly simple: I was spamming the websocket. When you drag to draw, you're touching a new pixel on basically every frame of mouse movement. I was emitting a separate event for every single one of those pixels. The server was getting flooded, events were racing each other, and state was ending up different on different clients depending on which events arrived in which order. The connection was dropping frames under load and nobody's canvas agreed on what was true.
The fix wasn't complicated once I understood what was happening. I stopped emitting per-pixel and started batching, collect everything touched during a drag, send it all together when the drag ends. Combined with server-side sequencing so clients process updates in order, all three failure modes went away at once.
That one debugging session shaped the whole rest of the architecture. The canvas world server (Node.js + Socket.IO) and the minigame server (Python websockets, handling lobbies, voting, scoring) are separate processes, partly because I learned the hard way that mixing two different consistency requirements into one server makes both of them worse.
I mention all this because it's directly relevant to why I want to build the WebSocket module in API Dash. I'm not coming at this theoretically, I know where these systems actually break, because I've been the person staring at a canvas wondering why my own pixels aren't showing up for me.

### 3. **What kind of problems or challenges motivate you the most to solve them?**

I am most motivated by problems where there is no obvious existing solution, especially when people assume they are too hard or impractical to build.

I have an entrepreneurship-oriented mindset, so I naturally gravitate toward technically difficult ideas with strong real-world use. For example, I am currently exploring:

- a mobile-GPU AI inference/training platform to coordinate model workloads across clusters of multiple phones,
- a mobile AI agent with on-device vision and deep device control to execute real tasks (from app flows to automation),
- and a websocket-synced Android lock-screen drawing experience where actions are mirrored in real time across devices.

What motivates me is the combination of technical depth, product-level constraints, and user impact. I enjoy turning "this should be impossible" into something reliable enough to demonstrate and iterate.

### 4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

Yes, full-time. GSoC is my main commitment during the coding period and I'm treating it that way.
I won't pretend I have zero going on, because I'm in college, I have side projects, and I've worked with clients. But honestly that's exactly why I'm not worried about this. Client work taught me that deadlines are real, communication matters, and you don't get to disappear when things get hard. I bring that same accountability here. I'll show up every week, flag blockers early, and I won't let review turnaround become a bottleneck on the mentor's end.

### 5. **Do you mind regularly syncing up with the project mentors?**

Not at all, I actually prefer it. I learned this the hard way with my first client. They were pretty quiet throughout the project, I kept building, and when I handed them the final product they said they didn't want it running on the PC itself, they wanted it on the cloud. Suddenly I'm dealing with containers, Kubernetes, deployment pipelines, things that weren't in the original plan at all. It took a lot of extra effort that could've been avoided with one conversation early on.
That experience genuinely changed how I work. Regular syncs aren't overhead to me anymore, they're how you avoid expensive surprises at the end. I'd rather flag a blocker or a design question on Monday than explain a derailed week on Friday. I'll bring progress openly, show what's working and what isn't, and if I'm choosing between two implementation approaches I'll bring both to the mentor instead of silently picking one.

### 6. **What interests you the most about API Dash?**

Honestly, I've felt the pain this tool is trying to solve.
When I was building **Aloo Bot**, backed by hundreds of different APIs, I wasn't even using proper tools. I had a Python script I'd manually modify every time I needed to test something different. Change the endpoint, change the payload, run it, check the output, repeat. For REST that was annoying. When I got into trading automation with Binance and Bybit, testing exchange APIs under real latency pressure with that same script was genuinely painful. Every test was a manual edit away and there was no visibility into what was actually happening on the wire.
API Dash is the tool I wished existed back then. It already has a solid cross-platform foundation and a clean architecture, it's not a toy, it's something developers actually use. And it's open source, which means when I add WebSocket, MQTT, and gRPC support, it's not a feature locked inside one company's product, it's available to every developer who's still out there editing Python scripts to test their APIs.
That's what interests me most. Not just the technical challenge, but the fact that shipping this actually makes something meaningfully better for people who build what I build.

### 7. **Can you mention some areas where the project can be improved?**

The obvious one is what this proposal is about, WebSocket, MQTT, and gRPC support. But a few things I noticed while actually working in the codebase:
Long-running sessions have almost no observability. If you're connected to a WebSocket for ten minutes and something goes wrong, there's not much to help you understand what happened, no message timeline metadata, no transport diagnostics, no way to replay the session. For debugging real production issues that's a real gap.
The history is useful but lightweight for protocol sessions. It shows that a request was made but not much about what the session looked like, how long it ran, how many messages exchanged, whether it disconnected cleanly. That context matters when you're debugging intermittent failures.
Contributor onboarding for protocol work is thin. The existing docs cover HTTP well but if someone wanted to add a new protocol or extend an existing one, there's not much guiding them through the provider/model/service pattern. That slows down community contributions.
And one small UX thing — advanced controls in the editor panes could be organized more consistently. Right now different panes handle progressive disclosure differently, which adds friction when you're switching between protocols.

### 8. **Have you interacted with and helped API Dash community? (GitHub/Discord links)**

Yes. I have interacted through issue-driven PR work and community contribution channels.

I have actively worked on real issues, submitted PRs, and built idea/prototype artifacts specifically for API Dash’s GSoC direction.

Recent PoC contribution evidence:

- GSoC PoC PR: [#1473](https://github.com/foss42/apidash/pull/1473)
	- Title: Add MQTT, WebSocket, and gRPC support to API Dash (PoC)
	- Status: Open (from `alaotach:poc` to `foss42:main`)
	- Scope: 14 commits, 57 files changed, +23,416 / -1,256 lines
- PoC demo video: [Google Drive demo](https://drive.google.com/file/d/1ufOMtceT_AyjXEdzWkwdhDEFOvwThADI/view?usp=sharing)

---

### Project Proposal Information

## Proposal Title

**WebSocket, MQTT, and gRPC Support in API Dash**

## Abstract

API Dash is excellent for HTTP, but a large chunk of modern backend systems don't speak HTTP. WebSocket powers real-time dashboards and chat. MQTT runs IoT sensors and telemetry pipelines. gRPC connects microservices and ML infrastructure. Right now, developers testing these systems have to leave API Dash entirely and juggle separate tools, or do what I used to do, which is maintain a Python script they modify by hand every time.

This project adds first-class support for all three protocols directly inside API Dash. Not as experimental add-ons as complete workflows with their own request models, connection state, message timelines, and debugging tools, built on the same provider/service/model architecture the codebase already uses for REST.

By the end of GSoC, a developer should be able to open API Dash and:
- connect to a WebSocket endpoint, send and receive messages, and replay a session for debugging
- connect to an MQTT broker, publish and subscribe across topics with QoS controls
- invoke a gRPC method via server reflection without needing a `.proto` file on hand

All of this while the existing HTTP workflows stay completely untouched and with production-grade UX patterns for reliability, observability, and reproducibility.

3. **Detailed Description**

![](https://github.com/foss42/apidash/assets/615622/493ce57f-06c3-4789-b7ae-9fa63bca8183)

## 3.1 Problem Statement and Need

Most backend systems today aren't pure REST. WebSocket handles real-time event streams and bidirectional channels. MQTT drives IoT telemetry and broker-mediated messaging. gRPC powers contract-first microservice communication. But API Dash currently has no support for any of them.

That forces developers into a fragmented workflow, a different tool for each protocol, repeated environment setup, no shared history, and no way to reproduce a debugging session across systems. I know this firsthand because before I found proper tooling I was doing all of this with a Python script I'd manually edit every time I needed to test something different.

This project closes that gap directly inside API Dash. One tool, all four protocols, the same UX.

## 3.2 Existing Codebase Grounding

Before writing any proposal I spent time actually reading the codebase to find where protocol support would need to plug in. Three files are the key extension points:

- `packages/better_networking/lib/models/http_request_model.dart` — where the existing HTTP request model lives. New protocol models need to follow the same pattern rather than extending this one, which was the root cause of failure in previous MQTT and WebSocket PRs.
- `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart` — where API type switching decides which editor to render. This is where new protocol panes get routed in.
- `lib/providers/collection_providers.dart` — where `sendRequest()` orchestrates execution. This is where the protocol router hooks into the existing flow without breaking HTTP.

I also searched all `APIType` switch callsites across the codebase to map every place that needs updating when a new protocol is added, not just the obvious ones.

## 3.3 Proposed Architecture Extension

The core decision here is to not touch the existing HTTP abstractions at all. Previous PRs that tried to reuse `HttpRequestModel` for WebSocket and MQTT ended up breaking things or losing state — the models have fundamentally different shapes and lifecycles. Each protocol gets its own dedicated model instead:

- `WebSocketRequestModel`
- `MqttRequestModel`
- `GrpcRequestModel`

Execution routes through a clean dispatch chain:
```
RequestExecutor → ProtocolRouter → ProtocolHandler
```

HTTP hits the existing pipeline unchanged. Every new protocol hits its own handler, with its own state machine and validation logic, completely isolated from the others.

Four design goals drove every decision here:

- **Isolation** — protocol-specific state and validation lives in its own model, not bolted onto HTTP abstractions
- **Non-regression** — existing HTTP, REST, and GraphQL workflows are untouched by any of this
- **Incremental delivery** — the architecture slices cleanly into small PRs: routing baseline first, then one protocol at a time
- **Extensibility** — adding a fourth protocol in the future means adding a new handler, not rearchitecting the existing ones

![](https://github.com/user-attachments/assets/c2933c78-806e-48c6-968e-36a3995bdef6)

## 3.4 WebSocket Module

The WebSocket module is the most complete of the three in the PoC. Here's what it covers:

### 3.4.1 Transport and Connection Behavior

- `ws://` and `wss://` support with TLS certificate introspection
- Custom headers and query parameters on the handshake request
- Explicit connection lifecycle — connecting, connected, reconnecting, disconnected, error each with appropriate controls enabled or disabled
- Reconnect policies with exponential backoff
- Keepalive with ping/pong visibility in the message timeline

### 3.4.2 Message Handling

- Send and receive text, JSON, and binary payloads
- Timeline view with sent/received direction indicators, sequence numbers, timestamps, and payload size
- Binary-safe rendering with configurable decoder (UTF-8, hex, base64)
- Search and filter across the message timeline

### 3.4.3 Advanced Tooling

- Decoder pipeline — upload a Protobuf descriptor, FlatBuffers schema, or Avro schema to decode binary messages automatically
- Session export and import in JSONL format for reproducible debugging
- Replay controls — replay sent-only or full session, with speed and jitter controls
- Transport diagnostics — TLS subject, issuer, fingerprint, validity window, frame-level metrics

### 3.4.4 Persistence

- Draft connection options saved with request state — reopening a request restores your last URL, headers, and settings
- Session metadata captured for history — duration, message count, connection status, error summary

> All advanced tooling lives behind a toggle so the default view stays clean.

## 3.5 MQTT Module

### 3.5.1 Broker Connectivity

- Broker host/port with TLS toggle (`mqtts://`)
- Client ID, username/password auth
- Connection status that actually tells you what went wrong, CONNACK return codes mapped to human-readable messages (identifier rejected, bad credentials, not authorized) instead of a generic "connection refused"
- Protocol version selector (3.1.1 / 5.0), keep-alive interval, and clean session controls
- Live status bar showing connection state, message counts, throughput, latency, and last message time at a glance

### 3.5.2 Pub/Sub Workflows

- Publish to any topic with QoS (0 at-most-once, 1 at-least-once, 2 exactly-once) and retain flag — with payload templates for quick JSON scaffolding
- Dynamic subscribe and unsubscribe — add topics with individual QoS levels, remove them without reconnecting, active subscriptions shown with live per-topic message rate
- Topic-filtered message stream on the right pane — filter by type (SUB/PUB), search by content, each message shows topic, payload, QoS badge, size, and timestamp
- "Use last sent" shortcut to quickly republish the previous payload

### 3.5.3 Diagnostics and Replay

- Live status strip — msgs/s, sent count, recv count, throughput in B/s, latency, connect attempts, time since last message
- Session export and import in JSONL format
- Deterministic replay with speed scaling and seeded jitter for reproducing timing-sensitive bugs
- All replay and advanced controls grouped behind an Advanced toggle to keep the default view clean

### 3.5.4 Scope Note

The primary target is a stable, reliable MQTT workflow — connect, publish, subscribe, debug, replay. Broker-specific edge cases and extended protocol tuning will be tracked as follow-up work after the core lands.

## 3.6 gRPC Module

### 3.6.1 Discovery and Schema Handling

- **Reflection-first** — connect to any gRPC server with reflection enabled and the Service Explorer populates automatically. No `.proto` file needed. Services and methods browse instantly from the left panel.
- **`.pb` descriptor import** as fallback for production servers with reflection disabled, simpler and more reliable than maintaining a proto text parser
- Service/method tree maps directly to the request builder, selecting a method generates the correct form fields from the descriptor at runtime

One non-obvious thing I ran into while building this: the reflection RPC itself is a bidi-streaming call. When it finishes and the stream closes, some servers respond with an HTTP/2 `GOAWAY` that kills the entire shared channel, so the actual RPC call right after reflection would fail with a connection error. The fix is a **separate ephemeral channel** for reflection only, shut down cleanly after discovery, then a fresh channel for real calls. That's now baked into the architecture.

### 3.6.2 Invocation Workflows

- Connection target with TLS toggle and metadata (gRPC headers) per call
- Request builder in two modes — **Form Mode** (typed fields generated from the descriptor,
  with correct input types for string/bool/enum/bytes/nested messages) and **JSON Mode** for
  power users
- All four call types supported: Unary, Server Streaming, Client Streaming, Bidirectional
- Response pane shows body, headers, trailers, and a timeline — each streaming message
  rendered as a separate timestamped card
- Invoke gating — the Invoke button stays disabled until both connection and descriptor are
  ready, preventing invalid execution states

### 3.6.3 Encoding/Decoding Strategy

No generated stubs — API Dash doesn't have compiled `.proto` files at runtime. The dynamic encoder handles all 15 protobuf field types directly from the descriptor:

- **Varints** (wire type 0): int32, uint32, sint32/64 with ZigZag, bool, enum
- **Fixed-width** (wire types 1 & 5): float, double, fixed32/64, sfixed32/64
- **Length-delimited** (wire type 2): string, bytes, nested messages

Wire type correctness matters here — a wrong wire type corrupts the length prefix and every field after it becomes garbage. The encoder writes raw `ByteData` directly rather than trying to use the `protobuf` package's `CodedBufferWriter` (which is designed for generated code, not dynamic use).

---

## 3.7 ConnectRPC Direction (Stretch)

ConnectRPC support is a stretch goal, explicitly deferred until core protocol stability lands. The approach would layer through existing HTTP service primitives with protocol-specific envelope and header handling, reusing the gRPC editor path. If core delivery finishes ahead of schedule this gets picked up, otherwise it becomes a post-GSoC follow-up PR.

---

## 3.8 UI/UX Integration Plan

All three protocol panes follow the same conventions API Dash already uses:

- **Compact default surface** — the view you see on open shows only what you need to make a
  connection and send a message
- **Advanced options behind toggles** — replay controls, decoder uploads, diagnostics,
  extended settings all hidden until you need them
- **Timeline/log first** — the response pane leads with the message stream, not metadata
- **Safe state transitions** — controls enable and disable based on connection state.
  You can't send before connecting, can't subscribe before the broker confirms, can't invoke
  before the descriptor is loaded
- **Consistent across protocols** — same connect/send/log/replay pattern on every pane so
  switching protocols doesn't require relearning the UI

### MQTT Pane

Three-panel layout — connection and topics on the left, publish controls in the center, live message stream on the right. The status bar across the top shows connection state, message counts, throughput, and latency at all times so you never have to dig for it. Advanced replay, import/export, and extended broker settings live behind an Advanced toggle and don't clutter the default view.

### WebSocket Pane

URL bar at the top, message timeline in the center, send box at the bottom — the same mental model as a chat client because that's what makes sense for a bidirectional stream. Sent and received messages are visually distinct. Filters and search sit above the timeline. Transport diagnostics (TLS cert info, frame metrics, sequence gaps) and decoder/replay controls are behind a Hide/Show advanced toggle so they're one click away but not always in your face.

### gRPC Pane

Service Explorer on the left for browsing discovered services and methods. Request Builder in the center with Form Mode and JSON Mode, generated directly from the runtime descriptor. Response pane on the right showing body, headers, trailers, and a per-message timeline for streaming calls. Reflection and `.pb` import controls are in the Service Explorer panel — where you'd naturally look when setting up a connection, not buried in settings.

## 3.9 History and Persistence Strategy

HTTP requests have a clean request/response pair, easy to store. Protocol sessions don't. A WebSocket session might run for twenty minutes and exchange thousands of messages. Storing everything by default would bloat history fast and make it unusable.

The approach is lightweight summary metadata per session:

- session duration
- message counts (sent/received)
- final connection status
- error summary if it ended badly
- reference to the exported JSONL file if the session was explicitly saved for replay

Full payload history is opt-in via export, not automatic. This keeps the history sidebar useful, you can see at a glance what happened in a session without loading the entire message log, and lets users decide for themselves when a session is worth keeping in full.

Draft connection options (URL, headers, broker settings, last payload) are persisted with the request state so reopening a request puts you back where you were.

## 3.10 Testing Strategy

Testing is staged by milestone — unit tests land with each feature PR, not saved for the end. The goal is to catch regressions at the PR level, not during a final stabilization sprint.

### Unit Tests

The boring but essential layer — protocol models, parser/serializer transforms, provider state transitions, and invalid-input handling. These run fast and catch the class of bugs that are hardest to spot in a running app: wrong field defaults, serialization edge cases, state machine transitions that skip a step.

### Widget Tests

Pane-level interactions — connect button enables and disables at the right times, advanced panel shows and hides correctly, inline validation errors appear and clear on user input, disabled states actually prevent actions. These exist because a lot of subtle UX bugs only show up when you simulate real interaction sequences.

### Integration Tests

End-to-end flows against real test servers:
- WebSocket echo endpoints for send/receive round-trips and reconnect behavior
- Public MQTT test brokers (broker.hivemq.com) for publish/subscribe workflows
- gRPC sample services (grpcb.in) for both reflection-enabled and descriptor-import paths

### Regression Safety

Every protocol PR runs the existing REST, GraphQL, and AI workflow tests before merge. Editor switching and history behavior get explicit checks — these are the two surfaces most likely to silently break when new protocol routing is added.

## 3.11 Reliability and Risk Management

Four risks worth being honest about upfront, and what I'm doing about each:

**1. Transport edge cases**
WebSocket fragmentation, MQTT broker quirks, gRPC servers that send `GOAWAY` after reflection — these don't show up in happy-path testing. Mitigation is staged rollout with protocol-specific diagnostics built in from day one, not added later. If something breaks silently, the diagnostics surface should tell you where.

**2. UI complexity growth**
Three new protocol panes is a lot of surface area. The risk is that each one slowly accumulates controls until the default view is overwhelming. Mitigation is the Advanced toggle pattern applied consistently — high-frequency controls always visible, everything else hidden until needed. This is enforced at the design level, not just aspirationally.

**3. State migration and regression risk**
Adding new fields to protocol models means older persisted sessions might be missing those fields on load. I hit this during PoC development — hot reload would create stale state objects that crashed on newly added non-null fields. Mitigation is defensive defaults everywhere: nullable counters with `?? 0` fallbacks, backward-safe model evolution, and migration checks before each protocol merge.

**4. Over-scoping**
Three protocols in twelve weeks is ambitious. The risk is trying to do too much on each and shipping none of them properly. Mitigation is a hard core/stretch boundary — unary gRPC before streaming, stable MQTT before MQTT v5, working WebSocket before advanced decoder pipelines. Stretch items are real planned work, not vague aspirations, but they don't block core delivery.

### 3.11.1 Feature and Implementation Tradeoffs

This project is intentionally designed around explicit tradeoffs so the implementation stays practical, reviewable, and shippable within GSoC timelines.

1. **Breadth (3 protocols) vs depth (one protocol with many advanced features)**
	 - Decision: deliver production-usable core workflows for WebSocket, MQTT, and gRPC first.
	 - Benefit: API Dash becomes a true multi-protocol client.
	 - Tradeoff: some advanced features (for example, richer codec/plugin pipelines or expanded gRPC streaming helpers) may remain stretch items.

2. **Stable UX consistency vs protocol-specific flexibility**
	 - Decision: keep pane structure and controls consistent across protocols (connect/send/log/replay), while exposing protocol-specific controls in advanced sections.
	 - Benefit: lower user learning curve and easier maintenance.
	 - Tradeoff: protocol power users may need one extra click for advanced controls.

3. **Compact default UI vs feature discoverability**
	 - Decision: place heavy options (codec uploads, replay controls, import/export, extended MQTT settings) behind Advanced toggles.
	 - Benefit: avoids editor clutter and layout instability.
	 - Tradeoff: discoverability of advanced capabilities is slightly reduced; mitigated with labels/tooltips and docs.

4. **WebSocket low-level diagnostics vs implementation complexity**
	 - Decision: retain useful transport/TLS diagnostics and sequence tracking in service/provider layers.
	 - Benefit: better debugging for real production socket issues.
	 - Tradeoff: service internals become more complex and require stronger test coverage and refactoring discipline.

5. **MQTT operational completeness vs initial simplicity**
	 - Decision: prioritize practical MQTT session flows (connect/publish/subscribe/unsubscribe/history/replay) over broker-specific edge-case tuning.
	 - Benefit: reliable day-to-day MQTT usage lands sooner.
	 - Tradeoff: some specialized broker behaviors and performance tuning knobs are deferred.

6. **gRPC reflection-first onboarding vs guaranteed compatibility**
	 - Decision: support reflection and descriptor-driven workflows in a single editor path.
	 - Benefit: easier service exploration and method discovery for most users.
	 - Tradeoff: reflection-disabled environments need stronger manual descriptor handling and validation paths.

7. **Replay fidelity vs storage/runtime cost**
	 - Decision: persist protocol events and support JSONL import/export for reproducible replay.
	 - Benefit: deterministic debugging and sharable sessions.
	 - Tradeoff: larger histories increase disk usage and replay orchestration complexity; mitigated by filtering and bounded retention defaults.

8. **Strong model typing vs migration effort**
	 - Decision: extend protocol request/session models explicitly instead of loosely typed payload blobs.
	 - Benefit: safer state transitions and easier long-term maintainability.
	 - Tradeoff: migration/model-update overhead increases in the short term.

9. **Delivery speed vs test depth**
	 - Decision: stage tests by milestone (unit -> widget -> integration) and enforce regression checks before each protocol merge.
	 - Benefit: better release confidence and lower regression risk.
	 - Tradeoff: slower short-term iteration during feature spikes.

10. **Ambitious scope vs predictable execution**
	 - Decision: keep strict core/stretches boundaries and publish milestone-level acceptance criteria.
	 - Benefit: mentors can evaluate progress objectively and unblock quickly.
	 - Tradeoff: attractive but non-critical enhancements may be postponed to post-GSoC follow-up PRs.

## 3.12 Deliverables Summary

**Core**
1. Protocol-specific request models and routing integration
2. WebSocket request/editor/provider/service workflow
3. MQTT request/editor/provider/service workflow
4. gRPC request/editor/provider/service workflow
5. Session/history/replay integrations for practical debugging
6. Test coverage and documentation updates

**Stretch**
1. ConnectRPC bridging in gRPC editor path
2. Extended streaming invocation modes
3. Additional decoder/plugin workflows where applicable

## 3.13 Why I Can Execute This

I already have:

- idea-level architecture submitted,
- protocol-focused PoC implementation experience,
- accepted/open issue-driven API Dash contribution record,
- and practical familiarity with model/provider/UI integration patterns in the repository.

This reduces onboarding risk and increases delivery predictability.

## 3.14 POC Engineering Report (Deep Technical)

This section documents the PoC implementation as an engineering artifact: what was built, how it was built, where it was built in code, and what failures were encountered and resolved.

### 3.14.1 PoC Scale and Scope

The PoC branch was intentionally broad and exploratory, resulting in a very large diff profile (approximately **24,000+ lines added** and **2,000+ lines removed** across protocol UIs, providers, models, and services).

This size was driven by:

1. Three protocol surfaces implemented in parallel (WebSocket, MQTT, gRPC).
2. Additional reliability instrumentation and transport diagnostics.
3. Persistence/history model updates.
4. Replay/export/import and advanced tooling UX.
5. Migration/hardening fixes discovered only under runtime/hot-reload conditions.

### 3.14.2 Libraries and Runtime Components Used

Core dependencies and protocol ecosystem used in PoC implementation:

- `flutter_riverpod`: protocol session state orchestration.
- `better_networking` package models/services: shared request model ecosystem.
- `package:grpc`: gRPC invocation layer.
- generated reflection + descriptor artifacts:
	- `lib/generated/grpc/reflection/v1alpha/reflection.pb.dart`
	- `lib/generated/grpc/reflection/v1alpha/reflection.pbgrpc.dart`
	- `lib/generated/google/protobuf/descriptor.pb.dart`
- `dart:io` socket primitives (`Socket`, `SecureSocket`) for deep WebSocket transport introspection.
- JSONL import/export pattern for replay datasets.

### 3.14.3 Exact Code Surfaces Implemented in the PoC

#### A) WebSocket implementation surfaces

- UI/editor: `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane_websocket.dart`
	- advanced tools toggle: `_showAdvancedTools`
	- replay state: `_replayEntries`, `_isReplayRunning`, `_replaySpeed`, `_replayProgressIndex`
	- import/export + replay actions integrated into advanced control surface

- Provider/state: `lib/providers/websocket_providers.dart`
	- session state machine and reconnect/keepalive controls
	- telemetry counters, sequence gap counters, and transport diagnostics ingestion

- Service/transport: `lib/services/websocket_service.dart`
	- low-level transport diagnostics fields: `tlsSubject`, `tlsIssuer`, `tlsSha1`, `tlsValidFrom`, `tlsValidTo`
	- explicit frame parsing/draining path for deeper protocol visibility
	- close/ping/pong/compression/fragmentation-aware metrics emission

- Model updates: `packages/better_networking/lib/models/websocket_request_model.dart`
	- truncated payload metadata fields for oversized message handling

#### B) MQTT implementation surfaces

- UI/editor: `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane_mqtt.dart`
	- advanced controls parity with WebSocket:
		- `_showAdvancedTools`
		- `_exportMqttSessionJsonl()`
		- `_importMqttSessionJsonl()`
		- `_startReplay(MqttNotifier notifier)`
	- replay speed/jitter/seed controls and progress counters

- Provider/state: `lib/providers/mqtt_providers.dart`
	- session model: `MqttSessionState`
	- telemetry counters:
		- `publishedCount`
		- `receivedCount`
		- `rollingMessagesPerSec`
		- throughput/last-message timestamps
	- connect/subscribe/publish/disconnect state transitions

- Service layer: `lib/services/mqtt_service.dart`
	- broker interaction abstraction consumed by notifier/provider

#### C) gRPC implementation surfaces

- UI/editor: `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane_grpc.dart`
	- reflection-aware capability checks and fallback UX
	- metadata editor toggles and per-call metadata map support (`_metadata`)
	- invoke gating by connection and descriptor readiness

- Service layer: `lib/services/grpc_service.dart`
	- native reflection imports and descriptor graph processing
	- descriptor cache keyed by endpoint
	- reflection-first discovery with proto-upload-required fallback

### 3.14.4 How the PoC Was Built (Implementation Phases)

#### Phase 1: Protocol editor scaffolding and routing integration

- Added protocol-specific panes and base provider/service hooks.
- Established state-machine style session structures so each protocol could evolve independently.
- Ensured API type switching could route to dedicated protocol workflows.

#### Phase 2: WebSocket depth-first implementation

- Implemented message timeline and connection controls first.
- Added advanced tooling (decoder upload/plugin hooks, JSONL import/export, replay).
- Expanded into low-level transport diagnostics (TLS metadata, frame-level metrics, fragmentation/compression counters).

#### Phase 3: MQTT feature parity and replay tooling

- Implemented broker connect/publish/subscribe flow.
- Added telemetry strips and rolling rate calculations.
- Added replay/import/export controls with pause/resume/speed/jitter.
- Aligned advanced panel behavior with WebSocket for UI consistency.

#### Phase 4: gRPC discovery and invocation path hardening

- Reflection-first discovery path.
- Descriptor fallback handling in UI flow.
- Metadata controls and invoke gating to avoid invalid execution states.

#### Phase 5: Runtime stabilization and regression hardening

- Fixed compile-time model generation mismatches.
- Fixed runtime hot-reload and provider state migration issues.
- Fixed narrow-pane overflow and advanced-control layout collisions.

### 3.14.5 Concrete Problems Encountered While Building and How They Were Fixed

#### Problem 1: Freezed/model mismatch after adding protocol-related fields

- **Symptom:** compile errors in history/request model implementations after field changes.
- **Root cause:** Freezed class declarations and generated artifacts became inconsistent during model evolution.
- **Fix:** converted affected models to proper abstract + mixin style and regenerated code.
- **Result:** generated code aligned; compile errors cleared.

#### Problem 2: WebSocket subscription type crash at runtime during dispose

- **Symptom:** runtime type error similar to `_ControllerSubscription<Object?>` not matching expected typed subscription during disposal.
- **Root cause:** overly specific subscription field generic did not match runtime stream subscription type in low-level flow.
- **Fix:** relaxed internal subscription field type to avoid runtime cast trap and keep disposal safe.
- **Files touched:** WebSocket service layer.

#### Problem 3: MQTT null subtype crashes after hot reload

- **Symptom:** nullable/runtime subtype failures in metrics widgets when reading newly introduced non-null counters.
- **Root cause:** hot-reload/session migration path created older state objects lacking newly added fields.
- **Fix:** defensive nullable counter strategy with `?? 0` fallback in state copy/update math and UI derived values.
- **Files touched:** MQTT provider + MQTT metrics UI.

#### Problem 4: MQTT stream pane RenderFlex overflow

- **Symptom:** overflow in narrow pane due to replay control rows.
- **Root cause:** fixed-width row layout in constrained width.
- **Fix:** changed controls to wrapping/adaptive layout and moved advanced controls behind a toggle panel.
- **Result:** compact default UI and no overflow under narrow constraints.

#### Problem 5: Advanced controls consuming too much editor space

- **Symptom:** replay/import/export controls crowded primary pane.
- **Root cause:** controls were always visible in stream panel.
- **Fix:** adopted WebSocket-style advanced toggle pattern for MQTT (`Advanced` / `Hide advanced`) and conditional panel rendering.

#### Problem 6: WebSocket low-level diagnostics compile/runtime edge cases

- **Symptom:** compile errors around const usage/type conversion/decode arguments during deep transport rewrite.
- **Root cause:** API signature and typing mismatches while replacing high-level channel behavior with low-level socket flow.
- **Fix:** iterative compile error resolution and validation; normalized type conversions for diagnostics outputs.

### 3.14.6 Representative Technical Patterns Implemented

#### Pattern A: Defensive state evolution for runtime-safe hot reload

- Nullable counters in session state where backward compatibility is needed.
- Provider update paths convert null legacy values into deterministic defaults.

#### Pattern B: Replay engine controls for reproducible debugging

- Imported session log converted into replay entries.
- Replay state machine includes:
	- run token,
	- progress index/total,
	- pause/resume,
	- speed scaling,
	- seeded jitter for deterministic delay perturbation.

#### Pattern C: Advanced tooling ergonomics

- Keep high-frequency controls in primary pane.
- Move low-frequency diagnostic/replay operations into advanced toggles.
- Preserve one-click visibility while minimizing persistent visual noise.

### 3.14.7 Why the PoC Diff Became Very Large and How Productionization Will Be Controlled

The PoC was intentionally exploratory — three protocols in parallel, runtime failures to debug, architecture decisions to validate. A 24k-line diff is the right output for that phase. It would be the wrong way to merge it.

Productionization happens in 8 focused PRs:

1. Model and routing baseline
2. WebSocket core
3. WebSocket advanced diagnostics/replay
4. MQTT core
5. MQTT advanced/replay
6. gRPC discovery/invoke
7. Persistence/history
8. Stabilization + tests

Each PR is reviewable on its own. No reviewer overload, no big-bang merge risk.

### 3.14.8 Additional Technical References

Primary proposal and idea grounding files:

- `doc/proposals/2026/gsoc/idea_alaotach_grPC_MQTT_Websocket_Integration.md`
- `doc/proposals/2026/gsoc/application_aryan_mishra_multi_protocol_support.md`

Key implementation surfaces referenced above:

- `lib/services/websocket_service.dart`
- `lib/providers/websocket_providers.dart`
- `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane_websocket.dart`
- `lib/providers/mqtt_providers.dart`
- `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane_mqtt.dart`
- `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane_grpc.dart`
- `lib/services/grpc_service.dart`

PoC validation artifacts:

- PR: [foss42/apidash#1473](https://github.com/foss42/apidash/pull/1473)
- Demo video: [POC walkthrough](https://drive.google.com/file/d/1ufOMtceT_AyjXEdzWkwdhDEFOvwThADI/view?usp=sharing)

This section is intentionally technical so mentors can clearly evaluate implementation realism, risk visibility, and execution readiness.

### 3.14.9 Visual Implementation Artifacts

#### Protocol Editor Implementations

![](https://github.com/user-attachments/assets/abb7316d-e406-4843-86de-34c9c03bd773)

![](https://github.com/user-attachments/assets/890cc5cf-ea3e-49d2-ad37-0d8a03f43464)

![](https://github.com/user-attachments/assets/79ad9dfd-585e-4bdf-b6b4-257e269ad50b)

![](https://github.com/user-attachments/assets/e79179f7-8ef8-4f4e-bd2f-41c0a6d3ca17)

![](https://github.com/user-attachments/assets/07dcfd10-ec0f-4f58-bf65-f0853edd60c9)

![](https://github.com/user-attachments/assets/a8df388b-9383-4e84-a54d-46c14cb0dbd2)

## 3.15 PoC Completion Gap: What Is Not Done Yet and What Will Be Done During GSoC

This subsection explicitly captures the gap between the current PoC state and the final production-quality deliverables planned for GSoC.

### 3.15.1 What is not fully done in the PoC yet

1. **Production PR slicing is incomplete**
	- Current PoC evolved as a large exploratory branch and still needs to be split into tightly scoped, review-friendly pull requests.

2. **Automated test coverage is not complete for all protocol paths**
	- Core runtime behavior was validated through iterative manual testing and diagnostics.
	- Full unit/widget/integration coverage for all newly added protocol interactions is still pending.

3. **gRPC deep streaming maturity is not fully complete**
	- Unary and primary invocation paths are the focus of current stability.
	- Client-streaming and bidirectional-streaming require dedicated production hardening and broader test fixtures.

4. **ConnectRPC path is not completed**
	- It is designed as a stretch direction and intentionally deferred until core protocol stability lands.

5. **Long-run stress and soak reliability testing is pending**
	- Reconnect loops, long session replay, and high-volume message streams still require systematic stress benchmarks.

6. **Final documentation package is not complete yet**
	- User guides, developer extension notes, and protocol troubleshooting docs must be completed to production quality.

7. **Compatibility/migration hardening for all persisted states is not finished**
	- Additional backward-compatibility checks for older stored sessions and metadata are planned.

### 3.15.2 What will be done during GSoC to close the gap

1. **Convert monolithic PoC into structured milestone PRs**
	- Router/model baseline PR.
	- WebSocket core PR.
	- WebSocket diagnostics/replay PR.
	- MQTT core PR.
	- MQTT advanced/replay PR.
	- gRPC discovery/invoke PR.
	- Persistence/history PR.
	- Stabilization/tests/documentation PR.

2. **Complete protocol-specific automated testing matrix**
	- Unit tests for request models, provider state transitions, validation guards, and serialization behavior.
	- Widget tests for pane controls, advanced toggles, disabled states, and error rendering.
	- Integration tests against WebSocket echo endpoints, MQTT brokers, and gRPC discovery/invoke scenarios.

3. **Finalize gRPC roadmap incrementally**
	- Stabilize unary and server-streaming behavior first.
	- Implement and validate client-streaming and bidirectional-streaming as planned stretch milestones.

4. **Implement ConnectRPC stretch integration only after core stability gates pass**
	- Reuse existing HTTP pathways with protocol-specific envelope/header handling.
	- Add targeted tests and documentation if included in final scope.

5. **Run reliability hardening and performance validation**
	- Reconnect/disconnect chaos testing.
	- Replay determinism and jitter behavior verification.
	- Narrow-layout and long-session UI stability checks.

6. **Ship complete documentation and contributor guidance**
	- End-user docs for each protocol workflow.
	- Contributor docs for architecture, extension points, and test strategy.
	- Troubleshooting matrix for protocol-specific failure modes.

### 3.15.3 Planned Refactoring of PoC Code During GSoC (Detailed)

Refactoring the current PoC code is an explicit GSoC task, not an optional cleanup pass. The goal is to preserve feature behavior while improving maintainability, testability, and long-term contributor velocity.

#### Refactoring objectives

1. Reduce monolithic service/provider/widget methods into composable units.
2. Isolate protocol business logic from UI rendering code.
3. Standardize session state transitions across WebSocket, MQTT, and gRPC.
4. Improve naming consistency, error surface clarity, and diagnostics boundaries.
5. Make critical flows easier to unit test without relying on full UI integration paths.

#### Planned refactoring scope

1. **WebSocket service and provider decomposition**
	- Split connection lifecycle, telemetry updates, and message dispatch into dedicated helpers.
	- Keep transport diagnostics handling in a dedicated diagnostics path to reduce coupling with send/receive logic.

2. **MQTT provider and pane separation of concerns**
	- Move replay/import/export orchestration out of large widget-state methods into focused controller/service utilities.
	- Keep UI state minimal and delegate protocol actions to testable provider/controller layers.

3. **gRPC editor execution path cleanup**
	- Separate discovery/descriptor resolution from invocation execution flow.
	- Keep request shaping, invocation, and response rendering as explicit pipeline stages.

4. **Cross-protocol consistency layer**
	- Align lifecycle state naming and transition semantics across protocol providers.
	- Introduce shared patterns for connection status, error reporting, and replay metadata handling where appropriate.

#### Execution approach

1. Refactor in small PRs with no intentional behavior change.
2. Add or update tests before and after each refactor slice to validate parity.
3. Use milestone-level checklists to confirm no UX regressions in protocol panes.
4. Keep each refactor PR scoped to one primary surface (service, provider, or UI pane) for reviewer clarity.

#### Measurable outcomes

1. Reduced method/class complexity in the largest protocol surfaces.
2. Increased unit-testable logic outside widget state classes.
3. Clearer ownership boundaries between protocol transport, state orchestration, and UI layers.
4. Lower review friction for follow-up feature PRs due to cleaner architecture.

### 3.15.4 Definition of done for production completion

The protocol work will be considered production-ready only when all of the following are true:

1. Each protocol has stable connect, send, receive, and disconnect behavior.
2. Advanced tooling (replay/import/export/diagnostics) is usable without layout instability.
3. Automated tests cover core and edge-case state transitions.
4. Existing REST/GraphQL/AI flows remain regression-free.
5. Documentation and demo artifacts are complete and reproducible.
6. Refactoring milestones are completed for major protocol surfaces with behavior parity validated by tests.

## 3.16 Technical Implementation Blueprint (Code-Level Proposal)

This section provides code-level architecture sketches to make implementation intent explicit and reviewable.

### 3.16.1 Protocol request contracts

```dart
enum ProtocolType { http, websocket, mqtt, grpc }

abstract class ProtocolRequestModel {
	ProtocolType get protocol;
	String get requestId;
	Map<String, dynamic> toJson();
	List<String> validate();
}

class WebSocketRequestModel implements ProtocolRequestModel {
	@override
	final ProtocolType protocol = ProtocolType.websocket;

	@override
	final String requestId;

	final Uri endpoint;
	final Map<String, String> headers;
	final List<String> subprotocols;
	final bool autoReconnect;
	final int keepAliveSec;

	WebSocketRequestModel({
		required this.requestId,
		required this.endpoint,
		this.headers = const {},
		this.subprotocols = const [],
		this.autoReconnect = false,
		this.keepAliveSec = 0,
	});

	@override
	List<String> validate() {
		final errors = <String>[];
		if (!endpoint.isScheme('ws') && !endpoint.isScheme('wss')) {
			errors.add('Endpoint must use ws:// or wss://');
		}
		if (keepAliveSec < 0) {
			errors.add('keepAliveSec cannot be negative');
		}
		return errors;
	}

	@override
	Map<String, dynamic> toJson() => {
				'requestId': requestId,
				'endpoint': endpoint.toString(),
				'headers': headers,
				'subprotocols': subprotocols,
				'autoReconnect': autoReconnect,
				'keepAliveSec': keepAliveSec,
			};
}
```

### 3.16.2 Protocol router and execution dispatcher

```dart
abstract class ProtocolHandler<T extends ProtocolRequestModel> {
	Future<void> connect(T model);
	Future<void> disconnect(String requestId);
	Stream<ProtocolEvent> events(String requestId);
}

class ProtocolRouter {
	ProtocolRouter({
		required this.wsHandler,
		required this.mqttHandler,
		required this.grpcHandler,
	});

	final WebSocketHandler wsHandler;
	final MqttHandler mqttHandler;
	final GrpcHandler grpcHandler;

	Future<void> execute(ProtocolRequestModel model) async {
		switch (model.protocol) {
			case ProtocolType.websocket:
				await wsHandler.connect(model as WebSocketRequestModel);
			case ProtocolType.mqtt:
				await mqttHandler.connect(model as MqttRequestModel);
			case ProtocolType.grpc:
				await grpcHandler.connect(model as GrpcRequestModel);
			case ProtocolType.http:
				throw UnsupportedError('HTTP handled by existing pipeline');
		}
	}
}
```

### 3.16.3 WebSocket core implementation (handshake + framing + control frames)

```dart
class WebSocketTransportCore {
	Socket? _socket;
	StreamSubscription? _subscription;
	final BytesBuilder _rxBuffer = BytesBuilder(copy: false);
	final BytesBuilder _fragmentBuffer = BytesBuilder(copy: false);
	int? _fragmentOpcode;

	final _events = StreamController<WsEvent>.broadcast();
	Stream<WsEvent> get events => _events.stream;

	Future<void> connect(WebSocketRequestModel model) async {
		final port = model.endpoint.hasPort
				? model.endpoint.port
				: (model.endpoint.scheme == 'wss' ? 443 : 80);

		_socket = model.endpoint.scheme == 'wss'
				? await SecureSocket.connect(model.endpoint.host, port)
				: await Socket.connect(model.endpoint.host, port);

		await _upgradeHandshake(model);

		_subscription = _socket!.listen(
			_onSocketChunk,
			onDone: () => _events.add(WsDisconnected()),
			onError: (e, st) => _events.add(WsError(e.toString())),
		);
	}

	Future<void> _upgradeHandshake(WebSocketRequestModel model) async {
		final nonce = base64.encode(
			List<int>.generate(16, (_) => Random.secure().nextInt(256)),
		);

		final path = (model.endpoint.path.isEmpty ? '/' : model.endpoint.path) +
				(model.endpoint.hasQuery ? '?${model.endpoint.query}' : '');

		final headers = <String, String>{
			'Host': model.endpoint.host,
			'Upgrade': 'websocket',
			'Connection': 'Upgrade',
			'Sec-WebSocket-Version': '13',
			'Sec-WebSocket-Key': nonce,
			...model.headers,
		};
		if (model.subprotocols.isNotEmpty) {
			headers['Sec-WebSocket-Protocol'] = model.subprotocols.join(', ');
		}

		final req = StringBuffer('GET $path HTTP/1.1\r\n');
		headers.forEach((k, v) => req.write('$k: $v\r\n'));
		req.write('\r\n');
		_socket!.add(utf8.encode(req.toString()));

		final raw = await _readHttpHeaderBlock(_socket!);
		final statusLine = raw.split('\r\n').first;
		if (!statusLine.contains('101')) {
			throw Exception('WebSocket upgrade failed: $statusLine');
		}

		final accept = _headerValue(raw, 'sec-websocket-accept');
		final expected = base64.encode(
			sha1
					.convert(utf8.encode('$nonce258EAFA5-E914-47DA-95CA-C5AB0DC85B11'))
					.bytes,
		);
		if (accept != expected) {
			throw Exception('Invalid Sec-WebSocket-Accept from server');
		}
	}

	void _onSocketChunk(Uint8List chunk) {
		_rxBuffer.add(chunk);
		final data = _rxBuffer.takeBytes();
		var i = 0;
		final remaining = BytesBuilder(copy: false);

		while (i + 2 <= data.length) {
			final b0 = data[i];
			final b1 = data[i + 1];
			final fin = (b0 & 0x80) != 0;
			final opcode = b0 & 0x0F;
			final masked = (b1 & 0x80) != 0;
			var len = b1 & 0x7F;
			var headerLen = 2;

			if (len == 126) {
				if (i + 4 > data.length) break;
				len = (data[i + 2] << 8) | data[i + 3];
				headerLen = 4;
			} else if (len == 127) {
				if (i + 10 > data.length) break;
				len = ByteData.sublistView(Uint8List.fromList(data.sublist(i + 2, i + 10)))
						.getUint64(0);
				headerLen = 10;
			}

			final maskLen = masked ? 4 : 0;
			final frameSize = headerLen + maskLen + len;
			if (i + frameSize > data.length) break;

			final maskStart = i + headerLen;
			final payloadStart = maskStart + maskLen;
			final payload = Uint8List.fromList(data.sublist(payloadStart, payloadStart + len));

			if (masked) {
				final mask = data.sublist(maskStart, maskStart + 4);
				for (var j = 0; j < payload.length; j++) {
					payload[j] ^= mask[j % 4];
				}
			}

			_handleFrame(fin: fin, opcode: opcode, payload: payload);
			i += frameSize;
		}

		if (i < data.length) {
			remaining.add(data.sublist(i));
		}
		_rxBuffer.add(remaining.takeBytes());
	}

	void _handleFrame({required bool fin, required int opcode, required Uint8List payload}) {
		// 0x0 continuation, 0x1 text, 0x2 binary, 0x8 close, 0x9 ping, 0xA pong
		if (opcode == 0x9) {
			_sendControl(opcode: 0xA, payload: payload); // pong
			_events.add(WsPing(payload.length));
			return;
		}
		if (opcode == 0xA) {
			_events.add(WsPong(payload.length));
			return;
		}
		if (opcode == 0x8) {
			_events.add(WsClose(payload));
			return;
		}

		if (opcode == 0x0) {
			_fragmentBuffer.add(payload);
			if (fin && _fragmentOpcode != null) {
				final merged = _fragmentBuffer.takeBytes();
				final fullOpcode = _fragmentOpcode!;
				_fragmentOpcode = null;
				_emitMessage(fullOpcode, merged);
			}
			return;
		}

		if (!fin) {
			_fragmentOpcode = opcode;
			_fragmentBuffer.clear();
			_fragmentBuffer.add(payload);
			return;
		}

		_emitMessage(opcode, payload);
	}

	void _emitMessage(int opcode, Uint8List payload) {
		if (opcode == 0x1) {
			_events.add(WsTextMessage(utf8.decode(payload, allowMalformed: true)));
		} else if (opcode == 0x2) {
			_events.add(WsBinaryMessage(payload));
		}
	}
}
```

### 3.16.4 MQTT core implementation (broker connect + subscribe + publish + updates stream)

```dart
class MqttServiceCore {
	MqttServiceCore(this._client);

	final MqttServerClient _client;
	final _events = StreamController<MqttEvent>.broadcast();
	StreamSubscription? _updatesSub;

	Stream<MqttEvent> get events => _events.stream;

	Future<void> connect(MqttRequestModel req) async {
		_client.server = req.host;
		_client.port = req.port;
		_client.logging(on: false);
		_client.keepAlivePeriod = req.keepAliveSec;
		_client.secure = req.useTls;
		_client.autoReconnect = req.autoReconnect;
		_client.resubscribeOnAutoReconnect = true;
		_client.connectionMessage = MqttConnectMessage()
				.withClientIdentifier(req.clientId)
				.startClean()
				.keepAliveFor(req.keepAliveSec)
				.authenticateAs(req.username ?? '', req.password ?? '');

		if (req.willTopic != null && req.willPayload != null) {
			_client.connectionMessage = _client.connectionMessage!
					.withWillTopic(req.willTopic!)
					.withWillMessage(req.willPayload!)
					.withWillQos(MqttQos.values[req.willQos])
					.withWillRetain();
		}

		_client.onConnected = () => _events.add(MqttConnected());
		_client.onDisconnected = () => _events.add(MqttDisconnected());
		_client.onAutoReconnect = () => _events.add(MqttReconnecting());
		_client.onAutoReconnected = () => _events.add(MqttReconnected());

		final status = await _client.connect();
		final rc = status?.returnCode;
		if (rc != MqttConnectReturnCode.connectionAccepted) {
			throw Exception(_humanReadableConnAck(rc));
		}

		_updatesSub?.cancel();
		_updatesSub = _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> batch) {
			for (final r in batch) {
				final pub = r.payload as MqttPublishMessage;
				final bytes = pub.payload.message;
				final payload = utf8.decode(bytes, allowMalformed: true);
				_events.add(MqttMessageEvent(
					topic: r.topic,
					payload: payload,
					qos: pub.variableHeader.qos.index,
					retain: pub.header.retain,
					size: bytes.length,
					timestamp: DateTime.now(),
				));
			}
		});
	}

	void subscribe(String topic, {int qos = 0}) {
		_client.subscribe(topic, MqttQos.values[qos]);
		_events.add(MqttSubscribed(topic, qos));
	}

	void publish(String topic, String payload, {int qos = 0, bool retain = false}) {
		final builder = MqttClientPayloadBuilder()..addUTF8String(payload);
		_client.publishMessage(topic, MqttQos.values[qos], builder.payload!, retain: retain);
		_events.add(MqttPublished(topic, payload.length, qos, retain));
	}

	String _humanReadableConnAck(MqttConnectReturnCode? rc) {
		switch (rc) {
			case MqttConnectReturnCode.identifierRejected:
				return 'Identifier rejected by broker';
			case MqttConnectReturnCode.badUsernameOrPassword:
				return 'Bad username/password';
			case MqttConnectReturnCode.notAuthorized:
				return 'Not authorized';
			default:
				return 'Connection rejected: $rc';
		}
	}
}
```

### 3.16.5 gRPC core implementation (reflection stream + descriptor graph + dynamic invoke)

```dart
class GrpcServiceCore {
	static final Map<String, Map<String, FileDescriptorProto>> _descriptorCache = {};

	Future<Map<String, FileDescriptorProto>> loadDescriptorsViaReflection({
		required String host,
		required int port,
		required bool useTls,
	}) async {
		final key = '$host:$port:${useTls ? 'tls' : 'plain'}';
		final cached = _descriptorCache[key];
		if (cached != null) return cached;

		final channel = ClientChannel(
			host,
			port: port,
			options: ChannelOptions(
				credentials:
						useTls ? const ChannelCredentials.secure() : const ChannelCredentials.insecure(),
			),
		);

		final stub = ServerReflectionClient(channel);
		final reqController = StreamController<ServerReflectionRequest>();
		final resStream = stub.serverReflectionInfo(reqController.stream);

		final files = <String, FileDescriptorProto>{};
		reqController.add(ServerReflectionRequest()..listServices = '');

		await for (final res in resStream) {
			if (res.hasListServicesResponse()) {
				for (final svc in res.listServicesResponse.service) {
					reqController.add(
						ServerReflectionRequest()..fileContainingSymbol = svc.name,
					);
				}
				continue;
			}
			if (res.hasFileDescriptorResponse()) {
				for (final raw in res.fileDescriptorResponse.fileDescriptorProto) {
					final fd = FileDescriptorProto.fromBuffer(raw);
					files[fd.name] = fd;
				}
			}
		}

		await reqController.close();
		await channel.shutdown();
		_descriptorCache[key] = files;
		return files;
	}

	Future<GrpcInvokeResult> invokeUnary({
		required ClientChannel channel,
		required DynamicMethodRef method,
		required Map<String, dynamic> json,
		required Map<String, String> metadata,
	}) async {
		final reqBytes = DynamicProtoEncoder.encode(method.inputDescriptor, json);
		final clientMethod = ClientMethod<List<int>, List<int>>(
			'/${method.serviceFullName}/${method.methodName}',
			(bytes) => bytes,
			(bytes) => bytes,
		);

		final call = channel.createCall(
			clientMethod,
			Stream.value(reqBytes),
			CallOptions(metadata: metadata),
		);

		final respFrames = await call.toList();
		final first = respFrames.isEmpty ? <int>[] : respFrames.first;
		final decoded = DynamicProtoDecoder.decode(method.outputDescriptor, first);
		return GrpcInvokeResult(decoded: decoded, trailers: call.trailers);
	}
}
```

### 3.16.6 Dynamic Protobuf encoder (wire-level core implementation)

```dart
class DynamicProtoEncoder {
	static Uint8List encode(DescriptorProto desc, Map<String, dynamic> json) {
		final out = BytesBuilder(copy: false);
		final byName = <String, FieldDescriptorProto>{
			for (final f in desc.field) f.name: f,
		};

		json.forEach((name, value) {
			final field = byName[name];
			if (field == null || value == null) return;
			_writeField(out, field, value);
		});

		return out.takeBytes();
	}

	static void _writeField(BytesBuilder out, FieldDescriptorProto f, dynamic v) {
		final wt = _wireTypeFor(f.type);
		_writeVarint(out, (f.number << 3) | wt);

		switch (f.type) {
			case FieldDescriptorProto_Type.TYPE_INT32:
			case FieldDescriptorProto_Type.TYPE_INT64:
			case FieldDescriptorProto_Type.TYPE_UINT32:
			case FieldDescriptorProto_Type.TYPE_UINT64:
			case FieldDescriptorProto_Type.TYPE_ENUM:
				_writeVarint(out, (v as num).toInt());
			case FieldDescriptorProto_Type.TYPE_SINT32:
			case FieldDescriptorProto_Type.TYPE_SINT64:
				_writeVarint(out, _zigZag((v as num).toInt()));
			case FieldDescriptorProto_Type.TYPE_BOOL:
				_writeVarint(out, (v as bool) ? 1 : 0);
			case FieldDescriptorProto_Type.TYPE_FIXED32:
			case FieldDescriptorProto_Type.TYPE_SFIXED32:
			case FieldDescriptorProto_Type.TYPE_FLOAT:
				final bd = ByteData(4);
				if (f.type == FieldDescriptorProto_Type.TYPE_FLOAT) {
					bd.setFloat32(0, (v as num).toDouble(), Endian.little);
				} else {
					bd.setUint32(0, (v as num).toInt(), Endian.little);
				}
				out.add(bd.buffer.asUint8List());
			case FieldDescriptorProto_Type.TYPE_FIXED64:
			case FieldDescriptorProto_Type.TYPE_SFIXED64:
			case FieldDescriptorProto_Type.TYPE_DOUBLE:
				final bd = ByteData(8);
				if (f.type == FieldDescriptorProto_Type.TYPE_DOUBLE) {
					bd.setFloat64(0, (v as num).toDouble(), Endian.little);
				} else {
					bd.setUint64(0, (v as num).toInt(), Endian.little);
				}
				out.add(bd.buffer.asUint8List());
			case FieldDescriptorProto_Type.TYPE_STRING:
				final b = utf8.encode(v as String);
				_writeVarint(out, b.length);
				out.add(b);
			case FieldDescriptorProto_Type.TYPE_BYTES:
				final b = v as List<int>;
				_writeVarint(out, b.length);
				out.add(b);
			case FieldDescriptorProto_Type.TYPE_MESSAGE:
				final nested = encode(_resolveNestedDescriptor(f), v as Map<String, dynamic>);
				_writeVarint(out, nested.length);
				out.add(nested);
			default:
				throw UnsupportedError('Unsupported protobuf type: ${f.type}');
		}
	}

	static void _writeVarint(BytesBuilder out, int value) {
		var n = value;
		while (true) {
			if ((n & ~0x7F) == 0) {
				out.add([n]);
				return;
			}
			out.add([(n & 0x7F) | 0x80]);
			n = n >> 7;
		}
	}

	static int _wireTypeFor(FieldDescriptorProto_Type t) {
		switch (t) {
			case FieldDescriptorProto_Type.TYPE_FIXED64:
			case FieldDescriptorProto_Type.TYPE_SFIXED64:
			case FieldDescriptorProto_Type.TYPE_DOUBLE:
				return 1;
			case FieldDescriptorProto_Type.TYPE_STRING:
			case FieldDescriptorProto_Type.TYPE_BYTES:
			case FieldDescriptorProto_Type.TYPE_MESSAGE:
				return 2;
			case FieldDescriptorProto_Type.TYPE_FIXED32:
			case FieldDescriptorProto_Type.TYPE_SFIXED32:
			case FieldDescriptorProto_Type.TYPE_FLOAT:
				return 5;
			default:
				return 0;
		}
	}
}
```

### 3.16.7 Protocol event flow into provider/UI (real integration path)

```dart
class WsNotifier extends StateNotifier<WsSessionState> {
	WsNotifier(this._service) : super(const WsSessionState());
	final WebSocketService _service;
	StreamSubscription? _sub;

	Future<void> connect(WebSocketRequestModel req) async {
		state = state.copyWith(phase: WsPhase.connecting, error: null);
		await _service.connect(req);
		state = state.copyWith(phase: WsPhase.connected);

		_sub?.cancel();
		_sub = _service.events.listen((e) {
			switch (e) {
				case WsTextMessage(:final text):
					state = state.copyWith(messages: [...state.messages, text]);
				case WsBinaryMessage(:final payload):
					state = state.copyWith(totalBytes: state.totalBytes + payload.length);
				case WsError(:final message):
					state = state.copyWith(error: message, phase: WsPhase.disconnected);
				default:
			}
		});
	}
}
```

### 3.16.8 Protocol-core hard problems and engineering decisions

1. **WebSocket transport depth vs stability**
	 - Decision: keep low-level frame parsing for diagnostics but isolate it behind service boundary to prevent UI coupling.

2. **MQTT session migration safety**
	 - Decision: provider state tolerates legacy/null fields in hot-reload and persisted-session evolution.

3. **gRPC dynamic typing without generated stubs**
	 - Decision: runtime descriptor-driven encoding/decoding instead of generated-code-only paths.

4. **Reflection availability inconsistency across servers**
	 - Decision: reflection-first with strict proto-upload fallback and explicit UI state messaging.

### 3.16.9 Code-generation and model workflow control

The proposal assumes strict model/codegen discipline whenever protocol model fields evolve:

1. Edit source model definitions.
2. Regenerate generated artifacts.
3. Re-run analyzer/tests.
4. Add migration-safe defaults for newly introduced fields.

This directly addresses one of the key failure classes observed during PoC evolution.

---

4. **Weekly Timeline: A week-wise timeline of activities that you would undertake.**

## Week 1: Community Bonding, Final Scope Lock, and Design Baseline

- Mentor alignment on core vs stretch scope.
- Finalize protocol model contracts and router interfaces.
- Confirm coding standards, PR slicing strategy, and review cadence.
- Prepare implementation checklist and risk register.

**Deliverable:** Final implementation plan and architecture notes signed off with mentors.

## Week 2: Core Protocol Routing Foundation

- Implement protocol routing skeleton in request execution path.
- Add protocol identification and dispatch layer.
- Wire minimal no-op handlers to validate architecture path.

**Deliverable:** Protocol router integrated with existing execution flow without regression.

## Week 3: WebSocket Core Transport + Base Editor

- Implement WebSocket connect/disconnect/send/receive foundation.
- Add base editor controls and message timeline.
- Add essential connection status and error handling.

**Deliverable:** Working WebSocket MVP path.

## Week 4: WebSocket Advanced Tooling and Persistence

- Add replay import/export pipeline support.
- Add advanced decoder/plugin integration path.
- Persist key connection draft options.
- Improve diagnostics and timeline metadata.

**Deliverable:** WebSocket editor with advanced tooling and reproducibility features.

## Week 5: MQTT Core Integration

- Implement broker connect/disconnect, publish, subscribe/unsubscribe.
- Add base provider/service state flow.
- Add connection states and broker error mapping.

**Deliverable:** Working MQTT end-to-end base workflow.

## Week 6: MQTT UI Refinement + Metrics + Replay

- Build protocol-friendly stream layout and topic interactions.
- Add metrics strip and message/session counters.
- Add replay/import/export controls in advanced section.
- Validate compact vs advanced UX behavior.

**Deliverable:** Full MQTT pane with practical debugging controls.

## Week 7: gRPC Discovery and Schema Path

- Integrate reflection-first discovery path.
- Add descriptor/proto fallback path.
- Build service/method mapping into UI models.

**Deliverable:** gRPC discovery flow that supports both reflection and fallback.

## Week 8: gRPC Request/Response Editor Path

- Implement method invocation workflow.
- Add metadata controls and response rendering.
- Improve error surfaces for schema/transport issues.

**Deliverable:** gRPC unary-focused, usable request/response workflow.

## Week 9: Cross-Protocol History and Session Metadata

- Add protocol session summary persistence.
- Integrate metadata into history/listing surfaces.
- Ensure safe behavior for older entries and migration defaults.

**Deliverable:** Session-aware persistence and history support across protocols.

## Week 10: Testing Sprint I (Unit + Widget)

- Add/expand unit tests for model/provider logic.
- Add widget tests for editor interactions and validation behavior.
- Fix discovered regressions.

**Deliverable:** Stable test baseline for core protocol surfaces.

## Week 11: Testing Sprint II (Integration + Reliability)

- Integration tests against live/test servers where feasible.
- Stress connection/reconnect/disconnect transitions.
- Fix runtime edge cases and improve diagnostics.

**Deliverable:** Reliability hardening and integration confidence.

## Week 12: Final Polish, Documentation, and Submission

- Final UX consistency pass.
- Update user documentation and contributor notes.
- Prepare demo artifacts and PR narrative.
- Close outstanding review comments and submit final deliverables.

**Deliverable:** Review-ready final state with docs and demo support.

### Implementation and Review Cadence

- Small, focused PRs aligned to weekly milestones.
- Clear PR descriptions with issue references and before/after behavior.
- Mandatory test evidence for each substantial change.
- Continuous mentor feedback incorporation.

---

### Expected Outcome

At project completion, API Dash will have practical multi-protocol capabilities for modern backend and real-time systems:

- WebSocket communication testing with diagnostics and replay,
- MQTT broker publish/subscribe testing with metrics and stream controls,
- gRPC schema-aware request workflows with reflection/fallback support,

while preserving API Dash’s UX quality and existing HTTP-first reliability.

---

### Additional Notes

- I am comfortable with transparent progress reporting and scope adjustments when needed.
- I will prioritize correctness and maintainability over feature inflation.
- I will collaborate closely with mentors to keep this production-focused and merge-friendly.