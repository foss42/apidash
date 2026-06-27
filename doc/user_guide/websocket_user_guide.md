# Using WebSockets in API Dash

This guide explains how to use WebSockets in API Dash. WebSockets keep a single connection open so you and a server can send messages back and forth in real time — unlike a normal request, where you ask once and get one answer back.

Use this page when you need a live, two-way connection: chat apps, live price feeds, multiplayer games, notifications, streaming data, or any service that pushes updates to you as they happen.

<!-- screenshot: a WebSocket request connected, with the message log streaming events -->

---

## Quick start

The fastest way to see WebSockets working is to connect to a public "echo" server, which simply repeats back whatever you send it.

1. Create a new request (or open an existing one) and switch its type to **WebSocket** (see "Where to find WebSocket" below).
2. In the URL field, enter:
   ```
   wss://echo.websocket.org
   ```
3. Click **Connect** and wait for the button to turn into a red **Disconnect**.
4. Open the **Message** tab, type any text — for example `Hello!` — and click **Send**.
5. Watch the live log on the right: you'll see your message go out (↑) and the same text come back (↓) from the echo server.

That's the whole loop: connect, send, receive. Everything else in this guide builds on those steps.

<!-- screenshot: echo.websocket.org connected, "Hello!" sent and echoed back -->

---

## Where to find WebSocket

WebSocket is a request **type** in API Dash, just like a regular HTTP request. You switch a request to it rather than opening a separate screen.

1. Create a new request, or select an existing one in the sidebar.
2. Change the request's type to **WebSocket**.
3. The request now shows a teal **WS** badge in the sidebar so you can spot it at a glance.

Once a request is a WebSocket request, the screen changes to match: there is no HTTP method dropdown (GET/POST/etc.), just a URL field and a **Connect** button.

> Tip: The teal **WS** badge is your quick visual cue. If you ever can't tell whether a saved request is a WebSocket, look for that badge in the sidebar.

<!-- screenshot: sidebar showing a request with the teal WS badge -->

---

## WebSockets at a glance

- **One open connection.** Connect once and keep the line open instead of sending separate requests.
- **Two-way messaging.** You can send messages and the server can send messages, at any time, in any order.
- **`ws://` and `wss://` URLs.** Plain or encrypted endpoints (more on this below).
- **No HTTP method.** Just a URL and a Connect/Disconnect button.
- **Four tabs:** Message, Params, Headers, and Settings.
- **A live event log.** Sent and received messages, plus connection events, stream into the response pane as they happen.
- **Reusable message Templates.** Save common payloads (like a login or ping message) and reuse them across sessions.
- **Keep-alive and auto-reconnect options** for connections that need to stay healthy on flaky networks or behind proxies.

Each section below explains what these are, when to use them, and exactly how to use them in API Dash.

---

## The WebSocket request screen

When a request is set to WebSocket, the screen has a few key parts.

**The URL field**

This is where you enter the WebSocket endpoint. It accepts addresses that start with `ws://` or `wss://`, for example:

```
wss://echo.websocket.org
ws://localhost:8080/chat
```

The field shows a hint when empty: *"Enter WebSocket endpoint like wss://echo.websocket.org"*.

You can also use environment variables in the URL, such as `{{WS_URL}}`. API Dash replaces the variable with its value before connecting, which is handy for switching between development and production servers without retyping the address.

**The action button**

There is a single action button next to the URL, and its label tells you the connection state:

**The four tabs**

The request area below the URL has four tabs:

- **Message** — type and send messages, and access saved Templates.
- **Params** — query-string values added to the URL before connecting.
- **Headers** — custom headers sent when the connection is first established.
- **Settings** — advanced options like auto-reconnect and keep-alive pings.

**`ws://` vs `wss://` — which do I use?**

The difference mirrors `http` vs `https`:

| Prefix | Encrypted? | Use it when |
| --- | --- | --- |
| `ws://` | No (plain text) | Local testing, or a server that doesn't support encryption |
| `wss://` | Yes (TLS) | Anything over the public internet, especially with tokens, passwords, or private data |

> Tip: When in doubt, use `wss://`. It's the secure choice and works for almost every public service.

<!-- screenshot: WebSocket request screen with URL field, Connect button, and the four tabs -->

