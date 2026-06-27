# Using MQTT in API Dash

This guide explains how to connect to an MQTT broker, subscribe to topics, and publish messages in API Dash. We'll start from zero and walk through every option in plain language with step-by-step instructions, examples, and tips.

Use this page when you want to test or interact with an MQTT broker — for example IoT devices, sensors, or any real-time publish/subscribe messaging system — instead of sending one-off HTTP requests.

> MQTT is different from HTTP. Instead of sending a request and waiting for a single response, you open a long-lived connection to a **broker**, **subscribe** to topics you care about, and **publish** messages to topics. Messages flow in both directions and appear live as they arrive.

<!-- screenshot: MQTT request open with the Connect button, version selector, and tabs visible -->

---

## Where to find MQTT

1. Create a new request (or open an existing one).
2. Find the request type / protocol selector (the same switcher you use to pick HTTP, GraphQL, or AI) and choose **MQTT**.
3. The request now switches into MQTT mode:
   - The **URL field becomes the Broker URL** (it shows a `mqtt://...` placeholder).
   - Where the HTTP method dropdown normally sits, you'll now see an **MQTT Version** selector.
   - The blue action button reads **Connect** instead of **Send**.

Once you're in MQTT mode, everything you need lives in the request tabs (**Message**, **Topics**, **Properties**, **Auth**, **Settings**) and the live message log in the response pane.

---

## MQTT at a glance

- **Broker URL** — the address of the MQTT broker you connect to.
- **MQTT Version** — choose **MQTT 3.1.1** or **MQTT 5.0** (default: MQTT 5.0).
- **Connect / Disconnect** — open or close the connection.
- **Topics tab** — the list of topics you want to subscribe to (receive messages from).
- **Message tab** — type and publish a message to a topic.
- **Properties tab** — custom key/value metadata (MQTT 5.0 only).
- **Auth tab** — username and password for the broker.
- **Settings tab** — port, Client ID, Keep Alive, QoS, TLS, WebSocket, Last Will, and session options.
- **Message log** — the live event stream in the response pane, showing every message sent and received.

Each section below explains what an option is, when to use it, and exactly how to fill it in.

---

## Quick start

This is the fastest way to see MQTT working end to end using a free public broker.

1. Create a new request and set its type to **MQTT**.
2. In the **Broker URL** field, enter a public test broker, for example `broker.hivemq.com` or `broker.emqx.io`.
3. Click **Connect** (or press **Enter** in the Broker URL field). The button changes to **Disconnect** and the status dot in the log turns green.
4. Go to the **Topics** tab and add a topic filter, for example `apidash/test/hello`. Tick its checkbox so it's enabled.
5. Go to the **Message** tab. In **Send to topic:**, enter the same topic (`apidash/test/hello`), type a message in the payload box (for example `Hello MQTT`), and click **Publish**.
6. Watch the **message log** in the response pane. You'll see your message echoed as a sent entry, and because you're subscribed to that topic, you'll also see it arrive back as a received message.
7. When you're done, click **Disconnect**.

> Tip: Publishing to a topic you're also subscribed to is the easiest way to confirm the whole round trip works. Once that succeeds, you know your connection, subscription, and publishing are all healthy.

---

## Choosing your MQTT version

The **MQTT Version** selector sits where the HTTP method dropdown normally appears (right next to the Broker URL).

- **MQTT 3.1.1** — the most widely deployed version. Use it if your broker or devices only support 3.1.1, or if you want the simplest setup.
- **MQTT 5.0** — the newer version with extra features: user properties, request/response metadata, detailed reason codes, and fine-grained session control. **This is the default.**

When you switch versions, API Dash shows or hides the version-specific options automatically (this is called progressive disclosure — you only see what applies to your chosen version). Specifically, the **Properties** tab and several MQTT 5.0 fields appear only when you select MQTT 5.0.

> If you're not sure which to pick, start with the default (MQTT 5.0). Most modern public brokers support it. If you hit trouble connecting, switch to MQTT 3.1.1.

---

## Connecting to a broker

### Broker URL

- **What it is:** the hostname or IP address of the MQTT broker.
- **When to use it:** always — it's how API Dash knows where to connect.
- **UI label:** the main URL field (placeholder `mqtt://...`).

Steps:
1. Make sure the request type is **MQTT**.
2. Type the broker address into the URL field (for example `broker.hivemq.com`).
3. Click **Connect**, or simply press **Enter** while your cursor is in the field.

<!-- screenshot: Broker URL field with Connect button -->

### Connect and Disconnect

- The action button reads **Connect** when you're disconnected.
- While connecting, the status shows a **connecting** state.
- Once connected, the button changes to **Disconnect** and the status dot turns **green**.
- Click **Disconnect** at any time to close the connection.

