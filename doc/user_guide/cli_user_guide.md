# API Dash CLI

The API Dash CLI (`apidash`) brings the core of API Dash to your terminal. It
sends HTTP requests and runs your saved requests using **the exact same
networking engine** as the desktop app (`better_networking`), so behaviour
matches what you see in the GUI. It is a **pure-Dart** program with no Flutter
at runtime, which makes it small, fast to start, and easy to drop into scripts,
CI pipelines, and AI agents.

## What it is

- **Send ad-hoc requests** from the command line, no setup required.
- **Run requests you saved in the desktop app** — the CLI reads the same
  workspace, so anything you created in the GUI is available by name or id.
- **Two output modes:** a readable, colourised view for humans, and a
  structured `--json` mode for pipes, scripts, and agents.

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
| `-h, --help` | Show usage. |

The CLI is **non-interactive**: it never prompts. On success it exits `0`; on
failure it prints a clear message and exits non-zero (see [Exit codes](#exit-codes)).

## Commands

### `send <METHOD> <url>` — ad-hoc request

Builds a request and sends it. No workspace needed.

| Option | Description |
| :--- | :--- |
| `-H "Key: Value"` | Add a header. Repeatable. |
| `-d, --body <data>` | Request body. Content type is auto-detected: valid JSON is sent as `application/json`, anything else as `text/plain` (override with `-H "Content-Type: ..."`). |

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

### `run <name|id>` — send a saved request

Loads a request from the workspace (matched by `name` or `id`) and sends it
through the same engine as `send`.

```bash
apidash run "Get current user"
apidash run 076adf90-36ae-11f1-9a98-69fc428529a8
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
| `2` | Unsupported request (e.g. an AI request, or a saved entry with no HTTP model). |
| `3` | `run`: request name/id not found in the workspace. |
| `64` | Usage error (bad arguments / unknown method). |
| `70` | Unexpected error. |

## Not yet in the CLI

Code generation (`apidash_core`'s codegen) and collection import/export
(Postman/Insomnia/HAR/OpenAPI, also in `apidash_core`) are not wired into the
CLI yet. They reuse existing engine packages and would be added as new
subcommands.
