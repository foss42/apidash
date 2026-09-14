# API Dash CLI

The API Dash CLI (`apidash`) brings the core of API Dash to your terminal. It
sends HTTP requests and runs your saved requests using **the exact same
networking engine** as the desktop app (`better_networking`), so behaviour
matches what you see in the GUI. It is a **pure-Dart** program with no Flutter
at runtime, which makes it small, fast to start, and easy to drop into scripts,
CI pipelines, and AI agents.

## What it is

- **Send ad-hoc requests** from the command line, no setup required —
  HTTP/REST (`send`), GraphQL (`graphql`) and AI prompts (`ai`).
- **Run requests you saved in the desktop app** — the CLI reads the same
  workspace, so anything you created in the GUI is available by name or id
  (REST, GraphQL and AI requests all route automatically).
- **Stream responses** live with `--stream` (SSE / streaming endpoints).
- **Apply saved environments** with `--env` for `{{key}}` substitution.
- **Two output modes:** a readable, colourised view for humans, and a
  structured `--json` mode for pipes, scripts, and agents.
- **Interactive mode** — run `apidash` with no arguments to browse and run your
  saved requests from a menu, no flags to remember (see
  [Interactive mode (TUI)](#interactive-mode-tui)).

## Install / Build

The CLI lives in `packages/cli`. From the repository root, resolve
dependencies once with the Flutter tool (Flutter is the pub-workspace root):

```bash
flutter pub get
```

Then either run it directly with Dart:

```bash
dart run packages/cli/bin/apidash.dart --help
```

or compile a standalone, dependency-free binary:

```bash
dart compile exe packages/cli/bin/apidash.dart -o packages/cli/apidash
./packages/cli/apidash --help
```

The compiled `apidash` binary can be copied anywhere on your `PATH`.

## Global options

| Option | Description |
| :--- | :--- |
| `--json` | Emit structured JSON instead of the human view. Forces machine output even in a terminal. |
| `-w, --workspace <path>` | Use a specific API Dash data directory (the folder containing `apidash-data.hive`). Defaults to the desktop app's configured workspace. |
| `--env <name\|id>` | Apply a saved environment: `{{key}}` tokens in the url, headers and body are substituted before sending. See [Environments](#env--saved-environments). |
| `-h, --help` | Show usage. |

In command mode the CLI is **non-interactive**: it never prompts. On success it
exits `0`; on failure it prints a clear message and exits non-zero (see
[Exit codes](#exit-codes)). The one exception is the no-argument
[interactive mode (TUI)](#interactive-mode-tui), which is menu-driven.

## Commands

### `send <METHOD> <url>` — ad-hoc request

Builds a request and sends it. No workspace needed.

| Option | Description |
| :--- | :--- |
| `-H "Key: Value"` | Add a header. Repeatable. |
| `-d, --body <data>` | Request body. Content type is auto-detected: valid JSON is sent as `application/json`, anything else as `text/plain` (override with `-H "Content-Type: ..."`). |
| `--stream` | Stream the response, printing each chunk as it arrives. See [Streaming responses](#stream--streaming--sse-responses). |

If you omit the URL scheme, `https://` is assumed (same default as the GUI).

```bash
# GET
apidash send GET https://api.apidash.dev

# POST with a header and a JSON body
apidash send POST https://api.apidash.dev/case/lower \
  -H "Content-Type: application/json" \
  -d '{"text":"HELLO WORLD"}'
```

Human output:

```
Status: 200 OK
Time:   343ms
Size:   22 bytes

{
  "data": "hello world"
}
```

### `graphql <url>` — send a GraphQL query

Sends a GraphQL request through the same engine (as `APIType.graphql`, exactly
like the desktop app: the query is wrapped into `{"query": ...}`).

| Option | Description |
| :--- | :--- |
| `-q, --query "<gql>"` | The GraphQL document. **Required.** Pass `-` to read the query from stdin. |
| `--variables '<json>'` | GraphQL variables as a JSON object. When present, the CLI sends `{"query", "variables"}` as a direct JSON POST (the shared query wrapper is query-only). |
| `-H "Key: Value"` | Add a header (e.g. `Authorization`). Repeatable. |

```bash
# A public GraphQL API
apidash graphql https://countries.trevorblades.com/ \
  --query "{ countries { code name } }"

# With variables
apidash graphql https://countries.trevorblades.com/ \
  --query 'query($c:ID!){ country(code:$c){ name capital } }' \
  --variables '{"c":"IN"}'

# Read the query from stdin
echo '{ countries { code } }' | apidash graphql https://countries.trevorblades.com/ --query -
```

Output uses the same human / `--json` shapes as `send` (status, time, size,
body). The `--env` flag applies to the url, headers and body.

### `ai <prompt>` — ad-hoc AI request

Sends a prompt to an AI provider and prints the **model's answer** (not the raw
provider JSON). It builds the provider's request the same way the desktop app
does and parses the reply with the provider's own formatter.

| Option | Description |
| :--- | :--- |
| `-p, --provider <id>` | Provider: `openai`, `anthropic`, `gemini`, `azureopenai`, `ollama`. **Required.** |
| `--model <name>` | Model name, e.g. `gpt-4o-mini`. **Required.** |
| `-m, --message "<prompt>"` | User prompt. **Required.** Repeatable (lines are joined). |
| `--system "<prompt>"` | Optional system prompt. |
| `--key <apiKey>` | API key. If omitted, falls back to the `<PROVIDER>_API_KEY` env var (e.g. `OPENAI_API_KEY`), then `OPENAI_API_KEY`. `ollama` needs no key. |
| `--url <url>` | Override the provider endpoint URL. |

```bash
export OPENAI_API_KEY=sk-...
apidash ai --provider openai --model gpt-4o-mini \
  -m "Give me a one-line summary of what HTTP is."

# Local Ollama (no key needed)
apidash ai --provider ollama --model llama3 -m "Say hi in one word."
```

Human output prints just the answer text. With `--json`:

```json
{
  "status": 200,
  "timeMs": 1203,
  "provider": "openai",
  "model": "gpt-4o-mini",
  "answer": "HTTP is the protocol browsers and servers use to exchange web data."
}
```

If no API key is available, the CLI fails immediately with a clear message and
a non-zero exit — it never hangs waiting for input. AI requests are sent
non-streaming (the `--stream` flag is for HTTP/SSE responses).

### `run <name|id>` — send a saved request

Loads a request from the workspace (matched by `name` or `id`) and sends it
through the same engine as `send`. It routes by the saved request type:

- **REST** and **GraphQL** requests go through the HTTP engine (GraphQL keeps
  its saved query and is sent as `APIType.graphql`).
- **AI** requests are rebuilt and answered like the [`ai`](#ai-prompt--ad-hoc-ai-request)
  command — the printed output is the model's answer. If the saved request has
  no key, the CLI falls back to the `<PROVIDER>_API_KEY` env var.

| Option | Description |
| :--- | :--- |
| `--stream` | Stream the response live (ignored for AI). See [Streaming responses](#stream--streaming--sse-responses). |

```bash
apidash run "Get current user"
apidash run 076adf90-36ae-11f1-9a98-69fc428529a8
apidash run "My streaming endpoint" --stream
```

If the name/id is not in the workspace, the CLI prints
`Request not found in workspace: <query>` and exits `3`.

### `list` — list saved requests

Lists the requests in the workspace (name, method, url, id).

```bash
apidash list
```

```
GET     Get current user  ->  https://api.apidash.dev/users/me  [a1b2...]
POST    Create order      ->  https://api.apidash.dev/orders    [c3d4...]
```

An empty list (no saved requests, or no desktop workspace yet) is not an error
— it prints a short notice and exits `0`.

### Interactive mode (TUI)

For non-technical use there's an interactive "pick and run" mode — no commands
or flags to memorise. Launch it by running `apidash` **with no arguments** on a
terminal, or explicitly:

```bash
apidash          # no args on a terminal → launches the TUI
apidash tui      # the same, explicitly
```

It reads your saved requests from the workspace and walks you through:

1. **Select a request** — an arrow-key menu of everything you've saved (e.g.
   `GET   Get user   (https://…)`, `[graphql] Search`, `[ai] Summarize`), plus
   a **Quit** entry.
2. It shows the request's details (name, type, method, url, header count) and
   an **Action** menu:
   - **Run** — send it and print the response (status, time, coloured body),
     exactly like [`run`](#run-nameid--send-a-saved-request).
   - **Edit URL / Edit Method / Edit Headers / Edit Body/Params** — tweak the
     request before running it. (For AI requests only Run / Generate curl are
     offered.)
   - **Generate curl** — print an equivalent `curl` command (reflects any edits).
   - **Back** — return to the request list.
3. Repeat until you choose **Quit** (or press `Ctrl+C`).

> **Edits are local and not saved.** The CLI opens the desktop workspace
> **read-only**, so any edits you make in the TUI apply only to that one run and
> are **not written back** to your saved requests (write-back is a future
> feature). Change and keep requests in the API Dash desktop app.

The global `--env` and `--workspace` options apply (e.g.
`apidash --env Prod tui`). The TUI needs a real terminal for keyboard input;
running `apidash` with no arguments in a non-interactive context (a pipe or
script) prints usage and exits `64` instead.

### `--stream` — streaming / SSE responses

`send` and `run` accept `--stream` for endpoints that stream their response
(Server-Sent Events / `text/event-stream`, chunked JSON streams, etc.). Instead
of waiting for the whole body, the CLI prints each chunk **as it arrives** and
returns when the stream closes.

```bash
# Live-tail an SSE endpoint
apidash send GET https://sse.dev/test --stream

# Stream a saved request
apidash run "My streaming endpoint" --stream
```

- **Human mode** writes each chunk's body straight to stdout as it comes in.
- **`--json` mode** emits **JSONL** — one compact JSON object per chunk, one per
  line: `{"streaming":true,"status":200,"timeMs":812,"body":...}`. This is
  friendlier to stream-process than a single giant array (read it line by line).
- A **non-streaming** endpoint used with `--stream` simply yields one chunk with
  the full body, so it still works — you just get one line / one print.
- On a stream error the CLI prints the error and exits `1`.

### `env` — saved environments

Environments hold `{{key}}` variables you can substitute into requests. The CLI
reads the **same** environments you created in the desktop app (read-only).

```bash
# List environments (name, id, variable count)
apidash env list

# Show one environment's variables (by name or id)
apidash env show "Development"
```

Apply an environment to any `send` / `run` / `graphql` call with the global
`--env` flag — `{{key}}` tokens in the url, headers and body are replaced before
the request is sent:

```bash
apidash --env "Development" send GET "{{base_url}}/users/me"
apidash --env prod run "Get current user"
```

Only **enabled, non-secret** variables are substituted (matching the app's
substitution map). Unknown `{{tokens}}` are left untouched. An unknown `--env`
name/id exits `3`.

## Human vs `--json` (agent) output

The default view is meant for a person reading a terminal. For scripts and AI
agents, add `--json` to get a stable, parseable shape.

`send`/`run` with `--json`:

```json
{
  "status": 200,
  "timeMs": 342,
  "headers": { "content-type": "application/json", "server": "cloudflare" },
  "body": { "data": "Check out https://api.apidash.dev/docs to get started." }
}
```

`list` with `--json` is an array:

```json
[
  { "id": "a1b2...", "name": "Get current user", "apiType": "rest",
    "method": "GET", "url": "https://api.apidash.dev/users/me" }
]
```

Notes:
- `body` is the parsed JSON when the response is JSON, otherwise the raw string.
- On failure, `--json` prints `{ "error": "<message>" }`.
- Without `--json`, colour is used only when writing to a real terminal, so
  piped/redirected output stays clean.

## Sharing the desktop workspace

API Dash Desktop stores your collections in a Hive database
(`apidash-data.hive`) inside its workspace folder. The CLI reads that **same**
file, so `list` and `run` see exactly the requests you created in the app.

- The workspace is auto-detected from the desktop app's settings. Override it
  any time with `--workspace <path>`.
- The CLI opens a **temporary read-only copy** of the database, so it works
  even while the desktop app is running and holding the file open. It never
  writes to your workspace.

## Exit codes

| Code | Meaning |
| :--- | :--- |
| `0` | Success. |
| `1` | Network / send error (connection failed, invalid URL, timeout). |
| `2` | Unsupported request (a saved entry with no request model, or an unknown AI provider). |
| `3` | `run`: request name/id not found in the workspace. |
| `64` | Usage error (bad arguments / unknown method). |
| `70` | Unexpected error. |

## Not yet in the CLI

- **WebSocket, gRPC, MQTT** — these transports aren't packaged as a reusable,
  Flutter-free engine yet, so the CLI can't send them. `send`/`run`/`graphql`
  cover HTTP/REST, GraphQL, SSE/streaming and AI.
- **Code generation** (`apidash_core`'s codegen) and **collection import/export**
  (Postman/Insomnia/HAR/OpenAPI) are not wired in yet. They reuse existing
  engine packages and would be added as new subcommands.