When you connect, API Dash automatically subscribes to all the enabled topics in your **Topics** tab, so you start receiving messages right away.

---

## Connection settings

Open the **Settings** tab to fine-tune how API Dash connects. Sensible defaults are filled in, so for most public brokers you can connect without changing anything here.

| Setting | UI label | Default | What it does |
|---|---|---|---|
| Port | Port | 1883 | The network port on the broker to connect to. |
| Client ID | Client ID | auto-generated | A unique name identifying your client to the broker. |
| Keep Alive | Keep Alive (s) | 60 | Seconds between heartbeat pings that keep the connection alive. |
| Default QoS | Default QoS | 0 | The delivery guarantee used for all your subscribes and publishes. |

### Port

- **What it is:** the broker's network port.
- **Default:** `1883` (the standard plain-text MQTT port).
- **Auto-remapping:** when you turn on certain options, API Dash automatically updates the port for you so it matches the transport you chose:

| You enable… | Port becomes |
|---|---|
| Use TLS | 8883 |
| Use WebSocket | 8083 |
| Use TLS **and** WebSocket | 8084 |

> You can always override the port manually if your broker uses a non-standard one.

### Client ID

- **What it is:** a unique identifier for your connection. Brokers use it to track your session.
- **When to set it:** leave it blank and API Dash generates one for you automatically (something like `apidash_` followed by a timestamp). Set your own only if your broker requires a specific Client ID, or if you want to resume a session later.

### Keep Alive (s)

- **What it is:** how often (in seconds) API Dash sends a small heartbeat ping so the broker knows you're still there.
- **Default:** `60`. Lower it for flaky networks; raise it to reduce traffic on stable ones.

### Default QoS

QoS (Quality of Service) controls the delivery guarantee for your messages. The **Default QoS** dropdown applies to both the topics you subscribe to and the messages you publish.

| QoS | Name | Meaning |
|---|---|---|
| 0 | At most once | Fire and forget. Fastest, but a message may be lost. **(Default)** |
| 1 | At least once | The broker acknowledges delivery. A message may arrive more than once. |
| 2 | Exactly once | A full handshake guarantees the message arrives exactly once. Slowest. |

> For interactive testing, QoS 0 is usually fine. Use QoS 1 or 2 only when you specifically need delivery guarantees.

---

## Authentication

Open the **Auth** tab to send a username and password to the broker.

- **What it is:** credentials some brokers require before they'll accept your connection.
- **When to use it:** only if your broker is protected. Leave both fields blank for anonymous (open) brokers like the public test brokers.
- **UI labels:** **Username** and **Password** (the password is masked as you type).

Steps:
1. Open the **Auth** tab.
2. Enter your **Username** and **Password**.
3. Connect as usual.

<!-- screenshot: Auth tab with Username and Password fields -->

> Most public test brokers don't require credentials, so you can skip this tab when getting started.

---

## Transport & Security

In the **Settings** tab, expand the **Transport & Security** section to control how the connection is encrypted and tunneled.

### Use TLS

- **UI label:** **Use TLS** — "Encrypt the connection (TLS/SSL)".
- **Default:** off.
- **What it does:** encrypts the connection between you and the broker.
- **When to use it:** whenever your broker offers a secure endpoint, and always in production.

Turning this on automatically bumps the port from `1883` to `8883` (the standard secure MQTT port).

### Allow Invalid Certificates

- **UI label:** **Allow Invalid Certificates** — "Accept self-signed / untrusted certs".
- **Default:** off.
- **Visibility:** this toggle only appears when **Use TLS** is on (it has no meaning otherwise).
- **What it does:** tells API Dash to trust the broker even if its certificate is self-signed or not issued by a recognized authority.
- **When to use it:** for test brokers that use self-signed certificates — a common example is `test.mosquitto.org` on its secure port.

> Warning: Only enable this for testing. Accepting invalid certificates removes a key security protection, so never use it against a production broker.

### Use WebSocket

- **UI label:** **Use WebSocket**.
- **Default:** off.
- **What it does:** tunnels the MQTT connection over a WebSocket transport instead of a raw TCP connection.
- **When to use it:** when your broker only exposes a WebSocket endpoint, or when a firewall blocks raw MQTT ports.

Turning this on automatically adjusts the port to `8083` (or `8084` if TLS is also on).

---

## Last Will & Testament (LWT)

In the **Settings** tab, expand the **Last Will & Testament (LWT)** section.

- **What it is:** a message you register up front that the broker will publish **on your behalf** if your client disconnects unexpectedly (for example, the network drops or the app crashes).
- **When to use it:** to let other clients know when your client goes offline ungracefully — for example, publishing an "offline" status to a topic other devices watch.

 Will | Retain Will | off | If on, the broker keeps the will message as the last message on the topic for future subscribers. |