---

## Connecting & disconnecting

Connecting opens the live line to the server. Here's the full flow.

1. Enter your `ws://` or `wss://` URL.
2. (Optional) Set up Params, Headers, and Settings first — these are applied at the moment you connect, so configure them *before* clicking Connect.
3. Click **Connect**. The button changes to **Connecting…** and the response pane shows a connecting spinner while the handshake happens.
4. **On success:** the connection is live, the message log appears, and the button turns into a red **Disconnect**. A "Connected" event is added to the log.
5. **To close the connection:** click **Disconnect**. The connection closes normally and the log records *"Disconnected by user"*.

**If the connection fails**

If the handshake doesn't succeed (wrong URL, server down, blocked by a firewall, etc.), API Dash logs the error with details and the button returns to **Connect** so you can fix the address and try again.

> Tip: Connection details such as Params and Headers only take effect at connect time. If you change them while connected, disconnect and reconnect to apply the new values.

<!-- screenshot: response pane showing a "Connecting…" spinner -->

---

## Params tab

The **Params** tab lets you add query-string values to the URL, which are tacked on before the connection is made.

What this is: extra name/value pairs appended to your URL as `?name=value&name2=value2`. Many servers read these to pick a room, pass a token, set a language, and so on.

When to use it: when the server expects information in the URL itself — for example `?token=abc&room=lobby`.

How it works in API Dash:
- Each row has a **name** and a **value**, plus an **enable checkbox** so you can keep a parameter saved but turned off.
- Use the **add-param** button to add another row.
- Values support environment variables (like `{{TOKEN}}`).
- The parameters are applied at handshake time — i.e., when you click Connect.

Steps:
1. Open the **Params** tab.
2. Click the add-param button to create a row.
3. Enter a **name** (e.g., `room`) and a **value** (e.g., `lobby`).
4. Make sure the row's checkbox is ticked so it's included.
5. Add more rows as needed.
6. Click **Connect**. API Dash appends them to your URL, e.g. `wss://example.com/chat?token=abc&room=lobby`.

> Tip: Untick a parameter's checkbox to temporarily exclude it without deleting it — useful while testing which values a server needs.

<!-- screenshot: Params tab with token and room rows and their enable checkboxes -->

---

## Headers tab

The **Headers** tab lets you send custom HTTP headers when the connection is first established.

What this is: header name/value pairs sent during the WebSocket handshake (the brief HTTP request that opens the connection).

When to use it: when a server checks headers before letting you in — most commonly authentication, like `Authorization: Bearer <token>`, or a custom header such as `X-Custom-Header`.

How it works in API Dash:
- Each row has a **name** and a **value**, plus an **enable checkbox**.
- Use the **add-header** button to add another row.
- Headers are applied at handshake time — i.e., when you click Connect.

Steps:
1. Open the **Headers** tab.
2. Click the add-header button to create a row.
3. Enter a header **name** (e.g., `Authorization`) and **value** (e.g., `Bearer your-token-here`).
4. Make sure the row's checkbox is ticked.
5. Click **Connect**.

> Tip: Some servers don't check headers during the handshake — instead they expect you to authenticate **after** you connect, by sending your credentials in your very first message. If headers aren't working for login, send an auth message instead (see "Sending messages" and "Templates" below).

<!-- screenshot: Headers tab with an Authorization header row -->

---

## Settings tab

The **Settings** tab holds advanced options that help your connection stay healthy. All of these are optional — leave them off if you don't need them.

### Auto Reconnect

- **What it is:** Automatically reconnects when the server closes the connection.
- **When to use it:** On flaky networks, or with servers that drop connections periodically, so you don't have to click Connect again every time.
- **Default:** OFF.
- **What you'll see:** When a live connection drops, API Dash retries automatically and logs each try as a *"Reconnection attempt"*.

Steps:
1. Open the **Settings** tab.
2. Turn the **Auto Reconnect** toggle ON.
3. Connect as usual. If the connection drops, API Dash reconnects on its own.

### WebSocket Heartbeat

- **What it is:** Sends periodic keep-alive "pings" to the server.
- **When to use it:** When something between you and the server — like a load balancer or proxy — tends to kill connections that look idle. The regular pings keep the line looking active.
- **Default:** OFF.
- **Good to know:** These pings happen quietly at the protocol level. They do **not** appear in your message log, so they won't clutter it.

