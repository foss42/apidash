# Using gRPC in API Dash

This guide explains how to use gRPC in API Dash. gRPC lets you call **methods** on a **service** running on a server — a bit like calling a function over the network — instead of hitting URLs the way plain HTTP does.

Use this page when you're working with a gRPC server: microservices, internal APIs, or any backend that exposes typed **Protocol Buffer** (Protobuf) methods over HTTP/2.

![A gRPC request open in API Dash — server address, Reflect/Send button, and the Invocation / Body / Metadata / Auth / Settings tabs](images/grpc/grpc_overview.png)

> **gRPC is different from HTTP.** Instead of sending a request to a URL and getting one response, you pick a **service** and one of its **methods**, fill in a typed request **message**, and invoke it. Messages are Protocol Buffers under the hood, but API Dash lets you write them as plain **JSON**. Every method has one of four **call types** — a single request/response, or a stream in one or both directions — and you'll see the responses arrive live.

---

## Quick start

The fastest, most reliable way to see gRPC working end to end is the **API Dash gRPC test rig**. It's a small local server that exercises every gRPC feature, so nothing depends on a flaky public endpoint.

1. Clone the [`foss42/api`](https://github.com/foss42/api) repo and start the rig from its `grpc/` folder:
   ```
   docker compose -f grpc/docker-compose.yml up --build
   ```
   This starts `apidash.test.TestService` on `localhost:9000` (plaintext, with reflection enabled).
2. In API Dash, create a new request and switch its type to **gRPC** (see "Where to find gRPC" below).
3. In the server-address field, enter:
   ```
   localhost:9000
   ```
   Note there's **no** `http://` or `grpc://` prefix — just `host:port`.
4. The URL-bar button reads **Reflect** (because you haven't picked a method yet). Click it. API Dash asks the server what it offers and fills the **Select Service** and **Select Method** dropdowns.
5. On the **Invocation** tab, pick the service `apidash.test.TestService`, then the method **`Echo`**. Leave **Type** on **Unary**.
6. Fill in the request message — in the **Request Parameters (Form)** box, or as JSON on the **Body** tab, e.g. `{"message": "Hello!"}`.
7. The URL-bar button now reads **Send**. Click it and read the echoed reply in the response pane.

That's the whole loop: set the address, discover methods, pick one, fill the message, send. Everything else in this guide builds on those steps.

> **Zero-setup alternative — `grpcb.in`.** If you don't want to run anything locally, use the public server `grpcb.in:9000` (plaintext) or `grpcb.in:9001` (TLS). It supports reflection, so **Reflect** works there too.

![The gRPC test rig connected — Echo method selected and its reply shown](images/grpc/grpc_quick_start.png)

---

## Where to find gRPC

gRPC is a request **type** in API Dash, just like a regular HTTP request. You switch a request to it rather than opening a separate screen.

1. Create a new request, or select an existing one in the sidebar.
2. Find the request type / protocol selector (the same switcher you use to pick HTTP, GraphQL, or WebSocket) and choose **gRPC**.
3. The request now switches into gRPC mode:
   - The **URL field becomes the server address** (it shows an *"Enter gRPC URL"* hint).
   - The blue action button reads **Reflect** or **Send** depending on whether you've picked a method (more on this below).
   - The request shows a **gRPC** badge in the sidebar so you can spot it at a glance.

Once you're in gRPC mode, everything you need lives in the five request tabs — **Invocation**, **Body**, **Metadata**, **Auth**, **Settings** — and the response pane.

![Sidebar showing a request with the gRPC badge](images/grpc/grpc_sidebar_badge.png)

---

## gRPC at a glance

- **Server address, not a URL.** You enter `host:port` (e.g. `localhost:9000`) — no `http://`, `ws://`, or `grpc://` scheme.
- **Services and methods.** A server hosts one or more **services**, each with named **methods** you call. You pick them from two dropdowns.
- **Two ways to discover methods.** Server **Reflection** (the **Reflect** button) asks the server what it offers; or import a **`.proto`** file for servers that don't support reflection.
- **Four call types.** Unary, server-streaming, client-streaming, and bidirectional — chosen with the **Type** selector.
- **Messages as JSON.** Protobuf request messages are written as JSON (or filled into a typed form), so you don't need compiled stubs.
- **Metadata instead of headers.** Key/value pairs sent with the call — gRPC's equivalent of HTTP headers.
- **Auth built in.** Bearer, Basic, API-key, and JWT auth, applied automatically as metadata.
- **A live response view.** Streamed messages appear in a running log; response **metadata** (initial and trailing) is shown like headers.

Each section below explains what these are, when to use them, and exactly how to use them in API Dash.

---

## The gRPC request screen

When a request is set to gRPC, the screen has a few key parts.

**The server-address field**

This is where you enter the gRPC endpoint as `host:port`, for example:

```
localhost:9000
```

The field shows the hint *"Enter gRPC URL"* when empty. Unlike HTTP or WebSocket, you do **not** add a scheme — no `http://`, `https://`, or `grpc://`. Whether the connection is encrypted is controlled by the **Use TLS** switch on the Settings tab, not by the address.

You can also use environment variables in the address, such as `{{GRPC_HOST}}`, which API Dash substitutes before connecting — handy for switching between dev and prod servers.

**The action button — Reflect vs. Send**

There's a single action button next to the address, and its label depends on your progress:

| Button reads | When | What it does |
| --- | --- | --- |
| **Reflect** | No method is selected yet | Runs **server reflection** to discover the server's services and methods and fill the dropdowns. It does **not** invoke a method. |
| **Send** | A method is selected | Invokes the selected method with your request message. |

So the natural flow is: type the address → **Reflect** to discover → pick a method → **Send** to call it.

**The five tabs**

- **Invocation** — pick the **service**, the **method**, the call **Type**, and fill the request message as a form.
- **Body** — the request message as raw **JSON** (and the Send/Finish controls for streaming calls).
- **Metadata** — key/value pairs sent with the call (gRPC's headers).
- **Auth** — Bearer / Basic / API-key / JWT, applied as metadata.
- **Settings** — port, TLS, and importing a `.proto` file.

![The gRPC request screen with the address field, Reflect button, and the five tabs](images/grpc/grpc_request_screen.png)

---

## Setting the server address

- **What it is:** the `host:port` of the gRPC server you want to call.
- **When to use it:** always — it's how API Dash knows where to connect.
- **How it works:** enter it in the main address field with **no scheme**, e.g. `localhost:9000` or `grpcb.in:9000`. If you leave the port off, API Dash defaults to `50051` (the conventional gRPC port). You can also set the port explicitly on the **Settings** tab.

Steps:
1. Make sure the request type is **gRPC**.
2. Type the address into the field, for example `localhost:9000`.
3. Turn on **Use TLS** in Settings if the server uses an encrypted endpoint (see "TLS" below).

> Tip: The port is part of the address. `grpcb.in:9000` is plaintext; `grpcb.in:9001` is the same server's TLS endpoint. Match the port to whether you've enabled TLS.

---

## Discovering methods

Before you can call anything, API Dash needs to know what **services** and **methods** the server has. There are two ways to find out.

### Option 1 — Server Reflection (the Reflect button)

- **What it is:** many gRPC servers can describe themselves at runtime through a feature called **server reflection**. API Dash asks the server "what do you offer?" and fills the dropdowns from the answer.
- **When to use it:** whenever the server supports reflection (the test rig and `grpcb.in` both do). It's the quickest path — no files needed.
- **How it works:** while no method is selected, the URL-bar button reads **Reflect**. Clicking it lists the server's services, loads the first service's methods, and marks reflection as the active source, so picking a different service or method fetches its details live from the server too. Reflection also sends your **Metadata** and **Auth**, so it works against secured servers.

Steps:
1. Enter the server address.
2. Click **Reflect**.
3. Open the **Invocation** tab and choose a service, then a method from the dropdowns.

> If reflection comes back empty, API Dash tells you **why** in the response log — for example *"Reflection failed: UNIMPLEMENTED …"* means the server doesn't have reflection enabled. In that case, use a `.proto` file instead.

![The Invocation tab after Reflect — Select Service and Select Method dropdowns populated](images/grpc/grpc_reflect.png)

### Option 2 — Import a `.proto` file (Settings → Fetch services)

- **What it is:** a Protocol Buffer definition file (`.proto`) describes a server's services and messages. If a server has reflection turned off, you can point API Dash at its `.proto` instead.
- **When to use it:** for servers **without** reflection, or when you already have the API's `.proto` on hand.
- **How it works:** you pick a `.proto` on the Settings tab and click **Fetch services**; API Dash parses it and fills the same Service/Method dropdowns.

Steps:
1. Open the **Settings** tab.
2. Next to **Proto File**, click **Select .proto** and choose your file. The path appears (it reads *"No Proto file selected"* until you do).
3. Click **Fetch services**. The services and methods load into the **Invocation** tab.
4. If you click **Fetch services** without picking a file first, API Dash reminds you to *"Select a .proto file first."*

![The Settings tab with a .proto selected and the Fetch services button](images/grpc/grpc_proto_import.png)

---

## Selecting a service and method

Open the **Invocation** tab. At the top are two dropdowns:

- **Select Service** — the service you want to call (a server can host several).
- **Select Method** — the method on that service.

When you pick a service, its methods load into the second dropdown. When you pick a method, API Dash loads that method's request fields into the **Request Parameters (Form)** below and pre-fills the **Body** tab's JSON to match — so you start from the right shape instead of a blank box.

Steps:
1. Discover methods first (Reflect, or import a `.proto`).
2. Open the **Invocation** tab.
3. Choose a **service**, then a **method**.
4. Set the call **Type** (see below) and fill in the request message.

> Once a method is selected, the URL-bar button switches from **Reflect** to **Send**.

---

## Choosing the call Type

Just below the method dropdown is a **Type** selector. gRPC has four kinds of call, and this is where you tell API Dash which one the method is.

| Type | UI label | You send | You receive |
| --- | --- | --- | --- |
| Unary | **Unary** | one message | one response |
| Server streaming | **Server streaming** | one message | a stream of responses |
| Client streaming | **Client streaming** | a stream of messages | one response |
| Bidirectional | **Bidirectional** | a stream of messages | a stream of responses |

- **What it is:** the shape of the call — whether each side sends one message or a stream.
- **When to use it:** match it to the method's definition. **Unary** is the default and the most common. On the test rig: `Echo` is unary, `StreamTicks` is server-streaming, `SumNumbers` is client-streaming, and `Chat` is bidirectional.
- **How it works:** unary and server-streaming send your one message and complete. Client and bidirectional keep the request stream **open** so you can push more messages over time (see "Streaming calls" below).

Steps:
1. On the **Invocation** tab, open the **Type** dropdown.
2. Pick the type that matches your method.

> Tip: API Dash doesn't guess the type from the method — you choose it. If a streaming method behaves oddly (e.g. only one message goes through), double-check the Type is set correctly.

![The Type selector showing Unary, Client streaming, Server streaming, and Bidirectional](images/grpc/grpc_type_selector.png)

---

## Composing the request message

There are two ways to write the request message, and they stay in sync:

**The form — Request Parameters (Form)**

- On the **Invocation** tab, below the Type selector, the **Request Parameters (Form)** box shows one row per field of the request message, with an input matched to its type: a checkbox for `bool`, a dropdown for `enum`, and a text box for everything else. Editing the form updates the JSON automatically.
- If a method takes no fields, you'll see *"No parameters defined for this method."* — that's fine; just send it.

**The JSON — Body tab**

- The **Body** tab holds the same message as raw **JSON** (hint: *"Enter request body (JSON)…"*). Use this when the message is nested or complex, or when you'd rather paste JSON than fill a form. Edits here are what gets sent.

Steps:
1. Pick your method (its fields load into both the form and the Body).
2. Fill the fields in the **Request Parameters (Form)**, or switch to the **Body** tab and edit the JSON directly, e.g. `{"message": "Hello!"}`.
3. Click **Send**.

> Tip: The form is easiest for flat messages; the Body/JSON view is better for nested messages. Whichever you use, the JSON on the Body tab is the source of truth for what's sent.

![The Invocation tab with the Request Parameters form filled in](images/grpc/grpc_request_message.png)

---

## Metadata tab

The **Metadata** tab is gRPC's equivalent of HTTP headers.

- **What it is:** key/value pairs sent alongside the call. Servers read them for things like routing, tracing IDs, tenant selection, or authentication tokens.
- **When to use it:** whenever the server expects extra context with the call — or when you want to hand-type an auth token instead of using the Auth tab.
- **How it works:** it's a table where each row has an **enable checkbox**, a **key**, a **value**, and a **remove** button. A blank row is always waiting at the bottom; start typing and a new one appears. Untick a row to keep it saved but turned off.

Steps:
1. Open the **Metadata** tab.
2. Type a **key** (e.g. `x-tenant-id`) and a **value** (e.g. `acme`).
3. Make sure the row's checkbox is ticked.
4. Add more rows as needed, then **Send**.

> The test rig's `EchoMetadata` method reflects your metadata back to you, which is a handy way to confirm what's being sent.

![The Metadata tab with key/value rows](images/grpc/grpc_metadata.png)

---

## Auth tab

The **Auth** tab is the first-class way to authenticate a gRPC call. It's the same auth editor used for HTTP and GraphQL requests — but for gRPC, whatever you configure is turned into **metadata** and sent with the call.

- **What it is:** a picker for the auth type plus its fields. Supported types include **Bearer Token**, **Basic Auth**, **API Key**, and **JWT Bearer**.
- **When to use it:** whenever the server requires authentication. It's cleaner than hand-typing an `authorization` row on the Metadata tab.
- **How it works:** API Dash formats the credential and adds it as metadata:

| Auth type | Metadata sent |
| --- | --- |
| Bearer Token | `authorization: Bearer <token>` |
| Basic Auth | `authorization: Basic <base64(user:pass)>` |
| API Key (header) | `<name>: <key>` — the name defaults to `x-api-key` |
| JWT Bearer (header) | `authorization: <prefix> <jwt>` |

Steps:
1. Open the **Auth** tab.
2. Choose an auth type and fill in its fields (e.g. paste your token for **Bearer Token**).
3. **Send.** The credential is added as metadata automatically — and it's also sent on Reflect, so it works against secured servers.

> **Auth wins over a manual row.** If you set auth here *and* type an `authorization` row on the Metadata tab, the Auth tab's value takes precedence. Set it in one place to avoid confusion.

> On the test rig, `SecureEcho` requires either `authorization: Bearer test-token` (use **Bearer Token** with `test-token`) or `x-api-key: test-apikey` (use **API Key** with name `x-api-key`).

![The Auth tab set to Bearer Token](images/grpc/grpc_auth.png)

---

## TLS

Open the **Settings** tab to control encryption.

### Use TLS

- **UI label:** **Use TLS**.
- **Default:** off.
- **What it does:** wraps the connection in TLS/SSL so everything between you and the server — metadata, tokens, and message payloads — is encrypted. It does **not** log you in; that's what the Auth tab is for.
- **When to use it:** whenever the server offers a secure endpoint, and always in production. Remember the port usually differs between plaintext and TLS (e.g. `grpcb.in:9000` plaintext vs. `grpcb.in:9001` TLS).

Steps:
1. Open the **Settings** tab.
2. Turn **Use TLS** on.
3. Make sure the address uses the server's **TLS port**, then **Send**.

### Allow Invalid Certificates

- **UI label:** **Allow Invalid Certificates**.
- **Default:** off.
- **What it does:** accepts self-signed or otherwise untrusted server certificates instead of rejecting them, letting you connect to a server whose certificate isn't signed by a trusted certificate authority.
- **When to use it:** only relevant when **Use TLS** is on (the switch is disabled otherwise). Use it for local or testing servers with a self-signed certificate. **Caution:** it disables certificate verification, so the connection is no longer protected against man-in-the-middle attacks — don't use it against production servers.

### Port

The **Settings** tab also has a **Port** field. It mirrors the port in your address; set it here if you prefer, or leave the address as `host:port`. If no port is given anywhere, API Dash uses `50051`.

> **Self-signed / invalid certificates:** to connect to a server with a self-signed or untrusted certificate, turn on **Use TLS** and then **Allow Invalid Certificates**. This skips certificate verification, so use it only for local or testing servers.

![The Settings tab with the Port field and Use TLS switch](images/grpc/grpc_tls.png)

---

## Sending & the response view

Once a method is selected and your message is ready, click **Send**.

**While the call is in flight**, the response pane shows a "sending" animation — the same one HTTP requests use — for every call type.

**Unary and single responses** appear in the standard response view, with the reply body shown as text/JSON. The response's **headers tab is labelled "Metadata"** for gRPC, because that's what a server sends back.

**Streaming responses** (and any call that returns more than one message) appear in a **live log** in the response pane — the same log-style view WebSocket uses:

- Each entry shows a direction icon (**Sent** ↑ / **Received** ↓), a timestamp in `[HH:MM:SS]`, a label, and the payload in a monospace font.
- A **Filter messages…** box narrows the log to entries containing your text.
- Click the **Copy** button on any entry to copy its payload; long payloads are truncated with a **Show more / Show less** toggle.
- The **clear** (trash) button empties the on-screen log.

**Response metadata (initial & trailing).** Servers can send metadata at the start of a response and again at the end. In the streaming log, click the **Metadata** button (info icon) to switch to a metadata view; entries are prefixed **`[Initial]`** or **`[Trailing]`** so you can tell them apart. Click **Back to Stream** to return.

![The response pane showing streamed messages and the Metadata button](images/grpc/grpc_response_stream.png)

### Streaming calls — pushing more messages

For **Client streaming** and **Bidirectional** methods, the request stream stays open after you Send, so you can push several messages:

1. Set the **Type** to **Client streaming** or **Bidirectional**, fill your first message, and click **Send** in the URL bar. This starts the call and sends message #1.
2. Go to the **Body** tab. The **Send message** and **Finish sending** buttons are now active.
3. Edit the params/body and click **Send message** to push another message. Repeat as many times as you like.
4. Click **Finish sending** to half-close the request stream and let the server finish. For **client streaming** you'll get one final response; for **bidirectional** responses arrive interleaved throughout.

> If **Send message** and **Finish sending** are greyed out, there's no open stream — start the call from the URL bar first, and make sure the **Type** is client- or bidirectional-streaming.

![The Body tab with the Send message and Finish sending buttons during a streaming call](images/grpc/grpc_streaming_send.png)

---

## History & persistence

API Dash remembers your gRPC work in two ways.

**Saved requests**

When you save a gRPC request, it keeps:
- the **server address** and **port**,
- the **service**, **method**, and **call Type**,
- your **request message** (form parameters and JSON body),
- your **Metadata** and **Auth**,
- the **TLS** setting and any imported **`.proto`** path.

So you can reopen a saved gRPC request later and call it again without reconfiguring.

**The History tab**

Every time you send a gRPC call, API Dash records it in **History**. You can reopen a past call to review what was sent and received in read-only form, without starting a new one.

> Tip: Combine saved requests with an environment variable in the address (`{{GRPC_HOST}}`) to switch between dev and prod servers in one click.

![The History tab showing a past gRPC call](images/grpc/grpc_history.png)

---

## Troubleshooting & tips

- **Button says "Reflect", not "Send"?** That's expected until you pick a method. Click **Reflect** (or import a `.proto`), choose a service and method, and the button becomes **Send**.
- **Reflect returns nothing?** The server probably has reflection disabled. Check the response log for the exact reason (*"Reflection failed: …"*) and use **Settings → Select .proto → Fetch services** instead.
- **Can't connect over TLS?** Confirm **Use TLS** matches the port (secure servers use a different port from plaintext). If the server has a self-signed or untrusted certificate, also turn on **Allow Invalid Certificates**.
- **Included a scheme in the address?** Don't. gRPC uses `host:port` only — no `http://`, `https://`, or `grpc://`.
- **Auth not working?** Check the Auth tab type and value. If you *also* typed an `authorization` row on the Metadata tab, the Auth tab overrides it — set the token in just one place.
- **Streaming method only sends one message?** Make sure the **Type** is set to **Client streaming** or **Bidirectional**, then use the Body tab's **Send message** / **Finish sending** buttons.
- **Wrong call type?** API Dash doesn't detect it automatically — pick the **Type** that matches the method's definition.
- **Message rejected as malformed?** Check the JSON on the **Body** tab; it's the source of truth for what's sent. The form and JSON stay in sync, but a hand-edited JSON typo will break the send.

---

## FAQ

- **Do I need compiled Protobuf stubs or generated code?**
  - No. API Dash uses reflection or your `.proto` to build the messages dynamically. You write the request as JSON.
- **What's the difference between the Invocation form and the Body tab?**
  - They're two views of the same message. The form gives you typed inputs per field; the Body tab is the raw JSON. The Body JSON is what actually gets sent.
- **How do I authenticate?**
  - Use the **Auth** tab (Bearer / Basic / API-key / JWT). It's turned into metadata automatically. You can also hand-type a token on the **Metadata** tab.
- **Where do I see the server's response metadata?**
  - For single responses, the response "Metadata" tab. For streaming responses, click the **Metadata** button in the log — entries are marked `[Initial]` or `[Trailing]`.
- **Can I connect to a server with a self-signed certificate?**
  - Yes — turn on **Use TLS** and then **Allow Invalid Certificates** on the Settings tab. This skips certificate verification, so use it only for local or testing servers.
- **Will my saved request remember everything?**
  - Yes — address, service, method, Type, message, Metadata, Auth, TLS, and the `.proto` path are all saved.

You're set! Switch a request to gRPC, enter a `host:port`, hit **Reflect** to discover methods, pick one, fill the message, and **Send**.
