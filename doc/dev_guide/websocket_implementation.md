# WebSocket Implementation — Developer Guide

> **Branch:** `main` | **Date:** February 2026  
> This document explains every file that was created or modified to add basic WebSocket support to API Dash, and how all the pieces connect at runtime.

---

## Table of Contents

1. [Big-picture architecture](#1-big-picture-architecture)
2. [Dependency chain](#2-dependency-chain)
3. [Layer 1 — `better_networking` package (transport layer)](#3-layer-1--better_networking-package)
4. [Layer 2 — App providers (state layer)](#4-layer-2--app-providers-state-layer)
5. [Layer 3 — UI widgets](#5-layer-3--ui-widgets)
6. [Modified existing files](#6-modified-existing-files)
7. [Data flow walkthrough](#7-data-flow-walkthrough)
8. [Why existing REST / GraphQL / AI flows are untouched](#8-why-existing-flows-are-untouched)
9. [Known limitations / next steps](#9-known-limitations--next-steps)

---

## 1. Big-picture architecture

```
User types ws:// URL  →  presses "Connect"  →  WsConnectButton
                                                      │
                                         wsStateProvider(requestId)
                                           .notifier.connect(url)
                                                      │
                                            WebSocketManager        ← singleton
                                           (better_networking)
                                                      │
                                          web_socket_channel         ← pub package
                                            WebSocketChannel
                                                      │
                                          channel.stream.listen()
                                                      │
                                     StreamController<WsMessage>
                                    (one per requestId, broadcast)
                                                      │
                                   WsStateNotifier listens → rebuilds WsState
                                                      │
                                    WsResponsePane re-renders with new messages
```

The key design principle, learned from analysing the three previously-rejected PRs, is:

> **WebSocket lives in its own parallel lane.** It does not touch `sendRequest()`, `cancelRequest()`, `HttpClientManager`, `HttpRequestModel`, or any existing request flow. Only the `APIType` enum and a few exhaustive `switch` statements needed updating to acknowledge the new type.

---

## 2. Dependency chain

```
packages/better_networking/   ← web_socket_channel, WsMessage, WebSocketManager
         ↓  (re-exported by)
packages/genai/
         ↓  (re-exported by)
packages/apidash_core/        ← single import used in the app
         ↓
lib/  (the Flutter app)       ← providers, widgets, screens
```

Any file in `lib/` that does `import 'package:apidash_core/apidash_core.dart'` automatically gets access to `WsMessage`, `WebSocketManager` (as the global `wsManager`), and `WebSocketChannel`.

---

## 3. Layer 1 — `better_networking` package

### 3.1 `packages/better_networking/pubspec.yaml` — modified

**Change:** Added one dependency.

```yaml
dependencies:
  web_socket_channel: ^3.0.1   # ← NEW
```

`web_socket_channel` is the Flutter-team's official cross-platform WebSocket package. It handles the low-level socket, TLS, and the `ws://` / `wss://` protocol on every platform (macOS, iOS, Android, Linux, Windows, Web).

---

### 3.2 `packages/better_networking/lib/consts.dart` — modified

**Change:** Added `websocket` as item 4 of the `APIType` enum.

```dart
enum APIType {
  rest("HTTP", "HTTP"),
  ai("AI", "AI"),
  graphql("GraphQL", "GQL"),
  websocket("WebSocket", "WS");   // ← NEW

  const APIType(this.label, this.abbr);
  final String label;    // shown in the type-selector dropdown
  final String abbr;     // shown in the sidebar badge (e.g. "WS")
}
```

Every `switch (apiType)` in the codebase that does not have a wildcard case is a **compile-time exhaustive match** in Dart — the compiler immediately tells you each place that needs updating. This is the safest way to extend the enum.

---

### 3.3 `packages/better_networking/lib/models/ws_models.dart` — **NEW**

This file defines the data types that travel through the message stream.

```dart
enum WsMessageType { sent, received, error, connected, disconnected }

class WsMessage {
  final String content;
  final WsMessageType type;      // which direction / kind
  final DateTime timestamp;

  bool get isSent        => type == WsMessageType.sent;
  bool get isReceived    => type == WsMessageType.received;
  bool get isError       => type == WsMessageType.error;
  bool get isStatus      => type == WsMessageType.connected
                         || type == WsMessageType.disconnected;
}
```

`WsMessage` is intentionally a **plain Dart class** (not `freezed`). The `freezed` package is used for models that are persisted (like `HttpRequestModel`). WebSocket messages live only in memory during a session, so the simpler approach is fine and avoids running `build_runner`.

---

### 3.4 `packages/better_networking/lib/services/websocket_service.dart` — **NEW**

This is the transport layer. It mirrors the existing `HttpClientManager` pattern: a singleton keyed by `requestId`.

```
WebSocketManager (singleton)
  _channels            : Map<requestId  →  WebSocketChannel>
  _messageControllers  : Map<requestId  →  StreamController<WsMessage>>
```

**Key methods:**

| Method | What it does |
|--------|--------------|
| `messagesStream(requestId)` | Returns (or creates) a `broadcast` stream for a request. Called before `connect()` so no messages are missed. |
| `connect({requestId, url, headers, onError, onDone})` | Calls `WebSocketChannel.connect(uri)`, waits for `channel.ready` (handshake), then calls `stream.listen()`. Emits `WsMessageType.connected` / `WsMessageType.error` status messages into the stream. |
| `send(requestId, message)` | Writes to `channel.sink` and emits a `WsMessageType.sent` message so the UI can show what was sent. |
| `disconnect(requestId)` | Closes `channel.sink`. The `onDone` callback on the listener emits a `disconnected` status message. |
| `dispose(requestId)` | `disconnect` + closes the `StreamController`. Called when the notifier is disposed. |

**Why `broadcast` stream?** A `broadcast` stream allows multiple listeners (e.g., the state notifier and any future widget that wants to subscribe directly). Regular single-subscription streams would throw if a second listener attached.

**Why `await channel.ready`?** `web_socket_channel` ^3.0 exposes `channel.ready` — a `Future` that completes when the WebSocket handshake succeeds. Without `await`ing it, the channel looks open but the first `send()` call could silently fail.

---

### 3.5 Export files — modified

Three existing barrel files were updated so the new code flows up the dependency chain:

| File | Added export |
|------|-------------|
| `packages/better_networking/lib/models/models.dart` | `export 'ws_models.dart';` |
| `packages/better_networking/lib/services/services.dart` | `export 'websocket_service.dart';` |
| `packages/better_networking/lib/better_networking.dart` | `export 'package:web_socket_channel/web_socket_channel.dart';` |

---

### 3.6 `packages/better_networking/lib/utils/http_request_utils.dart` — modified

The `getRequestBody()` function had an exhaustive switch. Added the websocket case:

```dart
String? getRequestBody(APIType type, HttpRequestModel httpRequestModel) {
  return switch (type) {
    APIType.rest    => (httpRequestModel.hasJsonData || ...) ? httpRequestModel.body : null,
    APIType.graphql => getGraphQLBody(httpRequestModel),
    APIType.ai      => null,
    APIType.websocket => null,   // ← NEW — WebSocket has no HTTP body
  };
}
```

---

## 4. Layer 2 — App providers (state layer)

### 4.1 `lib/providers/ws_providers.dart` — **NEW**

This file is the bridge between the `WebSocketManager` singleton (raw streams) and Flutter/Riverpod (reactive state).

#### `WsConnectionStatus` enum

```dart
enum WsConnectionStatus { idle, connecting, connected, disconnected, error }
```

Separate from `WsMessageType` — this answers "what is the connection doing right now?" while `WsMessageType` answers "what kind of message is this?"

#### `WsState` — immutable snapshot

```dart
class WsState {
  final WsConnectionStatus status;   // drives the Connect/Disconnect button label
  final List<WsMessage> messages;    // entire chat history (in-memory only)
  final String messageInput;         // text typed in the message textarea

  bool get isConnected  => status == WsConnectionStatus.connected;
  bool get isConnecting => status == WsConnectionStatus.connecting;
  bool get canSend      => isConnected && messageInput.isNotEmpty;
}
```

`canSend` is the single source of truth for whether the **Send** button is enabled.

#### `WsStateNotifier` — the business logic

```dart
class WsStateNotifier extends StateNotifier<WsState> {
  final String requestId;
  StreamSubscription<WsMessage>? _sub;
  ...
}
```

**`connect(url)`:**
1. Sets `status = connecting`, clears old messages.
2. **Subscribes to `wsManager.messagesStream(requestId)` first** — critical ordering so the "Connecting…" status message from the manager is not missed.
3. Calls `wsManager.connect(...)`.
4. For each incoming `WsMessage`, appends it to `state.messages` and updates `status` based on the message type.

**`send()`:**
1. Guards with `state.canSend` (no-op if not connected or input empty).
2. Calls `wsManager.send(requestId, state.messageInput)`.
3. Resets `messageInput` to `''` so the textarea clears.

**`disconnect()`:** Calls `wsManager.disconnect()`, sets `status = disconnected`.

**`dispose()`:** Cancels the stream subscription and closes the channel. Riverpod calls this automatically when the last widget watching this provider is unmounted.

#### `wsStateProvider`

```dart
final wsStateProvider =
    StateNotifierProvider.family<WsStateNotifier, WsState, String>(
  (ref, requestId) => WsStateNotifier(requestId),
);
```

`.family` means the provider is **parameterised by `requestId`** — each request in the collection has its own independent `WsState`. This is the same pattern as every other `.family` provider in the app.

---

### 4.2 `lib/providers/providers.dart` — modified

Added one export so the rest of the app can import `wsStateProvider` and `WsConnectionStatus` through the single `providers.dart` barrel:

```dart
export 'ws_providers.dart';
```

---

### 4.3 `lib/providers/collection_providers.dart` — modified

The `update()` method has an exhaustive switch for converting between API types. Added the websocket arm:

```dart
newModel = switch (apiType) {
  APIType.rest || APIType.graphql => currentModel.copyWith(
      apiType: apiType, httpRequestModel: const HttpRequestModel(), ...),
  APIType.ai => currentModel.copyWith(
      apiType: apiType, httpRequestModel: null, aiRequestModel: ...),
  APIType.websocket => currentModel.copyWith(         // ← NEW
      apiType: apiType,
      httpRequestModel: const HttpRequestModel(),     // stores the ws:// URL
      aiRequestModel: null),
};
```

WebSocket re-uses `httpRequestModel` for the URL and headers — it is just a data bag. The actual connection is never made through `sendRequest()`.

---

### 4.4 `lib/models/request_model.g.dart` and `lib/models/history_meta_model.g.dart` — modified

These are `json_serializable`-generated files. They contained a `_$APITypeEnumMap` that maps each enum value to a JSON string. Without adding `websocket`, a saved WebSocket request would fail to deserialize on the next app launch.

```dart
// Both files: added websocket entry
const _$APITypeEnumMap = {
  APIType.rest: 'rest',
  APIType.ai: 'ai',
  APIType.graphql: 'graphql',
  APIType.websocket: 'websocket',   // ← NEW
};
```

> **Note:** Normally these `.g.dart` files are regenerated with `dart run build_runner build`. The entry was added manually here to avoid breaking other parts of the generated file. If you run `build_runner` in future, ensure `APIType.websocket` is annotated correctly in the source model.

---

## 5. Layer 3 — UI widgets

### 5.1 `lib/screens/home_page/editor_pane/url_card.dart` — modified

**Two changes:**

#### (a) Method-selector switches — added websocket case

The card has two `switch (apiType)` blocks (one for narrow screen, one for wide). Both previously handled only `rest`, `graphql`, `ai`, and `null`. Added:

```dart
APIType.websocket => kSizedBoxEmpty,   // no HTTP-method dropdown needed
```

#### (b) Conditional action button

The "Send" button is shown for all types. For WebSocket, the button is replaced with a **WsConnectButton**:

```dart
SizedBox(
  height: 36,
  child: apiType == APIType.websocket
      ? const WsConnectButton()     // ← NEW
      : const SendRequestButton(),
)
```

#### (c) `WsConnectButton` widget — NEW, appended to same file

```dart
class WsConnectButton extends ConsumerWidget {
  ...
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(wsStateProvider(selectedId));
    final isConnected = wsState.status == WsConnectionStatus.connected;
    final isConnecting = wsState.status == WsConnectionStatus.connecting;

    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: isConnected ? errorColor : Colors.teal,
        ...
      ),
      onPressed: isConnecting ? null : () {
        if (isConnected) {
          ref.read(wsStateProvider(selectedId).notifier).disconnect();
        } else {
          final url = /* read from httpRequestModel.url */;
          ref.read(wsStateProvider(selectedId).notifier).connect(url);
        }
      },
      child: Text(isConnecting ? 'Connecting…' : isConnected ? 'Disconnect' : 'Connect'),
    );
  }
}
```

Button states:
| `WsConnectionStatus` | Button label | Button colour | `onPressed` |
|---|---|---|---|
| `idle` / `disconnected` / `error` | Connect | Teal | calls `connect(url)` |
| `connecting` | Connecting… | Teal | `null` (disabled) |
| `connected` | Disconnect | Error red | calls `disconnect()` |

---

### 5.2 `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane_ws.dart` — **NEW**

This is the **left pane** of the editor when `apiType == websocket`. It mirrors the layout from the approved GitHub issue sketch.

**Structure:**
```
Column
 ├── TabBar  [ Message | URL Params | Headers ]
 └── Expanded TabBarView
      ├── Message tab
      │    ├── Expanded TextField  (multi-line, expands to fill)
      │    └── FilledButton.icon "Send"  (disabled when canSend == false)
      ├── URL Params tab  →  EditRequestURLParams()  (reused from REST)
      └── Headers tab     →  EditRequestHeaders()    (reused from REST)
```

**Key decisions:**
- `EditRequestURLParams` and `EditRequestHeaders` are reused directly — they read/write `httpRequestModel.params` and `httpRequestModel.headers` through the existing `collectionStateNotifierProvider`. This means WebSocket connections can carry query params (some servers use them for auth tokens) and custom headers.
- The **Send** button reads `wsState.canSend` which is `false` unless the socket is connected AND there is text typed. This prevents the common bug of trying to send before connecting.
- The `TextField` is rebuilt from the current `wsState.messageInput` on each frame — this is safe because Riverpod rebuilds are cheap, and it keeps the input value in the provider state rather than a local `TextEditingController` (which would be lost on widget rebuild).

---

### 5.3 `lib/screens/home_page/editor_pane/details_card/ws_response_pane.dart` — **NEW**

This is the **right pane** — the chat-style message history.

**Structure:**
```
Column
 ├── _WsStatusBar       (coloured dot + status label + Disconnect button)
 ├── Divider
 ├── Expanded
 │    ├── empty state   (idle / connecting / no messages text)
 │    └── ListView.builder  →  _WsMessageBubble per message
 └── Clear button       (only shown when messages is non-empty)
```

#### `_WsStatusBar`
Shows a coloured indicator dot and text label driven by `WsConnectionStatus`:
- 🟢 Green — Connected
- 🟠 Orange — Connecting…
- ⚫ Grey — Disconnected / Idle
- 🔴 Red — Error

When `connected`, also shows a "Disconnect" text button on the right side of the bar.

#### `_WsMessageBubble`
Chat-bubble styling following standard conventions (right = sent by you, left = from server):

| Message type | Alignment | Background |
|---|---|---|
| `sent` | Right | Primary colour (light tint) |
| `received` | Left | Secondary container (light tint) |
| `error` | Left | `red.shade50` with `⚠` prefix |
| `connected` / `disconnected` | Centre | Italic grey text (no bubble card) |

Each bubble shows timestamp (`HH:mm:ss`) and sender label ("You" / "Server") in a smaller font below the content.

---

### 5.4 `lib/screens/home_page/editor_pane/details_card/details_card.dart` — modified

The `EditorPaneRequestDetailsCard` previously always showed `ResponsePane` (for REST) or `DashbotTab` (for AI) on the right. Updated to choose `WsResponsePane` for WebSocket:

```dart
final rightWidget = apiType == APIType.websocket
    ? const WsResponsePane()                 // ← NEW
    : !isDashbotPopped
        ? DashbotTab()
        : codePaneVisible
            ? const CodePane()
            : const ResponsePane();
```

---

### 5.5 `lib/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart` — modified

The bottom switch that picks which request pane to render now includes websocket:

```dart
APIType.websocket => const EditWSRequestPane(),   // ← NEW
```

---

### 5.6 `lib/utils/ui_utils.dart` — modified

`getAPIColor()` drives the sidebar badge background and several other colour uses. Added:

```dart
APIType.websocket => Colors.teal,
```

---

### 5.7 `lib/widgets/texts.dart` — modified

`SidebarRequestCardTextBox` shows the abbreviated type label in the sidebar. Added:

```dart
APIType.websocket => apiType.abbr,   // renders "WS"
```

---

## 6. Modified existing files — summary table

| File | Type | Change |
|------|------|--------|
| `packages/better_networking/pubspec.yaml` | modified | Added `web_socket_channel: ^3.0.1` |
| `packages/better_networking/lib/consts.dart` | modified | Added `APIType.websocket` enum value |
| `packages/better_networking/lib/models/models.dart` | modified | Export `ws_models.dart` |
| `packages/better_networking/lib/services/services.dart` | modified | Export `websocket_service.dart` |
| `packages/better_networking/lib/better_networking.dart` | modified | Export `web_socket_channel` |
| `packages/better_networking/lib/utils/http_request_utils.dart` | modified | Added `websocket => null` to `getRequestBody()` switch |
| `lib/providers/providers.dart` | modified | Export `ws_providers.dart` |
| `lib/providers/collection_providers.dart` | modified | Added websocket arm to type-switch in `update()` |
| `lib/models/request_model.g.dart` | modified | Added `websocket: 'websocket'` to serialization map |
| `lib/models/history_meta_model.g.dart` | modified | Added `websocket: 'websocket'` to serialization map |
| `lib/utils/ui_utils.dart` | modified | `Colors.teal` for websocket in `getAPIColor()` |
| `lib/widgets/texts.dart` | modified | `apiType.abbr` ("WS") for websocket in sidebar |
| `lib/screens/.../details_card.dart` | modified | Routes websocket to `WsResponsePane` |
| `lib/screens/.../request_pane.dart` | modified | Routes websocket to `EditWSRequestPane` |
| `lib/screens/.../url_card.dart` | modified | `WsConnectButton` + websocket in method-selector switches |

| File | Type | Purpose |
|------|------|---------|
| `packages/better_networking/lib/models/ws_models.dart` | **NEW** | `WsMessageType` enum + `WsMessage` class |
| `packages/better_networking/lib/services/websocket_service.dart` | **NEW** | `WebSocketManager` singleton |
| `lib/providers/ws_providers.dart` | **NEW** | `WsState`, `WsStateNotifier`, `wsStateProvider` |
| `lib/screens/.../request_pane_ws.dart` | **NEW** | Left pane — message input + params + headers tabs |
| `lib/screens/.../ws_response_pane.dart` | **NEW** | Right pane — chat history + status bar |

---

## 7. Data flow walkthrough

### Connecting

```
1. User types   "ws://echo.websocket.org"  in URLTextField
   → writes to httpRequestModel.url via collectionStateNotifierProvider

2. User presses "Connect" (WsConnectButton)
   → reads url from collectionStateNotifierProvider.getRequestModel(id).httpRequestModel.url
   → calls wsStateProvider(id).notifier.connect(url)

3. WsStateNotifier.connect(url):
   a. state = WsState(status: connecting, messages: [])
   b. subscribes to wsManager.messagesStream(requestId)   ← BEFORE connecting
   c. calls wsManager.connect(requestId, url)

4. WebSocketManager.connect():
   a. emits WsMessage("Connecting…", connected)          ← captured by step 3b
   b. WebSocketChannel.connect(uri)
   c. await channel.ready                                 ← handshake
   d. emits WsMessage("Connected to …", connected)
   e. channel.stream.listen(…)

5. WsStateNotifier listener sees "Connected to …" message:
   state = WsState(status: connected, messages: [msg1, msg2])

6. WsConnectButton rebuilds:  label = "Disconnect"  colour = red
   _WsStatusBar rebuilds:     dot = green,  label = "Connected"
   EditWSRequestPane.Send rebuilds:  enabled   (canSend = true once user types)
```

### Sending a message

```
1. User types "ping" in the Message tab TextField
   → onChanged → wsStateProvider.notifier.updateMessageInput("ping")
   → state.messageInput = "ping"
   → state.canSend = true  → Send button becomes enabled

2. User taps Send
   → wsStateProvider.notifier.send()
   → wsManager.send(requestId, "ping")
      a. channel.sink.add("ping")              ← wire
      b. emits WsMessage("ping", sent)

3. WsStateNotifier listener appends the sent message
   → WsResponsePane rebuilds, shows bubble on the right

4. Server replies "pong"
   → channel.stream fires
   → wsManager listener emits WsMessage("pong", received)
   → WsStateNotifier appends it
   → WsResponsePane rebuilds, shows bubble on the left
```

### Disconnecting

```
1. User presses "Disconnect" (button in WsConnectButton or _WsStatusBar)
   → wsStateProvider.notifier.disconnect()
   → wsManager.disconnect(requestId) → channel.sink.close()

2. channel.stream's onDone fires:
   → wsManager emits WsMessage("Disconnected", disconnected)
   → WsStateNotifier sets status = disconnected
   → both buttons update
```

---

## 8. Why existing flows are untouched

Previous WebSocket PRs were rejected for breaking REST/GraphQL/AI behaviour. Here is exactly why that does not happen here:

1. **`sendRequest()` is never called for WebSocket.** The entire REST request lifecycle (`HttpClientManager`, `streamHttpRequest`, `isWorking`, `cancelRequest`) is bypassed. WebSocket has its own separate `wsStateProvider` and `WebSocketManager`.

2. **`httpRequestModel` is only used for storage.** WebSocket requests store their URL in `httpRequestModel.url` and their headers in `httpRequestModel.headers` — the same fields REST uses. This is purely a data-bag use; no HTTP request is ever sent.

3. **Every exhaustive switch was updated.** Dart's exhaustiveness checking caught every location that needed a websocket arm. Adding `APIType.websocket` to the enum caused compile errors at exactly the files that needed updating — nothing was guessed.

4. **Serialization is explicit.** The `.g.dart` maps were updated so existing requests saved in Hive before this change are unaffected (the map still contains `rest`, `ai`, `graphql`), and new WebSocket requests round-trip correctly as `'websocket'`.

---

## 9. Known limitations / next steps

| # | Issue | Suggested fix |
|---|-------|---------------|
| 1 | **No persistence of WS messages.** Messages live in `WsState.messages` in memory only; they are cleared when the app restarts. | Save to Hive in `WsStateNotifier`, or at least the last N messages. |
| 2 | **URL stored in `httpRequestModel`.** A proper `WsRequestModel` (like `HttpRequestModel` / `AIRequestModel`) would be cleaner. | Add `wsRequestModel` field to `RequestModel`, run `build_runner`. |
| 3 | **No binary message support.** `wsManager.send()` only sends `String`. | Check `message.runtimeType`, support `List<int>` (Uint8List) for binary frames. |
| 4 | **Headers not sent on web.** `web_socket_channel` ignores `headers` on the web platform (browser security restriction). | Document the limitation; for web, use query-param auth instead. |
| 5 | **No reconnect / ping-pong.** Long-lived connections may be silently dropped by NAT/firewalls. | Implement a keep-alive ping on a timer, and optional auto-reconnect on disconnect. |
| 6 | **`request_model.g.dart` was hand-edited.** Running `build_runner` will overwrite the `websocket` entry unless the source annotation is in place. | Add `@JsonValue('websocket')` annotation to `APIType.websocket` in `consts.dart`, then regenerate. |
| 7 | **No tests.** | Add unit tests for `WebSocketManager` (mock `WebSocketChannel`), unit tests for `WsStateNotifier`, and a widget test for `WsResponsePane`. |