Steps:
1. Open the **Settings** tab.
2. Turn the **WebSocket Heartbeat** toggle ON.
3. (Optional) Adjust the **Ping Interval** below.
4. Connect as usual.

### Ping Interval (seconds)

- **What it is:** How often the keep-alive ping is sent, in seconds.
- **When to use it:** Only relevant when **Heartbeat** is ON. Lower it if connections still drop; raise it to reduce traffic.
- **Default:** 30 seconds.
- **Important:** A change to the interval takes effect on your **next** connect. Changing it while you're already connected has no effect until you disconnect and reconnect.

Steps:
1. Make sure **WebSocket Heartbeat** is ON.
2. Set **Ping Interval (seconds)** to the number of seconds you want (default is 30).
3. Connect (or reconnect, if you changed it mid-session) to apply the new interval.

> Tip: If you don't know what interval to use, start with the default of 30 seconds and only lower it if your connection still gets dropped while idle.

<!-- screenshot: Settings tab with Auto Reconnect, Heartbeat, and Ping Interval -->

---

## Sending messages

You send messages from the **Message** tab. This is the main place you'll work once you're connected.

**The message input**

A large, multi-line input box (shown in a monospace/code font) with the hint *"Enter message to send…"*. You can type plain text or JSON — whatever your server expects.

**The Send button**

- Click **Send** to send the contents of the box as a single text message.
- The input clears after sending, ready for your next message.
- **Send is disabled until you're connected** — connect first, then send.
- Each message you send appears in the log as an outgoing entry, marked with an up arrow (↑).

> Note: Messages are sent as **text** (send JSON or plain text). Sending binary files/frames from the UI is not supported.

Steps:
1. Connect to your server.
2. Open the **Message** tab.
3. Type your message or JSON into the input box.
4. Click **Send**.
5. Check the live log on the right to see it go out (↑), and any reply come back (↓).

### Recently Sent

Just below the input is a **Recently Sent** strip — a horizontal, scrollable list of roughly your last 10 sent messages for this session.

- Click any item to **refill the input** with that message, so you can resend or tweak it.
- This is great for quickly repeating a command without retyping it.

<!-- screenshot: Message tab with the input box, Send button, and Recently Sent strip -->

### Templates

For messages you use over and over — a login payload, a subscribe command, a ping — use **Templates**. Open them with the **Templates** button (it has a bookmark icon).

What templates are: reusable, saved message payloads (typically JSON). API Dash ships with a few defaults to get you started, such as **Ping Message**, **Auth Message**, and **Binance BTC**. Your own templates are saved and stay available across sessions.

What you can do with templates:
- **Search** the list to find a template quickly.
- **Use** a template to load its payload into the message input.
- **Create a new template:** choose **Create New Template**, then fill in a **Template Name** and a **JSON Payload** in the dialog.
- **Edit** or **delete** an existing template.
- **Save as template:** store whatever is currently in your message input as a new reusable template.

Steps to create and use a template:
1. Click the **Templates** button (bookmark icon).
2. Choose **Create New Template**.
3. Enter a **Template Name** (e.g., `Login`) and your **JSON Payload**.
4. Save it. It now appears in your templates list.
5. Later, open Templates, pick it from the list to load it into the input, adjust if needed, and click **Send**.

> Tip: Templates are perfect for servers that authenticate **after** connecting — save your login/auth message as a template and send it as your first message every time you connect.

<!-- screenshot: Templates dialog showing default templates and the Create New Template option -->

---

## Receiving messages — the live log

Everything that happens on the connection appears in the **live message log** in the response pane. It's a full-height, auto-scrolling list with the **oldest at the top and newest at the bottom**, so the latest activity is always in view.

Before you connect, the log shows an empty state: *"No messages yet. Connect to start."*

**What each entry shows**

Every line in the log has a small icon (its direction or type), a timestamp in `[HH:MM:SS]` format, and the message payload. The payload text is selectable and shown in a monospace font.


**Automatic system events**

You don't have to log connection activity yourself — API Dash does it for you. The log automatically records events like: connected, each message sent, each message received, *"Connection failed"* (with details), *"Disconnected by user"*, *"Reconnection attempt"*, and when the connection closes.