Steps:
1. Open the **Settings** tab and expand **Last Will & Testament (LWT)**.
2. Enter a **Will Topic** (for example `clients/myclient/status`).
3. Enter a **Will Message** (for example `offline`).
4. Optionally raise **Will QoS** or turn on **Retain Will**.
5. Connect. The broker now holds your will and publishes it automatically if you drop unexpectedly.

<!-- screenshot: Last Will & Testament section expanded -->

---

## Session control (Clean Start & Session Expiry)

How API Dash handles your session depends on the MQTT version you chose.

### MQTT 3.1.1

There's nothing to configure. API Dash connects with a clean session every time, meaning the broker doesn't keep any state for you between connections.

### MQTT 5.0

In the **Settings** tab you'll see a **Clean Start** toggle.

- **UI label:** **Clean Start** — "Session ends on disconnect".
- **Default:** on.
- **What it does (when on):** your session is discarded the moment you disconnect — a fresh start every time.

If you turn **Clean Start off**, a new field appears:

- **UI label:** **Session Expiry (s)**.
- **Default:** `3600` (one hour).
- **What it does:** tells the broker how many seconds to keep your session (including your subscriptions and any queued messages) after you disconnect, so you can reconnect and resume where you left off.

> To resume a session later, turn **Clean Start off**, set a **Session Expiry** long enough for your needs, and reconnect with the **same Client ID**.

---

## Subscribing to topics

Open the **Topics** tab to choose which topics you want to receive messages from. This is a table where each row is one topic filter.

Each row has:
- An **enable/disable checkbox** — tick it to subscribe, untick it to unsubscribe.
- A **Topic filter** text field — the topic (or wildcard pattern) you want to listen to.
- A **remove button** — deletes the row.

Adding rows:
- Start typing in the empty last row and a new blank row appears automatically.
- Or click **Add Topic** to add a row manually.

Steps:
1. Open the **Topics** tab.
2. Type a topic into a row, for example `home/living-room/temperature`.
3. Make sure the row's checkbox is ticked.
4. Repeat for as many topics as you like.

<!-- screenshot: Topics tab table with enabled topic rows -->

### Wildcards

Topic filters support MQTT wildcards so you can match many topics at once:

| Wildcard | Meaning | Example | Matches |
|---|---|---|---|
| `+` | Single level | `home/+/temperature` | `home/living-room/temperature`, `home/bedroom/temperature` |
| `#` | Multi level (must be last) | `sensors/#` | `sensors/temp`, `sensors/humidity/outdoor`, and everything below `sensors/` |

> Wildcards work only in subscriptions (the Topics tab), never when publishing. When you publish, you must use a full, specific topic.

### Live subscription behavior

The Topics tab reacts immediately while you're connected:

- **Tick a topic** → API Dash subscribes to it right away.
- **Untick a topic** → API Dash unsubscribes immediately.
- **Edit a topic** → API Dash resubscribes with the new filter.

If you're **not** connected, your topics are simply remembered and subscribed automatically the next time you **Connect**.

All subscriptions use the **Default QoS** from the Settings tab.

---

## Publishing a message

Open the **Message** tab to send a message to a topic.

Fields:
- **Send to topic:** — the full topic you're publishing to. As you type, API Dash suggests topics you're already subscribed to (a convenience only; you can type any topic).
- **Message payload** — a multiline text box for the message body.
- **Retain** toggle — if on, the broker stores this message as the last message on the topic, so future subscribers receive it immediately when they subscribe.
- **Publish** button — sends the message.

Steps:
1. Open the **Message** tab.
2. Enter a topic in **Send to topic:** (for example `apidash/test/hello`).
3. Type your message in the payload box.
4. Optionally turn on **Retain**.
5. Click **Publish**.

<!-- screenshot: Message tab with Send to topic, payload box, Retain toggle, and Publish button -->

> The **Publish** button is enabled only when you are **connected** and have entered a topic. If it's greyed out, check that you've connected and typed a topic.

Every message you publish is echoed into the message log as a **sent** entry, showing the payload and topic, so you have a record of what you sent.

---

## MQTT 5.0 extras

These options appear only when the **MQTT Version** is set to **MQTT 5.0**.

### User Properties

Open the **Properties** tab (visible only for MQTT 5.0).

- **What it is:** custom key/value metadata pairs, similar to HTTP headers, attached to your connection and to the messages you publish.
- **When to use it:** to send extra context — like a trace ID, a source name, or routing hints — without putting it inside the message body.
- **UI:** a table where each row has an **enable checkbox**, a **Key** field, a **Value** field, and a **remove** button.

Steps:
1. Switch the MQTT Version to **MQTT 5.0**.
2. Open the **Properties** tab.
3. Add a row, enter a **Key** and **Value** (for example `trace-id` → `abc-123`).
4. Make sure the row's checkbox is ticked.
5. Connect and/or publish — the enabled properties are sent along.