**Long messages — expand/collapse**

If a payload is very long (more than ~300 characters), it's truncated to keep the log tidy, with a **Show More / Show Less** toggle so you can expand or collapse the full text on demand.

**Copying a message**

Click any entry to copy its payload to your clipboard. A *"Copied to clipboard"* confirmation appears.

**Filtering the log**

Use the **Filter messages…** box to show only entries whose payload contains your search text. The filter is case-insensitive, and a clear (✕) button appears while a filter is active so you can reset it quickly.

**Clearing the log**

Click the clear-messages button (trash icon) to empty the log entirely. This just clears the on-screen view — it doesn't disconnect you.

**Max Log Messages**

The log caps how many messages it displays — by default the most recent **1000**. This keeps high-volume streams from slowing things down. If you need to keep more on screen, increase **Max Log Messages** in the app settings.

Steps to find a specific message in a busy log:
1. Type part of the message into the **Filter messages…** box.
2. Review the filtered results (oldest at top, newest at bottom).
3. Click an entry to copy its full payload.
4. Click the clear (✕) on the filter to return to the full log.

<!-- screenshot: live log with sent/received entries, timestamps, icons, and the filter box -->

---

## History & persistence

API Dash remembers your WebSocket work in two ways.

**Saved requests**

When you save a WebSocket request, it keeps:
- the **URL**,
- the **Headers** and **Params** you set up,
- and your **Settings** (the heartbeat and auto-reconnect options).

So you can reopen a saved WebSocket request later and connect again without reconfiguring it.

**The History tab**

The **History** tab lets you reopen a past WebSocket session and review its message log in **read-only** form. This is useful for going back over what was sent and received during an earlier session without starting a new connection.

> Tip: Save the requests you connect to often. Combined with environment variables in the URL (`{{WS_URL}}`), you can switch between servers in one click.

<!-- screenshot: History tab showing a past WebSocket session's read-only log -->

---

## Troubleshooting & tips

- **Use `wss://` for secure endpoints.** For anything over the public internet — especially with tokens or passwords — prefer the encrypted `wss://` form over plain `ws://`.
- **Connection keeps dropping while idle?** A proxy or load balancer may be closing connections that look inactive. Turn on **WebSocket Heartbeat** in the Settings tab to send keep-alive pings.
- **Server needs auth after connecting?** Some servers ignore handshake headers and expect credentials in your first message instead. Send an auth/login message right after connecting — saving it as a **Template** makes this one click.
- **On a flaky network?** Turn on **Auto Reconnect** so API Dash retries automatically when the connection drops.
- **Changed the Ping Interval but nothing happened?** Interval changes apply on the **next** connect. Disconnect and reconnect to apply them.
- **High-volume stream getting cut off?** The log shows the most recent 1000 messages by default. Increase **Max Log Messages** in app settings to keep more on screen.
- **Send button greyed out?** You're not connected yet. Click **Connect** first — Send only works on a live connection.
- **Can't connect at all?** Double-check the URL (right prefix, correct host/port), confirm the server is running, and check whether your network or firewall blocks WebSocket traffic. Failed handshakes are logged with details to help you pinpoint the issue.
- **Headers not authenticating you?** Confirm whether the server expects credentials at handshake time (Headers tab) or after connecting (first message/Template).

---

## FAQ

- **Can I send binary data (files, images) over the connection?**
  - No. Messages are sent as text frames. You can send plain text or JSON; binary frames aren't sent from the UI.
- **Do keep-alive pings show up in my message log?**
  - No. Heartbeat pings happen quietly at the protocol level and are kept out of the log.
- **Will my saved request remember the heartbeat and reconnect settings?**
  - Yes. Saved WebSocket requests keep their URL, Headers, Params, and Settings.
- **Can I use environment variables in the WebSocket URL?**
  - Yes. Use a variable like `{{WS_URL}}` and API Dash substitutes its value before connecting.
- **How do I resend a message I sent earlier?**
  - Use the **Recently Sent** strip (click an item to refill the input) or save the message as a **Template**.

You're set! Switch a request to WebSocket, enter your `ws://` or `wss://` URL, click Connect, and start sending and receiving messages in real time.