<!-- screenshot: Properties tab with User Properties key/value rows -->

> Only rows that are **enabled** and have a **non-empty key** are actually sent. Blank or unticked rows are ignored.

### Request / Response & Expiry

In the **Message** tab, expand the collapsible section titled **Request / Response & Expiry (v5)**.

> Use **Response Topic** and **Correlation Data** together when you want a request/response style exchange: publish a request that tells the responder where to reply and includes a token, then match the incoming reply by that same token.

### Reason codes

With MQTT 5.0, the broker returns detailed diagnostic **reason codes** for connection and subscription events. API Dash surfaces these in the message log, so after you connect, subscribe, or disconnect you'll see entries such as a successful CONNACK, a SUBACK granting QoS 1, or a normal-disconnection DISCONNECT. These are a big help when debugging why a broker rejected a connection or subscription.

---

## The message log

The response pane shows a **live event stream** — a running log of everything that happens on the connection.

What you'll see:
- **Connection events** — for example "Connected to broker", per-topic "Subscribed to topic: …", and "Disconnected from broker".
- **Every message sent and received**, each with a **direction icon** (so you can tell sent from received), a **timestamp** in `HH:MM:SS` format, and the **payload**.
- **Received messages** also show a **`Topic: <topic>`** badge so you know which topic they arrived on.

Things you can do in the log:

- **Copy a payload** — tap any message to copy its payload to your clipboard. You'll see a "Copied to clipboard" confirmation.
- **Expand long messages** — messages longer than 300 characters are shortened, with an expand toggle to see the full text.
- **Search** — use the search box to filter messages by payload text (case-insensitive).
- **Filter by topic** — add topic filters as chips (press **Enter** to add each one) to narrow the log to specific topics. These filters support wildcards, just like subscriptions.
- **Clear the log** — click the red **✕** button to empty the log.

> The log holds up to a maximum number of events, controlled by the **Max Log Messages** app setting. Older entries are dropped once you reach the limit, which keeps memory usage in check during high-volume streams.

---

## Connection lifecycle at a glance

API Dash shows your connection status with a colored dot and the action button label:

Typical log entries you'll see:
- On connect: **"Connected to broker: \<url\>"** followed by **"Subscribed to topic: …"** for each enabled topic.
- On disconnect: **"Disconnected from broker"**.
- On failure: **"Connection failed: \<error\>"** with the reason.

Click **Disconnect** whenever you want to close the connection.

---

## Public test brokers

These free brokers are handy for trying things out without setting up your own. None of them require a username or password for the plain (non-TLS) ports.

| Broker | Address | Plain port | TLS port | Notes |
|---|---|---|---|---|
| HiveMQ | `broker.hivemq.com` | 1883 | 8883 | Open public broker. |
| EMQX | `broker.emqx.io` | 1883 | 8883 | Supports MQTT 5.0. |
| Mosquitto | `test.mosquitto.org` | 1883 | 8883 | The TLS port uses a self-signed certificate — enable **Allow Invalid Certificates**. |

> These are shared public brokers used by many people. Don't publish anything sensitive to them, and expect to see other people's traffic if you subscribe to broad wildcards like `#`.

---

## Troubleshooting & tips

- **Can't connect?** Check that the **Port** matches your transport. If you turned on **Use TLS**, the port should be the secure one (usually 8883); for plain connections use 1883. API Dash auto-remaps the port for you when you toggle TLS or WebSocket, but a manually entered port can get out of sync.
- **TLS connection fails with a certificate error?** If you're using a test broker with a self-signed certificate (like `test.mosquitto.org` on its secure port), turn on **Allow Invalid Certificates** under Transport & Security. Don't use this in production.
- **Connected but not receiving messages?** Confirm the topic in your **Topics** tab is enabled (checkbox ticked) and matches what's being published. Double-check your wildcards (`+` matches one level, `#` matches everything below). Also verify the publisher and your subscription are using a compatible QoS.
- **Publish button greyed out?** You must be **connected** and have a topic typed in **Send to topic:** before you can publish.
- **Want to resume a session after disconnecting (MQTT 5.0)?** Turn **Clean Start off**, set a **Session Expiry** long enough to cover your downtime, and reconnect with the **same Client ID**.
- **Broker rejected your connection (MQTT 5.0)?** Read the **reason code** in the message log — it usually tells you exactly why (bad credentials, not authorized, etc.).
- **Log filling up too fast?** Use the **search box** or add **topic filter chips** to focus on what matters, and use the **clear (✕)** button to reset. If you regularly handle high-volume streams, adjust **Max Log Messages** in the app settings.

---

You're set! Pick MQTT, enter a broker, Connect, subscribe in the Topics tab, publish in the Message tab, and watch your messages flow through the live log.
